<%
'**********
'	class		: A Simple Encode
'	File Name	: BasicEncode.asp
'	Version		: 0.1.0
'	Author		: TerranC
'	Date		: 2008-4-3
'**********
'**********
'	ʾ��
'**********


Class Class_BasicEncode
	Private arr_en, arr_de

	Public Property Let Key(num)
		Dim item, i, tmp
		Call reset()
		For i = 0 to 50
			tmp = arr_en(arr_en(arr_en(num)))
			item = arr_en(num)
			arr_en(num) = arr_en(tmp)
			arr_en(tmp) = item
			arr_de(arr_en(num)) = num
			arr_de(item) = tmp
			num = arr_en(num)
		Next
	End Property

	Private Sub reset()
		arr_en = Array(123,38,211,162,29,250,98,206,200,130,181,118,54,198,190,67,212,195,124,27,154,52,253,26,82,224,35,156,140,137,159,173,161,219,88,69,97,149,49,245,48,77,9,235,216,28,65,132,32,60,78,239,89,134,228,57,210,21,1,46,114,222,208,191,166,83,249,176,79,56,31,255,175,237,152,30,44,85,111,37,145,185,61,39,10,121,183,194,81,143,215,133,63,230,164,116,68,7,138,15,42,72,139,158,23,135,128,107,20,157,207,171,252,106,117,148,6,125,4,101,127,213,199,76,147,174,150,2,241,93,13,84,205,180,177,240,160,142,110,70,126,62,66,112,5,80,91,186,40,168,74,55,103,201,169,92,11,53,115,170,244,105,188,248,141,8,187,167,136,223,221,102,64,196,33,251,14,43,75,182,204,100,226,232,59,144,214,192,94,218,129,86,73,34,179,99,36,120,163,184,146,109,178,217,87,95,18,172,45,209,243,104,193,0,236,71,202,225,90,197,24,165,113,47,233,122,108,153,19,220,50,155,151,246,96,51,227,238,22,189,119,41,3,203,17,25,231,16,131,58,12,247,229,234,242,254)
		arr_de = Array(213,58,127,242,118,144,116,97,165,42,84,156,250,130,176,99,247,244,206,228,108,57,238,104,220,245,23,19,45,4,75,70,48,174,193,26,196,79,1,83,148,241,100,177,76,208,59,223,40,38,230,235,21,157,12,151,69,55,249,184,49,82,141,92,172,46,142,15,96,35,139,215,101,192,150,178,123,41,50,68,145,88,24,65,131,77,191,204,34,52,218,146,155,129,188,205,234,36,6,195,181,119,171,152,211,161,113,107,226,201,138,78,143,222,60,158,95,114,11,240,197,85,225,0,18,117,140,120,106,190,9,248,47,91,53,105,168,29,98,102,28,164,137,89,185,80,200,124,115,37,126,232,74,227,20,231,27,109,103,30,136,32,3,198,94,221,64,167,149,154,159,111,207,31,125,72,67,134,202,194,133,10,179,86,199,81,147,166,162,239,14,63,187,212,87,17,173,219,13,122,8,153,216,243,180,132,7,110,62,209,56,2,16,121,186,90,44,203,189,33,229,170,61,169,25,217,182,236,54,252,93,246,183,224,253,43,214,73,237,51,135,128,254,210,160,39,233,251,163,66,5,175,112,22,255,71)
	End Sub

	Private Sub Class_Initialize()
		Call reset()
	End Sub

	Public Function Encode(ecodestr)
		Dim i, str
		For i = 1 to Len(ecodestr)
			str = str & Right("0"&CStr(Hex(arr_en(Asc(Mid(ecodestr,i,2))))),2)
		Next
		Encode = str
	End Function

	Public Function Decode(ecodestr)
		Dim i, str
		For i = 1 to Len(ecodestr)
			if (i + 1) mod 2 = 0 Then
				str = str & Chr(arr_de(Clng("&H"&Mid(ecodestr, i, 2))))
			End If
		Next
		Decode = str
	End Function
End Class
%>