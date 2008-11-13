<%
'**********
'	class		: A String class
'	File Name	: String.asp
'	Version		: 0.2.0
'	Author		: TerranC
'	Date		: 2008-6-16
'**********


'**********
'	ʾ��
'**********

'**********
'	������
'**********

Class Class_String
	'**********
    ' ������: class_Initialize
    ' ��  ��: Constructor
    '**********
	Private Sub Class_Initialize()
    End Sub
	'**********
	' ������: encodeJP
	' ��  ��: str as the input string
	' ��  ��: ��������
	'**********
	Function encodeJP(ByVal str)
		If str="" Then Exit Function
		Dim c1 : c1 = Array("��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��")
		Dim c2 : c2 = Array("460","462","463","450","466","468","470","472","474","476","478","480","482","485","487","489","496","497","499","500","502","503","505","506","508","509","532")
		Dim i
		For i=0 to 26
			str=Replace(str,c1(i),"&#12"&c2(i)&";")
		Next
		encodeJP = str
	End Function

	'**********
	' ������: Length
	' ��  ��: str as the input string
	' ��  ��: �����ַ�������
	'**********
	Function Length(ByVal Str)
		If Trim(Str) = "" Or IsNull(Str) Then
			Length = 0
		Else
			Dim P_len, x
			P_len = 0
			Length = 0
			P_len = Len(Trim(Str))
			For x = 1 To P_len
				If Asc(Mid(Str, x, 1))<0 Then
					Length = Int(Length) + 2
				Else
					Length = Int(Length) + 1
				End If
			Next
		End If
	End Function

	'**********
	' ������: Cut
	' ��  ��: str as the input string
	' ��  ��: �ض��ַ���
	'**********
	Function Cut(ByVal txt,ByVal length,ByVal isEnd)
		Dim x, y, ii
		If txt="" Then Exit Function
		txt = Trim(txt)
		x = Len(txt)
		y = 0
		If x >= 1 Then
			For ii = 1 To x
				If Asc(Mid(txt, ii, 1)) < 0 Or Asc(Mid(txt, ii, 1)) > 255 Then '����Ǻ���
					y = y + 2
				Else
					y = y + 1
				End If
				If y >= length Then
					If isEnd = True Then
						txt = Left(Trim(txt), ii) & "..."  '�ַ����޳�
					Else
						txt = Left(Trim(txt), ii)  '�ַ����޳�
					End If
					Exit For
				End If
			Next
			Cut = txt
		Else
			Cut = ""
		End If
	End Function

	'**********
	' ������: KeyWordLight
	' ��  ��: str as the input string
	' ��  ��: re as regex
	' ��  ��: �����ַ���
	'**********
	Function KeyWordLight(ByVal str, ByVal re)
		Dim s_str, a_re, reg, i
		If Len(str)>0 And Len(re)>0 Then
			s_str = str
			a_re = Split(re, "|")
			For i = 0 To UBound(a_re)
				If Len(Trim(a_re(i)))>0 Then
					s_str = regExpReplace(s_str,"("&a_re(i)&")", "<strong class=""wordlight"">$1</strong>",true)
				End If
			Next
			KeyWordLight = s_str
		End If
	End Function

	'**********
	'��������Validate
	'��  �ã������ж�
	'��  ����str  ----Ҫ������ַ���
	'			  ----�������
	'����ֵ: True ����   False ������
	'**********
	Function Validate(ByVal str, ByVal cType)
		Dim re, obj
		Set obj = New RegExp
		Select Case UCASE(cType)
			Case "KEY" re = "^(([A-Z]*|[a-z]*|\d*|[-_\~!@#\$%\^&\*\.\(\)\[\]\{\}<>\?\\\/\''\""]*)|.{0,5})$|\s"	'�������е��ַ�
			Case "EN" re = "^[A-Za-z]+$"	'Ӣ����ĸ
			Case "CN" re = "^[\u0391-\uFFE5]+$"	'����
			Case "NUM" re = "^\d+$"	'����
			Case "INT" re = "^-?[0-9\,]+$"	'������
			Case "FLOAT" re = "^-?\d+(\.{1}\d+)?$"	'������
			Case "SAFE" re = "^[A-Za-z0-9\_\-]+$"	'���֡���С��ĸ���»��ߡ�����
			Case "EMAIL" re = "^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"	'Email
			Case "PHONE" re = "^((\(\d{3}\))|(\d{3}\-))?(\(0\d{2,3}\)|0\d{2,3}-)?[1-9]\d{6,7}$"	'Phone
			Case "MOBILE" re = "^((\(\d{3}\))|(\d{3}\-))?13\d{9}$"	'Mobile
			Case "IDCARD" re = "^\d{15}(\d{2}[A-Za-z0-9])?$"	'���֤
			Case "ZIP" re = "^[1-9]\d{5}$"	'�ʱ�
			Case "QQ" re = "^[1-9]\d{4,8}$"	'���֤
			Case "URL" re = "^(http|https|ftp):(\/\/|\\\\)(([\w\/\\\+\-~`@:%])+\.)+([\w\/\\\.\=\?\+\-~`@\':!%#]|(&amp;)|&)+"	'URL��ַ
			Case "IMGURL" re = "^((http|https|ftp):(\/\/|\\\\)(([\w\/\\\+\-~`@:%])+\.)+([\w\/\\\.\=\?\+\-~`@\':!%#]|(&amp;)|&)+|\/([\w\/\\\.\=\?\+\-~`@\':!%#]|(&amp;)|&)+)\.(jpeg|jpg|gif|png|bmp)$"	'ͼƬ��ַ
			Case "TIME" re = "^(?=\d)(?:(?!(?:1582(?:\.|-|\/)10(?:\.|-|\/)(?:0?[5-9]|1[0-4]))|(?:1752(?:\.|-|\/)0?9(?:\.|-|\/)(?:0?[3-9]|1[0-3])))(?=(?:(?!000[04]|(?:(?:1[^0-6]|[2468][^048]|[3579][^26])00))(?:(?:\d\d)(?:[02468][048]|[13579][26]))\D0?2\D29)|(?:\d{4}\D(?!(?:0?[2469]|11)\D31)(?!0?2(?:\.|-|\/)(?:29|30))))(\d{4})([-\/.])(0?\d|1[012])\2((?!00)[012]?\d|3[01])(?:$|(?=\x20\d)\x20))?((?:(?:0?[1-9]|1[012])(?::[0-5]\d){0,2}(?:\x20[aApP][mM]))|(?:[01]\d|2[0-3])(?::[0-5]\d){1,2})?$"	'ʱ��
			Case "IP" re = "^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$"	'IP
			Case Else re = cType	'�Զ�������
		End Select
		obj.Pattern = re
		Validate = obj.Test(Trim(str))
		Set obj = Nothing
	End Function
	'**********
	' ������: htmlEncode
	' ��  ��: str as the input string
	' ��  ��: filter html code
	'**********
	Function htmlEncode(ByVal Str)
		If Trim(Str) = "" Or IsNull(Str) Then
			htmlEncode = ""
		Else
			str = Replace(str, """", "&quot;")
			str = Replace(str, ">", "&gt;")
			str = Replace(str, "<", "&lt;")
			htmlEncode = Str
		End If
	End Function

	'**********
	' ������: htmlDecode
	' ��  ��: str as the input string
	' ��  ��: Decode the html tag
	'**********
	Function htmlDecode(ByVal str)
		If Not IsNull(str) And str <> "" Then
			str = Replace(str, "&quot;", """")
			str = Replace(str, "&gt;", ">")
			str = Replace(str, "&lt;", "<")
			htmlDecode = str
		End If
	End Function

	'**********
	' ������: textToHtml
	' ��  ��: str as the input string
	' ��  ��: filter text code
	'**********
	Function textToHtml(ByVal str)
		If Trim(str)="" Then textEncode = "" : Exit Function
		str=replace(str,">","&gt;")
		str=replace(str,"<","&lt;")
		str=replace(str,chr(32)&chr(32)," &nbsp;")
		str=replace(str,chr(9),"&nbsp;&nbsp;&nbsp;&nbsp;")
		str=replace(str,chr(34),"&quot;")
		str=replace(str,chr(39),"&#39;")
		str=replace(str,chr(13)&chr(10),"<br />")
		str=replace(str,chr(13),"")
		str=replace(str,chr(10),"<br />")
		textToHtml = str
	End Function

	'**********
	' ������: htmlToJs
	' ��  ��: str as the input string
	' ��  ��: html��js��ת��
	'**********
	Function htmlToJs(ByVal str)
		If Len(str)>0 Then
			str = replace(str,"\","\\")
			str =replace(str,vbCrlf,"\n")
			htmlToJs = replace(str,"'","\'")
		End If
	End Function

	'********** 
	' ������: formEncode
	' Param: str as a output string
	' ����: ��ʽ�����ύ���ݣ�ת�������ַ�
	'********** 
	Function formEncode(ByVal str)
		If Len(str)>0 Then
			formEncode = Server.htmlEncode(str)
		End If
	End Function

	'**********
	' ������: stripHTML
	' ��  ��: str as the input string
	' ��  ��: ����HTML
	'**********
	Function stripHTML(ByVal strHTML)
		Dim objRegExp, strOutput
		Set objRegExp = New Regexp
		objRegExp.IgnoreCase = true
		objRegExp.Global = true
		objRegExp.Pattern = "<.+?>"
		strOutput = objRegExp.Replace(strHTML, "")
		strOutput = Replace(strOutput, "<", "&lt;")
		strOutput = Replace(strOutput, ">", "&gt;")
		stripHTML = strOutput
		Set objRegExp = Nothing
	End Function

	'**********
	' ������: regExpReplace
	'**********
	Function regExpReplace(ByVal str,ByVal re,ByVal restr,isCase)	'����,����
		If Len(str) > 0 Then
			Dim Obj
			Set Obj = New Regexp
			With Obj
				If isCase Then .IgnoreCase = False Else .IgnoreCase = True 
				.Global = True
				.Pattern = re
				regExpReplace = .Replace(str,restr)
			End With
			Set Obj = Nothing
		End If
	End Function

	'**********
	' ������: randStr
	' ����: Generate a specific length random string
	'**********
	Function randStr(intLength)
		Dim strSeed,seedLength,i
		strSeed = "abcdefghijklmnopqrstuvwxyz1234567890"
		seedLength = len(strSeed)
		For i=1 to intLength
			Randomize
			randStr = randStr & Mid(strSeed,Round((Rnd*(seedLength-1))+1),1)
		Next
	End Function
End Class
%>