Imports System.Data
Imports System.Data.SqlClient

Partial Class BlendSummary
    Inherits System.Web.UI.Page

    Sub PopulateBlends(ByVal node As TreeNode, ByVal enabled As Boolean)
        'Populate the tree node with all blends having enabled flag as per parameter

        Dim sqlQuery As New SqlCommand( _
            "Select Name, StockID From VStockBlend Where Enabled = @enabled Order By Name")
        sqlQuery.Parameters.Add("@enabled", SqlDbType.Bit).Value = enabled

        Dim ResultSet As DataSet
        ResultSet = RunQuery(sqlQuery)
        If ResultSet.Tables.Count > 0 Then

            Dim row As DataRow
            For Each row In ResultSet.Tables(0).Rows
                Dim NewNode As TreeNode = New  _
                    TreeNode(row("Name").ToString(), _
                    row("StockID").ToString())
                NewNode.PopulateOnDemand = True
                NewNode.SelectAction = TreeNodeSelectAction.Expand
                node.ChildNodes.Add(NewNode)
            Next

        End If
    End Sub

    Sub PopulateComponents(ByVal node As TreeNode)

        Dim sqlQuery As New SqlCommand
        sqlQuery.CommandText = "Select ComponentName, ComponentStockID, Percentage From VBlendComponent " & _
            " Where BlendStockID = @blendid Order By ComponentName"
        sqlQuery.Parameters.Add("@blendid", SqlDbType.Int).Value = _
            node.Value

        Dim ResultSet As DataSet = RunQuery(sqlQuery)
        If ResultSet.Tables.Count > 0 Then

            Dim row As DataRow
            For Each row In ResultSet.Tables(0).Rows
                Dim NewNode As TreeNode = New  _
                    TreeNode(row("ComponentName").ToString() & " - " & String.Format("{0:0.###}", row("Percentage")) & "%",
                    row("ComponentStockID").ToString())
                NewNode.PopulateOnDemand = False
                NewNode.SelectAction = TreeNodeSelectAction.None
                node.ChildNodes.Add(NewNode)
            Next

        End If
    End Sub

    Function RunQuery(ByVal sqlQuery As SqlCommand) As DataSet

        Dim connectionString As String = _
            ConfigurationManager.ConnectionStrings _
            ("GreenBeanConnectionString").ConnectionString
        Dim dbConnection As New SqlConnection
        dbConnection.ConnectionString = connectionString

        Dim dbAdapter As New SqlDataAdapter
        dbAdapter.SelectCommand = sqlQuery
        sqlQuery.Connection = dbConnection
        Dim resultsDataSet As DataSet = New DataSet
        Try
            dbAdapter.Fill(resultsDataSet)
        Catch ex As Exception
            Session("ErrorMessage") = "Error reading blends: " & ex.Message
            Session("ReturnURL") = "~/Forms/BlendSummary.aspx"
            Session("ReturnDescription") = "Return to blend summary"
            Response.Redirect("~/ShowError.aspx")
        End Try
        Return resultsDataSet

    End Function

    Protected Sub tvBlends_TreeNodePopulate(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.TreeNodeEventArgs) Handles tvBlends.TreeNodePopulate
        'NB: This sub will only run if property "tvBlends.PopulateOnDemand" is set to True

        If e.Node.ChildNodes.Count = 0 Then
            Select Case e.Node.Depth
                Case 0
                    PopulateBlends(e.Node, e.Node.Value) '(Node value indicates enabled/disabled blends)
                    e.Node.Expanded = True
                Case 1
                    PopulateComponents(e.Node)
                    e.Node.Expanded = False
            End Select

        End If

    End Sub

End Class