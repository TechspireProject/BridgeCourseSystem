using System;
using System.Data;
using System.Web.UI;

namespace BridgePrep
{
    public partial class ViewPerformance : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in
                if (Session["UserId"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                LoadPerformanceData();
            }
        }

        private void LoadPerformanceData()
        {
            try
            {
                // Uses FullName instead of UserName from Users table
                string query = @"
                    SELECT 
                        u.FullName AS StudentName,
                        q.QuizTitle,
                        s.SubjectName,
                        sc.Score,
                        sc.TotalMarks,
                        sc.TakenAt
                    FROM Scores sc
                    JOIN Users u ON sc.StudentId = u.UserId
                    JOIN Quizzes q ON sc.QuizId = q.QuizId
                    JOIN Subjects s ON q.SubjectId = s.SubjectId
                    ORDER BY sc.TakenAt DESC";

                DataTable dt = DbHelper.ExecuteQuery(query);

                if (dt != null && dt.Rows.Count > 0)
                {
                    gvPerformance.DataSource = dt;
                    gvPerformance.DataBind();
                    lblNoData.Visible = false;
                }
                else
                {
                    gvPerformance.DataSource = null;
                    gvPerformance.DataBind();
                    lblNoData.Visible = true;
                    lblNoData.Text = "No student performance records found.";
                }
            }
            catch (Exception ex)
            {
                lblNoData.Text = "Error fetching records: " + ex.Message;
                lblNoData.Visible = true;
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