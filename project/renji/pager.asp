<!--#include file="page.master.asp"-->
<%
aResult = Array("","A","B","C","D")
xId = Casp.rq(1,"id",0,0)

Casp.db.GetRowObject oPager,"select top 1 * from Pager where [language]='"&Mid(Lang,2,Len(Lang))&"' and id="&xId&""
If isset(oPager) = False Then die "没有找到该信息"
PageTitle = oPager("Title")
PageDescription = ""
PageBody = "page_body"
Call TopCode()
%>
		<div class="content">
			<div class="main">
				<div class="site_nav_bar">
					您现在的位置：<a href="/">首页</a> > <a href="list.asp?cid=13"><%=getClassName(13,Lang)%></a> > <a href="/show.asp?id=304">习题自测</a> > <%=oPager("Title")%>
				</div>
				<div class="article_body">
					<h1 class="article_title"><%=oPager("title")%></h1>
					<div class="article_content">
						<%
						If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
						%>
						<table width="100%" class="list">
						<tr height="25">
						<th width="60">ID</th><th>标题</th><th>正确答案</th><th>您所选答案</th><th>判断</th>
						</tr>
						<%
						i = 0
						Casp.db.Exec rs,"select * from Question where pid="&xId
						Do While Not rs.eof
						%>
						<tr height="25">
						<td>&nbsp;第 <%=i+1%> 题</td>
						<td><a href="javascript:;" onclick="showoptions(<%=rs("id")%>)"><%=rs("question")%></a> <span class="silver">(<%=IIF(rs("qtype"),"多选","单选")%>)</span></td>
						<td>
						<%
						sQ_result = ""
						fQ_Result = Replace(Casp.rq(3,"q_result"&rs("id"),1,"")," ","")
						Casp.db.Exec rs1,"select * from Options where Qid="&rs("id")&" order by sortid asc,id asc"
						n = 1
						Do WHile Not rs1.eof
							If rs1("isresult") Then
								sQ_result = sQ_result & aResult(n) & ","
							End If
							rs1.MoveNext
							n = n + 1
						Loop
						sQ_result = Join(Casp.Arrays.Strip(sQ_result),",")
						echo sQ_result
						%>
						</td>
						<td>
						<%=fQ_Result%>
						</td>
						<td>
						<%
						If fQ_Result = sQ_result Then
						%>
						<b class="right">√</b>
						<%
						Else
						%>
						<b class="wrong">×</b>
						<%
						End If
						%>
						</td>
						</tr>
						<tbody id="qshow<%=rs("id")%>" style="width:100%;display:none">
						<tr>
						<td></td>
						<td colspan="4">
						<%
							rs1.MoveFirst
							n = 1
							Do WHile Not rs1.eof
								echo "<span class="""&IIF(rs1("isresult"),"red","")&""">"&aResult(n)&"、"&rs1("option")&"</span><br/>"
								rs1.MoveNext
								n = n + 1
							Loop
						%>
						</td>
						</tr>
						</tbody>
						<%
							rs1.close
							rs.MoveNext
							i = i + 1
						Loop
						%>
						</table>
						<div class="form_submit">
							<input type="button" class="button" value="重新测试" onclick="javascript:history.back();" />
						</div>
						<%
						Else
						%>
						<form method="post" id="myform">
						<ul class="list list_question">
							<%
							Dim i 
							i = 1
							Casp.db.Exec rs,"select * from Question where pid="&xId
							Do While Not rs.eof
							%>
							<li class="item" id="q<%=rs("id")%>">
								<h3 class="title"><%=i%>、<%=rs("Question")%>(<%=IIF(rs("qtype"),"多选","单选")%>)</h3>
								<ul class="lite lite_option" id="qo<%=rs("id")%>">
									<%
									n = 1
									Casp.db.Exec rs1,"select * from Options where Qid="&rs("id")&" order by sortid asc,id asc"
									Do While Not rs1.eof
									%>
									<li>
									<label><input type="<%=IIF(rs("qtype"),"checkbox","radio")%>" name="q_result<%=rs("id")%>" value="<%=aResult(n)%>" />&nbsp;
									<%=aResult(n)%>、<%=rs1("option")%></label>
									</li>
									<%
										rs1.MoveNext
										n = n + 1
									Loop
									rs1.close
									%>
								</ul>
							</li>
							<%
								rs.MoveNext
								i = i + 1
							Loop
							%>
						</ul>
						<div class="form_submit">
							<input type="submit" class="button" value="提交" />
							<input type="reset" class="button" value="重置" /> 
							<a href="show.asp?id=304" class="gray">» 重新选题</a>
						</div>
						</form>
						<%
						End If
						%>
					</div>
				</div>
			</div>
			<div class="sidebar">
				<div class="category_box">
					<div class="category_header">
						<h3 class="title"><%=getClassName(13,Lang)%></h3>
						<em><%=getClassName(13,"_en")%></em>
					</div>
					<div class="category_body">
						<ul class="lite category_lite">
							<%
							Casp.db.Exec rs,"select * from [news] where CategoryId = 13 and [language]='"&Mid(Lang,2,Len(Lang))&"' order by sortid desc,id asc"
							If Not rs.eof Then
								Do While Not rs.eof
								%>
								<li <%=IIF(rs("id")=304,"class=""curr""","")%>><a href="show.asp?id=<%=rs("id")%>" class="title">• <%=rs("Title")%></a></li>
								<%
									rs.MoveNext
								Loop
							End If
							
							%>
						</ul>
					</div>
				</div>
			</div>
		</div>
<script>
$("#myform").submit(function(){
	var flag = true;
	if(confirm("确认无误？")){
		$(".lite_option",this).each(function(){
			var self = this;
			if($("input:checked",this).length == 0){
				flag = false;
				alert("请选择选项！");
				$("#q" + self.id.replace("qo","") + " h3.title").addClass("red");
				location.hash = "#q" + self.id.replace("qo","");
				return false;
			}else{
				$(this).prev().removeClass("red");
			}
		});
	}else{
		return false;
	}
	return flag;
});
function showoptions(qid){
	$("#qshow"+qid).toggle();
	return false;
}
</script>