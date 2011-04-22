<!--#include file="page.master.asp"-->
<!--#include file="../include/helper/validcode.asp"-->
<!--#include file="../include/helper/md5.asp"-->
<%
If Request("action") = "login" Then
	If Casp.validcode.Check(Casp.rq(3,"validcode",1,"")) = False Then
		alertBack "验证码错误"
	End If
	Casp.db.Exec rs,"select * from Manager where username='"&Casp.rq(3,"username",1,"")&"' and password='"&Casp.md5.encode(Casp.rq(3,"password",1,""),16)&"'"
	If rs.eof Then
		alertBack("输入有误，请重新尝试！")
	Else
		Casp.Session.Timeout = 60
		Casp.Session.Set "username",rs("username").value
		locationHref("news.asp?do=list")
	End If
	Casp.db.CloseRs(rs)
ElseIf Request("action") = "logout" Then
	Casp.Session.RemoveAll()
	locationHref("default.asp")
End If
%>
<%Call Header()%>
<div id="login"><span class="title"><%=Casp.WebConfig("SiteTitle")%>&nbsp;管理系统</span>
  <hr size="1" style="color: #EEE; background-color: #EEE; height: 1px; border: 0;" />
  <form method="post" name="myform">
    <table width="100%" border="0" cellpadding="5" cellspacing="0" class="login_form">
      <tr>
        <td class="login_form" width="80">用户名:</td>
        <td><input type="text" size="40" id="username" name="username" value="" class="input" maxlength="50" /></td>
      </tr>
      <tr>
        <td class="login_form">密码:</td>
        <td><input type="password" size="40" id="password" name="password" value="" class="input" maxlength="50" /></td>
      </tr>
      <tr>
        <td class="login_form">验证码:</td>
        <td><input type="text" size="5" id="validcode" name="validcode" value="" class="input" maxlength="5" /><%=Casp.validcode.GetCode("../","int")%></td>
      </tr>
      <tr>
        <td></td>
        <td><input type="hidden" id="action" name="action" value="login" />
          <input type="submit" id="submit" name="submit" value="登入系统" class="button" /></td>
      </tr>
    </table>
  </form>
</div>