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
 	'**********
    ' ������: Contents
    ' ��  ��: Get Params Value
    '**********
    Public Default Property Get Init(OutParams)
		Set OutParams = Server.CreateObject("Scripting.Dictionary")
		OutParams.CompareMode = 1
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
    End Sub

	Sub Close(OutParams)
		Set OutParams = Nothing
	End Sub
End Class
%>