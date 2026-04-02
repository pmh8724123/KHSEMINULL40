<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세 보기</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
    body {
        background-color: #f2f7ff; 
        margin: 0; 
        padding: 0; 
        font-family: 'Pretendard', sans-serif; 
    }
     
    .detail-wrapper { 
        width: 100%; 
        max-width: 750px; 
        margin: 50px auto; 
        padding: 40px; 
        background-color: white; 
        border: 1px solid #333; 
        border-radius: 35px; 
        box-sizing: border-box; 
    }
     
    .post-header { 
        display: flex; 
        justify-content: space-between; 
        align-items: center; 
        margin-bottom: 15px; 
    }
     
    .post-title { 
        font-size: 26px;
        font-weight: bold; 
        margin: 0; 
        color: #333; 
    }
     
    .edit-btn { 
        background-color: #31a1ff; 
        color: white; 
        border: none; 
        padding: 8px 18px; 
        border-radius: 12px; 
        font-weight: bold; 
        cursor: pointer; 
    }
     
    .post-info { 
        font-size: 14px; 
        color: #666; 
        margin-bottom: 25px; 
        padding-bottom: 15px; 
        border-bottom: 1px solid #eee; 
    }
    
    .post-content { 
        font-size: 16px; 
        line-height: 1.8; 
        min-height: 200px; 
        margin-bottom: 30px; 
        color: #333; 
    }
     
    .content-img-area img { 
        max-width: 100%; 
        height: auto; 
        display: block; 
        margin: 20px auto; 
        border-radius: 15px; 
        border: 1px solid #eee; 
    }
     
    .text-area { 
        white-space: pre-wrap; 
        word-wrap: break-word; 
    }

    .action-group { 
        display: flex; 
        gap: 10px; 
        padding-top: 20px; 
        border-top: 1px solid #eee; 
    }
     
    .action-btn { 
        display: flex; 
        align-items: center; 
        gap: 6px; 
        padding: 8px 15px; 
        background: white; 
        border: 1px solid #333; 
        border-radius: 15px; 
        font-weight: bold; 
        cursor: pointer; 
    }
     
    .action-btn-report { 
        margin-left: auto; 
        padding: 8px 15px; 
        background: white; 
        border: 1px solid #333; 
        border-radius: 15px; 
        color: #ff4d4d; 
        font-weight: bold; 
        cursor: pointer; 
    }
    
    .reply-section { 
        margin-top: 40px; 
    }
     
    .reply-count { 
        font-size: 18px; 
        font-weight: bold; 
        margin-bottom: 15px; 
    }
     
    .reply-write-box { 
        padding: 15px; 
        border: 1px solid #333; 
        border-radius: 20px; 
        margin-bottom: 25px;
    }
     
    #replyContent { 
        width: 100%; 
        min-height: 70px; 
        border: none; 
        resize: none; 
        outline: none; 
        font-size: 15px; 
    }
     
    .reply-submit-row { 
        display: flex; 
        justify-content: flex-end; 
    }
     
    .reply-btn { 
        background-color: #a2cfff; 
        border: 1px solid #333; 
        border-radius: 15px; 
        padding: 8px 20px; 
        font-weight: bold; 
        cursor: pointer; 
    }
     
    .reply-item { 
        padding: 15px 5px; 
        border-bottom: 1px solid #f0f0f0; 
    }
     
    .reply-writer { 
        font-size: 14px; 
        font-weight: bold; 
    }
     
    .reply-text { 
        margin: 10px 0; 
        font-size: 15px; 
        color: #444; 
    }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <c:set var="contextPath" value="pageContext.request.contextPath"/>
    
    <div class="detail-wrapper">
        <div class="post-section">
			<div class="post-header">
			    <h2 class="post-title">${notice.noticeTitle}</h2>
			    <div class="btns">
			        <sec:authorize access="hasRole('ADMIN')">
			        	<button class="edit-btn" onclick="location.href='${pageContext.request.contextPath}/notice/modify?noticeNo=${notice.noticeNo}'">수정</button>
			        	<button class="edit-btn" style="background-color: #ff4d4d; margin-left: 5px;" onclick="deleteNotice(${notice.noticeNo});">삭제</button>			        
			        </sec:authorize>
			    </div>
			</div>       
            <div class="post-info">
                작성자 <b>관리자</b> &nbsp;|&nbsp; 작성일 <b>${notice.createDate}</b>
            </div>
            
            <div class="post-content">
                <!-- [본문 이미지 출력] -->
                <c:if test="${not empty list}">
                    <div class="content-img-area">
                        <c:forEach var="f" items="${list}">
                            <c:set var="fileName" value="${f.changeName.toLowerCase()}" />
                            <c:if test="${fileName.endsWith('.jpg') || fileName.endsWith('.png') || fileName.endsWith('.jpeg') || fileName.endsWith('.gif')}">
                                <img src="${pageContext.request.contextPath}/resources/upload_files/${f.changeName}">
                            </c:if>
                        </c:forEach>
                    </div>
                </c:if>

                <!-- [본문 텍스트 출력] -->
                <div class="text-area">${notice.noticeContent}</div>
            </div>
        </div>
    </div>

    <script>
        // 게시글 삭제 함수
        function deleteNotice(noticeNo) {
    		if (!confirm("정말 삭제하시겠습니까?")) {
        		return;
    		}

    		fetch('${pageContext.request.contextPath}/notice/delete', {
        		method: 'POST',
        		headers: {
            		'Content-Type': 'application/x-www-form-urlencoded',
            		'X-CSRF-TOKEN': '${_csrf.token}'
        		},
        		body: 'noticeNo=' + noticeNo
   			}).then(response => {
        		if (response.ok) {
            		alert("삭제 완료");
            		location.href = '${pageContext.request.contextPath}/notice/list';
        		}
        		else {
            		alert("삭제 실패");
        		}
    		}).catch(error => console.error(error));
		}
    </script>
</body>
</html>