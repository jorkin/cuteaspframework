<!--#include file="page.master.asp"-->
<!--#include file="include/library/page.asp"-->
<%
xCategoryId = Casp.rq(1,"cid",0,0)

Casp.db.getRowObject oCate,"select * from [Category] where Id = "&xCategoryId&""
If isset(oCate) Then
	If Len(oCate("url"&Lang))>0 Then
		Response.Redirect oCate("Url"&Lang)
		Response.End
	End If
End If

PageTitle = ""
PageBody = "page_body"
Call TopCode()
%>


		<div class="content">
			<div class="main">
				<div class="site_nav_bar">
					您现在的位置：<a href="/">首页</a> > <%=getClassName(xCategoryId,Lang)%>
				</div>
				<div class="article_list_wrap">
					<ul class="lite article_lite">
						<%
						Casp.page.Conn = Casp.db.conn
						Casp.page.PageID = Trim(Request("PageID"))
						Casp.page.Size = 10
						Casp.page.Header_a rs,"[news]","*","CategoryId = "&xCategoryId&" and [language]='"&Mid(Lang,2,Len(Lang))&"'","","sortid desc,id desc"
						If Not rs.eof Then
							Do While Not rs.eof
							%>
								<li><a href="show.asp?id=<%=rs("id")%>" class="title"><%=rs("Title")%></a><em class="date"><%=DateValue(rs("addtime"))%></em></li>
							<%
								rs.MoveNext
							Loop
						End If
						
						%>
					</ul>
					<div class="pager"><%Casp.page.Footer_b "",""%></div>
				</div>
			</div>
			<div class="sidebar">
				<div class="category_box">
					<div class="category_header">
						<h3 class="title"><%=getClassName(xCategoryId,Lang)%></h3>
						<em><%=getClassName(xCategoryId,"_en")%></em>
					</div>
					<div class="category_body">
						<ul class="lite category_lite">
							<%
							Casp.db.Exec rs,"select * from [news] where CategoryId = "&xCategoryId&" and [language]='"&Mid(Lang,2,Len(Lang))&"' order by sortid desc,id asc"
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
