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
	' ������: max
	' ��  ��: arr as a Array
	' ��  ��: max �� ȡ�����ֵ
	'**********
	Function max(arr)
		Dim tmp
		tmp = rsort(arr)
		max = tmp(0)
	End Function
	
	'**********
	' ������: min
	' ��  ��: arr as a Array
	' ��  ��: min �� ȡ����Сֵ
	'**********
	Function min(arr)
		Dim tmp
		tmp = sort(arr)
		min = tmp(0)
	End Function
	
	'**********
	' ������: unshift
	' ��  ��: arr as an Array
	' ��  ��: unshift �� ��ǰѹ��Ԫ��
	'**********
	Function unshift(arr, var)
		Dim i, tmp
		tmp = toString(arr)
		tmp = var & "," & tmp
		tmp = toArray(tmp)
		unshift = tmp
	End Function
	
	'**********
	' ������: shift
	' ��  ��: arr as an Array
	' ��  ��: shift �� ��ǰɾ��Ԫ��
	'**********
	Function shift(arr)
		Dim i, tmp
		tmp = ""
		For i = 0 To UBound(arr)
			If i<>0 Then tmp = tmp & arr(i) & ","
		Next
		tmp = strip(tmp)
		shift = tmp
	End Function
	
	'**********
	' ������: push
	' ��  ��: arr as an Array
	' ��  ��: var as a variable added to an array
	' ��  ��: push �� �Ӻ�ѹ��Ԫ��
	'**********
	Function push(arr, var)
		Dim tmp : tmp = toString(arr)
		tmp = tmp & "," & convComma(var)
		tmp = toArray(tmp)
		push = tmp
	End Function
	
	'**********
	' ������: pop
	' ��  ��: arr as an array
	' ��  ��: pop �� �Ӻ�ɾ��Ԫ��
	'**********
	Function pop(arr)
		Dim i, tmp
		For i = 0 To UBound(arr)
			If i<>UBound(arr) Then tmp = tmp & arr(i) & ","
		Next
		tmp = strip(tmp)
		pop = tmp
	End Function
	
	'**********
	' ������: strip
	' ��  ��: str as a string such as "1,2,3,"
	' ��  ��: Strip "," of string
	'**********
	Function strip(Str)
		If IsArray(Str) Then Str = toString(Str)
		If Left(Str, 1) = "," Then Str = Right(Str, Len(Str) -1)
		If Right(Str, 1) = "," Then Str = Left(Str, Len(Str) -1)
		Str = toArray(Str)
		strip = Str
	End Function
	
	'**********
	' ������: walk
	' ��  ��: arr as an Array
	' ��  ��: callback as callback function
	' ��  ��: walk �� ��������Ԫ��ִ�к����󷵻�������
	'**********
	Function walk(arr, callback)
		Dim e : e = ""
		Dim tmp : tmp = ""
		For Each e in arr
			If IsArray(e) Then
				Execute("tmp=tmp&" & callback & "(""" & toString(e) & """)" & "&"",""")
			Else
				Execute("tmp=tmp&" & callback & "(""" & e & """)" & "&"",""")
			End If
		Next
		tmp = strip(tmp)
		walk = tmp
	End Function
	
	'**********
	' ������: splice
	' ��  ��: arr as an array
	' ��  ��: start as start index
	' ��  ��: final as end index
	' ��  ��: splice �� ��һ���������Ƴ�һ������Ԫ��
	'**********
	Function splice(arr, start, final)
		Dim i, temp, tmp
		If start > final Then
			temp = start
			start = final
			final = temp
		End If
		For i = 0 To UBound(arr)
			If i < start Or i > final Then tmp = tmp & arr(i) & ","
		Next
		tmp = strip(tmp)
		splice = tmp
	End Function
	
	'**********
	' ������: fill
	' ��  ��: arr as a Array
	' ��  ��: index as index to insert into an array
	' ��  ��: value as element to insert into an array
	' ��  ��: fill �� ����Ԫ��
	'**********
	Function fill(arr, index, Value)
		Dim i, tmp
		For i = 0 To UBound(arr)
			If i <> index Then
				tmp = tmp & arr(i) & ","
			Else
				tmp = tmp & Value & "," & arr(i) & ","
			End If
		Next
		tmp = strip(tmp)
		fill = tmp
	End Function
	
	'**********
	' ������: unique
	' ��  ��: arr as a Array
	' ��  ��: unique �� �Ƴ��ظ���Ԫ��
	'**********
	Function unique(arr)
		Dim tmp, e
		For Each e in arr
			If InStr(1, tmp, e) = 0 Then
				tmp = tmp & e & ","
			End If
		Next
		tmp = strip(tmp)
		unique = tmp
	End Function

	'**********
	' ������: reverse
	' ��  ��: arr as a Array
	' ��  ��: reverse �� ����
	'**********
	Function reverse(arr)
		Dim tmp, e
		For Each e in arr
			tmp = tmp & e & ","
		Next
		tmp = StrReverse(tmp)
		tmp = strip(tmp)
		reverse = tmp
	End Function
	
	'**********
	' ������: search
	' ��  ��: arr as a Array
	' ��  ��: value as searching value
	' ��  ��: search �� ��ѯԪ�أ��������򷵻�False
	'**********
	Function search(arr, Value)
		Dim a_tmp
		a_tmp = Filter(arr,Value)
		If UBound(a_tmp) = -1 Then
			search = False
			Exit Function
		End If
		search = a_tmp(0)
	End Function
	
	'**********
	' ������: rand
	' ��  ��: arr as a Array
	' ��  ��: num as specifies how many entries you want to pick
	' ��  ��: rand �� ����
	'**********
	Function rand(arr, num)
		Dim tmpi, tmp, i
		For i = 0 To num -1
			Randomize
			tmpi = Int((UBound(arr) + 1) * Rnd)
			tmp = tmp & arr(tmpi) & ","
		Next
		tmp = strip(tmp)
		rand = tmp
	End Function
	
	'**********
	' ������: sort
	' ��  ��: arr as a Array
	' ��  ��: sort �� ˳��
	'**********
	Function sort(arr)
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
		sort = tmpA
	End Function
	
	'**********
	' ������: rsort
	' ��  ��: arr as a Array
	' ��  ��: rsort �� ����
	'**********
	Function rsort(arr)
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
		rsort = tmpA
	End Function

	'**********
	' ������: shuffle
	' ��  ��: arr as a Array
	' ��  ��: shuffle �� �������
	'**********
	Function shuffle(arr)
		Dim m, n, i
		'i = search(arr,rand(arr,1))
		'arr = splice(arr,i,i+1)
		Randomize   
		For i = 0 to UBound(arr)
			m = Int(Rnd()*i)
			n = arr(m)
			arr(m) = arr(i) 
			arr(i) = n
		Next
		shuffle = arr
	End Function

	'**********
	' ������: convComma
	' ��  ��: star as a string
	'**********
	Function convComma(str)
		convComma = Replace(str,",","&#44;")
	End Function

	'**********
	' ������: implode
	' ��  ��: glue as a split character
	' ��  ��: arr as a output array
	' ��  ��: Join array elements with a string
	'**********
	Function toString(arr)
		If IsArray(arr) Then
			Dim tmp
			tmp = Join(arr, ",")
			toString = tmp
		Else
			toString = arr
		End If
	End Function

	'**********
	' ������: toArray
	' ��  ��: str as a string converted to an array
	' ��  ��: Convert to an array
	' Remarks: dim a : a = "a, b, c"
	'		   prinr(toArray(a))
	'**********
	Function toArray(str)
		Dim tmp
		tmp = Split(str, ",")
		toArray = tmp
	End Function

End Class

%>