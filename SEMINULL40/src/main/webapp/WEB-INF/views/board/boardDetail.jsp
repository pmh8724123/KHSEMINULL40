<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세 보기</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
    /* 1. 전체 레이아웃 설정 */
    body {
        background-color: #f2f7ff; /* 에타 특유의 연한 하늘색 배경 */
        margin: 0;
        padding: 0;
        font-family: 'Pretendard', -apple-system, sans-serif;
    }

    .detail-wrapper {
        width: 100%;
        max-width: 750px;
        margin: 50px auto;
        padding: 40px;
        background-color: white;
        border: 1px solid #333;
        border-radius: 35px; /* 둥근 카드 스타일 */
        box-sizing: border-box;
    }

    /* 2. 게시글 상단 (제목, 수정버튼, 정보) */
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
    }

    /* 3. 게시글 본문 */
    .post-content {
        font-size: 16px;
        line-height: 1.8;
        min-height: 180px;
        margin-bottom: 30px;
        color: #333;
    }

    /* 4. 공감 및 신고 버튼 (좋아요/싫어요) */
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
        margin-left: auto; /* 신고 버튼만 오른쪽 끝으로 밀기 */
        padding: 8px 15px;
        background: white;
        border: 1px solid #333;
        border-radius: 15px;
        color: #ff4d4d; /* 빨간색 포인트 */
        font-weight: bold;
        cursor: pointer;
    }

    /* 5. 댓글 영역 전체 */
    .reply-section {
        margin-top: 40px;
    }

    .reply-count {
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 15px;
    }

    /* 6. 댓글 입력창 박스 */
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

    /* 7. 개별 댓글 리스트 아이템 */
    .reply-item {
        padding: 15px 5px;
        border-bottom: 1px solid #f0f0f0;
    }

    .reply-writer {
        font-size: 14px;
        font-weight: bold;
    }

    .reply-date {
        font-size: 11px;
        color: #999;
        font-weight: normal;
        margin-left: 6px;
    }

    .reply-text {
        margin: 10px 0;
        font-size: 15px;
        color: #444;
    }

    .reply-actions {
        display: flex;
        gap: 12px;
        font-size: 13px;
        color: #888;
    }

    .reply-actions span {
        cursor: pointer;
    }
</style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <div class="detail-wrapper">
        <div class="post-section">
            <div class="post-header">
                <h2 class="post-title">${b.boardTitle}</h2>
                <button class="edit-btn" 
                        onclick="location.href='${pageContext.request.contextPath}/board/updateForm?boardno=${b.boardNo}'">수정</button>
            </div>
            
            <div class="post-info">
                작성자 <b>${b.boardWriter}</b> &nbsp;|&nbsp; 
                조회수 <b>${b.viewCount}</b> &nbsp;|&nbsp;
                작성일 <b>${b.createDate}</b>
            </div>
            
            <div class="post-content">${b.boardContent}</div>
        </div>
        
        <div class="action-group">
            <button class="action-btn" onclick="updateLike();">👍 좋아요<span id="likeCount">0</span></button>
            <button class="action-btn-report">신고</button>
        </div>
        
        <!-- 댓글 영역 -->
        <div class="reply-section">
             <div class="reply-count">댓글 <span id="rcount">0</span></div>
             
            <div class="reply-write-box">
                <textarea id="replyContent" placeholder="댓글을 입력하세요..."></textarea>
                <div class="reply-submit-row">
                    <button class="reply-btn" onclick="addReply();">댓글 작성</button>
                </div>
            </div>

            <!-- 이 구역의 내용이 Ajax에 의해 동적으로 바뀝니다 -->
            <div id="replyListArea">
                <%-- 초기 데이터는 비워둡니다 (자바스크립트가 채움) --%>
            </div>
        </div>
    </div>

    <script>
        $(function() {
            selectReplyList(); // 댓글 목록 가져오기
            getLikeCount(); // 좋아요 개수 가져오기
        });

        // 1. 댓글 목록 조회 함수
        function selectReplyList() {
            $.ajax({
                url: "${pageContext.request.contextPath}/reply/list",
                type: "get",
                data: { boardNo : ${b.boardNo} }, // 현재 게시글 번호 전달
                success: function(list) {
                    let html = "";
                    $("#rcount").text(list.length); // 댓글 개수 업데이트

                    if (list.length > 0) {
                    	list.forEach(r => {
                    	    html += "<div class='reply-item'>"
                    	         + "  <div class='reply-writer'>" 
                    	         +      (r.userName ? r.userName : "익명") 
                    	         + "    <span class='reply-date'>(" + r.createDate + ")</span>"
                    	         + "  </div>"
                    	         + "  <div class='reply-text'>" + r.replyContent + "</div>"
                    	         + "  <div class='reply-actions'>"
                    	         + "      <span>답글</span>"
                    	         // 아래 줄에 onclick="deleteReply(번호)" 를 추가합니다.
                    	         + "      <span onclick='deleteReply(" + r.replyNo + ")' style='color:red;'>삭제</span>" 
                    	         + "  </div>"
                    	         + "</div>";
                    	});
                    } else {
                        html = "<p style='text-align:center; color:#999; font-size:14px; padding:30px 0;'>등록된 댓글이 없습니다.</p>";
                    }
                    
                    $("#replyListArea").html(html);
                },
                error: function() {
                    console.log("댓글 조회 통신 실패");
              	  }
            });
        }

     // 2. 댓글 등록 함수
        function addReply() {
            const content = $("#replyContent").val();
            
            if (content.trim().length === 0) {
                alert("내용을 입력해주세요.");
                return;
            }

            $.ajax({
                url: "${pageContext.request.contextPath}/reply/insert",
                type: "post",
                data: {
                    boardNo: ${b.boardNo},
                    replyContent: content,
                    // 추가: 테스트를 위해 실제 DB에 있는 회원번호(MEM_NO) 하나를 직접 기입합니다.
                    replyWriter: 1 
                },
                success: function(result) {
                    if (result === "success") {
                        alert("댓글이 등록되었습니다.");
                        $("#replyContent").val(""); 
                        selectReplyList(); 
                    } else {
                        alert("댓글 등록 실패 (로그인이 필요하거나 데이터가 잘못되었습니다.)");
                    }
                },
                error: function() {
                    alert("댓글 등록 통신 실패");
                }
            });
        }
	     // 3. 삭제 함수 추가
	     function deleteReply(replyNo){
	    	 if(!confirm("정말 삭제하시겠습니까?")) return;
	     $.ajax({
	    	 url: "${pageContext.request.contextPath}/reply/delete",
	    	 type: "post",
	    	 data : {replyNo:replyNo},
	    	 success : function(result){
	    		 if(result == "success"){
	    			 alert("댓글이 삭제되었습니다.");
	    			 selectReplyList();
	    		 }else{
	    			 alert("삭제 실패");
	    		 }
	    	 },
	    	 error: function(){
	    		 alert("삭제 통신 실패");
	    	 }
	     });
	     
	  }

	     
	     
	     // [조회] 현재 게시글의 총 좋아요 수 가져오기
	   function getLikeCount() {
	       $.ajax({
	           url: "${pageContext.request.contextPath}/board/likeCount",
	           type: "get",
	           data: { boardNo: ${b.boardNo} },
	           success: function(count) {
	               $("#likeCount").text(count);
	           },
	           error: function() {
	               console.log("좋아요 카운트 조회 통신 실패");
	           }
	        });
	    }
	    
	    // [클릭] 좋아요 버튼 클릭 시 실행 (토글 방식)
	    function updateLike() {
	        // 실제로는 세션의 로그인 유저 번호를 사용해야 합니다 (예: ${loginUser.memNo})
	        // 현재는 테스트를 위해 1번 회원을 고정값으로 보냅니다.
	        const loginUserNo = 1; 

	        $.ajax({
	            url: "${pageContext.request.contextPath}/board/like",
	            type: "post",
	            data: { 
	                boardNo: ${b.boardNo},
	                memNo: loginUserNo 
	            },
	            success: function(result) {
	                if (result === "insert") {
	                    alert("이 게시글을 공감하였습니다.");
	                } else if (result === "delete") {
	                    alert("공감을 취소하였습니다.");
	                }
	                getLikeCount(); // 숫자를 최신 상태로 갱신
	            },
	            error: function() {
	                alert("로그인이 필요하거나 통신 중 오류가 발생했습니다.");
	            }
	        });
	    }
	     
	     
	    
    </script>
</body>
</html>