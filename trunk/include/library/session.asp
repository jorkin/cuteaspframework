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
        Session(Mark & Key) = Value
    End Sub

    '**********
    ' ������: get
    ' ��  ��: get a Session
    '**********
	Function [get](Key)
        [get] = Session(Mark & Key)
    End Function

    '**********
    ' ������: remove
    ' ��  ��: Remove a Session
    '**********
	Sub Remove(Key)
        Session.Contents.Remove(Mark & Key)
    End Sub

    '**********
    ' ������: removeAll
    ' ��  ��: Remove all Session
    '**********
	Sub RemoveAll()
		Session.abandon()
	End Sub

    '**********
    ' ������: Clear
    ' ��  ��: Remove all cookies
    '**********
	Private Sub Clear()
        Dim iSession
        For Each iSession In Session.Contents
            Session.Contents.Remove(iSession)
        Next
    End Sub
End Class
%>
