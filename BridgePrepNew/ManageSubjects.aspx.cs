using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace BridgePrep
{
    public partial class ManageSubjects : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 2)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadSubjects();
            }
        }

        private void LoadSubjects()
        {
            try
            {
                DataTable dt = DbHelper.ExecuteQuery("SELECT SubjectId, SubjectName FROM Subjects ORDER BY SubjectName ASC");
                if (dt != null && dt.Rows.Count > 0)
                {
                    gvSubjects.DataSource = dt;
                    gvSubjects.DataBind();
                    lblNoData.Visible = false;
                }
                else
                {
                    gvSubjects.DataSource = null;
                    gvSubjects.DataBind();
                    lblNoData.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error: " + ex.Message;
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
            }
        }

        protected void btnAddSubject_Click(object sender, EventArgs e)
        {
            string subjectName = txtSubjectName.Text.Trim();

            if (string.IsNullOrEmpty(subjectName))
            {
                lblMsg.Text = "Please enter a valid subject name.";
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                return;
            }

            string query = "INSERT INTO Subjects (SubjectName) VALUES (@SubjectName)";
            SqlParameter[] p = { new SqlParameter("@SubjectName", subjectName) };

            int rows = DbHelper.ExecuteNonQuery(query, p);
            if (rows > 0)
            {
                lblMsg.Text = "Subject added successfully!";
                lblMsg.CssClass = "text-success mt-3 d-block text-center";
                txtSubjectName.Text = string.Empty;
                LoadSubjects();
            }
        }

        protected void gvSubjects_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int subjectId = Convert.ToInt32(gvSubjects.DataKeys[e.RowIndex].Value);

            string query = "DELETE FROM Subjects WHERE SubjectId = @SubjectId";
            SqlParameter[] p = { new SqlParameter("@SubjectId", subjectId) };

            DbHelper.ExecuteNonQuery(query, p);
            LoadSubjects();
        }
    }
}