<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>신고하기</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
    body {
        background-color: #f2f7ff;
        font-family: 'Pretendard', sans-serif;
        margin: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }
    .report-container {
        width: 400px;
        background: white;
        border: 1px solid #999;
        padding: 40px 30px;
        border-radius: 10px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }
    h2 {
        text-align: center;
        font-size: 32px;
        font-weight: bold;
        margin-top: 0;
        margin-bottom: 30px;
    }
    .label {
        font-size: 14px;
        font-weight: bold;
        margin-bottom: 10px;
    }
    select {
        width: 100%;
        padding: 12px;
        border: 1px solid #333;
        border-radius: 15px;
        font-size: 16px;
        background-color: white;
        cursor: pointer;
        margin-bottom: 20px;
    }
    #otherReasonArea {
        display: none;
        margin-bottom: 20px;
    }
    textarea {
        width: 100%;
        height: 150px;
        padding: 15px;
        border: 1px solid #333;
        border-radius: 20px;
        resize: none;
        box-sizing: border-box;
        font-size: 14px;
        text-align: center;
    }
    .btn-area {
        text-align: center;
    }
    .submit-btn {
        width: 160px;
        padding: 12px;
        background-color: #31a1ff;
        color: white;
        border: none;
        border-radius: 25px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }
    .submit-btn:hover { background-color: #1e88e5; }
</style>
</head>
<body>

    <sec:authorize access="isAuthenticated()">
        <sec:authentication property="principal.member" var="loginUser" />
    </sec:authorize>

    <div class="report-container">
        <h2>신고</h2>
        
        <div class="label">신고 사유</div>
        <select id="reasonNo">
            <option value="" disabled selected>신고 사유를 선택해주세요</option>
            <option value="1">명예훼손 및 인격 모독</option>
            <option value="2">개인정보 노출</option>
            <option value="3">불법 정보 및 범죄</option>
            <option value="4">음란성 / 선정성</option>
            <option value="5">운영방해</option>
        </select>

        <div id="otherReasonArea">
            <textarea id="reasonContent" placeholder="기타 신고 사유 텍스트 박스&#10;기타를 선택했을 때만 보이게"></textarea>
        </div>

        <div class="btn-area">
            <button class="submit-btn" onclick="submitReport();">신고</button>
        </div>
    </div>

    <script>
        const token = $("meta[name='_csrf']").attr("content");
        const header = $("meta[name='_csrf_header']").attr("content");

        $(function() {
            $.ajaxSetup({
                beforeSend: function(xhr) {
                    if (header && token) xhr.setRequestHeader(header, token);
                }
            });

            $("#reasonNo").on("change", function() {
                if ($(this).val() == "6") {
                    $("#otherReasonArea").show();
                } else {
                    $("#otherReasonArea").hide();
                    $("#reasonContent").val("");
                }
            });
        });

        function submitReport() {
            const reasonNo = $("#reasonNo").val();
            const reasonContent = $("#reasonContent").val();
            const boardNo = "${boardNo}";
            const memNo = "${not empty loginUser ? loginUser.memNo : 0}";

            if (memNo == "0") {
                alert("로그인이 필요합니다.");
                return;
            }

            if (!reasonNo) {
                alert("신고 사유를 선택해주세요.");
                return;
            }

            if (reasonNo == "6" && !reasonContent.trim()) {
                alert("기타 사유를 입력해주세요.");
                return;
            }

            if (confirm("정말로 이 게시글을 신고하시겠습니까?")) {
                $.ajax({
                    url: "${pageContext.request.contextPath}/board/report",
                    type: "post",
                    data: {
                        reasonNo: reasonNo,
                        reasonContent: reasonContent,
                        targetNo: boardNo,
                        targetType: 'BOARD',
                        reportMem: memNo
                    },
                    success: function(result) {
                        if (result.trim() === "success") {
                            alert("신고가 정상적으로 접수되었습니다.");
                            window.close();
                        } else {
                            alert("신고 접수에 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("서버 통신 오류가 발생했습니다.");
                    }
                });
            }
        }
    </script>
</body>
</html>