<%
'**********
'	class		: provide a simple way to parse JSON
'	File Name	: json.asp
'	Version		: 0.1.0
'	Updater		: TerranC
'	Date		: 2008-5-21
'**********

Class JSONClass
	' ���������ԣ�Ĭ��ΪPrivate
	Private SqlString ' ��������Select
	Private JSON ' ���ص�JSON���������
	Private DBConnection ' ���ӵ����ݿ��Connection����

	' �����ⲿ���õĹ�������

	Public Function GetJSON()
		Dim Rs
		Dim returnStr
		Dim i
		Dim oneRecord

		' ��ȡ����
		Set Rs = Server.CreateObject("ADODB.Recordset")
		Rs.Open SqlString, DBConnection, 1, 1
		' ����JSON�ַ���
		If Rs.EOF = false And Rs.Bof = false Then
			returnStr = "{ "& JSON & ":{ records:["
			While Rs.EOF = false
				' -------
				oneRecord = "{"
				For i = 0 To Rs.Fields.Count -1
					oneRecord = oneRecord & Chr(34) &Rs.Fields(i).Name&Chr(34)&":"
					oneRecord = oneRecord & Chr(34) &Rs.Fields(i).Value&Chr(34) &","
				Next
				'ȥ����¼���һ���ֶκ��","
				oneRecord = Left(oneRecord, InStrRev(oneRecord, ",") -1)
				oneRecord = oneRecord & "},"
				'------------
				returnStr = returnStr & oneRecord
				Rs.MoveNext
			Wend
			' ȥ�����м�¼������","
			returnStr = Left(returnStr, InStrRev(returnStr, ",") -1)
			returnStr = returnStr & "]}}"
		End If
		Rs.Close
		Set Rs = Nothing
		GetJSON = returnStr
	End Function
End Class
%>