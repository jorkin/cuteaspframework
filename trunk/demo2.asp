<!--#include file="config.inc.asp"-->
<!--#include file="include/library/cache.asp"-->
<!--#include file="include/library/cookie.asp"-->
<!--#include file="include/library/debug.asp"-->
<!--#include file="include/library/file.asp"-->
<!--#include file="include/library/page.asp"-->
<!--#include file="include/library/upload.asp"-->
<!--#include file="include/helper/basicencode.asp"-->
<!--#include file="include/helper/email.asp"-->
<!--#include file="include/helper/excel.asp"-->
<!--#include file="include/helper/validcode.asp"-->
<!--#include file="include/helper/interface.asp"-->
<!--#include file="include/helper/json.asp"-->
<!--#include file="include/helper/md5.asp"-->
<!--#include file="include/helper/sha1.asp"-->
<!--#include file="include/helper/xml.asp"-->
<%

	Tpub.xml.Open("help/resource/data/menu.xml")
	Set xml = Tpub.xml.ChildNode("","tree",false).getElementsByTagName("class")
	menuContent = "<ul>"&vbCrlf
	i = 1
	For Each item In xml
		Dim itemName
		itemName = item.getAttribute("name")
		Tpub.file.CreatePath("help/manual/"&itemName)
		Dim fileContent
		Tpub.file.Charset = "utf-8"
		fileContent = Tpub.file.LoadFile("help/close.html")
		fileContent = Replace(fileContent,"<title>Db.Close - 帮助文档</title>","<title>"&itemName & " - 帮助文档</title>")
		fileContent = Replace(fileContent,"<h1 class=""title"">Db.Close</h1>","<h1 class=""title"">"&itemName&"</h1>")
		tmp = ""
		If i = 1 Then
			menuContent = menuContent & "<li class=""menuHeader"">"&vbCrlf
		Else
			menuContent = menuContent & "<li>"&vbCrlf
		End If
		menuContent = menuContent & "<h3><a href=""../"&LCase(itemName)&"/default.html"">"&itemName&"</a></h3>"&vbCrlf
		menuContent = menuContent & "<ul class=""smallTree"" id="""&LCase(itemName)&"Tree"">"&vbCrlf
		For Each item1 In item.getElementsByTagName("method")
			'fileContent = Replace(Replace(,"gmdate",itemName & "." & item1.getAttribute("name")),"<h1 class=""title"">Db.Close</h1>","<h1 class=""title"">"&itemName & "." & item1.getAttribute("name") & "</h1>")
			tmp = tmp & "<dl id="""&item1.getAttribute("name")&""" class=""funDesc"">"&vbCrlf
			tmp = tmp & "<dt>"&itemName & "." & item1.getAttribute("name")&"</dt>"&vbCrlf
			tmp = tmp & "<dd>"&vbCrlf
			tmp = tmp & "<p>"&item1.getAttribute("value")&"</p>"&vbCrlf
			If item1.getAttribute("demo") <> "" Then tmp = tmp & "<div class=""code"">"&item1.getAttribute("demo")&"</div>"&vbCrlf
			tmp = tmp & "<p class=""watchful"" style=""display:none"">注意事项</p>"&vbCrlf
			tmp = tmp & "</dd>"&vbCrlf
			tmp = tmp & "</dl>"&vbCrlf
			tmp = replace(tmp,"Common.","")
			menuContent = menuContent & "<li><a href=""../"&LCase(itemName)&"/default.html#"&item1.getAttribute("name")&""" title="""&item1.getAttribute("value")&""">"&item1.getAttribute("name")&"</a></li>"&vbCrlf
		Next
		fileContent = Replace(fileContent,"{Content}",tmp)
		Tpub.file.SaveFile "help/manual/"&itemName&"/default.html",fileContent
		menuContent = menuContent & "</ul>"&vbCrlf
		menuContent = menuContent & "</li>"&vbCrlf
		i = i + 1
	Next
	menuContent = menuContent & "</ul>"&vbCrlf
	Tpub.file.SaveFile "help/resource/data/menu.html",menuContent
	Tpub.xml.close
%>