using System;
using System.Data.SqlClient;

namespace BridgePrep
{
    public partial class Contact : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtName.Text) ||
                string.IsNullOrWhiteSpace(txtEmail.Text) ||
                string.IsNullOrWhiteSpace(txtMessage.Text))
            {
                lblStatus.Text = "Please fill in all required fields.";
                lblStatus.CssClass = "alert alert-danger";
                return;
            }

            string query = @"INSERT INTO ContactMessages (SenderName, Email, Subject, Message, SentAt) 
                             VALUES (@Name, @Email, @Subject, @Message, GETDATE())";

            SqlParameter[] parameters = {
                new SqlParameter("@Name", txtName.Text.Trim()),
                new SqlParameter("@Email", txtEmail.Text.Trim()),
                new SqlParameter("@Subject", txtSubject.Text.Trim()),
                new SqlParameter("@Message", txtMessage.Text.Trim())
            };

            try
            {
                DbHelper.ExecuteNonQuery(query, parameters);
                lblStatus.Text = "Thank you! Your message has been sent to the administrator.";
                lblStatus.CssClass = "alert alert-success";

                txtName.Text = txtEmail.Text = txtSubject.Text = txtMessage.Text = string.Empty;
            }
            catch (Exception ex)
            {
                lblStatus.Text = "Error sending message: " + ex.Message;
                lblStatus.CssClass = "alert alert-danger";
            }
        }
    }
}