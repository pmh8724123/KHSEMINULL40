<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- 현재 선택된 카테고리를 변수로 저장 (기본값 all) -->
<c:set var="cur" value="${empty param.category ? 'all' : param.category}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>캠둘기 - 게시판</title>
<style>
    :root {
        --primary-blue: #a2cfff;
        --bg-color: #f2f7ff;
        --border-color: #333;
        --text-dark: #333;
        --text-gray: #666;
    }

    html, body {
        height: 100%;
        margin: 0;
        padding: 0;
    }

    body {
        display: flex;
        flex-direction: column; 
        background-color: var(--bg-color);
        font-family: 'Pretendard', -apple-system, sans-serif;
        color: var(--text-dark);
    }

    .main-content {
        flex: 1;
    }

    .board-wrapper {
        max-width: 900px;
        margin: 0 auto;
        padding: 50px 20px;
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
        padding: 10px 25px;
        border-radius: 12px;
        font-weight: bold;
        cursor: pointer;
        text-decoration: none;
        color: black;
        transition: 0.2s;
    }

    .write-btn:hover {
        background-color: #8bbfff;
    }

    /* 카테고리 탭 스타일 */
    .category-list {
        list-style: none;
        padding: 0;
        margin: 0 0 35px 0;
        background-color: white;
        border: 1px solid var(--border-color);
        border-radius: 15px;
        display: flex;
        overflow: hidden;
    }

    .category-list li {
        flex: 1;
        text-align: center;
        padding: 18px 0;
        cursor: pointer;
        font-size: 16px;
        transition: 0.2s;
        border-right: 1px solid #eee;
    }

    .category-list li:last-child {
        border-right: none;
    }

    .category-list li.active {
        background-color: var(--primary-blue);
        font-weight: bold;
    }

    .category-list li:hover:not(.active) {
        background-color: #f9f9f9;
    }

    /* 게시글 아이템 스타일 */
    .post-item {
        background-color: white;
        border: 1px solid var(--border-color);
        border-radius: 20px;
        padding: 25px 35px;
        margin-bottom: 20px;
        text-decoration: none;
        color: inherit;
        display: block;
        transition: transform 0.2s, box-shadow 0.2s;
    }

    .post-item:hover {
        transform: translateY(-3px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.05);
    }

    .post-item h2 {
        font-size: 24px;
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
        padding: 5px 12px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: bold;
    }

    .tag-stats {
        color: var(--text-gray);
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .empty-msg {
        text-align: center;
        padding: 100px 0;
        background: white;
        border-radius: 20px;
        border: 1px dashed var(--border-color);
        color: var(--text-gray);
    }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" /> 

    <div class="main-content">
        <div class="board-wrapper">
            
            <header class="board-header">
                <h1>게시판</h1>
                <sec:authorize access="isAuthenticated()">
                    <button class="write-btn" onclick="location.href='write?category=${cur}'">글쓰기</button>
                </sec:authorize>
            </header>

            <!-- 카테고리 필터 -->
            <ul class="category-list">
                <li onclick="location.href='list?category=all'" class="${cur == 'all' ? 'active' : ''}">전체</li>
                <li onclick="location.href='list?category=free'" class="${cur == 'free' ? 'active' : ''}">자유게시판</li>
                <li onclick="location.href='list?category=qna'" class="${cur == 'qna' ? 'active' : ''}">질문답변</li>
                <li onclick="location.href='list?category=accident'" class="${cur == 'accident' ? 'active' : ''}">사건사고</li>
            </ul>

            <!-- 게시글 리스트 영역 -->
            <div class="post-container">
                <c:forEach var="post" items="${boardList}">
                    <a href="detail?boardno=${post.boardNo}" class="post-item">
                        <h2>${post.boardTitle}</h2>
                        <div class="post-info">
                            <span class="tag-category">${empty post.categoryName ? '일반' : post.categoryName}</span>
                            <div class="tag-stats">
                                <span>조회수 ${post.viewCount}</span>
                                <span>👍 ${post.likeCount}</span>
                            </div>
                        </div>
                    </a>
                </c:forEach>

                <!-- 게시글이 없을 경우 -->
                <c:if test="${empty boardList}">
                    <div class="empty-msg">
                        <p>선택하신 카테고리에 등록된 게시글이 없습니다.</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" /> 
</body>
</html>