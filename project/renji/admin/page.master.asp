<%@ CodePage=65001%>
<!--#include file="../config.inc.asp"-->
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
	If Casp.GetSelfName() <> "default.asp" Then
		If isset(Casp.Session.Get("username")) = False Then
			locationHref("default.asp")
		End If
	End If
	If PageTitle <> "" Then
		PageTitle = PageTitle & " - "
	End If
	If PageBody = "" Then PageBody = "default"
	Casp.noBuffer()
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="zh" xml:lang="zh">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=7" />
<meta http-equiv="Content-Language" content="zh-cn" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=PageTitle&Casp.WebConfig("SiteTitle")%></title>
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="style/css.css" type="text/css" media="all" />
<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
<link rel="icon" href="/favicon.ico" type="image/x-icon" />
<script type="text/javascript" src="../js/jquery-1.5.1.min.js"></script>
<script type="text/javascript" src="../js/kindeditor-min.js"></script>
<script type="text/javascript" src="../js/cute.js"></script>
<script type="text/javascript" src="../js/core/form.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<script type="text/javascript">
$(function(){
	$("input:checkbox.checkall").click(function(){
		$(this).closest("form").find($(this).attr("rel")).attr("checked",function(){
			return !this.checked;
		})
	});
	$("textarea.fckeditor").hide(0,function(){
        SNS.common.editor(this.id);
	});
	$("dl.tabs dt a").click(function(){
		 var _index = $(this).closest("dt").find("a").index($(this).siblings().removeClass("curr").end().addClass("curr"));
		$(this).closest("dl").find("dd:not(.none)").hide().eq(_index).show();
	});
	$("table.table>tr").not(".none").hover(function(){
		$(this).addClass("hover");
	},function(){
		$(this).removeClass("hover");
	});
	$("#nav_menu li.top").hover(function(){
		$(this).addClass("sfhover");
	},function(){
		$(this).removeClass("sfhover");
	});
});
</script>
</head>
<body id="<%=PageBody%>">
<div id="wrap">
  <%
End Sub

'底部
Sub Footer()
%>
</div>
<div id="bottom"><small>Data System | BETA v1.0 | Copyright &copy; 2008 (by <a href="http://terran.cc" target="_blank">TerranC</a>)</small></div>
</body>
</html>
<%
End Sub

Sub TopCode()
	Call Header()
%>
<div id="top">
  <div id="logo"><a href="Main.asp" title="Data System"></a></div>
  <div id="version">BETA v1.0</div>
</div>
<div id="nav">
  <ul id="nav_menu">
    <li class="top"><a href="javascript:;" class="top">基本设置</a>
      <ul>
        <li><a href="single.asp?m=index_intro" class="nav">首页介绍</a></li>
        <li><a href="single.asp?m=about_us" class="nav">关于我们</a></li>
        <li><a href="single.asp?m=contact_us" class="nav">联系我们</a></li>
        <li>
          <div class="sep">&nbsp;</div>
        </li>
        <li><a href="links.asp?do=list" class="nav">友情链接</a></li>
        <li><a href="advert.asp?do=list" class="nav">轮播广告</a></li>
        <li>
          <div class="sep">&nbsp;</div>
        </li>
        <li><a href="manager.asp" class="nav">修改密码</a></li>
        <li>
          <div class="sep">&nbsp;</div>
        </li>
        <li><a href="default.asp?action=logout" class="nav">登出</a></li>
      </ul>
    </li>
    <li class="top"><a href="javascript:;" class="top">公告管理</a>
      <ul>
        <li><a href="announce.asp?do=edit" class="nav">添加公告</a></li>
        <li><a href="announce.asp?do=list" class="nav">公告管理</a></li>
      </ul>
	</li>
    <li class="top"><a href="javascript:;" class="top">信息管理</a>
      <ul>
		<%
		Casp.db.Exec rs,"select * from Category order by sortid asc,id asc"
		Do While Not rs.eof
			echo "<li><a href=""news.asp?do=list&cid="&rs("id")&""" class=""nav"" title="""&rs("ClassName_en")&""">"&rs("ClassName_cn")&"</a></li>"
			rs.MoveNext
		Loop
		Casp.db.closeRs rs
		%>
        <li>
          <div class="sep">&nbsp;</div>
        </li>
        <li><a href="news.asp?do=list" class="nav">全部列表</a></li>
        <li>
          <div class="sep">&nbsp;</div>
        </li>
        <li><a href="page.asp?do=list" class="nav">额外单页管理</a></li>
      </ul>
	</li>
    <li class="top"><a href="javascript:;" class="top">栏目类别</a>
      <ul>
        <li><a href="category.asp?do=edit" class="nav">添加类别</a></li>
        <li><a href="category.asp?do=list" class="nav">栏目管理</a></li>
      </ul>
	</li>
    <li class="top"><a href="javascript:;" class="top">教师管理</a>
      <ul>
        <li><a href="teacher.asp?do=edit" class="nav">添加教师</a></li>
        <li><a href="teacher.asp?do=list" class="nav">教师列表</a></li>
      </ul>
	</li>
    <li class="top"><a href="javascript:;" class="top">自测试卷</a>
      <ul>
        <li><a href="pager.asp?do=edit" class="nav">添加试卷</a></li>
        <li><a href="pager.asp?do=list" class="nav">试卷管理</a></li>
      </ul>
	</li>
    <li class="top"><a href="guestbook.asp" class="top">答疑台</a></li>
  </ul>
</div>
<%
End Sub

Sub ShowError(params)
	Call TopCode()
	If TypeName(params) = "Array" Then
		Params = Array(params)
	End If
%>
<div id="inner">
  <div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;错误信息</div>
  <div id="main">
  <%If IsArray(Params) Then echo "<h3 class=""error_title"">系统打岔啦</h3>"%>
	<ul class="error_list">
	 <%
	  For Each item In Params
		echo "<li>"&item&"</li>"
	  Next
	  %>
	  <li class="error_back">>> <a href="<%=IIF( Casp.RefererUrl = "","default.asp","javascript:history.back()")%>">返回</a></li>
  </ul>
  </div>
</div>
<%	
	Call Footer()
	die("")
End Sub
%>