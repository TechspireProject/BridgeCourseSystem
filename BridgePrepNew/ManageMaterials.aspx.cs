using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;

namespace BridgePrep
{
    public partial class ManageMaterials : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Security Check for Teacher Role (RoleId = 2)
            if (Session["UserId"] == null || Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 2)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                lblTeacherName.Text = Session["UserName"] != null ? Session["UserName"].ToString() : "Teacher";
                LoadSubjects();
                LoadMaterials();
            }
        }

        private void LoadSubjects()
        {
            try
            {
                string query = "SELECT SubjectId, SubjectName FROM Subjects";
                DataTable dt = DbHelper.ExecuteQuery(query);

                if (dt != null && dt.Rows.Count > 0)
                {
                    ddlSubjects.DataSource = dt;
                    ddlSubjects.DataTextField = "SubjectName";
                    ddlSubjects.DataValueField = "SubjectId";
                    ddlSubjects.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error loading subjects: " + ex.Message;
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
            }
        }

        private void LoadMaterials()
        {
            try
            {
                string query = @"SELECT lm.MaterialId, lm.Title, lm.ContentType, lm.ContentUrl, s.SubjectName 
                                 FROM LearningMaterials lm 
                                 JOIN Subjects s ON lm.SubjectId = s.SubjectId 
                                 ORDER BY lm.UploadedAt DESC";
                DataTable dt = DbHelper.ExecuteQuery(query);

                if (dt != null && dt.Rows.Count > 0)
                {
                    gvMaterials.DataSource = dt;
                    gvMaterials.DataBind();
                    lblNoData.Visible = false;
                }
                else
                {
                    gvMaterials.DataSource = null;
                    gvMaterials.DataBind();
                    lblNoData.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error loading materials: " + ex.Message;
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
            }
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            lblMsg.Text = "";

            int teacherId = 0;
            if (Session["UserId"] != null)
            {
                int.TryParse(Session["UserId"].ToString(), out teacherId);
            }

            int subjectId = 0;
            if (ddlSubjects.SelectedValue != null)
            {
                int.TryParse(ddlSubjects.SelectedValue, out subjectId);
            }

            string title = txtTitle.Text.Trim();
            string contentType = ddlContentType.SelectedValue;

            if (string.IsNullOrEmpty(title))
            {
                lblMsg.Text = "Please enter a title.";
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                return;
            }

            if (subjectId <= 0)
            {
                lblMsg.Text = "Please select a valid subject.";
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                return;
            }

            string finalContentUrl = "";
            string savePath = "";

            try
            {
                // Process Video Links / Web Articles
                if (contentType == "Video" || contentType == "Article")
                {
                    finalContentUrl = txtContentUrl.Text.Trim();

                    if (string.IsNullOrEmpty(finalContentUrl))
                    {
                        lblMsg.Text = "Please enter a valid link/URL.";
                        lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                        return;
                    }

                    // Auto-fix missing http/https prefix
                    if (!finalContentUrl.StartsWith("http://", StringComparison.OrdinalIgnoreCase) &&
                        !finalContentUrl.StartsWith("https://", StringComparison.OrdinalIgnoreCase))
                    {
                        finalContentUrl = "https://" + finalContentUrl;
                    }
                }
                // Process Physical File Uploads (PDF / Document)
                else
                {
                    if (!fileUploadMaterial.HasFile)
                    {
                        lblMsg.Text = "Please select a file to upload.";
                        lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                        return;
                    }

                    string folderPath = Server.MapPath("~/Uploads/");
                    if (!Directory.Exists(folderPath))
                    {
                        Directory.CreateDirectory(folderPath);
                    }

                    string extension = Path.GetExtension(fileUploadMaterial.FileName);
                    string uniqueFileName = Guid.NewGuid().ToString() + extension;
                    savePath = Path.Combine(folderPath, uniqueFileName);

                    fileUploadMaterial.SaveAs(savePath);
                    finalContentUrl = "/Uploads/" + uniqueFileName;
                }

                // Insert into Database
                string query = @"INSERT INTO LearningMaterials (SubjectId, Title, ContentType, ContentUrl, UploadedBy, UploadedAt) 
                                 VALUES (@SubjectId, @Title, @ContentType, @Url, @TeacherId, GETDATE())";

                SqlParameter[] p = {
                    new SqlParameter("@SubjectId", subjectId),
                    new SqlParameter("@Title", title),
                    new SqlParameter("@ContentType", contentType),
                    new SqlParameter("@Url", finalContentUrl),
                    new SqlParameter("@TeacherId", teacherId)
                };

                int rows = DbHelper.ExecuteNonQuery(query, p);

                if (rows > 0)
                {
                    lblMsg.Text = "Material uploaded successfully!";
                    lblMsg.CssClass = "text-success mt-3 d-block text-center";
                    txtTitle.Text = "";
                    txtContentUrl.Text = "";
                    LoadMaterials();
                }
                else
                {
                    if (!string.IsNullOrEmpty(savePath) && File.Exists(savePath))
                    {
                        File.Delete(savePath);
                    }

                    lblMsg.Text = "Failed to save record to database.";
                    lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                }
            }
            catch (Exception ex)
            {
                if (!string.IsNullOrEmpty(savePath) && File.Exists(savePath))
                {
                    File.Delete(savePath);
                }

                lblMsg.Text = "Error during upload: " + ex.Message;
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
            }
        }

        protected void gvMaterials_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
        {
            try
            {
                int materialId = Convert.ToInt32(gvMaterials.DataKeys[e.RowIndex].Value);

                string selectQuery = "SELECT ContentUrl FROM LearningMaterials WHERE MaterialId = @MaterialId";
                SqlParameter[] pSelect = { new SqlParameter("@MaterialId", materialId) };
                DataTable dt = DbHelper.ExecuteQuery(selectQuery, pSelect);

                if (dt != null && dt.Rows.Count > 0)
                {
                    string fileUrl = dt.Rows[0]["ContentUrl"].ToString();

                    // Delete physical files only (ignore web URLs like YouTube/HTTP links)
                    if (!fileUrl.StartsWith("http://", StringComparison.OrdinalIgnoreCase) &&
                        !fileUrl.StartsWith("https://", StringComparison.OrdinalIgnoreCase))
                    {
                        if (fileUrl.StartsWith("~/") || fileUrl.StartsWith("/"))
                        {
                            string physicalPath = Server.MapPath("~" + fileUrl.Replace("~", ""));
                            if (File.Exists(physicalPath))
                            {
                                File.Delete(physicalPath);
                            }
                        }
                    }
                }

                // Delete DB Record
                string deleteQuery = "DELETE FROM LearningMaterials WHERE MaterialId = @MaterialId";
                SqlParameter[] pDelete = { new SqlParameter("@MaterialId", materialId) };

                DbHelper.ExecuteNonQuery(deleteQuery, pDelete);
                LoadMaterials();
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error deleting material: " + ex.Message;
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
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