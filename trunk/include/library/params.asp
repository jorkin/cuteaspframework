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
		If Item Is Nothing Then
			Contents = ""
		Else
			Contents = Item(sItem)
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
		If IsObject(Item) Then
			Set Item = Nothing
		End If
    End Sub

	Private Sub Open
		Set Item = Server.CreateObject("Scripting.Dictionary")
	End Sub

	Sub Add(itemName,itemValue)
		If Not IsObject(Item) Then Open
		If Item Is Nothing Then Open
		Item.Add itemName,itemValue
	End Sub

	Sub Close()
		Set Item = Nothing
	End Sub
End Class
%>