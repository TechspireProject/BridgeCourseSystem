<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TakeQuiz.aspx.cs" Inherits="BridgePrep.TakeQuiz" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BridgePrep | Take Quiz</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .quiz-container {
            max-width: 850px;
            margin: 30px auto;
        }
        .quiz-header-card {
            background: linear-gradient(135deg, #1b4332, #2d6a4f);
            color: #ffffff;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.08);
        }
        .progress-bar-custom {
            height: 10px;
            border-radius: 5px;
            background-color: #52b788;
        }
        .question-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.04);
            margin-bottom: 24px;
            background: #ffffff;
            transition: transform 0.2s;
        }
        .question-card:hover {
            transform: translateY(-2px);
        }
        
        /* Option Card Styling */
        .option-label {
            display: flex;
            align-items: center;
            justify-content: space-between;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 14px 20px;
            cursor: pointer;
            transition: all 0.2s ease-in-out;
            width: 100%;
            background-color: #ffffff;
            font-weight: 500;
            color: #1e293b;
            margin-bottom: 10px;
        }
        .option-label:hover {
            border-color: #2d6a4f;
            background-color: #f8fafc;
        }
        .option-input {
            transform: scale(1.2);
            margin-right: 12px;
            accent-color: #2d6a4f;
        }

        /* Full Background Block Coloring */
        .correct-box {
            background-color: #d1e7dd !important;
            border-color: #198754 !important;
            color: #0f5132 !important;
            font-weight: 600;
        }
        .wrong-box {
            background-color: #f8d7da !important;
            border-color: #dc3545 !important;
            color: #842029 !important;
            font-weight: 600;
        }

        .result-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            background: #ffffff;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container quiz-container">
            
            <!-- Quiz Header Banner & Progress Bar -->
            <div class="quiz-header-card mb-4">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h3 class="fw-bold mb-0">
                        <i class="fa-solid fa-graduation-cap me-2"></i>
                        <asp:Label ID="lblQuizTitle" runat="server" Text="Loading Quiz..."></asp:Label>
                    </h3>
                    <span class="badge bg-light text-dark px-3 py-2 rounded-pill fw-semibold">
                        Questions: <asp:Label ID="lblTotalQuestionCount" runat="server" Text="0"></asp:Label>
                    </span>
                </div>
                <p class="text-white-50 mb-3 small">Read each question carefully and select your best answer before submitting.</p>
                
                <!-- Progress Bar -->
                <div class="progress" style="height: 10px; background-color: rgba(255,255,255,0.2);">
                    <div id="quizProgressBar" class="progress-bar progress-bar-custom" role="progressbar" style="width: 100%;" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
            </div>

            <!-- Error / Warning Message -->
            <asp:Label ID="lblNoQuestions" runat="server" CssClass="alert alert-warning text-center d-block fw-semibold mb-4" Visible="false"></asp:Label>

            <!-- Quiz Questions Repeater -->
            <asp:Repeater ID="rptQuestions" runat="server" OnItemDataBound="rptQuestions_ItemDataBound">
                <ItemTemplate>
                    <div class="card question-card p-4">
                        <asp:HiddenField ID="hfQuestionId" runat="server" Value='<%# Eval("QuestionId") %>' />
                        <asp:HiddenField ID="hfCorrectOption" runat="server" Value='<%# Eval("CorrectOption") %>' />

                        <h5 class="fw-bold text-dark mb-3">
                            <span class="text-success me-2">Q<%# Container.ItemIndex + 1 %>.</span><%# Eval("QuestionText") %>
                        </h5>

                        <div class="options-group">
                            <asp:Repeater ID="rptOptions" runat="server">
                                <ItemTemplate>
                                    <label class="option-label <%# Eval("CssClass") %>">
                                        <div class="d-flex align-items-center w-100">
                                            <input type="radio" name="q_<%# Eval("QuestionId") %>" value="<%# Eval("Value") %>" 
                                                   class="option-input" <%# (bool)Eval("IsSelected") ? "checked='checked'" : "" %> 
                                                   <%# (bool)Eval("IsDisabled") ? "disabled='disabled'" : "" %> />
                                            <span><%# Eval("Text") %></span>
                                        </div>
                                        <%# Eval("IconHtml") %>
                                    </label>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <!-- Submit Quiz Button -->
            <div class="text-center mb-5">
                <asp:Button ID="btnSubmitQuiz" runat="server" Text="Submit Quiz Answers" 
                    CssClass="btn btn-success btn-lg px-5 py-3 fw-bold shadow-sm rounded-pill" 
                    OnClick="btnSubmitQuiz_Click" Visible="false" />
            </div>

            <!-- Quiz Results Panel -->
            <asp:Panel ID="pnlResult" runat="server" Visible="false" CssClass="card result-card p-5 text-center my-4">
                <div class="mb-3">
                    <i class="fa-solid fa-circle-check text-success fa-4x mb-3"></i>
                    <h2 class="fw-bold text-dark">Quiz Completed Successfully!</h2>
                    <p class="text-muted">Here is your final performance evaluation:</p>
                </div>
                
                <div class="d-flex justify-content-center align-items-center my-4">
                    <div class="p-4 bg-light rounded-4 border px-5">
                        <h1 class="display-3 fw-bold text-success mb-0">
                            <asp:Label ID="lblScore" runat="server" Text="0"></asp:Label>
                            <span class="fs-4 text-muted">/ <asp:Label ID="lblTotalMarks" runat="server" Text="0"></asp:Label></span>
                        </h1>
                        <span class="text-uppercase tracking-wider fw-bold text-muted small">Final Score</span>
                    </div>
                </div>

                <div class="mt-3">
                    <a href="StudentDashboard.aspx" class="btn btn-outline-success btn-lg px-4 rounded-pill me-2">
                        <i class="fa-solid fa-house me-2"></i>Back to Dashboard
                    </a>
                    <a href="SelectQuiz.aspx" class="btn btn-success btn-lg px-4 rounded-pill">
                        <i class="fa-solid fa-rotate-right me-2"></i>Take Another Quiz
                    </a>
                </div>
            </asp:Panel>

        </div>
    </form>
</body>
</html>