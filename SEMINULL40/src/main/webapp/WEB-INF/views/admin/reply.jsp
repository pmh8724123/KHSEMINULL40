<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">

</head>

<body>
	<jsp:include page="/WEB-INF/views/admin/common/header.jsp" />

	<div class="container">
		<jsp:include page="/WEB-INF/views/admin/common/sidebar.jsp" />
		<div class="content">

		<h2>댓글 관리</h2>

		 <!-- 🔥 검색/필터 영역 -->
            <div class="filter-box">
                <div class="filter-left">
            
                <select>
                    <option>전체</option>
                    <option>카테고리</option>
                    <option>작성자</option>
                </select>
                <input type="text" placeholder="검색어 입력">
                <button>검색</button>
            </div>
		</div>

		<div class="table-container">
			<table>
				<thead>
					<tr>
						<th>댓글번호</th>
						<th>대학교</th>
						<th>카테고리</th>
						<th>게시판제목</th>
						<th>작성자</th>
						<th>좋아요</th>
						<th>작성일</th>
						<th>처리</th>
					</tr>
				</thead>

				<tbody>
					<% for(int i=1; i<=30; i++){ %>
					<tr>
						<td><%= i %></td>
						<td>캠둘대학교</td>
						<td>자유게시판</td>
						<td>캠둘캠둘</td>
						<td>캠둘(camdu123)</td>
						<td>25</td>
						<td>25.12.12 13:11:10</td>
						<td>
							<button class="btn btn-approve">바로가기</button>
							<button class="btn btn-reject">삭제</button>
						</td>
					</tr>
					 <% } %>
				</tbody>
			</table>
		</div>

		</div>
	</div>
</body>
</html>