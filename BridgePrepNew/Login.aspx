<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="BridgePrep.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>BridgePrep - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; font-family: 'Times New Roman', Times, serif; }
        .card-custom { max-width: 420px; margin: 80px auto; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
    </style>
    <script>
function validateLoginForm() {
            let email = document.getElementById('<%= txtEmail.ClientID %>').value.trim();
            let password = document.getElementById('<%= txtPassword.ClientID %>').value;
            if (email === "" || password === "") {
                alert("Please enter both email and password.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server" onsubmit="return validateLoginForm();">
        <div class="card card-custom p-4 bg-white">
            <h3 class="text-center text-primary mb-3">BridgePrep Login</h3>
            
            <div class="mb-3">
                <label class="form-label">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="name@example.com"></asp:TextBox>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Password"></asp:TextBox>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn btn-primary w-100 mt-2" OnClick="btnLogin_Click" />
            <asp:Label ID="lblMsg" runat="server" CssClass="text-danger mt-3 d-block text-center"></asp:Label>
            
            <div class="mt-3 text-center">
                <small>Don't have an account? <a href="Register.aspx">Register here</a></small>
            </div>
        </div>
    </form>
</body>
</html>