<!--#include file="page.master.asp"-->
<%
xId = Casp.rq(1,"id",0,0)
Casp.db.GetRowObject oNews,"select top 1 * from News where [language]='"&Mid(Lang,2,Len(Lang))&"' and id="&xId&""
If isset(oNews) = False Then die "没有找到该信息"
PageTitle = oNews("Title") & " - 纹身工作室动态，上海天尊堂纹身机构是上海最专业的国际化纹身店。"
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
            
            <div class="content_right3" id="news_detail">
            	<h3 class="title"><%=oNews("Title")%></h3>
				<div class="news_content">
                <%=Casp.HtmlDecode(oNews("Content"))%>
				</div>
            </div>
        </div>