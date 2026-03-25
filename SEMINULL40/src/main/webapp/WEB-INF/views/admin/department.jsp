<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신고 내역</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">

</head>

<body>
	<jsp:include page="/WEB-INF/views/admin/common/header.jsp" />

	<div class="container">
		<jsp:include page="/WEB-INF/views/admin/common/sidebar.jsp" />
		<div class="content">

			<h2>학과 관리</h2>

			<div class="filter-box">
				<div class="filter-left">

					<select>
						<option>전체</option>
						<option>학과이름</option>
						<option>작성자</option>
					</select> 
					<input type="text" placeholder="검색어 입력">
					<button>검색</button>
				</div>
				
				<!-- 모달 -->
				<button type="button" onclick="openModal('departmentModal')">학과추가</button>

				<div id="departmentModal" class="modal">
					<div class="modal-content">

						<h3>학과 추가</h3>

						<form action="${pageContext.request.contextPath}/admin/department/insert" method="post">
    
						    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
						    
   						    학과명: <input type="text" name="deptName"><br>
						
						    <button type="submit" class="insert-btn">등록</button>
							<button type="button" onclick="closeModal('departmentModal')" class="exit-btn">취소</button>
						</form>

					</div>
				</div>

			</div>

			<div class="table-container">
			<table>
				<thead>
					<tr>
						<th>NO</th>
						<th>학과이름</th>
						<th>처리</th>
					</tr>
				</thead>

				<tbody>
					<c:forEach var="d" items="${list}" varStatus="status">
					<tr>
						<td>${status.index + 1}</td>
						<td>${d.deptName}</td>
						<td>
							<button class="btn btn-approve">수정</button>
							<button class="btn btn-reject">삭제</button>
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