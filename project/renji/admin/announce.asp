<!--#include file="page.master.asp"-->
<!--#include file="../include/library/upload.asp"-->
<!--#include file="../include/library/file.asp"-->
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
	Casp.db.GetRowObject oAnnounce,"select Top 1 * from Announce where id="&xId&""
	If isset(oAnnounce) = False And xId <> 0 Then ShowError(Array("没有该公告！"))
	TopCode()
	ProcessEdit()
Case "save"
	xId = Casp.rq(3,"id",0,0)
	xTitle = Casp.rq(3,"Title",1,"")
	If xTitle = "" Then alertBack "必须填写公告标题"
	xSortId = Casp.rq(3,"sortid",0,0)
	xContent = Request.Form("Content")
	xLanguage = Casp.rq(3,"Language",1,"")
	If xId = 0 Then
		Casp.db.setRs rs,"select Top 1 * from Announce",3
		rs.addnew
	Else
		Casp.db.setRs rs,"select Top 1 * from Announce where Id="&xId&"",3
		If rs.eof Then ShowError(Array("参数错误，请返回重试！"))
	End If
	rs("Title") = xTitle
	rs("Content") = xContent
	rs("SortID") = xSortId
	rs("Language") = xLanguage
	rs("addtime") = Now()
	rs.update
	newId = rs("id")
	Casp.db.CloseRs rs
	alertRedirect "更新成功！",IIF(xId=0,"Announce.asp?do=list&lang="&Request.QueryString("lang"),Casp.refererUrl)
End Select

Sub ProcessList()
	Casp.page.Conn = Casp.db.conn
	Casp.page.PageID = Trim(Request("PageID"))
	Casp.page.Size = 25
	If request.querystring("lang")="en" Then
		Casp.page.Header_a rs,"Announce","*","[language]='en'","","sortid desc,id desc"
	Else
		Casp.page.Header_a rs,"Announce","*","[language]='cn'","","sortid desc,id desc"
	End If
%>
<div id="inner">
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;公告列表</div>
	<div id="main">
      <dl class="tabs">
        <dt>
        <a href="Announce.asp?do=list" <%=IIF(Request("lang")<>"en","class=""curr""","")%>>中文</a>
        <a href="Announce.asp?do=list&lang=en" <%=IIF(Request("lang")="en","class=""curr""","")%>>English</a>
        </dt>
        <dd>
		<form action="?do=delete" method="post" name="myform">
			<div class="active">
			</div>
			<div class="active">
				<%If request.querystring("lang")="en" Then%>
				<div class="btn_o"><div class="btn_i"><a href="Announce.asp?do=edit&lang=en">Add Announce</a></div></div>
				<%Else%>
				<div class="btn_o"><div class="btn_i"><a href="Announce.asp?do=edit&lang=cn">添加公告</a></div></div>
				<%End If%>
			</div>
			<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
				<tbody>
					<tr class="none">
						<th width="50"><input type="checkbox" class="checkall" rel="input:checkbox[name=id]" /> ID</th>
						<th width="200">标题</th>
						<th>&nbsp;</th>
					</tr>
					<%Do While Not rs.eof%>
					<tr>
						<td><input type="checkbox" name="id" value="<%=rs("id")%>" />
							<%=rs("id")%></td>
						<td><a href="../show.asp?id=<%=rs("id")%>" target="_blank"><%=rs("Title")%></a></td>
						<td><a href="?do=edit&id=<%=rs("id")%>" class="comm">编辑</a>&nbsp;&nbsp;<a href="?do=delete&id=<%=rs("id")%>"  onClick="javascript:return confirm('真的要删除吗?')"  class="comm">删除</a></td>
					</tr>
					<%
						rs.MoveNext
					Loop
					%>
					<tr>
						<td colspan="5">
						<div class="btn_o"><div class="btn_i"><a href="javascript:if(confirm('真的要删除吗?'))document.forms[0].submit();">删除所选</a></div></div>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="pagelist"><%Casp.Page.Footer_a "","&do=list"%></div>
		</form>
		</dd>
	</div>
</div>
<%
	Casp.db.closeRs rs
End Sub

Sub ProcessEdit()
%>
<div id="inner">
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;<a href="Announce.asp">公告管理</a>&nbsp;-&nbsp;
		<%=IIF(isset(oAnnounce),"编辑","添加")%>&nbsp;<%If isset(oAnnounce) Then echo oAnnounce("Title") Else echo "公告"%>
	</div>
	<div id="main">
		<form action="?do=save" method="post" name="myform">
			<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
				<tbody>
					<tr class="">
						<td class="label" width="100">语言</td>
						<td><label><input type="radio" name="language" class="radio" value="cn" checked />中文</label> <label><input type="radio" name="language" class="radio" value="en" <%If xId<>0 Then echo IIF(oAnnounce("language")="en","checked","") Else echo IIF(Request("lang")="en","checked","")%> />Enlgish</label></td>
					</tr>
					<tr class="">
						<td class="label">标题</td>
						<td><input type="text" name="title" class="text" id="title" value="<%If xId<>0 Then echo oAnnounce("title")%>" size="40" /></td>
					</tr>
					<tr>
						<td class="label">排序(OrderID)</td>
						<td><input type="text" name="sortid" class="text" id="sortid" value="<%If xId<>0 Then echo oAnnounce("sortid")%>" /></td>
					</tr>
					<tr class="">
						<td class="label">内容</td>
						<td><textarea class="fckeditor" style="width:550px;height:300px;" name="content" id="content"><%If xId<>0 Then echo oAnnounce("Content")%></textarea></td>
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
	Call Casp.db.Conn.Execute("delete from Announce where id in ("&Join(aId,",")&")",flag)
	If flag > 0 Then
		locationHref Casp.RefererUrl
	Else
		alertBack "删除失败！"
	End If
End Sub
%>
