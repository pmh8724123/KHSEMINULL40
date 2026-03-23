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
					<h3>🆕 오늘 가입</h3>
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
					<h3>📝 게시글 수</h3>
					<p class="number">320</p>
				</div>

				<div class="card">
					<h3>💬 댓글 수</h3>
					<p class="number">1245</p>
				</div>

			</div>

			<!-- 🔥 그래프 영역 -->
			<div class="chart-box">
				<h3>📈 일별 가입자 통계</h3>
				<canvas id="myChart"></canvas>
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

	<!-- 🔥 Chart.js -->
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

	<script>
		const ctx = document.getElementById('myChart');

		new Chart(ctx, {
			type : 'line',
			data : {
				labels : [ '월', '화', '수', '목', '금', '토', '일' ],
				datasets : [ {
					label : '가입자 수',
					data : [ 3, 5, 2, 8, 6, 4, 7 ],
					borderWidth : 2,
					fill : false
				} ]
			}
		});
	</script>
</html>