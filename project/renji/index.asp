﻿<!--#include file="page.master.asp"-->
<%
PageTitle = ""
PageBody = "index_body"
Call TopCode()
%>
<div class="content">
	<div class="main">
		<div class="module slide_module">
			<div class="m_header">
				<div class="m_header_tl"></div>
				<div class="m_header_tr"></div>
				<h3 class="title">特色教学</h3>
			</div>
			<div class="m_body">
			</div>
		</div>
		<ul class="lite index_lite lite_cols2">
			<%
			Casp.db.Exec rs,"select * from News where isDisplay=true order by sortid desc,id desc"
			Do While Not rs.eof
			%>
			<li>
				<div class="module index_single_module">
					<div class="m_header">
						<div class="m_header_tl"></div>
						<div class="m_header_tr"></div>
						<h3 class="title"><%=rs("Title")%></h3>
						<div class="options">
							<a href="list.asp?cid=<%=rs("categoryId")%>" class="more">more..</a>
						</div>
					</div>
					<div class="m_body">
						<p><%=Casp.String.Cut(Casp.String.StripHTML(rs("content")),55,true)%></p>
					</div>
				</div>
			</li>
			<%
				rs.MoveNext
			Loop
			rs.close
			%>
		</ul>
	</div>
	<div class="sidebar">
		<div class="module side_module">
			<div class="m_header">
				<div class="m_header_tl"></div>
				<div class="m_header_tr"></div>
				<h3 class="title">网站公告</h3>
				<div class="options">
					<a href="" class="more">more..</a>
				</div>
			</div>
			<div class="m_body">
				<ul class="lite">
					<li><a href="">2010粘度麻醉与危重病系工作会议召开</a></li>
					<li><a href="">2010粘度麻醉与危重病系工作会议召开</a></li>
					<li><a href="">2010粘度麻醉与危重病系工作会议召开</a></li>
					<li><a href="">2010粘度麻醉与危重病系工作会议召开</a></li>
					<li><a href="">2010粘度麻醉与危重病系工作会议召开</a></li>
					<li><a href="">2010粘度麻醉与危重病系工作会议召开</a></li>
					<li><a href="">2010粘度麻醉与危重病系工作会议召开</a></li>
					<li><a href="">2010粘度麻醉与危重病系工作会议召开</a></li>
					<li><a href="">2010粘度麻醉与危重病系工作会议召开</a></li>
					<li><a href="">2010粘度麻醉与危重病系工作会议召开</a></li>
				</ul>
			</div>
		</div>
		<div class="module side_module">
			<div class="m_header">
				<div class="m_header_tl"></div>
				<div class="m_header_tr"></div>
				<h3 class="title">课程介绍</h3>
				<div class="options">
					<a href="list.asp?cid=11" class="more">more..</a>
				</div>
			</div>
			<div class="m_body">
				<p>
				<%
				Casp.db.getRowObject oNews,"select * from News where id = 289"
				echo Casp.String.Cut(Casp.String.StripHTML(oNews("content")),55,true)
				Set oNews = Nothing
				%>
				</p>
			</div>
		</div>
		<div class="module side_module">
			<div class="m_header">
				<div class="m_header_tl"></div>
				<div class="m_header_tr"></div>
				<h3 class="title">教学与科研成果</h3>
				<div class="options">
					<a href="list.asp?cid=18" class="more">more..</a>
				</div>
			</div>
			<div class="m_body">
				<p>
				<%
				Casp.db.getRowObject oNews,"select * from News where id = 328"
				echo Casp.String.Cut(Casp.String.StripHTML(oNews("content")),55,true)
				Set oNews = Nothing
				%>
				</p>
			</div>
		</div>
		<div class="module qa_module">
			<div class="m_body">
				<a href="guestbook.asp" class="qa_btn"></a>
			</div>
		</div>
	</div>
	<div class="module group_module">
		<div class="m_header">
			<div class="m_header_tl"></div>
			<div class="m_header_tr"></div>
			<h3 class="title">教学队伍</h3>
		</div>
		<div class="m_body">
			<div class="group_wrap">
				<div class="group_l_arrow">
					<a href=""></a>
				</div>
				<div class="group_inner">
					<ul class="lite group_lite">
						<li><div class="lite_image"><a href="" class="image_link"><img src="css/temp.jpg" /></a><p><a href="" class="title">教授顾问：朱也森</a></p></div></li>
						<li><div class="lite_image"><a href="" class="image_link"><img src="css/temp.jpg" /></a><p><a href="" class="title">教授顾问：朱也森</a></p></div></li>
						<li><div class="lite_image"><a href="" class="image_link"><img src="css/temp.jpg" /></a><p><a href="" class="title">教授顾问：朱也森</a></p></div></li>
						<li><div class="lite_image"><a href="" class="image_link"><img src="css/temp.jpg" /></a><p><a href="" class="title">教授顾问：朱也森</a></p></div></li>
						<li><div class="lite_image"><a href="" class="image_link"><img src="css/temp.jpg" /></a><p><a href="" class="title">教授顾问：朱也森</a></p></div></li>
						<li><div class="lite_image"><a href="" class="image_link"><img src="css/temp.jpg" /></a><p><a href="" class="title">教授顾问：朱也森</a></p></div></li>
						<li><div class="lite_image"><a href="" class="image_link"><img src="css/temp.jpg" /></a><p><a href="" class="title">教授顾问：朱也森</a></p></div></li>
					</ul>	
				</div>
				<div class="group_r_arrow">
					<a href=""></a>
				</div>
			</div>
		</div>
	</div>
	<div class="links">
		<select class="select">
			<option>相关链接</option>
		</select>
	</div>
</div>
<script>
$(function(){
	SNS.common.blockSlide({
		width: 575, 	//宽度
		height: 380, 	//高度
		data: [<%
			Casp.db.Exec rs,"select * from Advert order by sortid asc,id desc"
			Do While Not rs.eof
				echo "{href:"""&rs("url")&""",image:"""&rs("image")&""",title:"""&rs("title")&"""}"
				rs.MoveNext
				If Not rs.eof Then echo ","
			Loop
			rs.close
		%>], 	//广告列表，例：[{href:"",image:"",title:""}]
		interval: 5, //轮播间隔
		styleurl: ""	//特殊样式URL
	});
});
</script>