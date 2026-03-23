<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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

			<h2>신고 내역</h2>

			<!-- 🔥 검색/필터 영역 -->
			<div class="filter-box">
				<div class="filter-left">
					<select>
						<option>전체</option>
						<option>신고번호</option>
						<option>신고자</option>
						<option>내용</option>
						<option>처리</option>
					</select> 
					<input type="text" placeholder="검색어 입력">
					<button>검색</button>
				</div>
			</div>


			<div class="table-container">

				<table>
					<thead>
						<tr>
							<th>신고번호</th>
							<th>컨텐츠 유형</th>
							<th>신고자</th>
							<th>신고 사유</th>
							<th>신고 내용</th>
							<th>신고 날짜</th>
							<th>처리 상태</th>
							<th>처리</th>
						</tr>
					</thead>

					<tbody>
						<%
						for (int i = 1; i <= 30; i++) {
						%>
						<tr>
							<td><%=i%></td>
							<td>게시글</td>
							<td>user<%=i%></td>
							<td>욕설</td>
							<td>ㅁㄴㅇㅁㄴㅇ</td>
							<td>26.03.10 15:33:21</td>
							<td>미처리</td>
							<td>
								<button class="btn btn-approve">처리</button>
								<button class="btn btn-reject">삭제</button>
							</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>


		</div>
	</div>
</body>
</html>