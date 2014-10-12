<%@ Page Title="Home Page" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="_Default" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <br />
    <p>This site contains sample pages from the Quaffee web site</p>
    <p>Database connection:<br />
        &nbsp;
        Server: <asp:TextBox ID="txtServerName" runat="server" Width="90px"></asp:TextBox>&nbsp;
        Database: <asp:TextBox ID="txtDatabaseName" runat="server" Width="90px"></asp:TextBox>&nbsp;
        Integrated security: <asp:CheckBox ID="chkIntegratedSecurity" runat="server" />&nbsp;
        <asp:Label ID="lblUserID" runat="server" Text="User ID:"></asp:Label>
        <asp:TextBox ID="txtUserID" runat="server" Width="80px"></asp:TextBox>&nbsp;
        <asp:Label ID="lblPassword" runat="server" Text="Password:"></asp:Label>
        <asp:TextBox ID="txtPassword" runat="server" Width="80px"></asp:TextBox>
        <br /><br />&nbsp;
        <asp:Button ID="btnConnect" runat="server" Text="Connect" />&nbsp;
        <asp:Label ID="lblMessage" runat="server"></asp:Label> <br />&nbsp;
        &nbsp;
        </p>

    <asp:TreeView ID="SiteMap" runat="server" DataSourceID="SiteMapDataSource1">
    </asp:TreeView>
    <asp:SiteMapDataSource ID="SiteMapDataSource1" runat="server" />
</asp:Content>