<%
'**********
'	class		: Md5 
'	File Name	: mg5.asp
'	Version		: 0.2.0
'	Author		: TerranC
'	Date		: 2008-5-20
'**********


'**********
'	ʾ��
'**********

'********** 

'**********
'	������
'**********
Class Class_Email
	Public Charset,MailServer

    Private Sub Class_Initialize()
		Charset			= "gb2312"
		MailServer			= "127.0.0.1"
    End Sub

	'**********
    '��������Send
    '��  �ã���jMail��������ʼ�
    '��  ����MailtoAddress ----�����˵�ַ
    '        MailtoName    -----����������
    '        Subject       -----����
    '        TemplateFile  -----ģ���ļ�·��
    '        Params		   -----�滻����
    '        FromName      -----����������
    '        MailFrom      -----�����˵�ַ
    '        UserName      -----�������ʺ�
    '        Password      -----����������
    '        Priority      -----�ż����ȼ���1Ϊ�Ӽ���3Ϊ��ͨ��5Ϊ�ͼ���
	'����ֵ��Array(�Ƿ�ɹ�,��ʾ��Ϣ)
    '**********
    Public Function Send(MailtoAddress, MailtoName, Subject, TemplateFile, Params, FromName, FromMail, UserName, Password, Priority)
        If IsObjInstalled("jMail.Message") Then
            On Error Resume Next
        Else
			Send = Array(False,"δ�ҵ� JMail ���")
            Exit Function
        End If
		If Priority = "" Or IsNull(Priority) Then Priority = 3

		Dim jMail : Set jMail = Server.CreateObject("jMail.Message")
        jMail.Silent = False
        jMail.Charset = Charset							'�ʼ�����
        jMail.ContentType = "text/html"					'�ʼ����ĸ�ʽ
        jMail.From = FromMail							'������Email
        jMail.FromName = FromName						'����������
		jMail.ReplyTo = FromMail						
		jMail.AppendBodyFromFile TemplateFile			'����ģ��

		Dim iParamName
		If Not IsNull(Params) Then
			For Each iParamName In Params
				jMail.Body = Replace(jMail.Body, "{" & iParamName & "}", Params(iParamName))
			Next
		End If
        
		jMail.ClearRecipients
        jMail.AddRecipient MailtoAddress, MailtoName	'������
        jMail.Subject = Subject							'����
        jMail.Priority = Priority						'�ʼ��ȼ���1Ϊ�Ӽ���3Ϊ��ͨ��5Ϊ�ͼ�

		'�����������ҪSMTP�����֤����ָ�����²���
        jMail.MailDomain =	Right(FromMail,InStr(FromMail,"@"))				'����������á�name@domain.com���������û�����¼ʱ����ָ��domain.com
        jMail.MailServerUserName = UserName			'��¼�û���
        jMail.MailServerPassWord = Password			'��¼����

        jMail.Send MailServer
        Send = jMail.ErrorMessage
        jMail.Close
        Set jMail = Nothing
		If Err Then
			Send = Array(False,Err.Description)
			Err.Clear
			Exit Function
		End If
		Send = Array(True,Send)
        On Error Goto 0
    End Function

    '**********
    '��������IsObjInstalled
    '��  �ã��������Ƿ��Ѿ���װ
    '��  ����strClassString ----�����
    '����ֵ��True  ----�Ѿ���װ
    '       False ----û�а�װ
    '**********
    Private Function IsObjInstalled(strClassString)
        IsObjInstalled = False
        On Error Resume Next
        Dim xTestObj
        Set xTestObj = Server.CreateObject(strClassString)
        If Err.Number = 0 Then IsObjInstalled = True
        Set xTestObj = Nothing
        On Error Goto 0
    End Function
End Class

%>
