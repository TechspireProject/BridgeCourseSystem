using System;
using System.Data;
using System.Data.SqlClient;

namespace BridgePrep
{
    public partial class TeacherDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Session security check for Teacher (RoleId = 2)
            if (Session["UserId"] == null || Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 2)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                lblTeacherName.Text = Session["UserName"] != null ? Session["UserName"].ToString() : "Teacher";
                LoadDashboardMetrics();
            }
        }

        private void LoadDashboardMetrics()
        {
            try
            {
                int teacherId = Convert.ToInt32(Session["UserId"]);

                // 1. Total Materials (Uploaded by logged-in teacher)
                string matQuery = "SELECT COUNT(*) FROM LearningMaterials WHERE UploadedBy = @TeacherId";
                SqlParameter[] pMat = { new SqlParameter("@TeacherId", teacherId) };
                DataTable dtMat = DbHelper.ExecuteQuery(matQuery, pMat);
                lblTotalMaterials.Text = (dtMat != null && dtMat.Rows.Count > 0) ? dtMat.Rows[0][0].ToString() : "0";

                // 2. Active Quizzes (Created by logged-in teacher)
                string quizQuery = "SELECT COUNT(*) FROM Quizzes WHERE TeacherId = @TeacherId";
                SqlParameter[] pQuiz = { new SqlParameter("@TeacherId", teacherId) };
                DataTable dtQuiz = DbHelper.ExecuteQuery(quizQuery, pQuiz);
                lblTotalQuizzes.Text = (dtQuiz != null && dtQuiz.Rows.Count > 0) ? dtQuiz.Rows[0][0].ToString() : "0";

                // 3. Quiz Submissions (Count from Scores table for this teacher's quizzes)
                string subQuery = @"SELECT COUNT(s.ScoreId) 
                                   FROM Scores s 
                                   INNER JOIN Quizzes q ON s.QuizId = q.QuizId 
                                   WHERE q.TeacherId = @TeacherId";
                SqlParameter[] pSub = { new SqlParameter("@TeacherId", teacherId) };
                DataTable dtSub = DbHelper.ExecuteQuery(subQuery, pSub);

                // Fallback to absolute count of Scores if TeacherId filtering isn't needed
                if (dtSub == null || dtSub.Rows.Count == 0)
                {
                    dtSub = DbHelper.ExecuteQuery("SELECT COUNT(*) FROM Scores");
                }
                lblTotalSubmissions.Text = (dtSub != null && dtSub.Rows.Count > 0) ? dtSub.Rows[0][0].ToString() : "0";

                // 4. Course Subjects Count
                DataTable dtSubj = DbHelper.ExecuteQuery("SELECT COUNT(*) FROM Subjects");
                lblTotalSubjects.Text = (dtSubj != null && dtSubj.Rows.Count > 0) ? dtSubj.Rows[0][0].ToString() : "0";
            }
            catch (Exception)
            {
                lblTotalMaterials.Text = "0";
                lblTotalQuizzes.Text = "0";
                lblTotalSubmissions.Text = "0";
                lblTotalSubjects.Text = "0";
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