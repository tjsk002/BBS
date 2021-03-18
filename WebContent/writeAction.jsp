<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- * 이 파일은 이 아래로 joinAction.jsp를 일부 수정해 만들었음 -->
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<jsp:setProperty name="bbs" property="bbsTitle" />
<jsp:setProperty name="bbs" property="bbsContent" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%  // 게시글 작성 기능 구현
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) { // 로그아웃 -> 로그인 페이지로 이동
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('게시글을 작성하려면 로그인이 필요합니다.')"); 
			script.println("location.href = 'login.jsp'"); 
			script.println("</script>");			
		} else {
			if (bbs.getBbsTitle() == null || bbs.getBbsContent() == null) { // 공란 있음
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')"); // 경고창 띄움
				script.println("history.back()"); // 이전 페이지로 돌려보냄
				script.println("</script>");
			} else {
				BbsDAO bbsDAO = new BbsDAO(); // 공란 없음 -> 게시글 작성
				int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent());
				if (result == -1) { // 데이터베이스 오류
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('게시글 작성에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				} else { // 게시글 작성 성공
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('게시글이 등록되었습니다.')");
					script.println("location.href = 'bbs.jsp'"); // 게시글을 등록했으므로 게시판 페이지로 이동
					script.println("</script>");
				} 
			}
		}
	%>
</html>