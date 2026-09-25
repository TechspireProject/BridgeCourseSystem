using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI.WebControls;

namespace BridgePrep
{
    public partial class TakeQuiz : System.Web.UI.Page
    {
        private int QuizId
        {
            get
            {
                return Request.QueryString["QuizId"] != null ? Convert.ToInt32(Request.QueryString["QuizId"]) : 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 3)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (QuizId == 0)
            {
                Response.Redirect("SelectQuiz.aspx");
                return;
            }

            EnsureScoresTableExists();

            if (!IsPostBack)
            {
                LoadQuizHeader();
                LoadQuestions();
            }
        }

        private void EnsureScoresTableExists()
        {
            try
            {
                string tableCheckQuery = @"
                    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Scores')
                    BEGIN
                        CREATE TABLE [dbo].[Scores] (
                            [ScoreId]    INT     IDENTITY (1, 1) NOT NULL PRIMARY KEY,
                            [StudentId]  INT     NOT NULL,
                            [QuizId]     INT     NOT NULL,
                            [Score]      INT     NOT NULL,
                            [TotalMarks] INT     NOT NULL,
                            [TakenAt]    DATETIME DEFAULT (GETDATE()) NULL
                        );
                    END";
                DbHelper.ExecuteNonQuery(tableCheckQuery, null);
            }
            catch (Exception ex)
            {
                lblNoQuestions.Text = "Database Warning: " + ex.Message;
                lblNoQuestions.Visible = true;
            }
        }

        private void LoadQuizHeader()
        {
            try
            {
                string query = "SELECT QuizTitle FROM Quizzes WHERE QuizId = @QuizId";
                SqlParameter[] p = { new SqlParameter("@QuizId", QuizId) };
                DataTable dt = DbHelper.ExecuteQuery(query, p);

                if (dt != null && dt.Rows.Count > 0)
                {
                    lblQuizTitle.Text = dt.Rows[0]["QuizTitle"].ToString();
                }
            }
            catch (Exception ex)
            {
                lblNoQuestions.Text = "Error loading title: " + ex.Message;
                lblNoQuestions.Visible = true;
            }
        }

        private void LoadQuestions()
        {
            try
            {
                string query = @"SELECT QuestionId, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption 
                                FROM Questions 
                                WHERE QuizId = @QuizId 
                                ORDER BY NEWID()";

                SqlParameter[] p = { new SqlParameter("@QuizId", QuizId) };
                DataTable dt = DbHelper.ExecuteQuery(query, p);

                if (dt != null && dt.Rows.Count > 0)
                {
                    rptQuestions.DataSource = dt;
                    rptQuestions.DataBind();
                    lblTotalQuestionCount.Text = dt.Rows.Count.ToString();
                    lblNoQuestions.Visible = false;
                    btnSubmitQuiz.Visible = true;
                }
                else
                {
                    lblNoQuestions.Text = "No questions have been added to this quiz yet.";
                    lblNoQuestions.Visible = true;
                    btnSubmitQuiz.Visible = false;
                }
            }
            catch (Exception ex)
            {
                lblNoQuestions.Text = "Error loading quiz questions: " + ex.Message;
                lblNoQuestions.Visible = true;
            }
        }

        protected void rptQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView row = (DataRowView)e.Item.DataItem;
                string questionId = row["QuestionId"].ToString();

                var optionsList = new List<QuizOptionViewModel>
                {
                    new QuizOptionViewModel { QuestionId = questionId, Text = row["OptionA"].ToString(), Value = "A", IsDisabled = false, IsSelected = false },
                    new QuizOptionViewModel { QuestionId = questionId, Text = row["OptionB"].ToString(), Value = "B", IsDisabled = false, IsSelected = false },
                    new QuizOptionViewModel { QuestionId = questionId, Text = row["OptionC"].ToString(), Value = "C", IsDisabled = false, IsSelected = false },
                    new QuizOptionViewModel { QuestionId = questionId, Text = row["OptionD"].ToString(), Value = "D", IsDisabled = false, IsSelected = false }
                };

                var randomizedOptions = optionsList.OrderBy(x => Guid.NewGuid()).ToList();

                Repeater rptOptions = (Repeater)e.Item.FindControl("rptOptions");
                if (rptOptions != null)
                {
                    rptOptions.DataSource = randomizedOptions;
                    rptOptions.DataBind();
                }
            }
        }

        public class QuizOptionViewModel
        {
            public string QuestionId { get; set; }
            public string Text { get; set; }
            public string Value { get; set; }
            public bool IsSelected { get; set; }
            public bool IsDisabled { get; set; }
            public string CssClass { get; set; } = "";
            public string IconHtml { get; set; } = "";
        }

        protected void btnSubmitQuiz_Click(object sender, EventArgs e)
        {
            try
            {
                string query = "SELECT QuestionId, OptionA, OptionB, OptionC, OptionD, CorrectOption FROM Questions WHERE QuizId = @QuizId";
                SqlParameter[] qParams = { new SqlParameter("@QuizId", QuizId) };
                DataTable dtQuestions = DbHelper.ExecuteQuery(query, qParams);

                if (dtQuestions == null || dtQuestions.Rows.Count == 0)
                {
                    lblNoQuestions.Text = "Could not locate quiz questions to grade.";
                    lblNoQuestions.Visible = true;
                    return;
                }

                var questionDict = dtQuestions.AsEnumerable().ToDictionary(
                    row => row["QuestionId"].ToString(),
                    row => row
                );

                int correctAnswersCount = 0;
                int totalQuestionsCount = rptQuestions.Items.Count;

                foreach (RepeaterItem item in rptQuestions.Items)
                {
                    if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                    {
                        HiddenField hfQuestionId = (HiddenField)item.FindControl("hfQuestionId");
                        Repeater rptOptions = (Repeater)item.FindControl("rptOptions");

                        if (hfQuestionId != null && rptOptions != null)
                        {
                            string questionId = hfQuestionId.Value;
                            if (questionDict.ContainsKey(questionId))
                            {
                                DataRow qRow = questionDict[questionId];
                                string correctOpt = qRow["CorrectOption"].ToString().Trim();
                                string selectedOpt = Request.Form["q_" + questionId];

                                var rawOptions = new[]
                                {
                                    new { Text = qRow["OptionA"].ToString(), Val = "A" },
                                    new { Text = qRow["OptionB"].ToString(), Val = "B" },
                                    new { Text = qRow["OptionC"].ToString(), Val = "C" },
                                    new { Text = qRow["OptionD"].ToString(), Val = "D" }
                                };

                                var evaluatedOptions = new List<QuizOptionViewModel>();

                                foreach (var opt in rawOptions)
                                {
                                    bool isSelected = (selectedOpt != null && selectedOpt.Equals(opt.Val, StringComparison.OrdinalIgnoreCase));
                                    var vm = new QuizOptionViewModel
                                    {
                                        QuestionId = questionId,
                                        Text = opt.Text,
                                        Value = opt.Val,
                                        IsDisabled = true,
                                        IsSelected = isSelected
                                    };

                                    if (opt.Val.Equals(correctOpt, StringComparison.OrdinalIgnoreCase))
                                    {
                                        vm.CssClass = "correct-box";
                                        vm.IconHtml = "<i class='fa-solid fa-check text-success fs-5 ms-2'></i>";
                                    }
                                    else if (isSelected && !opt.Val.Equals(correctOpt, StringComparison.OrdinalIgnoreCase))
                                    {
                                        vm.CssClass = "wrong-box";
                                        vm.IconHtml = "<i class='fa-solid fa-xmark text-danger fs-5 ms-2'></i>";
                                    }

                                    evaluatedOptions.Add(vm);
                                }

                                rptOptions.DataSource = evaluatedOptions;
                                rptOptions.DataBind();

                                if (!string.IsNullOrEmpty(selectedOpt) && selectedOpt.Equals(correctOpt, StringComparison.OrdinalIgnoreCase))
                                {
                                    correctAnswersCount++;
                                }
                            }
                        }
                    }
                }

                int studentId = Convert.ToInt32(Session["UserId"]);

                string insertQuery = @"INSERT INTO Scores (StudentId, QuizId, Score, TotalMarks, TakenAt) 
                                     VALUES (@StudentId, @QuizId, @Score, @TotalMarks, GETDATE())";

                SqlParameter[] p = {
                    new SqlParameter("@StudentId", studentId),
                    new SqlParameter("@QuizId", QuizId),
                    new SqlParameter("@Score", correctAnswersCount),
                    new SqlParameter("@TotalMarks", totalQuestionsCount)
                };

                DbHelper.ExecuteNonQuery(insertQuery, p);

                lblScore.Text = correctAnswersCount.ToString();
                lblTotalMarks.Text = totalQuestionsCount.ToString();
                pnlResult.Visible = true;
                btnSubmitQuiz.Visible = false;
            }
            catch (Exception ex)
            {
                lblNoQuestions.Text = "Submission Error: " + ex.Message;
                lblNoQuestions.Visible = true;
            }
        }
    }
}