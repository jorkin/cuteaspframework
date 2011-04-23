<!--#include file="page.master.asp"-->
<%
xModule = LCase(Casp.rq(1,"m",1,""))
xDo = LCase(Casp.rq(1,"do",1,""))
Casp.db.GetRowObject oSingle,"select Top 1 * from SinglePage where ModuleName='"&xModule&"'"
If isset(oSingle) = False Then ShowError(Array("没有找到相应的模块"))
If xDo = "save" Then
	xContent_cn = Request("Content_cn")
	xContent_en = Request("Content_en")
	Casp.db.setRs rs,"select Top 1 * from SinglePage where ModuleName='"&xModule&"'",3
	If rs.eof Then ShowError(Array("参数错误，请返回重试！"))
	rs("Content_cn") = xContent_cn
	rs("Content_en") = xContent_en
	rs.update
	Casp.db.CloseRs rs
	alertRedirect "更新成功！",Casp.refererUrl
End If

TopCode()
Call ProcessModule(xModule)

Sub ProcessModule(modulename)
%>
<div id="inner">
  <div id="title"><a class="title" href="Main.asp"><%=Casp.WebConfig("SiteTitle")%></a>&nbsp;-&nbsp;<%=oSingle("Title_cn")%>(<%=oSingle("Title_en")%>)</div>
  <div id="main">
    <form action="?m=<%=xModule%>&do=save" method="post" name="myform">
      <dl class="tabs">
        <dt>
        <a href="javascript:void(0);" class="curr">中文</a>
        <a href="javascript:void(0);">English</a>
        </dt>
        <dd>
          <table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
            <tbody>
              <tr class="">
                <td><textarea class="fckeditor" style="width:550px;height:300px;" name="content_cn" id="content_cn"><%=oSingle("Content_cn")%></textarea></td>
              </tr>
              <tr class="none">
                <td>
                  <input type="submit" class="button" value="保存" name="submit" id="submit"></td>
              </tr>
            </tbody>
          </table>
        </dd>
        <dd style=" display:none;">
          <table width="100%" cellspacing="0" cellpadding="0" border="0" class="table">
            <tbody>
              <tr class="">
                <td><textarea class="fckeditor" style="width:550px;height:300px;" name="content_en" id="content_en"><%=oSingle("Content_en")%></textarea></td>
              </tr>
              <tr class="none">
                <td>
                  <input type="submit" class="button" value="Save" name="submit" id="submit"></td>
              </tr>
            </tbody>
          </table>
        </dd>
      </dl>
		<input type="hidden" value="1" name="id" id="id">
		<input type="hidden" value="save" name="do">
		<input type="hidden" value="yes" name="save" id="save">
    </form>
  </div>
</div>
<%
End Sub
%>
