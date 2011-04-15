<!--#include file="page.master.asp"-->
<!--#include file="include/library/page.asp"-->
<%
PageTitle = "纹身工作室动态，上海天尊堂纹身机构是上海最专业的国际化纹身店。"
PageDescription = ""
PageBody = "body3"
Call TopCode()
%>
        <div id="content" class="clearfix">
            <div class="content_left3">
            	<span><a href="/about_us_single" title="工作室简介"><strong>工作室简介</strong></a></span>
				<span><a href="/news" title="工作室动态"><strong>工作室动态</strong></a></span>
                <span><a href="/report.asp" title="媒体报道"><strong>媒体报道</strong></a></span>
				<span><a href="/links" title="友情链接"><strong>友情链接</strong></a></span>
            </div>
            
            <div class="content_right3" id="news_list">
            	<h3>纹身工作室动态</h3>
				<div class="news_list">
				<%
				Casp.page.Conn = Casp.db.conn
				Casp.page.PageID = Trim(Request("PageID"))
				Casp.page.Size = 10
				Casp.page.Header_a rs,"[news]","*","[language]='"&Mid(Lang,2,Len(Lang))&"'","","sortid desc,id desc"
				If Not rs.eof Then
					Do While Not rs.eof
					%>
						<p>
							<%If rs("IsImage") Then%><a href="/news/<%=rs("id")%>"><img src="<%=getNewsSmallImage(rs("id"))%>" /></a><br /><%End If%>
							<a href="/news/<%=rs("id")%>"><%=rs("Title")%></a>(<%=DateValue(rs("addtime"))%>)<br />
						</p>
					<%
						rs.MoveNext
					Loop
				End If
				Casp.page.Footer_b "",""
				%>
				</div>
            </div>
        </div>