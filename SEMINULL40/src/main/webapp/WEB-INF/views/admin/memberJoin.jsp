<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 가입 승인</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/admin.css">

</head>

<body>

	<!-- 헤더 -->
	<jsp:include page="/WEB-INF/views/admin/common/header.jsp" />
	
	<!-- Toast 메시지 -->
	<c:if test="${not empty msg}">
    <div id="toast-overlay">
        <div id="toast-box" class="${type}">
            ${msg}
        </div>
    </div>
	</c:if>
	
	<div class="container">

		<!-- 사이드바 -->
		<jsp:include page="/WEB-INF/views/admin/common/sidebar.jsp" />

		<!-- 콘텐츠 -->
		<div class="content">

			<h2>회원 가입 승인</h2>

			<!-- 검색/필터 영역 -->
			<div class="filter-box">
				<div class="filter-left">
					<select>
						<option>전체</option>
						<option>아이디</option>
						<option>학교</option>
					</select> <input type="text" placeholder="검색어 입력">
					<button>검색</button>
				</div>
			</div>

			<!-- 테이블 영역 -->
			<div class="table-container">

				<table>
					<thead>
						<tr>
							<th>회원번호</th>
							<th>아이디</th>
							<th>학번</th>
							<th>이름</th>
							<th>학교</th>
							<th>학과</th>
							<th>전화번호</th>
							<th>가입요청일</th>
							<th>상태</th>
							<th>변경</th>
						</tr>
					</thead>
					
					<tbody>
						<c:forEach var="m" items="${list}">
							<tr>
								<td>${m.memNo}</td>
								<td>${m.memId}</td>
								<td>${m.studentNo}</td>
								<td>${m.memName}</td>
								<td>${m.uniName}</td>
								<td>${m.deptNo}</td>
								<td>${m.phone}</td>
								<td><fmt:formatDate value="${m.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
								<td>${m.status}</td>
								<td>
								<div class="action-box"> 
									<!-- 회원가입요청승인 -->
									<form action="${pageContext.request.contextPath}/admin/member/join/approve" method="post">
									    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
									    <input type="hidden" name="memNo" value="${m.memNo}">
									    <button class="btn btn-approve" type="submit">승인</button>
									</form>
									<!-- 회원가입요청 거절 -->
									<form action="${pageContext.request.contextPath}/admin/member/join/reject" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
									    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
									    <input type="hidden" name="memNo" value="${m.memNo}">
									    <button class="btn btn-delete" type="submit">거절</button>
									</form>
								</div>	
								</td>
							</tr>
						</c:forEach>
					</tbody>

				</table>

			</div>

		</div>
	</div>
	
	<script src="${pageContext.request.contextPath}/resources/js/admin.js"></script>
</body>
</html>