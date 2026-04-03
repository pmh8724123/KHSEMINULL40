<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
</head>

<body>

	<jsp:include page="/WEB-INF/views/admin/common/header.jsp" />

	<div class="container">

		<jsp:include page="/WEB-INF/views/admin/common/sidebar.jsp" />

		<div class="content">

			<h2>📊 관리자 대시보드</h2>

			<!-- 🔥 카드 영역: DB 데이터 반영 -->
			<div class="dashboard">

				<div class="card">
					<h3>👥 총 회원</h3>
					<p class="number">${counts.TOTAL_MEM}명</p>
				</div>

				<div class="card">
					<h3> 가입대기</h3>
					<p class="number">${counts.PENDING_MEM}건</p>
				</div>

				<div class="card">
					<h3>⛔ 정지 회원</h3>
					<p class="number">${counts.BANNED_MEM}명</p>
				</div>

				<div class="card">
					<h3>🚨 신고 건수</h3>
					<p class="number">${counts.REPORT_COUNT}건</p>
				</div>

				<div class="card">
					<h3>📝 게시글</h3>
					<p class="number">${counts.BOARD_COUNT}개</p>
				</div>

				<div class="card">
					<h3>🏫 학교 </h3>
					<p class="number">${counts.UNI_COUNT}곳</p>
				</div>

			</div>

			<!-- 🔥 최근 신고: DB 데이터 반복문 출력 -->
			<div class="recent-box">
				<h3>🚨 최근 신고 (최신 5건)</h3>

				<table>
					<thead>
						<tr>
							<th>번호</th>
							<th>신고자</th>
							<th>사유</th>
							<th>날짜</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${not empty reports}">
								<c:forEach var="r" items="${reports}" varStatus="status">
									<tr>
										<td>${status.index + 1}</td>
										<td>${r.MEM_ID}</td>
										<td>${r.REASON_NAME}</td>
										<td>
											<fmt:formatDate value="${r.CREATE_DATE}" pattern="yyyy-MM-dd HH:mm"/>
										</td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="4" style="text-align:center;">최근 신고 내역이 없습니다.</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</body>
</html>