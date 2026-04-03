<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/admin.css">
</head>

<body>

	<jsp:include page="/WEB-INF/views/admin/common/header.jsp" />

	<div class="container">

		<jsp:include page="/WEB-INF/views/admin/common/sidebar.jsp" />

		<div class="content">

			<h2>📊 관리자 대시보드</h2>

			<!-- 🔥 카드 영역 -->
			<div class="dashboard">

				<div class="card">
					<h3>👥 총 회원</h3>
					<p class="number">120</p>
				</div>

				<div class="card">
					<h3> 가입대기</h3>
					<p class="number">8</p>
				</div>

				<div class="card">
					<h3>⛔ 정지 회원</h3>
					<p class="number">5</p>
				</div>

				<div class="card">
					<h3>🚨 신고 건수</h3>
					<p class="number">12</p>
				</div>

				<div class="card">
					<h3>📝 게시글</h3>
					<p class="number">320</p>
				</div>

				<div class="card">
					<h3>🏫 학교/학과 </h3>
					<p class="number">1245</p>
				</div>

			</div>

			<!-- 🔥 최근 신고 -->
			<div class="recent-box">
				<h3>🚨 최근 신고</h3>

				<table>
					<thead>
						<tr>
							<th>번호</th>
							<th>신고자</th>
							<th>내용</th>
							<th>날짜</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>1</td>
							<td>user01</td>
							<td>욕설 게시글</td>
							<td>2026-03-20</td>
						</tr>
						<tr>
							<td>2</td>
							<td>user02</td>
							<td>광고성 글</td>
							<td>2026-03-20</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>

</html>