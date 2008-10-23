<%
'**********
'	class		: Wrapper Class
'	File Name	: class.asp
'	Version		: 0.1.0
'	Author		: TerranC
'	Date		: 2008-6-28
'**********


'**********
'	ʾ��
'**********
'**********
'	������
'**********
Dim Tpub
Set Tpub = New Class_Wrap


Class Class_Wrap

	Public Db,[String],Params,[Array],Upload,Page,File,Debug,Cookie,Session,[Date]

	Public SHA1,Md5,Json,ValidCode,Export,Email,InterFace,BEDcode,DES,Xml

	Private Sub Class_Initialize()
		On Error Resume Next
		Set Db				= New Class_Db				'���ݿ������
		Set [String]		= New Class_String			'String������
		Set Params			= New Class_Params			'Dictionary�򻯲�����
		Set [Array]			= New Class_Array			'���������
		Set Upload			= New Class_Upload			'�ϴ���
		Set Page			= New Class_Page			'��ҳ��
		Set File			= New Class_File			'�ļ�������
		Set Debug			= New Class_Debug			'Debug������
		Set Cookie			= New Class_Cookie			'Cookies������
		Set Session			= New Class_Session			'Session������
		Set [Date]			= New Class_Date			'Date������

		Set SHA1			= Class_SHA1()				'SHA1����
		Set Md5				= New Class_Md5				'Md5����
		Set Json			= Class_Json()				'Json������
		Set ValidCode		= New Class_ValidCode		'��֤��
		Set Export			= New Class_Export			'Export Data
		Set Email			= New Class_Email			'Email������
		Set InterFace		= New Class_Interface		'Զ�̻�ȡ��
		Set BEDcode			= New Class_BasicEncode		'�򵥼��ܽ���
		Set DES				= Class_DES()				'DSC���ܽ�����
		Set Xml				= New Class_XML				'XML������
		Err.Clear
		On Error Goto 0
	End Sub

	Private Sub Class_Terminate()
		On Error Resume Next
		Set Db				= Nothing
		Set [String]		= Nothing
		Set Params			= Nothing
		Set [Array]			= Nothing
		Set Upload			= Nothing
		Set Page			= Nothing
		Set File			= Nothing
		Set Debug			= Nothing
		Set Cookie			= Nothing
		Set Session			= Nothing
		Set [Date]			= Nothing

		Set SHA1			= Nothing
		Set Md5				= Nothing
		Set Json			= Nothing
		Set ValidCode		= Nothing
		Set Export			= Nothing
		Set Email			= Nothing
		Set InterFace		= Nothing
		Set BEDcode			= Nothing
		Set DES				= Nothing
		Set Xml				= Nothing
		Err.Clear
		On Error Goto 0
	End Sub

	%>
	<!--#include file="library/common.asp"-->
	<%
End Class
%>
<script language="vbscript" runat="server">
	Set Tpub = Nothing	'ҳ��ִ����Ϻ��Զ��ͷŶ���
</script>