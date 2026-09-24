using System;
using System.Data;
using System.Web.UI;

namespace BridgePrep
{
    public partial class SelectQuiz : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Session check for Student (RoleId = 3)
            if (Session["UserId"] == null || Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 3)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Removed lblStudentName reference to resolve CS0103 build error
                LoadQuizzes();
            }
        }

        private void LoadQuizzes()
        {
            try
            {
                string query = @"SELECT q.QuizId, q.QuizTitle, q.TotalMarks, s.SubjectName 
                                 FROM Quizzes q 
                                 JOIN Subjects s ON q.SubjectId = s.SubjectId 
                                 ORDER BY q.QuizId DESC";

                DataTable dt = DbHelper.ExecuteQuery(query, null);

                if (dt != null && dt.Rows.Count > 0)
                {
                    gvAvailableQuizzes.DataSource = dt;
                    gvAvailableQuizzes.DataBind();
                    lblNoQuizzes.Visible = false;
                }
                else
                {
                    gvAvailableQuizzes.DataSource = null;
                    gvAvailableQuizzes.DataBind();
                    lblNoQuizzes.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblNoQuizzes.Text = "Error loading quizzes: " + ex.Message;
                lblNoQuizzes.Visible = true;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}