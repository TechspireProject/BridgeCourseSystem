using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace BridgePrep
{
    public partial class ManageProfile : Page
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
                LoadUserProfile();
            }
        }

        private void LoadUserProfile()
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                // Updated Username -> FullName
                string query = "SELECT FullName, Email FROM Users WHERE UserId = @UserId";

                SqlParameter[] p = { new SqlParameter("@UserId", userId) };
                DataTable dt = DbHelper.ExecuteQuery(query, p);

                if (dt != null && dt.Rows.Count > 0)
                {
                    txtName.Text = dt.Rows[0]["FullName"].ToString();
                    txtEmail.Text = dt.Rows[0]["Email"].ToString();
                }
            }
            catch (Exception ex)
            {
                lblStatus.Text = "Error loading profile: " + ex.Message;
                lblStatus.CssClass = "alert alert-danger d-block mb-4";
                lblStatus.Visible = true;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                // Updated Username -> FullName
                string query = "UPDATE Users SET FullName = @FullName WHERE UserId = @UserId";

                SqlParameter[] p = {
                    new SqlParameter("@FullName", txtName.Text.Trim()),
                    new SqlParameter("@UserId", userId)
                };

                int rowsAffected = DbHelper.ExecuteNonQuery(query, p);

                if (rowsAffected > 0)
                {
                    Session["UserName"] = txtName.Text.Trim();
                    lblStatus.Text = "Profile updated successfully!";
                    lblStatus.CssClass = "alert alert-success d-block mb-4";
                }
                else
                {
                    lblStatus.Text = "Failed to update profile.";
                    lblStatus.CssClass = "alert alert-warning d-block mb-4";
                }
                lblStatus.Visible = true;
            }
            catch (Exception ex)
            {
                lblStatus.Text = "Error updating profile: " + ex.Message;
                lblStatus.CssClass = "alert alert-danger d-block mb-4";
                lblStatus.Visible = true;
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