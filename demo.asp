<!--#include file="config.inc.asp"-->
<%
xViewContent = "asdsad��������<img src='http://www.haoyl.com/skin/haoyl/images/logo.jpg' />asdsa"
xViewContent = Tpub.String.regExpReplace(xViewContent,"<\/?(?!br|p|img)[^>]*>","",false)
die xViewContent
%>