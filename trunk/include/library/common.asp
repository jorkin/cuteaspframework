<%
'**********
'	class		: some function Library
'	File Name	: function.asp
'	Version		: 0.2.0
'	Author		: TerranC
'	Date		: 2008-4-3
'**********

'**********
'��������showErr
'��  ����message	-- ������Ϣ
'��  �ã���ʾ������Ϣ
'**********
Sub showErr(message)
    echo "<html><head><title>Exception page</title><meta http-equiv=""Content-Type"" content=""text/html; charset=gbk"" /><style type=""text/css""><!--" & vbNewLine & "* { margin:0; padding:0 }" & vbNewLine & "body { background:#333; color:#0f0; font:14px/1.6em ""����"", Verdana, Arial, Helvetica, sans-serif; }" & vbNewLine & "dl { margin:20px 40px; padding:20px; border:3px solid #f63; }" & vbNewLine & "dt { margin:0 0 0.8em 0; font-weight:bold; font-size:1.6em; }" & vbNewLine & "dd { margin-left:2em; margin-top:0.2em; }" & vbNewLine & "--></style></head><body><div id=""container""><dl><dt>Description:</dt><dd><span style=""color:#ff0;font-weight:bold;font-size:1.2em;"">Position:</span> " & message & "</dd></dl></div></body></html>"
	die()
End Sub

'**********
'��������showException
'��  �ã���ʾ�쳣��Ϣ
'**********
Sub showException()
    echo "<p><span style=""color:#ff0;font-weight:bold;font-size:1.2em;"">Error:</span> " & Err.Number & " " & Err.Description & "</p>"
    Err.Clear
    die()
End Sub

'**********
' ������: checkPostSource
' ��  ��: ������Դ��ַ
'**********
Function checkPostSource()
	Dim server_v1,server_v2
	server_v1=Cstr(Request.ServerVariables("HTTP_REFERER"))
	server_v2=Cstr(Request.ServerVariables("SERVER_NAME"))
	If Mid(server_v1,8,Len(server_v2))=server_v2 Then
		checkPostSource=True
	Else
		checkPostSource=False
	End If
End Function

'**********
'��������GetSystem
'��  �ã���ȡ�ͻ��˲���ϵͳ�汾
'����ֵ������ϵͳ�汾����
'**********
Function GetSystem()
	Dim System
	System = Request.ServerVariables("HTTP_USER_AGENT")
	If Instr(System,"Windows NT 5.2") Then
		System = "Win2003"
	ElseIf Instr(System,"Windows NT 5.0") Then
		System="Win2000"
	ElseIf Instr(System,"Windows NT 5.1") Then
		System = "WinXP"
	ElseIf Instr(System,"Windows NT") Then
		System = "WinNT"
	ElseIf Instr(System,"Windows 9") Then
		System = "Win9x"
	Elseif Instr(System,"unix") Or InStr(System,"linux") Or InStr(System,"SunOS") Or InStr(System,"BSD") Then
		System = "Unix"
	ElseIf Instr(System,"Mac") Then
		System = "Mac"
	Else
		System = "Other"
	End If
	GetSystem = System
End Function

'**********
'��������IsObjInstalled
'��  �ã��������Ƿ��Ѿ���װ
'��  ����obj ----�����
'����ֵ��True  ----�Ѿ���װ
'		 False ----û�а�װ
'**********
Function IsObjInstalled(obj)
	On Error Resume Next
	IsObjInstalled = False
	Dim xTestObj
	Set xTestObj = Server.CreateObject(obj)
	If Err.Number = 0 Then IsObjInstalled = True
	Set xTestObj = Nothing
	Err.Clear
	On Error Goto 0
End Function

'**********
' ������: noBuffer
' ��  ��: no buffer
'**********
Sub noBuffer()
	Response.Buffer = True
	Response.Expires = 0
	Response.AddHeader "Expires",toGMTdate()
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Cache-Control","no-cache,must-revalidate"
	Response.ExpiresAbsolute = Now() - 1
	Response.CacheControl = "no-cache"
End Sub

'**********
' ������: rand
' ��  ��: str as the input string
' ��  ��: Generate a random integer
'**********
Function rand(min, max)
    Randomize
    rand = Int((max - min + 1) * Rnd + min)
End Function

'**********
' ������: rq
' ��  ��: Requester as the request type
' ��  ��: Name as the request name
' ��  ��: iType as check type
' ��  ��: Default as the Default string
' ��  ��: safe filter
'**********
Function rq(Requester,Name,iType,Default)
	Dim tmp
	Select Case Requester
	Case 0
		tmp = Name
	Case 1
		tmp = Request(Name)
	Case 2
		tmp = Request.QueryString(Name)
	Case 3
		tmp = Form(Name)
	Case 4
		tmp = Request.Cookies(Name)
	End Select
	tmp = Trim(tmp)
	If tmp = "" Then tmp = Default
	Select Case iType
	Case 0
		If IsNumeric(tmp) = False Then
			tmp = Default
		Else
			tmp = CSng(tmp)
		End If
	Case 1
		If tmp <> "" Then
			tmp = sqlFilter(tmp)
		End If
	Case 2
		If Not IsDate(tmp) Or Len(tmp) <= 0 Then 
			tmp = CDate(Default)
		Else
			tmp = CDate(tmp)
		End If
	End Select
	rq = tmp
End function

'**********
'��������Form
'��  ����element ---- �ؼ���
'��  �ã���ȡForm�ؼ�����
'**********
Function Form(element)
    On Error Resume Next
    If InStr(LCase(Request.ServerVariables("Content_Type")), "multipart/form-data") Then	'multipart/form-data
        If IsObject(Tup) = False Then
    		If Err Then
				die("no include upload class file")
			End If
        End If
		If Tup.Error <> 0 Then
			Tup.Open
		End If
        Form = Tup.Form(element)
    Else
        Form = Request.Form(element)
    End If
    On Error GoTo 0
End Function

'**********
'��������sqlFilter
'��  �ã�����Sql�ؼ���
'**********
Function sqlFilter(str)
	If str = "" Then Exit Function
	str = Replace(str,";","&#59;")
	'str = Replace(str,"<","&lt;")
	'str = Replace(str,">","&gt;")
	str = Replace(str," ","&nbsp;")
	str = Replace(str,"\","&#92;")
	str = Replace(str, "'", "&#39;")
	str = Replace(str,"--","&#45;&#45;")
	sqlFilter = str
End Function

'**********
' ������: currentURL
' ��  ��: ���ص�ǰ��ַ
'**********
Function currentURL()
	Dim port : port = LCase(Request.ServerVariables("Server_Port"))
    Dim page : page = LCase(Request.ServerVariables("Script_Name"))
    Dim query : query = LCase(Request.QueryString())
	Dim url
	If CStr(port) = "80" Then 
		url = page 
	Else
		url = ":" & port & page
	End If
	If query <> "" Then
		currentURL = "http://" & Request.ServerVariables("server_name") & url & "?" & query
	Else
		currentURL = "http://" & Request.ServerVariables("server_name") & url
	End If
End Function

'**********
' ������: refererURL
' ��  ��: ������Դ��ַ
'**********
Function refererURL()
	refererURL = Request.ServerVariables("HTTP_REFERER")
End Function

'**********
' ������: getIP
' ��  ��: ��ȡ�ͻ���IP
'**********
Function getIP()
	Dim Ip,Tmp
	Dim i,IsErr
	Dim ForTotal
	IsErr=False
	Ip=Request.ServerVariables("REMOTE_ADDR")
	If Len(Ip)<=0 Then Ip=Request.ServerVariables("HTTP_X_ForWARDED_For")
	If Len(Ip)>15 Then 
		IsErr=True
	Else
		Tmp=Split(Ip,".")
		If Ubound(Tmp)=3 Then 
			ForTotal = Ubound(Tmp)
			For i=0 To ForTotal
				If Len(Tmp(i))>3 Then IsErr=True
			Next
		Else
			IsErr=True
		End If
	End If
	If IsErr Then 
		getIP="1.1.1.1"
	Else
		getIP=Ip
	End If
End Function

'**********
' ������: getSelfName
' ��  ��: ��ȡ��ǰ�����ļ���
'**********
Function getSelfName()
    getSelfName = Request.ServerVariables("PATH_TRANSLATED")
    getSelfName = Mid(getSelfName, InstrRev(getSelfName, "\") + 1, Len(getSelfName))
End Function

%>
