<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageMaterials.aspx.cs" Inherits="BridgePrep.ManageMaterials" MasterPageFile="~/Teacher.Master" %><asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<style>

.card {

border-radius: 10px;

box-shadow: 0 4px 10px rgba(0,0,0,0.05);

border: none;

}

</style>

<script type="text/javascript">

    function toggleInputType() {

        var contentType = document.getElementById('<%= ddlContentType.ClientID %>').value;

        var fileContainer = document.getElementById('fileUploadContainer');

        var urlContainer = document.getElementById('urlInputContainer');



        if (contentType === 'Video' || contentType === 'Article') {

            fileContainer.style.display = 'none';

            urlContainer.style.display = 'block';

        } else {

            fileContainer.style.display = 'block';

            urlContainer.style.display = 'none';

        }

    }



    window.onload = function () {

        toggleInputType();

    };

</script></asp:Content><asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<!-- Top Welcome Bar -->

<div class="d-flex justify-content-between align-items-center mb-4">

<h2 class="h4 mb-0 fw-bold text-dark">Manage Learning Materials</h2>

<span class="text-muted">Welcome, <asp:Label ID="lblTeacherName" runat="server" Font-Bold="true" CssClass="text-dark"></asp:Label></span>

</div>



<div class="row">

<!-- Upload Material Form -->

<div class="col-md-5 mb-4">

<div class="card p-4">

<h4 class="text-success mb-3 fw-bold">Upload Material</h4>


<div class="mb-3">

<label class="form-label font-weight-bold">Title</label>

<asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="e.g., Chapter 1 Lecture Notes"></asp:TextBox>

</div>



<div class="mb-3">

<label class="form-label font-weight-bold">Subject</label>

<asp:DropDownList ID="ddlSubjects" runat="server" CssClass="form-select"></asp:DropDownList>

</div>



<div class="mb-3">

<label class="form-label font-weight-bold">Content Type</label>

<asp:DropDownList ID="ddlContentType" runat="server" CssClass="form-select" onchange="toggleInputType()">

<asp:ListItem Text="PDF / Document" Value="PDF"></asp:ListItem>

<asp:ListItem Text="Video Link" Value="Video"></asp:ListItem>

<asp:ListItem Text="Article / Website" Value="Article"></asp:ListItem>

</asp:DropDownList>

</div>



<!-- File Upload Field -->

<div class="mb-3" id="fileUploadContainer">

<label class="form-label font-weight-bold">Select File</label>

<asp:FileUpload ID="fileUploadMaterial" runat="server" CssClass="form-control" />

</div>



<!-- URL Field for Video Links & Articles -->

<div class="mb-3" id="urlInputContainer" style="display: none;">

<label class="form-label font-weight-bold">Paste Video / Web Link</label>

<asp:TextBox ID="txtContentUrl" runat="server" CssClass="form-control" placeholder="https://www.youtube.com/watch?v=..."></asp:TextBox>

</div>



<asp:Button ID="btnUpload" runat="server" Text="Upload Material" CssClass="btn btn-success w-100 mt-2" OnClick="btnUpload_Click" />

<asp:Label ID="lblMsg" runat="server" CssClass="mt-3 d-block text-center"></asp:Label>

</div>

</div>



<!-- Existing Materials List -->

<div class="col-md-7 mb-4">

<div class="card p-4">

<h4 class="text-success mb-3 fw-bold">Uploaded Materials</h4>

<asp:GridView ID="gvMaterials" runat="server" AutoGenerateColumns="False" DataKeyNames="MaterialId"

OnRowDeleting="gvMaterials_RowDeleting" CssClass="table table-hover table-bordered align-middle">

<Columns>

<asp:BoundField DataField="Title" HeaderText="Title" />

<asp:BoundField DataField="SubjectName" HeaderText="Subject" />

<asp:BoundField DataField="ContentType" HeaderText="Type" />

<asp:TemplateField HeaderText="Link">

<ItemTemplate>

<a href='<%# Eval("ContentUrl").ToString().StartsWith("http", StringComparison.OrdinalIgnoreCase) ? Eval("ContentUrl") : ResolveUrl(Eval("ContentUrl").ToString()) %>'

target="_blank" rel="noopener noreferrer" class="btn btn-sm btn-primary">View</a>

</ItemTemplate>

</asp:TemplateField>

<asp:CommandField ShowDeleteButton="True" ButtonType="Button" DeleteText="Delete" ControlStyle-CssClass="btn btn-danger btn-sm" />

</Columns>

</asp:GridView>

<asp:Label ID="lblNoData" runat="server" Text="No materials uploaded yet." Visible="false" CssClass="text-muted"></asp:Label>

</div>

</div>

</div></asp:Content>