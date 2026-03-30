<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>캠둘기 - 강의 평가</title>
<style>
    :root {
        --primary-blue: #b3d7ff;
        --bg-color: #f2f7ff;
        --point-pink: #ffafc3;
        --border-color: #333;
        --text-dark: #333;
        --text-gray: #666;
        --star-color: #ffcc00;
    }

    html, body {
        height: 100%;
        margin: 0;
        padding: 0;
        background-color: var(--bg-color);
        font-family: 'Pretendard', -apple-system, sans-serif;
    }

    .main-content {
        max-width: 800px;
        margin: 0 auto;
        padding: 40px 20px;
    }

    .lecture-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }

    .lecture-header h1 {
        font-size: 32px;
        font-weight: 700;
        margin: 0;
    }

    .write-btn {
        background-color: var(--point-pink);
        border: none;
        padding: 10px 25px;
        border-radius: 12px;
        font-weight: bold;
        cursor: pointer;
        color: black;
        transition: 0.2s;
        text-decoration: none;
        display: inline-block;
    }

    .write-btn:hover {
        opacity: 0.8;
    }

    .search-container {
        margin-bottom: 30px;
    }

    .search-input {
        width: 100%;
        padding: 15px 20px;
        border-radius: 15px;
        border: 1px solid white;
        box-sizing: border-box;
        font-size: 16px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        outline: none;
    }

    .lecture-item {
        background-color: white;
        border: 1px solid var(--border-color);
        border-radius: 20px;
        padding: 25px;
        margin-bottom: 20px;
        position: relative;
        transition: transform 0.2s;
    }

    .lecture-item:hover {
        transform: translateY(-2px);
    }

    .lecture-title-box {
        background-color: #f0f0f0;
        padding: 8px 20px;
        border-radius: 20px;
        display: inline-block;
        font-weight: 600;
        margin-bottom: 10px;
    }

    .evaluate-btn {
        background-color: var(--primary-blue);
        border: none; 
        padding: 8px 20px;
        border-radius: 12px;
        font-weight: bold;
        cursor: pointer;
        position: absolute;
        top: 25px;
        right: 25px;
    }

    .stars {
        color: #ddd;
        font-size: 18px;
        margin-bottom: 15px;
    }

    .stars .filled {
        color: #4a90e2;
    }

    .lecture-stats {
        margin-top: 20px;
        font-size: 16px;
        color: var(--text-dark);
    }

    .empty-msg {
        text-align: center;
        padding: 80px 0;
        background: white;
        border-radius: 20px;
        border: 1px dashed #ccc;
        color: var(--text-gray);
        font-size: 18px;
    }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    
    <div class="main-content">
        <!-- 상단 헤더 -->
        <header class="lecture-header">
            <h1>강의평가</h1>
            <sec:authorize access="isAuthenticated()">
                <!-- 주의: 아래 상단 글쓰기 버튼은 어떻게 동작할지 기획에 따라 변경이 필요합니다 (설명 참조) -->
                <button class="write-btn" onclick="alert('평가할 강의 우측의 [평가하기] 버튼을 눌러주세요!');">글쓰기</button>
            </sec:authorize>
        </header>
    
        <!-- 검색창 (엔터키 검색을 위해 form 추가) -->
        <div class="search-container">
            <form action="${pageContext.request.contextPath}/rating" method="get">
                <input type="text" name="keyword" class="search-input" placeholder="강의명으로 검색" value="${keyword}">
            </form>
        </div>
        
        <!-- 강의 리스트 영역 -->
        <div class="lecture-container">
            <c:forEach var="lecture" items="${lectureList}">
                <div class="lecture-item">
                    <div class="lecture-title-box">
                        ${lecture.lectureName} - ${lecture.professorName} 교수님
                    </div>
                
                    <!-- ★ 수정됨: 경로를 절대경로로 변경하고 detail -> write로 변경 -->
                    <button class="evaluate-btn" onclick="location.href='${pageContext.request.contextPath}/rating/write?lectureNo=${lecture.lectureNo}'">평가하기</button>
                    
                    <!-- 별점 동적 처리: 평균 점수만큼 칠해진 별 표시 -->
                    <div class="stars">
                        <c:forEach var="i" begin="1" end="5">
                            <span class="${i <= lecture.avgScore ? 'filled' : ''}">★</span>
                        </c:forEach>
                    </div>
					                    
					<div class="lecture-stats">
					    과제 : 
					    <c:choose>
					        <c:when test="${lecture.homework == 1}">많음</c:when>
					        <c:when test="${lecture.homework == 2}">보통</c:when>
					        <c:when test="${lecture.homework == 3}">적음</c:when>
					        <c:otherwise>없음</c:otherwise>
					    </c:choose>
					    
					    &nbsp;&nbsp;성적 : 
					    <c:choose>
					        <c:when test="${lecture.grade == 1}">너그러움</c:when>
					        <c:when test="${lecture.grade == 2}">보통</c:when>
					        <c:otherwise>깐깐함</c:otherwise>
					    </c:choose>
					    
					    &nbsp;&nbsp;평가 : ${lecture.reviewCount} 개
					</div>
                </div>
            </c:forEach>
          
            <!-- 강의 평가가 없을 경우 -->
            <c:if test="${empty lectureList}">
                <div class="empty-msg">
                    <p>등록된 강의 평가가 없습니다.</p>
                </div>
            </c:if>          
        </div>    
    </div>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>