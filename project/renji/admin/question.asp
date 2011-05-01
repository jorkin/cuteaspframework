<!--#include file="page.master.asp"-->
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
	xQtype = Casp.rq(3,"qtype",0,0)
	xQuestion = Casp.rq(3,"Question",1,"")
	If xQuestion = "" Then alertBack "必须填写题目标题"
	xSortId = Casp.rq(3,"SortId",0,0)

	aQId = Split(Replace(Casp.rq(3,"q_id",1,"")," ",""),",")
	aQ_option = Split(Replace(Casp.rq(3,"q_option",1,"")," ",""),",")
	aQ_sortid = Split(Replace(Casp.rq(3,"q_sortid",1,"")," ",""),",")
	aQ_result = Split(Replace(Casp.rq(3,"q_result",1,"")," ",""),",")

	If UBound(aQ_option) < 2 Then
		alertBack "至少需要两个选项！"
	End If

	If Casp.Arrays.Search(aQ_result,1) = False Then
		alertBack "没有一个正确答案？"
	End If


	If xId = 0 Then
		Casp.db.setRs rs,"select Top 1 * from Question",3
		rs.addnew
	Else
		Casp.db.setRs rs,"select Top 1 * from Question where Id="&xId&"",3
		If rs.eof Then ShowError(Array("参数错误，请返回重试！"))
	End If
	rs("Pid") = xPid
	rs("Question") = xQuestion
	rs("SortId") = xSortId
	rs("Qtype") = xQtype
	rs.update
	newId = rs("id")
	Dim aResult
	aResult = Array()
	For i = 0 To  UBound(aQ_option)
		If aQ_option(i) <> "" Then
			If aQId(i) = 0 Then
				Casp.db.setRs rs1,"select Top 1 * from Options",3
				rs1.addnew
			Else
				Casp.db.setRs rs1,"select Top 1 * from Options where Id="&aQId(i)&"",3
				If rs1.eof Then ShowError(Array("参数错误，请返回重试！"))
			End If
			rs1("Qid") = newId
			rs1("option") = aQ_option(i)
			rs1("sortId") = aQ_sortid(i)
			rs1("isresult") = aQ_result(i)
			rs1.update
			Casp.db.CloseRs rs1
		End If
	Next
	Casp.db.CloseRs rs
	alertRedirect "更新成功！",IIF(xId=0,"Question.asp?do=list&pid="&xPid,Casp.refererUrl)
End Select

Sub ProcessList()
	Casp.page.Conn = Casp.db.conn
	Casp.page.PageID = Trim(Request("PageID"))
	Casp.page.Size = 50
	Casp.page.Header_a rs,"Question","*","pid="&xPid&"","","sortid asc,id asc"
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
				<div class="btn_o"><div class="btn_i"><a href="Question.asp?do=edit&pid=<%=xpid%>">添加题目</a></div></div>
			</div>
			<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
				<tbody>
					<tr class="none">
						<th width="50"><input type="checkbox" class="checkall" rel="input:checkbox[name=id]" /> ID</th>
						<th width="60">类型</th>
						<th width="280">题目</th>
						<th width="50">排序ID</th>
						<th>&nbsp;</th>
					</tr>
					<%
					Do While Not rs.eof
					%>
					<tr>
						<td><input type="checkbox" name="id" value="<%=rs("id")%>" />
							<%=rs("id")%></td>
						<td><%=IIF(rs("qtype")=1,"多选","单选")%></td>
						<td><%=rs("Question")%></td>
						<td><%=rs("sortid")%></td>
						<td><a href="?do=edit&pid=<%=rs("pid")%>&id=<%=rs("id")%>" class="comm">编辑</a>&nbsp;&nbsp;<a href="?do=delete&id=<%=rs("id")%>"  onClick="javascript:return confirm('真的要删除吗?')"  class="comm">删除</a></td>
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
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;<a href="pager.asp?do=list">试卷管理</a>&nbsp;-&nbsp;<a href="question.asp?do=list&pid=<%=xPid%>"><%=oPager("Title")%></a>&nbsp;-&nbsp;
		<%=IIF(isset(oQuestion),"编辑","添加")%>&nbsp;<%If isset(oQuestion) Then echo oQuestion("question") Else echo "题目"%>
	</div>
	<div id="main">
		<form action="?do=save" method="post" name="myform">
			<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
				<tbody>
					<tr class="">
						<td class="label" width="100">题目</td>
						<td><input type="text" name="question" class="text" id="question" value="<%If xId<>0 Then echo oQuestion("question")%>" size="40" /></td>
					</tr>
					<tr class="">
						<td class="label" width="100">类型</td>
						<td>
						<select class="select" name="qtype">
							<option value="0">单选题</option>
							<option value="1" <%If xId <> 0 Then echo IIF(oQuestion("qtype")=1,"selected","")%>>多选题</option>
						</select>
						</td>
					</tr>
					<tr class="">
						<td class="label">排序</td>
						<td><input type="text" name="sortid" class="text" id="sortid" value="<%If xId<>0 Then echo oQuestion("sortid") Else echo "0"%>" size="2" /> 从小到大排序</td>
					</tr>
					<tr>
						<td colspan="2" style="height:1px; border-top:1px solid #ccc;"></td>
					</tr>
					<tr>
						<td class="label">选项：</td>
						<td>
							<ul class="lite lite_option">
								<%
								Dim m
								m = 6
								If xId <> 0 Then
									Casp.db.Exec rs1,"select * from Options where qid="&xId&" order by sortid asc,id asc"
									Do While Not rs1.eof
								%>
								<li>
									
									<input type="hidden" value="<%=rs1("id")%>" name="q_id">
									<input type="text" class="text" name="q_option" size="30" value="<%=rs1("option")%>" /> 
									排序:<input type="text" class="text" name="q_sortid" value="<%=rs1("sortid")%>" size="4" > 
									<select class="select q_result" name="q_result"><option value="0" class="gray">非正确选项</option><option value="1" class="red" <%=IIF(rs1("isresult"),"selected","")%>>正确选项</option></select>
								</li>
								<%
										m = m - 1
										rs1.MoveNext
									Loop
									rs1.close
									Set rs1 = Nothing
								End If
								For i = 1 To m
								%>
								<li>
									<input type="hidden" value="0" name="q_id">
									<input type="text" class="text" name="q_option" size="30" /> 
									排序:<input type="text" class="text" name="q_sortid" value="0" size="4" > 
									<select class="select q_result" name="q_result"><option value="0" class="gray">非正确选项</option><option value="1" class="red">正确选项</option></select>
								</li>
								<%
								Next
								%>
							</ul>
						</td>
					</tr>
					<tr class="none">
						<td class="label"></td>
						<td><input type="submit" class="button" value="保存" name="submit" id="submit"></td>
					</tr>
				</tbody>
			</table>
			<input type="hidden" value="<%=xId%>" name="id" id="id">
			<input type="hidden" value="<%=xPid%>" name="pid" id="pid">
			<input type="hidden" value="save" name="do">
			<input type="hidden" value="yes" name="save" id="save">
		</form>
	</div>
</div>
<script>
$("select[name=q_result]").change(function(){
	if($("option:selected",this).hasClass("red")){
		$(this).addClass("red");
	}else{
		$(this).removeClass("red");
	}
}).change();
</script>
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
