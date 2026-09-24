using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace BridgePrep
{
    public partial class ManageQuizzes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Session check for Teacher
            if (Session["UserId"] == null || Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 2)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                lblTeacherName.Text = Session["UserName"] != null ? Session["UserName"].ToString() : "teacher";
                LoadSubjects();
                LoadQuizzes();
            }
        }

        private void LoadSubjects()
        {
            try
            {
                string query = "SELECT SubjectId, SubjectName FROM Subjects";
                DataTable dt = DbHelper.ExecuteQuery(query);

                ddlSubjects.DataSource = dt;
                ddlSubjects.DataTextField = "SubjectName";
                ddlSubjects.DataValueField = "SubjectId";
                ddlSubjects.DataBind();

                // Add default select option
                ddlSubjects.Items.Insert(0, new ListItem("-- Select Subject --", "0"));
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error loading subjects: " + ex.Message;
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
            }
        }

        private void LoadQuizzes()
        {
            try
            {
                string query = @"SELECT q.QuizId, q.QuizTitle, q.TotalMarks, s.SubjectName 
                                 FROM Quizzes q 
                                 JOIN Subjects s ON q.SubjectId = s.SubjectId 
                                 ORDER BY q.CreatedAt DESC";
                DataTable dt = DbHelper.ExecuteQuery(query);

                if (dt != null && dt.Rows.Count > 0)
                {
                    gvQuizzes.DataSource = dt;
                    gvQuizzes.DataBind();
                    lblNoData.Visible = false;
                }
                else
                {
                    gvQuizzes.DataSource = null;
                    gvQuizzes.DataBind();
                    lblNoData.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error loading quizzes: " + ex.Message;
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
            }
        }

        protected void btnCreateQuiz_Click(object sender, EventArgs e)
        {
            string title = txtQuizTitle.Text.Trim();
            string marksStr = txtTotalMarks.Text.Trim();

            // Check if fields are empty or default subject is selected
            if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(marksStr) || ddlSubjects.SelectedValue == "0" || string.IsNullOrEmpty(ddlSubjects.SelectedValue))
            {
                lblMsg.Text = "Please fill in all fields and select a subject.";
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                return;
            }

            int subjectId = Convert.ToInt32(ddlSubjects.SelectedValue);
            int totalMarks = Convert.ToInt32(marksStr);
            int teacherId = Convert.ToInt32(Session["UserId"]);

            // Updated query matching database schema: TeacherId
            string query = @"INSERT INTO Quizzes (SubjectId, TeacherId, QuizTitle, TotalMarks) 
                             VALUES (@SubjectId, @TeacherId, @Title, @Marks)";

            SqlParameter[] p = {
                new SqlParameter("@SubjectId", subjectId),
                new SqlParameter("@TeacherId", teacherId),
                new SqlParameter("@Title", title),
                new SqlParameter("@Marks", totalMarks)
            };

            int rows = DbHelper.ExecuteNonQuery(query, p);
            if (rows > 0)
            {
                lblMsg.Text = "Quiz created successfully!";
                lblMsg.CssClass = "text-success mt-3 d-block text-center";

                // Reset form fields
                txtQuizTitle.Text = "";
                txtTotalMarks.Text = "";
                ddlSubjects.SelectedIndex = 0;

                LoadQuizzes();
            }
            else
            {
                lblMsg.Text = "Failed to create quiz.";
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
            }
        }

        protected void gvQuizzes_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
        {
            int quizId = Convert.ToInt32(gvQuizzes.DataKeys[e.RowIndex].Value);

            string query = "DELETE FROM Quizzes WHERE QuizId = @QuizId";
            SqlParameter[] p = { new SqlParameter("@QuizId", quizId) };

            DbHelper.ExecuteNonQuery(query, p);
            LoadQuizzes();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}