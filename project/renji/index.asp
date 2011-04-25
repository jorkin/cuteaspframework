<!--#include file="page.master.asp"-->
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
					<a href="announce_list.asp" class="more">more..</a>
				</div>
			</div>
			<div class="m_body">
				<ul class="lite">
					<%
					Casp.db.Exec rs,"select Top 8 * from Announce where [language]='"&Replace(Lang,"_","")&"' order by sortid desc,id desc"
					Do While Not rs.eof
					%>
					<li><a href="announce.asp?id=<%=rs("id")%>" target="_blank"><%=rs("Title")%></a></li>
					<%
						rs.MoveNext
					Loop
					rs.close
					%>
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
					<a href="javascript:;" rel="0"></a>
				</div>
				<div class="group_inner">
					<ul class="lite group_lite">
						<%
						Casp.db.Exec rs,"select * from Teacher order by sortid asc,id asc"
						Do While Not rs.eof
						%>
						<li><div class="lite_image"><a href="<%=rs("Url"&Lang)%>" class="image_link"><img src="<%=getTeacherImage(rs("id"))%>" /></a><p><a href="<%=rs("Url"&Lang)%>" class="title"><%=rs("NickName"&Lang)%></a></p></div></li>
						<%
							rs.MoveNext
						Loop
						rs.close
						%>
					</ul>	
				</div>
				<div class="group_r_arrow">
					<a href="javascript:;" rel="1"></a>
				</div>
			</div>
		</div>
	</div>
	<div class="links">
		<select class="select" id="linkChange">
			<option value="">相关链接</option>
			<%
			Casp.db.Exec rs,"select * from links order by sortid desc,id desc"
			Do While Not rs.eof
				echo "<option value="""&rs("LinkUrl")&""" title="""&rs("LinkUrl")&""">"&rs("Title")&"</option>"
				rs.MoveNext
			Loop
			rs.close
			%>
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
	$("#linkChange").change(function(){
		var  url = $(this).val();
		if (url)
		{
			location.href = url;
		}
	});
	var obj = $(".group_lite");
	var item = $("li",obj);
	obj.width(item.outerWidth(true) * item.length);
	$(".group_l_arrow a,.group_r_arrow a").one("click",function(){
		var cb = arguments.callee;
		var self = this;
		var offsetX = item.outerWidth(true) * (item.length > 5 ? 5 : item.length);
		if (this.rel == 1)
		{
			if(Math.abs(obj.position().left - offsetX) >= obj.innerWidth()){
				offsetX = 0-obj.innerWidth() + offsetX;
			}else{
				offsetX = '-=' + offsetX;
			}
		}else{
			if(obj.position().left + offsetX >= 0){
				offsetX = 0;
			}else{
				offsetX = '+='+ offsetX;
			}
		}
		obj.animate({
			left: offsetX
		},800, function(){
			$(self).one("click",jQuery.proxy(cb,self));
		});
	});
});
</script>