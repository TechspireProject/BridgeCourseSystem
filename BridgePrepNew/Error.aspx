<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="BridgePrep.Error" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Unexpected Error - BridgePrep</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light d-flex align-items-center justify-content-center vh-100">
    <form id="form1" runat="server">
        <div class="card p-5 text-center shadow-sm border-0" style="max-width: 500px;">
            <div class="card-body">
                <h1 class="text-danger fw-bold display-4 mb-3">Oops!</h1>
                <h4 class="text-dark fw-semibold mb-2">Something went wrong</h4>
                <p class="text-muted mb-4">We encountered an unexpected error or database timeout. Don't worry, your data is safe. Please try again or return to your dashboard.</p>
                <a href="Login.aspx" class="btn btn-success px-4 py-2">Return to Home / Login</a>
            </div>
        </div>
    </form>
</body>
</html>