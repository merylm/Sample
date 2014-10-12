<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="RoastBatchList.aspx.vb" Inherits="InputForms_RoastBatchList" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="BatchListHeadContent" ContentPlaceHolderID="HeadContent" Runat="Server">
    <style type="text/css">
        .col1
        {
            width: 109px;
        }
        .col2
        {
            width: 169px;
        }
    </style>
</asp:Content>
<asp:Content ID="BatchListMainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:ToolkitScriptManager ID="BatchListScriptManager" runat="server">
    </asp:ToolkitScriptManager>        
    <h2>
        Roast Batches</h2>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
       <ContentTemplate>
             <table>
            <tr>
                <td class="col1">
                    Machine:</td>
                <td class="col2">
                    <asp:DropDownList ID="cmbMachine" runat="server" DataSourceID="dtaMachine" 
                        DataTextField="Name" DataValueField="MachineID" 
                        AppendDataBoundItems="True">
                        <asp:ListItem Value="0" Selected="True">(All)</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="dtaMachine" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:GreenBeanConnectionString %>" 
                        SelectCommand="SELECT * FROM [TMachine] ORDER BY [Name]">
                    </asp:SqlDataSource>
                </td>
                <td>
                    <asp:Label ID="lblFromMachineID" runat="server" Text="0000000" Visible="False"></asp:Label>&nbsp;
                    <asp:Label ID="lblToMachineID" runat="server" Text="9999999" Visible="False"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="col1">
                    Item:</td>
                <td class="col2">
                    <asp:DropDownList ID="cmbItem" runat="server" DataSourceID="SqlDataSource2" 
                        DataTextField="Name" DataValueField="StockID" AppendDataBoundItems="True">
                        <asp:ListItem Value="0">(All)</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:GreenBeanConnectionString %>"                        
                        SelectCommand="SELECT [StockID], [Name] FROM [VStockGreen] ORDER BY [Name]"></asp:SqlDataSource>
                </td>
                <td>
                    <asp:Label ID="lblFromStockID" runat="server" Text="0000000" Visible="False"></asp:Label>&nbsp;
                    <asp:Label ID="lblToStockID" runat="server" Text="9999999" Visible="False"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="col1">
                    From Date:</td>
                <td class="col2">
                    <asp:TextBox ID="txtFromDate" runat="server"></asp:TextBox>
                    <asp:CalendarExtender
                    ID="calFromDate"
                    TargetControlID="txtFromDate"
                    runat="server" />
                </td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="col1">
                    To Date:</td>
                <td class="col2">
                    <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>
                     <asp:CalendarExtender
                    ID="calToDate"
                    TargetControlID="txtToDate"
                    runat="server" />
               </td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="col1">
                    &nbsp;</td>
                <td class="col2">
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit" />
                </td>
                <td>
                    &nbsp;</td>
            </tr>
        </table>
        <br />
        <asp:GridView ID="grdRoastBatches" runat="server" AutoGenerateColumns="False" 
            DataKeyNames="BatchNumber" DataSourceID="dtaRoastBatches" AllowPaging="True" PageSize="20" 
            ShowHeaderWhenEmpty="True" CssClass="TblZebra" >
            <Columns>
                <asp:HyperLinkField Text="Edit" DataNavigateUrlFields="BatchID" 
                    DataNavigateUrlFormatString="~/Forms/RoastBatchDetail.aspx?batchid={0}" />
                <asp:BoundField DataField="RoastDate" HeaderText="Roast date" 
                    SortExpression="RoastDate" DataFormatString="{0:d}" />
                <asp:BoundField DataField="BatchNumber" HeaderText="Batch number" 
                    ReadOnly="True" SortExpression="BatchNumber" />
                <asp:BoundField DataField="Name" HeaderText="Stock item" 
                    SortExpression="Name" >
                <HeaderStyle Width="8em" />
                </asp:BoundField>
                <asp:BoundField DataField="GreenQty" HeaderText="Green qty" 
                    SortExpression="GreenQty" DataFormatString="{0:0.###}" >
                <HeaderStyle Width="6em" />
                </asp:BoundField>
                <asp:BoundField DataField="YieldQty" HeaderText="Yield qty" 
                    SortExpression="YieldQty" DataFormatString="{0:0.###}" >
                <HeaderStyle Width="6em" />
                </asp:BoundField>
                <asp:BoundField DataField="LossPercentage" HeaderText="Loss %" 
                    SortExpression="LossPercentage" DataFormatString="{0:0.##}" >
                <HeaderStyle Width="4em" />
                </asp:BoundField>
                <asp:BoundField DataField="FirstCrackTime" DataFormatString="{0:m\:ss}" 
                    HeaderText="1st crack time" SortExpression="FirstCrackTime">
                <HeaderStyle Width="4em" />
                </asp:BoundField>
                <asp:BoundField DataField="FirstCrackTemp" DataFormatString="{0:0.###}" 
                    HeaderText="1st crack temp" SortExpression="FirstCrackTemp">
                <HeaderStyle Width="4em" />
                </asp:BoundField>
                <asp:BoundField DataField="DropTime" DataFormatString="{0:m\:ss}" 
                    HeaderText="Drop time" SortExpression="DropTime">
                <HeaderStyle Width="4em" />
                </asp:BoundField>
                <asp:BoundField DataField="DropTemp" DataFormatString="{0:0.###}" 
                    HeaderText="Drop temp" SortExpression="DropTemp">
                <HeaderStyle Width="4em" />
                </asp:BoundField>
                <asp:BoundField DataField="CaptureUser" HeaderText="Captured" />
                <asp:BoundField DataField="CaptureDate" HeaderText="Date" 
                    DataFormatString="{0:d}" />
                <asp:CheckBoxField DataField="NewGasCylinder" HeaderText="New gas" />
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
        <asp:SqlDataSource ID="dtaRoastBatches" runat="server" 
            ConnectionString="<%$ ConnectionStrings:GreenBeanConnectionString %>" 
                 SelectCommand="SELECT [BatchID], [MachineID], [RoastDate], [BatchNumber], [Name], [GreenQty], [YieldQty], [LossPercentage], [TurningPointTemp], TimeAt300, [FirstCrackTime], [FirstCrackTemp], [DropTime], [DropTemp], LEFT([Notes], 30) AS Notes, [NewGasCylinder], [CaptureUser], [CaptureDate] FROM [VRoastBatches] WHERE ((MachineID &gt;= @FromMachineID) AND (MachineID &lt;= @ToMachineID) AND ([StockID] &gt;= @StockID) AND ([StockID] &lt;= @StockID2) AND ([RoastDate] &gt;= @RoastDate) AND ([RoastDate] &lt;= @RoastDate2)) ORDER BY [RoastDate] DESC, [BatchNumber] DESC">
            <SelectParameters>
                <asp:ControlParameter ControlID="lblFromMachineID" Name="FromMachineID" 
                    PropertyName="Text" />
                <asp:ControlParameter ControlID="lblToMachineID" Name="ToMachineID" 
                    PropertyName="Text" />
                <asp:ControlParameter ControlID="lblFromStockID" Name="StockID" 
                    PropertyName="Text" Type="Int32" />
                <asp:ControlParameter ControlID="lblToStockID" Name="StockID2" 
                    PropertyName="Text" Type="Int32" />
                <asp:ControlParameter ControlID="txtFromDate" DbType="Date" Name="RoastDate" 
                    PropertyName="Text" />
                <asp:ControlParameter ControlID="txtToDate" DbType="Date" Name="RoastDate2" 
                    PropertyName="Text" />
            </SelectParameters>
        </asp:SqlDataSource>
           </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

