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
Class Class_Cookie
	Public	Mark	'ǰ׺

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
    ' ��  ��: Add a cookie
    '**********
	Sub [set](Key, Value, Options)
        Response.Cookies(Me.Mark & Key) = Value
        If Not (IsNull(Options) Or IsEmpty(Options) Or Options = "") Then
            If IsArray(Options) Then
                Dim l : l = UBound(Options)
                Response.Cookies(Me.Mark & Key).Expire = Options(0)
                If l = 1 Then Response.Cookies(Me.Mark & Key).Path = Options(1)
                If l = 2 Then Response.Cookies(Me.Mark & Key).Domain = Options(2)
            Else
                Response.Cookies(Me.Mark & Key).Expire = Options
            End If
        End If
    End Sub

    '**********
    ' ������: get
    ' ��  ��: get a cookies
    '**********
	Function [get](Key)
        [get] = Request.Cookies(Me.Mark & Key)
    End Function

    '**********
    ' ������: remove
    ' ��  ��: Remove a cookie
    '**********
	Sub Remove(Key)
         Response.Cookies(Me.Mark & Key) = Empty
    End Sub

    '**********
    ' ������: removeAll
    ' ��  ��: Remove all cookies
    '**********
	Sub RemoveAll()
        Clear()
    End Sub

    '**********
    ' ������: Clear
    ' ��  ��: Remove all cookies
    '**********
	Private Sub Clear()
        Dim iCookie
        For Each iCookie In Request.Cookies
            Response.Cookies(iCookie).Expires = formatDateTime(Now)
        Next
    End Sub

End Class
%>
