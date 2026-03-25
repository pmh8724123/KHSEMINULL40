<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    
    /* 본문 내 이미지/텍스트 스타일 */
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
    
    /* 댓글 스타일 생략 (기존과 동일) */
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
    
    <div class="detail-wrapper">
        <div class="post-section">
            <div class="post-header">
                <h2 class="post-title">${b.boardTitle}</h2>
                <button class="edit-btn" onclick="location.href='${pageContext.request.contextPath}/board/updateForm?boardno=${b.boardNo}'">수정</button>
            </div>
            
            <div class="post-info">
                작성자 <b>${b.boardWriter}</b> &nbsp;|&nbsp; 조회수 <b>${b.viewCount}</b> &nbsp;|&nbsp; 작성일 <b>${b.createDate}</b>
            </div>
            
            <div class="post-content">
                <!-- [본문 이미지 출력] -->
                <c:if test="${not empty list}">
                    <div class="content-img-area">
                        <c:forEach var="f" items="${list}">
                            <%-- 확장자 체크하여 이미지만 본문에 출력 --%>
                            <c:set var="fileName" value="${f.changeName.toLowerCase()}" />
                            <c:if test="${fileName.endsWith('.jpg') || fileName.endsWith('.png') || fileName.endsWith('.jpeg') || fileName.endsWith('.gif')}">
                                <img src="${pageContext.request.contextPath}/resources/upload_files/${f.changeName}">
                            </c:if>
                        </c:forEach>
                    </div>
                </c:if>

                <!-- [본문 텍스트 출력] -->
                <div class="text-area">${b.boardContent}</div>
            </div>
        </div>
        
        <div class="action-group">
            <button class="action-btn" onclick="updateLike();">👍 좋아요 <span id="likeCount">0</span></button>
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
            <div id="replyListArea"></div>
        </div>
    </div>

    <script>
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
                                        <div style='font-size:12px; color:#888;'><span>답글</span> | <span onclick='deleteReply(\${r.replyNo})' style='color:red; cursor:pointer;'>삭제</span></div>
                                     </div>`;
                        });
                    } else {
                        html = "<p style='text-align:center; color:#999; padding:20px;'>등록된 댓글이 없습니다.</p>";
                    }
                    $("#replyListArea").html(html);
                }
            });
        }

        function addReply() {
            const content = $("#replyContent").val();
            if (!content.trim()) return;
            $.ajax({
                url: "${pageContext.request.contextPath}/reply/insert",
                type: "post",
                data: { boardNo: "${b.boardNo}", replyContent: content, replyWriter: 1 },
                success: function(result) {
                    if (result === "success") {
                        $("#replyContent").val("");
                        selectReplyList();
                    }
                }
            });
        }

        function getLikeCount() {
            $.ajax({
                url: "${pageContext.request.contextPath}/board/likeCount",
                data: { boardNo: "${b.boardNo}" },
                success: function(count) { $("#likeCount").text(count); }
            });
        }

        function updateLike() {
            $.ajax({
                url: "${pageContext.request.contextPath}/board/like",
                type: "post",
                data: { boardNo: "${b.boardNo}", memNo: 1 },
                success: function(result) {
                    getLikeCount();
                    alert(result === "insert" ? "공감하였습니다." : "공감을 취소하였습니다.");
                }
            });
        }
    </script>
</body>
</html>