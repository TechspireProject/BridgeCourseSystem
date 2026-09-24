<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageProfile.aspx.cs" Inherits="BridgePrep.ManageProfile" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BridgePrep | My Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --sidebar-bg: #111827;
            --sidebar-hover: #1f2937;
            --accent-green: #10b981;
            --bg-main: #f8fafc;
        }

        body {
            background-color: var(--bg-main);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #334155;
        }

        .sidebar {
            min-height: 100vh;
            background-color: var(--sidebar-bg);
            color: #f8fafc;
        }

        .sidebar-brand {
            font-size: 1.25rem;
            letter-spacing: 0.5px;
        }

        .sidebar a {
            color: #94a3b8;
            text-decoration: none;
            padding: 12px 18px;
            display: flex;
            align-items: center;
            border-radius: 10px;
            font-weight: 500;
            margin-bottom: 6px;
            transition: all 0.2s ease;
        }

        .sidebar a:hover {
            background-color: var(--sidebar-hover);
            color: #ffffff;
        }

        .sidebar a.active {
            background-color: var(--accent-green);
            color: #ffffff;
            font-weight: 600;
        }

        .dash-card {
            border: none;
            border-radius: 16px;
            background: #ffffff;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
            <div class="row">
                <!-- Navigation Sidebar -->
                <div class="col-md-3 col-lg-2 sidebar p-3 d-flex flex-column">
                    <div class="sidebar-brand fw-bold text-center py-3 border-bottom border-secondary mb-4">
                        <i class="fa-solid fa-graduation-cap me-2 text-success"></i>BridgePrep
                    </div>

                    <a href="StudentDashboard.aspx"><i class="fa-solid fa-house me-3"></i>Dashboard</a>
                    <a href="DownloadMaterials.aspx"><i class="fa-solid fa-folder-open me-3"></i>Study Resources</a>
                    <a href="SelectQuiz.aspx"><i class="fa-solid fa-pen-to-square me-3"></i>Take Quiz</a>
                    <a href="ViewResults.aspx"><i class="fa-solid fa-chart-line me-3"></i>Quiz Results</a>
                    <a href="ManageProfile.aspx" class="active"><i class="fa-solid fa-user-gear me-3"></i>My Profile</a>
                    
                    <div class="mt-auto pt-4 border-top border-secondary">
                        <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="text-danger border-0 bg-transparent w-100 text-start p-2">
                            <i class="fa-solid fa-right-from-bracket me-3"></i>Logout
                        </asp:LinkButton>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="col-md-9 col-lg-10 p-4">
                    <div class="mb-4 pb-2 border-bottom">
                        <h3 class="fw-bold mb-1"><i class="fa-solid fa-user-gear me-2 text-success"></i>Account Profile</h3>
                        <p class="text-muted small mb-0">View and manage your personal account information.</p>
                    </div>

                    <asp:Label ID="lblStatus" runat="server" Visible="false" CssClass="alert d-block mb-4"></asp:Label>

                    <div class="row">
                        <div class="col-md-8 col-lg-6">
                            <div class="card dash-card p-4">
                                <h5 class="fw-bold mb-4 border-bottom pb-2">Profile Details</h5>

                                <div class="mb-3">
                                    <label class="form-label text-muted fw-semibold small">Full Name</label>
                                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control form-control-lg rounded-3"></asp:TextBox>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-muted fw-semibold small">Email Address</label>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control form-control-lg rounded-3" ReadOnly="true"></asp:TextBox>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label text-muted fw-semibold small">Role</label>
                                    <asp:TextBox ID="txtRole" runat="server" CssClass="form-control form-control-lg rounded-3 bg-light" ReadOnly="true" Text="Student"></asp:TextBox>
                                </div>

                                <asp:Button ID="btnSave" runat="server" Text="Update Profile" OnClick="btnSave_Click" CssClass="btn btn-success btn-lg rounded-pill w-100 fw-bold" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>