using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace BridgePrep
{
    public partial class AddQuestions : System.Web.UI.Page
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
            // Session check for Teacher
            if (Session["UserId"] == null || Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 2)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (QuizId == 0)
            {
                Response.Redirect("ManageQuizzes.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadQuizInfo();
                LoadQuestions();
            }
        }

        private void LoadQuizInfo()
        {
            try
            {
                string query = "SELECT QuizTitle, TotalMarks FROM Quizzes WHERE QuizId = @QuizId";
                SqlParameter[] p = { new SqlParameter("@QuizId", QuizId) };
                DataTable dt = DbHelper.ExecuteQuery(query, p);

                if (dt != null && dt.Rows.Count > 0)
                {
                    lblQuizTitle.Text = dt.Rows[0]["QuizTitle"].ToString();
                    txtTotalMarks.Text = dt.Rows[0]["TotalMarks"].ToString();
                }
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error loading quiz info: " + ex.Message;
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
            }
        }

        protected void btnUpdateMarks_Click(object sender, EventArgs e)
        {
            string marksStr = txtTotalMarks.Text.Trim();

            if (string.IsNullOrEmpty(marksStr))
            {
                lblMarksMsg.Text = "Please enter total marks.";
                lblMarksMsg.CssClass = "text-danger";
                return;
            }

            try
            {
                int totalMarks = Convert.ToInt32(marksStr);
                string query = "UPDATE Quizzes SET TotalMarks = @TotalMarks WHERE QuizId = @QuizId";
                SqlParameter[] p = {
                    new SqlParameter("@TotalMarks", totalMarks),
                    new SqlParameter("@QuizId", QuizId)
                };

                int rows = DbHelper.ExecuteNonQuery(query, p);
                if (rows > 0)
                {
                    lblMarksMsg.Text = "Marks updated successfully!";
                    lblMarksMsg.CssClass = "text-success";
                }
                else
                {
                    lblMarksMsg.Text = "Failed to update marks.";
                    lblMarksMsg.CssClass = "text-danger";
                }
            }
            catch (Exception ex)
            {
                lblMarksMsg.Text = "Error: " + ex.Message;
                lblMarksMsg.CssClass = "text-danger";
            }
        }

        private void LoadQuestions()
        {
            try
            {
                string query = "SELECT QuestionId, QuestionText, CorrectOption FROM Questions WHERE QuizId = @QuizId ORDER BY QuestionId DESC";
                SqlParameter[] p = { new SqlParameter("@QuizId", QuizId) };
                DataTable dt = DbHelper.ExecuteQuery(query, p);

                if (dt != null && dt.Rows.Count > 0)
                {
                    gvQuestions.DataSource = dt;
                    gvQuestions.DataBind();
                    lblNoData.Visible = false;
                }
                else
                {
                    gvQuestions.DataSource = null;
                    gvQuestions.DataBind();
                    lblNoData.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error loading questions: " + ex.Message;
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
            }
        }

        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            string qText = txtQuestionText.Text.Trim();
            string optA = txtOptionA.Text.Trim();
            string optB = txtOptionB.Text.Trim();
            string optC = txtOptionC.Text.Trim();
            string optD = txtOptionD.Text.Trim();
            string correctOpt = ddlCorrectOption.SelectedValue;

            if (string.IsNullOrEmpty(qText) || string.IsNullOrEmpty(optA) || string.IsNullOrEmpty(optB) ||
                string.IsNullOrEmpty(optC) || string.IsNullOrEmpty(optD) || correctOpt == "0")
            {
                lblMsg.Text = "Please fill in all options and select the correct answer.";
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                return;
            }

            string query = @"INSERT INTO Questions (QuizId, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption) 
                             VALUES (@QuizId, @QuestionText, @OptionA, @OptionB, @OptionC, @OptionD, @CorrectOption)";

            SqlParameter[] p = {
                new SqlParameter("@QuizId", QuizId),
                new SqlParameter("@QuestionText", qText),
                new SqlParameter("@OptionA", optA),
                new SqlParameter("@OptionB", optB),
                new SqlParameter("@OptionC", optC),
                new SqlParameter("@OptionD", optD),
                new SqlParameter("@CorrectOption", correctOpt)
            };

            int rows = DbHelper.ExecuteNonQuery(query, p);
            if (rows > 0)
            {
                lblMsg.Text = "Question added successfully!";
                lblMsg.CssClass = "text-success mt-3 d-block text-center";

                // Clear inputs
                txtQuestionText.Text = "";
                txtOptionA.Text = "";
                txtOptionB.Text = "";
                txtOptionC.Text = "";
                txtOptionD.Text = "";
                ddlCorrectOption.SelectedIndex = 0;

                LoadQuestions();
            }
            else
            {
                lblMsg.Text = "Failed to add question.";
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
            }
        }

        protected void gvQuestions_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int qId = Convert.ToInt32(gvQuestions.DataKeys[e.RowIndex].Value);

            string query = "DELETE FROM Questions WHERE QuestionId = @QuestionId";
            SqlParameter[] p = { new SqlParameter("@QuestionId", qId) };

            DbHelper.ExecuteNonQuery(query, p);
            LoadQuestions();
        }
    }
}