using System;
using System.IO;
using System.Web.UI;

namespace BridgePrep
{
    public partial class TeacherMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected string GetActiveClass(string pageName)
        {
            string currentPage = Path.GetFileName(Request.Url.AbsolutePath);
            return string.Equals(currentPage, pageName, StringComparison.OrdinalIgnoreCase) ? "active" : "";
        }

        protected void btnSidebarLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}