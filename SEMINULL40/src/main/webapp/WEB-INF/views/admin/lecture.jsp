<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>강의 관리</title>
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

			<h2>강의 관리</h2>

			<div class="filter-box">
				<div class="filter-left">
					<form action="${pageContext.request.contextPath}/admin/lecture" method="get">
						<select name="condition">
							<option value="all" ${condition == 'all' ? 'selected' : ''}>전체</option>
							<option value="deptName" ${condition == 'deptName' ? 'selected' : ''}>학과명</option>
							<option value="lectureName" ${condition == 'lectureName' ? 'selected' : ''}>강의명</option>
							<option value="professorName" ${condition == 'professorName' ? 'selected' : ''}>교수명</option>
						</select>
						<input type="text" name="keyword" value="${keyword}" placeholder="검색어 입력">
						<button type="submit">검색</button>
					</form>
				</div>

				<c:if test="${loginUser.uniNo != 0}">
					<button type="button" onclick="openModal('lectureInsertModal')">강의추가</button>
				</c:if>

				<!-- 강의 추가 모달 -->
				<div id="lectureInsertModal" class="modal">
					<div class="modal-content">

						<h3>강의 추가</h3>

						<form action="${pageContext.request.contextPath}/admin/lecture/insert" method="post">
							<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

							학과:
							<select name="deptNo" required>
								<option value="">학과 선택</option>
								<c:forEach var="d" items="${deptList}">
									<option value="${d.deptNo}">${d.deptName}</option>
								</c:forEach>
							</select>
							<br>

							강의명:
							<input type="text" name="lectureName" required>
							<br>

							교수명:
							<input type="text" name="professorName" required>
							<br>

							<button type="submit" class="insert-btn">등록</button>
							<button type="button" onclick="closeModal('lectureInsertModal')" class="exit-btn">취소</button>
						</form>

					</div>
				</div>

				<!-- 강의 수정 모달 -->
				<div id="lectureUpdateModal" class="modal">
					<div class="modal-content">

						<h3>강의 수정</h3>

						<form action="${pageContext.request.contextPath}/admin/lecture/update" method="post">
							<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
							<input type="hidden" name="lectureNo" id="updateLectureNo">

							학과:
							<select name="deptNo" id="updateDeptNo" required>
								<option value="">학과 선택</option>
								<c:forEach var="d" items="${deptList}">
									<option value="${d.deptNo}">${d.deptName}</option>
								</c:forEach>
							</select>
							<br>

							강의명:
							<input type="text" name="lectureName" id="updateLectureName" required>
							<br>

							교수명:
							<input type="text" name="professorName" id="updateProfessorName" required>
							<br>

							<button type="submit" class="insert-btn">수정</button>
							<button type="button" onclick="closeModal('lectureUpdateModal')" class="exit-btn">취소</button>
						</form>

					</div>
				</div>
			</div>

			<div class="table-container">
				<table>
					<thead>
						<tr>
							<th>NO</th>
							<c:if test="${loginUser.uniNo == 0}">
								<th>대학교명</th>
							</c:if>
							<th>학과명</th>
							<th>강의명</th>
							<th>교수명</th>
							<th>처리</th>
						</tr>
					</thead>

					<tbody>
						<c:forEach var="l" items="${list}" varStatus="status">
							<tr>
								<td>${status.index + 1}</td>
								<c:if test="${loginUser.uniNo == 0}">
									<td>${l.uniName}</td>
								</c:if>
								<td>${l.deptName}</td>
								<td>${l.lectureName}</td>
								<td>${l.professorName}</td>
								<td>
									<c:if test="${loginUser.uniNo != 0}">
									<button type="button" class="btn btn-approve"
										onclick="openLectureUpdateModal('${l.lectureNo}', '${l.deptNo}', '${l.lectureName}', '${l.professorName}')">
										수정
									</button>
									</c:if>

									<form action="${pageContext.request.contextPath}/admin/lecture/delete"
										method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');"
										style="display:inline;">
										<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
										<input type="hidden" name="lectureNo" value="${l.lectureNo}">
										<button class="btn btn-delete" type="submit">삭제</button>
									</form>
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