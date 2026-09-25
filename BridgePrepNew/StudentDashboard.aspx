<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentDashboard.aspx.cs" Inherits="BridgePrep.StudentDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BridgePrep | Student Dashboard</title>
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
            display: block;
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
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .dash-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 24px rgba(0, 0, 0, 0.06);
        }

        .table-custom { margin-bottom: 0; }
        .table-custom thead th {
            background-color: #f1f5f9;
            color: #64748b;
            font-size: 0.825rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 700;
            border: none;
            padding: 14px 18px;
        }
        .table-custom tbody td {
            padding: 16px 18px;
            border-bottom: 1px solid #f1f5f9;
            font-weight: 500;
        }

        /* --- Dynamic Subject Cards & Gradients --- */
        .subject-card {
            border-radius: 16px;
            overflow: hidden;
            border: none;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .subject-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
        }

        .subject-card .card-img-top {
            height: 140px;
            object-fit: cover;
        }

        .subject-card .card-body {
            padding: 20px;
            color: #ffffff;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .card-gradient-0 { background: linear-gradient(135deg, #1e3a8a, #3b82f6); }
        .card-gradient-1 { background: linear-gradient(135deg, #065f46, #10b981); }
        .card-gradient-2 { background: linear-gradient(135deg, #581c87, #a855f7); }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
            <div class="row">
                <!-- Navigation Sidebar -->
                <div class="col-md-3 col-lg-2 sidebar p-3 d-flex flex-column">
                    <a href="StudentDashboard.aspx" class="sidebar-brand fw-bold text-center py-3 border-bottom border-secondary mb-4 text-white text-decoration-none">
                        <i class="fa-solid fa-graduation-cap me-2 text-success"></i>BridgePrep
                    </a>

                    <a href="StudentDashboard.aspx" class="active"><i class="fa-solid fa-house me-3"></i>Dashboard</a>
                    <a href="DownloadMaterials.aspx"><i class="fa-solid fa-folder-open me-3"></i>Study Resources</a>
                    <a href="SelectQuiz.aspx"><i class="fa-solid fa-pen-to-square me-3"></i>Take Quiz</a>
                    <a href="ViewResults.aspx"><i class="fa-solid fa-chart-line me-3"></i>Quiz Results</a>
                    <a href="ManageProfile.aspx"><i class="fa-solid fa-user-gear me-3"></i>My Profile</a>
                    
                    <div class="mt-auto pt-4 border-top border-secondary">
                        <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="text-danger border-0 bg-transparent w-100 text-start p-2">
                            <i class="fa-solid fa-right-from-bracket me-3"></i>Logout
                        </asp:LinkButton>
                    </div>
                </div>

                <!-- Main Content Panel -->
                <div class="col-md-9 col-lg-10 p-4">
                    <!-- Top Welcome Bar -->
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                        <div>
                            <h3 class="fw-bold mb-1">Welcome back, <asp:Label ID="lblUserName" runat="server" Text="Student"></asp:Label>! 👋</h3>
                            <p class="text-muted small mb-0">Track your subjects, materials, and overall academic performance.</p>
                        </div>
                        <a href="SelectQuiz.aspx" class="btn btn-success fw-bold px-4 py-2 rounded-pill shadow-sm">
                            <i class="fa-solid fa-play me-2"></i>Take Quiz
                        </a>
                    </div>

                    <!-- Learning Progress Tracker Card -->
                    <div class="card dash-card p-4 mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h5 class="fw-bold mb-0"><i class="fa-solid fa-chart-pie me-2 text-success"></i>Track Learning Progress</h5>
                            <span class="text-muted small">Completed <asp:Label ID="lblCompletedCount" runat="server" Text="0"></asp:Label> of <asp:Label ID="lblTotalQuizzesCount" runat="server" Text="0"></asp:Label> Quizzes</span>
                        </div>
                        <p class="text-muted small mb-3">Monitor your overall achievements and quiz progression.</p>
                        
                        <div class="progress" style="height: 18px; border-radius: 9px; background-color: #f1f5f9;">
                            <div id="progressBarFill" runat="server" class="progress-bar bg-success progress-bar-striped progress-bar-animated" role="progressbar" style="width: 0%; font-weight: 600; font-size: 0.8rem;" aria-valuemin="0" aria-valuemax="100">0%</div>
                        </div>
                    </div>

                    <!-- Choose Your Subject Section -->
                    <div class="mb-4">
                        <div class="text-center mb-4">
                            <h4 class="fw-bold text-dark mb-1">Choose Your Subject</h4>
                            <p class="text-muted small">Select a core subject to filter your learning metrics and materials.</p>
                        </div>
                        
                        <div class="row g-4">
                            <asp:Repeater ID="rptSubjects" runat="server">
                                <ItemTemplate>
                                    <div class="col-md-4">
                                        <div class='<%# "card subject-card shadow-sm card-gradient-" + (Container.ItemIndex % 3) %>'>
                                            <img src="https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=500&q=80" class="card-img-top" alt='<%# Eval("SubjectName") %>'>
                                            <div class="card-body">
                                                <div>
                                                    <div class="mb-2"><i class="fa-solid fa-book-open fa-lg"></i></div>
                                                    <h5 class="fw-bold mb-2"><%# Eval("SubjectName") %></h5>
                                                    <p class="small text-white-50 mb-3">Explore interactive quizzes and resources for <%# Eval("SubjectName") %>.</p>
                                                </div>
                                                <div class="d-flex justify-content-between align-items-center pt-2 border-top border-white-50">
                                                    <span class="small text-white-50"><i class="fa-regular fa-file-lines me-1"></i> Active Course</span>
                                                    <a href='<%# "DownloadMaterials.aspx?subject=" + Server.UrlEncode((Eval("SubjectName") ?? "").ToString()) %>' class="text-white fw-bold text-decoration-none small">View Materials &rarr;</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>

                    <!-- Available Quizzes Section -->
                    <div class="card dash-card p-4 mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold mb-0"><i class="fa-solid fa-pen-to-square me-2 text-success"></i>Available Quizzes</h5>
                            <a href="SelectQuiz.aspx" class="btn btn-sm btn-outline-secondary rounded-pill px-3">View All</a>
                        </div>
                        
                        <asp:Label ID="lblNoQuizzes" runat="server" Text="No active quizzes available." Visible="false" CssClass="alert alert-light text-muted d-block mb-0"></asp:Label>
                        
                        <div class="table-responsive">
                            <asp:GridView ID="gvQuizzes" runat="server" AutoGenerateColumns="false" CssClass="table table-custom align-middle" GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="QuizTitle" HeaderText="Quiz Title" />
                                    <asp:BoundField DataField="SubjectName" HeaderText="Subject" />
                                    <asp:BoundField DataField="TotalMarks" HeaderText="Total Marks" />
                                    <asp:TemplateField HeaderText="Action" ItemStyle-CssClass="text-end" HeaderStyle-CssClass="text-end">
                                        <ItemTemplate>
                                            <a href='TakeQuiz.aspx?QuizId=<%# Eval("QuizId") %>' class="btn btn-sm btn-success rounded-pill px-4 fw-semibold">
                                                Start <i class="fa-solid fa-arrow-right ms-1"></i>
                                            </a>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>

                    <!-- Recent Attempts Section -->
                    <div class="card dash-card p-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold mb-0"><i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i>Recent Quiz Submissions</h5>
                            <a href="ViewResults.aspx" class="btn btn-sm btn-outline-secondary rounded-pill px-3">Full Report</a>
                        </div>

                        <asp:Label ID="lblNoAttempts" runat="server" Text="No quizzes completed yet." Visible="false" CssClass="alert alert-light text-muted d-block mb-0"></asp:Label>

                        <div class="table-responsive">
                            <asp:GridView ID="gvRecentAttempts" runat="server" AutoGenerateColumns="false" CssClass="table table-custom align-middle" GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="QuizTitle" HeaderText="Quiz Title" />
                                    <asp:BoundField DataField="SubjectName" HeaderText="Subject" />
                                    <asp:BoundField DataField="Score" HeaderText="Score" />
                                    <asp:BoundField DataField="TotalMarks" HeaderText="Out Of" />
                                    <asp:BoundField DataField="TakenAt" HeaderText="Date Submitted" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </form>
</body>
</html>