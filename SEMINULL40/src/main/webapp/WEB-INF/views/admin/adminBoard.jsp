<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">

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

		<h2>게시판 관리</h2>

		 <!-- 🔥 검색/필터 영역 -->
            <div class="filter-box">
                <div class="filter-left">
                <form action="${pageContext.request.contextPath}/admin/board" method="get">
						<select name="condition">
							<option value="all" ${condition == 'all' ? 'selected' : ''}>전체</option>
							<option value="boardTitle" ${condition == 'boardTitle' ? 'selected' : ''}>제목</option>
							<option value="boardWriterName" ${condition == 'boardWriterName' ? 'selected' : ''}>작성자</option>
							<option value="categoryName" ${condition == 'categoryName' ? 'selected' : ''}>카테고리</option>
							<c:if test="${loginUser.uniNo == 0}">
								<option value="uniName" ${condition == 'uniName' ? 'selected' : ''}>대학이름</option>
							</c:if>
							<option value="status" ${condition == 'status' ? 'selected' : ''}>상태</option>
						</select> 
						<input type="text" name="keyword" value="${keyword}" placeholder="검색어 입력">
						<button type="submit">검색</button>
					</form>
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
						<th>카테고리</th>
						<th>제목</th>
						<th>작성자</th>
						<th>게시날짜</th>
						<th>상태</th>
						<th>처리</th>
					</tr>
				</thead>

				<tbody>
					<c:forEach var="b" items="${list}" varStatus="status">
					<tr>
						<td>${status.index + 1}</td>
						<c:if test="${loginUser.uniNo == 0}">
							<td>${b.uniName}</td>
						</c:if>
						<td>${b.btypeName}</td>
						<td class="board-title">${b.boardTitle}</td>
						<td>${b.boardWriterName}</td>
						<td>
							<fmt:formatDate value="${b.createDate}"	
							pattern="yyyy-MM-dd HH:mm:ss" />
						</td>
						<td>${b.status}</td>
						<td>
							<a href="${pageContext.request.contextPath}/board/detail?boardno=${b.boardNo}" 
							   class="btn btn-approve">
							   바로가기
							</a>
						</td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		</div>
	</div>
</body>
</html>