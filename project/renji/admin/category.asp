<!--#include file="page.master.asp"-->
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
	Casp.db.GetRowObject oCategory,"select Top 1 * from Category where id="&xId&""
	If isset(oCategory) = False And xId <> 0 Then ShowError(Array("没有该类别！"))
	TopCode()
	ProcessEdit()
Case "save"
	xClassname_cn = Casp.rq(3,"classname_cn",1,"")
	xClassname_en = Casp.rq(3,"classname_en",1,"")
	xUrl_en = Casp.rq(3,"Url_en",1,"")
	xUrl_cn = Casp.rq(3,"Url_cn",1,"")
	If xClassname_cn = "" Or xClassname_en = "" Then alertBack "必须填写类别名称"
	xSortId = Casp.rq(3,"sortid",0,0)
	If xId = 0 Then
		Casp.db.setRs rs,"select Top 1 * from Category",3
		rs.addnew
	Else
		Casp.db.setRs rs,"select Top 1 * from Category where Id="&xId&"",3
		If rs.eof Then ShowError(Array("参数错误，请返回重试！"))
	End If
	rs("classname_cn") = xClassname_cn
	rs("classname_en") = xClassname_en
	rs("SortID") = xSortId
	rs("url_en") = xUrl_en
	rs("url_cn") = xUrl_cn
	rs.update
	xId = rs("id")
	Casp.db.CloseRs rs
	alertRedirect "更新成功！",Casp.refererUrl
End Select

Sub ProcessList()
	Casp.db.Exec rs,"select * from Category order by sortid asc,id asc"
%>
<div id="inner">
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;类别列表</div>
	<div id="main">
		<form action="?do=delete" method="post" name="myform">
			<div class="active">
				<div class="btn_o"><div class="btn_i"><a href="category.asp?do=edit">添加类别</a></div></div>
			</div>
			<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
				<tbody>
					<tr class="none">
						<th width="50"><input type="checkbox" class="checkall" rel="input:checkbox[name=id]" /> ID</th>
						<th width="150">名称（中文）</th>
						<th width="150">Name（English）</th>
						<th width="60">排序ID</th>
						<th>&nbsp;</th>
					</tr>
					<%Do While Not rs.eof%>
					<tr>
						<td><input type="checkbox" name="id" value="<%=rs("id")%>" />
							<%=rs("id")%></td>
						<td><a href="?do=edit&id=<%=rs("id")%>" class="title" title="<%=rs("ClassName_cn")%>"><%=rs("ClassName_cn")%></a></td>
						<td><a href="?do=edit&id=<%=rs("id")%>" class="title" title="<%=rs("ClassName_en")%>"><%=rs("ClassName_en")%></a></td>
						<td><%=rs("SortID")%></td>
						<td><a href="?do=edit&id=<%=rs("id")%>" class="comm">编辑</a>&nbsp;&nbsp;<a href="?do=delete&id=<%=rs("id")%>"  onClick="javascript:return confirm('真的要删除吗?')"  class="comm">删除</a></td>
					</tr>
					<%
						rs.MoveNext
					Loop
					%>
					<tr>
						<td colspan="6">
						<div class="btn_o"><div class="btn_i"><a href="javascript:if(confirm('真的要删除吗?'))document.forms[0].submit();">删除所选</a></div></div>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
</div>
<%
	Casp.db.closeRs rs
End Sub

Sub ProcessEdit()
%>
<div id="inner">
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;<a href="category.asp">作品类别</a>&nbsp;-&nbsp;
		<%=IIF(isset(oCategory),"编辑","添加")%>&nbsp;<%If isset(oCategory) Then echo oCategory("ClassName_cn")&"("&oCategory("ClassName_en")&")" Else echo "类别"%>
	</div>
	<div id="main">
		<form action="?do=save" method="post" name="myform">
			<dl class="tabs">
				<dt><a href="javascript:;" class="curr">中文</a><a href="javascript:;">English</a></dt>
				<dd class="none">
				<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
					<tbody>
						<tr>
							<td class="label" width="100">排序(OrderID)</td>
							<td><input type="text" name="sortid" class="text" id="sortid" value="<%If xId<>0 Then echo oCategory("sortid")%>" /></td>
						</tr>
					</tbody>
				</table>
				</dd>
				<dd>
					<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
						<tbody>
							<tr class="">
								<td class="label" width="100">名称</td>
								<td><input type="text" name="classname_cn" class="text" id="classname_cn" value="<%If xId<>0 Then echo oCategory("classname_cn")%>" /></td>
							</tr>
							<tr class="">
								<td class="label" width="100">跳转地址</td>
								<td><input type="text" name="url_cn" class="text" id="url_cn" value="<%If xId<>0 Then echo oCategory("url_cn")%>" /></td>
							</tr>
							<tr class="none">
								<td class="label"></td>
								<td><input type="submit" class="button" value="保存" name="submit" id="submit"></td>
							</tr>
						</tbody>
					</table>
				</dd>
				<dd style=" display:none;">
					<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
						<tbody>
							<tr class="">
								<td class="label" width="100">Name</td>
								<td><input type="text" name="classname_en" class="text" id="classname_en" value="<%If xId<>0 Then echo oCategory("classname_en")%>" /></td>
							</tr>
							<tr class="">
								<td class="label" width="100">Redirect Url</td>
								<td><input type="text" name="url_en" class="text" id="url_en" value="<%If xId<>0 Then echo oCategory("url_en")%>" /></td>
							</tr>
							<tr class="none">
								<td class="label"></td>
								<td><input type="submit" class="button" value="Save" name="submit" id="submit"></td>
							</tr>
						</tbody>
					</table>
				</dd>
			</dl>
			<input type="hidden" value="<%=xId%>" name="id" id="id">
			<input type="hidden" value="save" name="do">
			<input type="hidden" value="yes" name="save" id="save">
		</form>
	</div>
</div>
<%
End Sub

Sub ProcessDelete()
	Call Casp.db.Conn.Execute("delete from Category where id in ("&Join(aId,",")&")",flag)
	If flag > 0 Then
		locationHref Casp.RefererUrl
	Else
		alertBack "删除失败！"
	End If
End Sub
%>
