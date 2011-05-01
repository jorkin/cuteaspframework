<!--#include file="page.master.asp"-->
<%
xId = Casp.rq(1,"id",0,0)
Casp.db.GetRowObject oPager,"select top 1 * from Pager where [language]='"&Mid(Lang,2,Len(Lang))&"' and id="&xId&""
If isset(oPager) = False Then die "没有找到该信息"
PageTitle = oPager("Title")
PageDescription = ""
PageBody = "page_body"
Call TopCode()
%>
		<div class="content">
			<div class="main">
				<div class="site_nav_bar">
					您现在的位置：<a href="/">首页</a> > <a href="list.asp?cid=13"><%=getClassName(13,Lang)%></a> > <a href="/show.asp?id=304">习题自测</a> > <%=oPager("Title")%>
				</div>
				<div class="article_body">
					<h1 class="article_title"><%=oPager("title")%></h1>
					<div class="article_content">
						
					</div>
				</div>
			</div>
			<div class="sidebar">
				<div class="category_box">
					<div class="category_header">
						<h3 class="title"><%=getClassName(13,Lang)%></h3>
						<em><%=getClassName(13,"_en")%></em>
					</div>
					<div class="category_body">
						<ul class="lite category_lite">
							<%
							Casp.db.Exec rs,"select * from [news] where CategoryId = 13 and [language]='"&Mid(Lang,2,Len(Lang))&"' order by sortid desc,id asc"
							If Not rs.eof Then
								Do While Not rs.eof
								%>
								<li <%=IIF(rs("id")=304,"class=""curr""","")%>><a href="show.asp?id=<%=rs("id")%>" class="title">• <%=rs("Title")%></a></li>
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
