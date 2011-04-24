<!--#include file="page.master.asp"-->
<!--#include file="include/library/page.asp"-->
<%

If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
	
	xUsername = Casp.rq(3,"username",1,"")
	xContent = Casp.rq(3,"content",1,"")
	
	If xUsername = "" Then alertBack "请填写您的姓名。"

	'If xContent = "" Then alertBack "不详细描述下你想要的纹身吗？"

	Casp.db.setRs rs,"select top 1 * from Guestbook",3
	rs.addnew
	rs("username") = xUserName
	rs("addtime") = now
	rs("content") = xContent
	rs.update
	newId = rs("id")
	Casp.db.closeRs rs
	alertRedirect "提问成功，我们会尽快答复您的问题，请密切回访关注!",Casp.refererUrl
End If

PageTitle = "答疑台"
PageDescription = ""
PageBody = "page_body"
Call TopCode()
%>
	<div class="content">
		<div class="main">
			<div class="site_nav_bar">
				您现在的位置：<a href="/">首页</a> > 答疑台
			</div>
			<div class="article_body">
				<ul class="list gb_list">
					<%
					Casp.page.Conn = Casp.db.conn
					Casp.page.PageID = Trim(Request("PageID"))
					Casp.page.Size = 10
					Casp.page.Header_a rs,"[Guestbook]","*","","","id desc"
					If Not rs.eof Then
						Do While Not rs.eof
						%>
							<li class="item">
								<div class="list_info">
									<em class="date"><%=rs("addtime")%></em>
									<p><label>提 问 人：</label><%=rs("UserName")%></p>
									<p><label>问题内容：</label><br /><%=Casp.String.TextToHtml(rs("Content"))%></p>
									<%If rs("ReplyContent")<>"" Then%>
									<p class="reply_content"><span class="layer_arrow l_arrow_up"><i></i></span><label>老师答复：</label><%=rs("ReplyContent")%></p>
									<%End If%>
								</div>
							</li>
						<%
							rs.MoveNext
						Loop
					End If
					
					%>
				</ul>
				<div class="pager"><%Casp.page.Footer_b "",""%></div>
				<form method="post" class="gb_form">
				<table class="edit">
				<tr>
					<td class="label">姓名；</td>
					<td><input type="text" class="text" size="30" name="UserName" /></td>
				</tr>
				<tr>
					<td class="label">问题；</td>
					<td><textarea class="textarea" cols="40" rows="5" name="Content"></textarea></td>
				</tr>
				<tr>
					<td class="label"></td>
					<td><input type="submit" class="button" value="提交" /></td>
				</tr>
				</table>
				</form>
			</div>
		</div>
		<div class="sidebar">
			<div class="category_box">
				<div class="category_header">
					<h3 class="title">答疑台</h3>
					<em>Question and Answer</em>
				</div>
				<div class="category_body">
					<ul class="lite category_lite">
						<%
						Casp.db.Exec rs,"select * from [news] where CategoryId = 10 and [language]='"&Mid(Lang,2,Len(Lang))&"' order by sortid desc,id asc"
						If Not rs.eof Then
							Do While Not rs.eof
							%>
							<li><a href="show.asp?id=<%=rs("id")%>" class="title">• <%=rs("Title")%></a></li>
							<%
								rs.MoveNext
							Loop
						End If
						
						%>
					</ul>
				</div>
			</div>
		</div>
	</div>
