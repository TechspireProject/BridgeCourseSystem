<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewResults.aspx.cs" Inherits="BridgePrep.ViewResults" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>BridgePrep | Quiz Results & Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root { --sidebar-bg: #111827; --accent-green: #10b981; }
        body { background-color: #f8fafc; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .sidebar { min-height: 100vh; background-color: var(--sidebar-bg); color: #f8fafc; }
        .sidebar-brand { font-size: 1.25rem; }
        .sidebar a { color: #94a3b8; text-decoration: none; padding: 12px 18px; display: flex; align-items: center; border-radius: 10px; margin-bottom: 6px; }
        .sidebar a:hover, .sidebar a.active { background-color: #1f2937; color: #fff; }
        .sidebar a.active { background-color: var(--accent-green); }
        .dash-card { border: none; border-radius: 16px; background: #fff; box-shadow: 0 4px 20px rgba(0,0,0,0.03); }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-3 col-lg-2 sidebar p-3 d-flex flex-column">
                    <div class="sidebar-brand fw-bold text-center py-3 border-bottom border-secondary mb-4">
                        <i class="fa-solid fa-graduation-cap me-2 text-success"></i>BridgePrep
                    </div>
                    <a href="StudentDashboard.aspx"><i class="fa-solid fa-house me-3"></i>Dashboard</a>
                    <a href="DownloadMaterials.aspx"><i class="fa-solid fa-folder-open me-3"></i>Study Resources</a>
                    <a href="SelectQuiz.aspx"><i class="fa-solid fa-pen-to-square me-3"></i>Take Quiz</a>
                    <a href="ViewResults.aspx" class="active"><i class="fa-solid fa-chart-line me-3"></i>Quiz Results</a>
                    <a href="ManageProfile.aspx"><i class="fa-solid fa-user-gear me-3"></i>My Profile</a>
                </div>

                <div class="col-md-9 col-lg-10 p-4">
                    <h3 class="fw-bold mb-1">Your Quiz Results</h3>
                    <p class="text-muted small mb-4">Check your scores and feedback from submitted quizzes.</p>

                    <div class="card dash-card p-4">
                        <asp:GridView ID="gvResults" runat="server" AutoGenerateColumns="False" CssClass="table table-hover align-middle">
                            <Columns>
                                <asp:BoundField DataField="QuizTitle" HeaderText="Quiz Title" />
                                <asp:BoundField DataField="SubjectName" HeaderText="Subject" />
                                <asp:BoundField DataField="Score" HeaderText="Obtained Score" ItemStyle-CssClass="fw-bold text-success" />
                                <asp:BoundField DataField="TotalMarks" HeaderText="Total Marks" />
                                <asp:BoundField DataField="TakenAt" HeaderText="Date Taken" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                            </Columns>
                        </asp:GridView>
                        <asp:Label ID="lblNoData" runat="server" Text="No quiz records found." Visible="false" CssClass="text-muted d-block py-3"></asp:Label>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>