<!--#include file="page.master.asp"-->
<!--#include file="../include/library/upload.asp"-->
<!--#include file="../include/library/file.asp"-->
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
	Casp.db.GetRowObject oLinks,"select Top 1 * from Links where id="&xId&""
	If isset(oLinks) = False And xId <> 0 Then ShowError(Array("没有该友情链接！"))
	TopCode()
	ProcessEdit()
Case "save"
	Casp.Upload.AutoSave = 2
	Casp.Upload.SavePath = Casp.WebConfig("SitePath")&Casp.WebConfig("LinksPath") & "/"
	Casp.file.CreatePath(Casp.WebConfig("SitePath")&Casp.WebConfig("LinksPath"))
	xId = Casp.rq(3,"id",1,0)
	xTitle = Casp.rq(3,"Title",1,"")
	xLinkUrl = Casp.rq(3,"LinkUrl",1,"")
	xIsImage = Casp.rq(3,"IsImage",0,0)
	If xTitle = "" Then alertBack "必须填写友情链接名称"
	xSortId = Casp.rq(3,"sortid",0,0)
	If xId = 0 Then
		Casp.db.setRs rs,"select Top 1 * from Links",3
		rs.addnew
	Else
		Casp.db.setRs rs,"select Top 1 * from Links where Id="&xId&"",3
		If rs.eof Then ShowError(Array("参数错误，请返回重试！"))
	End If
	rs("Title") = xTitle
	rs("LinkUrl") = xLinkUrl
	rs("SortID") = xSortId
	rs("IsImage") = xIsImage
	rs.update
	newId = rs("id")
	Casp.db.CloseRs rs
	If Casp.Upload.UpCount > 0 Then
		If Not Casp.Upload.Save("image",newId&".jpg") Then
			alertBack "上传失败"
		End If
	End if
	alertRedirect "更新成功！",Casp.refererUrl
End Select

Sub ProcessList()
	Casp.db.Exec rs,"select * from Links order by sortid desc,id asc"
%>
<div id="inner">
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;友情链接列表</div>
	<div id="main">
		<form action="?do=delete" method="post" name="myform">
			<div class="active">
				<div class="btn_o"><div class="btn_i"><a href="Links.asp?do=edit">添加友情链接</a></div></div>
			</div>
			<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
				<tbody>
					<tr class="none">
						<th width="50"><input type="checkbox" class="checkall" rel="input:checkbox[name=id]" /> ID</th>
						<th width="150">名称</th>
						<th width="60">排序ID</th>
						<th>&nbsp;</th>
					</tr>
					<%Do While Not rs.eof%>
					<tr>
						<td><input type="checkbox" name="id" value="<%=rs("id")%>" />
							<%=rs("id")%></td>
						<td><a href="?do=edit&id=<%=rs("id")%>" class="title" title="<%=rs("Title")%>"><%=rs("Title")%></a></td>
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
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;<a href="Links.asp">作品友情链接</a>&nbsp;-&nbsp;
		<%=IIF(isset(oLinks),"编辑","添加")%>&nbsp;<%If isset(oLinks) Then echo oLinks("Title")&"("&oLinks("ClassName_en")&")" Else echo "友情链接"%>
	</div>
	<div id="main">
		<form action="?do=save" method="post" name="myform" enctype="multipart/form-data">
			<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
				<tbody>
					<tr class="">
						<td class="label" width="70">名称</td>
						<td><input type="text" name="Title" class="text" id="Title" value="<%If xId<>0 Then echo oLinks("Title")%>" /></td>
					</tr>
					<tr class="">
						<td class="label">网址</td>
						<td><input type="text" name="linkurl" class="text" id="linkurl" value="<%If xId<>0 Then echo oLinks("linkurl")%>" size="50" /></td>
					</tr>
					<tr class="">
						<td class="label">是否图片</td>
						<td><input type="radio" name="IsImage" class="text" value="1" autocomplete="off" <%If xId<>0 Then echo IIF(oLinks("IsImage")=True,"checked","")%> />是 <input type="radio" autocomplete="off" name="IsImage" class="text" value="0" <%If xId<>0 Then echo IIF(oLinks("IsImage")=False,"checked","")%> <%If xId = 0 Then echo "checked"%> />否</td>
					</tr>
					<tr>
						<td class="label">Logo</td>
						<td><%If xId <> 0 Then%><img src="<%=getLinksImage(oLinks("id"))%>" style="display:block;" /><%End If%><input type="file" id="image" name="image" class="text" /></td>
					</tr>
					<tr>
						<td class="label" width="70">排序(OrderID)</td>
						<td><input type="text" name="sortid" class="text" id="sortid" value="<%If xId<>0 Then echo oLinks("sortid")%>" /></td>
					</tr>
					<tr class="none">
						<td class="label"></td>
						<td><input type="submit" class="button" value="Save" name="submit" id="submit"></td>
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
	Call Casp.db.Conn.Execute("delete from Links where id in ("&Join(aId,",")&")",flag)
	If flag > 0 Then
		locationHref Casp.RefererUrl
	Else
		alertBack "删除失败！"
	End If
End Sub
%>
