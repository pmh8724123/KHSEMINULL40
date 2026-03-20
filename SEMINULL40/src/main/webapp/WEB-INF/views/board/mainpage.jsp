<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>

<!DOCTYPE html>
<html>
<head>

<c:set var="path" value="${pageContext.request.contextPath}" />


<meta charset="UTF-8">
<title>캠둘기</title>
<link rel="stylesheet"
	href="${path}/resources/css/mainpage.css">

<style>

/* 광고 이미지 */
.left-ad {
	left: -100px;
	background-image: url('${path}/resources/images/adleft.jpg');
}

.right-ad {
	right: -100px;
	background-image: url('${path}/resources/images/adright.jpg');
}
</style>

</head>
<body>

	<div class="container">
		<jsp:include page="/WEB-INF/views/common2/header.jsp" />
		<!-- 광고 영역 -->

		<!-- 메인 영역 -->
		<main class="content"></main>

	</div>
	<jsp:include page="/WEB-INF/views/common2/footer.jsp" />
</body>
</html>

