<%
'**********
'	class		: Array extensive class
'	File Name	: Array.asp
'	Version		: 0.2.0
'	Updater		: TerranC
'	Date		: 2008-4-20
'**********


'**********
'	ʾ��
'**********

'**********
'	������
'**********
Class Class_Array

	'**********
	' ������: Max
	' ��  ��: arr as a Array
	' ��  ��: Max �� ȡ�����ֵ
	'**********
	Function Max(ByVal arr)
		Dim tmp
		tmp = Me.rSort(arr)
		Max = tmp(0)
	End Function
	
	'**********
	' ������: Min
	' ��  ��: arr as a Array
	' ��  ��: Min �� ȡ����Сֵ
	'**********
	Function Min(ByVal arr)
		Dim tmp
		tmp = Me.Sort(arr)
		Min = tmp(0)
	End Function
	
	'**********
	' ������: UnShift
	' ��  ��: arr as an Array
	' ��  ��: UnShift �� ��ǰѹ��Ԫ��
	'**********
	Function UnShift(ByVal arr, ByVal var)
		Dim i, tmp
		tmp = Me.ToString(arr)
		tmp = var & "," & tmp
		tmp = Me.ToArray(tmp)
		UnShift = tmp
	End Function
	
	'**********
	' ������: Shift
	' ��  ��: arr as an Array
	' ��  ��: Shift �� ��ǰɾ��Ԫ��
	'**********
	Function Shift(ByVal arr)
		Dim i, tmp
		tmp = ""
		For i = 0 To UBound(arr)
			If i<>0 Then tmp = tmp & arr(i) & ","
		Next
		tmp = Me.Strip(tmp)
		Shift = tmp
	End Function
	
	'**********
	' ������: Push
	' ��  ��: arr as an Array
	' ��  ��: var as a variable added to an array
	' ��  ��: Push �� �Ӻ�ѹ��Ԫ��
	'**********
	Function Push(ByVal arr, ByVal var)
		Dim tmp : tmp = Me.ToString(arr)
		tmp = tmp & "," & Me.ConvComma(var)
		tmp = Me.ToArray(tmp)
		Push = tmp
	End Function
	
	'**********
	' ������: Pop
	' ��  ��: arr as an array
	' ��  ��: Pop �� �Ӻ�ɾ��Ԫ��
	'**********
	Function Pop(ByVal arr)
		Dim i, tmp
		For i = 0 To UBound(arr)
			If i<>UBound(arr) Then tmp = tmp & arr(i) & ","
		Next
		tmp = Me.Strip(tmp)
		Pop = tmp
	End Function
	
	'**********
	' ������: Strip
	' ��  ��: str as a string such as "1,2,3,"
	' ��  ��: Strip "," of string
	'**********
	Function Strip(ByVal Str)
		If IsArray(Str) Then Str = Me.ToString(Str)
		If Left(Str, 1) = "," Then Str = Right(Str, Len(Str) -1)
		If Right(Str, 1) = "," Then Str = Left(Str, Len(Str) -1)
		Str = Me.ToArray(Str)
		Strip = Str
	End Function
	
	'**********
	' ������: Walk
	' ��  ��: arr as an Array
	' ��  ��: callback as callback function
	' ��  ��: Walk �� ��������Ԫ��ִ�к����󷵻�������
	'**********
	Function Walk(ByVal arr, ByVal callback)
		Dim e : e = ""
		Dim tmp : tmp = ""
		For Each e in arr
			If IsArray(e) Then
				Execute("tmp=tmp&" & callback & "(""" & Me.ToString(e) & """)" & "&"",""")
			Else
				Execute("tmp=tmp&" & callback & "(""" & e & """)" & "&"",""")
			End If
		Next
		tmp = Me.Strip(tmp)
		Walk = tmp
	End Function
	
	'**********
	' ������: Splice
	' ��  ��: arr as an array
	' ��  ��: start as start index
	' ��  ��: final as end index
	' ��  ��: Splice �� ��һ���������Ƴ�һ������Ԫ��
	'**********
	Function Splice(ByVal arr, ByVal start, ByVal final)
		Dim i, temp, tmp
		If start > final Then
			temp = start
			start = final
			final = temp
		End If
		For i = 0 To UBound(arr)
			If i < start Or i > final Then tmp = tmp & arr(i) & ","
		Next
		tmp = Me.Strip(tmp)
		Splice = tmp
	End Function
	
	'**********
	' ������: Fill
	' ��  ��: arr as a Array
	' ��  ��: index as index to insert into an array
	' ��  ��: value as element to insert into an array
	' ��  ��: Fill �� ����Ԫ��
	'**********
	Function Fill(ByVal arr, ByVal index, ByVal Value)
		Dim i, tmp
		For i = 0 To UBound(arr)
			If i <> index Then
				tmp = tmp & arr(i) & ","
			Else
				tmp = tmp & Value & "," & arr(i) & ","
			End If
		Next
		tmp = Me.Strip(tmp)
		Fill = tmp
	End Function
	
	'**********
	' ������: Unique
	' ��  ��: arr as a Array
	' ��  ��: Unique �� �Ƴ��ظ���Ԫ��
	'**********
	Function Unique(ByVal arr)
		Dim tmp, e
		For Each e in arr
			If InStr(1, tmp, e) = 0 Then
				tmp = tmp & e & ","
			End If
		Next
		tmp = Me.Strip(tmp)
		Unique = tmp
	End Function

	'**********
	' ������: Reverse
	' ��  ��: arr as a Array
	' ��  ��: Reverse �� ����
	'**********
	Function Reverse(ByVal arr)
		Dim tmp, e
		For Each e in arr
			tmp = tmp & e & ","
		Next
		tmp = StrReverse(tmp)
		tmp = Me.Strip(tmp)
		Reverse = tmp
	End Function
	
	'**********
	' ������: Search
	' ��  ��: arr as a Array
	' ��  ��: value as Searching value
	' ��  ��: Search �� ��ѯԪ�أ��������򷵻�False
	'**********
	Function Search(ByVal arr, ByVal Value)
		Dim i
		For i = 0 To UBound(arr)
			If arr(i) = Value Then
				Search = i
				Exit Function
			End If
		Next
		Search = -1
	End Function
	
	'**********
	' ������: Rand
	' ��  ��: arr as a Array
	' ��  ��: num as specifies how many entries you want to pick
	' ��  ��: Rand �� ����
	'**********
	Function Rand(ByVal arr, ByVal num)
		Dim tmpi, tmp, i
		For i = 0 To num -1
			Randomize
			tmpi = Int((UBound(arr) + 1) * Rnd)
			tmp = tmp & arr(tmpi) & ","
		Next
		tmp = Me.Strip(tmp)
		Rand = tmp
	End Function
	
	'**********
	' ������: Sort
	' ��  ��: arr as a Array
	' ��  ��: Sort �� ˳��
	'**********
	Function Sort(ByVal arr)
		Dim tmp, i, j
		ReDim tmpA(UBound(arr))
		For i = 0 To UBound(tmpA)
			tmpA(i) = CDbl(arr(i))
		Next
		For i = 0 To UBound(tmpA)
			For j = i + 1 To UBound(tmpA)
				If tmpA(i) > tmpA(j) Then
					tmp = tmpA(i)
					tmpA(i) = tmpA(j)
					tmpA(j) = tmp
				End If
			Next
		Next
		Sort = tmpA
	End Function
	
	'**********
	' ������: rSort
	' ��  ��: arr as a Array
	' ��  ��: rSort �� ����
	'**********
	Function rSort(ByVal arr)
		Dim tmp, i, j
		ReDim tmpA(UBound(arr))
		For i = 0 To UBound(tmpA)
			tmpA(i) = CDbl(arr(i))
		Next
		For i = 0 To UBound(tmpA)
			For j = i + 1 To UBound(tmpA)
				If tmpA(i) < tmpA(j) Then
					tmp = tmpA(i)
					tmpA(i) = tmpA(j)
					tmpA(j) = tmp
				End If
			Next
		Next
		rSort = tmpA
	End Function

	'**********
	' ������: Shuffle
	' ��  ��: arr as a Array
	' ��  ��: Shuffle �� �������
	'**********
	Function Shuffle(ByVal arr)
		Dim m, n, i
		'i = Search(arr,Rand(arr,1))
		'arr = Splice(arr,i,i+1)
		Randomize   
		For i = 0 to UBound(arr)
			m = Int(Rnd()*i)
			n = arr(m)
			arr(m) = arr(i) 
			arr(i) = n
		Next
		Shuffle = arr
	End Function

	'**********
	' ������: ConvComma
	' ��  ��: star as a string
	'**********
	Function ConvComma(ByVal str)
		ConvComma = Replace(str,",","&#44;")
	End Function

	'**********
	' ������: implode
	' ��  ��: glue as a split character
	' ��  ��: arr as a output array
	' ��  ��: Join array elements with a string
	'**********
	Function ToString(ByVal arr)
		If IsArray(arr) Then
			Dim tmp
			tmp = Join(arr, ",")
			ToString = tmp
		Else
			ToString = arr
		End If
	End Function

	'**********
	' ������: ToArray
	' ��  ��: str as a string converted to an array
	' ��  ��: Convert to an array
	' Remarks: dim a : a = "a, b, c"
	'		   prinr(ToArray(a))
	'**********
	Function ToArray(ByVal str)
		Dim tmp
		tmp = Split(str, ",")
		ToArray = tmp
	End Function

End Class

%>