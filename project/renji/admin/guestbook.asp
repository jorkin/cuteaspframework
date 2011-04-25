<!--#include file="page.master.asp"-->
<!--#include file="../include/library/upload.asp"-->
<!--#include file="../include/library/file.asp"-->
<!--#include file="../include/helper/interface.asp"-->
<!--#include file="../include/library/page.asp"-->
<%
xDo = LCase(Casp.rq(1,"do",1,"list"))
xId = Casp.rq(1,"id",0,0)
Select Case xDo
Case "list"
	TopCode()
	ProcessList()
Case "delete"
	aId = Casp.Arrays.ToArray(Casp.rq(1,"id",1,""))
	If UBound(aId) = -1 Then alertBack "请选择一项！"
	ProcessDelete()
Case "edit"
	Casp.db.GetRowObject oGuestbook,"select Top 1 * from Guestbook where id="&xId&""
	If isset(oGuestbook) = False And xId <> 0 Then ShowError(Array("没有该答疑！"))
	TopCode()
	ProcessEdit()
Case "save"
	xId = Casp.rq(3,"id",0,0)
	xReplyContent = Request("ReplyContent")
	Casp.db.setRs rs,"select Top 1 * from Guestbook where Id="&xId&"",3
	If rs.eof Then ShowError(Array("参数错误，请返回重试！"))
	If xReplyContent = "" Then 
		rs("IsRead") = 0
	Else
		rs("IsRead") = 1
	End If
	rs("ReplyContent") = xReplyContent
	rs.update
	newId = rs("id")
	Casp.db.CloseRs rs
	alertRedirect "答复成功！",IIF(xId=0,"Guestbook.asp?do=edit&id="&newId,Casp.refererUrl)
End Select

Sub ProcessList()
	Casp.page.Conn = Casp.db.conn
	Casp.page.PageID = Trim(Request("PageID"))
	Casp.page.Size = 10
	Casp.page.Header_a rs,"Guestbook","*","","","id desc"
%>
<div id="inner">
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;答疑列表</div>
	<div id="main">
		<form action="?do=delete" method="post" name="myform">
			<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
				<tbody>
					<tr class="none">
						<th width="50"><input type="checkbox" class="checkall" rel="input:checkbox[name=id]" /> ID</th>
						<th width="120">姓名</th>
						<th width="300">问题描述摘要</th>
						<th width="130">提问时间</th>
						<th width="50">状态</th>
						<th>&nbsp;</th>
					</tr>
					<%Do While Not rs.eof%>
					<tr style="<%=IIF(rs("isRead"),"","background:#FFF0F0")%>">
						<td><input type="checkbox" name="id" value="<%=rs("id")%>" />
							<%=rs("id")%></td>
						<td><%=rs("UserName")%></td>
						<td><%=Casp.String.Cut(rs("Content"),120,true)%><br /><br /></td>
						<td><%=rs("addtime")%></td>
						<td><%=IIF(rs("IsRead"),"<span style=""color:silver"">已答复</span>","<span style=""color:red"">未答复</span>")%></td>
						<td><a href="?do=edit&id=<%=rs("id")%>" class="comm"><%=IIF(rs("IsRead"),"查看","答复")%></a>&nbsp;&nbsp;<a href="?do=delete&id=<%=rs("id")%>"  onClick="javascript:return confirm('真的要删除吗?')"  class="comm">删除</a></td>
					</tr>
					<%
						rs.MoveNext
					Loop
					%>
					<tr>
						<td colspan="9">
						<div class="btn_o"><div class="btn_i"><a href="javascript:if(confirm('真的要删除吗?'))document.forms[0].submit();">删除所选</a></div></div>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="pagelist"><%Casp.Page.Footer_a "","&do=list"%></div>
		</form>
	</div>
</div>
<%
	Casp.db.closeRs rs
End Sub

Sub ProcessEdit()
%>
<div id="inner">
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;<a href="Guestbook.asp">答疑管理</a>&nbsp;-&nbsp;
		<%=IIF(isset(oGuestbook),"答复","添加")%>&nbsp;<%=oGuestbook("UserName")%>的提问
	</div>
	<div id="main">
		<form action="?do=save" method="post" name="myform">
			<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
				<tbody>
					<tr class="">
						<td class="label" width="100">姓名</td>
						<td><%=oGuestbook("UserName")%></td>
					</tr>
					<tr class="">
						<td class="label">提问时间</td>
						<td><%=oGuestbook("addtime")%></td>
					</tr>
					<tr class="">
						<td class="label">问题描述</td>
						<td><%=Casp.String.TextToHtml(oGuestbook("content"))%></td>
					</tr>
					<tr class="">
						<td class="label">答复内容</td>
						<td><textarea class="textarea" name="replycontent" rows="5"><%=oGuestbook("replycontent")%></textarea></td>
					</tr>
					<tr class="">
						<td class="label">答复状态</td>
						<td><%=IIF(oGuestbook("IsRead"),"<span style=""color:silver"">已答复</span>","<span style=""color:red"">未答复</span>")%></td>
					</tr>
					<tr class="none">
						<td class="label"></td>
						<td><input type="submit" class="button" value="保存" name="submit" id="submit"></td>
					</tr>
				</tbody>
			</table>
			<input type="hidden" value="<%=xId%>" name="id" id="id">
			<input type="hidden" value="save" name="do">
			<input type="hidden" value="yes" name="save" id="save">
		</form>
	</div>
</div>
<%
End Sub
Sub ProcessDelete()
	Casp.db.setRs rs,"select * from Guestbook where id in ("&Join(aId,",")&")",3
	Do While Not rs.eof
		If Casp.File.DelFolder(Casp.WebConfig("SitePath")&Casp.WebConfig("GuestbookPath") & "/" & rs("id") & "/") Then
			rs.delete
			rs.update
		End If
		rs.MoveNext
	Loop
	locationHref Casp.RefererUrl
End Sub
%>
