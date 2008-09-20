<%
'**********
'	class		: A database class
'	File Name	: db.asp
'	Version		: 0.2.0
'	Author		: TerranC
'	Date		: 2008-4-4
'**********


'**********
'	ʾ��
'**********

'**********
'	������
'**********
Class Class_Db
    Private ConnStr, SqlLocalPath
    Public ServerIp		'���ݿ�����������
	Public ConnectionType	'���ݿ��������� -- 1.ACCESS 2.MSSQL
	Public Database		'���ݿ��� 
	Public Username			'�û���
	Public Password			'����
    Public Conn, rs

    Private Sub Class_Initialize()
		ServerIp			= "(local)"
		ConnectionType		= "MSSQL"
		Username			= "sa"
		Password			= ""
    End Sub
	
    Private Sub Class_Terminate()
        Me.Close()
		Me.CloseRs(null)
    End Sub
	
    Sub Open()
		On Error Resume Next
		If ConnectionType = "ACCESS" Then
			SqlLocalPath = Replace(Request.ServerVariables("PATH_TRANSLATED"),Replace(Request.ServerVariables("PATH_INFO"),"/","\"),"")
			ConnStr = "Provider=Microsoft.jet.OLEDB.4.0;Data Source=" & SqlLocalPath & Database
		ElseIf ConnectionType = "MSSQL" Then
			ConnStr = "Provider=SQLOLEDB.2;DATA SOURCE=" & ServerIp & ";UID="&Username&";PWD="&Password&";Database="&Database&""
		End If
		Set Conn = CreateObject("ADODB.Connection")
		Conn.Open ConnStr
		If Err Then
			Err.Clear
			Set Conn = Nothing
			Response.Write "���ݿ����ӳ������������ִ���"
			Response.End()
		End If
		On Error GoTo 0
    End Sub
	
	Sub Close()
        If IsObject(Conn) Then
            If Conn.State <> 0 Then
                Conn.Close
                Set Conn = Nothing
            End If
        End If
	End Sub
	
	Sub CloseRs(OutRs)
		If IsObject(OutRs) Then
			OutRs.close
			Set OutRs = Nothing
		Else
			If IsObject(rs) Then
				rs.close
				Set rs = Nothing
			End If
		End If
	End Sub

    Sub setRs( OutRs, strsql, CursorAndLockType)
		Set OutRs = Server.Createobject("ADODB.Recordset")
        OutRs.Open strsql, Conn, 1, CursorAndLockType
    End Sub

    Sub Exec(OutRs, sql)
        If InStr(UCase(sql), UCase("select"))>0 Then
            Set OutRs = Conn.Execute(sql)
        Else
            Call Conn.Execute(sql)
            OutRs = 1
        End If
    End Sub

	'--------------------------------------------------------------------------
	' ����	��	ִ�д洢���̲����ؼ�¼��
	'--------------------------------------------------------------------------
	Function ExecuteRecordSet(commandName , ByVal params, ByVal conn)
		Set ExecuteRecordSet = ExecuteSqlCommand(commandName , params , 2,conn)
	End Function
	
	'--------------------------------------------------------------------------
	' ����	��	ִ�д洢���̲����ؼ�¼����һ�е�һ��
	'--------------------------------------------------------------------------
	Function ExecuteScalar(commandName , ByVal params, ByVal conn)
		Set rs = ExecuteSqlCommand(commandName , params , 2,conn)
		If Not rs.EOF And Not rs.BOF Then
			ExecuteScalar = rs(0).Value
		Else
			ExecuteScalar = NULL
		End If
		rs.Close
		Set rs = Nothing
	End Function
	
	'--------------------------------------------------------------------------
	' ����	��	ִ�д洢���̲�����һ��ֵ
	'--------------------------------------------------------------------------
	Function ExecuteReturnValue(commandName , ByVal params, ByVal conn)
		ExecuteReturnValue = ExecuteSqlCommand(commandName , params , 1, conn)
	End Function
	
	'--------------------------------------------------------------------------
	' ����	��	ִ�д洢���̲������κ�����
	'--------------------------------------------------------------------------
	Function ExecuteNonQuery(commandName , ByVal params, ByVal conn)
		Call ExecuteSqlCommand(commandName , params , 0, conn)
	End Function
	
	'--------------------------------------------------------------------------
	' ����	��	ִ�д洢���̲����ؼ�¼����һ��ֵ
	'--------------------------------------------------------------------------
	Function ExecuteRecordsetAndValue(commandName , ByVal params, ByVal conn)
		ExecuteRecordsetAndValue = ExecuteSqlCommand(commandName , params , 3, conn)
	End Function
	
	'--------------------------------------------------------------------------
	' ����	��	ִ�д洢����
	'--------------------------------------------------------------------------
	' commandName		�洢��������
	' params			�������ϣ�����ʹ�� Scripting.Dictionary ������
	' returnMode		����ģʽ
	'					0	�������κβ��������
	'					1	ִ�к�õ�����ֵ
	'					2	ִ�к�õ���¼��
	'					3	ִ�к�õ�����ֵ�ͼ�¼��
	'--------------------------------------------------------------------------
	Private Function ExecuteSqlCommand(commandName , ByVal params , returnMode, ByVal conn)
		Dim cmd : Set cmd = Server.CreateObject("ADODB.Command")
		Dim iName : iName = ""
		Dim RSReturn : Set RSReturn = Nothing
		Dim ReturnValue : ReturnValue = ""
					
		cmd.ActiveConnection = conn
		cmd.CommandText = commandName
		cmd.CommandType = 4
		cmd.NamedParameters = True
	
		If returnMode = 1 Or returnMode = 3 Then
			cmd.Parameters.Append cmd.CreateParameter("@ReturnValue" , 2 , 4)
		End If
	
		If Not IsNull(params) Then
			For Each iName in params
				cmd.Parameters.Append cmd.CreateParameter(iName , 200 , 1 , 8000 , params(iName))
			Next
		End If
	
		Select Case returnMode
			' ִ�к�õ�����ֵ
			Case 1
				Call cmd.Execute(, , 128)
				ExecuteSqlCommand = cmd("@ReturnValue")
				' ִ�к�õ���¼��
			Case 2
				Set ExecuteSqlCommand = cmd.Execute()
			Case 3
				Set RSReturn = cmd.Execute()
				ExecuteSqlCommand = Array(RSReturn, cmd("@ReturnValue"))
				' Ĭ�Ϸ�ʽ���������κβ��������
			Case Else
				Call cmd.Execute(, , 128)
		End Select
	
		Set cmd = Nothing
	End Function
End Class

%>