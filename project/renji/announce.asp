<!--#include file="page.master.asp"-->
<%
xId = Casp.rq(1,"id",0,0)
Casp.db.GetRowObject oAnnounce,"select top 1 * from Announce where id="&xId&""
If isset(oAnnounce) = False Then die "没有找到该信息"
PageTitle = oAnnounce("Title")
PageDescription = ""
PageBody = "page_full_body"
Call TopCode()
%>
		<div class="content">
			<div class="main">
				<div class="site_nav_bar">
					您现在的位置：<a href="/">首页</a> > <a href="announce_list.asp">公告</a> > <%=oAnnounce("Title")%>
				</div>
				<div class="article_body">
					<h1 class="article_title"><%=oAnnounce("title")%></h1>
					<div class="article_content">
						<%=oAnnounce("Content")%>
					</div>
				</div>
			</div>
		</div>
