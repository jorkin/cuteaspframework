<!--#include file="page.master.asp"-->
<!--#include file="../include/helper/md5.asp"-->
<%
xDo = LCase(Casp.rq(1,"do",1,""))
If xDo = "save" Then
	xPassword = Casp.rq(1,"password",1,"")
	xRePassword = Casp.rq(1,"repassword",1,"")
	If xPassword = "" Then alertBack "密码不能为空！"
	If xPassword <> xRePassword Then alertBack "两次密码不一致，请确认"
	Casp.db.setRs rs,"select Top 1 * from Manager where UserName='admin'",3
	If rs.eof Then ShowError(Array("参数错误，请返回重试！"))
	rs("password") = Casp.md5.encode(xPassword,16)
	rs.update
	Casp.db.CloseRs rs
	alertRedirect "更新成功！",Casp.refererUrl
End If

TopCode()
Call ProcessModule()

Sub ProcessModule()
%>
<div id="inner">
  <div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;管理员密码修改</div>
  <div id="main">
    <form action="?m=<%=xModule%>&do=save" method="post" name="myform">
	  <table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
		<tbody>
		  <tr class="">
			<td class="label" width="90">修改密码：</td>
			<td><input type="text" name="password" class="text" id="password" value="" /></td>
		  </tr>
		  <tr class="">
			<td class="label">再次确认密码：</td>
			<td><input type="text" name="repassword" class="text" id="repassword" value="" /></td>
		  </tr>
		  <tr class="none">
			<td class="label"></td>
			<td>
			  <input type="submit" class="button" value="确认修改" name="submit" id="submit"></td>
		  </tr>
		</tbody>
	  </table>
		<input type="hidden" value="1" name="id" id="id">
		<input type="hidden" value="save" name="do">
		<input type="hidden" value="yes" name="save" id="save">
    </form>
  </div>
</div>
<%
End Sub
%>
