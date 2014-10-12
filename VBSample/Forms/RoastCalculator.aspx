<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" MaintainScrollPositionOnPostback="true" AutoEventWireup="false" CodeFile="RoastCalculator.aspx.vb" Inherits="InputForms_RoastCalculator" %>
<%@ Register TagPrefix="aspCustomControl" Namespace="BulkEditGridView.AspNet.VB.Controls"%>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div>
        <h2>
            Roast Calculator
            &nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnClear" runat="server" Text="Clear qty in stock" />
            &nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnRefresh" runat="server" Text="Refresh qty so far" />
            &nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnRestart" runat="server" style="text-align: right" 
            Text="Clear all &amp; Restart" />
        </h2>
       <asp:HiddenField ID="HiddenRoastReqID" runat="server" />
        <br />
        <%--
 BackColor="White" 
            BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="0" 
          <AlternatingRowStyle BackColor="#DCDCDC" />
--%>
      <aspCustomControl:BulkEditGridView ID="grdRoastRequirement" runat="server" 
            AutoGenerateColumns="False" DataKeyNames="RoastReqID,StockID,ItemTypeID" 
            DataSourceID="dtaRoastRequirement" CssClass="TblThinRow" 
            ShowHeaderWhenEmpty="True">
          <Columns>
              <asp:BoundField HeaderText="Stock item" DataField="StockName" ReadOnly="True" />
              <asp:TemplateField HeaderText="Roast qty needed">
                  <EditItemTemplate>
                      <asp:TextBox ID="txtRoastQtyNeeded" runat="server" Height="17px" 
                          Text='<%# Bind("RoastQtyNeeded", "{0:#.###}") %>'></asp:TextBox>
                  </EditItemTemplate>
                  <ItemTemplate>
                      <asp:Label ID="lblRoastQtyNeeded" runat="server" 
                          Text='<%# Bind("RoastQtyNeeded", "{0:#.###}") %>'></asp:Label>
                  </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField HeaderText="Roast qty in stock">
                  <EditItemTemplate>
                      <asp:TextBox ID="txtRoastQtyInStock" runat="server" 
                          Text='<%# Bind("RoastQtyInStock", "{0:#.###}") %>' Height="17px" 
                          style="font-size: small"></asp:TextBox>
                  </EditItemTemplate>
                  <ItemTemplate>
                      <asp:Label ID="lblRoastQtyInStock" runat="server" Text='<%# Bind("RoastQtyInStock") %>'></asp:Label>
                  </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField HeaderText="Roast qty so far">
                  <EditItemTemplate>
                      <asp:TextBox ID="txtRoastQtySoFar" runat="server" 
                          Text='<%# Bind("RoastQtySoFar", "{0:#.###}") %>' Height="17px" 
                          style="font-size: small"></asp:TextBox>
                  </EditItemTemplate>
                  <ItemTemplate>
                      <asp:Label ID="lblRoastQtySoFar" runat="server" Text='<%# Bind("RoastQtySoFar") %>'></asp:Label>
                  </ItemTemplate>
              </asp:TemplateField>
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
        </aspCustomControl:BulkEditGridView>
        <asp:SqlDataSource ID="dtaRoastRequirement" runat="server" 
            ConnectionString="<%$ ConnectionStrings:GreenBeanConnectionString %>" 
            
            
            
            SelectCommand="SELECT [RoastReqID], [StockID], [ItemTypeID], [StockName], [RoastQtyNeeded], [RoastQtyInStock], [RoastQtySoFar] FROM [VRoastRequirement] WHERE RoastReqID = @RoastReqID ORDER BY [SortOrder], [StockName]" 
            UpdateCommand="UPDATE TRoastRequirement SET RoastQtyNeeded = @RoastQtyNeeded, RoastQtyInStock = @RoastQtyInStock, RoastQtySoFar = @RoastQtySoFar WHERE RoastReqID = @RoastReqID AND StockID = @StockID">
            <SelectParameters>
                <asp:ControlParameter ControlID="HiddenRoastReqID" Name="RoastReqID" 
                    PropertyName="Value" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="RoastQtyNeeded" />
                <asp:Parameter Name="RoastQtyInStock" />
                <asp:Parameter Name="RoastQtySoFar" />
                <asp:Parameter Name="RoastReqID" />
                <asp:Parameter Name="StockID" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <br />
        <asp:Button ID="btnCalculate" runat="server" Text="Calculate" />
        <br />
        <br />

        <asp:GridView ID="grdRoastCalculator" runat="server" AutoGenerateColumns="False" CssClass="TblSimple"
            DataSourceID="dtaRoastCalculator" Font-Size="Small" GridLines="Vertical">
            <Columns>
                <asp:BoundField DataField="StockName" HeaderText="Stock item" 
                    SortExpression="StockName" />
                <asp:BoundField DataField="RoastQtyForSingleOrigin" 
                    HeaderText="Roast qty - single" SortExpression="RoastQtyForSingleOrigin" 
                    DataFormatString="{0:0.###}" />
                <asp:BoundField DataField="RoastQtyForBlend" HeaderText="Roast qty - blends" 
                    SortExpression="RoastQtyForBlend" DataFormatString="{0:0.###}" />
                <asp:BoundField DataField="TotalRoastQtyNeeded" HeaderText="Total roast qty" 
                    SortExpression="TotalRoastQtyNeeded" DataFormatString="{0:0.###}" />
                <asp:BoundField DataField="RoastQtyInStock" HeaderText="Roast qty in stock" 
                    SortExpression="RoastQtyInStock" DataFormatString="{0:0.###}" />
                <asp:BoundField DataField="RoastQtySoFar" HeaderText="Roast qty so far" 
                    SortExpression="RoastQtySoFar" DataFormatString="{0:0.###}" />
                <asp:BoundField DataField="LossPercentage" HeaderText="Loss percentage" 
                    SortExpression="LossPercentage" DataFormatString="{0:0.###}" />
                <asp:BoundField DataField="GreenQtyToRoast" HeaderText="Green qty to roast" 
                    SortExpression="GreenQtyToRoast" DataFormatString="{0:0.###}" />
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
        <asp:SqlDataSource ID="dtaRoastCalculator" runat="server" 
            ConnectionString="<%$ ConnectionStrings:GreenBeanConnectionString %>" 
            SelectCommand="SELECT [StockName], [RoastQtyForSingleOrigin], [RoastQtyForBlend], [RoastQtyInStock], [RoastQtySoFar], [LossPercentage], [GreenQtyToRoast], [TotalRoastQtyNeeded] FROM [VRoastCalculator] WHERE (([RoastReqID] = @RoastReqID) AND ([TotalRoastQtyNeeded] &lt;&gt; @TotalRoastQtyNeeded)) ORDER BY [StockName]">
            <SelectParameters>
                <asp:ControlParameter ControlID="HiddenRoastReqID" Name="RoastReqID" 
                    PropertyName="Value" Type="Int32" />
                <asp:Parameter DefaultValue="0" Name="TotalRoastQtyNeeded" Type="Decimal" />
            </SelectParameters>
        </asp:SqlDataSource>
        <br />
    </div>
</asp:Content>

