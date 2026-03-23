<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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
/*실제 이미지가 있다면 아래 주석 해제
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

.login-options {
	display: flex;
	justify-content: space-between;
	font-size: 14px;
	color: #666;
	width: 100%;
}

.login-options a {
	text-decoration: none;
	color: #666;
}

.signup-link {
	margin-top: 50px;
}

.signup-link a {
	text-decoration: none;
	font-weight: bold;
	color: #333;
	font-size: 18px;
}

/* 푸터 스타일 */
.footer {
	width: 100%;
	background-color: #101c2d;
	color: #fff;
	padding: 40px 10% 20px;
}

.footer-content {
	display: flex;
	flex-wrap: wrap;
	justify-content: space-between;
	align-items: flex-start;
	max-width: 1200px;
	margin: 0 auto;
}

.footer-brand {
	flex: 1;
	min-width: 200px;
}

.footer-logo-text {
	font-size: 28px;
	font-weight: bold;
	margin-bottom: 5px;
}

.footer-brand p {
	font-size: 14px;
	color: #aaa;
}

.footer-links {
	display: flex;
	flex: 2;
	justify-content: space-around;
}

.footer-column h4 {
	font-size: 16px;
	margin-bottom: 10px;
	color: #fff;
}

.footer-column ul {
	list-style: none;
}

.footer-column li {
	margin-bottom: 5px;
}

.footer-column a {
	color: #aaa;
	text-decoration: none;
	font-size: 13px;
}

.footer-copyright {
	width: 100%;
	text-align: right;
	margin-top: 30px;
	font-size: 14px;
	font-weight: bold;
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
		</div>

		<form:form action="${contextPath}/member/loginProcess" method="post" class="login-form">
			<input type="text" name="memId" placeholder="아이디" required> <input
				type="password" name="memPw" placeholder="비밀번호" required>
			<button type="submit" class="login-btn">로그인</button>

			<div class="login-options">
				<label><input type="checkbox" name="stayLoggedIn">
					로그인 유지</label> <a href="#">아이디/비밀번호 찾기</a>
			</div>
		</form:form>

		<div class="signup-link">
			<a href="${contextPath}/member/register">회원가입</a>
		</div>
	</div>

	<footer class="footer">
		<div class="footer-content">
			<div class="footer-brand">
				<div class="footer-logo-text">캠둘기</div>
				<p>대학생들의 소통 공간</p>
			</div>
			<div class="footer-links">
				<div class="footer-column">
					<h4>고객지원</h4>
					<ul>
						<li><a href="#">공지사항</a></li>
						<li><a href="#">Q&A(문의하기)</a></li>
					</ul>
				</div>
				<div class="footer-column">
					<h4>정보</h4>
					<ul>
						<li><a href="#">이용약관</a></li>
						<li><a href="#">개인정보처리방침</a></li>
					</ul>
				</div>
			</div>
			<div class="footer-copyright">&copy; 2026 캠둘기. All rights
				reserved.</div>
		</div>
	</footer>
</body>
</html>