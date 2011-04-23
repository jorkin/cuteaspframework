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
					您现在的位置：<a href="/">首页</a> > 关于我们
				</div>
				<div class="article_body">
					<div class="article_content">
						<%=getSingleModule("about_us")("Content"&Lang)%>
					</div>
				</div>
			</div>
			<div class="sidebar">
				<div class="category_box">
					<div class="category_header">
						<h3 class="title">关于我们</h3>
						<em>About us</em>
					</div>
					<div class="category_body">
						<ul class="lite category_lite">
							<li class="curr"><a href="about.asp" class="title">• 关于我们</a></li>
							<li><a href="contact.asp" class="title">• 联系我们</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
