<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="RoastBatchDetail.aspx.vb"
    Inherits="Forms_RoastBatchDetail" MaintainScrollPositionOnPostback="true" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="RoastDetailHeadContent" ContentPlaceHolderID="HeadContent" Runat="Server">
    <script src="../Scripts/RecoverInputs.js"></script>
    <script>
        function disableButton() {
            btnRecoverInputs.disabled = true;
        }
        function __doPostBack(eventTarget, eventArgument) {
            var frm = document.forms[0];
            frm.__EVENTTARGET.value = eventTarget;
            frm.__EVENTARGUMENT.value = eventArgument;
            frm.submit();
        }
    </script>
</asp:Content>
<asp:Content ID="RoastDetailMainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <h2>
        <asp:Label ID="lblHeading" runat="server" Text="Insert/Edit Roast Batch"></asp:Label>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <input id="btnRecoverInputs" type="button" value="Recover inputs" onclick="recoverInputs(getQueryStringValue('batchid'), this.form); __doPostBack('btnRecoverInputs', '');" />
    </h2>
    <asp:ToolkitScriptManager ID="RoastDetailScriptManager" runat="server">
    </asp:ToolkitScriptManager>
    <asp:UpdatePanel ID="RoastDetailUpdatePanel" runat="server">
        <ContentTemplate>
            <asp:HiddenField ID="HiddenDefaultsLoaded" runat="server" Value="1" />
            <asp:HiddenField ID="HiddenUserName" runat="server" />
            <asp:HyperLink ID="lnkGoToList" runat="server" 
                NavigateUrl="~/Forms/RoastBatchList.aspx">Go back to list of batches</asp:HyperLink>
    <br />
            <asp:ValidationSummary ID="RoastDetailValidationSummary" runat="server" ForeColor="Red" 
                HeaderText="Errors found:" />
            <asp:FormView ID="fvRoastBatch" runat="server"
                BackColor="#DEBA84" BorderColor="#DEBA84" CssClass="" DataKeyNames="BatchID" 
                DataSourceID="dtaRoastBatch" Height="50px" style="margin-right: 225px" 
                Width="400px">
                <EditRowStyle BackColor="#738A9C" CssClass="" Font-Bold="True" 
                    ForeColor="White" />

                        <ItemTemplate>
                            (Item template is empty - see Edit & Insert templates)
                        </ItemTemplate>

                        <EditItemTemplate>
                        <table>
                            <tr>
                                <td>Machine</td>
                                <td>
                                    <asp:DropDownList ID="cmbMachineID" runat="server" AutoPostBack="True" 
                                        DataSourceID="dtaMachine" DataTextField="Name" DataValueField="MachineID" 
                                        onselectedindexchanged="cmbMachineID_SelectedIndexChanged" 
                                        SelectedValue='<%# Bind("MachineID") %>' AppendDataBoundItems="True">
                                        <asp:ListItem Value="0">(Machine)</asp:ListItem>
                                    </asp:DropDownList>
                                    &nbsp;<asp:CompareValidator ID="vldMachineID" runat="server" 
                                        ControlToValidate="cmbMachineID" Display="Dynamic" 
                                        ErrorMessage="Please select a machine from the list" ForeColor="Red" 
                                        Operator="NotEqual" ValueToCompare="0">*</asp:CompareValidator>
                                    &nbsp;<asp:SqlDataSource ID="dtaMachine" runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:GreenBeanConnectionString %>" 
                                        SelectCommand="SELECT [MachineID], [Name] FROM [TMachine] ORDER BY [Name]">
                                    </asp:SqlDataSource>
                                </td>
                            </tr>
                            
                            <tr>
                                <td>Roast date</td>
                                <td>
                                    <asp:TextBox ID="txtRoastDate" runat="server" AutoPostBack="True" 
                                        ontextchanged="txtRoastDate_TextChanged" 
                                        Text='<%# Bind("RoastDate","{0:d}") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rqdRoastDate" runat="server" 
                                        ControlToValidate="txtRoastDate" Display="Dynamic" 
                                        ErrorMessage="Roast date is a required filed" ForeColor="Red">*</asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="vldRoastDate" runat="server" 
                                        ControlToValidate="txtRoastDate" Display="Dynamic" 
                                        ErrorMessage="Please enter a valid roast date" ForeColor="Red" 
                                        Operator="DataTypeCheck" Type="Date">*</asp:CompareValidator>
                                    <asp:CalendarExtender
                                        ID="calRoastDate"
                                        TargetControlID="txtRoastDate"
                                        runat="server" />
                                </td>
                            </tr>
                            
                            <tr>
                                <td>Batch number</td>
                                <td>
                                    <asp:TextBox ID="txtBatchNumber" runat="server" 
                                        Text='<%# Bind("BatchNumber") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rqdBatchNumber" runat="server" 
                                        ControlToValidate="txtBatchNumber" Display="Dynamic" 
                                        ErrorMessage="Batch number is a required field" ForeColor="Red">*</asp:RequiredFieldValidator>
                                    <asp:HiddenField ID="hiddenBatchNumberModified" runat="server" />
                                </td>
                            </tr>

                            <tr>
                                <td>Stock item</td>
                                <td>
                                    <asp:DropDownList ID="cmbStockID" runat="server" DataSourceID="dtaStock" 
                                        DataTextField="Name" DataValueField="StockID" 
                                        onselectedindexchanged="cmbStockID_SelectedIndexChanged" 
                                        SelectedValue='<%# Bind("StockID") %>' AppendDataBoundItems="True">
                                        <asp:ListItem Value="0">(Stock item)</asp:ListItem>
                                    </asp:DropDownList>
                                    &nbsp;
                                    <asp:SqlDataSource ID="dtaStock" runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:GreenBeanConnectionString %>" 
                                        SelectCommand="SELECT [StockID], [Name] FROM [VStockGreen] ORDER BY [Name]">
                                    </asp:SqlDataSource>
                                </td>
                            </tr>
                            
                            <tr>
                                <td>Green qty</td>
                                <td>
                                    <asp:TextBox ID="txtGreenQty" runat="server" Text='<%# Bind("GreenQty", "{0:0.###}") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rqdGreenQty" runat="server" 
                                        ControlToValidate="txtGreenQty" Display="Dynamic" 
                                        ErrorMessage="Green bean quantity is a required field" ForeColor="Red">*</asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="vldGreenQty" runat="server" 
                                        ControlToValidate="txtGreenQty" Display="Dynamic" 
                                        ErrorMessage="Please enter a valid green bean quantity" ForeColor="Red" 
                                        Operator="GreaterThan" Type="Double" ValueToCompare="0">*</asp:CompareValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Humidity</td>
                                <td><asp:TextBox ID="txtHumidity" runat="server" Text='<%# Bind("Humidity", "{0:0.##}") %>'></asp:TextBox></td>
                            </tr>

                            <tr>
                                <td>Ambient temperature</td>
                                <td><asp:TextBox ID="txtAmbientTemp" runat="server" Text='<%# Bind("AmbientTemp", "{0:0.##}") %>'></asp:TextBox></td>
                            </tr>

                            <tr>
                                <td>Charge temperature</td>
                                <td><asp:TextBox ID="txtChargeTemp" runat="server" Text='<%# Bind("ChargeTemp", "{0:0.##}") %>'></asp:TextBox></td>
                            </tr>

                            <tr>
                                <td>Turning point time</td>
                                <td>
                                    <asp:TextBox ID="txtTurningPointTime" runat="server" 
                                        Text='<%# Bind("TurningPointTime", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldTurningPointTime" runat="server" 
                                        ControlToValidate="txtTurningPointTime" 
                                        ErrorMessage="Please enter a valid turning point time" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Turning point temperature</td>
                                <td>
                                    <asp:TextBox ID="txtTurningPointTemp" runat="server" 
                                        Text='<%# Bind("TurningPointTemp", "{0:0.##}") %>'></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td>Time at 190</td>
                                <td>
                                    <asp:TextBox ID="txtTimeAt190" runat="server" Text='<%# Bind("TimeAt190", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldTimeAt190" runat="server" 
                                        ControlToValidate="txtTimeAt190" 
                                        ErrorMessage="Please enter a valid time at 190" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Time at 220</td>
                                <td>
                                    <asp:TextBox ID="txtTimeAt220" runat="server" Text='<%# Bind("TimeAt220", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldTimeAt220" runat="server" 
                                        ControlToValidate="txtTimeAt220" 
                                        ErrorMessage="Please enter a valid time at 220" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Time at 250</td>
                                <td>
                                    <asp:TextBox ID="txtTimeAt250" runat="server" Text='<%# Bind("TimeAt250", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldTimeAt250" runat="server" 
                                        ControlToValidate="txtTimeAt250" 
                                        ErrorMessage="Please enter a valid time at 250" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Time change to 50/50</td>
                                <td>
                                    <asp:TextBox ID="txtTimeChangeTo5050" runat="server" 
                                        Text='<%# Bind("TimeChangeTo5050", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldTimeChangeTo5050" runat="server" 
                                        ControlToValidate="txtTimeChangeTo5050" 
                                        ErrorMessage="Please enter a valid time change to 50/50" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Temperature change to 50/50</td>
                                <td>
                                    <asp:TextBox ID="txtTempChangeTo5050" runat="server" 
                                        Text='<%# Bind("TempChangeTo5050", "{0:0.##}") %>'></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td>Time at 300</td>
                                <td>
                                    <asp:TextBox ID="txtTimeAt300" runat="server" Text='<%# Bind("TimeAt300", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldTimeAt300" runat="server" 
                                        ControlToValidate="txtTimeAt300" 
                                        ErrorMessage="Please enter a valid time at 300" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Yellow to brown time</td>
                                <td>
                                    <asp:TextBox ID="txtYellowToBrownTime" runat="server" 
                                        Text='<%# Bind("YellowToBrownTime", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldYellowToBrownTime" runat="server" 
                                        ControlToValidate="txtYellowToBrownTime" 
                                        ErrorMessage="Please enter a valid yellow to brown time" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Yellow to brown temperature</td>
                                <td>
                                    <asp:TextBox ID="txtYellowToBrownTemp" runat="server" 
                                        Text='<%# Bind("YellowToBrownTemp", "{0:0.##}") %>'></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td>Time change to full</td>
                                <td>
                                    <asp:TextBox ID="txtTimeChangeToFull" runat="server" 
                                        Text='<%# Bind("TimeChangeToFull", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldTimeChangeToFull" runat="server" 
                                        ControlToValidate="txtTimeChangeToFull" 
                                        ErrorMessage="Please enter a valid time change to full" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Temperature change to full</td>
                                <td>
                                    <asp:TextBox ID="txtTempChangeToFull" runat="server" 
                                        Text='<%# Bind("TempChangeToFull", "{0:0.##}") %>'></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td>Time at 350</td>
                                <td>
                                    <asp:TextBox ID="txtTimeAt350" runat="server" Text='<%# Bind("TimeAt350", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldTimeAt350" runat="server" 
                                        ControlToValidate="txtTimeAt350" 
                                        ErrorMessage="Please enter a valid time at 350" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>First crack time</td>
                                <td>
                                    <asp:TextBox ID="txtFirstCrackTime" runat="server" Text='<%# Bind("FirstCrackTime", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldFirstCrackTime" runat="server" 
                                        ControlToValidate="txtFirstCrackTime" 
                                        ErrorMessage="Please enter a valid first crack time" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>First crack temperature</td>
                                <td><asp:TextBox ID="txtFirstCrackTemp" runat="server" Text='<%# Bind("FirstCrackTemp", "{0:0.##}") %>'></asp:TextBox></td>
                            </tr>

                            <tr>
                                <td>Second crack time</td>
                                <td>
                                    <asp:TextBox ID="txtSecondCrackTime" runat="server" Text='<%# Bind("SecondCrackTime", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldSecondCrackTime" runat="server" 
                                        ControlToValidate="txtSecondCrackTime" 
                                        ErrorMessage="Please enter a valid second crack time" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Second crack temperature</td>
                                <td><asp:TextBox ID="txtSecondCrackTemp" runat="server" Text='<%# Bind("SecondCrackTemp", "{0:0.##}") %>'></asp:TextBox></td>
                            </tr>

                            <tr>
                                <td>Drop time</td>
                                <td>
                                    <asp:TextBox ID="txtDropTime" runat="server" Text='<%# Bind("DropTime", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldDropTime" runat="server" 
                                        ControlToValidate="txtDropTime" 
                                        ErrorMessage="Please enter a valid drop time" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Drop temperature</td>
                                <td><asp:TextBox ID="txtDropTemp" runat="server" Text='<%# Bind("DropTemp", "{0:0.##}") %>'></asp:TextBox></td>
                            </tr>

                            <tr>
                                <td>Yield qty</td>
                                <td>
                                    <asp:TextBox ID="txtYieldQty" runat="server" Text='<%# Bind("YieldQty", "{0:0.###}") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rqdYieldQty" runat="server" 
                                        ControlToValidate="txtYieldQty" Display="Dynamic" 
                                        ErrorMessage="Yield quantity is a required field" ForeColor="Red">*</asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="vldYieldQty" runat="server" 
                                        ControlToValidate="txtYieldQty" Display="Dynamic" 
                                        ErrorMessage="Please enter a valid yield quantity" ForeColor="Red" 
                                        Operator="GreaterThan" Type="Double" ValueToCompare="0">*</asp:CompareValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Notes</td>
                                <td><asp:TextBox ID="txtNotes" runat="server" Text='<%# Bind("Notes") %>' 
                                        MaxLength="255" Width="20em"></asp:TextBox></td>
                            </tr>

                            <tr>
                                <td>New gas cylinder?</td>
                                <td>
                                    <asp:CheckBox ID="chkNewGasCylinder" runat="server" 
                                        Checked='<%# Bind("NewGasCylinder") %>' />
                                </td>
                            </tr>

                            <tr>
                                <td colspan="2">
                                    <asp:Button ID="btnUpdate" runat="server" CausesValidation="True" 
                                        CommandName="Update" Text="Update" CommandArgument="0" />&nbsp;
                                    <asp:Button ID="btnUpdateAndCont" runat="server" CausesValidation="True"
                                        CommandName="Update" Text="Update &amp; Cont" CommandArgument="1" />&nbsp;
                                    <asp:Button ID="btnCancelEdit" runat="server" CausesValidation="False" 
                                        CommandName="Cancel" Text="Cancel" />
                                </td>
                            </tr>
                       </table>
                       </EditItemTemplate>

                        <InsertItemTemplate>
                        <table>
                            <tr>
                                <td>Machine</td>
                                <td>
                                    <asp:DropDownList ID="cmbMachineID" runat="server" AutoPostBack="True" 
                                        DataSourceID="dtaMachine" DataTextField="Name" DataValueField="MachineID" 
                                        onselectedindexchanged="cmbMachineID_SelectedIndexChanged" 
                                        SelectedValue='<%# Bind("MachineID") %>' AppendDataBoundItems="True">
                                        <asp:ListItem Value="0">(Machine)</asp:ListItem>
                                    </asp:DropDownList>
                                    &nbsp;
                                    <asp:CompareValidator ID="vldMachineID" runat="server" 
                                        ControlToValidate="cmbMachineID" Display="Dynamic" 
                                        ErrorMessage="Please select a machine from the list" ForeColor="Red" 
                                        Operator="NotEqual" ValueToCompare="0">*</asp:CompareValidator>
                                    &nbsp;<asp:SqlDataSource ID="dtaMachine" runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:GreenBeanConnectionString %>" 
                                        SelectCommand="SELECT [MachineID], [Name] FROM [TMachine] ORDER BY [Name]">
                                    </asp:SqlDataSource>
                                </td>
                            </tr>

                            <tr>
                                <td>Roast date</td>
                                <td>
                                    <asp:TextBox ID="txtRoastDate" runat="server" AutoPostBack="True" 
                                        ontextchanged="txtRoastDate_TextChanged" 
                                        Text='<%# Bind("RoastDate", "{0:d}") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rqdRoastDate" runat="server" 
                                        ControlToValidate="txtRoastDate" Display="Dynamic" 
                                        ErrorMessage="Roast date is a required field" ForeColor="Red">*</asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="vldRoastDate" runat="server" 
                                        ControlToValidate="txtRoastDate" Display="Dynamic" 
                                        ErrorMessage="Please enter a valid roast date" ForeColor="Red" 
                                        Operator="DataTypeCheck" Type="Date">*</asp:CompareValidator>
                                    <asp:CalendarExtender
                                        ID="calRoastDate"
                                        TargetControlID="txtRoastDate"
                                        runat="server" />
                                </td>
                            </tr>

                            <tr>
                                <td>Batch number</td>
                                <td>
                                    <asp:TextBox ID="txtBatchNumber" runat="server" 
                                        Text='<%# Bind("BatchNumber") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rqdBatchNumber" runat="server" 
                                        ControlToValidate="txtBatchNumber" Display="Dynamic" 
                                        ErrorMessage="Batch number is a required field" ForeColor="Red">*</asp:RequiredFieldValidator>
                                    <asp:HiddenField ID="hiddenBatchNumberModified" runat="server" />
                                </td>
                            </tr>

                            <tr>
                                <td>Stock item</td>
                                <td>
                                    <asp:DropDownList ID="cmbStockID" runat="server" DataSourceID="dtaStock" 
                                        DataTextField="Name" DataValueField="StockID" 
                                        onselectedindexchanged="cmbStockID_SelectedIndexChanged" 
                                        SelectedValue='<%# Bind("StockID") %>' AppendDataBoundItems="True" 
                                        AutoPostBack="True">
                                        <asp:ListItem Value="0">(Stock item)</asp:ListItem>
                                    </asp:DropDownList>
                                    &nbsp;
                                    <asp:SqlDataSource ID="dtaStock" runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:GreenBeanConnectionString %>" 
                                        SelectCommand="SELECT [StockID], [Name] FROM [VStockGreen] WHERE Enabled = 1 ORDER BY [Name]">
                                    </asp:SqlDataSource>
                                </td>
                            </tr>

                            <tr>
                                <td>Green qty</td>
                                <td>
                                    <asp:TextBox ID="txtGreenQty" runat="server" Text='<%# Bind("GreenQty", "{0:0.###}") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rqdGreenQty" runat="server" 
                                        ControlToValidate="txtGreenQty" Display="Dynamic" 
                                        ErrorMessage="Green bean quantity is a required field" ForeColor="Red">*</asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="CompareValidator1" runat="server" 
                                        ControlToValidate="txtGreenQty" Display="Dynamic" 
                                        ErrorMessage="Please enter a valid green bean quantity" ForeColor="Red" 
                                        Operator="GreaterThan" Type="Double" ValueToCompare="0">*</asp:CompareValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Humidity</td>
                                <td><asp:TextBox ID="txtHumidity" runat="server" Text='<%# Bind("Humidity", "{0:0.##}") %>'></asp:TextBox></td>
                            </tr>

                            <tr>
                                <td>Ambient temperature</td>
                                <td><asp:TextBox ID="txtAmbientTemp" runat="server" Text='<%# Bind("AmbientTemp", "{0:0.##}") %>'></asp:TextBox></td>
                            </tr>

                            <tr>
                                <td>Charge temperature</td>
                               <td><asp:TextBox ID="txtChargeTemp" runat="server" Text='<%# Bind("ChargeTemp", "{0:0.##}") %>'></asp:TextBox></td>
                            </tr>

                            <tr>
                                <td>Turning point time</td>
                                <td>
                                    <asp:TextBox ID="txtTurningPointTime" runat="server" 
                                        Text='<%# Bind("TurningPointTime", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldTurningPointTime" runat="server" 
                                        ControlToValidate="txtTurningPointTime" 
                                        ErrorMessage="Please enter a valid turning point time" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Turning point temperature</td>
                                <td>
                                    <asp:TextBox ID="txtTurningPointTemp" runat="server" 
                                        Text='<%# Bind("TurningPointTemp", "{0:0.##}") %>'></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td>Time at 190</td>
                                <td>
                                    <asp:TextBox ID="txtTimeAt190" runat="server" 
                                        Text='<%# Bind("TimeAt190", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldTimeAt190" runat="server" 
                                        ControlToValidate="txtTimeAt190" 
                                        ErrorMessage="Please enter a valid time at 190" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Time at 220</td>
                                <td>
                                    <asp:TextBox ID="txtTimeAt220" runat="server" 
                                        Text='<%# Bind("TimeAt220", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldTimeAt220" runat="server" 
                                        ControlToValidate="txtTimeAt220" 
                                        ErrorMessage="Please enter a valid time at 220" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Time at 250</td>
                                <td>
                                    <asp:TextBox ID="txtTimeAt250" runat="server" 
                                        Text='<%# Bind("TimeAt250", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldTimeAt250" runat="server" 
                                        ControlToValidate="txtTimeAt250" 
                                        ErrorMessage="Please enter a valid time at 250" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Time change to 50/50</td>
                                <td>
                                    <asp:TextBox ID="txtTimeChangeTo5050" runat="server" 
                                        Text='<%# Bind("TimeChangeTo5050", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldTimeChangeTo5050" runat="server" 
                                        ControlToValidate="txtTimeChangeTo5050" 
                                        ErrorMessage="Please enter a valid time change to 50/50" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Temperature change to 50/50</td>
                                <td>
                                    <asp:TextBox ID="txtTempChangeTo5050" runat="server" 
                                        Text='<%# Bind("TempChangeTo5050", "{0:0.##}") %>'></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td>Time at 300</td>
                                <td>
                                    <asp:TextBox ID="txtTimeAt300" runat="server" 
                                        Text='<%# Bind("TimeAt300", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldTimeAt300" runat="server" 
                                        ControlToValidate="txtTimeAt300" 
                                        ErrorMessage="Please enter a valid time at 300" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Yellow to brown time</td>
                                <td>
                                    <asp:TextBox ID="txtYellowToBrownTime" runat="server" 
                                        Text='<%# Bind("YellowToBrownTime", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldYellowToBrownTime" runat="server" 
                                        ControlToValidate="txtYellowToBrownTime" 
                                        ErrorMessage="Please enter a valid yellow to brown time" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Yellow to brown temperature</td>
                                <td>
                                    <asp:TextBox ID="txtYellowToBrownTemp" runat="server" 
                                        Text='<%# Bind("YellowToBrownTemp", "{0:0.##}") %>'></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td>Time change to full</td>
                                <td>
                                    <asp:TextBox ID="txtTimeChangeToFull" runat="server" 
                                        Text='<%# Bind("TimeChangeToFull", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldTimeChangeToFull" runat="server" 
                                        ControlToValidate="txtTimeChangeToFull" 
                                        ErrorMessage="Please enter a valid time change to full" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Temperature change to full</td>
                                <td>
                                    <asp:TextBox ID="txtTempChangeToFull" runat="server" 
                                        Text='<%# Bind("TempChangeToFull", "{0:0.##}") %>'></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td>Time at 350</td>
                                <td>
                                    <asp:TextBox ID="txtTimeAt350" runat="server" Text='<%# Bind("TimeAt350", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldTimeAt350" runat="server" 
                                        ControlToValidate="txtTimeAt350" 
                                        ErrorMessage="Please enter a valid time at 350" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>First crack time</td>
                                <td>
                                    <asp:TextBox ID="txtFirstCrackTime" runat="server" Text='<%# Bind("FirstCrackTime", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldFirstCrackTime" runat="server" 
                                        ControlToValidate="txtFirstCrackTime" 
                                        ErrorMessage="Please enter a valid first crack time" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>First crack temperature</td>
                                <td><asp:TextBox ID="txtFirstCrackTemp" runat="server" Text='<%# Bind("FirstCrackTemp", "{0:0.##}") %>'></asp:TextBox></td>
                            </tr>

                            <tr>
                                <td>Second crack time</td>
                                <td>
                                    <asp:TextBox ID="txtSecondCrackTime" runat="server" Text='<%# Bind("SecondCrackTime", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldSecondCrackTime" runat="server" 
                                        ControlToValidate="txtSecondCrackTime" 
                                        ErrorMessage="Please enter a valid second crack time" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Second crack temperature</td>
                                <td><asp:TextBox ID="txtSecondCrackTemp" runat="server" Text='<%# Bind("SecondCrackTemp", "{0:0.##}") %>'></asp:TextBox></td>
                            </tr>

                            <tr>
                                <td>Drop time</td>
                                <td>
                                    <asp:TextBox ID="txtDropTime" runat="server" Text='<%# Bind("DropTime", "{0:m\:ss}") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="vldDropTime" runat="server" 
                                        ControlToValidate="txtDropTime" 
                                        ErrorMessage="Please eter a valid drop time" ForeColor="Red" 
                                        ValidationExpression="">*</asp:RegularExpressionValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Drop temperature</td>
                                <td><asp:TextBox ID="txtDropTemp" runat="server" Text='<%# Bind("DropTemp", "{0:0.##}") %>'></asp:TextBox></td>
                            </tr>

                            <tr>
                                <td>Yield qty</td>
                                <td>
                                    <asp:TextBox ID="txtYieldQty" runat="server" Text='<%# Bind("YieldQty", "{0:0.###}") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rqdYieldQty" runat="server" 
                                        ControlToValidate="txtYieldQty" Display="Dynamic" 
                                        ErrorMessage="Yield quantity is a required field" ForeColor="Red">*</asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="vldYieldQty" runat="server" 
                                        ControlToValidate="txtYieldQty" Display="Dynamic" 
                                        ErrorMessage="Please enter a valid yield quantity" ForeColor="Red" 
                                        Operator="GreaterThan" Type="Double" ValueToCompare="0">*</asp:CompareValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Notes</td>
                                <td><asp:TextBox ID="txtNotes" runat="server" Text='<%# Bind("Notes") %>' 
                                        MaxLength="255" Width="20em"></asp:TextBox></td>
                            </tr>

                            <tr>
                                <td>New gas cylinder?</td>
                                <td>
                                    <asp:CheckBox ID="chkNewGasCylinder" runat="server" 
                                        Checked='<%# Bind("NewGasCylinder") %>' />
                                </td>
                            </tr>

                            <tr>
                                <td colspan="2">
                                    <asp:Button ID="btnInsert" runat="server" CausesValidation="True" 
                                        CommandName="Insert" Text="Insert" CommandArgument="0" />&nbsp;
                                    <asp:Button ID="btnInsertAndCont" runat="server" CausesValidation="True"
                                        CommandName="Insert" Text="Insert &amp; Cont" CommandArgument="1" />&nbsp;
                                    <asp:Button ID="btnInsertAndNew" runat="server" CausesValidation="True"
                                        CommandName="Insert" Text="Insert &amp; New" CommandArgument="2" />&nbsp;
                                    <asp:Button ID="btnCancel" runat="server" CausesValidation="False" 
                                        CommandName="Cancel" Text="Cancel" />
                                </td>
                            </tr>
                        </table>
                        </InsertItemTemplate>

                <FooterStyle BackColor="#F7DFB5" ForeColor="#8C4510" />
                <HeaderStyle BackColor="#A55129" Font-Bold="True" ForeColor="White" />
                <PagerStyle ForeColor="#8C4510" HorizontalAlign="Center" />
                <RowStyle BackColor="#FFF7E7" ForeColor="#8C4510" />
            </asp:FormView>
            <asp:SqlDataSource ID="dtaRoastBatch" runat="server" 
                ConnectionString="<%$ ConnectionStrings:GreenBeanConnectionString %>" 
                DeleteCommand="DELETE FROM [TRoastBatch] WHERE [BatchID] = @BatchID" 
                InsertCommand="-- Times are MM:SS. They must be prefixed with '00:' so that they are written to db as 00:MM:SS and not HH:MM:00
INSERT INTO [TRoastBatch] ([MachineID], [RoastDate], [BatchNumber], [StockID], [GreenQty], [YieldQty], [Humidity], [AmbientTemp], [ChargeTemp], [TurningPointTime], [TurningPointTemp], [TimeAt190], [TimeAt220], [TimeAt250], [YellowToBrownTime], [YellowToBrownTemp], [TimeAt300], [TimeChangeTo5050], [TempChangeTo5050], [TimeAt350], [TimeChangeToFull], [TempChangeToFull], [FirstCrackTime], [FirstCrackTemp], [SecondCrackTime], [SecondCrackTemp], [DropTime], [DropTemp], [Notes] , [NewGasCylinder], [CaptureUser], [CaptureDate])
VALUES (@MachineID, @RoastDate, @BatchNumber, @StockID, @GreenQty, @YieldQty, @Humidity, @AmbientTemp, @ChargeTemp, CAST('00:' + @TurningPointTime AS TIME), @TurningPointTemp, CAST('00:' + @TimeAt190 AS TIME), CAST('00:' + @TimeAt220 AS TIME), CAST('00:' + @TimeAt250 AS TIME), CAST('00:' + @YellowToBrownTime AS TIME), @YellowToBrownTemp, CAST('00:' + @TimeAt300 AS TIME), CAST('00:' + @TimeChangeTo5050 AS TIME), @TempChangeTo5050, CAST('00:' + @TimeAt350 AS TIME), CAST('00:' + @TimeChangeToFull AS TIME), @TempChangeToFull, CAST('00:' + @FirstCrackTime AS TIME), @FirstCrackTemp, CAST('00:' + @SecondCrackTime AS TIME), @SecondCrackTemp, CAST('00:' + @DropTime AS TIME), @DropTemp, @Notes, @NewGasCylinder, @HiddenUserName, GETDATE())
UPDATE TSystemVariable SET VALUE = @@IDENTITY WHERE SysVarName = 'LatestRoastBatchID'
" 
                SelectCommand="SELECT * FROM [TRoastBatch] WHERE ([BatchID] = @BatchID)" 
                
                UpdateCommand="-- Times are MM:SS. They must be prefixed with '00:' so that they are written to db as 00:MM:SS and not HH:MM:00

UPDATE [TRoastBatch] SET [MachineID] = @MachineID, [RoastDate] = @RoastDate, [BatchNumber] = @BatchNumber, [StockID] = @StockID, [GreenQty] = @GreenQty, [YieldQty] = @YieldQty, [Humidity] = @Humidity, [AmbientTemp] = @AmbientTemp, [ChargeTemp] = @ChargeTemp, [TurningPointTime] = CAST('00:' + @TurningPointTime AS TIME), [TurningPointTemp] = @TurningPointTemp, [TimeAt190] = CAST('00:' + @TimeAt190 AS TIME), [TimeAt220] = CAST('00:' + @TimeAt220 AS TIME), [TimeAt250] = CAST('00:' + @TimeAt250 AS TIME), YellowToBrownTime = CAST('00:' + @YellowToBrownTime AS TIME), YellowToBrownTemp = @YellowToBrownTemp, [TimeAt300] = CAST('00:' + @TimeAt300 AS TIME), [TimeChangeTo5050] = CAST('00:' + @TimeChangeTo5050 AS TIME), [TempChangeTo5050] = @TempChangeTo5050, [TimeAt350] = CAST('00:' + @TimeAt350 AS TIME), [TimeChangeToFull] = CAST('00:' + @TimeChangeToFull AS TIME), [TempChangeToFull] = @TempChangeToFull, [FirstCrackTime] = CAST('00:' + @FirstCrackTime AS TIME), [FirstCrackTemp] = @FirstCrackTemp, [SecondCrackTime] = CAST('00:' + @SecondCrackTime AS TIME), [SecondCrackTemp] = @SecondCrackTemp, [DropTime] = CAST('00:' + @DropTime AS TIME), [DropTemp] = @DropTemp, [Notes] = @Notes, [NewGasCylinder] = @NewGasCylinder WHERE [BatchID] = @BatchID">
                <DeleteParameters>
                    <asp:Parameter Name="BatchID" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="MachineID" />
                    <asp:Parameter DbType="Date" Name="RoastDate" />
                    <asp:Parameter Name="BatchNumber" Type="String" />
                    <asp:Parameter Name="StockID" Type="Int32" />
                    <asp:Parameter Name="GreenQty" Type="Decimal" />
                    <asp:Parameter Name="YieldQty" Type="Decimal" />
                    <asp:Parameter Name="Humidity" Type="Decimal" />
                    <asp:Parameter Name="AmbientTemp" Type="Decimal" />
                    <asp:Parameter Name="ChargeTemp" Type="Decimal" />
                    <asp:Parameter Name="TurningPointTime" />
                    <asp:Parameter Name="TurningPointTemp" Type="Decimal" />
                    <asp:Parameter Name="TimeAt190" />
                    <asp:Parameter Name="TimeAt220" />
                    <asp:Parameter Name="TimeAt250" />
                    <asp:Parameter Name="YellowToBrownTime" />
                    <asp:Parameter Name="YellowToBrownTemp" />
                    <asp:Parameter Name="TimeAt300" />
                    <asp:Parameter Name="TimeChangeTo5050" />
                    <asp:Parameter Name="TempChangeTo5050" Type="Decimal" />
                    <asp:Parameter Name="TimeAt350" />
                    <asp:Parameter Name="TimeChangeToFull" />
                    <asp:Parameter Name="TempChangeToFull" Type="Decimal" />
                    <asp:Parameter Name="FirstCrackTime" />
                    <asp:Parameter Name="FirstCrackTemp" Type="Decimal" />
                    <asp:Parameter Name="SecondCrackTime" />
                    <asp:Parameter Name="SecondCrackTemp" Type="Decimal" />
                    <asp:Parameter Name="DropTime" />
                    <asp:Parameter Name="DropTemp" Type="Decimal" />
                    <asp:Parameter Name="Notes" Type="String" />
                    <asp:Parameter Name="NewGasCylinder" />
                    <%--<asp:Parameter Name="HiddenUserName" />--%>
                    <asp:ControlParameter Name="HiddenUserName" ControlID="HiddenUserName" />
                </InsertParameters>
                <SelectParameters>
                    <asp:QueryStringParameter Name="BatchID" QueryStringField="batchid" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="MachineID" />
                    <asp:Parameter DbType="Date" Name="RoastDate" />
                    <asp:Parameter Name="BatchNumber" />
                    <asp:Parameter Name="StockID" Type="Int32" />
                    <asp:Parameter Name="GreenQty" Type="Decimal" />
                    <asp:Parameter Name="YieldQty" Type="Decimal" />
                    <asp:Parameter Name="Humidity" Type="Decimal" />
                    <asp:Parameter Name="AmbientTemp" Type="Decimal" />
                    <asp:Parameter Name="ChargeTemp" Type="Decimal" />
                    <asp:Parameter Name="TurningPointTime" />
                    <asp:Parameter Name="TurningPointTemp" Type="Decimal" />
                    <asp:Parameter Name="TimeAt190" />
                    <asp:Parameter Name="TimeAt220" />
                    <asp:Parameter Name="TimeAt250" />
                    <asp:Parameter Name="YellowToBrownTime" />
                    <asp:Parameter Name="YellowToBrownTemp" />
                    <asp:Parameter Name="TimeAt300" />
                    <asp:Parameter Name="TimeChangeTo5050" />
                    <asp:Parameter Name="TempChangeTo5050" Type="Decimal" />
                    <asp:Parameter Name="TimeAt350" />
                    <asp:Parameter Name="TimeChangeToFull" />
                    <asp:Parameter Name="TempChangeToFull" Type="Decimal" />
                    <asp:Parameter Name="FirstCrackTime" />
                    <asp:Parameter Name="FirstCrackTemp" Type="Decimal" />
                    <asp:Parameter Name="SecondCrackTime" />
                    <asp:Parameter Name="SecondCrackTemp" Type="Decimal" />
                    <asp:Parameter Name="DropTime" />
                    <asp:Parameter Name="DropTemp" Type="Decimal" />
                    <asp:Parameter Name="Notes" Type="String" />
                    <asp:Parameter Name="NewGasCylinder" />
                    <asp:Parameter Name="BatchID" />
                </UpdateParameters>
            </asp:SqlDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
<br />
</asp:Content>

