<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<c:set var="path" value="${pageContext.request.contextPath}" />

<html>
<head>
<meta charset="UTF-8">
<title>친구 추가</title>

<link rel="stylesheet" href="${path}/resources/css/addfriend.css">

<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

</head>
<body>

	<div class="addfriend-wrap">

		<!-- 헤더 -->
		<div class="addfriend-header">
			<button class="back-btn" onclick="history.back()">&#8592;</button>
			<h3>친구 추가</h3>
		</div>

		<!-- 검색창 -->
		<div class="search-box">
			<input type="text" id="searchInput" placeholder="이름으로 검색하세요"
				onkeydown="if(event.key==='Enter') searchFriend()">
			<button class="search-btn" onclick="searchFriend()">검색</button>
		</div>

		<!-- 검색 결과 -->
		<div class="result-list" id="resultList">
			<div class="result-guide">이름을 입력하고 검색해보세요</div>
		</div>

	</div>

	<script>
const token = document.querySelector('meta[name="_csrf"]').content;
const header = document.querySelector('meta[name="_csrf_header"]').content;

    function searchFriend() {
        const keyword = document.getElementById('searchInput').value.trim();
        if (!keyword) return;

        fetch('${path}/addfriend/search?keyword=' + encodeURIComponent(keyword))
            .then(res => res.json())
            .then(data => {
                const list = document.getElementById('resultList');

                if (!data || data.length === 0) {
                    list.innerHTML = '<div class="result-empty">검색 결과가 없습니다</div>';
                    return;
                }

                list.innerHTML = data.map(user => `
                    <div class="result-item">
                        <span class="result-name">\${user.memName}</span>
                        <button class="add-btn \${user.requested ? 'sent' : ''}"
                                \${user.requested ? 'disabled' : ''}
                                onclick="sendRequest(\${user.memNo}, this)">
                            \${user.requested ? '신청됨' : '친구 신청'}
                        </button>
                    </div>
                `).join('');
            });
    }

    function sendRequest(receiverNo, btn) {
        fetch('${path}/addfriend/request', {
            method: 'POST',
            headers: { 
                'Content-Type': 'application/json',
                [header]: token // 헤더에 CSRF 토큰 추가
            },
            body: JSON.stringify({ receiverNo: receiverNo })
        })
        .then(res => res.json())
        .then(data => {
            if (data.result === 'ok') {
                btn.textContent = '신청됨';
                btn.classList.add('sent');
                btn.disabled = true;
            }else if (data.result === 'already') {
                alert(data.message); // "이미 친구 신청을 보냈습니다."
                btn.textContent = '신청됨';
                btn.disabled = true;
            } else {
                alert("신청 실패: 다시 시도해주세요.");
            }
        })
        .catch(err => console.error('Error:', err));
    }
</script>

</body>
</html>