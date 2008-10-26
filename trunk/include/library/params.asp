<%
'**********
'	class		: A Item class
'	File Name	: Item.asp
'	Version		: 0.2.0
'	Author		: TerranC
'	Date		: 2008-6-16
'**********


'**********
'	ʾ��
'**********

'**********
'	������
'**********
Class Class_Params
	Public Item

 	'**********
    ' ������: Contents
    ' ��  ��: Get Params Value
    '**********
   Public Default Property Get Contents(sItem)
		On Error Resume Next
		If Me.Item Is Nothing Then
			Contents = ""
		Else
			Contents = Me.Item(sItem)
		End If
		On Error Goto 0
    End Property

	'**********
    ' ������: class_Initialize
    ' ��  ��: Constructor
    '**********
	Private Sub Class_Initialize()
    End Sub

	'**********
    ' ������: class_Initialize
    ' ��  ��: Constructor
    '**********
	Private Sub Class_Terminate()
		If IsObject(Me.Item) Then
			Set Me.Item = Nothing
		End If
    End Sub

	Private Sub Open
		Set Me.Item = Server.CreateObject("Scripting.Dictionary")
	End Sub

	Sub Add(itemName,itemValue)
		If Not IsObject(Me.Item) Then Open
		If Me.Item Is Nothing Then Open
		Me.Item.Add itemName,itemValue
	End Sub

	Sub Close()
		Set Me.Item = Nothing
	End Sub
End Class
%>