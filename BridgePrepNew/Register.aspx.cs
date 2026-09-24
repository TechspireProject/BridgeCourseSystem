using System;
using System.Data;
using System.Data.SqlClient;

namespace BridgePrep
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string name = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            int roleId = Convert.ToInt32(ddlRole.SelectedValue);

            // 1. Check if email already exists in the database
            string checkEmailQuery = "SELECT COUNT(*) FROM Users WHERE Email = @CheckEmail";
            SqlParameter[] checkParams = {
                new SqlParameter("@CheckEmail", email)
            };

            try
            {
                DataTable dt = DbHelper.ExecuteQuery(checkEmailQuery, checkParams);
                if (dt.Rows.Count > 0 && Convert.ToInt32(dt.Rows[0][0]) > 0)
                {
                    lblMsg.Text = "An account with this email address already exists. Please log in.";
                    lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                    return; // Stop execution
                }
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Database check error: " + ex.Message;
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                return;
            }

            // 2. Hash the password before saving to DB
            string hashedPassword = PasswordHelper.HashPassword(password);

            // 3. Insert new user if email is clear
            string insertQuery = "INSERT INTO Users (FullName, Email, PasswordHash, RoleId, CreatedAt) VALUES (@Name, @Email, @Pass, @Role, GETDATE())";
            SqlParameter[] p = {
                new SqlParameter("@Name", name),
                new SqlParameter("@Email", email),
                new SqlParameter("@Pass", hashedPassword),
                new SqlParameter("@Role", roleId)
            };

            try
            {
                int rows = DbHelper.ExecuteNonQuery(insertQuery, p);
                if (rows > 0)
                {
                    Response.Redirect("Login.aspx?msg=registered");
                }
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Registration Error: " + ex.Message;
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
            }
        }
    }
}