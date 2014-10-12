<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="StockList.aspx.vb" Inherits="StockList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <style type="text/css">
        .spacebefore {
            margin-left: 2em;
        }
        .spaceafter {
            margin-right: 3em;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h2>
        <span style="font-size: medium">Stock List for type:</span>
        <asp:DropDownList ID="cmbItemType" runat="server" DataSourceID="dtaItemType" 
            DataTextField="Description" DataValueField="ItemTypeID" 
            AutoPostBack="True" class="spaceafter">
        </asp:DropDownList>
        <asp:CheckBox ID="chkEnabledOnly" runat="server" Checked="True" 
            class="spacebefore" Text="Enabled only" AutoPostBack="True" 
            Font-Size="Medium"/>

        <asp:SqlDataSource ID="dtaItemType" runat="server" 
            ConnectionString="<%$ ConnectionStrings:GreenBeanConnectionString %>" 
            SelectCommand="SELECT * FROM [TItemType]"></asp:SqlDataSource>
    </h2>
    <br />
        <asp:GridView ID="grdStock" runat="server" AutoGenerateColumns="False" 
            DataSourceID="dtaStock" EmptyDataText="(no data found)" AllowSorting="True" 
            CssClass="TblSimple" DataKeyNames="StockID" ShowHeaderWhenEmpty="True" >
            <Columns>
                <asp:BoundField DataField="StockName" HeaderText="Item" 
                    SortExpression="StockName" />
                <asp:BoundField DataField="SKU" HeaderText="SKU" SortExpression="SKU" />
                <asp:BoundField DataField="QtyInStock" HeaderText="Qty in stock" 
                    SortExpression="QtyInStock" />
                <asp:BoundField DataField="PricePerKg" HeaderText="Price/kg" 
                    SortExpression="PricePerKg" />
                <asp:BoundField DataField="ReplacedByName" HeaderText="Replaced By" 
                    SortExpression="ReplacedByName" />
                <asp:BoundField DataField="GreenStockName" HeaderText="Green bean" 
                    SortExpression="GreenStockName" />
                <asp:CheckBoxField DataField="Enabled" HeaderText="Enabled" 
                    SortExpression="Enabled" />
                <asp:BoundField DataField="Notes" HeaderText="Notes" SortExpression="Notes" />
            </Columns>
            <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
            <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
            <RowStyle BackColor="#EEEEEE" ForeColor="Black" />
            <SelectedRowStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
            <SortedAscendingCellStyle BackColor="#F1F1F1" />
            <SortedAscendingHeaderStyle BackColor="#0000A9" />
            <SortedDescendingCellStyle BackColor="#CAC9C9" />
            <SortedDescendingHeaderStyle BackColor="#000065" />

        </asp:GridView>
        <asp:SqlDataSource ID="dtaStock" runat="server" 
            ConnectionString="<%$ ConnectionStrings:GreenBeanConnectionString %>" 
            
    SelectCommand="SELECT StockID, ItemTypeID, StockName, SKU, ItemType, KgsPerBag, MinQty, ReorderQty, QtyInStock, PricePerKg, ReplacedBy, ReplacedByName, GreenStockName, Enabled, RIGHT (Notes, 50) AS Notes FROM VStock WHERE (ItemTypeID = @ItemTypeID) AND (@EnabledOnly = 0) OR (ItemTypeID = @ItemTypeID) AND (Enabled = @EnabledOnly) ORDER BY ItemType, StockName" 
    OldValuesParameterFormatString="original_{0}">
            <SelectParameters>
                <asp:ControlParameter ControlID="cmbItemType" Name="ItemTypeID" 
                    PropertyName="SelectedValue" Type="Int32" />
                <asp:ControlParameter ControlID="chkEnabledOnly" Name="EnabledOnly" 
                    PropertyName="Checked" />
            </SelectParameters>
        </asp:SqlDataSource>
</asp:Content>

