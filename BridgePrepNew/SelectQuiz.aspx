<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SelectQuiz.aspx.cs" Inherits="BridgePrep.SelectQuiz" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>BridgePrep | Complete Subject Quizzes</title>
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
                <!-- Sidebar Navigation -->
                <div class="col-md-3 col-lg-2 sidebar p-3 d-flex flex-column">
                    <div class="sidebar-brand fw-bold text-center py-3 border-bottom border-secondary mb-4">
                        <i class="fa-solid fa-graduation-cap me-2 text-success"></i>BridgePrep
                    </div>
                    <a href="StudentDashboard.aspx"><i class="fa-solid fa-house me-3"></i>Dashboard</a>
                    <a href="DownloadMaterials.aspx"><i class="fa-solid fa-folder-open me-3"></i>Study Resources</a>
                    <a href="SelectQuiz.aspx" class="active"><i class="fa-solid fa-pen-to-square me-3"></i>Take Quiz</a>
                    <a href="ViewResults.aspx"><i class="fa-solid fa-chart-line me-3"></i>Quiz Results</a>
                    <a href="ManageProfile.aspx"><i class="fa-solid fa-user-gear me-3"></i>My Profile</a>
                </div>

                <!-- Main Content Area -->
                <div class="col-md-9 col-lg-10 p-4">
                    <h3 class="fw-bold mb-1">Subject Quizzes</h3>
                    <p class="text-muted small mb-4">Complete your English, Mathematics, and Science quizzes.</p>

                    <div class="card dash-card p-4">
                        <asp:GridView ID="gvAvailableQuizzes" runat="server" AutoGenerateColumns="False" CssClass="table table-hover align-middle">
                            <Columns>
                                <asp:BoundField DataField="QuizTitle" HeaderText="Quiz Title" />
                                <asp:BoundField DataField="SubjectName" HeaderText="Subject" />
                                <asp:BoundField DataField="TotalMarks" HeaderText="Total Marks" ItemStyle-Width="100px" />
                                
                                <asp:TemplateField HeaderText="Attempts" ItemStyle-Width="100px">
                                    <ItemTemplate>
                                        <span class="badge bg-secondary rounded-pill px-3"><%# Eval("TotalAttempts") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Best Score" ItemStyle-Width="110px">
                                    <ItemTemplate>
                                        <span class="badge bg-success rounded-pill px-3"><%# Eval("BestScore") %> / <%# Eval("TotalMarks") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Latest Score" ItemStyle-Width="110px">
                                    <ItemTemplate>
                                        <span class="badge bg-info text-dark rounded-pill px-3"><%# Eval("LatestScore") %> / <%# Eval("TotalMarks") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Action" ItemStyle-Width="160px">
                                    <ItemTemplate>
                                        <a href='TakeQuiz.aspx?QuizId=<%# Eval("QuizId") %>' class="btn btn-success btn-sm rounded-pill px-3">
                                            <%# Convert.ToInt32(Eval("TotalAttempts")) > 0 ? "Retake Quiz" : "Start Quiz" %>
                                        </a>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>

                        <asp:Label ID="lblNoQuizzes" runat="server" Text="No quizzes available at the moment." Visible="false" CssClass="text-muted py-3 d-block"></asp:Label>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>