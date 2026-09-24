<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TeacherDashboard.aspx.cs" Inherits="BridgePrep.TeacherDashboard" MasterPageFile="~/Teacher.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .stat-card { border: none; border-radius: 14px; background: #ffffff; box-shadow: 0 4px 15px rgba(0,0,0,0.03); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header Section -->
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
        <div>
            <h3 class="fw-bold mb-1">Teacher Dashboard</h3>
            <p class="text-muted small mb-0">Overview of course activities, student engagement, and material records.</p>
        </div>
        <span class="fs-6 text-secondary">Welcome, <asp:Label ID="lblTeacherName" runat="server" CssClass="fw-bold text-dark"></asp:Label></span>
    </div>

    <!-- Counter Cards -->
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="card stat-card p-3 border-start border-success border-4">
                <span class="text-muted small fw-semibold">Total Materials</span>
                <h2 class="fw-bold my-1"><asp:Label ID="lblTotalMaterials" runat="server" Text="0"></asp:Label></h2>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stat-card p-3 border-start border-primary border-4">
                <span class="text-muted small fw-semibold">Active Quizzes</span>
                <h2 class="fw-bold my-1"><asp:Label ID="lblTotalQuizzes" runat="server" Text="0"></asp:Label></h2>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stat-card p-3 border-start border-warning border-4">
                <span class="text-muted small fw-semibold">Quiz Submissions</span>
                <h2 class="fw-bold my-1"><asp:Label ID="lblTotalSubmissions" runat="server" Text="0"></asp:Label></h2>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stat-card p-3 border-start border-info border-4">
                <span class="text-muted small fw-semibold">Course Subjects</span>
                <h2 class="fw-bold my-1"><asp:Label ID="lblTotalSubjects" runat="server" Text="0"></asp:Label></h2>
            </div>
        </div>
    </div>

    <!-- Quick Actions Grid -->
    <h5 class="fw-bold mb-3">Quick Actions</h5>
    <div class="row g-3">
        <div class="col-md-4">
            <div class="card stat-card p-4 text-center">
                <i class="fa-solid fa-file-arrow-up fa-2x text-success mb-2"></i>
                <h5>Upload Learning Materials</h5>
                <p class="text-muted small">Publish lecture notes, documents, and reference video links.</p>
                <a href="ManageMaterials.aspx" class="btn btn-outline-success btn-sm rounded-pill">Go to Materials</a>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card p-4 text-center">
                <i class="fa-solid fa-list-check fa-2x text-primary mb-2"></i>
                <h5>Manage Quizzes</h5>
                <p class="text-muted small">Design quizzes, configure total marks, and manage question banks.</p>
                <a href="ManageQuizzes.aspx" class="btn btn-outline-primary btn-sm rounded-pill">Go to Quizzes</a>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card p-4 text-center">
                <i class="fa-solid fa-square-poll-vertical fa-2x text-warning mb-2"></i>
                <h5>Student Performance</h5>
                <p class="text-muted small">Evaluate individual scores and track student progress metrics.</p>
                <a href="ViewPerformance.aspx" class="btn btn-outline-warning btn-sm rounded-pill">View Metrics</a>
            </div>
        </div>
    </div>
</asp:Content>