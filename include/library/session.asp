<%
'**********
'	class		: A Caching class
'	File Name	: Cache.asp
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
Class Class_Session
	Public	Mark	'ǰ׺

    Public Property Let Timeout(Value)
		If IsNumeric(Value) Then Session.Timeout = Value
    End Property

    Public Default Property Get Contents(Value)
        contents = [get](Value)
    End Property

    '**********
    ' ������: class_Initialize
    ' ��  ��: Save the session
    '**********
	Private Sub class_initialize()
		Mark = "cute_"
    End Sub

    '**********
    ' ������: class_Terminate
    ' ��  ��: Deconstrutor
    '**********
	Private Sub class_Terminate()
    End Sub

    '**********
    ' ������: set
    ' ��  ��: Add a Session
    '**********
	Sub [set](Key, Value)
		If IsObject(Value) Then
			Set Session(Me.Mark & Key) = Value
		Else
			Session(Me.Mark & Key) = Value
		End If
    End Sub

    '**********
    ' ������: get
    ' ��  ��: get a Session
    '**********
	Function [get](Key)
		If IsObject(Session(Me.Mark & Key)) Then
			Set [get] = Session(Me.Mark & Key)
		Else
			[get] = Session(Me.Mark & Key)
		End If
    End Function

    '**********
    ' ������: remove
    ' ��  ��: Remove a Session
    '**********
	Sub Remove(Key)
		If IsObject(Session(Me.Mark & Key)) Then
			Set Session(Me.Mark & Key) = Nothing
		End If
        Session.Contents.Remove(Me.Mark & Key)
    End Sub

    '**********
    ' ������: removeAll
    ' ��  ��: Remove all Session
    '**********
	Sub RemoveAll()
        Dim iSession
        For Each iSession In Session.Contents
			Me.Remove(iSession)
        Next
	End Sub
End Class
%>
