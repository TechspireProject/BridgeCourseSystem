<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="BridgePrep.Register" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>BridgePrep - Register</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; font-family: 'Times New Roman', Times, serif; }
        .card-custom { max-width: 450px; margin: 60px auto; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
    </style>
    <script>
        function validateRegisterForm() {
            let name = document.getElementById('<%= txtFullName.ClientID %>').value.trim();
            let email = document.getElementById('<%= txtEmail.ClientID %>').value.trim();
            let password = document.getElementById('<%= txtPassword.ClientID %>').value;

            if (name === "" || email === "" || password === "") {
                alert("Please fill in all fields.");
                return false;
            }
            if (password.length < 6) {
                alert("Password must be at least 6 characters long.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server" onsubmit="return validateRegisterForm();">
        <div class="card card-custom p-4 bg-white">
            <h3 class="text-center text-primary mb-3">Create BridgePrep Account</h3>
            
            <div class="mb-3">
                <label class="form-label">Full Name</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="John Doe"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label class="form-label">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="name@example.com"></asp:TextBox>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Minimum 6 characters"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label class="form-label">Account Role</label>
                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select">
                    <asp:ListItem Value="3">Student</asp:ListItem>
                    <asp:ListItem Value="2">Teacher</asp:ListItem>
                </asp:DropDownList>
            </div>

            <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-primary w-100 mt-2" OnClick="btnRegister_Click" />
            <asp:Label ID="lblMsg" runat="server" CssClass="text-danger mt-3 d-block text-center"></asp:Label>
            
            <div class="mt-3 text-center">
                <small>Already have an account? <a href="Login.aspx">Login here</a></small>
            </div>
        </div>
    </form>
</body>
</html>