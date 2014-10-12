Imports System.Data
Imports System.Data.SqlClient
Imports System.Globalization

Partial Class Forms_RoastBatchDetail
    Inherits System.Web.UI.Page

    'Regular expression - one or 2 digits, followed by ":", followed by one or 2 digits
    Private Const REGEXTIMEVALIDATOR As String = "^([0-9]|[0-5][0-9])(:([0-9]|[0-5][0-9]))?$"
    Private Const RECOVERYBUTTON As String = "btnRecoverInputs"
    Private Const MINLOSSPERC = "MinLossPerc"
    Private Const MAXLOSSPERC = "MaxLossPerc"

    Private util As Utilities
    Private connectionString As String
    Private dbConnection As SqlConnection
    Private dbAdapter As SqlDataAdapter

    Private strInsertArgument As String
    Private strUpdateArgument As String

    Function PostbackControlName() As String
        'The name of the control that caused the Postback
        Return Page.Request.Params.Get("__EVENTTARGET")
    End Function

    Sub AddAttribute(ctl As WebControl, attrName As String, attrValue As String)
        'Add the given attribute (name, value) to the control
        'If the control already has the attribute, then concatenate the new & old values
        'If the attribute is a JavaScript event, the calling routine must ensure that ";" appears in the correct place

        If ctl.Attributes(attrName) Is Nothing Then
            ctl.Attributes.Add(attrName, attrValue)
        Else
            Dim oldValue = ctl.Attributes(attrName)
            ctl.Attributes(attrName) = attrValue & oldValue
        End If
        'System.Diagnostics.Debug.Print(ctl.ID)
    End Sub

    Sub AddStartupScriptSave()
        'Register Startup script to save all inputs to cookie
        Dim strScript As String
        Dim strName As String
        Dim batch As String

        batch = Request.QueryString("batchid")

        strScript = "// Use AJAX to call a Javascript function when the Postback is complete." & vbCrLf & _
            "// We want to save all input values as they appear when the form is loaded." & vbCrLf & _
            "//alert('startup script ...');" & vbCrLf & _
            "var prm = Sys.WebForms.PageRequestManager.getInstance();" & vbCrLf & _
            "prm.add_endRequest(function (s, e) {" & vbCrLf & _
            "var frm = document.forms[0];" & vbCrLf & _
            "saveInputs('" & batch & "', frm);" & vbCrLf & _
            "//alert('Save startup script complete, Charge temp = ' + " & fvRoastBatch.FindControl("txtChargeTemp").ClientID & ".value);" & vbCrLf & _
            "});" & vbCrLf
        strName = "ScriptSave"

        Page.ClientScript.RegisterStartupScript(Me.GetType(), strName, strScript, True)

    End Sub

    Sub AddStartupScriptRecover()
        'Register Startup script to recover all inputs from cookie
        'NB: Updating controls this way will not cause an AutoPostback, so we need to do Postback from Javascript
        'Otherwise the server-side events (SelectedIndexChanged etc.) are triggered at the wrong time
        Dim strScript As String
        Dim strName As String
        Dim batch As String

        batch = Request.QueryString("batchid")
        strScript = "// Automatically recover input values from cookie" & vbCrLf & _
            "//alert('recovering ..')" & vbCrLf & _
            "var frm = document.forms[0];" & vbCrLf & _
            "recoverInputs('" & batch & "', frm);" & vbCrLf & _
            "// Postback machine(add/edit), roastdate(add/edit), stockitem(add only)" & vbCrLf & _
            "__doPostBack('btnRecoverInputs', '');" & vbCrLf
        strName = "ScriptRecover"

        Page.ClientScript.RegisterStartupScript(Me.GetType(), strName, strScript, True)

    End Sub

    Sub AddStartupScriptDisable()
        'Disable the "recover inputs" button
        Dim strScript As String
        Dim strName As String

        strScript = "// Disable the 'recover inputs' button" & vbCrLf & _
            "disableButton();" & vbCrLf
        strName = "ScriptDisable"

        Page.ClientScript.RegisterStartupScript(Me.GetType(), strName, strScript, True)

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim batch As String
        Dim restore As String
        Dim contentpage As ContentPlaceHolder
        Dim hdg As Label
        Dim lnkGoBack As HyperLink

        util = New Utilities()

        batch = Request.QueryString("batchid")
        restore = Request.QueryString("restore")
        contentpage = Form.FindControl("MainContent")

        hdg = contentpage.FindControl("lblHeading")
        lnkGoBack = contentpage.FindControl("lnkGoToList")

        HiddenUserName.Value = Page.User.Identity.Name

        'If batch number is not received in the query string then go into add mode. Else edit mode.
        If batch Is Nothing Then
            fvRoastBatch.ChangeMode(FormViewMode.Insert)
            hdg.Text = "Enter Roast Batch"
            lnkGoBack.Visible = False
            If Not IsPostBack Then
                HiddenDefaultsLoaded.Value = "0"
            End If

        Else
            fvRoastBatch.ChangeMode(FormViewMode.Edit)
            hdg.Text = "Edit Roast Batch"
            lnkGoBack.Visible = True
            If Not IsPostBack Then
                HiddenDefaultsLoaded.Value = "1"
            End If
        End If

        'If "restore" is specified in the query string, then restore all inputs from saved values
        'This flag will be set when returning from the "ShowError" page, eg. after a database error
        If Not IsPostBack And
             Not (restore Is Nothing) Then

            AddStartupScriptRecover()
            HiddenDefaultsLoaded.Value = "1"
        End If

        'Save all inputs when page is loaded (eg. in case defaults were loaded before the connection was lost)
        AddStartupScriptSave()

        'Only allow the "recover inputs" button before the user starts capturing any data
        If IsPostBack Then
            AddStartupScriptDisable()
        End If

    End Sub

    Protected Sub GetDefaultBatchNumber()
        'Call stored procedure to calculate the default batch number
        Dim cmbMach As DropDownList
        Dim txtBatch As TextBox
        Dim txtDate As TextBox

        cmbMach = fvRoastBatch.FindControl("cmbMachineID")
        txtBatch = fvRoastBatch.FindControl("txtBatchNumber")
        txtDate = fvRoastBatch.FindControl("txtRoastDate")

        Dim sqlQuery As New SqlCommand( _
            "Select dbo.fnDefaultBatchNumber(@MachineID, @RoastDate)")

        sqlQuery.Parameters.Add("@MachineID", SqlDbType.Int).Value = cmbMach.SelectedValue
        sqlQuery.Parameters.Add("@RoastDate", SqlDbType.Date).Value = txtDate.Text
        sqlQuery.Connection = dbConnection
        dbAdapter.SelectCommand = sqlQuery

        If IsDate(txtDate.Text) Then
            Dim resultsTable As DataTable = New DataTable
            Try
                dbAdapter.Fill(resultsTable)
            Catch ex As Exception
                Session("ErrorMessage") = "Error calculating default batch number: " & ex.Message
                Session("ReturnURL") = "~/Forms/RoastBatchDetail.aspx?restore=1"
                Session("ReturnDescription") = "Return to roast batch"
                Response.Redirect("~/ShowError.aspx")
            End Try

            If Not (TypeOf resultsTable(0)(0) Is System.DBNull) Then
                txtBatch.Text = resultsTable(0)(0)
            End If

        End If

    End Sub

    Sub LoadBlank(ByVal colName As String)
        'Load one blank value into fvRoastBatch
        'All control names must be = "txt" + the column name in TRoastBatch
        Dim ctl As TextBox
        Dim ctlName As String

        ctlName = "txt" & colName
        ctl = fvRoastBatch.FindControl(ctlName)
        If Not ctl Is Nothing Then
            ctl.Text = ""
        End If
    End Sub

    Sub LoadValue(ByVal row As DataRow, ByVal colName As String, ByVal formatString As String)
        'Load one value into fvRoastBatch
        'All control names must be = "txt" + the column name in TRoastBatch
        Dim ctl As TextBox
        Dim ctlName As String

        ctlName = "txt" & colName
        ctl = fvRoastBatch.FindControl(ctlName)
        If Not ctl Is Nothing Then
            If TypeOf row(colName) Is System.DBNull Then
                ctl.Text = ""
            Else
                ctl.Text = Format(row(colName), formatString)
            End If
        End If
    End Sub

    Sub LoadTimeValue(ByVal row As DataRow, ByVal colName As String)
        'Load one time value into fvRoastBatch
        'All control names must be = "txt" + the column name in TRoastBatch
        Dim ctl As TextBox
        Dim ctlName As String
        Dim dt As DateTime

        ctlName = "txt" & colName
        ctl = fvRoastBatch.FindControl(ctlName)
        If Not ctl Is Nothing Then
            If TypeOf row(colName) Is System.DBNull Then
                ctl.Text = ""
            Else
                dt = DateTime.Parse(row(colName).ToString)
                ctl.Text = Format(dt, "m:ss")
            End If
        End If
    End Sub

    Sub LoadDefaultValues()
        'Update fvRoastBatch with default values, as a guide showing the roaster how to do the next roast
        Dim cmbStock As DropDownList
        Dim cmbMach As DropDownList
        Dim SQLQuery As SqlCommand
        Dim tblBatch As DataTable
        Dim row As DataRow

        cmbStock = fvRoastBatch.FindControl("cmbStockID")
        cmbMach = fvRoastBatch.FindControl("cmbMachineID")

        If Not cmbStock Is Nothing AndAlso cmbStock.SelectedValue <> 0 _
            AndAlso Not cmbMach Is Nothing AndAlso cmbMach.SelectedValue <> 0 Then

            SQLQuery = New SqlCommand
            SQLQuery.CommandText = "Select * From TRoastBatch Where BatchID = " & _
                    "(Select MAX(BatchID) From TRoastBatch Where MachineID = @MachineID And StockID = @StockID)"
            SQLQuery.Parameters.Add("@StockID", SqlDbType.Int).Value = cmbStock.SelectedValue
            SQLQuery.Parameters.Add("@MachineID", SqlDbType.Int).Value = cmbMach.SelectedValue
            tblBatch = util.GetResultTable(SQLQuery)

            If Not tblBatch Is Nothing Then
                row = tblBatch(0)
                If row Is Nothing Then
                    LoadBlank("ChargeTemp")
                    LoadBlank("TurningPointTime")
                    LoadBlank("TurningPointTemp")
                    LoadBlank("TimeAt190")
                    LoadBlank("TimeAt220")
                    LoadBlank("TimeAt250")
                    LoadBlank("YellowToBrownTime")
                    LoadBlank("YellowToBrownTemp")
                    LoadBlank("TimeChangeTo5050")
                    LoadBlank("TempChangeTo5050")
                    LoadBlank("TimeAt300")
                    LoadBlank("TimeAt350")
                    LoadBlank("TimeChangeToFull")
                    LoadBlank("TempChangeToFull")
                    LoadBlank("FirstCrackTime")
                    LoadBlank("FirstCrackTemp")
                    LoadBlank("SecondCrackTime")
                    LoadBlank("SecondCrackTemp")
                    LoadBlank("DropTime")
                    LoadBlank("DropTemp")
                Else
                    LoadValue(row, "ChargeTemp", "0.##")
                    LoadTimeValue(row, "TurningPointTime")
                    LoadValue(row, "TurningPointTemp", "0.##")
                    LoadTimeValue(row, "TimeAt190")
                    LoadTimeValue(row, "TimeAt220")
                    LoadTimeValue(row, "TimeAt250")
                    LoadTimeValue(row, "YellowToBrownTime")
                    LoadValue(row, "YellowToBrownTemp", "0.##")
                    LoadTimeValue(row, "TimeChangeTo5050")
                    LoadValue(row, "TempChangeTo5050", "0.##")
                    LoadTimeValue(row, "TimeAt300")
                    LoadTimeValue(row, "TimeAt350")
                    LoadTimeValue(row, "TimeChangeToFull")
                    LoadValue(row, "TempChangeToFull", "0.##")
                    LoadTimeValue(row, "FirstCrackTime")
                    LoadValue(row, "FirstCrackTemp", "0.##")
                    LoadTimeValue(row, "SecondCrackTime")
                    LoadValue(row, "SecondCrackTemp", "0.##")
                    LoadTimeValue(row, "DropTime")
                    LoadValue(row, "DropTemp", "0.##")
                End If
            End If

            'Set flag so that defaults are not loaded again without warning
            HiddenDefaultsLoaded.Value = "1"

        End If

    End Sub

    Private Sub SetValidationRegEx(ctlName As String)
        'Update the control's ValidationExpression property (to avoid repeated hard coding of the expression in mark-up)
        Dim vld As RegularExpressionValidator

        vld = fvRoastBatch.FindControl(ctlName)
        If Not vld Is Nothing Then
            vld.ValidationExpression = REGEXTIMEVALIDATOR
        End If
    End Sub

    Protected Function GetInsertedBatchID() As Integer
        'Retrive the system variable storing the identity field of the record just inserted
        'The system variable is set in the formview's "INSERT" command

        Dim sqlQuery As New SqlCommand("SELECT Value FROM TSystemVariable WHERE SysVarName = 'LatestRoastBatchID'")
        sqlQuery.Connection = dbConnection
        dbAdapter.SelectCommand = sqlQuery

        Dim resultsTable As DataTable = New DataTable
        Try
            dbAdapter.Fill(resultsTable)
            If TypeOf resultsTable(0)(0) Is System.DBNull Then
                Return 0
            Else
                Return resultsTable(0)(0)
            End If
        Catch ex As Exception
            Session("ErrorMessage") = "Error retrieving batch id: " & ex.Message
            Session("ReturnURL") = "~/Forms/RoastBatchDetail.aspx?restore=1"
            Session("ReturnDescription") = "Return to roast batch"
            Response.Redirect("~/ShowError.aspx")
            Return 0
        End Try

    End Function

    Protected Sub fvRoastBatch_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles fvRoastBatch.DataBound
        Dim batch As String
        Dim restore As String
        Dim cmbMach As DropDownList
        Dim cmbStock As DropDownList
        Dim txtGreen As TextBox
        Dim txtYield As TextBox
        Dim txtDate As TextBox
        Dim calDate As AjaxControlToolkit.CalendarExtender
        Dim strScript As String
        Dim minLoss As Decimal
        Dim maxLoss As Decimal

        batch = Request.QueryString("batchid")
        restore = Request.QueryString("restore")
        cmbMach = fvRoastBatch.FindControl("cmbMachineID")
        cmbStock = fvRoastBatch.FindControl("cmbStockID")
        txtGreen = fvRoastBatch.FindControl("txtGreenQty")
        txtYield = fvRoastBatch.FindControl("txtYieldQty")

        minLoss = util.GetSystemVariable(MINLOSSPERC)
        maxLoss = util.GetSystemVariable(MAXLOSSPERC)

        'If we are inserting a new batch, set default machine, date & batch number if possible

        If batch Is Nothing And
            restore Is Nothing And
             Not IsPostBack() Then

            If Not cmbMach Is Nothing Then
                If cmbMach.SelectedValue = "0" Then
                    If Not Session("LastMachineID") Is Nothing Then
                        cmbMach.SelectedValue = Session("LastMachineID")
                    End If
                End If
            End If

            txtDate = fvRoastBatch.FindControl("txtRoastDate")
            If Not txtDate Is Nothing Then
                txtDate.Text = Today()
            End If

            GetDefaultBatchNumber()

        End If

        calDate = fvRoastBatch.FindControl("calRoastDate")
        If Not calDate Is Nothing Then
            calDate.Format = DateTimeFormatInfo.CurrentInfo.ShortDatePattern
        End If

        SetValidationRegEx("vldTurningPointTime")
        SetValidationRegEx("vldTimeAt190")
        SetValidationRegEx("vldTimeAt220")
        SetValidationRegEx("vldTimeAt250")
        SetValidationRegEx("vldYellowToBrownTime")
        SetValidationRegEx("vldTimeChangeTo5050")
        SetValidationRegEx("vldTimeAt300")
        SetValidationRegEx("vldTimeAt350")
        SetValidationRegEx("vldTimeChangeToFull")
        SetValidationRegEx("vldFirstCrackTime")
        SetValidationRegEx("vldSecondCrackTime")
        SetValidationRegEx("vldDropTime")

        'Script for cmbStockID/cmbMachineID onChange events
        '   If default times & temps have been loaded, and the stock item/machine is changed, ask the user
        '   whether they want to re-load defaults for the new stock item/machine
        '   If defaults must be reloaded then set the hidden field "HiddenDefaultsLoaded" back to 0

        strScript = "hiddenfield = document.getElementById(""MainContent_HiddenDefaultsLoaded""); " & _
        "if (hiddenfield.value == ""1"")" & _
            "{" & _
            "if (confirm(""Re-load defaults for the changed stock item/machine?"")) " & _
                "hiddenfield.value = ""0"";" & _
            "}"

        If fvRoastBatch.CurrentMode = DetailsViewMode.Insert Then
            cmbMach.Attributes.Add("onChange", strScript)
            cmbStock.Attributes.Add("onChange", strScript)
        End If

        'Script for txtGreenQty/txtYieldQty onClick events
        '   If the calculated loss % not in valid range, then show message "Please check ..."
        strScript = "var green = document.getElementById(""MainContent_fvRoastBatch_txtGreenQty""); " & _
        "var yield = document.getElementById(""MainContent_fvRoastBatch_txtYieldQty""); " & _
        "if (green.value != """" & yield.value != """" & yield.value != 0)" & _
            "{" & _
            "var loss = (green.value - yield.value) / yield.value * 100;" & _
            "loss = Math.round(loss*100)/100;" & _
            "if (loss < " & minLoss & " | loss > " & maxLoss & ")" & _
                "alert(""The loss percentage is "" + loss + ""%. Please check whether this is correct."") " & _
            "}"
        ''"{" & _
        ''"if (!confirm(""The loss percentage is "" + loss + ""%. Are you sure this is correct?"")) " & _
        ''    "return false;" & _
        ''"}" & _

        txtGreen.Attributes.Add("onChange", strScript)
        txtYield.Attributes.Add("onChange", strScript)

        'Script to save all input fields to cookie in case the internet connection is lost
        strScript = "saveInputs('" & batch & "', this.form); disableButton();"

        Dim fr As FormViewRow = (CType(fvRoastBatch.Controls(0).Controls(1), FormViewRow))
        Dim tc As TableCell = fr.Cells(0)

        'Add the script to each control on the form
        For i As Integer = 0 To tc.Controls.Count - 1

            Dim controlType = tc.Controls(i).ToString

            If InStr(controlType, "TextBox") > 0 Then
                Dim txt As TextBox = tc.Controls(i)
                AddAttribute(txt, "onChange", strScript)
            End If
            If InStr(controlType, "DropDownList") > 0 Then
                Dim cmb As DropDownList = tc.Controls(i)
                AddAttribute(cmb, "onChange", strScript)
            End If
            If InStr(controlType, "CheckBox") > 0 Then
                Dim chk As CheckBox = tc.Controls(i)
                AddAttribute(chk, "onClick", strScript)
            End If

        Next

        'NB: Button btnRecoverInputs is an HTML control with no server-side logic

    End Sub

    Protected Sub fvRoastBatch_ItemCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewCommandEventArgs) Handles fvRoastBatch.ItemCommand

        If e.CommandName = "Cancel" Then
            Response.Redirect("~/Forms/RoastBatchList.aspx")

        Else
            If e.CommandName = "Insert" Then
                'Save the argument that indicates whether or not to continue editing / continue inserting more records
                strInsertArgument = e.CommandArgument
            End If
            If e.CommandName = "Update" Then
                'Save the argument that indicates whether or not to continue editing the same record
                strUpdateArgument = e.CommandArgument
            End If
        End If

    End Sub

    Protected Sub dtaRoastBatch_Inserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dtaRoastBatch.Inserted
        Dim InsertedBatchID As Integer
        Dim strRedirect As String = ""

        'Retrieve the value of BatchID, the identity field of the row just created
        'This must happen immediately after a batch has been inserted
        'TODO: Allow for multi-user environment (>1 person adding roast batch at the same time)
        InsertedBatchID = GetInsertedBatchID()

        If e.Exception Is Nothing Then

            If strInsertArgument = "0" Then
                'Insert clicked - Return to main form
                strRedirect = "RoastBatchList.aspx"
            ElseIf strInsertArgument = "1" Then
                'Insert & Continue clicked - Return to editing the batch just inserted ... user may wish to do interim save while waiting for roast to complete
                strRedirect = "RoastBatchDetail.aspx?batchid=" & InsertedBatchID
            ElseIf strInsertArgument = "2" Then
                'Insert & New clicked - Prepare to enter another roast batch
                strRedirect = "RoastBatchDetail.aspx"
            End If

            'Redirect to temporary page in order to save batch id, then to the actual page requred
            Session("InsertedBatchID") = InsertedBatchID
            Session("RoastBatchRedirect") = strRedirect '(NB: relative path name)
            Response.Redirect("~/Forms/RoastBatchRedirect.aspx")

        Else
            'Show error message
            Session("ErrorMessage") = "Error inserting into Roast Batch table: " & e.Exception.Message
            Session("ReturnURL") = "~/Forms/RoastBatchDetail.aspx?restore=1"
            Session("ReturnDescription") = "Return to batch entry"
            Response.Redirect("~/ShowError.aspx")
        End If
    End Sub

    Protected Sub dtaRoastBatch_Updated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dtaRoastBatch.Updated
        Dim batch As String

        batch = Request.QueryString("batchid")

        If e.Exception Is Nothing Then

            If strUpdateArgument = "0" Then
                'Update clicked - Return to main form
                Response.Redirect("~/Forms/RoastBatchList.aspx")
            ElseIf strUpdateArgument = "1" Then
                'Update & Continue clicked - Return to editing the same batch ... user may wish to do interim save while waiting for roast to complete
                Response.Redirect("~/Forms/RoastBatchDetail.aspx?batchid=" & batch)
            End If

        Else
            'Show error message
            Session("ErrorMessage") = "Error updating Roast Batch table: " & e.Exception.Message
            Session("ReturnURL") = "~/Forms/RoastBatchDetail.aspx?batchid=" & batch & "&restore=1"
            Session("ReturnDescription") = "Return to batch edit"
            Response.Redirect("~/ShowError.aspx")
        End If

    End Sub

    Protected Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Unload
        util = Nothing
    End Sub

    Public Sub New()

        connectionString = _
            ConfigurationManager.ConnectionStrings _
            ("GreenBeanConnectionString").ConnectionString

        dbConnection = New SqlConnection
        dbConnection.ConnectionString = connectionString

        dbAdapter = New SqlDataAdapter
    End Sub

    Protected Overrides Sub Finalize()
        dbConnection = Nothing
        dbAdapter = Nothing
        MyBase.Finalize()
    End Sub

    Protected Sub cmbMachineID_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        'If entering a new batch, or editing a batch and batch number is empty, get default batch number
        'If entering a new batch, load default time & temperature values
        'Called from both Insert and Edit Template
        Dim cmbMach As DropDownList
        Dim txtBatch As TextBox

        cmbMach = fvRoastBatch.FindControl("cmbMachineID")
        txtBatch = fvRoastBatch.FindControl("txtBatchNumber")

        Session("LastMachineID") = cmbMach.SelectedValue

        If PostbackControlName() <> RECOVERYBUTTON Then

            If fvRoastBatch.CurrentMode = DetailsViewMode.Insert Or _
                fvRoastBatch.CurrentMode = DetailsViewMode.Edit And txtBatch.Text = "" Then
                GetDefaultBatchNumber()
            End If

            'Defaults probably won't get loaded here unless stock item is already selected, but check just in case ...
            If fvRoastBatch.CurrentMode = DetailsViewMode.Insert Then
                If HiddenDefaultsLoaded.Value = "0" Then
                    LoadDefaultValues()
                End If
            End If

        End If

    End Sub

    Protected Sub txtRoastDate_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        'If entering a new batch, or editing a batch and batch is number empty, get default batch number
        'Called from both Insert and Edit Template
        Dim txtBatch As TextBox
        Dim txtDate As TextBox

        txtBatch = fvRoastBatch.FindControl("txtBatchNumber")
        txtDate = fvRoastBatch.FindControl("txtRoastDate")

        If PostbackControlName() <> RECOVERYBUTTON Then

            If fvRoastBatch.CurrentMode = DetailsViewMode.Insert Or _
                fvRoastBatch.CurrentMode = DetailsViewMode.Edit And txtBatch.Text = "" Then
                GetDefaultBatchNumber()
            End If

        End If

    End Sub

    Protected Sub cmbStockID_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        'If entering a new batch, load default time & temperature values
        'Note: AutoPostBack = True for the INSERT item template only

        If PostbackControlName() <> RECOVERYBUTTON Then

            If fvRoastBatch.CurrentMode = DetailsViewMode.Insert Then
                If HiddenDefaultsLoaded.Value = "0" Then
                    LoadDefaultValues()
                End If
            End If

        End If

    End Sub

End Class
