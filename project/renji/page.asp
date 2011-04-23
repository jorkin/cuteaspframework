<!--#include file="page.master.asp"-->
<%
xId = Casp.rq(1,"id",0,0)
Casp.db.GetRowObject oPage,"select top 1 * from Page where id="&xId&""
If isset(oPage) = False Then die "没有找到该信息"
PageTitle = oPage("Title")
PageDescription = ""
PageBody = "page_body"
Call TopCode()
%>
		<div class="content">
			<div class="main">
				<div class="site_nav_bar">
					您现在的位置：<a href="/">首页</a> > <a href="list.asp?cid=<%=oPage("CategoryId")%>"><%=getClassName(oPage("CategoryId"),Lang)%></a> > <%=oPage("Title")%>
				</div>
				<div class="article_body">
					<h1 class="article_title"><%=oPage("title")%></h1>
					<div class="article_content">
						<%=oPage("Content")%>
					</div>
				</div>
			</div>
			<div class="sidebar">
				<div class="category_box">
					<div class="category_header">
						<h3 class="title"><%=getClassName(oPage("CategoryId"),Lang)%></h3>
						<em><%=getClassName(oPage("CategoryId"),"_en")%></em>
					</div>
					<div class="category_body">
						<ul class="lite category_lite">
							<%
							Casp.db.Exec rs,"select * from [News] where CategoryId = "&oPage("CategoryId")&" and [language]='"&Mid(Lang,2,Len(Lang))&"' order by sortid desc,id asc"
							If Not rs.eof Then
								Do While Not rs.eof
								%>
								<li <%=IIF(rs("id")=xId,"class=""curr""","")%>><a href="show.asp?id=<%=rs("id")%>" class="title">• <%=rs("Title")%></a></li>
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
