<%
Function getArtistImage(id)
	getArtistImage = Casp.WebConfig("SiteUrl") & Casp.WebConfig("UserFacePath") & "/" & id & ".jpg"
End Function
Function getLinksImage(id)
	getLinksImage = Casp.WebConfig("SiteUrl") & Casp.WebConfig("LinksPath") & "/" & id & ".jpg"
End Function

Function getWorkSmallImage(id)
	getWorkSmallImage = Casp.WebConfig("SiteUrl") & Casp.WebConfig("WorksPath") & "/" & id & "_small.jpg"
End Function

Function getWorkImage(id)
	getWorkImage = Casp.WebConfig("SiteUrl") & Casp.WebConfig("WorksPath") & "/" & id & ".jpg"
End Function

Function getNewsSmallImage(id)
	getNewsSmallImage = Casp.WebConfig("SiteUrl") & Casp.WebConfig("NewsPath") & "/" & id & ".jpg"
End Function

Function getNewsImage(id)
	getNewsImage = Casp.WebConfig("SiteUrl") & Casp.WebConfig("NewsPath") & "/" & id & ".jpg"
End Function

Function getGuestbookSmallImage(id)
	getGuestbookSmallImage = Casp.WebConfig("SiteUrl") & Casp.WebConfig("GuestbookPath") & "/" & id & "/preview.jpg"
End Function

Function MakePic(sourcpic,newwidth,newheight,destpic)
	MakePic=false
	Set Jpeg = Server.CreateObject("Persits.Jpeg")
	Jpeg.RegKey = "19851-45809-68580"
	if Err then
		die "���󣺿ռ�û��װaspjpeg���"
	end if
	Jpeg.Quality = 60
	Jpeg.Open Server.MapPath(sourcpic)
	jpeg.PreserveAspectRatio = True '�ȱ�����
	if jpeg.OriginalWidth/jpeg.OriginalHeight > newwidth/newheight then'̫���ˣ�Ҫ�������Ҳ���
		jpeg.Height = newheight
		jpeg.crop CInt((jpeg.Width - newwidth)/2),0,CInt((jpeg.Width - newwidth)/2)+newwidth,newheight
	else '̫���ˣ�Ҫ�������²���
		jpeg.Width = newwidth
		jpeg.crop 0,CInt((jpeg.Height - newheight)/2),newwidth,CInt((jpeg.Height - newheight)/2)+newheight
	end if
	Jpeg.Save Server.MapPath(destpic)
	if err.number=0 then MakePic=True
	Jpeg.Close
	Set Jpeg=Nothing
End Function

Function MakeWorksImage(ByVal id)
	OriginalWorksImage = Casp.WebConfig("SitePath") & Casp.WebConfig("WorksPath") & "/" & id & "_small.jpg"
	SmallWorksImage = Casp.WebConfig("SitePath") & Casp.WebConfig("WorksPath") & "/" & id & "_small.jpg"
	MakeWorksImage = MakePic(OriginalWorksImage,Casp.WebConfig("WorksSmallWidth"),Casp.WebConfig("WorksSmallHeight"),SmallWorksImage)
End Function

Function MakeNewsImage(ByVal id)
	OriginalNewsImage = Casp.WebConfig("SitePath") & Casp.WebConfig("NewsPath") & "/" & id & ".jpg"
	SmallNewsImage = Casp.WebConfig("SitePath") & Casp.WebConfig("NewsPath") & "/" & id & "_small.jpg"
	MakeNewsImage = MakePic(OriginalNewsImage,Casp.WebConfig("NewsSmallWidth"),Casp.WebConfig("NewsSmallHeight"),SmallNewsImage)
End Function

Function MakeGuestbookImage(ByVal id,ByVal Content)
	MakeGuestbookImage = False
'	If Content <> "" Then
'		Set obj = New regexp
'		obj.IgnoreCase = True ' �����Ƿ������ַ���Сд�� 
'		obj.Global = True ' ����ȫ�ֿ����ԡ� 
'		obj.Pattern = "http://(?:\w+\.)(?:\w+\.)?\w+(?:\.net|\.com|\.org|\.cn|\.cc|\.tv|[0-9]{1,3})(\S*\/)((\S)+(?:\.gif|\.jpg|\.jpeg|\.png|\.bmp))"
'		Set Matches = obj.Execute(Content)
'		Set obj = Nothing
'		For Each Match in Matches ' ����ƥ�伯�ϡ� 
'			Casp.File.CreatePath(Casp.WebConfig("SitePath") & Casp.WebConfig("GuestbookPath"))
'			xFileType = LCase(Casp.File.GetFileTypeName(Match.Value))
'			xFileName = Casp.WebConfig("SitePath") & Casp.WebConfig("GuestbookPath") & "/" & id &"_small.jpg"
'			die Casp.InterFace.SaveRemoteFile(xFileName,Match.Value,"")
'			If Casp.InterFace.SaveRemoteFile(xFileName,Match.Value,"")<>"$False$" Then
'				MakeGuestbookImage = MakePic(xFileName,Casp.WebConfig("GuestbookSmallWidth"),Casp.WebConfig("GuestbookSmallHeight"),xFileName)
'			End If
'			Exit For
'		Next 
'		Set Matches = Nothing
'	End If
End Function

Function Lang()
	Lang = "_" & Casp.WebConfig("Language")
End Function

Function getSingleModule(module)
	Casp.db.GetRowObject getSingleModule,"select Top 1 * from SinglePage where ModuleName='"&module&"'"
	If isset(getSingleModule) Then
		If getSingleModule.Exists("Content") Then getSingleModule.Item("Content") = Casp.HtmlDecode(getSingleModule.Item("Content"))
		If getSingleModule.Exists("Content"&Lang) Then getSingleModule.Item("Content"&Lang) = Casp.HtmlDecode(getSingleModule.Item("Content"&Lang))
	End If
End Function
%>