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
	Casp.db.GetRowObject oTeacher,"select Top 1 * from Teacher where id="&xId&""
	If isset(oTeacher) = False And xId <> 0 Then ShowError(Array("没有该教师！"))
	TopCode()
	ProcessEdit()
Case "delimage"
	Casp.File.DelFile Casp.WebConfig("SitePath")&Casp.WebConfig("UserFacePath") & "/" & xId & ".jpg"
	locationHref Casp.RefererUrl
Case "save"
	Casp.Upload.AutoSave = 2
	Casp.Upload.SavePath = Casp.WebConfig("SitePath")&Casp.WebConfig("UserFacePath") & "/"
	Casp.file.CreatePath(Casp.WebConfig("SitePath")&Casp.WebConfig("UserFacePath"))
	xId = Casp.rq(3,"id",1,0)
	xNickname_cn = Casp.rq(3,"nickname_cn",1,"")
	xNickname_en = Casp.rq(3,"nickname_en",1,"")
	If xNickname_cn = "" Or xNickname_en = "" Then alertBack "必须填写教师姓名"
	xSortId = Casp.rq(3,"sortid",0,0)
	xUserFace = Casp.rq(3,"userface",1,"")
	If xId = 0 Then
		Casp.db.setRs rs,"select Top 1 * from Teacher",3
		rs.addnew
	Else
		Casp.db.setRs rs,"select Top 1 * from Teacher where Id="&xId&"",3
		If rs.eof Then ShowError(Array("参数错误，请返回重试！"))
	End If
	rs("nickname_cn") = xNickname_cn
	rs("nickname_en") = xNickname_en
	rs("Url_cn") = xUrl_cn
	rs("Url_en") = xUrl_en
	rs("SortID") = xSortId
	rs.update
	newId = rs("id")
	Casp.db.CloseRs rs
	If Casp.Upload.UpCount > 0 Then
		If Not Casp.Upload.Save("userface",newId&".jpg") Then
			alertBack "上传失败"
		End If
	End if
	alertRedirect "更新成功！",Casp.refererUrl
End Select

Sub ProcessList()
	Casp.db.Exec rs,"select * from Teacher order by sortid asc,id desc"
%>
<div id="inner">
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;教师列表</div>
	<div id="main">
		<form action="?do=delete" method="post" name="myform">
			<div class="active">
				<div class="btn_o"><div class="btn_i"><a href="Teacher.asp?do=edit">添加教师</a></div></div>
			</div>
			<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
				<tbody>
					<tr class="none">
						<th width="50"><input type="checkbox" class="checkall" rel="input:checkbox[name=id]" /> ID</th>
						<th width="60">头像</th>
						<th width="200">头衔/姓名</th>
						<th width="60">排序ID</th>
						<th>&nbsp;</th>
					</tr>
					<%Do While Not rs.eof%>
					<tr>
						<td><input type="checkbox" name="id" value="<%=rs("id")%>" />
							<%=rs("id")%></td>
						<td><a href="?do=edit&id=<%=rs("id")%>" class="title" title="<%=rs("NickName_cn")%>(<%=rs("NickName_en")%>)"><img src="<%=getTeacherImage(rs("id"))%>" width="48" /></a></td>
						<td><a href="?do=edit&id=<%=rs("id")%>" class="title" title="<%=rs("NickName_cn")%>(<%=rs("NickName_en")%>)"><%=rs("NickName_cn")%>(<%=rs("NickName_en")%>)</a></td>
						<td><%=rs("sortId")%></td>
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
	<div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;<a href="Teacher.asp">教师</a>&nbsp;-&nbsp;
		<%=IIF(isset(oTeacher),"编辑","添加")%>&nbsp;<%If isset(oTeacher) Then echo oTeacher("NickName_cn")&"("&oTeacher("NickName_en")&")" Else echo "教师"%>
	</div>
	<div id="main">
		<form action="?do=save" method="post" name="myform" enctype="multipart/form-data">
			<dl class="tabs">
				<dt><a href="javascript:;" class="curr">中文</a><a href="javascript:;">English</a></dt>
				<dd class="none">
				<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
					<tbody>
						<tr>
							<td class="label" width="100">头像(UserFace)</td>
							<td><%If xId <> 0 Then%><img src="<%=getTeacherImage(oTeacher("id"))%>" style="display:block;width:130px;height:160px;" /><%End If%><input type="file" id="userface" name="userface" class="text" />
							<a href="javascript:if(confirm('真的要删除吗?'))location.href='?do=delimage&id=<%=xId%>';">删除缩略图</a></td>
						</tr>
						<tr>
							<td class="label">排序(OrderID)</td>
							<td><input type="text" name="sortid" class="text" id="sortid" value="<%If xId<>0 Then echo oTeacher("sortid")%>" /> 从小到大</td>
						</tr>
					</tbody>
				</table>

				</dd>

				<dd>
					<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
						<tbody>
							<tr class="">
								<td class="label" width="100">头衔/姓名</td>
								<td><input type="text" name="nickname_cn" class="text" id="nickname_cn" value="<%If xId<>0 Then echo oTeacher("nickname_cn")%>" /></td>
							</tr>
							<tr class="">
								<td class="label">链接</td>
								<td><input type="text" name="Url_cn" class="text" id="Url_cn" value="<%If xId<>0 Then echo oTeacher("Url_cn")%>" /></td>
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
								<td class="label" width="100">Title/Name</td>
								<td><input type="text" name="nickname_en" class="text" id="nickname_en" value="<%If xId<>0 Then echo oTeacher("nickname_en")%>" /></td>
							</tr>
							<tr class="">
								<td class="label">Link</td>
								<td><input type="text" name="Url_en" class="text" id="Url_en" value="<%If xId<>0 Then echo oTeacher("Url_en")%>" /></td>
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
	Call Casp.db.Conn.Execute("delete from Teacher where id in ("&Join(aId,",")&")",flag)
	If flag > 0 Then
		locationHref Casp.RefererUrl
	Else
		alertBack "删除失败！"
	End If
End Sub
%>
