
Partial Class InputForms_RoastBatchRedirect
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        'Register startup scripts to run as soon as page is loaded
        Dim strScript As String
        Dim strName As String
        Dim batchid As String
        Dim redirect As String

        'Save inserted batch id to cookie (so that if the "recover inputs" button is clicked, the batch id can be verified)
        batchid = CStr(Session("InsertedBatchID"))
        If batchid <> "" Then
            strScript = "// Update the cookie to reflect the batchid just inserted" & vbCrLf & _
                "saveBatchid(" & batchid & ");" & vbCrLf
            strName = "ScriptSaveBatchid"

            Page.ClientScript.RegisterStartupScript(Me.GetType(), strName, strScript, True)
        End If

        'Now redirect to the desired page
        redirect = CStr(Session("RoastBatchRedirect"))
        If redirect <> "" Then
            strScript = "// Redirect to desired page" & vbCrLf & _
                "window.location.href='" & redirect & "';" & vbCrLf
            strName = "ScriptRedirect"

            Page.ClientScript.RegisterStartupScript(Me.GetType(), strName, strScript, True)
        End If
    End Sub
End Class
