<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
</head>

<body>
	<!-- 헤더 영역 -->
<jsp:include page="/WEB-INF/views/common/admin/header.jsp" />

    <!-- 사이드바 영역 -->
<jsp:include page="/WEB-INF/views/common/admin/sidebar.jsp" />


<div class="container">

    <!-- 콘텐츠 영역 -->
    <div class="content">
        <h2>관리자 대시보드</h2>
        <p>왼쪽 메뉴를 선택하세요.</p>
    </div>

</div>

</body>
</html>