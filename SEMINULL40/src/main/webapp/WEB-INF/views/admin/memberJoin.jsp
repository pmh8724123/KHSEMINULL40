<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 가입 승인</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
    
</head>

<body>

    <!-- 헤더 -->
    <jsp:include page="/WEB-INF/views/admin/common/header.jsp" />

    <div class="container">

        <!-- 사이드바 -->
        <jsp:include page="/WEB-INF/views/admin/common/sidebar.jsp" />

        <!-- 콘텐츠 -->
        <div class="content">

            <h2>회원 가입 승인</h2>

            <!-- 🔥 검색/필터 영역 -->
            <div class="filter-box">
            	<div class="filter-left">
	                <select>
	                    <option>전체</option>
	                    <option>아이디</option>
	                    <option>학교</option>
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
                            <th>학교</th>
                            <th>요청일</th>
                            <th>상태(대기/거절)</th>
                            <th>승인</th>
                        </tr>
                    </thead>

                    <tbody>
                        <% for(int i=1; i<=30; i++){ %>
                        <tr>
                            <td><%= i %></td>
                            <td>user<%= i %></td>
                            <td>OO대학교</td>
                            <td>26.03.20 15:22:22</td>
                            <td>대기</td>
                            <td>
                                <button class="btn btn-approve">승인</button>
                                <button class="btn btn-reject">거절</button>
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