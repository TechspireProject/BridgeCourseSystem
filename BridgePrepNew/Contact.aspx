<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="BridgePrep.Contact" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>BridgePrep - Contact Us</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
    <form id="form1" runat="server">
        <!-- Navigation Header -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4 shadow-sm">
            <div class="container-fluid">
                <a class="navbar-brand font-weight-bold" href="Default.aspx">
                    <i class="bi bi-mortarboard-fill text-primary me-2"></i>BridgePrep
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item"><a class="nav-link" href="Default.aspx">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href="About.aspx">About Us</a></li>
                        <li class="nav-item"><a class="nav-link" href="SubjectsPublic.aspx">Subjects</a></li>
                        <li class="nav-item"><a class="nav-link active" href="Contact.aspx">Contact Us</a></li>
                    </ul>
                    <div class="d-flex">
                        <a href="Login.aspx" class="btn btn-outline-light btn-sm me-2">Login</a>
                        <a href="Register.aspx" class="btn btn-primary btn-sm">Register</a>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Form Content -->
        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card p-4 shadow-sm border-0">
                        <h3 class="mb-3">Reach Out to Us</h3>
                        <p class="text-muted">Have questions or need assistance? Send a message directly to system administrators.</p>
                        
                        <asp:Label ID="lblStatus" runat="server" CssClass="mb-3 d-block"></asp:Label>

                        <div class="mb-3">
                            <label class="form-label">Your Name</label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" Placeholder="Full Name"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email Address</label>
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" Placeholder="name@example.com"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Subject</label>
                            <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" Placeholder="Inquiry Subject"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Message</label>
                            <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" Placeholder="Type your question or comment here..."></asp:TextBox>
                        </div>
                        <asp:Button ID="btnSubmit" runat="server" Text="Send Message" CssClass="btn btn-primary w-100" OnClick="btnSubmit_Click" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html> 