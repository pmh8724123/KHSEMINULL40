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
        --border-color: #333;
        --text-dark: #333;
        --text-gray: #666;
    }

    html, body { 
	    height: 100%; 
	    margin: 0; 
	    background-color: var(--bg-color); 
	    font-family: 'Pretendard', sans-serif; 
    }
    .main-content { 
	    max-width: 800px; 
	    margin: 0 auto; 
	    padding: 40px 20px; 
    }

    /* 헤더 및 검색 */
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
	    background-color: #32a2ff; /* 버튼 색상 강조 */
	    border: 1px solid var(--border-color); color: white;
	    padding: 10px 25px; 
	    border-radius: 12px; 
	    font-weight: bold; 
	    cursor: pointer; 
	    transition: 0.2s; 
    }
    .write-btn:hover { opacity: 0.8; }

    .search-container { margin-bottom: 30px; }
    .search-input { 
	    width: 100%; 
	    padding: 15px 20px; 
	    border-radius: 15px; 
	    border: 1px solid #ccc; 
	    box-sizing: border-box; 
	    font-size: 16px; 
	    box-shadow: 0 2px 5px rgba(0,0,0,0.05); 
	    outline: none; 
    }

    /* 강의 리스트 아이템 */
    .lecture-item { 
	    background: white; 
	    border: 1px solid var(--border-color); 
	    border-radius: 20px; 
	    padding: 25px; 
	    margin-bottom: 20px; 
	    position: relative; 
	    transition: transform 0.2s; 
    }
    .lecture-item:hover { transform: translateY(-2px); }
    .lecture-title-box {
   		background: #eef7ff; 
   		padding: 8px 20px; 
   		border-radius: 20px; 
   		display: inline-block; 
   		font-weight: 600; 
   		margin-bottom: 10px; 
   	}
    .evaluate-btn { 
	    background: var(--primary-blue); 
	    border: 1px solid var(--border-color); 
	    padding: 8px 20px; 
	    border-radius: 12px; 
	    font-weight: bold; 
	    cursor: pointer; 
	    position: absolute; 
	    top: 25px; right: 25px; 
    }

    .stars { color: #ddd; font-size: 18px; margin-bottom: 15px; }
    .stars .filled { color: #4a90e2; }
    .lecture-stats { font-size: 16px; color: var(--text-dark); }
    
    .empty-msg { 
	    text-align: center; padding: 80px 0; 
	    background: white; border-radius: 20px; 
	    border: 1px dashed #ccc; color: var(--text-gray); 
    }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    
    <div class="main-content">
        <header class="lecture-header">
            <h1>강의평가</h1>
            <sec:authorize access="isAuthenticated()">
                <%-- 글쓰기 버튼: 강의 검색 가능 상태로 모달 오픈 --%>
                <button class="write-btn" onclick="openEvalModal()">글쓰기</button>
            </sec:authorize>
        </header>
    
        <div class="search-container">
            <%-- 검색 경로 수정: /rating으로 전송 --%>
            <form action="${pageContext.request.contextPath}/rating" method="get">
                <input type="text" name="keyword" class="search-input" placeholder="강의명 또는 교수명으로 검색" value="${keyword}">
            </form>
        </div>
        
        <div class="lecture-container">
            <c:forEach var="lecture" items="${lectureList}">
                <div class="lecture-item">
                    <div class="lecture-title-box">${lecture.lectureName} - ${lecture.professorName} 교수님</div>
                    
                    <%-- 평가하기 버튼: 특정 강의 번호를 가지고 모달 오픈 --%>
                    <button class="evaluate-btn" 
                            onclick="openEvalModal('${lecture.lectureNo}', '${lecture.lectureName}', '${lecture.professorName}')">
                        평가하기
                    </button>
                    
                    <div class="stars">
                        <%-- 평균 별점 표시 --%>
                        <c:forEach var="i" begin="1" end="5">
                            <span class="${i <= lecture.avgScore ? 'filled' : ''}">★</span>
                        </c:forEach>
                    </div>
                    
                    <div class="lecture-stats">
                        과제: 
                        <c:choose>
                            <c:when test="${lecture.homework == 1}">많음</c:when>
                            <c:when test="${lecture.homework == 2}">보통</c:when>
                            <c:when test="${lecture.homework == 3}">적음</c:when>
                            <c:otherwise>없음</c:otherwise>
                        </c:choose>
                        &nbsp;&nbsp;성적: 
                        <c:choose>
                            <c:when test="${lecture.grade == 1}">너그러움</c:when>
                            <c:when test="${lecture.grade == 2}">보통</c:when>
                            <c:otherwise>깐깐함</c:otherwise>
                        </c:choose>
                        &nbsp;&nbsp;평가: <b>${lecture.reviewCount}</b>개
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty lectureList}">
                <div class="empty-msg"><p>검색 결과가 없거나 등록된 강의 평가가 없습니다.</p></div>
            </c:if>          
        </div>    
    </div>

    <!-- 모달 파일 포함 -->
    <jsp:include page="/WEB-INF/views/board/assessmentWrite.jsp" />

    <jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>