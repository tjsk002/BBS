<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="java.util.ArrayList"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta charset="UTF-8" name="viewport" content="width=device-width"
	, initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP 게시판 웹 사이트</title>
<style type="text/css">
a, a:hover {
	color: #000000;
	textdecoration: none;
}
</style>
</head>
<body>
	<%
		//userid, bbsid

		System.out.println("bbsID:::::" + request.getParameter("bbsID"));

		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}

		int bbsID = 0;

		bbsID = Integer.parseInt(request.getParameter("bbsID"));
		
		if (request.getParameter("pageID") != null) {
			bbsID = Integer.parseInt(request.getParameter("bbsID"));

			System.out.println("bbsID::: " + bbsID);

		}

		if (bbsID == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href='login.jsp'");
			script.println("</script>");
		}

		Bbs bbs = new BbsDAO().getBbs(bbsID);
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>

		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			
			<%
				if (userID == null) {
			%>
			
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="flase">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>

			<%
				} else {
			%>
			
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="flase">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			
			<%
				}
			%>

		</div>
	</nav>
	<div class="row">
		<table class="table table-striped"
			style="text-align: center; border: 1px solid #dddddd;">
			<thead>
				<tr>
					<th colspan="3"
						style="background-color: #eeeeee; text-align: center;">게시판
						글보기</th>

				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="width: 20%">글 제목</td>
					<td colspan="2"><%=bbs.getBbsTitle()%></td>
				</tr>
				<tr>
					<td>작성자</td>
					<td colspan="2"><%=bbs.getUserID()%></td>
				</tr>
				<tr>
					<td>작성일자</td>
					<td colspan="2"><%=bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시"
					+ bbs.getBbsDate().substring(14, 16) + "분"%></td>
				</tr>
				<tr>
					<td>내용</td>
					<td colspan="2" style="min-hight: 200px; text-align: left;">
					<%= bbs.getBbsContent().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>;") %>

					</td>

				</tr>
			</tbody>
		</table>
		<a href="bbs.jsp" class="btn btn-primary">목록</a>
		
		<%
			if (userID != null && userID.equals(bbs.getUserID())) {
				//본인이라면 수정과 삭제가 가능함
				//본인이 아니라면 수정과 삭제 버튼이 보이지 않음
		%>

		<a href="update.jsp?bbsID=<%=bbsID%>" class="btn btn-parimay">수정</a>
		<%//정말로 삭제하시겠습니까? 만들어주기 %>
		<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%=bbsID%>" class="btn btn-parimay">삭제</a>
			
		<%
			}
		%>

	</div>
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>