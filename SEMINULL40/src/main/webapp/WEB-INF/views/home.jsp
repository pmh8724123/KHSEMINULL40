<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>캠둘기</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home.css">
</head>
<body>

	<div class="container">
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
		<!-- 광고 영역 -->
		<aside class="ad left-ad">광고 텍스트</aside>
		<aside class="ad right-ad">광고 텍스트</aside>

		<!-- 메인 영역 -->
		<main class="content"></main>

	</div>
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>

