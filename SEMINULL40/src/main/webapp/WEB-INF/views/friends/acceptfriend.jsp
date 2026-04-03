<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="path" value="${pageContext.request.contextPath}" />


<html>
<head>
<meta charset="UTF-8">
<title>친구 수락</title>

<link rel="stylesheet" href="${path}/resources/css/addfriend.css">

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />
</head>
<body>

	<body>
	<div class="friends-layout-container">
        
        <div class="acceptfriend-wrap"> <div
				class="acceptfriend-header">
                <button class="back-btn" onclick="history.back()">&#8592;</button>
                <h3>친구 수락</h3>
                <c:if test="${not empty pendingList}">
                    <span class="pending-count">${fn:length(pendingList)}건 대기중</span>
                </c:if>
            </div>

            <c:if test="${empty pendingList}">
                <div class="pending-empty">
                    <div class="empty-icon">✉️</div>
                    <p>대기 중인 친구 요청이 없습니다</p>
                </div>
            </c:if>

            <c:if test="${not empty pendingList}">
                <div class="pending-list" id="pendingList">
                    <c:forEach var="p" items="${pendingList}">
                        <div class="pending-item"
							id="item-${p.senderNo}">
                            <span class="pending-name">${p.friendName}</span>
                            <div class="pending-actions">
                                <button class="accept-btn"
									onclick="handleRequest(${p.senderNo}, 'accept', this)">수락</button>
                                <button class="reject-btn"
									onclick="handleRequest(${p.senderNo}, 'reject', this)">거절</button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>

        <div class="friends-side-info">
            <div class="side-card">
                <h4>✅ 수락 대기 중</h4>
                <p>나에게 친구 요청을 보낸 사용자 목록입니다. 수락 시 즉시 시간표가 공유됩니다.</p>
            </div>
        </div>

    </div>
	<script>
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
	
	function handleRequest(senderNo, action, btn) {

	    $.ajax({
	        // /acceptfriend/accept 또는 /acceptfriend/reject로 요청
	        url  : '${path}/friends/acceptfriend/' + action,
	        type : 'POST',
	        // 서버로 보내는 데이터 형식 지정
	        contentType: 'application/json',
	        data : JSON.stringify({ senderNo: senderNo }),
	        headers: { '${_csrf.headerName}': '${_csrf.token}' },

	        success: function(data) {
	            if (data.result === 'ok') {
	                const item = document.getElementById('item-' + senderNo);

	                item.querySelector('.pending-actions').innerHTML =
	                    '<span class="done-msg">' +
	                    (action === 'accept' ? '님과 친구가 되었습니다' : '요청을 거절했습니다') +
	                    '</span>';

	                // 1.5초 후 해당 아이템 제거
	                // 서서히 사라지게 만드는 효과(fade out)
	                setTimeout(() => {
	                    item.style.transition = 'opacity .3s';
	                    item.style.opacity = '0';
	                    setTimeout(() => item.remove(), 300);
	                }, 1500);
	            }
	        },

	        error: function() {
	            alert('처리 중 오류가 발생했습니다.');
	        }
	    });
	}
</script>

</body>


</html>