// ViewResults.aspx.cs
using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace BridgePrep
{
    public partial class ViewResults : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadResults();
            }
        }

        private void LoadResults()
        {
            try
            {
                int studentId = Convert.ToInt32(Session["UserId"]);
                string query = @"
                    SELECT q.QuizTitle, s.SubjectName, sc.Score, sc.TotalMarks, sc.TakenAt
                    FROM Scores sc
                    JOIN Quizzes q ON sc.QuizId = q.QuizId
                    JOIN Subjects s ON q.SubjectId = s.SubjectId
                    WHERE sc.StudentId = @StudentId
                    ORDER BY sc.TakenAt DESC";

                SqlParameter[] p = { new SqlParameter("@StudentId", studentId) };
                DataTable dt = DbHelper.ExecuteQuery(query, p);

                if (dt != null && dt.Rows.Count > 0)
                {
                    gvResults.DataSource = dt;
                    gvResults.DataBind();
                }
                else
                {
                    lblNoData.Visible = true;
                }
            }
            catch (Exception)
            {
                lblNoData.Visible = true;
            }
        }
    }
}