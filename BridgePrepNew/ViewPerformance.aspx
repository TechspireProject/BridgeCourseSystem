<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewPerformance.aspx.cs" Inherits="BridgePrep.ViewPerformance" MasterPageFile="~/Teacher.Master" %>

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
            <h3 class="fw-bold mb-1">Student Performance Overview</h3>
            <p class="text-muted small mb-0">Completed quiz submissions and total scored marks by students.</p>
        </div>
    </div>

    <!-- Performance Table Card -->
    <div class="card p-4">
        <asp:GridView ID="gvPerformance" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered align-middle">
            <Columns>
                <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                <asp:BoundField DataField="QuizTitle" HeaderText="Quiz Title" />
                <asp:BoundField DataField="SubjectName" HeaderText="Subject" />
                <asp:BoundField DataField="Score" HeaderText="Score Obtained" ItemStyle-CssClass="fw-bold text-success" />
                <asp:BoundField DataField="TotalMarks" HeaderText="Total Marks" />
                <asp:BoundField DataField="TakenAt" HeaderText="Date Submitted" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
            </Columns>
        </asp:GridView>
        <asp:Label ID="lblNoData" runat="server" Text="No student performance records found." Visible="false" CssClass="text-muted text-center d-block my-3"></asp:Label>
    </div>
</asp:Content>