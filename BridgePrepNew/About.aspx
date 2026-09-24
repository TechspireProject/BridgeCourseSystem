<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="BridgePrep.About" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BridgePrep - About Us</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
    <form id="form1" runat="server">
        <!-- Navigation Header -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4 shadow-sm">
            <div class="container-fluid">
                <a class="navbar-brand fw-bold" href="Default">
                    <i class="bi bi-mortarboard-fill text-primary me-2"></i>BridgePrep
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item"><a class="nav-link" href="Default">Home</a></li>
                        <li class="nav-item"><a class="nav-link active" href="About">About Us</a></li>
                        <li class="nav-item"><a class="nav-link" href="Subjects">Subjects</a></li>
                        <li class="nav-item"><a class="nav-link" href="Contact">Contact Us</a></li>
                    </ul>
                    <div class="d-flex">
                        <a href="Login" class="btn btn-outline-light btn-sm me-2">Login</a>
                        <a href="Register" class="btn btn-primary btn-sm">Register</a>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Main Content -->
        <div class="container py-5">
            <div class="row align-items-center mb-5">
                <div class="col-lg-6">
                    <h2 class="fw-bold text-dark mb-3">Aim & Purpose</h2>
                    <p class="lead text-muted">BridgePrep is designed to help students bridge knowledge gaps and prepare for academic advancement.</p>
                    <p class="text-secondary">Our targeted bridge courses simplify core concepts in English, Mathematics, and Science. By combining clear reading materials with interactive self-assessments, we help students build confidence and master fundamental skills.</p>
                </div>
                <div class="col-lg-6">
                    <div class="card p-4 border-0 shadow-sm bg-white">
                        <h4 class="text-primary mb-3">Core Principles</h4>
                        <ul class="list-unstyled mb-0">
                            <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i><strong>Accessibility:</strong> High-quality learning resources available anytime.</li>
                            <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i><strong>Targeted Learning:</strong> Structured modules focusing on essential concepts.</li>
                            <li class="mb-0"><i class="bi bi-check-circle-fill text-success me-2"></i><strong>Self-Paced Mastery:</strong> Quizzes designed for practice and progress tracking.</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>