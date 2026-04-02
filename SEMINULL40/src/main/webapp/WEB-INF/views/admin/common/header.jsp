<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<meta charset="UTF-8">
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
    
<div class="header">

    <div class="header-container">

        <div class="header-left">
            <button onclick="location.href='main'">🏠HOME</button>
        </div>

        <div class="header-center">
            <h2>캠둘기 관리자 페이지</h2>
        </div>

        <div class="header-right">
            <span>
                <b>👤 관리자 : <sec:authentication property="principal.member.memId"/></b>
            </span>
			
			<!-- 수정필요 -->
            <button onclick="location.href='${pageContext.request.contextPath}'">로그아웃</button>
            
        </div>

    </div>

</div>