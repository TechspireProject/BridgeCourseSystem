<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddQuestions.aspx.cs" Inherits="BridgePrep.AddQuestions" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>BridgePrep - Add Questions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; font-family: 'Times New Roman', Times, serif; }
        .card { border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Navigation Bar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-success px-4">
            <a class="navbar-brand font-weight-bold" href="ManageQuizzes.aspx">BridgePrep Teacher Portal</a>
            <div class="navbar-nav ms-auto d-flex align-items-center">
                <a class="nav-link text-white me-3" href="ManageMaterials.aspx">Materials</a>
                <a class="nav-link text-white fw-bold me-3" href="ManageQuizzes.aspx">Back to Quizzes</a>
            </div>
        </nav>

        <div class="container mt-4">
            <div class="row">
                <!-- Add Question Form -->
                <div class="col-md-6 mb-4">
                    <div class="card p-4">
                        <h4 class="text-success mb-3">
                            Add Question to: <asp:Label ID="lblQuizTitle" runat="server" CssClass="text-dark"></asp:Label>
                        </h4>

                        <div class="mb-3">
                            <label class="form-label">Question Text</label>
                            <asp:TextBox ID="txtQuestionText" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Enter the question here..."></asp:TextBox>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Option A</label>
                                <asp:TextBox ID="txtOptionA" runat="server" CssClass="form-control" placeholder="Option A"></asp:TextBox>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Option B</label>
                                <asp:TextBox ID="txtOptionB" runat="server" CssClass="form-control" placeholder="Option B"></asp:TextBox>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Option C</label>
                                <asp:TextBox ID="txtOptionC" runat="server" CssClass="form-control" placeholder="Option C"></asp:TextBox>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Option D</label>
                                <asp:TextBox ID="txtOptionD" runat="server" CssClass="form-control" placeholder="Option D"></asp:TextBox>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Correct Option</label>
                            <asp:DropDownList ID="ddlCorrectOption" runat="server" CssClass="form-select">
                                <asp:ListItem Text="-- Select Correct Option --" Value="0" />
                                <asp:ListItem Text="Option A" Value="A" />
                                <asp:ListItem Text="Option B" Value="B" />
                                <asp:ListItem Text="Option C" Value="C" />
                                <asp:ListItem Text="Option D" Value="D" />
                            </asp:DropDownList>
                        </div>

                        <asp:Button ID="btnAddQuestion" runat="server" Text="Add Question" CssClass="btn btn-success w-100 mt-2" OnClick="btnAddQuestion_Click" />
                        <asp:Label ID="lblMsg" runat="server" CssClass="mt-3 d-block text-center"></asp:Label>
                    </div>
                </div>

                <!-- Existing Questions List -->
                <div class="col-md-6 mb-4">
                    <div class="card p-4">
                        <h4 class="text-success mb-3">Questions in this Quiz</h4>
                        <asp:GridView ID="gvQuestions" runat="server" AutoGenerateColumns="False" DataKeyNames="QuestionId"
                                      OnRowDeleting="gvQuestions_RowDeleting" CssClass="table table-hover table-bordered">
                            <Columns>
                                <asp:BoundField DataField="QuestionText" HeaderText="Question" />
                                <asp:BoundField DataField="CorrectOption" HeaderText="Answer" ItemStyle-Width="70px" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center" />
                                <asp:CommandField ShowDeleteButton="True" ButtonType="Button" DeleteText="Delete" ControlStyle-CssClass="btn btn-danger btn-sm" ItemStyle-Width="70px" />
                            </Columns>
                        </asp:GridView>
                        <asp:Label ID="lblNoData" runat="server" Text="No questions added to this quiz yet." Visible="false" CssClass="text-muted"></asp:Label>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>