<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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

	<div class="container">
		<jsp:include page="/WEB-INF/views/admin/common/sidebar.jsp" />
		<div class="content">

			<h2>강의 관리</h2>

			<div class="filter-box">
				<div class="filter-left">

					<select>
						<option>전체</option>
						<option>강의번호</option>
						<option>강의명</option>
						<option>교수명</option>
					</select> <input type="text" placeholder="검색어 입력">
					<button>검색</button>
				</div>

				<!-- 모달 -->
				<button type="button" onclick="openModal('lectureInsertModal')">강의추가</button>

				<div id="lectureInsertModal" class="modal">
					<div class="modal-content">

						<h3>강의 추가</h3>

						<form
							action="${pageContext.request.contextPath}/admin/lecture/insert"
							method="post">

							<input type="hidden" name="${_csrf.parameterName}"
								value="${_csrf.token}"> 강의명: <input type="text"
								name="lectureName"><br> 교수명: <input type="text"
								name="professorName"><br> 강의요일: <select name="days">
								<option value="MON">월</option>
								<option value="TUE">화</option>
								<option value="WED">수</option>
								<option value="THU">목</option>
								<option value="FRI">금</option>
							</select><br>
							<br> 시작시간: <input type="date" name="startTime"><br>
							종료시간: <input type="date" name="endTime"><br> 강의실: <input
								type="text" name="lectureRoom"><br>

							<button type="submit" class="insert-btn">등록</button>
							<button type="button" onclick="closeModal('lectureInsertModal')"
								class="exit-btn">취소</button>
						</form>

					</div>
				</div>
			</div>

			<div class="table-container">
				<table>
					<thead>
						<tr>
							<th>강의번호</th>
							<th>강의명</th>
							<th>교수명</th>
							<th>요일</th>
							<th>시작시간</th>
							<th>종료시간</th>
							<th>강의실</th>
							<th>처리</th>
						</tr>
					</thead>

					<tbody>
						<c:forEach var="l" items="${list}">
							<tr>
								<td>${l.lectureNo}</td>
								<td>${l.lectureName}</td>
								<td>${l.professorName}</td>
								<td><fmt:formatDate value="${l.days}" pattern="EEEE" /></td>
								<td><fmt:formatDate value="${l.startTime}" pattern="HH:mm" /></td>
								<td><fmt:formatDate value="${l.endTime}" pattern="HH:mm" /></td>
								<td>${l.lectureRoom}</td>
								<td>
									<button class="btn btn-approve">수정</button>
									<form
										action="${pageContext.request.contextPath}/admin/department/delete"
										method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">

										<input type="hidden" name="${_csrf.parameterName}"
											value="${_csrf.token}" /> <input type="hidden" name="deptNo"
											value="${d.deptNo}">
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