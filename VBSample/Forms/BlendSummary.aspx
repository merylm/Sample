<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="BlendSummary.aspx.vb" Inherits="BlendSummary" %>

<asp:Content ID="BatchSummaryHeadContent" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="BatchSummaryMainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <h2>
        Blend Summary
    </h2>
    <asp:TreeView ID="tvBlends" runat="server" MaxDataBindDepth="2">
        <Nodes>
            <asp:TreeNode PopulateOnDemand="True" Text="CURRENT BLENDS" 
                Value="1"></asp:TreeNode>
            <asp:TreeNode PopulateOnDemand="True" Text="INACTIVE BLENDS" Value="0">
            </asp:TreeNode>
        </Nodes>
    </asp:TreeView>
</asp:Content>

