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

	Public SHA1,Md5,Json,ValidCode,DbToExcel,Email,InterFace,BEDcode,Xml

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
		Set DbToExcel		= New Class_DbToExcel		'Db Data To Excel Data
		Set Email			= New Class_Email			'Email������
		Set InterFace		= New Class_Interface		'Զ�̻�ȡ��
		Set BEDcode			= New Class_BasicEncode		'�򵥼��ܽ���
		Set Xml				= New Class_XML				'XML������
		Err.Clear
		On Error Goto 0
	End Sub

	Private Sub Class_Terminate()
		If IsObject(Db) Then			Set Db				= Nothing
		If IsObject([String]) Then		Set [String]		= Nothing
		If IsObject(Params) Then		Set Params			= Nothing
		If IsObject([Array]) Then		Set [Array]			= Nothing
		If IsObject(Upload) Then		Set Upload			= Nothing
		If IsObject(Page) Then			Set Page			= Nothing
		If IsObject(File) Then			Set File			= Nothing
		If IsObject(Debug) Then			Set Debug			= Nothing
		If IsObject(Cookie) Then		Set Cookie			= Nothing
		If IsObject(Session) Then		Set Session			= Nothing
		If IsObject([Date]) Then		Set [Date]			= Nothing

		If IsObject(SHA1) Then			Set SHA1			= Nothing
		If IsObject(Md5) Then			Set Md5				= Nothing
		If IsObject(Json) Then			Set Json			= Nothing
		If IsObject(ValidCode) Then		Set ValidCode		= Nothing
		If IsObject(DbToExcel) Then		Set DbToExcel		= Nothing
		If IsObject(Email) Then			Set Email			= Nothing
		If IsObject(InterFace) Then		Set InterFace		= Nothing
		If IsObject(BEDcode) Then		Set BEDcode			= Nothing
		If IsObject(Xml) Then			Set Xml				= Nothing
	End Sub

	%>
	<!--#include file="library/common.asp"-->
	<%
End Class
%>
<script language="vbscript" runat="server">
	Set Tpub = Nothing	'ҳ��ִ����Ϻ��Զ��ͷŶ���
</script>