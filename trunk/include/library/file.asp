<%
'**********
'	class		: file operate class
'	File Name	: file.asp
'	Version		: 0.1.0
'	Author		: TerranC
'	Date		: 2008-5-17
'**********

'**********
'	ʾ��
'**********

'**********
'	������
'**********
Class Class_File
	Public FSO			'����FSO�������
	Public Stream		'����Stream�������
	Public Charset		'�����ַ���

    '**********
    ' ������: class_Initialize
    ' ��  ��: Constructor
    '**********
	Private Sub Class_Initialize()
		Charset = "gb2312"
		Stream = "ADODB.Stream"
		FSO = "Scripting.FileSystemObject"
    End Sub

	'**********
	'��������GetFileTypeName
	'��  �ã���ȡ�ļ���չ��
	'**********
	Function GetFileTypeName(fName)
		Dim fileName : fileName = Split(fName, ".")
		GetFileTypeName = fileName(UBound(fileName))
	End Function
	
	'**********
	'��������CheckFileExt
	'��  �ã������Ƿ�Ϸ��ļ�
	'**********
	Function CheckFileExt(sFile,ext)
		If Trim(ext) = "" And Trim(ext) <> "*" Then 
			CheckFileExt = "jpg|gif|png"
		End If
		Dim arr_Ext : arr_Ext = split(ext,"|")
		Dim i, fileExt
		fileExt = Me.GetFileTypeName(sFile)
		CheckFileExt = False
		For Each i In arr_Ext
			If fileExt = i Then CheckFileExt = True
		Next
	End Function
	
	'**********
	'FormatFileSize
	'��  �ã���ʽ���ļ��Ĵ�С
	'**********
	Function FormatFileSize(fs)
		If fs>1073741824 Then
			fs = FormatNumber(fs / 1073741824, 2, true)&"&nbsp;GB"
		ElseIf fs>1048576 Then
			fs = FormatNumber(fs / 1048576, 1, true)&"&nbsp;MB"
		ElseIf fs>1024 Then
			fs = FormatNumber(fs / 1024, 1, true)&"&nbsp;KB"
		Else
			fs = FormatNumber(fs, 0, true)
		End If
		FormatFileSize = fs
	End Function
	
	'**********
	'GetFileSize
	'��  �ã���ȡ�ļ��Ĵ�С
	'**********
	Function GetFileSize(fls)
		Dim fso, fdr, arr_fls, fsize, i, fl
		arr_fls = split(fls,"||")
		fsize = 0
		For Each i In arr_fls
			fl = Server.MapPath(i)
			Set fso = Server.CreateObject(FSO)
			If fso.FileExists(fl) Then
				Set fdr = fso.GetFile(fl)
				fsize = fdr.size + fsize
				Set fdr = Nothing
			End If
			Set fso = Nothing
		Next
		GetFileSize = Me.FormatFileSize(fsize)
	End Function
	
	'**********
	'GetFolderSize
	'��  �ã���ȡĿ¼�Ĵ�С
	'**********
	Function GetFolderSize(fls)
		Dim fso, fdr, arr_fls, fsize, i, fl
		arr_fls = split(fls,"||")
		fsize = 0
		For Each i In arr_fls
			fl = Server.MapPath(i)
			Set fso = Server.CreateObject(FSO)
			If fso.FolderExists(fl) Then
				Set fdr = fso.GetFolder(fl)
				fsize = fdr.size + fsize
				Set fdr = Nothing
			End If
			Set fso = Nothing
		Next
		GetFolderSize = Me.FormatFileSize(fsize)
	End Function

	'**********
	'��������IsFolderExists
	'��  �ã����ĳһĿ¼�Ƿ����
	'��  ����FolderPath	----Ŀ¼
	'**********
	Function IsFolderExists(FolderPath)
		Dim fso
		FolderPath=Server.MapPath(".")&"\"&FolderPath
		Set fso = Server.CreateObject(FSO)
		If fso.FolderExists(FolderPath) then
			IsFolderExists = True	'����
		Else
			IsFolderExists = False	'������
		End if
		Set fso = nothing
	End Function
	
	'**********
	'��������IsFileExists
	'��  �ã����ĳһĿ¼�Ƿ����
	'��  ����FilePath	----Ŀ¼
	'**********
	Function IsFileExists(FilePath)
		Dim fso
		FilePath=Server.MapPath(".")&"\"&FilePath
		Set fso = Server.CreateObject(FSO)
		If fso.FileExists(FilePath) then
			IsFileExists = True	'����
		Else
			IsFileExists = False	'������
		End if
		Set fso = nothing
	End Function
	
	'**********
	'��������CreatePath
	'��  �ã������༶Ŀ¼�����Դ��������ڵĸ�Ŀ¼
	'��  ����Ҫ������Ŀ¼���ƣ������Ƕ༶
	'�����߼�ֵ��True�ɹ���Falseʧ��
	'����Ŀ¼�ĸ�Ŀ¼�ӵ�ǰĿ¼��ʼ
	'**********
	Function CreatePath(CFolder)
		On Error Resume Next
		Dim objFSO,PhCreateFolder,CreateFolderArray,CreateFolder
		Dim i,ii,CreateFolderSub,PhCreateFolderSub,BlInfo
		BlInfo = False
		CreateFolder = CFolder
		Set objFSO = Server.CreateObject(FSO)
		If Err Then
			Err.Clear
			Exit Function
		End If
		CreateFolder = Replace(CreateFolder,"\","/")
		If Right(CreateFolder,1)="/" Then
			CreateFolder = Left(CreateFolder,Len(CreateFolder)-1)
		End If
		CreateFolderArray = Split(CreateFolder,"/")
		For i = 0 to UBound(CreateFolderArray)
			CreateFolderSub = ""
			For ii = 0 to i
				CreateFolderSub = CreateFolderSub & CreateFolderArray(ii) & "/"
			Next
			PhCreateFolderSub = Server.MapPath(CreateFolderSub)
			If Not objFSO.FolderExists(PhCreateFolderSub) Then
				objFSO.CreateFolder(PhCreateFolderSub)
			End If
		Next
		If Err Then
			Err.Clear
		Else
			BlInfo = True
		End If
		Set objFSO=nothing
		CreatePath = BlInfo
	End Function
	
	'**********
	'��������DelFile
	'��  �ã�ɾ���ļ�
	'��  ����Ҫɾ�����ļ�����(֧����|�ָ����б�)
	'**********
	Function DelFile(sFiles) 
		DelFile=True
		Dim fso, sFile, i
		sFile = split(sFiles,"|")
		Set fso=Server.CreateObject(FSO) 
		For i = 0 to Ubound(sFile)
			If fso.FileExists(Server.MapPath(sFile(i))) then 
				fso.DeleteFile(Server.MapPath(sFile(i)))
			End If
		Next
		Set fso=Nothing
		If Err Then
			Err.Clear
			DelFile = False
		End If
	End Function 

	'**********
	'��������DelFolder
	'��  �ã�ɾ��Ŀ¼
	'��  ����Ҫɾ����Ŀ¼����
	'**********
	Function DelFolder(sPath) 
		On Error Resume Next
		DelFolder=False
		Dim fso,tmpfolder,tmpsubfolder,tmpfile,tmpfiles 
		Set fso=Server.CreateObject(FSO) 
		If (fso.FolderExists(Server.MapPath (sPath))) then 
			Set tmpfolder=fso.GetFolder(Server.MapPath (sPath)) 
			Set tmpfiles=tmpfolder.files 
			For each tmpfile in tmpfiles 
				fso.DeleteFile (tmpfile) 
			Next 
			Set tmpsubfolder=tmpfolder.SubFolders 
			For each tmpfolder in tmpsubfolder 
				DelFolder(spath&"/"&tmpfolder.name ) 
			Next 
			fso.DeleteFolder (Server.MapPath (sPath)) 
		End If 
		If Err Then
			Err.Clear
		Else
			DelFolder=True
		End If
	End Function 
	
	'**********
	'��������LoadFile
	'��  �ã���ȡ�ļ�
	'��  ����File	----�ļ�·��
	'**********
	Function LoadFile(sFile)
		On Error Resume Next
		Dim objStream
		Dim RText
		Set objStream = Server.CreateObject(Stream)
		If Err Then 
			RText = Array(Err.Number,Err.Description)
			LoadFile="False"
			Err.Clear
			Exit Function
		End If
		With objStream
			.Type = 2
			.Mode = 3
			.Open
			.Charset = Charset
			.Position = objStream.Size
			.LoadFromFile Server.MapPath(sFile)
			If Err.Number<>0 Then
			   RText = Err.Description
			   LoadFile=RText
			   Err.Clear
			   Exit Function
			End If
			RText=.ReadText
			.Close
		End With
		LoadFile=RText
		Set objStream = Nothing
	End Function
	
	'**********
	'��������SaveFile
	'��  �ã������ļ�
	'��  ����sFilePath	----�ļ�·��
	'		 sPageContent --�ļ�����
	'**********
	Function SaveFile(sFilePath,sPageContent)
		SaveFile=True
		Dim FileName
		Dim S
		Set S = Server.CreateObject(Stream)
		FileName=Server.MapPath(sFilePath)
		With S
			.Open
			.Charset = Charset
			.WriteText sPageContent
			.SaveToFile FileName,2
			.Close
		End With
		Set S = Nothing
		If Err Then
			SaveFile=False
		End If
	End Function
	
	'**********
	'�����ļ�
	'sFilePath:Դ�ļ�
	'dFilePath:Ŀ�ļ�
	'**********
	Function CopyFile(sFilePath, dFilePath)
		On Error Resume Next
		CopyFile = True
	    Dim fs
	    Set fs = Server.CreateObject(FSO)
	    fs.CopyFile Server.Mappath(sFilePath), Server.Mappath(dFilePath)
	    Set fs = Nothing
	    If Err Then
			Err.Clear 
			CopyFile = False
	    End If
	End Function
	
	'**********
	'����Ŀ¼�������ļ�
	'sFolderPath:ԴĿ¼
	'dFolderPath:Ŀ��Ŀ¼
	'**********
	Function CopyFolder(sFolderPath, dFolderPath)
		On Error Resume Next
		CopyFolder = True
	    Dim fs
	    Set fs = Server.CreateObject(FSO)
	    fs.CopyFolder Server.Mappath(sFolderPath), Server.Mappath(dFolderPath)
	    Set fs = Nothing
	    If Err Then 
			CopyFolder = False
	    End If
	End Function
	
	'**********
	'����ָ��Ŀ¼�ļ��б�
	'strDir:Ŀ¼
	'strFileExt:�ļ�����(��|�ָ�)
	'**********
	Function LoadIncludeFiles(strDir,strFileExt)
		Dim aryFileList()
		ReDim aryFileList(0)
		Dim fso, f, f1, fc, s, i
		Set fso = Server.CreateObject(FSO)
		Set f = fso.GetFolder(Server.Mappath(strDir))
		Set fc = f.Files
		i=0
		For Each f1 in fc
			If Me.CheckFileExt(f1.Name,strFileExt) Then
				ReDim Preserve aryFileList(i)
				aryFileList(i) = f1.Name 
				i = i+1
			End If
		Next
		LoadIncludeFiles = aryFileList
	End Function
	
	'**********
	'����ָ��Ŀ¼��Ŀ¼�б�
	'strDir:Ŀ¼
	'**********
	Function LoadIncludeFolder(strDir)
		Dim aryFileList()
		ReDim aryFileList(0)
		Dim fso, f, f1, fc, s, i
		Set fso = Server.CreateObject(FSO)
		Set f = fso.GetFolder(Server.Mappath(strDir))
		Set fc = f.SubFolders 
		i=0
		For Each f1 in fc
			ReDim Preserve aryFileList(i)
			aryFileList(i)=f1.Name 
			i=i+1
		Next
		LoadIncludeFolder=aryFileList
	End Function
End Class
%>
