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

<div class="header">

    <div class="header-container">

        <!-- 좌측 -->
        <div class="header-left">
            <button onclick="location.href='/'">🏠HOME</button>
        </div>

        <!-- 가운데 -->
        <div class="header-center">
            <h2>캠둘기 관리자 페이지</h2>
        </div>

        <!-- 우측 -->
        <div class="header-right">
            <span>
                <b>👤 관리자 : 박무혁<%-- ${loginAdmin.adminName} --%></b>
                (pmh8724)<%-- (${loginAdmin.adminId}) --%>
            </span>

            <button onclick="location.href='logout'">로그아웃</button>
        </div>

    </div>

</div>


</body>
</html>