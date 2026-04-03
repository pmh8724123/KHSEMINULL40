<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>

/* 푸터 css */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: "Arial", sans-serif;
}



.footer {
	position : relative;
	bottom : 0;
	width : 100%;
	background: #0d1b2a;
	color: #fff;
	display: flex;
	justify-content: space-between;
	padding: 30px;
	margin-top: 20px;
}

.footer-left {
	display: flex;
	gap: 10px;
}

.footer-center {
	display: flex;
	gap: 50px;
}

.footer-center h4 {
	margin-bottom: 10px;
}

.footer-right {
	text-align: right;
}

</style>
</head>
<body>
	<!-- 푸터 -->
		<footer class="footer">
			<div class="footer-left">
				<div class="profile small"></div>
				<div>
					<h2>캠둘기</h2>
					<p>대학생들의 소통 공간</p>
				</div>
			</div>

			<div class="footer-center">
				<div>
					<h4>고객지원</h4>
					<a href="${pageContext.request.contextPath}/information/informationNotice">공지사항</a><br>
					<a href="${pageContext.request.contextPath}/information/qna">문의하기</a>
				</div>
				<div>
					<h4>정보</h4>
					<a href="${pageContext.request.contextPath}/information/tos">이용약관</a><br>
					<a href="${pageContext.request.contextPath}/information/privacyPolicy">개인정보처리방침</a>
				</div>
			</div>

			<div class="footer-right">
				© 2026 캠둘기.<br> All rights reserved.
			</div>
		</footer>
</body>
</html>