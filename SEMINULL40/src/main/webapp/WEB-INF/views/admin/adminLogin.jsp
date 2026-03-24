<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>캠둘기 - 로그인</title>
<link rel="stylesheet" type="text/css" href="style.css">
<style>
/* 기본 초기화 */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: 'Malgun Gothic', sans-serif;
}

body {
	background-color: #f0f7ff;
	min-height: 100vh;
	display: flex;
	flex-direction: column;
	align-items: center;
}

/* 로그인 컨테이너 */
.login-container {
	flex: 1;
	width: 400px;
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	padding: 50px 0;
}

.logo-section {
	text-align: center;
	margin-bottom: 30px;
}

.logo-circle {
	width: 120px;
	height: 120px;
	background-color: #ddd;
	border-radius: 20px;
	margin-bottom: 10px;
	overflow: hidden;
}
/* 실제 이미지가 있다면 아래 주석 해제
		.logo-circle img { width: 100%; height: 100%; object-fit: cover; }
		*/
.logo-section h1 {
	font-size: 32px;
	font-weight: bold;
	color: #333;
}

/* 폼 스타일 */
.login-form {
	width: 100%;
}

.login-form input[type="text"], .login-form input[type="password"] {
	width: 100%;
	padding: 15px;
	margin-bottom: 10px;
	border: none;
	border-radius: 8px;
	font-size: 16px;
	background-color: #fff;
}

.login-btn {
	width: 100%;
	padding: 15px;
	background-color: #a2ccfe;
	border: none;
	border-radius: 8px;
	color: #444;
	font-size: 18px;
	font-weight: bold;
	cursor: pointer;
	margin-bottom: 15px;
}

.login-btn:hover {
	background-color: #8dbdf7;
}

.exit-btn {
	width: 100%;
	padding: 15px;
	background-color: #ff0000;
	border: none;
	border-radius: 8px;
	color: #ffffff;
	font-size: 18px;
	font-weight: bold;
	cursor: pointer;
	margin-bottom: 15px;
}

</style>

</head>
<body>
	<c:set var="contextPath" value="${pageContext.request.contextPath}"
		scope="application" />
	<div class="login-container">
		<div class="logo-section">
			<div class="logo-circle"></div>
			<h1>캠둘기</h1>
			<h1>ADMIN</h1>
		</div>

		<form action="loginProcess.jsp" method="post" class="login-form">
			<input type="text" name="id" placeholder="아이디" required> 
			<input type="password" name="pwd" placeholder="비밀번호" required>
			<button onclick="location.href='admin/main'"
				type="submit" class="login-btn">로그인</button>
		</form>
		<button onclick="location.href='${pageContext.request.contextPath}'"
		 		type="submit" class="exit-btn">나가기</button>

	</div>

</body>
</html>