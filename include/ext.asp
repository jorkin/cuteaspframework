<%
'**********
'	class		: A Extensive function Library
'	File Name	: ext.asp
'	Version		: 0.2.0
'	Author		: TerranC
'	Date		: 2008-4-3
'**********
'**********
'	示例
'**********

'**********
' 函数名: echo
' 参  数: str as a output string
' 作  用: Print the value of a variable
'**********
Sub echo(ByVal str)
    Response.Write str
End Sub

'**********
' 函数名: isNothing
' 参  数: Obj as a object
' 作  用: isNothing — Check if the object is nothing
'**********
Function isNothing(Obj)
    If Not IsObject(Obj) Then
        isNothing = true
        Exit Function
    End If
    If Obj Is Nothing Then
        isNothing = true
        Exit Function
    End If
    If IsNull(Obj) Then
        IsNothing = true
        Exit Function
    End If
    If IsEmpty(Obj) Then
        IsNothing = true
        Exit Function
    End If
    isNothing = false
End Function

'**********
' 函数名: regReplace
' 参  数: DateTime as the input time
' 参  数: format as the formating type
' 作  用: formatDate — Format Date
'**********
Function regReplace(ByVal str,restr,re,isCase)'内容,正则
	If Len(str) > 0 Then
		Dim Obj
		Set Obj = New Regexp
		With Obj
			If isCase Then .IgnoreCase = False Else .IgnoreCase = True 
			.Global = True
			.Pattern = re
			regReplace = .Replace(str,restr)
		End With
		Set Obj = Nothing
	End If
End Function

'**********
'函数名：ReturnObj
'作  用：返回一个对象
'返回值：对象包含三个参数(Code,Message,AttachObject)
'**********
Function returnObj()
	On Error Resume Next
	TypeName(New AopResult)
	If Err Then
		Set returnObj = ReAopResult()	'调用js重定义的AopResult
		Err.Clear
	Else
		Set returnObj = New AopResult
	End If
	On Error Goto 0
End Function

'**********
' 函数名: URLDecode
' 作  用: URLDecode — URL decode
'**********
Function URLDecode(ByVal vstrin)
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
	URLDecode = strreturn
End Function

'**********
'函数名：Confirm
'作  用：确认窗口
'**********	
Function clickConfirm(msgstr)
	clickConfirm = " onClick=""javascript:return confirm('"&msgstr&"')"" "
End Function

'**********
'函数名：locationHref
'作  用：页面跳转
'**********
Sub locationHref(url)
	On Error Resume Next
	Response.Redirect url
	die()
	On Error Goto 0
End Sub

'**********
'函数名：Referer
'作  用：返回上页
'**********
Sub locationReferer()
	On Error Resume Next
	locationHref(Request.ServerVariables("HTTP_REFERER"))
	die()
	On Error Goto 0
End Sub

'**********
'函数名：AlertRedirect
'作  用：消息框
'**********
Sub alertRedirect(msgstr,url)
	On Error Resume Next
	echo "<script type=""text/javascript"" language=""javascript"">"&vbCr& _
			"alert("""&msgstr&""");"&vbCr& _
			"location.href="""&url&""";"&vbCr& _
			"</script>"
	die()
	On Error Goto 0
End Sub
%>
<script runat="server" language="jscript">
//********** 
// 函数名: die
// Param: str as a output string
// 作用: Print the value of a variable and exit the procedure
//********** 
var die = function(str){
	echo(str);
	Response.End();
}
//********** 
// 函数名: die
// Param: str as a output string
// 作用: Print the value of a variable and exit the procedure
//********** 
var ReAopResult = function(){
	function createClass(){
		this.Code = null;
		this.Message = null;
		this.AttachObject = null;
	}
	return new createClass();
}

//**********
// 函数名: randStr
// 作用: Generate a specific length random string
//**********
var randStr = function(StrLen){
	var tmpStr = "abcdefghijklmnopqrstuvwxyz0123456789";
	var i, ti;
	var temp = "";
	for(var i = 1; i < (StrLen == undefined ? 8 : StrLen+1); i++){
		ti = 0;
		while(ti == 0){
			ti = Math.round(Math.floor(35 * Math.random()+1));
			temp = temp + tmpStr.substr(ti, 1);
		}
	}
	temp = (StrLen == undefined ? new Date().getTime().toString() + temp : temp);
	return temp.toUpperCase();
}
//**********
//函数名：AlertBack
//参  数：back	-- true返回;false不返回
//作  用：消息框
//**********
function alertBack(msgstr, isback){
	if(isback == undefined) isback = true;
	Response.Write("<scr"+"ipt type=\"text/javascript\" language=\"javascript\">alert(\"" + msgstr + "\");");
	if (isback == true) Response.Write("history.back(-1);");
	Response.Write("</sc"+"ript>");
	if (isback == true) Response.End();
}

</script>