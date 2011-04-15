<%@ CodePage=65001%>
<!--#include file="config.inc.asp"-->
<%
'''''''页面模板页'''''''
'加载头部
%>
<script language="vbscript" runat="server">
'加载底部
Footer()
</script>










<%
'头部
Dim PageTitle
Dim PageKeyWords
Dim PageDescription
Sub Header()
	If PageTitle <> "" Then
		PageTitle = PageTitle & " - "
	End If
	If PageBody = "" Then PageBody = "body"
	If PageDescription = "" Then
		PageDescription = Casp.WebConfig("Description")
	End If
	Casp.noBuffer()
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Language" content="zh-cn" />
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><%=PageTitle&Casp.WebConfig("SiteTitle")%></title>
	<meta http-equiv="Pragma" content="no-cache" />
	<meta name="description" content="<%=PageDescription%>" />
	<link rel="stylesheet" type="text/css" href="/css/global.css" />
	<link rel="stylesheet" type="text/css" href="/css/colorbox.css" />
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
	<script type="text/javascript" src="/js/jquery.colorbox-min.js"></script>
	<script type="text/javascript" src="/fckeditor/fckeditor.js"></script>
	<!--[if lte IE 6]>
	<script type="text/javascript" src="/js/unitpngfix.js"></script>
	<![endif]-->
	<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
	<link rel="icon" href="/favicon.ico" type="image/x-icon" />
	<script type="text/javascript">
	$(function(){
		$(".worksimage").colorbox({
			slideshow:true,
			maxWidth:800,
			maxHeight:620,
			slideshowSpeed:10000
		});
		$("textarea.fckeditor").hide(0,function(){
			var oFCKeditor = new FCKeditor($(this).attr("id"));
			oFCKeditor.Config['ToolbarStartExpanded'] = false ;
			oFCKeditor.ToolbarSet = "Basic" ;
			if($(this).attr("rows") == -1)
				oFCKeditor.Height = this.style.height || 300;
			else
				oFCKeditor.Height = $(this).attr("rows") * 50;
			oFCKeditor.BasePath	= "/fckeditor/" ;
			oFCKeditor.ReplaceTextarea();
		});
	});
	</script>
</head>
<body id="<%=PageBody%>">
<div id="contianer">
	<div id="wrap">
<%
End Sub

'底部
Sub Footer()
%>
        <table id="footer_menu">
            <tr>
                <th width="80">纹身师</th>
                <td>
                    <%
					Casp.db.Exec rs,"select * from Artist order by sortid desc,id desc"
					Do While Not rs.eof
						echo "<a href=""/artist/"&rs("id")&""">"&rs("NickName"&Lang)&"</a>"
						rs.MoveNext
						If Not rs.eof Then echo " | "
					Loop
					Casp.db.closeRs rs
					%>
                </td>
            </tr>
            <tr>
                <th>纹身工作室</th>
                <td>
                    <a href="/about_us_single">工作室简介</a>&nbsp;|&nbsp;
                    <a href="/news">工作室动态</a>&nbsp;|&nbsp;
                    <a href="/report.asp">媒体报道</a>&nbsp;|&nbsp;
                    <a href="/links">友情链接</a>
                </td>
            </tr>
            <tr>
                <th>纹身作品</th>
                <td>
                    <%
					Casp.db.Exec rs,"select * from Category order by sortid desc,id desc"
					Do While Not rs.eof
						echo "<a href=""/works/c"&rs("id")&""">"&rs("ClassName"&Lang)&"</a>"
						rs.MoveNext
						If Not rs.eof Then echo " | "
					Loop
					Casp.db.closeRs rs
					%>
                </td>
            </tr>
            <tr>
                <th>纹身商品</th>
                <td>
                    <a href="/goods_tools_single">纹身机器</a>&nbsp;|&nbsp;
                    <a href="/books_single">纹身书籍</a>&nbsp;|&nbsp;
                    <a href="/t_shirt_single">纹身T恤</a>
                </td>
            </tr>
            <tr>
                <th>纹身培训</th>
                <td>
                    <a href="/training_single">纹身培训</a>
                </td>
            </tr>
            <tr>
                <th>联系方式</th>
                <td>
                    <a href="/contact_us_single">纹身预约</a>
                </td>
            </tr>
            <tr>
                <th>语言</th>
                <td>
                    <a href="/en">English</a>&nbsp;|&nbsp;
                    <a href="/">中文版</a>
                </td>
            </tr>
        </table>
	</div>
    <div id="footer">
		上海市黄浦区广西北路252号百米香榭商业街1楼137室<br />
		252 North Guangxi Road, Huangpu District, Shanghai, 1st Floor, Room 137<br />
		Tel:86-21-63518781 86-13818264589&nbsp;&nbsp;QQ:837591770&nbsp;&nbsp;MSN:duzewu@hotmail.com&nbsp;&nbsp;Email:billdutattoo@163.com<br />
		Copyright @ 2010 上海天尊堂纹身馆&nbsp;&nbsp;版权所有&nbsp;&nbsp;不得转载&nbsp;&nbsp;<a href="http://www.miibeian.gov.cn/" target="_blank">沪ICP备10209632号</a>&nbsp;&nbsp;<script src="http://s4.cnzz.com/stat.php?id=2136599&web_id=2136599" language="JavaScript"></script>
    </div>
    <div style="display:none;">
        <script type="text/javascript">
        
          var _gaq = _gaq || [];
          _gaq.push(['_setAccount', 'UA-17091308-1']);
          _gaq.push(['_trackPageview']);
        
          (function() {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
          })();
        
        </script>
    </div>
</div>
</body>
</html>
<%
End Sub

Sub TopCode()
	Call Header()
%>
        <div class="language">
            <a href="<%=Casp.WebConfig("SiteUrl")%>/en">English</a>
            <a href="<%=Casp.WebConfig("SiteUrl")%>/index.asp">中文版</a>
        </div>
        <div class="logo1">
            <a href="/" title="<%=Casp.WebConfig("SiteTitle")%>"><img src="/css/logo.png" /></a>
        </div>
        <div class="main-menu1">
            <a href="/artist" title="纹身师"><img src="/css/artists.png" alt="纹身师" /></a>
            <a href="/about_us_single" title="纹身工作室"><img src="/css/studio.png" alt="纹身工作室" /></a>
            <a href="/works" title="纹身作品"><img src="/css/tattos.png" alt="纹身作品" /></a>
            <a href="/goods_tools_single" title="纹身商品"><img src="/css/stuffs.png" alt="纹身商品" /></a>
            <a href="/training_single" title="纹身培训"><img src="/css/training.png" alt="纹身培训" /></a>
            <a href="/contact_us_single" title="联系我们"><img src="/css/contactus.png" alt="联系我们" /></a>
        </div>
<%
End Sub
%>