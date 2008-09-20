<%
'**********
'	class		: TdbToExcel
'	File Name	: TdbToExcel.asp
'	Version		: 0.1.0
'	Author		: TerranC
'	Date		: 2008-5-17
'**********


'**********
'	示例
'**********

'********** 

'**********
'	构建类
'**********

Class Class_DbToExcel
	Private s_table, s_fields, s_fieldnames
	Public FileName		'设置生成的文件名
	Public Conn			'设置数据库链接
	
	Private Sub Class_Initialize()
		FileName = "excel"
	End Sub
	
	Public Default Property Get Contents(sTable,sFields,sWhere,sOrders,sAnother)
		Dim rs,aAnother,i
		Response.Buffer = True 
		Response.ContentType = "application/vnd.ms-excel" 
		Response.AddHeader "content-disposition", "inline; filename = "&FileName&".xls"
		Response.Write "<meta http-equiv=""Content-Type"" content=""text/html;   charset=gb2312"">"
		Response.Write "<table border=""1"">"
		If Trim(sWhere) <> "" Then sWhere = "where " & sWhere
		If Trim(sOrders) <> "" Then sOrders = "order by " & sOrders
		Set rs = Conn.Execute("select "&sFields&" from "&sTable&" "&sWhere&" "&sOrders&"")
		Response.Write("<tr>")
		If sAnother = "" Then
			For i=0 To rs.fields.count-1
				Response.Write "<td>"&RS.Fields(i).Name&"</td>"
			Next
		Else
			If Ubound(Split(sFields,",")) <> Ubound(Split(sAnother,"|")) Then Err.Raise 1, "Class_DbToExcel", "Fields Another fails"
			aAnother = Split(sAnother,"|")
			For i=0 To uBound(aAnother)
				Response.Write "<td>"&aAnother(i)&"</td>"
			Next
		End If
		Response.Write("</tr>")
		Do While Not rs.eof
			Response.Write "<tr>"
			for i=0 to rs.fields.count-1  
				Response.Write "<td>"&rs(i)&"</td>"
			Next
			Response.Write "</tr>"
			rs.MoveNext
		Loop
		rs.close : Set rs = Nothing
		Response.Write "</table>"
	End Property
End Class
%> 
