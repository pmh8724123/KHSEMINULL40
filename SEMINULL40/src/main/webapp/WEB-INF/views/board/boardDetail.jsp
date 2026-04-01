<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
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
    
    <!-- Spring Security에서 로그인한 유저 정보를 가져와 loginUser 변수에 담음 -->
    <sec:authorize access="isAuthenticated()">
        <sec:authentication property="principal.member" var="loginUser" />
    </sec:authorize>
    
    <div class="detail-wrapper">
        <div class="post-section">
			<div class="post-header">
			    <h2 class="post-title">${b.boardTitle}</h2>
				<div class="btns">
				    <!-- 작성자 본인에게만 수정/삭제 버튼 노출 -->
				    <c:if test="${not empty loginUser and loginUser.memNo eq b.boardWriter}">
				        <button class="edit-btn" onclick="location.href='${pageContext.request.contextPath}/board/updateForm?boardno=${b.boardNo}'">수정</button>
				        <button class="edit-btn" style="background-color: #ff4d4d; margin-left: 5px;" onclick="deleteBoard();">삭제</button>
				    </c:if>
				</div>
			</div>       
            <div class="post-info">
                작성자 <b>${b.boardWriterName}</b> &nbsp;|&nbsp; 조회수 <b>${b.viewCount}</b> &nbsp;|&nbsp; 작성일 <b>${b.createDate}</b>
            </div>
            
            <div class="post-content">
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
                <div class="text-area">${b.boardContent}</div>
            </div>
        </div>
        
        <div class="action-group">
            <button class="action-btn" onclick="updateLike();">👍 좋아요 <span id="likeCount">0</span></button>
            <button class="action-btn-report">신고</button>
        </div>
        
        <div class="reply-section">
             <div class="reply-count">댓글 <span id="rcount">0</span></div>
            <div class="reply-write-box">
                <textarea id="replyContent" placeholder="댓글을 입력하세요..."></textarea>
                <div class="reply-submit-row">
                    <button class="reply-btn" onclick="addReply();">댓글 작성</button>
                </div>
            </div>
            <div id="replyListArea"></div>
        </div>
    </div>
	<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 
    <script>
        // AJAX CSRF 설정 (Spring Security 필수)
        const token = $("meta[name='_csrf']").attr("content");
        const header = $("meta[name='_csrf_header']").attr("content");

        $.ajaxSetup({
            beforeSend: function(xhr) {
                if (header && token) {
                    xhr.setRequestHeader(header, token);
                }
            }
        });

        // 로그인 유저의 번호를 할당 (비로그인시 0)
        const currentLoginUserNo = "${not empty loginUser ? loginUser.memNo : 0}";

        $(function() {
            selectReplyList();
            getLikeCount();

            $(".action-btn-report").on("click", function() {
                const boardNo = "${b.boardNo}";
                if(!boardNo) return;
                const url = "${pageContext.request.contextPath}/board/report?boardNo=" + boardNo;
                window.open(url, "reportPopup", "width=500,height=650,top=100,left=500");
            });
        });
		// 댓글 목록
        function selectReplyList() {
            $.ajax({
                url: "${pageContext.request.contextPath}/reply/list",
                type: "get",
                data: { boardNo : "${b.boardNo}" },
                success: function(list) {
                    let html = "";
                    $("#rcount").text(list.length);
                    if (list.length > 0) {
                        list.forEach(r => {
                            html += `<div class='reply-item'>
                                        <div class='reply-writer'>\${r.userName || '익명'} <span style='font-size:11px; color:#999;'>(\${r.createDate})</span></div>
                                        <div class='reply-text'>\${r.replyContent}</div>
                                        <div style='font-size:12px; color:#888;'>
                                            \${currentLoginUserNo == r.replyWriter ? `<span onclick='deleteReply(\${r.replyNo})' style='color:red; cursor:pointer;'>삭제</span>` : ''}
                                        </div>
                                     </div>`;
                        });
                    } else {
                        html = "<p style='text-align:center; color:#999; padding:20px;'>등록된 댓글이 없습니다.</p>";
                    }
                    $("#replyListArea").html(html);
                }
            });
        }
		// 댓글 추가
        function addReply() {
            // 로그인 체크
            if (currentLoginUserNo == 0) {
                alert("로그인 후 이용 가능합니다.");
                return;
            }

            const content = $("#replyContent").val();
            if (!content.trim()) {
                alert("내용을 입력해주세요.");
                return;
            }

            $.ajax({
                url: "${pageContext.request.contextPath}/reply/insert",
                type: "post",
                data: { 
                    boardNo: "${b.boardNo}", 
                    replyContent: content, 
                    replyWriter: currentLoginUserNo 
                },
                success: function(result) {
                    if (result === "success") {
                        $("#replyContent").val("");
                        selectReplyList();
                    } else {
                        alert("댓글 등록 실패");
                    }
                }
            });
        }
		// 좋아요 카운트
        function getLikeCount() {
            $.ajax({
                url: "${pageContext.request.contextPath}/board/likeCount",
                data: { boardNo: "${b.boardNo}" },
                success: function(count) { $("#likeCount").text(count); }
            });
        }
		// 좋아요 업데이트
        function updateLike() {
            if (currentLoginUserNo == 0) {
                alert("로그인 후 이용 가능합니다.");
                return;
            }
            $.ajax({
                url: "${pageContext.request.contextPath}/board/like",
                type: "post",
                data: { 
                    boardNo: "${b.boardNo}", 
                    memNo: currentLoginUserNo 
                },
                success: function(result) {
                    getLikeCount();
                    alert(result === "insert" ? "공감하였습니다." : "공감을 취소하였습니다.");
                }
            });
        }
        // 댓글 삭제
        function deleteReply(replyNo) {
            if(confirm("정말로 이 댓글을 삭제하시겠습니까?")) {
                $.ajax({
                    url: "${pageContext.request.contextPath}/reply/delete",
                    type: "post",
                    data: { replyNo: replyNo },
                    success: function(result) {
                        if (result === "success") {
                            alert("댓글이 삭제되었습니다.");
                            selectReplyList(); 
                        } else {
                            alert("댓글 삭제에 실패했습니다.");
                        }
                    }
                });
            }
        }
        // 게시글 삭제
		function deleteBoard(){
        	if(confirm("정말로 이 게시글을 삭제하시겠습니까?")){
        		// 1. 동적 form 생성
        		const form = document.createElement('form');
        		form.method = 'POST';
        		form.action = "${pageContext.request.contextPath}/board/delete";
        		
        		// 2. 게시글 번호 추가
        		const boardNoInput = document.createElement('input');
        		boardNoInput.type = 'hidden';
        		boardNoInput.name = 'boardno';
        		boardNoInput.value = "${b.boardNo}";
        		form.appendChild(boardNoInput);
        		
        		// 3. CSRF 토큰 추가
        		const csrfInput = document.createElement('input');
        		csrfInput.type = 'hidden';
        		csrfInput.name = "${_csrf.parameterName}";
        		csrfInput.value = "${_csrf.token}";
        		form.appendChild(csrfInput);
        		
        		// 4. form을 문서에 붙여서 전송
        		document.body.appendChild(form);
        		form.submit();
        	}
        }
    </script>
</body>
</html>