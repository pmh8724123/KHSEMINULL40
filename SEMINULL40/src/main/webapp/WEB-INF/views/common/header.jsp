<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="path" value="${pageContext.request.contextPath}" />

<style>
/* 헤더 */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: "Arial", sans-serif;
}


.header {
	background: #fff;
	border: 2px solid #4a90e2;
	border-radius: 20px;
	padding: 15px;
}

.top-bar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	
}

.left {
	display: flex;
	align-items: center;
	gap: 10px;
}

.profile {
	width: 40px;
	height: 40px;
	background: #ccc;
	border-radius: 50%;
	background-image: url('${path}/resources/images/logoImg.png');
	background-size: cover;
    background-position: center;
}

.logo {
	font-weight: bold;
	font-size: 32px;
}

.right {
	display: flex;
	align-items: center;
	gap: 10px;
}

.logout {
	padding: 5px 10px;
	border: 1px solid #aaa;
	background: #fff;
	border-radius: 5px;
	cursor: pointer;
}

/* 🔥 추가 (빠져있던 부분) */
.search-box {
	margin: 15px auto;
	display: flex;
	justify-content: center;
}

.search-box input {
	width: 300px;
	padding: 10px;
	border: 1px solid #4a90e2;
	border-radius: 20px 0 0 20px;
	outline: none;
}

.search-box button {
	padding: 10px;
	border: 1px solid #4a90e2;
	border-left: none;
	border-radius: 0 20px 20px 0;
	cursor: pointer;
}

.menu {
	display: flex;
	justify-content: space-around;
	margin-top: 10px;
}

.menu a {
	text-decoration: none;
	color: #333;
}
</style>

<!-- 상단 헤더 -->
<header class="header">
	<div class="top-bar">
		<div class="left">
			<div class="profile"></div>
			<span class="logo">
				
				<a href="${path}/" style="text-decoration:none; color:black;">캠둘기</a>
			</span>
		</div>
		
		<!-- 접속 권한이 관리자일때  -->
		
		
		
		
		<!-- 접속 권한이 회원일때 -->
		<!-- 접속 권한 : 회원일때 보이게 하고 그에 맞는 데이터 갖고오기 -->
		<div class="right">
			<span class="school">
				<sec:authentication property="principal.member.memName"/>님 /
				<sec:authentication property="principal.member.uniName"/>
			</span>
			<form:form action="${contextPath}/member/logout" method="post">
				<button type="submit" class="logout">로그아웃</button>			
			</form:form>
		</div>
	</div>

	<!-- 검색 -->
	<div class="search-box">
		<input type="text" placeholder="게시물 검색">
		<button>🔍</button>
	</div>

	<!-- 메뉴 -->
	<!-- 회원이 아닌 사람이 누르면 로그인 페이지 뜨게 출력하기 -->
	<!-- 각 페이지 경로 맞춰서 하세요 -->
	<nav class="menu">
		<a href="${path}/board/list">게시판</a>
		<a href="${path}/rating">평가</a>
		<a href="${path}/timetable">시간표</a>
		<a href="${path}/mypage">마이페이지</a>
		<a href="${path}/notice">공지사항</a>
	</nav>
</header>