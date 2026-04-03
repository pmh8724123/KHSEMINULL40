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

	<c:if test="${not empty msg}">
		<div id="toast-overlay">
			<div id="toast-box" class="${type}">${msg}</div>
		</div>
	</c:if>

	<div class="container">
		<jsp:include page="/WEB-INF/views/admin/common/sidebar.jsp" />
		<div class="content">

			<h2>신고 내역</h2>

			<div class="table-container">

				<table>
					<thead>
						<tr>
							<th>NO</th>
							<c:if test="${loginUser.uniNo == 0}">
								<th>대학교명</th>
							</c:if>
							<th>컨텐츠 유형</th>
							<th>작성자</th>
							<th>작성 날짜</th>
							<th>신고 사유</th>
							<th>신고자</th>
							<th>신고 날짜</th>
							<th>처리</th>
						</tr>
					</thead>

					<tbody>
						<c:forEach var="r" items="${list}" varStatus="status">
							<tr>
								<td>${status.index + 1}</td>
								<c:if test="${loginUser.uniNo == 0}">
									<td>${r.uniName}</td>
								</c:if>
								<td>${r.contentType}</td>
								<td>${r.writerName}</td>
								<td>
									<fmt:formatDate value="${r.contentCreateDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
								<td>${r.reasonName}</td>
								<td>${r.reportMemName}</td>
								<td>
									<fmt:formatDate value="${r.reportDate}" pattern="yyyy-MM-dd HH:mm:ss" />
								</td>
								<td>
									<button class="btn btn-approve" type="button"
										onclick="location.href='${pageContext.request.contextPath}/board/detail?boardno=${r.boardNo}'">
										바로가기</button>

									<form
										action="${pageContext.request.contextPath}/admin/report/delete" method="post" style="display: inline;">
										<input type="hidden" name="reportNo" value="${r.reportNo}">
										<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
										<button class="btn btn-delete" type="submit"
											onclick="return confirm('이 신고 내역을 삭제하시겠습니까?');">삭제</button>
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