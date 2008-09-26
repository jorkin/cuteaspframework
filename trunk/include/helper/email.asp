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
	Private s_chs, s_svr, s_user, s_pwd
	
	'�����ַ���
	Public Property Let Charset(str)
		s_chs = str
	End Property

	'�����ַ���
	Private Property Get Charset()
		If s_chs = "" Then s_chs = "gb2312"
		s_chs = str
	End Property

	Public Property Let MailServer(str)
		s_svr = str
	End Property
	
	Private Property Get MailServer()
		If s_svr = "" Then s_svr = "12.0.0.1"
		MailServer = s_svr
	End Property

	'���÷����û���
	Public Property Let MailUserName(str)
		s_chs = str
	End Property
	
	Private Property Get MailUserName()
		MailUserName = s_user
	End Property

	'���÷����û�������
	Public Property Let MailPassword(str)
		s_pwd = str
	End Property
	
	Private Property Get MailPassword()
		MailPassword = s_pwd
	End Property

	'**********
    '��������SendMail
    '��  �ã���jMail��������ʼ�
    '��  ����MailtoAddress ----�����˵�ַ
    '        MailtoName    -----����������
    '        Subject       -----����
    '        TemplateFile  -----ģ���ļ�·��
    '        Params		   -----�滻����
    '        FromName      -----����������
    '        MailFrom      -----�����˵�ַ
    '        Priority      -----�ż����ȼ���1Ϊ�Ӽ���3Ϊ��ͨ��5Ϊ�ͼ���
	'����ֵ��Array(�Ƿ�ɹ�,��ʾ��Ϣ)
    '**********
    Function SendMail(MailtoAddress, MailtoName, Subject, TemplateFile, Params, FromName, FromMail, Priority)
        If IsObjInstalled("jMail.Message") Then
            On Error Resume Next
        Else
			SendMail = Array(False,"δ�ҵ� JMail ���")
            Exit Function
        End If
		If Priority = "" Or IsNull(Priority) Then Priority = 3

		Dim jMail : Set jMail = Server.CreateObject("jMail.Message")
        jMail.Silent = False
        jMail.Charset = System_Charset					'�ʼ�����
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
        jMail.MailDomain = MailDomain					'����������á�name@domain.com���������û�����¼ʱ����ָ��domain.com
        jMail.MailServerUserName = MailUserName			'��¼�û���
        jMail.MailServerPassWord = MailPassword			'��¼����

        jMail.Send MailServer
        SendMail = jMail.ErrorMessage
        jMail.Close
        Set jMail = Nothing
		If Err Then
			SendMail = Array(False,Err.Description)
			Err.Clear
			Exit Function
		End If
		SendMail = Array(True,SendMail)
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
