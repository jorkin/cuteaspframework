<!--#include file="page.master.asp"-->
<%
PageTitle = ""
PageDescription = ""
PageBody = "page_body"
Call TopCode()
%>
		<div class="content">
			<div class="main">
				<div class="site_nav_bar">
					您现在的位置：<a href="/">首页</a> > 网站地图
				</div>
				<div class="article_body">
					<div class="article_content">
						<ul class="lite lite_parent">
						<%
						Casp.db.Exec rs,"select * from Category order by sortid asc,id asc"
						Do While Not rs.eof
							echo "<li><a href=""list.asp?cid="&rs("id")&""">"&rs("ClassName"&Lang)&"</a>"
							Casp.db.Exec rs1,"select * from news where CategoryId="&rs("id")&" order by sortid desc,id desc"
							Do While Not rs1.eof
								echo "<ul class=""lite lite_child"">"
								echo "<li><a href=""show.asp?id="&rs1("id")&""">"&rs1("Title")&"</a></li>"
								echo "</ul>"
								rs1.MoveNext
							Loop
							rs1.close
							echo "</li>"
							rs.MoveNext
						Loop
						rs.close
						%>
						</ul>
					</div>
				</div>
			</div>
		</div>
