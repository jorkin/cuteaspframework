<%
'**********
'	class		: some function Library
'	File Name	: function.asp
'	Version		: 0.2.0
'	Author		: TerranC
'	Date		: 2008-4-3
'**********

'**********
'��������ShowErr
'��  ����message	-- ������Ϣ
'��  �ã���ʾ������Ϣ
'**********
Sub ShowErr(message)
    die "<html><head><title>Exception page</title><meta http-equiv=""Content-Type"" content=""text/html; charset=gbk"" /><style type=""text/css""><!--" & vbNewLine & "* { margin:0; padding:0 }" & vbNewLine & "body { background:#333; color:#0f0; font:14px/1.6em ""����"", Verdana, Arial, Helvetica, sans-serif; }" & vbNewLine & "dl { margin:20px 40px; padding:20px; border:3px solid #f63; }" & vbNewLine & "dt { margin:0 0 0.8em 0; font-weight:bold; font-size:1.6em; }" & vbNewLine & "dd { margin-left:2em; margin-top:0.2em; }" & vbNewLine & "--></style></head><body><div id=""container""><dl><dt>Description:</dt><dd><span style=""color:#ff0;font-weight:bold;font-size:1.2em;"">Position:</span> " & message & "</dd></dl></div></body></html>"
End Sub

'**********
'��������ShowException
'��  �ã���ʾ�쳣��Ϣ
'**********
Sub ShowException()
    echo "<p><span style=""color:#ff0;font-weight:bold;font-size:1.2em;"">Error:</span> " & Err.Number & " " & Err.Description & "</p>"
    Err.Clear
    die("")
End Sub

'**********
' ������: CheckPostSource
' ��  ��: ������Դ��ַ
'**********
Function CheckPostSource()
	Dim server_v1,server_v2
	server_v1=Cstr(Request.ServerVariables("HTTP_REFERER"))
	server_v2=Cstr(Request.ServerVariables("SERVER_NAME"))
	If Mid(server_v1,8,Len(server_v2))=server_v2 Then
		CheckPostSource=True
	Else
		CheckPostSource=False
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
'��������IsInstall
'��  �ã��������Ƿ��Ѿ���װ
'��  ����obj ----�����
'����ֵ��True  ----�Ѿ���װ
'		 False ----û�а�װ
'**********
Function IsInstall(obj)
	On Error Resume Next
	IsInstall = False
	Dim xTestObj
	Set xTestObj = Server.CreateObject(obj)
	If Err.Number = 0 Then IsInstall = True
	Set xTestObj = Nothing
	Err.Clear
	On Error Goto 0
End Function

'**********
' ������: NoBuffer
' ��  ��: no buffer
'**********
Sub NoBuffer()
	Response.Buffer = True
	Response.Expires = 0
	Response.AddHeader "Expires",0
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Cache-Control","no-cache,private, post-check=0, pre-check=0, max-age=0"
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
' ������: RandStr
' ����: Generate a specific length random string
'**********
Function RandStr(intLength)
	Dim strSeed,seedLength,i
	strSeed = "abcdefghijklmnopqrstuvwxyz1234567890"
	seedLength = len(strSeed)
	For i=1 to intLength
		Randomize
		RandStr = RandStr & Mid(strSeed,Round((Rnd*(seedLength-1))+1),1)
	Next
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
		tmp = Trim(Request(Name))
		tmp = HtmlEncode(tmp)
	Case 2
		tmp = Trim(Request.QueryString(Name))
		tmp = HtmlEncode(tmp)
	Case 3
		tmp = Trim(Form(Name))
		tmp = HtmlEncode(tmp)
	Case 4
		tmp = Request.Cookies(Name)
		tmp = HtmlEncode(tmp)
	End Select
	If tmp = "" Then tmp = Default
	Select Case iType
	Case 0
		If IsNumeric(tmp) = False Then
			tmp = Default
		Else
			tmp = CSng(tmp)
		End If
	Case 1
		tmp = safe(EncodeJP(tmp))
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
'��������form
'��  ����element ---- �ؼ���
'��  �ã���ȡForm�ؼ�����
'**********
Function form(element)
    On Error Resume Next
    If InStr(LCase(Request.ServerVariables("Content_Type")), "multipart/form-data") Then	'multipart/form-data
        If IsObject(Tpub.Upload) = False Then
    		If Err Then
				die("no include upload class file")
			End If
        End If
		If Tpub.Upload.Error <> 0 Then
			Tpub.Upload.Open
		End If
        form = Tpub.Upload.Form(element)
    Else
        form = Request.Form(element)
    End If
    On Error GoTo 0
End Function

'**********
'��������sqlFilter
'��  �ã�����Sql�ؼ���
'**********
Function safe(str)
	If str = "" Then Exit Function
	str = Replace(str, "'", "''")
	str = Replace(str,"--","&#45;&#45;")
	If IsArray(FilterWord) Then
		Dim item
		str = Tpub.String.regExpReplace(str,Join(FilterWord,"|"),"XX",false)
	End If
	safe = str
End Function

Private Function StrRepeat(length,str)
	Dim i
	For i = 1 To length
		StrRepeat = StrRepeat & str
	Next
End Function

'**********
' ������: CurrentURL
' ��  ��: ���ص�ǰ��ַ
'**********
Function CurrentURL()
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
		CurrentURL = "http://" & Request.ServerVariables("server_name") & url & "?" & query
	Else
		CurrentURL = "http://" & Request.ServerVariables("server_name") & url
	End If
End Function

'**********
' ������: refererURL
' ��  ��: ������Դ��ַ
'**********
Function RefererURL()
	RefererURL = Request.ServerVariables("HTTP_REFERER")
End Function

'**********
' ������: GetIP
' ��  ��: ��ȡ�ͻ���IP
'**********
Function GetIP()
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
		GetIP="1.1.1.1"
	Else
		GetIP=Ip
	End If
End Function

'**********
' ������: GetSelfName
' ��  ��: ��ȡ��ǰ�����ļ���
'**********
Function GetSelfName()
    GetSelfName = Request.ServerVariables("PATH_TRANSLATED")
    GetSelfName = Mid(GetSelfName, InstrRev(GetSelfName, "\") + 1, Len(GetSelfName))
End Function

'**********
'��������ReturnObj
'��  �ã�����һ������
'����ֵ�����������������(Code,Message,AttachObject)
'**********
Function ReturnObj()
	On Error Resume Next
	TypeName(New AopResult)
	If Err Then
		Set ReturnObj = New ReAopResult		'�ض����AopResult
		Err.Clear
	Else
		Set ReturnObj = New AopResult
	End If
	On Error Goto 0
End Function

'**********
' ������: EncodeJP
' ��  ��: str as the input string
' ��  ��: ��������
'**********
Function EncodeJP(ByVal str)
	If str="" Then Exit Function
	Dim c1 : c1 = Array("��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��")
	Dim c2 : c2 = Array("460","462","463","450","466","468","470","472","474","476","478","480","482","485","487","489","496","497","499","500","502","503","505","506","508","509","532")
	Dim i
	For i=0 to 26
		str=Replace(str,c1(i),"&#12"&c2(i)&";")
	Next
	EncodeJP = str
End Function

'**********
' ������: HtmlEncode
' ��  ��: str as the input string
' ��  ��: filter html code
'**********
Function HtmlEncode(ByVal Str)
	If Trim(Str) = "" Or IsNull(Str) Then
		HtmlEncode = ""
	Else
		str = Replace(str, "  ", "&nbsp; ")
		str = Replace(str, """", "&quot;")
		str = Replace(str, ">", "&gt;")
		str = Replace(str, "<", "&lt;")
		HtmlEncode = Str
	End If
End Function



'**********
' ������: HtmlDecode
' ��  ��: str as the input string
' ��  ��: Decode the html tag
'**********
Function HtmlDecode(ByVal str)
	If Not IsNull(str) And str <> "" Then
		str = Replace(str, "&nbsp;", " ",1,-1,1)
		str = Replace(str, "&quot;", """",1,-1,1)
		str = Replace(str, "&gt;", ">",1,-1,1)
		str = Replace(str, "&lt;", "<",1,-1,1)
		HtmlDecode = str
	End If
End Function

'**********
' ������: UrlDecode
' ��  ��: UrlDecode �� URL decode
'**********
Function UrlDecode(ByVal vstrin)
	Dim i, strreturn, strSpecial, intasc, thischr
	strSpecial = "!""#$%&'()*+,.-_/:;<=>?@[\]^`{|}~%"
	strreturn = ""
	For i = 1 To Len(vstrin)
		thischr = Mid(vstrin, i, 1)
		If thischr = "%" Then
			intasc = Eval("&h" + Mid(vstrin, i + 1, 2))
			If InStr(strSpecial, Chr(intasc))>0 Then
				strreturn = strreturn & Chr(intasc)
				i = i + 2
			Else
				intasc = Eval("&h" + Mid(vstrin, i + 1, 2) + Mid(vstrin, i + 4, 2))
				strreturn = strreturn & Chr(intasc)
				i = i + 5
			End If
		Else
			If thischr = "+" Then
				strreturn = strreturn & " "
			Else
				strreturn = strreturn & thischr
			End If
		End If
	Next
	UrlDecode = strreturn
End Function

'**********
' ������: SetQueryString
' ����: ���ò���
'**********
Function SetQueryString(ByVal sQuery, ByVal Name,ByVal Value)
	Dim Obj
	If Len(sQuery) > 0 Then
		If InStr(1,sQuery,Name&"=",1) = 0 Then
			If InStr(sQuery,"=") > 0 And Right(sQuery,1) <> "&" Then
				sQuery = sQuery & "&" & Name & "=" & Value
			Else
				sQuery = sQuery & Name & "=" & Value
			End If
		Else
			Set Obj = New Regexp
			Obj.IgnoreCase = False
			Obj.Global = True
			Obj.Pattern = "(&?" & Name & "=)[^&]+"
			sQuery = Obj.Replace(sQuery,"$1" & Value)
			Set Obj = Nothing
		End If
	Else
		sQuery = sQuery & Name & "=" & Value
	End If
	SetQueryString = sQuery
End Function

'**********
' ������: GetGUID
' ����: ����GUID
'**********
Function GetGUID()
	On Error Resume Next
	GetGUID = Mid(CreateObject("Scriptlet.TypeLib").Guid,2,36)
	Err.Clear
	On Error Goto 0
End Function



%>
