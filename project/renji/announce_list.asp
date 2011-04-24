<!--#include file="page.master.asp"-->
<!--#include file="include/library/page.asp"-->
<%
PageTitle = ""
PageBody = "page_full_body"
Call TopCode()
%>


		<div class="content">
			<div class="main">
				<div class="site_nav_bar">
					您现在的位置：<a href="/">首页</a> > 公告
				</div>
				<div class="article_list_wrap">
					<ul class="lite article_lite">
						<%
						Casp.page.Conn = Casp.db.conn
						Casp.page.PageID = Trim(Request("PageID"))
						Casp.page.Size = 10
						Casp.page.Header_a rs,"[Announce]","*","[language]='"&Mid(Lang,2,Len(Lang))&"'","","sortid desc,id desc"
						If Not rs.eof Then
							Do While Not rs.eof
							%>
								<li><a href="announce.asp?id=<%=rs("id")%>" class="title"><%=rs("Title")%></a><em class="date"><%=DateValue(rs("addtime"))%></em></li>
							<%
								rs.MoveNext
							Loop
						End If
						
						%>
					</ul>
					<div class="pager"><%Casp.page.Footer_b "",""%></div>
				</div>
			</div>
		</div>
