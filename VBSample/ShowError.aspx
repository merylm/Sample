<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="ShowError.aspx.vb" Inherits="ShowError" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h2>
        Error</h2>
    <p>
        An error has occurred</p>
    <p>
        <asp:Label ID="lblErrorMessage" runat="server"></asp:Label>
    </p>
    <p>
        <asp:HyperLink ID="lnkReturnURL" runat="server">[lnkReturnURL]</asp:HyperLink>
    </p>
</asp:Content>

