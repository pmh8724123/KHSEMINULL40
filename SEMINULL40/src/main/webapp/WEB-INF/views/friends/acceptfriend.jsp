<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="path" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>친구 수락</title>

<link rel="stylesheet" href="${path}/resources/css/addfriend.css">
</head>
<body>

	<div class="acceptfriend-wrap">

		<!-- 헤더 -->
		<div class="acceptfriend-header">
			<button class="back-btn" onclick="history.back()">&#8592;</button>
			<h3>친구 수락</h3>
			<c:if test="${not empty pendingList}">
				<span class="pending-count">${fn:length(pendingList)}건 대기중</span>
			</c:if>
		</div>

		<!-- 대기 요청 없을 때 -->
		<c:if test="${empty pendingList}">
			<div class="pending-empty">대기 중인 친구 요청이 없습니다</div>
		</c:if>

		<!-- 대기 요청 목록 -->
		<c:if test="${not empty pendingList}">
			<div class="pending-list" id="pendingList">
				<c:forEach var="p" items="${pendingList}">
					<div class="pending-item" id="item-${p.senderNo}">
						<span class="pending-name">${p.friendName}</span>
						<div class="pending-actions">
							<button class="accept-btn"
								onclick="handleRequest(${p.senderNo}, 'accept', this)">
								수락</button>
							<button class="reject-btn"
								onclick="handleRequest(${p.senderNo}, 'reject', this)">
								거절</button>
						</div>
					</div>
				</c:forEach>
			</div>
		</c:if>

	</div>

	<script>
	function handleRequest(senderNo, action, btn) {

	    $.ajax({
	        // /acceptfriend/accept 또는 /acceptfriend/reject로 요청
	        url  : '${path}/acceptfriend/' + action,
	        type : 'POST',
	        contentType: 'application/json',
	        data : JSON.stringify({ senderNo: senderNo }),
	        headers: { '${_csrf.headerName}': '${_csrf.token}' },

	        success: function(data) {
	            if (data.result === 'ok') {
	                const item = document.getElementById('item-' + senderNo);

	                item.querySelector('.pending-actions').innerHTML =
	                    '<span class="done-msg">' +
	                    (action === 'accept' ? '친구가 되었습니다' : '요청을 거절했습니다') +
	                    '</span>';

	                // 1.5초 후 해당 아이템 제거
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