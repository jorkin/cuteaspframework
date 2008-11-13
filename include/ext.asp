<%
'**********
'	class		: A Extensive function Library
'	File Name	: ext.asp
'	Version		: 0.2.0
'	Author		: TerranC
'	Date		: 2008-4-3
'**********
'**********
'	ʾ��
'**********

'**********
' ������: echo
' ��  ��: str as a output string
' ��  ��: Print the value of a variable
'**********
Sub echo(ByVal str)
    Response.Write str
End Sub

'**********
' ������: isset
' ��  ��: Obj as a object
' ��  ��: isNothing �� Check if the object is nothing or null or undefined
'**********
Function isset(Obj)
    isset = true
    If IsEmpty(Obj) Then
        isset = false
        Exit Function
    End If
    If IsNull(Obj) Then
        isset = false
        Exit Function
    End If
	If IsObject(Obj) Then
		If Obj Is Nothing Then
			isset = false
			Exit Function
		End If
	Else
		If Obj = "" Then
			isset = false
			Exit Function
		End If
	End If
End Function

'**********
'��������Confirm
'��  �ã�ȷ�ϴ���
'**********	
Function clickConfirm(msgstr)
	clickConfirm = " onclick=""javascript:return confirm('"&msgstr&"')"" "
End Function

'**********
'��������locationHref
'��  �ã�ҳ����ת
'**********
Sub locationHref(url)
	Response.Redirect url
	die("")
End Sub

'**********
'��������Referer
'��  �ã�������ҳ
'**********
Sub locationReferer()
	locationHref(Request.ServerVariables("HTTP_REFERER"))
	die("")
End Sub

'**********
'��������AlertRedirect
'��  �ã���Ϣ��
'**********
Sub alertRedirect(msgstr,url)
	die "<script type=""text/javascript"">"&vbCr& _
			"alert("""&msgstr&""");"&vbCr& _
			"location.replace("""&url&""");"&vbCr& _
			"</script>"
End Sub

'**********
'��������AlertBack
'��  ����msgstr	-- ������Ϣ
'��  �ã���Ϣ��
'**********
Sub alertBack(msgstr)
	die "<script type=""text/javascript"">alert(""" + msgstr + """);history.back(-1);</script>"
End Sub

'********** 
' ������: die
' Param: str as a output string
' ����: Print the value of a variable and exit the procedure
'********** 
Sub die(str)
	echo(str)
	Response.End()
End Sub

'********** 
' ����: ReAopResult
'********** 
Class ReAopResult
	Public Code
	Public Message
	Public AttachObject
End Class
%>