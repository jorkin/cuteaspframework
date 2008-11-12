<%
'**********
'	class		: A Date class
'	File Name	: Date.asp
'	Version		: 0.2.0
'	Updater		: TerranC
'	Date		: 2008-4-2
'**********


'**********
'	ʾ��
'**********

'********** 

'**********
'	������
'**********
Class Class_Date
	Public TimeZone
	
    '**********
    ' ������: class_Initialize
    ' ��  ��: Save the session
    '**********
	Private Sub class_initialize()
		TimeZone = 8
    End Sub

    '**********
    ' ������: class_Terminate
    ' ��  ��: Deconstrutor
    '**********
	Private Sub class_Terminate()
    End Sub

	Private Function getMistiming(sDate)
		getMistiming = DateDiff("s","1970-1-1 00:00:00",DateAdd("h",Me.TimeZone,sDate))
	End Function

    '**********
    ' ������: toGMTdate
    ' ��  ��: sDate
    ' ��  ��: ��ȡGMTʱ��
    '**********
	Function toGMTdate(sDate)
	  Dim dWeek,dMonth
	  Dim strZero,strZone
	  strZero="00"
	  If Me.TimeZone > 0 Then
	  	strZone = "+"&Right("0"&Me.TimeZone,2)&"00"
	  Else
	  	strZone = "-"&Right("0"&Me.TimeZone,2)&"00"
	  End If
	  dWeek=Array("Sun","Mon","Tue","Wes","Thu","Fri","Sat")
	  dMonth=Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
	  toGMTdate = dWeek(WeekDay(sDate)-1)&", "&Right(strZero&Day(sDate),2)&" "&dMonth(Month(sDate)-1)&" "&Year(sDate)&" "&Right(strZero&Hour(sDate),2)&":"&Right(strZero&Minute(sDate),2)&":"&Right(strZero&Second(sDate),2)&" "&strZone
	End Function

    '**********
    ' ������: toUnixEpoch
    ' ��  ��: sDate
    ' ��  ��: ��ȡʱ���
    '**********
	Function toUnixEpoch(sDate)
		toUnixEpoch = DateDiff("s", "1970-1-1 00:00:00", sDate) -  getMistiming("1970-1-1 00:00:00")
	End Function

    '**********
    ' ������: fromUnixEpoch
    ' ��  ��: iNumber	--  ʱ���
    ' ��  ��: ��ȡ����ʱ��
    '**********
	Function fromUnixEpoch(iNumber)
		fromUnixEpoch = DateAdd("s",iNumber +  getMistiming("1970-1-1 00:00:00"),"1970-1-1 00:00:00")
	End Function

	'**********
	' ������: zodiac
	' ��  ��: bYear as birthday year
	' ��  ��: ����������Ф
	'**********
	Function zodiac(bYear)
		If bYear > 0 Then
			Dim zodiacList : zodiacList = Array("��", "��", "��", "��", "��", "ţ", "��", "��", "��", "��", "��", "��")
			zodiac = zodiacList(bYear mod 12)
		End If
	End Function

	'**********
	' ������: Constellation
	' ��  ��: Birth as birthday
	' ��  ��: ����������Ф
	'**********    
	Function Constellation(Birth)
        If Year(Birth) <1951 Or Year(Birth) > 2049 Then Exit Function
        Dim BirthDay, BirthMonth
        BirthDay = Day(Birth)
        BirthMonth = Month(Birth)
        Select Case BirthMonth
            Case 1
                If BirthDay>= 21 Then
                    Constellation = Constellation & "ˮƿ"
                Else
                    Constellation = Constellation & "ħ��"
                End If
            Case 2
                If BirthDay>= 20 Then
                    Constellation = Constellation & "˫��"
                Else
                    Constellation = Constellation & "ˮƿ"
                End If
            Case 3
                If BirthDay>= 21 Then
                    Constellation = Constellation & "����"
                Else
                    Constellation = Constellation & "˫��"
                End If
            Case 4
                If BirthDay>= 21 Then
                    Constellation = Constellation & "��ţ"
                Else
                    Constellation = Constellation & "����"
                End If
            Case 5
                If BirthDay>= 22 Then
                    Constellation = Constellation & "˫��"
                Else
                    Constellation = Constellation & "��ţ"
                End If
            Case 6
                If BirthDay>= 22 Then
                    Constellation = Constellation & "��з"
                Else
                    Constellation = Constellation & "˫��"
                End If
            Case 7
                If BirthDay>= 23 Then
                    Constellation = Constellation & "ʨ��"
                Else
                    Constellation = Constellation & "��з"
                End If
            Case 8
                If BirthDay>= 24 Then
                    Constellation = Constellation & "��Ů"
                Else
                    Constellation = Constellation & "ʨ��"
                End If
            Case 9
                If BirthDay>= 24 Then
                    Constellation = Constellation & "���"
                Else
                    Constellation = Constellation & "��Ů"
                End If
            Case 10
                If BirthDay>= 24 Then
                    Constellation = Constellation & "��Ы"
                Else
                    Constellation = Constellation & "���"
                End If
            Case 11
                If BirthDay>= 23 Then
                    Constellation = Constellation & "����"
                Else
                    Constellation = Constellation & "��Ы"
                End If
            Case 12
                If BirthDay>= 22 Then
                    Constellation = Constellation & "ħ��"
                Else
                    Constellation = Constellation & "����"
                End If
            Case Else
                Constellation = ""
        End Select
    End Function

End Class
%>
