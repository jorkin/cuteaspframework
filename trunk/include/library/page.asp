<%
'**********
'	class		: page
'	File Name	: page.asp
'	Version		: 0.2.0
'	Author		: TerranC
'	Date		: 2008-6-20
'**********


'**********
'	ʾ��
'**********

'Dim Getdata
'Tpub.page.Conn = Tpub.db.conn
'Tpub.page.Page = Trim(Request("PageID"))
'Tpub.page.Size = 10
'Tpub.page.Header_b(rs,sTable,sPK,sFields,sWhere,sSort)
'Do While Not rs.eof
'	--------
'	MoveNext
'Loop
'Tpub.page.Footer_a "",""

'**********
'	������
'**********

Class Class_Page
	Private i_pCount,i_rCount,i_pSize,i_pNumber,i_conn,CurrentPath
	Public PageProcedure

	Private Sub Class_Initialize()
		i_pSize = 1
		i_pNumber = 1
		i_pCount = 0
		i_rCount = 0
		CurrentPath = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("SCRIPT_NAME")
		PageProcedure = "P_DbTable_RowCount_Paging"
	End Sub
	
	'**********��������**************************
	'Conn : ���ݿ����Ӷ���
	'Size : ÿҳ��ʾ
	'Page : ��ǰҳ��
	'**********
	Public Property Let Conn(ByVal n)
		Set i_conn = n
	End Property
	
	Public Property Let Size(ByVal n)
		i_pSize = n
	End Property

	Public Property Let Page(ByVal n)
		If Not IsNumeric(n) Then n = 1
		If n <= 0 Then n = 1
		i_pNumber = CLng(n)
	End Property
	
	'**********��ȡ����**************************
	'Size : ÿҳ��ʾ
	'Page : ��ǰҳ��
	'PageCount : ���ҳ��
	'RecordCount : �����¼����
	'**********
	Public Property Get Size()
		Size = i_pSize
	End Property
	
	Public Property Get Page()
		Page = i_pNumber
	End Property
	
	Public Property Get PageCount()
		PageCount = i_pCount
	End Property
	
	Public Property Get RecordCount()
		RecordCount = i_rCount
	End Property

	'**********��ҳģ��Top��1��******************
	'Call Header_a(Obj,SQL���)
	'**********
	Sub Header_a(OutRs,sql)
		Set OutRs = Server.CreateObject("ADODB.Recordset")
		OutRs.open sql,i_conn,1,1
		If Not OutRs.eof Then
			i_rCount = OutRs.RecordCount
			i_pCount = Abs(Int(-(i_rCount / i_pSize)))
			If i_pNumber > i_pCount Then i_pNumber = i_pCount
			OutRs.Move i_pSize * (Abs(i_pNumber) - 1)
		End If
	End Sub
	
	'**********��ҳģ��Top��2��******************
	'Call Header_b(Obj,���ݱ���,����,��ѯ�ֶ�,��ѯ����,����)
	'**********
	Sub Header_b(OutRs,sTable,sPK,sFields,sWhere,sSort)
		Dim Cmd, sql,StrOrder, bFlag
		bFlag = i_conn.Execute("select count(0) from sysobjects where id = object_id(N'["&PageProcedure&"]') and OBJECTPROPERTY(id, N'IsProcedure') = 1")(0)
		Set Cmd = Server.CreateObject("ADODB.Command")
		On Error Resume Next
		With Cmd
			.ActiveConnection = i_conn
			.CommandType = 4
			If bFlag > 0 Then
				.CommandText = PageProcedure
			Else
				Dim sqlParams, sqlCmd 
				sqlParams = "@Tables varchar(1000)," & vbCr & "@PK varchar(100)," & vbCr & "@Sort varchar(200) = NULL," & vbCr & "@PageNumber int = 1," & vbCr & "@PageSize int = 10," & vbCr & "@Fields varchar(1000) = '**********'," & vbCr & "@Filter varchar(1000) = NULL" & vbCr
				sqlCmd = "IF @Sort IS NULL OR @Sort = ''" & vbCr & "SET @Sort = @PK" & vbCr & "DECLARE @SortTable varchar(100),@SortName varchar(100),@strSortColumn varchar(200),@operator char(2),@type varchar(100),@prec int" & vbCr & "IF CHARINDEX('DESC',@Sort)>0" & vbCr & "BEGIN" & vbCr & "SET @strSortColumn = REPLACE(@Sort, 'DESC', '')" & vbCr & "SET @operator = '<='" & vbCr & "END" & vbCr & "ELSE" & vbCr & "BEGIN" & vbCr & "IF CHARINDEX('ASC', @Sort) = 0" & vbCr & "SET @strSortColumn = REPLACE(@Sort, 'ASC', '')" & vbCr & "SET @operator = '>='" & vbCr & "END" & vbCr & "IF CHARINDEX('.', @strSortColumn) > 0" & vbCr & "BEGIN" & vbCr & "SET @SortTable = SUBSTRING(@strSortColumn, 0, CHARINDEX('.',@strSortColumn))" & vbCr & "SET @SortName = SUBSTRING(@strSortColumn, CHARINDEX('.',@strSortColumn) + 1, LEN(@strSortColumn))" & vbCr & "END" & vbCr & "ELSE" & vbCr & "BEGIN" & vbCr & "SET @SortTable = @Tables" & vbCr & "SET @SortName = @strSortColumn" & vbCr & "END" & vbCr & "SELECT @type=t.name, @prec=c.prec FROM sysobjects o JOIN syscolumns c on o.id=c.id JOIN systypes t on c.xusertype=t.xusertype WHERE o.name = @SortTable AND c.name = @SortName" & vbCr & "IF CHARINDEX('char', @type) > 0" & vbCr & "SET @type = @type + '(' + CAST(@prec AS varchar) + ')'" & vbCr & "DECLARE @strPageSize varchar(50),@strStartRow varchar(50),@strFilter varchar(1000),@strSimpleFilter varchar(1000),@strGroup varchar(1000)" & vbCr & "IF @PageNumber < 1" & vbCr & "SET @PageNumber = 1" & vbCr & "SET @strPageSize = CAST(@PageSize AS varchar(50))" & vbCr & "SET @strStartRow = CAST(((@PageNumber - 1)*@PageSize + 1) AS varchar(50))" & vbCr & "IF @Filter IS NOT NULL AND @Filter != ''" & vbCr & "BEGIN" & vbCr & "SET @strFilter = ' WHERE ' + @Filter + ' '" & vbCr & "SET @strSimpleFilter = ' AND ' + @Filter + ' '" & vbCr & "END" & vbCr & "ELSE" & vbCr & "BEGIN" & vbCr & "SET @strSimpleFilter = ''" & vbCr & "SET @strFilter = ''" & vbCr & "END" & vbCr & "EXEC ('" & vbCr & "DECLARE @PageCount Int,@Count int" & vbCr & "SELECT @Count=Count(*) FROM ' + @Tables + @strFilter  + '" & vbCr & "Set @PageCount = ABS(CEILING(@Count/' + @strPageSize + '.))" & vbCr & "Select @PageCount As PageCount,@Count as RecordCount" & vbCr & "')" & vbCr & "EXEC('" & vbCr & "DECLARE @SortColumn ' + @type + '" & vbCr & "SET ROWCOUNT ' + @strStartRow + '" & vbCr & "SELECT @SortColumn=' + @strSortColumn + ' FROM ' + @Tables + @strFilter + ' ORDER BY ' + @Sort + '" & vbCr & "SET ROWCOUNT ' + @strPageSize + '" & vbCr & "SELECT ' + @Fields + ' FROM ' + @Tables + ' WHERE ' + @strSortColumn + @operator + ' @SortColumn ' + @strSimpleFilter + ' ORDER BY ' + @Sort + '" & vbCr & "')" & vbCr
				.CommandText = "sp_executesql"
				.Parameters.Append .CreateParameter("@stmt",203,,8000,sqlCmd)
				.Parameters.Append .CreateParameter("@parameters",203,,8000,sqlParams)
			End If
			.Parameters.Append .CreateParameter ("@Table",200,,1000,sTable)
			.Parameters.Append .CreateParameter ("@PK",200,,100,sPK)
			.Parameters.Append .CreateParameter ("@Sort",200,,200,sSort)
			.Parameters.Append .CreateParameter ("@PageNumber",3,,,i_pNumber)
			.Parameters.Append .CreateParameter ("@PageSize",2,,,i_pSize)
			.Parameters.Append .CreateParameter ("@Fields",200,,1000,sFields)
			.Parameters.Append .CreateParameter ("@Filter",200,,1000,sWhere)
			Set OutRs = .Execute
		End With
		Set Cmd = Nothing
		i_pCount = OutRs("PageCount")
		i_rCount = OutRs("RecordCount")
		Set OutRs = OutRs.NextRecordset
		If i_rCount = 0 Then
			If sWhere = "" Or IsNull(sWhere) Then
				i_rCount = i_conn.Execute("SELECT COUNT(0) FROM "&sTable)(0)
			Else
				i_rCount = i_conn.Execute("SELECT COUNT(0) FROM "&sTable&" WHERE "&sWhere)(0)
			End If
		End If
		If i_pNumber > i_pCount Then i_pNumber = i_pCount
		On Error Goto 0
	End Sub

	'**********��ҳģ��End��1��******************
	'Footer_a(��������,��������)
	'**********
	Function Footer_a(str,p_Type)
		If i_pCount = 1 Then Exit Function
		Response.Write "<span class=""pageIntroA"">"
		If i_rCount<>"" Then 
			Response.Write "����:<kbd class=""p_total"">"&i_rCount&"</kbd> "&vbCrlf
		End If
		Response.Write "ÿҳ:<kbd class=""p_size"">"&i_pSize&"</kbd> "&vbCrlf
		Response.Write "</span>"
		Response.Write "<span class=""pageContorlA"">"
		If i_pNumber<=1 Then
			Response.Write  "<a href=""#;"" class=""p_disabled"" disabled title=""�Ѿ��ǵ�һҳ��"">��ҳ</a> <a href=""#;"" class=""p_disabled"" disabled>��һҳ</a> "
		Else
			Response.Write "<a href="""&CurrentPath&"?PageID=1"&str&""" class=""p_start"" title=""��һҳ"">��ҳ</a> <a href="""&CurrentPath&"?PageID="&i_pNumber-1&""&str&""" class=""p_pre"">��һҳ</a> "
		End If
		If i_pCount="" Then
			Response.Write "<a href="""&CurrentPath&"?PageID="&i_pNumber+1&""&str&""" class=""p_next"">��һҳ</a>  <a href="""&CurrentPath&"?PageID=999999999"&str&""" class=""p_end"">βҳ</a> "
		Else
			If i_pNumber>=i_pCount Then
				Response.Write "<a href=""#;"" class=""p_disabled"" disabled>��һҳ</a> <a href=""#;"" class=""p_disabled"" disabled title=""�Ѿ������һҳ��"">βҳ</a>"
			Else
				Response.Write "<a href="""&CurrentPath&"?PageID="&i_pNumber+1&""&str&""" class=""p_next"">��һҳ</a> <a href="""&CurrentPath&"?PageID="&i_pCount&""&str&""" class=""p_end"" title=""���һҳ"">βҳ</a>"
			End If
		End If
		Call CommonFooterContorl(str,p_Type)
		Response.Write "</span>"
	End Function
	
	
	'**********��ҳģ��End��2��******************
	'Footer_b(��������,��������)
	'**********
	Function Footer_b(str,p_Type)
		Dim i, m
		m = 9
		If i_pCount = 1 Then Exit Function
		Response.Write "<span class=""pageIntroB"">"
		If i_rCount <> "" Then
			Response.Write "����:<kbd class=""p_total"">"&i_rCount&"</kbd>"
		End If
		Response.Write " ÿҳ:<kbd class=""p_size"">"&i_pSize&"</kbd>"
		Response.Write "</span>"
		Response.Write "<span class=""pageContorlB"">"
		If i_pNumber = 1 Then 
			Response.Write " <a href=""#;"" class=""p_disabled"" disabled title=""�Ѿ��ǵ�һҳ��"">��һҳ</a>"
		Else
			Response.Write " <a href="""&CurrentPath&"?PageID="&i_pNumber-1&""&str&""" class=""p_pre"">��һҳ</a> "
		End If
		If i_pNumber > m - 4 Then 
			Response.Write " <a href="""&CurrentPath&"?PageID=1"&str&""" class=""p_start"" title=""��һҳ"">1</a> "
			If i_pNumber > m - 3 Then Response.Write " ... "
		End If
		For i = i_pNumber - m + 5 to i_pNumber + m - 1
			If i > 0 and i <= i_pCount Then 
				If i = i_pNumber Then
					Response.Write " <strong class=""p_cur"">"&i&"</strong> "
				Else
					Response.Write " <a href="""&CurrentPath&"?PageID="&i&""&str&""" class=""p_page"">"&i&"</a> "
				End If
			End If
			If i_pNumber < m - 3 And i > m - 1 Then Exit For
			If i_pNumber > m - 5 And i >= i_pNumber + m - 5 Then Exit For
		Next
		If i_pNumber < i_pCount - m + 5 Then
			If i_pNumber < i_pCount - m + 4 Then Response.Write " ... "
			Response.Write " <a href="""&CurrentPath&"?PageID="&i_pCount&""&str&""" class=""p_end"" title=""���һҳ"">"&i_pCount&"</a> "
		End If
		If i_pNumber = i_pCount Then 
			Response.Write " <a href=""#;"" class=""p_disabled"" disabled title=""�Ѿ������һҳ��"">��һҳ</a> "
		Else
			Response.Write " <a href="""&CurrentPath&"?PageID="&i_pNumber+1&""&str&""" class=""p_next"">��һҳ</a> "
		End If
		Call CommonFooterContorl(str,p_Type)
		Response.Write "</span>"
	End Function

	'**********
	'CommonFooterContorl(��������,��������)
	'**********
	Private Sub CommonFooterContorl(str,p_Type)
		Select Case p_Type
		Case "select"
			Response.Write "&nbsp;��ת��:<select name=""PageID"" onChange=""location.href='"&CurrentPath&"?PageID='+this.options[this.selectedIndex].value+'"&str&"'"" class=""p_select"">"&vbCrlf
			Dim i
			For i=1 to i_pCount
				Response.Write "<option value="""&i&""""
				If i=i_pNumber Then Response.Write " selected"
				Response.Write ">��"&i&"ҳ</option>"&vbCrlf
			Next
			Response.Write "</select>"&vbCrlf
		Case Else
			Randomize
			Dim PageID : PageID = "PageID" & Int(Rnd() * 10000000)
			Response.Write " ��ת��:<input type=""text"" id="""&PageID&""" name=""PageID"" onkeydown=""if(event.keyCode==13) document.getElementById('btn_"&PageID&"').click();"" size=""3"" value="""&i_pNumber&""" onclick=""this.select()"" maxlength=8 class=""p_text""> "&vbCrlf & _
							 "<input type=""button"" value=""GO"" onclick=""location.href='"&CurrentPath&"?PageID='+document.getElementById('"&PageID&"').value+'"&str&"'"" align=""absmiddle"" id=""btn_"&PageID&""" class=""p_btn""></form>"
		End Select
	End Sub
End Class
%>
