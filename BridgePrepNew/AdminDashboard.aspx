<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="BridgePrep.AdminDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>BridgePrep - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .sidebar { min-height: 100vh; background-color: #2c3e50; }
        .sidebar a { color: #ecf0f1; text-decoration: none; padding: 12px 20px; display: block; }
        .sidebar a:hover, .sidebar a.active { background-color: #34495e; color: #3498db; }
        .card { border-radius: 10px; border: none; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .stat-card { border-left: 4px solid #3498db; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Top Navigation Bar -->
        <nav class="navbar navbar-dark bg-dark px-4 shadow-sm">
            <a class="navbar-brand font-weight-bold" href="AdminDashboard.aspx">
                <i class="bi bi-shield-lock-fill text-primary me-2"></i>BridgePrep Admin Portal
            </a>
            <div class="ms-auto d-flex align-items-center">
                <span class="text-white me-3">Admin: <asp:Label ID="lblAdminName" runat="server" Font-Bold="true"></asp:Label></span>
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-outline-light btn-sm" OnClick="btnLogout_Click" />
            </div>
        </nav>

        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar Menu -->
                <nav class="col-md-2 d-none d-md-block sidebar py-3 px-0">
                    <a href="#dashboard" class="active"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a>
                    <a href="#users"><i class="bi bi-people me-2"></i>Manage Users</a>
                    <a href="#subjects"><i class="bi bi-book me-2"></i>Manage Subjects</a>
                    <a href="#materials"><i class="bi bi-folder2-open me-2"></i>Learning Materials</a>
                    <a href="#quizzes"><i class="bi bi-journal-check me-2"></i>Manage Quizzes</a>
                    <a href="#reports"><i class="bi bi-bar-chart-line me-2"></i>Generate Reports</a>
                </nav>

                <!-- Main Content Area -->
                <main class="col-md-10 ms-sm-auto px-md-4 py-4">
                    
                    <!-- Global Message Alert -->
                    <asp:Label ID="lblMsg" runat="server" CssClass="mb-3 d-block"></asp:Label>

                    <!-- Feature 1: Admin Dashboard (System Overview) -->
                    <section id="dashboard" class="mb-5">
                        <h2 class="h4 mb-3 border-bottom pb-2 text-secondary">Dashboard Overview</h2>
                        <div class="row g-3">
                            <div class="col-md-3">
                                <div class="card p-3 stat-card">
                                    <h6 class="text-muted">Total Users</h6>
                                    <h3><asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label></h3>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card p-3 stat-card" style="border-left-color: #2ecc71;">
                                    <h6 class="text-muted">Active Subjects</h6>
                                    <h3><asp:Label ID="lblTotalSubjects" runat="server" Text="0"></asp:Label></h3>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card p-3 stat-card" style="border-left-color: #e67e22;">
                                    <h6 class="text-muted">Total Materials</h6>
                                    <h3><asp:Label ID="lblTotalMaterials" runat="server" Text="0"></asp:Label></h3>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card p-3 stat-card" style="border-left-color: #e74c3c;">
                                    <h6 class="text-muted">Total Quizzes</h6>
                                    <h3><asp:Label ID="lblTotalQuizzes" runat="server" Text="0"></asp:Label></h3>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- Feature 2: Manage Users -->
                    <section id="users" class="mb-5">
                        <div class="card p-4">
                            <h4 class="text-dark mb-3"><i class="bi bi-people me-2"></i>Manage Users (Students & Teachers)</h4>
                            
                            <!-- Add New User Form Inline -->
                            <div class="row g-2 mb-3 bg-light p-3 rounded">
                                <h6>Add New Account</h6>
                                <div class="col-md-3">
                                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control form-control-sm" Placeholder="Full Name"></asp:TextBox>
                                </div>
                                <div class="col-md-3">
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control form-control-sm" Placeholder="Email"></asp:TextBox>
                                </div>
                                <div class="col-md-2">
                                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control form-control-sm" Placeholder="Password"></asp:TextBox>
                                </div>
                                <div class="col-md-2">
                                    <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select form-select-sm">
                                        <asp:ListItem Value="2" Text="Teacher"></asp:ListItem>
                                        <asp:ListItem Value="3" Text="Student"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-2">
                                    <asp:Button ID="btnAddUser" runat="server" Text="Add User" CssClass="btn btn-primary btn-sm w-100" OnClick="btnAddUser_Click" />
                                </div>
                            </div>

                            <!-- Users Grid with Inline Editing Support -->
                            <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" DataKeyNames="UserId" 
                                          OnRowDeleting="gvUsers_RowDeleting" 
                                          OnRowEditing="gvUsers_RowEditing" 
                                          OnRowUpdating="gvUsers_RowUpdating" 
                                          OnRowCancelingEdit="gvUsers_RowCancelingEdit"
                                          OnRowDataBound="gvUsers_RowDataBound"
                                          CssClass="table table-striped table-bordered align-middle">
                                <Columns>
                                    <asp:BoundField DataField="UserId" HeaderText="User ID" ReadOnly="True" />
                                    
                                    <asp:TemplateField HeaderText="Full Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblFullName" runat="server" Text='<%# Eval("FullName") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtEditFullName" runat="server" Text='<%# Eval("FullName") %>' CssClass="form-control form-control-sm"></asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Email">
                                        <ItemTemplate>
                                            <asp:Label ID="lblEmail" runat="server" Text='<%# Eval("Email") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtEditEmail" runat="server" Text='<%# Eval("Email") %>' CssClass="form-control form-control-sm"></asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Role">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRole" runat="server" Text='<%# Eval("RoleName") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:HiddenField ID="hfRoleId" runat="server" Value='<%# Eval("RoleId") %>' />
                                            <asp:DropDownList ID="ddlEditRole" runat="server" CssClass="form-select form-select-sm">
                                                <asp:ListItem Value="2" Text="Teacher"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Student"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Admin"></asp:ListItem>
                                            </asp:DropDownList>
                                        </EditItemTemplate>
                                    </asp:TemplateField>

                                    <asp:BoundField DataField="CreatedAt" HeaderText="Registered Date" ReadOnly="True" DataFormatString="{0:yyyy-MM-dd}" />

                                    <asp:CommandField ShowEditButton="True" ButtonType="Button" EditText="Edit" UpdateText="Save" CancelText="Cancel" ControlStyle-CssClass="btn btn-outline-primary btn-sm me-1" />
                                    <asp:CommandField ShowDeleteButton="True" ButtonType="Button" DeleteText="Remove" ControlStyle-CssClass="btn btn-danger btn-sm" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </section>

                    <!-- Feature 3: Manage Subjects -->
                    <section id="subjects" class="mb-5">
                        <div class="card p-4">
                            <h4 class="text-dark mb-3"><i class="bi bi-book me-2"></i>Manage Subjects</h4>
                            <p class="text-muted">Control modules for core curriculum.</p>
                            <asp:GridView ID="gvSubjects" runat="server" AutoGenerateColumns="False" CssClass="table table-hover">
                                <Columns>
                                    <asp:BoundField DataField="SubjectId" HeaderText="ID" />
                                    <asp:BoundField DataField="SubjectName" HeaderText="Subject Module" />
                                    <asp:BoundField DataField="Description" HeaderText="Description" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </section>

                    <!-- Feature 4 & 5: Learning Materials & Quizzes Overview Grid -->
                    <div class="row mb-5">
                        <div class="col-md-6" id="materials">
                            <div class="card p-4 h-100">
                                <h4 class="text-dark mb-3"><i class="bi bi-folder2-open me-2"></i>Learning Materials</h4>
                                
                                <asp:Label ID="lblNoMaterials" runat="server" Text="No learning materials uploaded yet." Visible="false" CssClass="alert alert-light text-muted d-block mb-3"></asp:Label>
                                
                                <asp:GridView ID="gvMaterials" runat="server" AutoGenerateColumns="False" DataKeyNames="MaterialId" 
                                              OnRowDeleting="gvMaterials_RowDeleting" CssClass="table table-sm table-striped">
                                    <Columns>
                                        <asp:BoundField DataField="Title" HeaderText="Material Title" />
                                        <asp:BoundField DataField="SubjectName" HeaderText="Subject" />
                                        <asp:CommandField ShowDeleteButton="True" ButtonType="Button" DeleteText="Delete" ControlStyle-CssClass="btn btn-outline-danger btn-sm" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>

                        <div class="col-md-6" id="quizzes">
                            <div class="card p-4 h-100">
                                <h4 class="text-dark mb-3"><i class="bi bi-journal-check me-2"></i>Manage Quizzes</h4>
                                <asp:GridView ID="gvQuizzes" runat="server" AutoGenerateColumns="False" DataKeyNames="QuizId" 
                                              OnRowDeleting="gvQuizzes_RowDeleting" CssClass="table table-sm table-striped">
                                    <Columns>
                                        <asp:BoundField DataField="QuizTitle" HeaderText="Quiz Title" />
                                        <asp:BoundField DataField="SubjectName" HeaderText="Subject" />
                                        <asp:CommandField ShowDeleteButton="True" ButtonType="Button" DeleteText="Delete" ControlStyle-CssClass="btn btn-outline-danger btn-sm" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>

                    <!-- Feature 6: Reports -->
                    <div class="row mb-5">
                        <div class="col-md-12" id="reports">
                            <div class="card p-4">
                                <h4 class="text-dark mb-3"><i class="bi bi-bar-chart-line me-2"></i>Generate Reports</h4>
                                <p class="text-muted">Export system activity and student performance logs.</p>
                                <div class="d-flex gap-2">
                                    <asp:Button ID="btnUserReport" runat="server" Text="Export User Activity (CSV)" CssClass="btn btn-outline-primary" OnClick="btnUserReport_Click" />
                                    <asp:Button ID="btnPerformanceReport" runat="server" Text="Export Student Marks" CssClass="btn btn-outline-success" OnClick="btnPerformanceReport_Click" />
                                </div>
                            </div>
                        </div>
                    </div>

                </main>
            </div>
        </div>
    </form>
</body>
</html>