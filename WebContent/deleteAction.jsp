<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="bbs.BbsDAO"%>
<% request.setCharacterEncoding("UTF-8");%>
<% request.setCharacterEncoding("euc-kr"); %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String) session.getAttribute("userID");
		}
		
		if(userID == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href='login.jsp'");
			script.println("</script>");
			
		}
		
		int bbsID = 0;
			//존재하는글 
		
		if (request.getParameter("bbsID") != null) {
			bbsID = Integer.parseInt(request.getParameter("bbsID"));

		}

		if (bbsID == 0) {
			// 존재하지 않는 글
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href='login.jsp'");
			script.println("</script>");
		}

		Bbs bbs = new BbsDAO().getBbs(bbsID);
		
		if(!userID.equals(bbs.getUserID())){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다')");
			script.println("location.href='login.jsp'");
			script.println("</script>");
		}
				
		BbsDAO bbsDAO = new BbsDAO();
			//게시글 삭제
			int result = bbsDAO.delete(bbsID);
		
			if (result == -1) { // 데이터베이스 오류
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('게시글 삭제에 실패했습니다.')");
				script.println("history.back()");
				script.println("</script>");
				
			}else{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('게시글 삭제가 되었습니다.')");
				script.println("location.href = 'bbs.jsp'");
				script.println("</script>");
			}
		
		
		
		
	%>
</body>
</html>