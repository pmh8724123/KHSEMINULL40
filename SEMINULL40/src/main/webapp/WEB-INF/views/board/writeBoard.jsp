<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 1. JSTL 선언 추가 (이게 없으면 <c:if>가 작동 안 해서 boardNo 에러가 납니다) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${not empty b ? '게시글 수정' : '새 게시글 작성'}</title>
<style>
    body{ background-color: #f2f7ff; margin: 0; padding : 0; font-family: 'Pretendard', sans-serif; }
    .write-wrapper{ width: 100%; max-width: 650px; margin: 50px auto; border: 1px solid #333; border-radius: 35px; padding: 50px; box-sizing: border-box; background-color: #f2f7ff; }
    .write-title{ font-size: 42px; font-weight: bold; margin-bottom: 35px; }
    .form-group{ margin-bottom: 25px; }
    .form-group label{ display: block; font-size: 15px; margin-bottom: 10px; font-weight: bold; }
    .input-style{ width: 100%; padding: 15px 15px; border: 1px solid #333; border-radius: 20px; background-color: white; font-size: 16px; box-sizing: border-box; outline: none; }
    textarea.input-style{ min-height: 200px; resize: none; overflow-y: hidden; line-height: 1.5; }
    .file-box{ border: 1px solid #333; border-radius: 20px; padding: 20px; background-color: white; margin-bottom: 20px; }
    .file-select-btn{ background-color:#a2cfff; border: none; padding: 8px 20px; border-radius: 12px; font-weight: bold; cursor: pointer; margin-bottom: 10px; }
    .file-list{ list-style: none; padding: 0; margin: 0; }
    .file-item{ display: flex; justify-content: space-between; align-items: center; padding: 5px 0; font-size: 15px; }
    .preview-container{ display: flex; gap: 15px; margin-bottom: 10px; }
    .preview-box{ flex: 1; aspect-ratio: 1 / 1; border: 1px solid #333; border-radius: 20px; background-color: white; display: flex; justify-content: center; align-items: center; text-align: center; font-size: 14px; font-weight: bold; }
    .bottom-line{ border: 0; border-top: 1px solid #333; margin: 30px 0 25px 0; }
    .btn-group{ display: flex; justify-content: flex-end; gap: 20px; }
    .btn{ width: 180px; padding: 16px 0; border: 1px solid #333; border-radius: 18px; font-size: 18px; font-weight: bold; cursor: pointer; background-color: #a2cfff; }
</style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/common/header.jsp" /> 
    
    <div class="write-wrapper">
        <div class="write-title">${not empty b ? '게시글 수정' : '새 게시글 작성'}</div>
        
        <form action="${pageContext.request.contextPath}/board/${not empty b ? 'update.bo' : 'insert.bo'}" 
              method="post" enctype="multipart/form-data">
            
            <%-- 2. 수정 시에만 boardNo 전송 (JSTL 선언 덕분에 이제 정상 작동합니다) --%>
            <c:if test="${not empty b}">
                <input type="hidden" name="boardNo" value="${b.boardNo}">
            </c:if>

            <!-- 카테고리 선택 -->
            <div class="form-group">
                <label>카테고리</label>
                <select class="input-style" name="ubtypeNo" required>
                    <option value="">카테고리를 선택하세요</option>
                    <option value="1" ${ (b.ubtypeNo == 1)? 'selected' : ''}>자유게시판</option>
                    <option value="2" ${ (b.ubtypeNo == 2)? 'selected' : ''}>질문답변</option>
                    <option value="3" ${ (b.ubtypeNo == 3)? 'selected' : ''}>공지사항</option>
                </select>
            </div>

            <!-- 제목 입력 (name을 VO 필드명인 boardTitle로 변경) -->
            <div class="form-group">
                <label>제목</label>
                <input type="text" class="input-style" name="boardTitle" 
                       value="${b.boardTitle}" placeholder="제목을 입력하세요" required>
            </div>

            <!-- 내용 입력 (name을 VO 필드명인 boardContent로 변경) -->
            <div class="form-group">
                <label>내용</label>
                <textarea class="input-style" name="boardContent" placeholder="내용을 입력하세요" required>${b.boardContent}</textarea>
            </div>

            <!-- 첨부파일 -->
            <div class="form-group">
                <label>첨부파일</label>
                <div class="file-box">
                    <button type="button" class="file-select-btn" onclick="document.getElementById('fileInput').click();">첨부파일 선택</button>
                    <input type="file" id="fileInput" name="upfiles" style="display:none;" multiple onchange="updateFiles(this)">
                    <ul class="file-list" id="fileListDisplay"></ul>
                </div>
            </div>

            <div class="preview-container">
                <div class="preview-box">미리보기 1</div>
                <div class="preview-box">미리보기 2</div>
                <div class="preview-box">미리보기 3</div>
            </div>

            <hr class="bottom-line">

            <div class="btn-group">
                <button type="button" class="btn" onclick="history.back();">취소</button>
                <button type="submit" class="btn">${not empty b ? '수정하기' : '게시하기'}</button>
            </div>
        </form>
    </div>

    <script>
        function updateFiles(input) {
            const listDisplay = document.getElementById('fileListDisplay');
            listDisplay.innerHTML = ''; 
            for (let i = 0; i < input.files.length; i++) {
                const li = document.createElement('li');
                li.className = 'file-item';
                li.innerHTML = `<span>\${input.files[i].name}</span><span style="color:red; cursor:pointer;">✕</span>`;
                listDisplay.appendChild(li);
            }
        }
    </script>
</body>
</html>