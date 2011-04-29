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
	Casp.db.GetRowObject oPager,"select Top 1 * from Pager where id="&xId&""
	If isset(oPager) = False And xId <> 0 Then ShowError(Array("没有该试卷！"))
	TopCode()
	ProcessEdit()
Case "save"
	xId = Casp.rq(3,"id",0,0)
	xTitle = Casp.rq(3,"Title",1,"")
	If xTitle = "" Then alertBack "必须填写试卷标题"
	xLanguage = Casp.rq(3,"Language",1,"")
	If xId = 0 Then
		Casp.db.setRs rs,"select Top 1 * from Pager",3
		rs.addnew
	Else
		Casp.db.setRs rs,"select Top 1 * from Pager where Id="&xId&"",3
		If rs.eof Then ShowError(Array("参数错误，请返回重试！"))
	End If
	rs("Title") = xTitle
	rs("Language") = xLanguage
	rs.update
	newId = rs("id")
	Casp.db.CloseRs rs
	alertRedirect "更新成功！",IIF(xId=0,"pager.asp?do=list&lang="&Request.QueryString("lang"),Casp.refererUrl)
End Select

Sub ProcessList()
	Casp.page.Conn = Casp.db.conn
	Casp.page.PageID = Trim(Request("PageID"))
	Casp.page.Size = 25
	If request.querystring("lang")="en" Then
		Casp.page.Header_a rs,"Pager","*","[language]='en'","","id desc"
	Else
		Casp.page.Header_a rs,"Pager","*","[language]='cn'","","id desc"
	End If
%>
<div id="inner">
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;试卷列表</div>
	<div id="main">
      <dl class="tabs">
        <dt>
        <a href="pager.asp?do=list" <%=IIF(Request("lang")<>"en","class=""curr""","")%>>中文</a>
        <a href="Pager.asp?do=list&lang=en" <%=IIF(Request("lang")="en","class=""curr""","")%>>English</a>
        </dt>
        <dd>
		<form action="?do=delete" method="post" name="myform">
			<div class="active">
			</div>
			<div class="active">
				<%If request.querystring("lang")="en" Then%>
				<div class="btn_o"><div class="btn_i"><a href="Pager.asp?do=edit&lang=en">Add Pager</a></div></div>
				<%Else%>
				<div class="btn_o"><div class="btn_i"><a href="Pager.asp?do=edit&lang=cn">添加试卷</a></div></div>
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
						<td><a href="../pager.asp?id=<%=rs("id")%>" target="_blank"><%=rs("Title")%></a></td>
						<td><a href="question.asp?do=list&pid=<%=rs("id")%>" class="comm">设置题目</a>&nbsp;&nbsp;<a href="?do=edit&id=<%=rs("id")%>" class="comm">编辑</a>&nbsp;&nbsp;<a href="?do=delete&id=<%=rs("id")%>"  onClick="javascript:return confirm('真的要删除吗?')"  class="comm">删除</a></td>
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
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;<a href="Pager.asp">试卷管理</a>&nbsp;-&nbsp;
		<%=IIF(isset(oPager),"编辑","添加")%>&nbsp;<%If isset(oPager) Then echo oPager("Title") Else echo "试卷"%>
	</div>
	<div id="main">
		<form action="?do=save" method="post" name="myform" enctype="multipart/form-data">
			<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
				<tbody>
					<tr class="">
						<td class="label" width="100">语言</td>
						<td><label><input type="radio" name="language" class="radio" value="cn" checked />中文</label> <label><input type="radio" name="language" class="radio" value="en" <%If xId<>0 Then echo IIF(oPager("language")="en","checked","") Else echo IIF(Request("lang")="en","checked","")%> />Enlgish</label></td>
					</tr>
					<tr class="">
						<td class="label">标题</td>
						<td><input type="text" name="title" class="text" id="title" value="<%If xId<>0 Then echo oPager("title")%>" size="40" /></td>
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
	Call Casp.db.Conn.Execute("delete from Pager where id in ("&Join(aId,",")&")",flag)
	If flag > 0 Then
		locationHref Casp.RefererUrl
	Else
		alertBack "删除失败！"
	End If
End Sub
%>
