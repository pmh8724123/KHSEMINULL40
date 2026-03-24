<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신고 내역</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">

</head>

<body>
	<jsp:include page="/WEB-INF/views/admin/common/header.jsp" />

	<div class="container">
		<jsp:include page="/WEB-INF/views/admin/common/sidebar.jsp" />
		<div class="content">

		<h2>수업 관리</h2>

		 <!-- 🔥 검색/필터 영역 -->
            <div class="filter-box">
                <div class="filter-left">
            
                <select>
                    <option>전체</option>
                    <option>강의 번호</option>
                    <option>강의명</option>
					<option>교수명</option>
                </select>
                <input type="text" placeholder="검색어 입력">
                <button>검색</button>
            </div>
                <button class="btn btn-add">강의 추가</button>
		</div>

		<div class="table-container">
			<table>
				<thead>
					<tr>
						<th>강의번호</th>
						<th>강의명</th>
						<th>교수명</th>
						<th>시작시간</th>
						<th>종료시간</th>
						<th>강의실</th>
						<th>작성/수정날짜</th>
						<th>처리</th>
					</tr>
				</thead>

				<tbody>
					<c:forEach var="l" items="${list}">
					<tr>
						<td>${l.lectureNo}</td>
						<td>${l.lectureName}</td>
						<td>홍길동</td>
						<td>09:00</td>
						<td>12:00</td>
						<td>${l.lectureRoom}</td>
						<td>sysdate</td>
						<td>
							<button class="btn btn-approve">수정</button>
							<button class="btn btn-reject">삭제</button>
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