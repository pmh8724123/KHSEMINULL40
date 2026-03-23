<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 상태 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
	
</head>

<body>
	<jsp:include page="/WEB-INF/views/admin/common/header.jsp" />

	<div class="container">
		
		<jsp:include page="/WEB-INF/views/admin/common/sidebar.jsp" />
		<div class="content">

			<h2>회원 상태 관리</h2>

			 <!-- 🔥 검색/필터 영역 -->
            <div class="filter-box">
	            <div class="filter-left">
	                <select>
	                    <option>전체</option>
	                    <option>회원번호</option>
	                    <option>아이디</option>
						<option>이름</option>
						<option>상태</option>
	                </select>
	                <input type="text" placeholder="검색어 입력">
	                <button>검색</button>
	            </div>
          	</div>

			 <!-- 🔥 테이블 영역 -->
            <div class="table-container">

                <table>
                    <thead>
                        <tr>
                            <th>회원번호</th>
							<th>아이디</th>
							<th>이름</th>
							<th>상태(활성/정지/탈퇴)</th>
							<th>변경</th>
                        </tr>
                    </thead>

                    <tbody>
                        <% for(int i=1; i<=30; i++){ %>
                        <tr>
                            <td><%= i %></td>
                            <td>user<%= i %></td>
							<td>홍길동</td>
							<td>활성화</td>
                            <td>
                                <button class="btn btn-approve">정지</button>
                                <button class="btn btn-reject">탈퇴</button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>

                </table>
			</div>
	</div>


</body>
</html>