Imports System.Data
Imports System.Data.SqlClient

Partial Class InputForms_RoastCalculator
    Inherits System.Web.UI.Page

    Const CURRENT_ID As String = "CurrentRoastReqID"
    Const ITEMTYPE_BLEND As String = "ItemTypeBlend"

    Private intCurrentReqID As Integer
    Dim util As Utilities

    Private connectionString As String
    Private dbConnection As SqlConnection
    Private dbAdapter As SqlDataAdapter

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        util = New Utilities

        connectionString = _
            ConfigurationManager.ConnectionStrings _
            ("GreenBeanConnectionString").ConnectionString

        dbConnection = New SqlConnection
        dbConnection.ConnectionString = connectionString

        dbAdapter = New SqlDataAdapter

        'System variables
        intCurrentReqID = CInt(util.GetSystemVariable(CURRENT_ID))

        'Save the current ID to a hidden field on the form
        HiddenRoastReqID.Value = CStr(intCurrentReqID)

    End Sub

    Protected Sub grdRoastRequirement_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdRoastRequirement.RowDataBound
        Dim txtRoastQtyInStock As TextBox
        Dim txtRoastQtySoFar As TextBox
        Dim i As Integer
        Dim intItemType As Integer

        If e.Row.RowType = DataControlRowType.DataRow Then

            txtRoastQtyInStock = e.Row.FindControl("txtRoastQtyInStock")
            txtRoastQtySoFar = e.Row.FindControl("txtRoastQtySoFar")
            i = util.GetDataKeyIndex(grdRoastRequirement, "ItemTypeID")
            If i <> -1 Then
                intItemType = grdRoastRequirement.DataKeys(e.Row.RowIndex).Values(i)
            End If

            'Blends - make qty so far invisible
            If i <> -1 AndAlso intItemType = util.ItemTypeBlend Then

                If Not txtRoastQtySoFar Is Nothing Then
                    txtRoastQtySoFar.Visible = False
                End If

            End If

        End If

    End Sub

    Protected Sub btnRestart_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRestart.Click
        'Create a new set of entries in the roast requirement table
        Dim sqlCmd As New SqlCommand
        Dim numRows As Integer

        sqlCmd = New SqlCommand
        sqlCmd.CommandText = "spNewRoastRequirement"
        sqlCmd.Connection = dbConnection

        Try
            dbConnection.Open()
            numRows = sqlCmd.ExecuteNonQuery()
        Catch ex As Exception
            Session("ErrorMessage") = "Error creating new roast calculation: " & ex.Message
            Session("ReturnURL") = "~/Forms/RoastCalculator.aspx"
            Session("ReturnDescription") = "Return to roast calculator"
            Response.Redirect("~/ShowError.aspx")
        Finally
            dbConnection.Close()
        End Try

        'Retrieve the new ID & save to a hidden field on the form
        intCurrentReqID = CInt(util.GetSystemVariable(CURRENT_ID))
        HiddenRoastReqID.Value = CStr(intCurrentReqID)

        grdRoastCalculator.Visible = False

    End Sub

    Protected Sub btnCalculate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCalculate.Click
        'Update the roast requirement table, then do calculation
        Dim sqlCmd As New SqlCommand
        Dim numRows As Integer

        grdRoastRequirement.UpdateAllRows()

        sqlCmd = New SqlCommand
        sqlCmd.CommandText = "spRoastCalculator @RoastReqID"
        sqlCmd.Parameters.Add("@RoastReqID", SqlDbType.Int).Value = intCurrentReqID
        sqlCmd.Connection = dbConnection

        Try
            dbConnection.Open()
            numRows = sqlCmd.ExecuteNonQuery()
        Catch ex As Exception
            Session("ErrorMessage") = "Error in roast calculation: " & ex.Message
            Session("ReturnURL") = "~/Forms/RoastCalculator.aspx"
            Session("ReturnDescription") = "Return to roast calculator"
            Response.Redirect("~/ShowError.aspx")
        Finally
            dbConnection.Close()
        End Try

        grdRoastCalculator.DataBind() 'Refresh results
        grdRoastCalculator.Visible = True

    End Sub

    Protected Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Unload

        util = Nothing
        dbConnection = Nothing
        dbAdapter = Nothing
    End Sub

    Protected Sub btnClear_Click(sender As Object, e As System.EventArgs) Handles btnClear.Click
        'Clear the "roasted qty in stock" column
        Dim sqlCmd As New SqlCommand

        sqlCmd = New SqlCommand
        sqlCmd.CommandText = "Update TRoastRequirement Set RoastQtyInStock = 0 Where RoastReqID = @RoastReqID"
        sqlCmd.Parameters.Add("@RoastReqID", SqlDbType.Int).Value = intCurrentReqID
        util.ExecuteCommand(sqlCmd)
        grdRoastRequirement.DataBind()

    End Sub

    Protected Sub btnRefresh_Click(sender As Object, e As System.EventArgs) Handles btnRefresh.Click
        'Refresh the "roasted qty so far" = total roasted today for each stock item
        Dim sqlCmd As New SqlCommand

        sqlCmd = New SqlCommand
        sqlCmd.CommandText = "Update TRoastRequirement Set RoastQtySoFar = " & _
            "(Select Sum(YieldQty) From TRoastBatch, TStockRoast " & _
                "Where TRoastRequirement.StockID = TStockRoast.StockID " & _
                "And TStockRoast.GreenStockID = TRoastBatch.StockID " & _
                "And RoastDate = @Today) " & _
            "Where RoastReqID = @RoastReqID"
        sqlCmd.Parameters.Add("@Today", SqlDbType.Date).Value = Today
        sqlCmd.Parameters.Add("@RoastReqID", SqlDbType.Int).Value = intCurrentReqID
        util.ExecuteCommand(sqlCmd)
        grdRoastRequirement.DataBind()

    End Sub
End Class
