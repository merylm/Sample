Imports System.Xml
Imports System.Data.SqlClient

Partial Class _Default
    Inherits System.Web.UI.Page

    Const CONNECTIONSTRINGNAME = "GreenBeanConnectionString"

    Protected Function GetConnectionString() As String
        'Retrieve connection string from web.config

        Dim connString As String = ""
        Dim path As String = Server.MapPath("~/Web.Config")
        Dim doc As New XmlDocument()
        doc.Load(path)

        Dim list As XmlNodeList = doc.DocumentElement.SelectNodes(String.Format("connectionStrings/add[@name='{0}']", CONNECTIONSTRINGNAME))

        If list.Count <> 0 Then
            Dim node As XmlNode = list(0)
            connString = node.Attributes("connectionString").Value
        End If

        Return connString

    End Function

    Protected Sub LoadConnectionInfo()
        'Load text boxes with info from connection string

        Dim connString As String = GetConnectionString()
        Dim conStringBuilder As New SqlConnectionStringBuilder(connString)
        txtDatabaseName.Text = conStringBuilder.InitialCatalog
        txtServerName.Text = conStringBuilder.DataSource
        chkIntegratedSecurity.Checked = CBool(conStringBuilder.IntegratedSecurity)
        txtUserID.Text = conStringBuilder.UserID
        txtPassword.Text = conStringBuilder.Password

    End Sub

    Protected Sub UpdateConnectionString()
        'Update web.config from data in text boxes

        Dim path As String = Server.MapPath("~/Web.Config")
        Dim doc As New XmlDocument()
        doc.Load(path)

        Dim list As XmlNodeList = doc.DocumentElement.SelectNodes(String.Format("connectionStrings/add[@name='{0}']", CONNECTIONSTRINGNAME))

        If list.Count <> 0 Then
            Dim node As XmlNode = list(0)

            Dim connString As String = node.Attributes("connectionString").Value
            Dim conStringBuilder As New SqlConnectionStringBuilder(connString)
            conStringBuilder.InitialCatalog = txtDatabaseName.Text
            conStringBuilder.DataSource = txtServerName.Text
            conStringBuilder.IntegratedSecurity = CStr(chkIntegratedSecurity.Checked)
            conStringBuilder.UserID = txtUserID.Text
            conStringBuilder.Password = txtPassword.Text
            node.Attributes("connectionString").Value = conStringBuilder.ConnectionString
            doc.Save(path)
        End If

    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

        If Not IsPostBack() Then
            LoadConnectionInfo()
        End If

        'Javascript event to show/hide user id & password
        Dim strScript As String = "if (" & chkIntegratedSecurity.ClientID & ".checked) {" &
            lblUserID.ClientID & ".style.visibility = 'hidden'; " &
            lblPassword.ClientID & ".style.visibility = 'hidden'; " &
            txtUserID.ClientID & ".style.visibility = 'hidden'; " &
            txtPassword.ClientID & ".style.visibility = 'hidden' }" &
            "else {" &
            lblUserID.ClientID & ".style.visibility = 'visible'; " &
            lblPassword.ClientID & ".style.visibility = 'visible'; " &
            txtUserID.ClientID & ".style.visibility = 'visible'; " &
            txtPassword.ClientID & ".style.visibility = 'visible' }"

        'Add event to check box & document startup
        chkIntegratedSecurity.Attributes.Add("onChange", strScript)
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "StartupScript", strScript, True)

        'Javascript event to show a message when "Connect" is clicked
        btnConnect.OnClientClick = "document.getElementById('" & lblMessage.ClientID & "').style = 'foregroundColor: black'; " &
            "document.getElementById('" & lblMessage.ClientID & "').innerHTML = 'Trying to connect ...'"

        lblMessage.Text = ""
        lblMessage.ForeColor = Drawing.Color.Black
    End Sub

    Protected Sub btnConnect_Click(sender As Object, e As System.EventArgs) Handles btnConnect.Click

        UpdateConnectionString()

        Dim conn As New SqlConnection
        conn.ConnectionString = GetConnectionString()
        btnConnect.Enabled = False
        Try
            conn.Open()
            lblMessage.Text = "Connection succeeded."
            lblMessage.ForeColor = Drawing.Color.Black
        Catch ex As Exception
            lblMessage.Text = "Error - " & ex.Message
            lblMessage.ForeColor = Drawing.Color.Red
        Finally
            conn.Close()
            btnConnect.Enabled = True
        End Try

    End Sub

End Class