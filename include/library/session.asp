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

    Public Default Property Get Constructor(Value)
        Constructor = [Get](Value)
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
    ' ������: Set
    ' ��  ��: Add a Session
    '**********
	Sub [Set](Key, Value)
		If IsObject(Value) Then
			Set Session(Me.Mark & Key) = Value
		Else
			Session(Me.Mark & Key) = Value
		End If
    End Sub

    '**********
    ' ������: Get
    ' ��  ��: Get a Session
    '**********
	Function [Get](Key)
		If IsObject(Session(Me.Mark & Key)) Then
			Set [Get] = Session(Me.Mark & Key)
		Else
			[Get] = Session(Me.Mark & Key)
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

    '**********
    ' ������: compare
    ' ��  ��: Compare two session
    '**********
	Function Compare(Key1, Key2)
        Dim Cache1
        Cache1 = Me.[Get](Key1)
        Dim Cache2
        Cache2 = Me.[Get](Key2)
        If TypeName(Cache1) <> TypeName(Cache2) Then
            Compare = False
        Else
            If TypeName(Cache1) = "Object" Then
                Compare = (Cache1 Is Cache2)
            Else
                If TypeName(Cache1) = "Variant()" Then
                    Compare = (Join(Cache1, "^") = Join(Cache2, "^"))
                Else
                    Compare = (Cache1 = Cache2)
                End If
            End If
        End If
    End Function
End Class
%>
