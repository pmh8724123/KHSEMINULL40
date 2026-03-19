<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link rel="stylesheet" href="/resources/admin.css">
</head>

<body>

<div class="container">

    <!-- 사이드 메뉴 -->
    <div class="sidebar">

        <h2>회원 관리</h2>
        <a href="memberStatus">회원 상태 관리</a>
        <a href="memberJoin">회원 가입 관리</a>

        <h2>학교 관리</h2>
        <a href="category">게시판 카테고리</a>
        <a href="department">학과 관리</a>
        <a href="class">수업 관리</a>
        <a href="notice">공지사항</a>

        <h2>신고 관리</h2>
        <a href="report">신고 내역</a>

    </div>

    <!-- 콘텐츠 영역 -->
    <div class="content">
        <h2>관리자 대시보드</h2>
        <p>왼쪽 메뉴를 선택하세요.</p>
    </div>

</div>

</body>
</html>