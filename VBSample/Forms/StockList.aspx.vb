Imports System.Data
Imports System.Data.SqlClient

Partial Class StockList
    Inherits System.Web.UI.Page

    Const COL_QTYINSTOCK = 2
    Const COL_PRICEPERKG = 3
    Const COL_REPLACEDBY = 4
    Const COL_GREENBEAN = 5

    Const ITEMTYPE_GREEN = "ItemTypeGreenBean"
    Const ITEMTYPE_ROAST = "ItemTypeRoast"
    Const ITEMTYPE_BLEND = "ItemTypeBlend"

    Private util As Utilities
    Private intItemTypeGreen As Integer
    Private intItemTypeRoast As Integer
    Private intItemTypeBlend As Integer

    Protected Sub Page_Init(sender As Object, e As System.EventArgs) Handles Me.Init
        'We must use Page_Init and not Page_Load to set the value of cmbItemType

        util = New Utilities

        If Not Session("StockListCurrentType") Is Nothing Then
            cmbItemType.SelectedValue = Session("StockListCurrentType").ToString
        End If
        If Not Session("StockListEnabledOnly") Is Nothing Then
            chkEnabledOnly.Checked = Session("StockListEnabledOnly").ToString
        End If

        intItemTypeGreen = util.GetSystemVariable(ITEMTYPE_GREEN)
        intItemTypeRoast = util.GetSystemVariable(ITEMTYPE_ROAST)
        intItemTypeBlend = util.GetSystemVariable(ITEMTYPE_BLEND)
    End Sub

    Protected Sub cmbItemType_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmbItemType.DataBound

        'Save the item type, to use when returning to this page
        Session("StockListCurrentType") = cmbItemType.SelectedValue
    End Sub

    Protected Sub cmbItemType_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmbItemType.SelectedIndexChanged

        'Save the item type, to use when returning to this page
        Session("StockListCurrentType") = cmbItemType.SelectedValue
    End Sub

    Protected Sub chkEnabledOnly_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkEnabledOnly.CheckedChanged

        'Save the enabled only flag, to use when returning to this page
        Session("StockListEnabledOnly") = chkEnabledOnly.Checked

    End Sub

    Protected Sub grdStock_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdStock.DataBound
        'Show/hide certain columns depending on the item type

        If cmbItemType.SelectedValue = intItemTypeGreen Then
            util.HideGridColumn(grdStock, COL_GREENBEAN)

        ElseIf cmbItemType.SelectedValue = intItemTypeRoast Then
            util.HideGridColumn(grdStock, COL_PRICEPERKG)
            util.HideGridColumn(grdStock, COL_REPLACEDBY)

        ElseIf cmbItemType.SelectedValue = intItemTypeBlend Then
            util.HideGridColumn(grdStock, COL_GREENBEAN)
            util.HideGridColumn(grdStock, COL_REPLACEDBY)
        End If

    End Sub

    Protected Sub grdStock_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles grdStock.RowCommand
        '(Select/Edit buttton clicked)
        Dim stockid As Integer

        If e.CommandName = "Select" Or e.CommandName = "Edit" Then

            'grdStock.SelectedValue is not set, so use the DataKey value instead
            stockid = grdStock.DataKeys(e.CommandArgument).Value

            If cmbItemType.SelectedValue = intItemTypeGreen Then
                Response.Redirect("~/Forms/StockDetailGreen.aspx?action=" & e.CommandName & "&stockid=" & CStr(stockid))
            ElseIf cmbItemType.SelectedValue = intItemTypeRoast Then
                Response.Redirect("~/Forms/StockDetailRoast.aspx?action=" & e.CommandName & "&stockid=" & CStr(stockid))
            ElseIf cmbItemType.SelectedValue = intItemTypeBlend Then
                Response.Redirect("~/Forms/StockDetailBlend.aspx?action=" & e.CommandName & "&stockid=" & CStr(stockid))
            End If

        End If
    End Sub

    Protected Sub Page_Unload(sender As Object, e As System.EventArgs) Handles Me.Unload
        util = Nothing
    End Sub
End Class
