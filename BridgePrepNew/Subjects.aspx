<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Subjects.aspx.cs" Inherits="BridgePrep.Subjects" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BridgePrep - Subjects</title>
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
                        <li class="nav-item"><a class="nav-link" href="Default">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href="About">About Us</a></li>
                        <li class="nav-item"><a class="nav-link active" href="Subjects">Subjects</a></li>
                        <li class="nav-item"><a class="nav-link" href="Contact">Contact Us</a></li>
                    </ul>
                    <div class="d-flex">
                        <a href="Login" class="btn btn-outline-light btn-sm me-2">Login</a>
                        <a href="Register" class="btn btn-primary btn-sm">Register</a>
                    </div>
                </div>
            </div>
        </nav>

        <div class="container py-5">
            <div class="text-center mb-5">
                <h2 class="fw-bold">Subjects Offered</h2>
                <p class="text-muted">Explore the core subjects designed to prepare you for your bridge modules.</p>
            </div>

            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card h-100 shadow-sm border-0">
                        <div class="card-body text-center p-4">
                            <div class="bg-primary-subtle text-primary rounded-circle p-3 d-inline-block mb-3">
                                <i class="bi bi-journal-bookmark-fill display-5"></i>
                            </div>
                            <h4 class="card-title fw-bold">English</h4>
                            <p class="card-text text-muted">Develop core communication skills, reading comprehension, grammar foundations, and academic writing practice.</p>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card h-100 shadow-sm border-0">
                        <div class="card-body text-center p-4">
                            <div class="bg-success-subtle text-success rounded-circle p-3 d-inline-block mb-3">
                                <i class="bi bi-calculator-fill display-5"></i>
                            </div>
                            <h4 class="card-title fw-bold">Mathematics</h4>
                            <p class="card-text text-muted">Master essential algebra, geometry, basic statistics, and logical quantitative problem-solving tools.</p>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card h-100 shadow-sm border-0">
                        <div class="card-body text-center p-4">
                            <div class="bg-warning-subtle text-warning rounded-circle p-3 d-inline-block mb-3">
                                <i class="bi bi-gear-wide-connected display-5"></i>
                            </div>
                            <h4 class="card-title fw-bold">Science</h4>
                            <p class="card-text text-muted">Gain foundational knowledge across Physics, Chemistry, and introductory biological concepts.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>