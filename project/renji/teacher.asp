<!--#include file="page.master.asp"-->
<%
xId = Casp.rq(1,"id",0,0)
Casp.db.GetRowObject oTeacher,"select top 1 * from Teacher where id="&xId&""
If isset(oTeacher) = False Then die "没有找到该信息"
PageTitle = oTeacher("NickName"&Lang)
PageDescription = ""
PageBody = "page_body"
Call TopCode()
%>
		<div class="content">
			<div class="main">
				<div class="site_nav_bar">
					您现在的位置：<a href="/">首页</a> > 教师队伍 > <%=oTeacher("NickName"&Lang)%>
				</div>
				<div class="article_body">
					<h1 class="article_title"><%=oTeacher("NickName"&Lang)%></h1>
					<div class="article_content">
						<div class="teacher_face"><img src="<%=getTeacherImage(oTeacher("id"))%>" style="width:130px;height:160px;" /></div>
						<%=oTeacher("Content"&Lang)%>
					</div>
				</div>
			</div>
			<div class="sidebar">
				<div class="category_box">
					<div class="category_header">
						<h3 class="title">教师队伍</h3>
						<em>Teacher group</em>
					</div>
					<div class="category_body">
						<ul class="lite category_lite">
							<%
							Casp.db.Exec rs,"select * from [Teacher] order by sortid asc,id asc"
							If Not rs.eof Then
								Do While Not rs.eof
								%>
								<li <%=IIF(rs("id")=xId,"class=""curr""","")%>><a href="teacher.asp?id=<%=rs("id")%>" class="title">• <%=rs("NickName"&Lang)%></a></li>
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
