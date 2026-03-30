<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<title>회원가입 승인 대기</title>

<style>
body {
	font-family: 'Arial';
	background-color: #f5f6fa;
	display: flex;
	flex-direction: column;
	justify-content: center;
	min-height: 100vh;
	align-items: center;
	height: 100vh;
}

.container {
	background: white;
	padding: 40px;
	border-radius: 12px;
	text-align: center;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

h2 {
	color: #2f3640;
}

p {
	margin-top: 15px;
	color: #636e72;
}

.btn {
	margin-top: 20px;
	padding: 10px 20px;
	border: none;
	background-color: #0984e3;
	color: white;
	border-radius: 6px;
	cursor: pointer;
}
</style>
</head>
<body>

	<div class="container">
		<h2>⏳ 승인 대기 중입니다</h2>

		<p>
			현재 관리자 승인 후 이용 가능합니다.<br> 조금만 기다려주세요!
		</p>

		<form:form action="${pageContext.request.contextPath}/member/logout"
			method="post">
			<button type="submit" class="btn">메인으로 이동</button>
		</form:form>


	</div>
</body>
</html>