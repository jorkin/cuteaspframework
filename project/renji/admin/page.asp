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
	Casp.db.GetRowObject oPage,"select Top 1 * from Page where id="&xId&""
	If isset(oPage) = False And xId <> 0 Then ShowError(Array("没有该额外单页！"))
	TopCode()
	ProcessEdit()
Case "save"
	xId = Casp.rq(3,"id",0,0)
	xCategoryId = Casp.rq(3,"CategoryId",0,0)
	xTitle = Casp.rq(3,"Title",1,"")
	If xTitle = "" Then alertBack "必须填写额外单页标题"
	If xCategoryId = 0 Then alertBack "必须选择类别"
	xContent = Request("Content")
	If xId = 0 Then
		Casp.db.setRs rs,"select Top 1 * from Page",3
		rs.addnew
	Else
		Casp.db.setRs rs,"select Top 1 * from Page where Id="&xId&"",3
		If rs.eof Then ShowError(Array("参数错误，请返回重试！"))
	End If
	rs("Title") = xTitle
	rs("CategoryId") = xCategoryId
	rs("Content") = xContent
	rs("addtime") = Now()
	rs.update
	newId = rs("id")
	Casp.db.CloseRs rs
	alertRedirect "更新成功！",IIF(xId=0,"Page.asp?do=list&lang="&Request.QueryString("lang"),Casp.refererUrl)
End Select

Sub ProcessList()
	Casp.page.Conn = Casp.db.conn
	Casp.page.PageID = Trim(Request("PageID"))
	Casp.page.Size = 25
	xCategoryId = Casp.rq(1,"cid",0,0)
	If xCategoryId <> 0 Then
		sWhere = " and CategoryId = " & xCategoryId
	End If
	Casp.page.Header_a rs,"Page a inner join Category b on b.id=a.CategoryID","a.*,b.ClassName_cn,b.ClassName_en","1=1 "&sWhere&"","","a.id desc"
%>
<div id="inner">
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;额外单页列表</div>
	<div id="main">
      <dl class="tabs">
        <dt>
        <a href="Page.asp?do=list" <%=IIF(Request("lang")<>"en","class=""curr""","")%>>中文</a>
        <a href="Page.asp?do=list&lang=en" <%=IIF(Request("lang")="en","class=""curr""","")%>>English</a>
        </dt>
        <dd>
		<form action="?do=delete" method="post" name="myform">
			<div class="active">
				<%
				Casp.db.Exec crs,"select * from Category order by sortid asc,id asc"
				Do While Not crs.eof
					If request.querystring("lang")="en" Then
						echo "<a href=""news.asp?do=list&cid="&crs("id")&""" title="""&crs("ClassName_cn")&""">"&crs("ClassName_en")&"</a>&nbsp;|&nbsp;"
					Else
						echo "<a href=""news.asp?do=list&cid="&crs("id")&""" title="""&crs("ClassName_en")&""">"&crs("ClassName_cn")&"</a>&nbsp;|&nbsp;"
					End If
					crs.MoveNext
				Loop
				crs.close
				%>
			</div>
			<div class="active">
				<%If request.querystring("lang")="en" Then%>
				<div class="btn_o"><div class="btn_i"><a href="Page.asp?do=edit&lang=en">Add Page</a></div></div>
				<%Else%>
				<div class="btn_o"><div class="btn_i"><a href="Page.asp?do=edit&lang=cn">添加额外单页</a></div></div>
				<%End If%>
			</div>
			<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
				<tbody>
					<tr class="none">
						<th width="50"><input type="checkbox" class="checkall" rel="input:checkbox[name=id]" /> ID</th>
						<th width="180">类别</th>
						<th width="200">标题</th>
						<th>&nbsp;</th>
					</tr>
					<%Do While Not rs.eof%>
					<tr>
						<td><input type="checkbox" name="id" value="<%=rs("id")%>" />
							<%=rs("id")%></td>
						<td>
						<%
						If request.querystring("lang")="en" Then
							echo rs("ClassName_en")
						Else
							echo rs("ClassName_cn")
						End If
						%></td>
						<td><a href="../page.asp?id=<%=rs("id")%>" target="_blank"><%=rs("Title")%></a></td>
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
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;<a href="Page.asp">额外单页管理</a>&nbsp;-&nbsp;
		<%=IIF(isset(oPage),"编辑","添加")%>&nbsp;<%If isset(oPage) Then echo oPage("Title") Else echo "额外单页"%>
	</div>
	<div id="main">
		<form action="?do=save" method="post" name="myform">
			<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
				<tbody>
					<tr>
						<td class="label" width="120">类别(Category)</td>
						<td>
							<select name="categoryid">
								<option value="">请选择类别..</option>
								<%
								Casp.db.Exec rs,"select * from Category order by sortid asc,id asc"
								Do While Not rs.eof
									If xId = 0 Then
										echo "<option value="""&rs("id")&""">"&rs("ClassName_cn")&"("&rs("ClassName_en")&")</option>"
									Else
										echo "<option value="""&rs("id")&""" "&IIF(rs("id")=oPage("CategoryID"),"selected","")&">"&rs("ClassName_cn")&"("&rs("ClassName_en")&")</option>"
									End If
									rs.MoveNext
								Loop
								Casp.db.closeRs rs
								%>
							</select>
						</td>
					</tr>
					<tr class="">
						<td class="label">标题</td>
						<td><input type="text" name="title" class="text" id="title" value="<%If xId<>0 Then echo oPage("title")%>" size="40" /></td>
					</tr>
					<tr class="">
						<td class="label">简介</td>
						<td><textarea class="fckeditor" style="width:550px;height:300px;" name="content" id="content"><%If xId<>0 Then echo oPage("Content")%></textarea></td>
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
	Call Casp.db.Conn.Execute("delete from Page where id in ("&Join(aId,",")&")",flag)
	If flag > 0 Then
		locationHref Casp.RefererUrl
	Else
		alertBack "删除失败！"
	End If
End Sub
%>
