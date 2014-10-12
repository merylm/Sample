Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class Utilities

    Private connectionString As String
    Private dbConnection As SqlConnection
    Private dbAdapter As SqlDataAdapter

    Private Const ITEMTYPE_GREEN As String = "ItemTypeGreenBean"
    Private Const ITEMTYPE_ROAST As String = "ItemTypeRoast"
    Private Const ITEMTYPE_BLEND As String = "ItemTypeBlend"
    Private Const REASON_STOCKLOSS As String = "ReasonStockLoss"
    Private Const REASON_STOCKGAIN As String = "ReasonStockGain"
    Private Const DESTINATION_LOSSGAIN As String = "DestinationLossGain"

    Private Const DATE_RANGE_TODAY As String = "Today"
    Private Const DATE_RANGE_YESTERDAY As String = "Yesterday"
    Private Const DATE_RANGE_THISWEEK As String = "This week"
    Private Const DATE_RANGE_LASTWEEK As String = "Last week"
    Private Const DATE_RANGE_THISMONTH As String = "This month"
    Private Const DATE_RANGE_LASTMONTH As String = "Last month"
    Private Const DATE_RANGE_ALL As String = "All"

    Public Property ItemTypeGreen As String
        Get
            Return Trim(GetSystemVariable(ITEMTYPE_GREEN))
        End Get
        Set(value As String)

        End Set
    End Property

    Public Property ItemTypeRoast As String
        Get
            Return Trim(GetSystemVariable(ITEMTYPE_ROAST))
        End Get
        Set(value As String)

        End Set
    End Property

    Public Property ItemTypeBlend As String
        Get
            Return Trim(GetSystemVariable(ITEMTYPE_BLEND))
        End Get
        Set(value As String)

        End Set
    End Property

    Public Property ReasonStockLoss As String
        Get
            Return GetSystemVariable(REASON_STOCKLOSS)
        End Get
        Set(value As String)

        End Set
    End Property

    Public Property ReasonStockGain As String
        Get
            Return GetSystemVariable(REASON_STOCKGAIN)
        End Get
        Set(value As String)

        End Set
    End Property

    Public Property DestinationLossGain As String
        Get
            Return GetSystemVariable(DESTINATION_LOSSGAIN)
        End Get
        Set(value As String)

        End Set
    End Property

    Public Function ExecuteQuery(ByVal SqlQuery As SqlCommand) As Object
        SqlQuery.Connection = dbConnection
        dbAdapter.SelectCommand = SqlQuery

        Dim resultsTable As DataTable = New DataTable
        Try
            dbAdapter.Fill(resultsTable)
        Catch ex As Exception
            Throw ex
        Finally
            dbConnection.Close()
        End Try

        Return resultsTable

    End Function

    Public Function ExecuteCommand(ByVal SqlCmd As SqlCommand) As Integer
        'Return the number of rows updated
        Dim numRows As Integer

        SqlCmd.Connection = dbConnection

        Try
            dbConnection.Open()
            numRows = SqlCmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
            numRows = 0
        Finally
            dbConnection.Close()
        End Try

        Return numRows

    End Function

    Public Function GetDecimalValueFromGrid(ByVal header As String, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) As Decimal
        Dim obj As Object

        obj = DataBinder.Eval(e.Row.DataItem, header)

        If Not IsDBNull(obj) Then
            If IsNumeric(obj) Then
                Return Convert.ToDecimal(obj)
            End If
        End If

        'obj is not a valid number
        Return 0

    End Function

    Public Sub HideGridColumn(ByVal grd As GridView, ByVal intCol As Integer)
        Dim row As GridViewRow

        grd.HeaderRow.Cells(intCol).Visible = False

        For Each row In grd.Rows
            row.Cells(intCol).Visible = False
        Next

    End Sub

    Public Function GetDataKeyIndex(ByVal grd As GridView, ByVal strName As String) As Integer
        'Search the data key names of a grid, and return the index of the specified field name
        Dim i As Integer

        For i = 0 To grd.DataKeyNames.Length - 1
            If grd.DataKeyNames(i) = strName Then
                Return i
            End If
        Next

        'If the name was not found ...
        Return -1

    End Function

    Public Function dtvFindControl(ByVal dtv As DetailsView, ByVal controltofind As String) As Control
        'Search all rows of the details view for the control name
        Dim i As Integer
        Dim ctl As Control

        For i = 0 To dtv.Rows.Count - 1
            If dtv.Rows(i).Cells.Count >= 2 Then

                ctl = dtv.Rows(i).Cells(1).FindControl(controltofind)
                If Not ctl Is Nothing Then
                    Return ctl
                End If

            End If
        Next

        'All rows searched, nothing found
        Return Nothing
    End Function

    Public Function dtvFindControl(ByVal fv As FormView, ByVal controltofind As String) As Control
        'Overloaded function - parameter is a form view instead of a details view
        'Search the form view for the control name
        Dim i As Integer
        Dim ctl As Control

        For i = 0 To fv.Controls.Count - 1
            If fv.Controls.Count >= 2 Then

                ctl = fv.Controls(i).FindControl(controltofind)
                If Not ctl Is Nothing Then
                    Return ctl
                End If

            End If
        Next

        'All rows searched, nothing found
        Return Nothing
    End Function

    Public Function GetResultTable(ByVal SqlQuery As SqlCommand) As DataTable
        SqlQuery.Connection = dbConnection
        dbAdapter.SelectCommand = SqlQuery

        Dim resultsTable As DataTable = New DataTable
        Try
            dbAdapter.Fill(resultsTable)
        Catch ex As Exception
            Throw ex
        Finally
            dbConnection.Close()
        End Try

        Return resultsTable

    End Function

    Public Function GetResultValue(ByVal SqlQuery As SqlCommand) As Object
        SqlQuery.Connection = dbConnection
        dbAdapter.SelectCommand = SqlQuery

        Dim resultsTable As DataTable = New DataTable
        Try
            dbAdapter.Fill(resultsTable)
        Catch ex As Exception
            Throw ex
        Finally
            dbConnection.Close()
        End Try

        If resultsTable(0) Is Nothing Then '(No rows returned)
            Return Nothing
        ElseIf TypeOf resultsTable(0)(0) Is System.DBNull Then '(Null value returned)
            Return Nothing
        Else
            Return resultsTable(0)(0)
        End If

    End Function

    Public Function GetSystemVariable(ByRef strVarName As String) As String
        'Retrieve the value of the given system variable
        Dim tbl As DataTable
        Dim sqlQuery As SqlCommand

        sqlQuery = New SqlCommand("Select Value From TSystemVariable Where SysVarName = @sysvarname")
        sqlQuery.Parameters.Add("@sysvarname", SqlDbType.VarChar).Value = strVarName
        tbl = GetResultTable(sqlQuery)
        If Not (TypeOf tbl(0)(0) Is System.DBNull) Then
            Return tbl(0)(0)
        Else
            Return Nothing
        End If

    End Function

    Function FirstDayOfWeek(ByVal dt As Date) As Date
        Dim days As Integer

        days = Weekday(dt) - 1
        Return DateAdd(DateInterval.Day, -days, dt)
    End Function

    Function FirstDayOfMonth(ByVal dt As Date) As Date
        Dim days As Integer
        Dim firstday As Date

        days = DatePart(DateInterval.Day, dt) - 1 'No of days to subtract to get to the 1st
        firstday = DateAdd(DateInterval.Day, -days, dt)
        Return firstday

    End Function

    Function LastDayOfMonth(ByVal dt As Date) As Date
        Dim days As Integer
        Dim nextmth As Date
        Dim lastday As Date

        nextmth = DateAdd(DateInterval.Month, 1, dt)
        days = DatePart(DateInterval.Day, nextmth) 'No of days to subtract from next month
        lastday = DateAdd(DateInterval.Day, -days, nextmth)
        Return lastday

    End Function

    Function LastDayOfLastMonth(ByVal dt As Date) As Date
        Dim days As Integer
        Dim lastday As Date

        days = DatePart(DateInterval.Day, dt) 'No of days to subtract
        lastday = DateAdd(DateInterval.Day, -days, dt)
        Return lastday

    End Function

    Sub LoadCustomDateRange(cmb As DropDownList)
        'Load a combo with the possible date ranges that the user can select

        cmb.Items.Clear()
        cmb.Items.Add(DATE_RANGE_TODAY)
        cmb.Items.Add(DATE_RANGE_YESTERDAY)
        cmb.Items.Add(DATE_RANGE_THISWEEK)
        cmb.Items.Add(DATE_RANGE_LASTWEEK)
        cmb.Items.Add(DATE_RANGE_THISMONTH)
        cmb.Items.Add(DATE_RANGE_LASTMONTH)
        cmb.Items.Add(DATE_RANGE_ALL)

        cmb.SelectedIndex = 0
    End Sub

    Sub GetCustomDateRange(rangeDesc As String, ByRef fromDate As Date, ByRef toDate As Date)
        'Calculate the from & to date range for the range description supplied

        If rangeDesc = DATE_RANGE_TODAY Then
            fromDate = Today
            toDate = Today

        ElseIf rangeDesc = DATE_RANGE_YESTERDAY Then
            fromDate = DateAdd(DateInterval.Day, -1, Today)
            toDate = DateAdd(DateInterval.Day, -1, Today)

        ElseIf rangeDesc = DATE_RANGE_THISWEEK Then
            fromDate = FirstDayOfWeek(Today)
            toDate = DateAdd(DateInterval.Day, 6, fromDate)

        ElseIf rangeDesc = DATE_RANGE_LASTWEEK Then
            fromDate = FirstDayOfWeek(Today) 'This week
            fromDate = DateAdd(DateInterval.Day, -7, fromDate) 'Last week
            toDate = DateAdd(DateInterval.Day, 6, fromDate)

        ElseIf rangeDesc = DATE_RANGE_THISMONTH Then
            fromDate = FirstDayOfMonth(Today)
            toDate = LastDayOfMonth(Today)

        ElseIf rangeDesc = DATE_RANGE_LASTMONTH Then
            fromDate = FirstDayOfMonth(Today) 'This month
            fromDate = DateAdd(DateInterval.Month, -1, fromDate) 'Last month
            toDate = LastDayOfLastMonth(Today)

        ElseIf rangeDesc = DATE_RANGE_ALL Then
            fromDate = DateTime.MinValue
            toDate = DateTime.MaxValue
        End If
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
End Class

