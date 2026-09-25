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
            if (Session["UserId"] == null || Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 3)
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
                    SELECT 
                        QuizTitle,
                        SubjectName,
                        Score,
                        TotalMarks,
                        TakenAt,
                        CAST(ROUND((CAST(Score AS FLOAT) / TotalMarks) * 100, 1) AS VARCHAR) + '%' AS Percentage
                    FROM dbo.StudentResults
                    WHERE StudentId = @StudentId
                    ORDER BY TakenAt DESC";

                SqlParameter[] parameters = {
                    new SqlParameter("@StudentId", studentId)
                };

                DataTable dt = DbHelper.ExecuteQuery(query, parameters);

                if (dt != null && dt.Rows.Count > 0)
                {
                    gvResults.DataSource = dt;
                    gvResults.DataBind();
                    lblNoData.Visible = false;
                }
                else
                {
                    gvResults.DataSource = null;
                    gvResults.DataBind();
                    lblNoData.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblNoData.Text = "Error loading performance history: " + ex.Message;
                lblNoData.Visible = true;
            }
        }
    }
}