<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageSubjects.aspx.cs" Inherits="BridgePrep.ManageSubjects" MasterPageFile="~/Teacher.Master" %>

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
            <h3 class="fw-bold mb-1">Manage Course Content</h3>
            <p class="text-muted small mb-0">Add new course subjects and manage existing entries.</p>
        </div>
    </div>

    <div class="row">
        <!-- Add Subject Form -->
        <div class="col-md-5 mb-4">
            <div class="card p-4">
                <h4 class="text-success fw-bold mb-3">Add New Subject</h4>
                <div class="mb-3">
                    <label class="form-label fw-bold">Subject Name</label>
                    <asp:TextBox ID="txtSubjectName" runat="server" CssClass="form-control" placeholder="e.g., Web Design"></asp:TextBox>
                </div>
                <asp:Button ID="btnAddSubject" runat="server" Text="Add Subject" CssClass="btn btn-success w-100 mt-2" OnClick="btnAddSubject_Click" />
                <asp:Label ID="lblMsg" runat="server" CssClass="mt-3 d-block text-center"></asp:Label>
            </div>
        </div>

        <!-- Existing Subjects List -->
        <div class="col-md-7 mb-4">
            <div class="card p-4">
                <h4 class="text-success fw-bold mb-3">Existing Subjects</h4>
                <asp:GridView ID="gvSubjects" runat="server" AutoGenerateColumns="False" DataKeyNames="SubjectId" 
                              OnRowDeleting="gvSubjects_RowDeleting" CssClass="table table-bordered table-hover align-middle">
                    <Columns>
                        <asp:BoundField DataField="SubjectId" HeaderText="ID" ItemStyle-Width="60px" />
                        <asp:BoundField DataField="SubjectName" HeaderText="Subject Title" />
                        <asp:CommandField ShowDeleteButton="True" ButtonType="Button" DeleteText="Remove" ControlStyle-CssClass="btn btn-danger btn-sm" ItemStyle-Width="90px" />
                    </Columns>
                </asp:GridView>
                <asp:Label ID="lblNoData" runat="server" Text="No subjects found." Visible="false" CssClass="text-muted"></asp:Label>
            </div>
        </div>
    </div>
</asp:Content>