using System;
using System.IO;

namespace BridgePrep
{
    public partial class TeacherMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        // Highlights active link dynamically
        protected string GetActiveClass(string pageName)
        {
            string currentPage = Path.GetFileName(Request.Url.AbsolutePath);
            return currentPage.Equals(pageName, StringComparison.OrdinalIgnoreCase) ? "active" : "";
        }

        protected void btnSidebarLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}