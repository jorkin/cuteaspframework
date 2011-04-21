<%
'Option Explicit
Response.Buffer = True
Dim StartTime : StartTime = timer()
%>
<!--#include file="include/ext.asp"-->
<!--#include file="include/class.asp"-->
<!--#include file="include/library/db.asp"-->
<!--#include file="include/library/date.asp"-->
<!--#include file="include/library/array.asp"-->
<!--#include file="include/library/string.asp"-->
<!--#include file="include/library/params.asp"-->
<!--#include file="include/library/session.asp"-->
<!--#include file="include/AppFunctions.asp"-->
<%
Casp.WebConfig("CodePage")		=	65001				'设置站点编码
Casp.WebConfig("Charset")		=	"utf-8"		'设置站点字符集
Casp.WebConfig("FilterWord")	=	""				'设置过滤字符

Casp.WebConfig.Add "SiteTitle","上海交通大学医学院"				'站点名称
Casp.WebConfig.Add "Description","上海交通大学医学院麻醉与危重病医学精品课程专题网"				'站点简介
Casp.WebConfig.Add "SitePath",""				'站点路径
Casp.WebConfig.Add "SiteUrl","http://localhost:9100"				'站点路径
Casp.WebConfig.Add "UserFacePath","/attached/userface"				'头像路径
Casp.WebConfig.Add "GuestbookPath","/attached/guestbook"				'留言图片路径
Casp.WebConfig.Add "LinksPath","/attached/links"				'友情链接图片路径
Casp.WebConfig.Add "AdvertPath","/attached/advert"				'友情链接图片路径
Casp.WebConfig.Add "NewsPath","/attached/news"				'新闻图片路径
Casp.WebConfig.Add "GuestbookSmallWidth",100				'留言缩略图宽度
Casp.WebConfig.Add "GuestbookSmallHeight",100				'留言缩略图高度
Casp.WebConfig.Add "NewsSmallWidth",272				'新闻缩略图宽度
Casp.WebConfig.Add "NewsSmallHeight",100				'新闻缩略图高度
Casp.WebConfig.Add "WorksPath","/userfiles/works"				'作品路径
Casp.WebConfig.Add "WorksSmallWidth",70				'作品缩略图宽度
Casp.WebConfig.Add "WorksSmallHeight",70				'作品缩略图高度
Casp.WebConfig.Add "UpFileType","gif|png|jpg"				'上传文件允许格式
Casp.WebConfig.Add "Language","cn"

Casp.db.ConnectionType = "ACCESS"
Casp.db.ServerIp = "localhost"
Casp.db.Database = "/database/db.mdb"
Casp.db.UserName = "sa"
Casp.db.Password = ""
Casp.db.Open()

On Error Resume Next
Session.CodePage = Casp.WebConfig("CodePage")
Response.Charset = Casp.WebConfig("Charset")
Casp.Cookie.Mark = "cute_"		'设置Cookie名称前缀
Casp.Cache.Mark = "cute_"		'设置缓存名称前缀
Casp.Ubb.Mode = 0				'使用基本UBB
Casp.Date.TimeZone = 8			'设置所在时区
Casp.Upload.Mode	= 1
Casp.Upload.Charset	= "utf-8"		'设置站点字符集
On Error Goto 0

Sub Finish()
    Dim RunTime : RunTime = round((Timer() - StartTime), 3)
    echo "<p style=""text-align:center;font-size:11px;"">Page rendered in " & RunTime & " seconds.</p>"
End Sub
%>
