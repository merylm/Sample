'Reference - Matt Dotson's .NET Tips & Tricks - Real World GridView: Bulk Editing
'http://blogs.msdn.com/b/mattdotson/archive/2005/11/09/real-world-gridview-bulk-editing.aspx

Imports Microsoft.VisualBasic
Imports System
Imports System.ComponentModel
Imports System.Security.Permissions
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls

Namespace BulkEditGridView.AspNet.VB.Controls
    < _
    AspNetHostingPermission(SecurityAction.Demand, _
        Level:=AspNetHostingPermissionLevel.Minimal), _
    AspNetHostingPermission(SecurityAction.InheritanceDemand, _
        Level:=AspNetHostingPermissionLevel.Minimal), _
    DefaultProperty("SelectedValue"), _
    DefaultEvent("SelectedIndexChanged"),
    ToolboxData( _
        "<{0}:BulkEditGridView runat=""server""> </{0}:BulkEditGridView>") _
    > _
    Public Class BulkEditGridView
        Inherits GridView

        Protected Overrides Function CreateRow(ByVal rowIndex As Integer, ByVal dataSourceIndex As Integer, ByVal rowType As System.Web.UI.WebControls.DataControlRowType, ByVal rowState As System.Web.UI.WebControls.DataControlRowState) As System.Web.UI.WebControls.GridViewRow
            'Make every row that is created have a rowstate of Edit

            Dim newRowState As System.Web.UI.WebControls.DataControlRowState

            newRowState = rowState Or DataControlRowState.Edit
            Return MyBase.CreateRow(rowIndex, dataSourceIndex, rowType, newRowState)
        End Function

        Public Sub UpdateAllRows()
            Dim i As Integer

            For i = 0 To MyBase.Rows.Count - 1
                MyBase.UpdateRow(i, False)
            Next

        End Sub

    End Class
End Namespace
