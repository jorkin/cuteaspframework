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

	Private IExpires
	Private sysName
	Private localName, localValue

    Public Default Property Get Contents(Value)
        Contents = getCache(Value)
    End Property

    Private Property Let Expires(Value)
        IExpires = DateAdd("n", Value, Now)	'����
    End Property

    Private Property Get Expires()
        Expires = IExpires
    End Property

	Public Property Let CacheName(str)
		sysName = str
	End Property
	
	Private Property Get CacheName()
		If Len(sysName) = 0 Then sysName = "terranc"
		CacheName = sysName
	End Property
		
    '**********
    ' ������: class_Initialize
    ' ��  ��: Constructor
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
	Sub setCache(Key, Value, Expire)
        Expires = Expire
        Lock
        Application(CacheName & "_" & Key) = Value
        Application(CacheName & "_" & Key & "_Expires") = Expires
        unLock
    End Sub

    '**********
    ' ������: getCache
    ' ��  ��: Get a cache
    '**********
	Function getCache(Key)
        Dim Expire
        Expire = Application(CacheName & "_" & Key & "_Expires")
        If IsNull(Expire) Or IsEmpty(Expire) Then
            getCache = ""
        Else
            If IsDate(Expire) And CDate(Expire) > Now Then
                getCache = Application(CacheName & "_" & Key)
            Else
                Call Remove(CacheName & "_" & Key)
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
        Application.Contents.Remove(CacheName & "_" & Key)
        Application.Contents.Remove(CacheName & "_" & Key & "_Expires")
        unLock
    End Sub

    '**********
    ' ������: removeAll
    ' ��  ��: remove all cache
    '**********
	Sub RemoveAll()
        Clear()
    End Sub

    '**********
    ' ������: clear
    ' ��  ��: Get a cookie
    '**********
	Private Sub Clear()
        Application.Contents.RemoveAll()
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