<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<meta charset="UTF-8">

<div class="sidebar">

    <h2>회원 관리</h2>
    <a href="${pageContext.request.contextPath}/admin/memberStatus">회원 상태 관리</a>
    <a href="${pageContext.request.contextPath}/admin/memberJoin">회원 가입 관리</a>

    <h2>학교 관리</h2>
    <sec:authorize access="hasRole('MASTER')">
    <a href="${pageContext.request.contextPath}/admin/university">학교 관리</a>
    </sec:authorize>
    <a href="${pageContext.request.contextPath}/admin/department">학과 관리</a>
    <a href="${pageContext.request.contextPath}/admin/lecture">강의 관리</a>
    
    <h2>게시판 관리</h2>    
    <a href="notice">공지사항</a>
	<a href="${pageContext.request.contextPath}/admin/board">게시판 관리</a>
    
    <h2>신고 관리</h2>
    <a href="${pageContext.request.contextPath}/admin/report">신고 내역</a>
</div>