using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

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
                LoadSubjectsDropdown();

                // Check if a subject query string was passed from the dashboard cards
                string selectedSubject = Request.QueryString["subject"];
                if (!string.IsNullOrEmpty(selectedSubject))
                {
                    if (ddlSubjectFilter.Items.FindByValue(selectedSubject) != null)
                    {
                        ddlSubjectFilter.SelectedValue = selectedSubject;
                    }
                }

                LoadMaterials(ddlSubjectFilter.SelectedValue);
            }
        }

        private void LoadSubjectsDropdown()
        {
            try
            {
                string query = "SELECT SubjectName FROM Subjects ORDER BY SubjectName ASC";
                DataTable dt = DbHelper.ExecuteQuery(query, new SqlParameter[0]);

                if (dt != null && dt.Rows.Count > 0)
                {
                    ddlSubjectFilter.DataSource = dt;
                    ddlSubjectFilter.DataTextField = "SubjectName";
                    ddlSubjectFilter.DataValueField = "SubjectName";
                    ddlSubjectFilter.DataBind();
                }

                // Insert default option at top
                ddlSubjectFilter.Items.Insert(0, new ListItem("All Subjects", ""));
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Dropdown Error: " + ex.Message);
            }
        }

        protected void ddlSubjectFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadMaterials(ddlSubjectFilter.SelectedValue);
        }

        private void LoadMaterials(string selectedSubject)
        {
            try
            {
                string query;
                SqlParameter[] parameters = null;

                if (!string.IsNullOrEmpty(selectedSubject))
                {
                    // Filter materials specifically for the chosen subject
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
                    // Load all materials if no subject is filtered
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