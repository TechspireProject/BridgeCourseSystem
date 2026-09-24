<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageQuizzes.aspx.cs" Inherits="BridgePrep.ManageQuizzes" MasterPageFile="~/Teacher.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .card { 
            border-radius: 10px; 
            box-shadow: 0 4px 10px rgba(0,0,0,0.05); 
            border: none;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header Bar -->
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
        <div>
            <h3 class="fw-bold mb-1">Manage Quizzes</h3>
            <p class="text-muted small mb-0">Create new quizzes and manage existing question sets.</p>
        </div>
        <span class="fs-6 text-secondary">Welcome, <asp:Label ID="lblTeacherName" runat="server" CssClass="fw-bold text-dark"></asp:Label></span>
    </div>

    <div class="row">
        <!-- Create Quiz Form -->
        <div class="col-md-5 mb-4">
            <div class="card p-4">
                <h4 class="text-success mb-3 fw-bold">Create New Quiz</h4>
                
                <div class="mb-3">
                    <label class="form-label fw-bold">Quiz Title</label>
                    <asp:TextBox ID="txtQuizTitle" runat="server" CssClass="form-control" placeholder="e.g., Chapter 1 Quiz"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Subject</label>
                    <asp:DropDownList ID="ddlSubjects" runat="server" CssClass="form-select"></asp:DropDownList>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Total Marks</label>
                    <asp:TextBox ID="txtTotalMarks" runat="server" TextMode="Number" CssClass="form-control" placeholder="10"></asp:TextBox>
                </div>

                <asp:Button ID="btnCreateQuiz" runat="server" Text="Create Quiz" CssClass="btn btn-success w-100 mt-2" OnClick="btnCreateQuiz_Click" />
                <asp:Label ID="lblMsg" runat="server" CssClass="mt-3 d-block text-center"></asp:Label>
            </div>
        </div>

        <!-- Existing Quizzes List -->
        <div class="col-md-7 mb-4">
            <div class="card p-4">
                <h4 class="text-success mb-3 fw-bold">Available Quizzes</h4>
                <asp:GridView ID="gvQuizzes" runat="server" AutoGenerateColumns="False" DataKeyNames="QuizId"
                              OnRowDeleting="gvQuizzes_RowDeleting" CssClass="table table-hover table-bordered align-middle">
                    <Columns>
                        <asp:BoundField DataField="QuizTitle" HeaderText="Quiz Title" />
                        <asp:BoundField DataField="SubjectName" HeaderText="Subject" />
                        <asp:BoundField DataField="TotalMarks" HeaderText="Total Marks" />
                        <asp:TemplateField HeaderText="Add Questions">
                            <ItemTemplate>
                                <a href='AddQuestions.aspx?QuizId=<%# Eval("QuizId") %>' class="btn btn-sm btn-outline-primary">Manage Questions</a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:CommandField ShowDeleteButton="True" ButtonType="Button" DeleteText="Delete" ControlStyle-CssClass="btn btn-danger btn-sm" />
                    </Columns>
                </asp:GridView>
                <asp:Label ID="lblNoData" runat="server" Text="No quizzes created yet." Visible="false" CssClass="text-muted"></asp:Label>
            </div>
        </div>
    </div>
</asp:Content>