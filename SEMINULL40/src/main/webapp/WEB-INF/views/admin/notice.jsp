<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 사항</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">

</head>

<body>
	<jsp:include page="/WEB-INF/views/admin/common/header.jsp" />

	<div class="container">
		<jsp:include page="/WEB-INF/views/admin/common/sidebar.jsp" />
		<div class="content">

		<h2>공지사항 관리</h2>

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
                <button class="btn btn-add">공지사항 게시글 추가</button>
		</div>

		<div class="table-container">
			<table>
				<thead>
					<tr>
						<th>공지번호</th>
						<th>공지이름</th>
						<th>카테고리 종류(상시게시/긴급게시)</th>
						<th>작성자</th>
						<th>작성/수정날짜</th>
						<th>처리</th>
					</tr>
				</thead>

				<tbody>
					<% for(int i=1; i<=30; i++){ %>
					<tr>
						<td><%= i %></td>
						<td>※공지1※</td>
						<td>긴급공지</td>
						<td>박무혁(pmh8724)</td>
						<td>sysdate</td>
						<td>
							<button class="btn btn-approve">수정</button>
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