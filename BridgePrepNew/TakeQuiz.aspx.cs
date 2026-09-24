using System;
using System.Data;
using System.Data.SqlClient;
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
            // Session check for Student Role (RoleId = 3)
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

            // Database setup check
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
                            [ScoreId]    INT      IDENTITY (1, 1) NOT NULL PRIMARY KEY,
                            [StudentId]  INT      NOT NULL,
                            [QuizId]     INT      NOT NULL,
                            [Score]      INT      NOT NULL,
                            [TotalMarks] INT      NOT NULL,
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
                string query = "SELECT QuestionId, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption FROM Questions WHERE QuizId = @QuizId";
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

        protected void btnSubmitQuiz_Click(object sender, EventArgs e)
        {
            try
            {
                // Retrieve original question details from Database for grading
                string query = "SELECT QuestionId, CorrectOption FROM Questions WHERE QuizId = @QuizId";
                SqlParameter[] qParams = { new SqlParameter("@QuizId", QuizId) };
                DataTable dtQuestions = DbHelper.ExecuteQuery(query, qParams);

                if (dtQuestions == null || dtQuestions.Rows.Count == 0)
                {
                    lblNoQuestions.Text = "Could not locate quiz questions to grade.";
                    lblNoQuestions.Visible = true;
                    return;
                }

                int correctAnswersCount = 0;
                int totalQuestionsCount = dtQuestions.Rows.Count;

                foreach (DataRow row in dtQuestions.Rows)
                {
                    string questionId = row["QuestionId"].ToString();
                    string actualCorrectOption = row["CorrectOption"].ToString().Trim();

                    string selectedOption = null;

                    // Match HTTP posted radio inputs safely across standard and mangled forms
                    foreach (string key in Request.Form.AllKeys)
                    {
                        if (key != null && (key == "q_" + questionId || key.EndsWith("q_" + questionId)))
                        {
                            selectedOption = Request.Form[key];
                            break;
                        }
                    }

                    if (!string.IsNullOrEmpty(selectedOption) && selectedOption.Equals(actualCorrectOption, StringComparison.OrdinalIgnoreCase))
                    {
                        correctAnswersCount++;
                    }
                }

                int studentId = Convert.ToInt32(Session["UserId"]);

                // Record Score in DB
                string insertQuery = @"INSERT INTO Scores (StudentId, QuizId, Score, TotalMarks) 
                                      VALUES (@StudentId, @QuizId, @Score, @TotalMarks)";

                SqlParameter[] p = {
                    new SqlParameter("@StudentId", studentId),
                    new SqlParameter("@QuizId", QuizId),
                    new SqlParameter("@Score", correctAnswersCount),
                    new SqlParameter("@TotalMarks", totalQuestionsCount)
                };

                DbHelper.ExecuteNonQuery(insertQuery, p);

                // Render Summary Panel
                lblScore.Text = correctAnswersCount.ToString();
                lblTotalMarks.Text = totalQuestionsCount.ToString();
                pnlResult.Visible = true;
                rptQuestions.Visible = false;
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