<!--#include file="page.master.asp"-->
<%
PageTitle = "上海天尊堂纹身机构，上海最专业的国际化纹身店。上海纹身。Shanghai Tattoo。"
PageDescription = "上海天尊堂纹身师中国最专业国际纹身机构，首席纹身师杜泽武先生在国内外纹身界享有盛誉。本机构提供多风格纹身、人体彩绘、穿刺、刺青、纹身器材、纹身设计、纹身培训等多元化的专业服务。"
PageBody = "body"
Call TopCode()
%>
        <div id="content" class="clearfix">
            <div class="content_left1">
                <a href="/goods_tools_single"><img src="/css/index_stuff.png" /></a>
                <%
				Casp.db.Exec rs,"select Top 3 * from News where [language]='"&Mid(Lang,2,Len(Lang))&"' and isdisplay=true order by sortid desc,id desc"
				Do While Not rs.eof
				%>
                <div class="index_news">
                    <%If rs("IsImage") Then%><p><a href="/news/<%=rs("id")%>"><img src="<%=getNewsSmallImage(rs("id"))%>" /></a></p><%End If%>
                    <a href="/news/<%=rs("id")%>"><%=rs("Title")%></a>
                </div>
				<%
					rs.MoveNext
				Loop
				rs.close
				%>
                <div class="index_more"><a href="news">>>&nbsp;&nbsp;更多纹身资讯</a></div>
            </div>
            <div class="content_right1">
            	<div class="index_tattoos"><%=getSingleModule("index_intro")("Content"&Lang)%></div>
                <h3>最新纹身作品</h3>
				<ul class="works_list">
				<%
				Casp.db.Exec rs,"select Top 20 * from Works order by sortid desc,id desc"
				Do While Not rs.eof
				%>
					<li><a href="<%=getWorkImage(rs("id"))%>" class="worksimage" rel="workgroup" title="<%=rs("Title"&Lang)%>"><img src="<%=getWorkSmallImage(rs("id"))%>" onerror="this.src='/images/nopic.jpg'" width="<%=Casp.WebConfig("WorksSmallWidth")%>" /></a></li>
				<%
					rs.MoveNext
				Loop
				rs.close
				%>
				</ul>
                <div class="index_works"><a href="works">>>&nbsp;&nbsp;更多纹身作品</a></div>
            </div>
        </div>