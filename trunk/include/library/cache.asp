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
Class Class_Cache
	Public	Mark	'ǰ׺

	Private IExpires

    Public Default Property Get Contents(Value)
        Contents = [get](Value)
    End Property

    Private Property Let Expires(Value)
        IExpires = DateAdd("n", Value, Now)	'����
    End Property

    Private Property Get Expires()
        Expires = IExpires
    End Property

    '**********
    ' ������: class_Initialize
    ' ��  ��: Constructor
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
    ' ������: lock
    ' ��  ��: lock the applaction
    '**********
	Sub Lock()
        Application.Lock()
    End Sub

    '**********
    ' ������: unlock
    ' ��  ��: unLock the applaction
    '**********
	Sub unlock()
        Application.unLock()
    End Sub

    '**********
    ' ������: SetCache
    ' ��  ��: Set a cache
    '**********
	Sub [set](Key, Value, Expire)
        Expires = Expire
        Lock
		Application(Mark & Key) = Value
        Application(Mark & Key & "_Expires") = Expires
        unLock
    End Sub

    '**********
    ' ������: getCache
    ' ��  ��: Get a cache
    '**********
	Function [get](Key)
        Dim Expire
        Expire = Application(Mark & Key & "_Expires")
        If IsNull(Expire) Or IsEmpty(Expire) Then
            [get] = ""
        Else
            If IsDate(Expire) And CDate(Expire) > Now Then
                [get] = Application(Mark & Key)
            Else
                Call Remove(Mark & Key)
                Value = ""
            End If
        End If
    End Function

    '**********
    ' ������: remove
    ' ��  ��: remove a cache
    '**********
	Sub Remove(Key)
        Lock
        Application.Contents.Remove(Mark & Key)
        Application.Contents.Remove(Mark & Key & "_Expires")
        unLock
    End Sub

    '**********
    ' ������: removeAll
    ' ��  ��: remove all cache
    '**********
	Sub RemoveAll()
        Lock
        Application.Contents.RemoveAll()
        unLock
    End Sub

    '**********
    ' ������: compare
    ' ��  ��: Compare two caches
    '**********
	Function Compare(Key1, Key2)
        Dim Cache1
        Cache1 = getCache(Key1)
        Dim Cache2
        Cache2 = getCache(Key2)
        If TypeName(Cache1) <> TypeName(Cache2) Then
            Compare = True
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