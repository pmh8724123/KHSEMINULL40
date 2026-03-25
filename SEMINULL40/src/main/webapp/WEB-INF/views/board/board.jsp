<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 현재 선택된 카테고리를 변수로 저장 -->
<c:set var="cur" value="${empty param.category ? 'all' : param.category}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 리스트</title>
<style>
    :root {
        --primary-blue: #a2cfff;
        --bg-color: #f2f7ff;
        --border-color: #333;
        --text-dark: #333;
        --text-gray: #666;
    }

    body {
        background-color: var(--bg-color);
        margin: 0; padding: 0;
        font-family: 'Pretendard', -apple-system, sans-serif;
        color: var(--text-dark);
    }

    .board-wrapper {
        max-width: 900px;
        margin: 0 auto;
        padding: 40px 20px;
    }

    .board-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
    }

    .board-header h1 {
        font-size: 36px;
        margin: 0;
        font-weight: 800;
        letter-spacing: -1px;
    }

    .write-btn {
        background-color: var(--primary-blue);
        border: 1px solid var(--border-color);
        padding: 12px 28px;
        border-radius: 12px;
        font-weight: bold;
        cursor: pointer;
        text-decoration: none;
        color: black;
        display: inline-block;
    }

    .category-list {
        list-style: none;
        padding: 0;
        margin-bottom: 35px;
        background-color: white;
        border: 1px solid var(--border-color);
        border-radius: 15px;
        display: flex;
        overflow: hidden;
    }

    .category-list li {
        flex: 1;
        text-align: center;
        padding: 16px 0;
        cursor: pointer;
        font-size: 16px;
        transition: 0.2s;
    }

    .category-list li.active {
        background-color: var(--primary-blue);
        font-weight: bold;
    }

    .post-item {
        background-color: white;
        border: 1px solid var(--border-color);
        border-radius: 20px;
        padding: 25px 35px;
        margin-bottom: 20px;
        text-decoration: none;
        color: inherit;
        display: block;
    }

    .post-item h2 {
        font-size: 26px;
        margin: 0 0 15px 0;
        font-weight: 700;
    }

    .post-info {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .tag-category {
        background-color: var(--primary-blue);
        padding: 6px 14px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: bold;
    }

    .tag-stats {
        color: var(--text-gray);
        font-size: 15px;
    }

    .empty-msg {
        text-align: center;
        padding: 80px 0;
        color: var(--text-gray);
        font-size: 18px;
    }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" /> 
    
    <div class="board-wrapper">
        
        <header class="board-header">
            <h1>게시판</h1>
            <%-- 상세 페이지 이동을 위해 location.href 사용 시 boardno 소문자 권장 (Controller와 맞춤) --%>
            <button class="write-btn" onclick="location.href='write?category=${cur}'">글쓰기</button>
        </header>

        <ul class="category-list">
            <li onclick="location.href='list?category=all'" class="${cur == 'all' ? 'active' : ''}">전체</li>
            <li onclick="location.href='list?category=free'" class="${cur == 'free' ? 'active' : ''}">자유게시판</li>
            <li onclick="location.href='list?category=qna'" class="${cur == 'qna' ? 'active' : ''}">질문답변</li>
            <li onclick="location.href='list?category=accident'" class="${cur == 'accident' ? 'active' : ''}">사건사고</li>
        </ul>

        <div class="post-container">
            <%-- 컨트롤러에서 담아준 boardList를 순회함 --%>
            <c:forEach var="post" items="${boardList}">
                <a href="detail?boardno=${post.boardNo}" class="post-item">
                    <h2>${post.boardTitle}</h2>
                    <div class="post-info">
                        <%-- Mapper에서 별칭으로 가져올 categoryName --%>
                        <span class="tag-category">${empty post.categoryName ? '일반' : post.categoryName}</span>
                        <%-- readCount 대신 VO 필드명인 viewCount 사용 --%>
                        <span class="tag-stats">조회수 ${post.viewCount} &nbsp; 👍 ${post.likeCount}</span>
                    </div>
                </a>
            </c:forEach>

            <c:if test="${empty boardList}">
                <div class="empty-msg">
                    <p>아직 등록된 게시글이 없습니다.</p>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>