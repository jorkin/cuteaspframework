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
	Casp.db.GetRowObject oWorks,"select Top 1 * from Works where id="&xId&""
	If isset(oWorks) = False And xId <> 0 Then ShowError(Array("没有该作品！"))
	TopCode()
	ProcessEdit()
Case "save"
	Casp.Upload.AutoSave = 2
	Casp.Upload.SavePath = Casp.WebConfig("SitePath")&Casp.WebConfig("WorksPath") & "/"
	Casp.file.CreatePath(Casp.WebConfig("SitePath")&Casp.WebConfig("WorksPath"))
	xId = Casp.rq(3,"id",0,0)
	xCategoryID = Casp.rq(3,"CategoryID",0,0)
	xArtistID = Casp.rq(3,"ArtistID",0,0)
	xTitle_cn = Casp.rq(3,"Title_cn",1,"")
	xTitle_en = Casp.rq(3,"Title_en",1,"")
	xSortId = Casp.rq(3,"sortid",0,0)
	xContent_cn = Casp.rq(3,"Content_cn",1,"")
	xContent_en = Casp.rq(3,"Content_en",1,"")
	If xCategoryID = 0 Then alertBack "请选择类别"
	If xArtistID = 0 Then alertBack "请选择纹身师"
	If xId = 0 Then
		Casp.db.setRs rs,"select Top 1 * from Works",3
		rs.addnew
	Else
		Casp.db.setRs rs,"select Top 1 * from Works where Id="&xId&"",3
		If rs.eof Then ShowError(Array("参数错误，请返回重试！"))
	End If
	rs("CategoryID") = xCategoryID
	rs("ArtistID") = xArtistID
	rs("Title_cn") = xTitle_cn
	rs("Title_en") = xTitle_en
	rs("Content_cn") = xContent_cn
	rs("Content_en") = xContent_en
	rs("SortID") = xSortId
	rs.update
	newId = rs("id")
	Casp.db.CloseRs rs
	If Casp.Upload.UpCount > 0 Then
		On Error Resume Next
		echo "<span style=""display:none"">"&Casp.Upload.FileItem("smallimage").Name&"</span>"
		If Err.Number = 0 Then
			If Not Casp.Upload.Save("smallimage",newId&"_small.jpg") Or Not MakeWorksImage(newId) Then
				alertRedirect "缩略图上传失败，请重试","works.asp?do=edit&id="&newId
			End If			
		End If
		Err.clear
		On Error Resume Next
		echo "<span style=""display:none"">"&Casp.Upload.FileItem("image").Name&"</span>"
		If Err.Number = 0 Then
			If Not Casp.Upload.Save("image",newId&".jpg") Then
				alertRedirect "作品图上传失败，请重试","works.asp?do=edit&id="&newId
			End If			
		End If
	End If
	alertRedirect "更新成功！",IIF(xId=0,"works.asp?do=list",Casp.refererUrl)
End Select

Sub ProcessList()
	Casp.page.Conn = Casp.db.conn
	Casp.page.PageID = Trim(Request("PageID"))
	Casp.page.Size = 10
	Casp.page.Header_a rs,"Works a inner join Category b on b.id=a.CategoryID","a.*,b.ClassName_cn,b.ClassName_en","","","a.sortid desc,a.id desc"
%>
<div id="inner">
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;作品列表</div>
	<div id="main">
		<form action="?do=delete" method="post" name="myform">
			<div class="active">
				<div class="btn_o"><div class="btn_i"><a href="works.asp?do=edit">添加作品</a></div></div>
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
						<td><%=rs("ClassName_cn")%>(<%=rs("ClassName_en")%>)</td>
						<td><%=rs("Title_cn")%>(<%=rs("Title_en")%>)</td>
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
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;<a href="works.asp">作品管理</a>&nbsp;-&nbsp;
		<%=IIF(isset(oWorks),"编辑","添加")%>&nbsp;<%If isset(oWorks) Then echo oWorks("Title_cn")&"("&oWorks("Title_en")&")" Else echo "作品"%>
	</div>
	<div id="main">
		<form action="?do=save" method="post" name="myform" enctype="multipart/form-data">
			<dl class="tabs">
				<dt><a href="javascript:;" class="curr">中文</a><a href="javascript:;">English</a></dt>
				<dd class="none">
				<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
					<tbody>
						<tr>
							<td class="label" width="100">排序(OrderID)</td>
							<td><input type="text" name="sortid" class="text" id="sortid" value="<%If xId<>0 Then echo oWorks("sortid")%>" /></td>
						</tr>
						<tr>
							<td class="label">类别(Category)</td>
							<td>
								<select name="categoryid">
									<option value="">请选择类别..</option>
									<%
									Casp.db.Exec rs,"select * from Category order by sortid desc,id desc"
									Do While Not rs.eof
										If xId = 0 Then
											echo "<option value="""&rs("id")&""">"&rs("ClassName_cn")&"("&rs("ClassName_en")&")</option>"
										Else
											echo "<option value="""&rs("id")&""" "&IIF(rs("id")=oWorks("CategoryID"),"selected","")&">"&rs("ClassName_cn")&"("&rs("ClassName_en")&")</option>"
										End If
										rs.MoveNext
									Loop
									Casp.db.closeRs rs
									%>
								</select>
							</td>
						</tr>
						<tr>
							<td class="label">纹身师(Artist)</td>
							<td>
								<select name="artistid">
									<option value="">请选择纹身师..</option>
									<%
									Casp.db.Exec rs,"select * from Artist order by sortid desc,id desc"
									Do While Not rs.eof
										If xId = 0 Then
											echo "<option value="""&rs("id")&""">"&rs("NickName_cn")&"("&rs("NickName_en")&")</option>"
										Else
											echo "<option value="""&rs("id")&""" "&IIF(rs("id")=oWorks("ArtistID"),"selected","")&">"&rs("NickName_cn")&"("&rs("NickName_en")&")</option>"
										End If
										rs.MoveNext
									Loop
									Casp.db.closeRs rs
									%>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
				</dd>
				<dd>
					<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
						<tbody>
							<tr class="">
								<td class="label" width="100">作品名称</td>
								<td><input type="text" name="title_cn" size="40" class="text" id="title_cn" value="<%If xId<>0 Then echo oWorks("title_cn")%>" /></td>
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
								<td class="label" width="100">Works Title</td>
								<td><input type="text" name="title_en" size="40" class="text" id="title_en" value="<%If xId<>0 Then echo oWorks("title_en")%>" /></td>
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
	Call Casp.db.Conn.Execute("delete from Works where id in ("&Join(aId,",")&")",flag)
	If flag > 0 Then
		locationHref Casp.RefererUrl
	Else
		alertBack "删除失败！"
	End If
End Sub
%>
