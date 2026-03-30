<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신고 내역</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/admin.css">

</head>

<body>
	<jsp:include page="/WEB-INF/views/admin/common/header.jsp" />

	<c:if test="${not empty msg}">
		<div id="toast-overlay">
			<div id="toast-box" class="${type}">${msg}</div>
		</div>
	</c:if>

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
					</select> <input type="text" placeholder="검색어 입력">
					<button>검색</button>
				</div>

				<!-- 모달 -->
				<button type="button" onclick="openModal('departmentInsertModal')">학과추가</button>

				<div id="departmentInsertModal" class="modal">
					<div class="modal-content">

						<h3>학과 추가</h3>

						<form
							action="${pageContext.request.contextPath}/admin/department/insert"
							method="post">

							<input type="hidden" name="${_csrf.parameterName}"
								value="${_csrf.token}"> 학과명: <input type="text"
								name="deptName"><br>

							<button type="submit" class="insert-btn">추가</button>
							<button type="button"
								onclick="closeModal('departmentInsertModal')" class="exit-btn">취소</button>
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
									<div class="action-box">
										<button type="button"
											onclick="openModal('departmentUpdateModal${d.deptNo}')"
											class="btn btn-approve">수정</button>

										<div id="departmentUpdateModal${d.deptNo}" class="modal">
											<div class="modal-content">

												<h3>학과 수정</h3>

												<form
													action="${pageContext.request.contextPath}/admin/department/update" method="post">

													<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
													<input type="hidden" name="deptNo" value="${d.deptNo}"> 학과명: 
													<input type="text" name="deptName" value="${d.deptName}"><br>

													<button type="submit" class="btn btn-approve">수정</button>
													<button type="button" onclick="closeModal('departmentUpdateModal${d.deptNo}')" class="exit-btn">취소</button>
												</form>

											</div>
										</div>

										<form
											action="${pageContext.request.contextPath}/admin/department/delete"
											method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">

											<input type="hidden" name="${_csrf.parameterName}"
												value="${_csrf.token}" /> <input type="hidden"
												name="deptNo" value="${d.deptNo}">
											<button class="btn btn-delete" type="submit">삭제</button>
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