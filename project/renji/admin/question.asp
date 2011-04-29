<!--#include file="page.master.asp"-->
<!--#include file="../include/library/upload.asp"-->
<!--#include file="../include/library/file.asp"-->
<!--#include file="../include/library/page.asp"-->
<%
xDo = LCase(Casp.rq(1,"do",1,"list"))
xId = Casp.rq(1,"id",0,0)
xPid = Casp.rq(1,"pid",0,0)

aResult = Array("","A","B","C","D")

Casp.db.GetRowObject oPager,"select Top 1 * from Pager where id="&xPid&""
If isset(oPager) = False And xPid <> 0 Then ShowError(Array("没有该试卷！"))

Select Case xDo
Case "list"
	TopCode()
	ProcessList()
Case "delete"
	aId = Casp.Arrays.ToArray(Casp.rq(1,"id",1,""))
	If UBound(aId) = -1 Then alertBack "请选择一项！"
	ProcessDelete()
Case "edit"
	Casp.db.GetRowObject oQuestion,"select Top 1 * from Question where id="&xId&""
	If isset(oQuestion) = False And xId <> 0 Then ShowError(Array("没有该题目！"))
	TopCode()
	ProcessEdit()
Case "save"
	xId = Casp.rq(3,"id",0,0)
	xTitle = Casp.rq(3,"Title",1,"")
	If xTitle = "" Then alertBack "必须填写题目标题"
	xLanguage = Casp.rq(3,"Language",1,"")
	If xId = 0 Then
		Casp.db.setRs rs,"select Top 1 * from Question",3
		rs.addnew
	Else
		Casp.db.setRs rs,"select Top 1 * from Question where Id="&xId&"",3
		If rs.eof Then ShowError(Array("参数错误，请返回重试！"))
	End If
	rs("Title") = xTitle
	rs("Language") = xLanguage
	rs.update
	newId = rs("id")
	Casp.db.CloseRs rs
	alertRedirect "更新成功！",IIF(xId=0,"Question.asp?do=list&lang="&Request.QueryString("lang"),Casp.refererUrl)
End Select

Sub ProcessList()
	Casp.page.Conn = Casp.db.conn
	Casp.page.PageID = Trim(Request("PageID"))
	Casp.page.Size = 25
	Casp.page.Header_a rs,"Question","*","pid="&xPid&"","","id desc"
%>
<div id="inner">
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;<a href="pager.asp?do=list">试卷管理</a>&nbsp;-&nbsp;<%=oPager("Title")%>&nbsp;-&nbsp;题目列表</div>
	<div id="main">
      <dl class="tabs">
		<form action="?do=delete" method="post" name="myform">
			<div class="active">
				<h2 class="title"><%=oPager("Title")%></h2>
			</div>
			<div class="active">
				<div class="btn_o"><div class="btn_i"><a href="Question.asp?do=edit&lang=cn">添加题目</a></div></div>
			</div>
			<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
				<tbody>
					<tr class="none">
						<th width="50"><input type="checkbox" class="checkall" rel="input:checkbox[name=id]" /> ID</th>
						<th width="60">类型</th>
						<th width="280">题目</th>
						<th width="100">答案</th>
						<th>&nbsp;</th>
					</tr>
					<%
					
					Do While Not rs.eof
						If rs("result") <> "" Then
							On Error Resume Next
							Casp.db.Exec rs1,"select id from options (nolock) where id in ("&rs("result")&")"
							If not rs1.eof Then
								result_str = rs1.GetString(,,"",",","")
							End If
							rs1.close
							Err.clear
							On Error Goto 0
						End If
					%>
					<tr>
						<td><input type="checkbox" name="id" value="<%=rs("id")%>" />
							<%=rs("id")%></td>
						<td><%=IIF(rs("qtype")=1,"多选","单选")%></td>
						<td><%=rs("Title")%></td>
						<td><%=result_str%></td>
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
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;<a href="Question.asp">题目管理</a>&nbsp;-&nbsp;
		<%=IIF(isset(oQuestion),"编辑","添加")%>&nbsp;<%If isset(oQuestion) Then echo oQuestion("Title") Else echo "题目"%>
	</div>
	<div id="main">
		<form action="?do=save" method="post" name="myform" enctype="multipart/form-data">
			<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
				<tbody>
					<tr class="">
						<td class="label" width="100">题目</td>
						<td><input type="text" name="question" class="text" id="question" value="<%If xId<>0 Then echo oQuestion("question")%>" size="40" /></td>
					</tr>
					<tr class="">
						<td class="label" width="100">排序</td>
						<td><input type="text" name="sortid" class="text" id="sortid" value="<%If xId<>0 Then echo oQuestion("sortid")%>" size="40" /></td>
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
	Call Casp.db.Conn.Execute("delete from Question where id in ("&Join(aId,",")&")",flag)
	If flag > 0 Then
		locationHref Casp.RefererUrl
	Else
		alertBack "删除失败！"
	End If
End Sub
%>
