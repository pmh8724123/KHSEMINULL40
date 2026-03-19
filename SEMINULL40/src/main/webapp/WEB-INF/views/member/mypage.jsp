<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="path" value="${pageContext.request.contextPath}" />

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/mainpage.css">


<style>
.mypage-container {
	width: 800px;
	margin: 50px auto;
}

.title {
	margin-bottom: 20px;
}

.tab-wrapper {
	display: flex;
	justify-content: center;
	margin: 30px 0;
}

/* 탭 버튼 */
.tab-menu {
	width: 800px;
	justify-content: center;
	background: #A1CFFF;
	padding: 10px;
	border-radius: 20px;
	display: flex;
	gap: 10px;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.tab-btn {
	justify-content: center;
	width: 200px;
	padding: 10px 20px;
	border: 1px solid #4a90e2;
	background: white;
	cursor: pointer;
	border-radius: 10px;
}

/* 선택된 버튼 */
.tab-btn.active {
	font-size: 20px;
	font-weight: bold;
	background: #4a90e2;
	color: white;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}

/* 내용 */
.tab-content {
	background: #A1CFFF;
	height: 500px;
	border-radius: 15px;
	overflow: hidden;
}

.tab-panel {
	display: none;
	padding: 20px;
	height: 100%;
	border: 1px solid #ddd;
}

/* 활성화된 내용 */
.tab-panel.active {
	display: block;
}

#friend.active {
	overflow-y: auto;
}
</style>

<!-- 아이콘 삽입용 cdn -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">


<!-- friend.css 삽입 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/friend.css">

<jsp:include page="/WEB-INF/views/common2/header.jsp" />

<div class="mypage-container">

	<h1 class="title">마이페이지</h1>

	<!-- 탭 버튼 -->
	<div class="tab-wrapper">
		<div class="tab-menu">

			<button class="tab-btn active" onclick="showTab('attendance')">
				<i class="fa-regular fa-calendar-check"></i> 출석체크
			</button>

			<button class="tab-btn" onclick="showTab('friend')">
				<i class="fa-solid fa-user-group"></i> 친구
			</button>

			<button class="tab-btn" onclick="showTab('timetable')">
				<i class="fa-solid fa-calendar-days"></i> 시간표
			</button>

			<button class="tab-btn" onclick="showTab('setting')">
				<i class="fa-solid fa-gear"></i> 설정
			</button>

		</div>
	</div>

	<script>
		function showTab(tabName) {

    		// 모든 버튼 비활성화
    		const buttons = document.querySelectorAll(".tab-btn");
    		buttons.forEach(btn => btn.classList.remove("active"));

    		// 모든 내용 숨김
    		const panels = document.querySelectorAll(".tab-panel");
    		panels.forEach(panel => panel.classList.remove("active"));

    		// 선택된 버튼 활성화
   			event.target.classList.add("active");

    		// 선택된 내용 보여주기
    		document.getElementById(tabName).classList.add("active");
		}
	</script>


	<!-- 내용 영역 -->
	<div class="tab-content">

		<div id="attendance" class="tab-panel active">
			<h2>출석 체크</h2>
			<br> <br> <b>매일 출석하고 포인트를 받으세요 !</b>

			<div id="attendDays"></div>

		</div>

		<div id="friend" class="tab-panel">

			<!-- 친구 상단 -->
			<div class="friend-header">
				<div>
					<h3>친구 목록</h3>
					<!-- 친구 몇명인지 DB에서 가져오기 -->
					<p>친구 N명</p>
				</div>

				<div class="friend-actions">
					<!-- 버튼 클릭 시 친구 추가 페이지로 이동 -->
					<button class="friend-btn">친구 추가</button>

					<!-- 버튼 클릭 시 친구 수락 대기 페이지로 이동 (친구 추가 페이지와 UI 비슷) -->
					<button class="friend-btn">친구 수락</button>
				</div>
			</div>

			<!-- 친구 리스트 -->
			<!-- 
				이름과 프로필 보기 클릭시 친구 프로필로 이동
				채팅방 열기 클릭 시 해당 친구와의 채팅방으로 이동
			 -->
			<c:forEach var="f" items="${friendList}">

				<div class="friend-item">

					<div class="friend-info">

						<img src="${path}/resources/profile/${f.profileImg}"
							class="profile-img">

						<div class="friend-text">
							<span>${f.memberName}</span>

							<c:choose>
								<c:when test="${f.status eq 'O'}">
									<span class="online">온라인</span>
								</c:when>
								<c:otherwise>
									<span class="offline">오프라인</span>
								</c:otherwise>
							</c:choose>

						</div>
					</div>

				</div>

			</c:forEach>





			<div id="timetable" class="tab-panel">
				<h3>시간표 $</h3>
			</div>

			<div id="setting" class="tab-panel">
				<h3>설정 영역</h3>
			</div>

		</div>

	</div>
	
	</div>

	<jsp:include page="/WEB-INF/views/common2/footer.jsp" />