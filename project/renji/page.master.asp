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
	<link href="/css/style.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="../js/jquery-1.5.1.min.js"></script>
	<script type="text/javascript" src="../js/kindeditor-min.js"></script>
	<script type="text/javascript" src="../js/cute.js"></script>
	<script type="text/javascript" src="../js/core/form.js"></script>
	<script type="text/javascript" src="../js/common.js"></script>
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
<body class="<%=PageBody%>">
<div class="wrap">
	<div class="container">
<%
End Sub

'底部
Sub Footer()
%>
		<div class="footer">
			<div class="footer_inner">
				<p class="f_company">2011 上海交通大学医学院麻醉与危重病医学系</p>
				<p class="f_address">地址：上海市东方路  电话：12345678</p>
			</div>
		</div>
	</div>
</div>
</body>
</html>
<%
End Sub

Sub TopCode()
	Call Header()
%>
		<div class="header">
			<div class="logo">
				<a href="" title="首页"></a>
			</div>
			<div class="top_nav">
				<ul>
					<li><a href="">English</a></li>
					<li><a href="about.asp">关于我们</a></li>
					<li><a href="sitemap.asp">网站地图</a></li>
				</ul>
			</div>
			<div class="top_banner">
				<a href=""></a>
			</div>
			<ul class="main_menus">
				<li><a href="/">首　页</a></li>
                <%
				Casp.db.Exec rs,"select * from Category order by sortid asc,id asc"
				Do While Not rs.eof
				%>
				<li><a href="list.asp?cid=<%=rs("id")%>"><%=rs("ClassName_"&Mid(Lang,2,Len(Lang)))%></a></li>
				<%
					rs.MoveNext
				Loop
				rs.close
				%>
			</ul>
		</div>
<%
End Sub
%>