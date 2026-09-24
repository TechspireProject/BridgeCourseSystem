<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BridgePrep.Default" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BridgePrep - Welcome</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
    <form id="form1" runat="server">
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
                        <li class="nav-item"><a class="nav-link active" href="Default">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href="About">About Us</a></li>
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

        <div class="bg-primary text-white text-center py-5">
            <div class="container py-4">
                <h1 class="display-4 fw-bold">Bridge the Gap to Success</h1>
                <p class="lead mb-4">Empowering students with essential learning materials, practice quizzes, and guided subjects.</p>
                <a href="Register" class="btn btn-light btn-lg me-2 text-primary fw-bold">Get Started</a>
                <a href="Subjects" class="btn btn-outline-light btn-lg">Explore Subjects</a>
            </div>
        </div>

        <div class="container py-5">
            <div class="row text-center g-4">
                <div class="col-md-4">
                    <div class="card h-100 p-4 border-0 shadow-sm">
                        <i class="bi bi-book text-primary display-4 mb-3"></i>
                        <h5>Rich Resources</h5>
                        <p class="text-muted">Access structured learning materials for core bridge topics anytime, anywhere.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card h-100 p-4 border-0 shadow-sm">
                        <i class="bi bi-journal-check text-success display-4 mb-3"></i>
                        <h5>Interactive Quizzes</h5>
                        <p class="text-muted">Test your progress with topic-wise assessments and track your improvement.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card h-100 p-4 border-0 shadow-sm">
                        <i class="bi bi-person-badge text-warning display-4 mb-3"></i>
                        <h5>Teacher Guidance</h5>
                        <p class="text-muted">Learn under modules carefully structured by experienced educators.</p>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>