
Partial Class ShowError
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        'Show error message then return to caller

        lblErrorMessage.Text = Session("ErrorMessage")

        If Session("ReturnURL") <> "" Then
            lnkReturnURL.Visible = True
            lnkReturnURL.NavigateUrl = Session("ReturnURL")
            lnkReturnURL.Text = Session("ReturnDescription")
        Else
            lnkReturnURL.Visible = False
        End If

        Session("ReturnURL") = ""
        Session("ReturnDescription") = ""

    End Sub
End Class
