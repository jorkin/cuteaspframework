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
	Casp.db.GetRowObject oNews,"select Top 1 * from News where id="&xId&""
	If isset(oNews) = False And xId <> 0 Then ShowError(Array("没有该信息！"))
	TopCode()
	ProcessEdit()
Case "delimage"
	Casp.File.DelFile Casp.WebConfig("SitePath")&Casp.WebConfig("NewsPath") & "/" & xId & ".jpg"
	Casp.File.DelFile Casp.WebConfig("SitePath")&Casp.WebConfig("NewsPath") & "/" & xId & "_small.jpg"
	Casp.db.conn.Execute("update News set IsImage=false where id="&xId&"")
	locationHref Casp.RefererUrl
Case "save"
	Casp.Upload.AutoSave = 2
	Casp.Upload.SavePath = Casp.WebConfig("SitePath")&Casp.WebConfig("NewsPath") & "/"
	Casp.file.CreatePath(Casp.WebConfig("SitePath")&Casp.WebConfig("NewsPath"))
	xId = Casp.rq(3,"id",0,0)
	xIsDisplay = Casp.rq(3,"IsDisplay",0,0)
	xCategoryId = Casp.rq(3,"CategoryId",0,0)
	xTitle = Casp.rq(3,"Title",1,"")
	If xTitle = "" Then alertBack "必须填写信息标题"
	If xCategoryId = 0 Then alertBack "必须选择类别"
	xSortId = Casp.rq(3,"sortid",0,0)
	xContent = Casp.Form("Content")
	xLanguage = Casp.rq(3,"Language",1,"")
	If xId = 0 Then
		Casp.db.setRs rs,"select Top 1 * from News",3
		rs.addnew
	Else
		Casp.db.setRs rs,"select Top 1 * from News where Id="&xId&"",3
		If rs.eof Then ShowError(Array("参数错误，请返回重试！"))
	End If
	rs("IsDisplay") = xIsDisplay
	rs("Title") = xTitle
	rs("CategoryId") = xCategoryId
	rs("Content") = xContent
	rs("SortID") = xSortId
	rs("Language") = xLanguage
	rs("addtime") = Now()
	rs.update
	newId = rs("id")
	If Casp.Upload.UpCount > 0 Then
		If Not Casp.Upload.Save("image",newId&".jpg") Then
			If xId = 0 Then Casp.db.conn.Execute("delete from News where id="&newId&"")
			alertBack "上传失败"
		End If
		rs("IsImage") = true
		rs.update
	End If
	Casp.db.CloseRs rs
	alertRedirect "更新成功！",IIF(xId=0,"news.asp?do=list&lang="&Request.QueryString("lang"),Casp.refererUrl)
End Select

Sub ProcessList()
	Casp.page.Conn = Casp.db.conn
	Casp.page.PageID = Trim(Request("PageID"))
	Casp.page.Size = 25
	xCategoryId = Casp.rq(1,"cid",0,0)
	If xCategoryId <> 0 Then
		sWhere = " and CategoryId = " & xCategoryId
	End If
	If request.querystring("lang")="en" Then
		Casp.page.Header_a rs,"News a inner join Category b on b.id=a.CategoryID","a.*,b.ClassName_cn,b.ClassName_en","a.[language]='en' "&sWhere&"","","a.sortid desc,a.id desc"
	Else
		Casp.page.Header_a rs,"News a inner join Category b on b.id=a.CategoryID","a.*,b.ClassName_cn,b.ClassName_en","a.[language]='cn' "&sWhere&"","","a.sortid desc,a.id desc"
	End If
%>
<div id="inner">
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;信息列表</div>
	<div id="main">
      <dl class="tabs">
        <dt>
        <a href="news.asp?do=list" <%=IIF(Request("lang")<>"en","class=""curr""","")%>>中文</a>
        <a href="news.asp?do=list&lang=en" <%=IIF(Request("lang")="en","class=""curr""","")%>>English</a>
        </dt>
        <dd>
		<form action="?do=delete" method="post" name="myform">
			<div class="active">
			</div>
			<div class="active">
				<%If request.querystring("lang")="en" Then%>
				<div class="btn_o"><div class="btn_i"><a href="news.asp?do=edit&lang=en">Add News</a></div></div>
				<%Else%>
				<div class="btn_o"><div class="btn_i"><a href="news.asp?do=edit&lang=cn">添加信息</a></div></div>
				<%End If%>
			</div>
			<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
				<tbody>
					<tr class="none">
						<th width="50"><input type="checkbox" class="checkall" rel="input:checkbox[name=id]" /> ID</th>
						<th width="180">类别</th>
						<th width="200">标题</th>
						<th width="80">是否首页显示</th>
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
						<td><a href="../show.asp?id=<%=rs("id")%>" target="_blank"><%=rs("Title")%></a></td>
						<td><%=IIF(rs("IsDisplay"),"√","×")%></td>
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
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;<a href="news.asp">信息管理</a>&nbsp;-&nbsp;
		<%=IIF(isset(oNews),"编辑","添加")%>&nbsp;<%If isset(oNews) Then echo oNews("Title") Else echo "信息"%>
	</div>
	<div id="main">
		<form action="?do=save" method="post" name="myform" enctype="multipart/form-data">
			<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
				<tbody>
					<tr class="">
						<td class="label" width="100">语言</td>
						<td><label><input type="radio" name="language" class="radio" value="cn" checked />中文</label> <label><input type="radio" name="language" class="radio" value="en" <%If xId<>0 Then echo IIF(oNews("language")="en","checked","") Else echo IIF(Request("lang")="en","checked","")%> />Enlgish</label></td>
					</tr>
					<tr>
						<td class="label">类别(Category)</td>
						<td>
							<select name="categoryid">
								<option value="">请选择类别..</option>
								<%
								Casp.db.Exec rs,"select * from Category order by sortid asc,id asc"
								Do While Not rs.eof
									If xId = 0 Then
										echo "<option value="""&rs("id")&""">"&rs("ClassName_cn")&"("&rs("ClassName_en")&")</option>"
									Else
										echo "<option value="""&rs("id")&""" "&IIF(rs("id")=oNews("CategoryID"),"selected","")&">"&rs("ClassName_cn")&"("&rs("ClassName_en")&")</option>"
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
						<td><input type="text" name="title" class="text" id="title" value="<%If xId<>0 Then echo oNews("title")%>" size="40" /></td>
					</tr>
					<tr>
						<td class="label">排序(OrderID)</td>
						<td><input type="text" name="sortid" class="text" id="sortid" value="<%If xId<>0 Then echo oNews("sortid")%>" /></td>
					</tr>
					<tr>
						<td class="label">首页显示?</td>
						<td><input type="checkbox" name="isdisplay" class="checkbox" id="isdisplay" value="1" 
						<%If xId<>0 Then 
							If oNews("IsDisplay") Then
								echo "checked"
							End If
						End If
						%> /></td>
					</tr>
					<tr class="">
						<td class="label">简介</td>
						<td><textarea class="fckeditor" style="width:550px;height:300px;" name="content" id="content"><%If xId<>0 Then echo oNews("Content")%></textarea></td>
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
	Call Casp.db.Conn.Execute("delete from News where id in ("&Join(aId,",")&")",flag)
	If flag > 0 Then
		locationHref Casp.RefererUrl
	Else
		alertBack "删除失败！"
	End If
End Sub
%>
