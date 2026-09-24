using System;
using System.Data;
using System.Data.SqlClient;

namespace BridgePrep
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["msg"] == "registered")
            {
                lblMsg.Text = "Registration successful! Please log in.";
                lblMsg.CssClass = "text-success mt-3 d-block text-center";
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            // Hash user input password to compare with the hash in DB
            string hashedPassword = PasswordHelper.HashPassword(password);

            string query = "SELECT UserId, FullName, RoleId FROM Users WHERE Email = @Email AND PasswordHash = @Pass";
            SqlParameter[] p = {
                new SqlParameter("@Email", email),
                new SqlParameter("@Pass", hashedPassword)
            };

            DataTable dt = DbHelper.ExecuteQuery(query, p);

            if (dt != null && dt.Rows.Count > 0)
            {
                Session["UserId"] = dt.Rows[0]["UserId"].ToString();
                Session["UserName"] = dt.Rows[0]["FullName"].ToString();
                int roleId = Convert.ToInt32(dt.Rows[0]["RoleId"]);
                Session["RoleId"] = roleId;

                if (roleId == 1) // Admin
                {
                    Response.Redirect("AdminDashboard.aspx");
                }
                else if (roleId == 2) // Teacher
                {
                    // Updated: Now routes directly to the Teacher Dashboard
                    Response.Redirect("TeacherDashboard.aspx");
                }
                else if (roleId == 3) // Student
                {
                    Response.Redirect("StudentDashboard.aspx");
                }
            }
            else
            {
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                lblMsg.Text = "Invalid email or password.";
            }
        }
    }
}