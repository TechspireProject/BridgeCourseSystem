using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace BridgePrep
{
    public partial class DownloadMaterials : Page
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
                LoadMaterials();
            }
        }

        private void LoadMaterials()
        {
            try
            {
                string selectedSubject = Request.QueryString["subject"];
                string query;
                SqlParameter[] parameters = null;

                if (!string.IsNullOrEmpty(selectedSubject))
                {
                    // Filter materials specifically for the chosen subject card
                    query = @"
                        SELECT 
                            m.MaterialId,
                            m.Title,
                            m.ContentType AS DisplayType,
                            ISNULL(m.ContentUrl, '#') AS DisplayUrl,
                            ISNULL(s.SubjectName, 'General') AS SubjectName
                        FROM LearningMaterials m
                        LEFT JOIN Subjects s ON m.SubjectId = s.SubjectId
                        WHERE s.SubjectName = @SubjectName
                        ORDER BY m.MaterialId DESC";

                    parameters = new SqlParameter[] {
                        new SqlParameter("@SubjectName", selectedSubject)
                    };
                }
                else
                {
                    // Load all materials if no specific subject card was clicked
                    query = @"
                        SELECT 
                            m.MaterialId,
                            m.Title,
                            m.ContentType AS DisplayType,
                            ISNULL(m.ContentUrl, '#') AS DisplayUrl,
                            ISNULL(s.SubjectName, 'General') AS SubjectName
                        FROM LearningMaterials m
                        LEFT JOIN Subjects s ON m.SubjectId = s.SubjectId
                        ORDER BY m.MaterialId DESC";
                }

                DataTable dt = DbHelper.ExecuteQuery(query, parameters);

                if (dt != null && dt.Rows.Count > 0)
                {
                    gvMaterials.DataSource = dt;
                    gvMaterials.DataBind();
                    gvMaterials.Visible = true;
                    lblNoMaterials.Visible = false;
                }
                else
                {
                    gvMaterials.DataSource = null;
                    gvMaterials.DataBind();
                    gvMaterials.Visible = false;
                    lblNoMaterials.Visible = true;
                    lblNoMaterials.Text = string.IsNullOrEmpty(selectedSubject)
                        ? "No study materials published yet."
                        : $"No study materials found for {selectedSubject}.";
                }
            }
            catch (Exception ex)
            {
                gvMaterials.Visible = false;
                lblNoMaterials.Text = "Error loading study materials: " + ex.Message;
                lblNoMaterials.Visible = true;
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