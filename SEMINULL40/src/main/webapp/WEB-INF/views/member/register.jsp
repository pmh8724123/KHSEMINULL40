<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>캠둘기 회원가입</title>
<style>
/* 기본 스타일 리셋 */
body, h1, p {
	margin: 0;
	padding: 0;
	font-family: 'Pretendard', sans-serif;
}

body {
	background-color: #f0f5ff;
	display: flex;
	flex-direction: column;
	min-height: 1100px;
	align-items: center;
}

/* 컨테이너 */
.container {
	width: 100%;
	max-width: 500px;
	padding: 40px 20px;
	flex: 1;
}

.header-title {
	text-align: center;
	font-size: 28px;
	margin-bottom: 40px;
	font-weight: bold;
}

/* 입력 폼 스타일 */
.form-group {
	margin-bottom: 20px;
}

input[type="text"], input[type="password"], input[type="email"] {
	width: 100%;
	padding: 15px;
	border: 1px solid #ccc;
	border-radius: 8px;
	box-sizing: border-box;
	font-size: 14px;
	outline: none;
}

.error-msg {
	color: #ff4d4d;
	font-size: 12px;
	margin-top: 5px;
	margin-left: 5px;
}

select {
	width: 100%;
	padding: 15px;
	border: 1px solid #ccc;
	border-radius: 8px;
	box-sizing: border-box;
	font-size: 14px;
	outline: none;
	background-color: white;
	cursor: pointer;
	appearance: none;
	background-image:
		url("data:image/svg+xml;utf8,<svg fill='%2338a5ff' height='20' viewBox='0 0 24 24' width='20' xmlns='http://www.w3.org/2000/svg'><path d='M7 10l5 5 5-5z'/></svg>");
	background-repeat: no-repeat;
	background-position: right 10px center;
}

/* 포커스 시 */
select:focus {
	border-color: #38a5ff;
}

/* 옵션 스타일 (일부 브라우저 제한 있음) */
select option {
	font-size: 14px;
}

/* 이메일 영역 (인증 버튼 포함) */
.email-row {
	display: flex;
	gap: 10px;
	align-items: flex-start;
}

.email-row input {
	flex: 1;
}

.btn-verify {
	background-color: #38a5ff;
	color: white;
	border: none;
	padding: 15px 20px;
	border-radius: 8px;
	cursor: pointer;
	font-weight: bold;
	white-space: nowrap;
}

/* 가입하기 버튼 */
.btn-submit {
	width: 100%;
	background-color: #e8f9ed;
	color: #333;
	border: none;
	padding: 18px;
	border-radius: 8px;
	font-size: 18px;
	font-weight: bold;
	cursor: pointer;
	margin-top: 20px;
}

/* 로그인 유도 링크 */
.login-link {
	text-align: center;
	margin-top: 20px;
	font-size: 13px;
	color: #666;
}

.login-link a {
	color: #38a5ff;
	text-decoration: none;
	font-weight: bold;
}

/* 푸터 스타일 */
footer {
	width: 100%;
	background-color: #1a1a1a;
	color: #fff;
	padding: 30px 0;
	display: flex;
	justify-content: space-around;
	font-size: 12px;
	margin-top: 50px;
}

.footer-logo {
	font-size: 20px;
	font-weight: bold;
}

.footer-info {
	display: flex;
	gap: 40px;
}

.info-section h4 {
	color: #ccc;
	margin-bottom: 10px;
}

.info-section p {
	color: #888;
	line-height: 1.6;
	cursor: pointer;
}
</style>
</head>
<body data-context-path="${pageContext.request.contextPath}">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<c:set var="contextPath" value="${pageContext.request.contextPath}"
		scope="application" />
	<div class="container">
		<h1 class="header-title">캠둘기 회원가입</h1>

		<form:form action="${contextPath}/member/register" method="post" modelAttribute="member" id="registerForm">


			<div class="form-group">
				<input type="text" name="memId" id="memId" placeholder="아이디">
				<div class="error-msg" id="idMsg">
					<p>아이디를 입력해 주세요</p>
				</div>
			</div>

			<div class="form-group">
				<input type="password" name="memPw" id="memPw" placeholder="비밀번호"
					style="margin-bottom: 10px;"> <input type="password"
					name="memPwConfirm" id="memPwConfirm" placeholder="비밀번호 재입력">
				<div class="error-msg" id="pwMsg">비밀번호를 입력해 주세요</div>
			</div>

			<div class="form-group">
				<input type="text" name="memName" id="memName" placeholder="이름">
				<div class="error-msg" id="nameMsg">이름을 입력해 주세요</div>
			</div>

			<div class="form-group">
				<select name="uniNo" id="uniSelect">
					<option value="">학교 선택</option>
					<c:forEach var="uni" items="${uniList}">
						<option value="${uni.uniNo}">${uni.uniName}</option>
					</c:forEach>
				</select>
				<div class="error-msg" id="uniMsg">학교를 선택해 주세요</div>
			</div>

			<div class="form-group">
				<select name="deptNo" id="deptSelect">
					<option value="">학과 선택</option>
				</select>
				<div class="error-msg" id="deptMsg">학과를 선택해 주세요</div>
			</div>

			<div class="form-group">
				<input type="text" name="studentNo" id="studentNo" placeholder="학번">
				<div class="error-msg" id="snoMsg">학번을 입력해 주세요</div>
			</div>

			<div class="form-group">
				<input type="text" name="phone" id="phone" placeholder="전화번호">
				<div class="error-msg" id="phoneMsg">
					전화번호를 입력해주세요.<br>ex) 010-0000-0000
				</div>
			</div>

			<button type="submit" class="btn-submit">가입하기</button>

			<p class="login-link">
				이미 회원이신가요? <a href="${contextPath}">로그인</a>
			</p>
		</form:form>


	</div>
	
	<c:if test="${not empty requestScope['org.springframework.validation.BindingResult.member'].fieldErrors}">
    	<script>
     	   alert("${requestScope['org.springframework.validation.BindingResult.member'].fieldErrors[0].defaultMessage}");
    	</script>
	</c:if>

	<script src="${contextPath}/resources/js/register.js"></script>

	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>