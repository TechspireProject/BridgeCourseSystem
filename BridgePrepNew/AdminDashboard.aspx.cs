using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BridgePrep
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Session security check for Admin (RoleId = 1)
            if (Session["UserId"] == null || Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 1)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                lblAdminName.Text = Session["UserName"] != null ? Session["UserName"].ToString() : "Admin";

                // Load all dashboard sections
                LoadDashboardStats();
                LoadUsers();
                LoadSubjects();
                LoadMaterials();
                LoadQuizzes();
            }
        }

        #region Load Data Methods
        private void LoadDashboardStats()
        {
            try
            {
                DataTable dtUsers = DbHelper.ExecuteQuery("SELECT COUNT(*) FROM Users");
                lblTotalUsers.Text = (dtUsers != null && dtUsers.Rows.Count > 0) ? dtUsers.Rows[0][0].ToString() : "0";

                DataTable dtSubjects = DbHelper.ExecuteQuery("SELECT COUNT(*) FROM Subjects");
                lblTotalSubjects.Text = (dtSubjects != null && dtSubjects.Rows.Count > 0) ? dtSubjects.Rows[0][0].ToString() : "0";

                DataTable dtMaterials = DbHelper.ExecuteQuery("SELECT COUNT(*) FROM LearningMaterials");
                lblTotalMaterials.Text = (dtMaterials != null && dtMaterials.Rows.Count > 0) ? dtMaterials.Rows[0][0].ToString() : "0";

                DataTable dtQuizzes = DbHelper.ExecuteQuery("SELECT COUNT(*) FROM Quizzes");
                lblTotalQuizzes.Text = (dtQuizzes != null && dtQuizzes.Rows.Count > 0) ? dtQuizzes.Rows[0][0].ToString() : "0";
            }
            catch (Exception ex)
            {
                lblTotalUsers.Text = "0";
                lblTotalMaterials.Text = "0";
                lblTotalQuizzes.Text = "0";
                ShowMessage("Error loading statistics: " + ex.Message, "warning");
            }
        }

        private void LoadUsers()
        {
            string query = @"SELECT u.UserId, u.FullName, u.Email, u.RoleId, u.CreatedAt, r.RoleName 
                             FROM Users u 
                             LEFT JOIN Roles r ON u.RoleId = r.RoleId";
            gvUsers.DataSource = DbHelper.ExecuteQuery(query);
            gvUsers.DataBind();
        }

        private void LoadSubjects()
        {
            string query = "SELECT SubjectId, SubjectName, Description FROM Subjects";
            gvSubjects.DataSource = DbHelper.ExecuteQuery(query);
            gvSubjects.DataBind();
        }

        private void LoadMaterials()
        {
            string query = @"SELECT m.MaterialId, m.Title, ISNULL(s.SubjectName, 'Unassigned') AS SubjectName 
                             FROM LearningMaterials m 
                             LEFT JOIN Subjects s ON m.SubjectId = s.SubjectId";
            DataTable dt = DbHelper.ExecuteQuery(query);
            gvMaterials.DataSource = dt;
            gvMaterials.DataBind();

            if (lblNoMaterials != null)
            {
                lblNoMaterials.Visible = (dt == null || dt.Rows.Count == 0);
            }
        }

        private void LoadQuizzes()
        {
            string query = @"SELECT q.QuizId, q.QuizTitle, ISNULL(s.SubjectName, 'Unassigned') AS SubjectName 
                             FROM Quizzes q 
                             LEFT JOIN Subjects s ON q.SubjectId = s.SubjectId";
            gvQuizzes.DataSource = DbHelper.ExecuteQuery(query);
            gvQuizzes.DataBind();
        }
        #endregion

        #region User Actions & Inline Editing
        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtFullName.Text) || string.IsNullOrWhiteSpace(txtEmail.Text))
            {
                ShowMessage("Please complete all required user fields.", "danger");
                return;
            }

            string query = @"INSERT INTO Users (FullName, Email, PasswordHash, RoleId, CreatedAt) 
                             VALUES (@FullName, @Email, @Password, @RoleId, GETDATE())";

            SqlParameter[] p = {
                new SqlParameter("@FullName", txtFullName.Text.Trim()),
                new SqlParameter("@Email", txtEmail.Text.Trim()),
                new SqlParameter("@Password", txtPassword.Text.Trim()),
                new SqlParameter("@RoleId", ddlRole.SelectedValue)
            };

            try
            {
                DbHelper.ExecuteNonQuery(query, p);
                ShowMessage("Account added successfully.", "success");

                txtFullName.Text = txtEmail.Text = txtPassword.Text = string.Empty;
                LoadUsers();
                LoadDashboardStats();
            }
            catch (Exception ex)
            {
                ShowMessage("Error adding user: " + ex.Message, "danger");
            }
        }

        protected void gvUsers_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvUsers.EditIndex = e.NewEditIndex;
            LoadUsers();
        }

        protected void gvUsers_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvUsers.EditIndex = -1;
            LoadUsers();
        }

        protected void gvUsers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && (e.Row.RowState & DataControlRowState.Edit) > 0)
            {
                DropDownList ddlEditRole = (DropDownList)e.Row.FindControl("ddlEditRole");
                HiddenField hfRoleId = (HiddenField)e.Row.FindControl("hfRoleId");

                if (ddlEditRole != null && hfRoleId != null && !string.IsNullOrEmpty(hfRoleId.Value))
                {
                    ddlEditRole.SelectedValue = hfRoleId.Value;
                }
            }
        }

        protected void gvUsers_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                int userId = Convert.ToInt32(gvUsers.DataKeys[e.RowIndex].Value);
                GridViewRow row = gvUsers.Rows[e.RowIndex];

                TextBox txtEditFullName = (TextBox)row.FindControl("txtEditFullName");
                TextBox txtEditEmail = (TextBox)row.FindControl("txtEditEmail");
                DropDownList ddlEditRole = (DropDownList)row.FindControl("ddlEditRole");

                string fullName = txtEditFullName != null ? txtEditFullName.Text.Trim() : "";
                string email = txtEditEmail != null ? txtEditEmail.Text.Trim() : "";
                string roleId = ddlEditRole != null ? ddlEditRole.SelectedValue : "3";

                if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email))
                {
                    ShowMessage("Full Name and Email are required.", "danger");
                    return;
                }

                string query = @"UPDATE Users 
                                 SET FullName = @FullName, Email = @Email, RoleId = @RoleId 
                                 WHERE UserId = @UserId";

                SqlParameter[] p = {
                    new SqlParameter("@FullName", fullName),
                    new SqlParameter("@Email", email),
                    new SqlParameter("@RoleId", roleId),
                    new SqlParameter("@UserId", userId)
                };

                DbHelper.ExecuteNonQuery(query, p);
                ShowMessage("User details updated successfully.", "success");

                gvUsers.EditIndex = -1;
                LoadUsers();
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating user: " + ex.Message, "danger");
            }
        }

        protected void gvUsers_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int userId = Convert.ToInt32(gvUsers.DataKeys[e.RowIndex].Value);
            string query = "DELETE FROM Users WHERE UserId = @UserId";
            SqlParameter[] p = { new SqlParameter("@UserId", userId) };

            try
            {
                DbHelper.ExecuteNonQuery(query, p);
                ShowMessage("User removed successfully.", "success");
                LoadUsers();
                LoadDashboardStats();
            }
            catch (Exception ex)
            {
                ShowMessage("Cannot delete user: " + ex.Message, "danger");
            }
        }
        #endregion

        #region Material & Quiz Deletions
        protected void gvMaterials_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int materialId = Convert.ToInt32(gvMaterials.DataKeys[e.RowIndex].Value);
            string query = "DELETE FROM LearningMaterials WHERE MaterialId = @MaterialId";
            SqlParameter[] p = { new SqlParameter("@MaterialId", materialId) };

            try
            {
                DbHelper.ExecuteNonQuery(query, p);
                ShowMessage("Learning material deleted.", "info");
                LoadMaterials();
                LoadDashboardStats();
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting material: " + ex.Message, "danger");
            }
        }

        protected void gvQuizzes_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int quizId = Convert.ToInt32(gvQuizzes.DataKeys[e.RowIndex].Value);
            string query = "DELETE FROM Quizzes WHERE QuizId = @QuizId";
            SqlParameter[] p = { new SqlParameter("@QuizId", quizId) };

            try
            {
                DbHelper.ExecuteNonQuery(query, p);
                ShowMessage("Quiz removed.", "info");
                LoadQuizzes();
                LoadDashboardStats();
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting quiz: " + ex.Message, "danger");
            }
        }
        #endregion

        #region Reports
        protected void btnUserReport_Click(object sender, EventArgs e)
        {
            DataTable dt = DbHelper.ExecuteQuery("SELECT UserId, FullName, Email, CreatedAt FROM Users");
            ExportToCsv(dt, "User_Activity_Report.csv");
        }

        protected void btnPerformanceReport_Click(object sender, EventArgs e)
        {
            DataTable dt = DbHelper.ExecuteQuery("SELECT * FROM StudentResults");
            ExportToCsv(dt, "Student_Performance_Report.csv");
        }

        private void ExportToCsv(DataTable dt, string fileName)
        {
            if (dt == null || dt.Rows.Count == 0)
            {
                ShowMessage("No data available to export.", "warning");
                return;
            }

            StringBuilder sb = new StringBuilder();

            foreach (DataColumn col in dt.Columns)
                sb.Append(col.ColumnName + ",");

            sb.AppendLine();

            foreach (DataRow row in dt.Rows)
            {
                foreach (DataColumn col in dt.Columns)
                    sb.Append(row[col].ToString().Replace(",", " ") + ",");
                sb.AppendLine();
            }

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", $"attachment;filename={fileName}");
            Response.Charset = "";
            Response.ContentType = "text/csv";
            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        private void ShowMessage(string message, string cssType)
        {
            lblMsg.Text = message;
            lblMsg.CssClass = $"alert alert-{cssType} alert-dismissible fade show";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
        #endregion
    }
}