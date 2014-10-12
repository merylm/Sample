Imports System.Globalization

Partial Class InputForms_RoastBatchList
    Inherits System.Web.UI.Page

    Protected Sub cmbItem_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmbItem.SelectedIndexChanged
        'When the selected item changes, update 2 hidden labels
        'This is to allow the grid datasource "WHERE" clause to be built up

        If cmbItem.SelectedValue = 0 Then '(All items)
            lblFromStockID.Text = 0
            lblToStockID.Text = 9999999
        Else
            lblFromStockID.Text = cmbItem.SelectedValue
            lblToStockID.Text = cmbItem.SelectedValue
        End If
    End Sub

    Protected Sub cmbMachine_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmbMachine.SelectedIndexChanged
        'When the selected machine changes, update 2 hidden labels
        'This is to allow the grid datasource "WHERE" clause to be built up

        If cmbMachine.SelectedValue = 0 Then '(All machines)
            lblFromMachineID.Text = 0
            lblToMachineID.Text = 9999999
        Else
            lblFromMachineID.Text = cmbMachine.SelectedValue
            lblToMachineID.Text = cmbMachine.SelectedValue
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim dt As Date
        If Not IsPostBack Then
            If txtFromDate.Text = "" Then
                dt = DateAdd(DateInterval.Day, -30, Today)
                txtFromDate.Text = dt.ToString("d")
                calFromDate.SelectedDate = dt
                calFromDate.Format = DateTimeFormatInfo.CurrentInfo.ShortDatePattern
            End If
            If txtToDate.Text = "" Then
                txtToDate.Text = Today.ToString("d")
                calToDate.SelectedDate = Today
                calToDate.Format = DateTimeFormatInfo.CurrentInfo.ShortDatePattern
            End If
        End If
    End Sub

    Protected Sub txtFromDate_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtFromDate.TextChanged
        If IsDate(txtFromDate.Text) Then
            calFromDate.SelectedDate = txtFromDate.Text
        End If
    End Sub

    Protected Sub txtToDate_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtToDate.TextChanged
        If IsDate(txtToDate.Text) Then
            calToDate.SelectedDate = txtToDate.Text
        End If
    End Sub

End Class
