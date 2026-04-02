<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>대학 관리</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/admin.css">

</head>

<body>
	<jsp:include page="/WEB-INF/views/admin/common/header.jsp" />

	<c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>

	<c:if test="${not empty msg}">
		<div id="toast-overlay">
			<div id="toast-box" class="${type}">${msg}</div>
		</div>
	</c:if>

	<div class="container">
		<jsp:include page="/WEB-INF/views/admin/common/sidebar.jsp" />
		<div class="content">

			<h2>학교 관리</h2>

			<div class="filter-box">
				<div class="filter-left">
					<form action="${contextPath}/admin/university">
						<select name="condition">
							<option value="all" ${condition == 'all' ? 'selected' : ''}>전체</option>
							<option value="uniName" ${condition == 'uniName' ? 'selected' : ''}>학교 이름</option>
							<option value="memId" ${condition == 'memId' ? 'selected' : ''}>관리자 아이디</option>
						</select>
						<input type="text" name="keyword" value="${condition != 'all' ? keyword : ''}" placeholder="검색어 입력">
						<button type="submit">검색</button>
					</form>
				</div>

				<!-- 모달 -->
				<button type="button" onclick="openModal('uniInsertModal')">학교추가</button>

				<div id="uniInsertModal" class="modal">
					<div class="modal-content">

						<h3>학교 추가</h3>

						<form:form action="${contextPath}/admin/university/insert" method="post">
							학교명:<br> <input type="text" name="uniName"><br>
							관리자 ID:<br> <input type="text" name="memId"><br>
							관리자 이름:<br> <input type="text" name="memName"><br>

							<br>
							
							<button type="submit" class="insert-btn">추가</button>
							<button type="button" onclick="closeModal('uniInsertModal')" class="exit-btn">취소</button>
						</form:form>
					</div>
				</div>

			</div>

			<div class="table-container">
				<table>
					<thead>
						<tr>
							<th>NO</th>
							<th>학교 이름</th>
							<th>관리자 ID</th>
							<th>회원 수</th>
							<th>상태</th>
							<th>처리</th>
						</tr>
					</thead>

					<tbody>
						<c:forEach var="uni" items="${list}" varStatus="status">
							<tr>
								<td>${uni.uniNo}</td>
								<td>${uni.uniName}</td>
								<td>${uni.memId}</td>
								<td>${uni.count}</td>
								<td>${uni.status}</td>
								<td>
									<div class="action-box">
										<button type="button"
											onclick="openModal('uniUpdateModal${uni.uniNo}')"
											class="btn btn-approve">수정</button>

										<div id="uniUpdateModal${uni.uniNo}" class="modal">
											<div class="modal-content">

												<h3>학교 정보 수정</h3>

												<form:form action="${contextPath}/admin/university/update" method="post">
													<input type="hidden" name="uniNo" value="${uni.uniNo}">
													학과명: <input type="text" name="uniName" value="${uni.uniName}">
													<br>
													<button type="submit" class="btn btn-approve">수정</button>
													<button type="button" onclick="closeModal('uniUpdateModal${uni.uniNo}')" class="exit-btn">취소</button>
												</form:form>
											</div>
										</div>
										
										<c:set var="csmsg" value="${uni.status.toString() eq 'Y' ? '정말 비활성화 하시겠습니까?' : '정말 활성화 하시겠습니까?'}"/>
										
										<form:form action="${contextPath}/admin/university/changeStatus" method="post" onsubmit="return confirm('${csmsg}');">											
											<input type="hidden" name="uniNo" value="${uni.uniNo}">
											<input type="hidden" name="status" value="${uni.status}">
											<button class="btn btn-delete" type="submit">${uni.status.toString() eq 'Y' ? '비활성화' : '활성화'}</button>
										</form:form>
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