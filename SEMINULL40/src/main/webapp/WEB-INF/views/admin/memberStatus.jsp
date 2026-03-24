<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 상태 관리</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/admin.css">

</head>

<body>
	<jsp:include page="/WEB-INF/views/admin/common/header.jsp" />
	
	<!-- 🔥 Toast 메시지 -->
	<c:if test="${not empty msg}">
    <div id="toast-overlay">
        <div id="toast-box" class="${type}">
            ${msg}
        </div>
    </div>
	</c:if>
	
	<div class="container">


		<jsp:include page="/WEB-INF/views/admin/common/sidebar.jsp" />
		<div class="content">

			<h2>회원 상태 관리</h2>

			<!-- 🔥 검색/필터 영역 -->
			<div class="filter-box">
				<div class="filter-left">
					<select>
						<option>전체</option>
						<option>아이디</option>
						<option>이름</option>
						<option>학과</option>
						<option>전화번호</option>
						<option>이메일</option>
						<option>상태</option>
					</select> <input type="text" placeholder="검색어 입력">
					<button>검색</button>
				</div>
			</div>

			<!-- 🔥 테이블 영역 -->
			<div class="table-container">

				<table>
					<thead>
						<tr>
							<th>회원번호</th>
							<th>아이디</th>
							<th>이름</th>
							<th>학교</th>
							<th>학과</th>
							<th>전화번호</th>
							<th>이메일</th>
							<th>생성날짜</th>
							<th>상태(활성/정지/탈퇴)</th>
							<th>변경</th>
						</tr>
					</thead>

					<tbody>
						<c:forEach var="m" items="${list}">
							<tr>
								<td>${m.memNo}</td>
								<td>${m.memId}</td>
								<td>${m.memName}</td>
								<td>${m.uniName}</td>
								<td>${m.deptNo}</td>
								<td>${m.phone}</td>
								<td>${m.email}</td>
								<td>${m.createDate}</td>
								<td>${m.status}</td>
								<td>
									<form
										action="${pageContext.request.contextPath}/admin/member/status" method="post">
									    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
										<input type="hidden" name="memNo" value="${m.memNo}">
										<input type="hidden" name="status" value="Y">
										<button class="btn btn-approve" type="submit">활성</button>
									</form>
									
									<form
										action="${pageContext.request.contextPath}/admin/member/status" method="post">
									    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
										<input type="hidden" name="memNo" value="${m.memNo}">
										<input type="hidden" name="status" value="N">
										<button class="btn btn-reject" type="submit">탈퇴</button>
									</form>
								</td>

							</tr>
						</c:forEach>

					</tbody>

				</table>
			</div>
		</div>
	</div>
	
	<script>
    const overlay = document.getElementById("toast-overlay");

    if (overlay) {
        setTimeout(() => {
            overlay.style.display = "none";
        }, 1500); // 1.5초 후 사라짐
    }
	</script>
	
</body>
</html>