<%
'**********
'	class		: A String class
'	File Name	: String.asp
'	Version		: 0.2.0
'	Author		: TerranC
'	Date		: 2008-6-16
'**********


'**********
'	示例
'**********

'**********
'	构建类
'**********

Class Class_String
	'**********
    ' 函数名: class_Initialize
    ' 作  用: Constructor
    '**********
	Private Sub Class_Initialize()
    End Sub

	'**********
	' 函数名: Length
	' 参  数: str as the input string
	' 作  用: 计算字符串长度
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
	' 函数名: Cut
	' 参  数: str as the input string
	' 作  用: 截断字符串
	'**********
	Function Cut(ByVal txt,ByVal length,ByVal isEnd)
		Dim x, y, ii
		If txt="" Then Exit Function
		txt = Trim(txt)
		x = Len(txt)
		y = 0
		If x >= 1 Then
			For ii = 1 To x
				If Asc(Mid(txt, ii, 1)) < 0 Or Asc(Mid(txt, ii, 1)) > 255 Then '如果是汉字
					y = y + 2
				Else
					y = y + 1
				End If
				If y >= length Then
					If isEnd = True Then
						txt = Left(Trim(txt), ii) & "..."  '字符串限长
					Else
						txt = Left(Trim(txt), ii)  '字符串限长
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
	' 函数名: KeyWordLight
	' 参  数: str as the input string
	' 参  数: re as regex
	' 作  用: 高亮字符串
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
	'函数名：Validate
	'作  用：正则判断
	'参  数：str  ----要检验的字符串
	'			  ----正则规则
	'返回值: True 符合   False 不符合
	'**********
	Function Validate(ByVal str, ByVal cType)
		Dim re, obj
		Set obj = New RegExp
		Select Case UCASE(cType)
			Case "KEY" re = "^(([A-Z]*|[a-z]*|\d*|[-_\~!@#\$%\^&\*\.\(\)\[\]\{\}<>\?\\\/\''\""]*)|.{0,5})$|\s"	'键盘上有的字符
			Case "EN" re = "^[A-Za-z]+$"	'英文字母
			Case "CN" re = "^[\u0391-\uFFE5]+$"	'中文
			Case "NUM" re = "^\d+$"	'数字
			Case "INT" re = "^-?[0-9\,]+$"	'正整数
			Case "FLOAT" re = "^-?\d+(\.{1}\d+)?$"	'浮点数
			Case "SAFE" re = "^[A-Za-z0-9\_\-]+$"	'数字、大小字母、下划线、横线
			Case "EMAIL" re = "^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"	'Email
			Case "PHONE" re = "^((\(\d{3}\))|(\d{3}\-))?(\(0\d{2,3}\)|0\d{2,3}-)?[1-9]\d{6,7}$"	'Phone
			Case "MOBILE" re = "^((\(\d{3}\))|(\d{3}\-))?13\d{9}$"	'Mobile
			Case "IDCARD" re = "^\d{15}(\d{2}[A-Za-z0-9])?$"	'身份证
			Case "ZIP" re = "^[1-9]\d{5}$"	'邮编
			Case "QQ" re = "^[1-9]\d{4,8}$"	'身份证
			Case "URL" re = "^(http|https|ftp):(\/\/|\\\\)(([\w\/\\\+\-~`@:%])+\.)+([\w\/\\\.\=\?\+\-~`@\':!%#]|(&amp;)|&)+"	'URL地址
			Case "IMGURL" re = "^((http|https|ftp):(\/\/|\\\\)(([\w\/\\\+\-~`@:%])+\.)+([\w\/\\\.\=\?\+\-~`@\':!%#]|(&amp;)|&)+|\/([\w\/\\\.\=\?\+\-~`@\':!%#]|(&amp;)|&)+)\.(jpeg|jpg|gif|png|bmp)$"	'图片地址
			Case "TIME" re = "^(?=\d)(?:(?!(?:1582(?:\.|-|\/)10(?:\.|-|\/)(?:0?[5-9]|1[0-4]))|(?:1752(?:\.|-|\/)0?9(?:\.|-|\/)(?:0?[3-9]|1[0-3])))(?=(?:(?!000[04]|(?:(?:1[^0-6]|[2468][^048]|[3579][^26])00))(?:(?:\d\d)(?:[02468][048]|[13579][26]))\D0?2\D29)|(?:\d{4}\D(?!(?:0?[2469]|11)\D31)(?!0?2(?:\.|-|\/)(?:29|30))))(\d{4})([-\/.])(0?\d|1[012])\2((?!00)[012]?\d|3[01])(?:$|(?=\x20\d)\x20))?((?:(?:0?[1-9]|1[012])(?::[0-5]\d){0,2}(?:\x20[aApP][mM]))|(?:[01]\d|2[0-3])(?::[0-5]\d){1,2})?$"	'时间
			Case "IP" re = "^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$"	'IP
			Case Else re = cType	'自定义正则
		End Select
		obj.Pattern = re
		Validate = obj.Test(Trim(str))
		Set obj = Nothing
	End Function

	'**********
	' 函数名: textToHtml
	' 参  数: str as the input string
	' 作  用: filter text code
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
	' 函数名: htmlToJs
	' 参  数: str as the input string
	' 作  用: html到js的转换
	'**********
	Function htmlToJs(ByVal str)
		If Len(str)>0 Then
			str = replace(str,"\","\\")
			str = replace(str,vbCrlf,"\n")
			str = replace(str,"""","\""")
			htmlToJs = replace(str,"'","\'")
		End If
	End Function

	'**********
	' 函数名: stripHTML
	' 参  数: str as the input string
	' 作  用: 过滤HTML
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
	' 函数名: regExpReplace
	'**********
	Function regExpReplace(ByVal str,ByVal re,ByVal restr,isCase)	'内容,正则
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
End Class
%>