<%@ page contentType="text/html;charset=UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="path" value="${pageContext.request.contextPath}" />


<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

<link rel="stylesheet" href="${path}/resources/css/mainpage.css">

<link rel="stylesheet" href="${path}/resources/css/friends.css">

<link rel="stylesheet" href="${path}/resources/css/schedule.css">

<!-- =============================================
     전체 마이페이지 + 출석체크 통합 스타일
     색상 기조: 기존 파란 계열 (#A1CFFF, #4a90e2) + 보라 계열 (#534AB7) 유지
     변경 항목: 레이아웃 간격 / 타이포 / 카드 그림자 / 탭 버튼 전환 효과
============================================= -->
<style>

/* ── 전체 컨테이너 ──────────────────────────────
   마이페이지 전체를 감싸는 최상위 박스            */
.mypage-container {
	width: 800px;
	margin: 50px auto;
	/* 추가: 좌우 여백 확보 (작은 화면 대비) */
	padding: 0 16px;
	box-sizing: border-box;
}

/* ── 페이지 제목 ────────────────────────────────
   "마이페이지" 타이틀 영역                        */
.title {
	margin-bottom: 24px; /* 기존 20px → 여백 살짝 넓힘 */
	font-size: 26px;
	font-weight: 700;
	color: #1a1a1a;
	letter-spacing: -0.5px; /* 추가: 자간 조임으로 타이틀 정돈 */
}

/* ── 탭 버튼 감싸는 래퍼 ───────────────────────
   탭 메뉴를 가운데 정렬                           */
.tab-wrapper {
	display: flex;
	justify-content: center;
	margin: 0 0 0px 0; /* 기존 30px → 탭과 콘텐츠 간격 제거 (탭-콘텐츠 연결감) */
}

/* ── 탭 버튼 묶음 ───────────────────────────────     */
.tab-menu {
	width: 800px;
	justify-content: center;
	background: #A1CFFF;
	padding: 10px;
	border-radius: 16px 16px 0 0;
	display: flex;
	gap: 8px;
	box-shadow: 0 -2px 12px rgba(74, 144, 226, 0.15);
	/* 위쪽 그림자로 띄워 보이는 효과 */
}

/* ── 개별 탭 버튼 기본 상태 ─────────────────────
   색상 유지, hover 추가                           */
.tab-btn {
	justify-content: center;
	width: 200px;
	padding: 10px 20px;
	border: 1px solid #4a90e2; /* 기존 색상 유지 */
	background: white;
	cursor: pointer;
	border-radius: 10px;
	font-size: 14px;
	font-weight: 500;
	color: #4a90e2; /* 추가: 텍스트도 파란색 계열로 통일 */
	transition: background 0.2s, color 0.2s, transform 0.1s;
	/* 추가: 전환 애니메이션 */
	display: flex; /* 추가: 아이콘 + 텍스트 수직 정렬 */
	align-items: center;
	gap: 6px;
}

/* ── 탭 버튼 호버 상태 (추가) ───────────────────
   누르기 전 미리 반응하는 느낌                    */
.tab-btn:hover:not(.active) {
	background: #e8f4ff;
	transform: translateY(-1px);
}

/* ── 선택된 탭 버튼 ───────────────────────────── */
.tab-btn.active {
	font-size: 15px;
	font-weight: 700;
	background: #4a90e2;
	color: white;
	box-shadow: 0 2px 8px rgba(74, 144, 226, 0.35);
	border-color: #4a90e2;
}

/* ── 탭 콘텐츠 전체 박스 ──────────────────────── */
.tab-content {
	background: #A1CFFF;
	min-height: 500px;
	border-radius: 0 0 16px 16px;
	overflow: hidden;
	border-top: 2px solid rgba(74, 144, 226, 0.3);
}

/* ── 개별 탭 패널 ───────────────────────────────
   기본 숨김 상태                                  */
.tab-panel {
	display: none;
	padding: 28px 24px;
	min-height: 100%;
	border: none;
	box-sizing: border-box;
}

/* ── 활성화된 패널 ──────────────────────────────
   선택된 탭 내용만 보임                           */
.tab-panel.active {
	display: block;
}

/* ── 친구 탭: 세로 스크롤 허용 ─────────────────
   친구가 많을 때 패널 내부만 스크롤               */
#friend.active {
	overflow-y: auto;
	max-height: 500px;
}
</style>








<!-- 아이콘 삽입용 CDN -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">


<jsp:include page="/WEB-INF/views/common2/header.jsp" />

<div class="mypage-container">

	<h1 class="title">마이페이지</h1>

	<!-- 탭 버튼 영역 -->
	<div class="tab-wrapper">
		<div class="tab-menu">

			<!-- 출석체크 탭 버튼 -->
			<button class="tab-btn active" onclick="showTab('attendance', this)">
				<i class="fa-regular fa-calendar-check"></i> 출석체크
			</button>

			<!-- 친구 탭 버튼 -->
			<button class="tab-btn" onclick="showTab('friend', this)">
				<i class="fa-solid fa-user-group"></i> 친구
			</button>

			<!-- 시간표 탭 버튼 -->
			<button class="tab-btn" onclick="showTab('timetable', this)">
				<i class="fa-solid fa-calendar-days"></i> 시간표
			</button>

			<!-- 설정 탭 버튼 -->
			<button class="tab-btn" onclick="showTab('setting', this)">
				<i class="fa-solid fa-gear"></i> 설정
			</button>

		</div>
	</div>

	<!-- =============================================
         탭 전환 스크립트
         - event.target 대신 this를 명시적으로 넘겨
           아이콘 클릭 시 버튼이 아닌 <i>에 active 붙는 사항 수정
    ============================================= -->
	<script>
        function showTab(tabName, clickedBtn) {

            // 모든 탭 버튼에서 active 제거
            document.querySelectorAll(".tab-btn")
                    .forEach(btn => btn.classList.remove("active"));

            // 모든 탭 패널 숨김
            document.querySelectorAll(".tab-panel")
                    .forEach(panel => panel.classList.remove("active"));

            // 클릭된 버튼에 active 추가
            // (this로 받아서 아이콘 클릭 시 버그 방지)
            clickedBtn.classList.add("active");

            // 해당 tabName의 패널 활성화
            document.getElementById(tabName).classList.add("active");
        }
    </script>


	<!-- =============================================
         탭 콘텐츠 영역
         모든 패널이 tab-content 안에 형제로 위치해야
         showTab() 의 display 제어가 정상 동작
    ============================================= -->
	<div class="tab-content">


		<!-- ── 출석체크 패널 ─────────────────────── -->
		<div id="attendance" class="tab-panel active">
			<div class="att-card">

				<!-- 카드 헤더: 제목(좌) + 현재 일차(우) -->
				<div class="att-header">
					<div>
						<p class="att-title">출석 체크</p>
						<p class="att-sub">7일 출석하고 포인트를 받으세요!</p>
					</div>
					<div style="text-align: right">
						<!-- JS attRender()가 동적으로 숫자 업데이트 -->
						<div class="att-day-num" id="attDayNum">1</div>
						<div class="att-day-label">일차</div>
					</div>
				</div>

				<!-- 출석 체크 버튼 -->
				<div class="att-btn-wrap">
					<button class="att-btn" id="attBtn">출석 체크하기</button>
				</div>

				<!-- 7개 날짜 도형 컨테이너 (JS가 동적 생성) -->
				<div class="att-days" id="attDots"></div>

				<!-- 진행률 바 -->
				<div class="att-progress-wrap">
					<div class="att-prog-labels">
						<span>진행률</span>
						<!-- JS가 "N / 7일" 형식으로 업데이트 -->
						<span id="attProgLabel">0 / 7일</span>
					</div>
					<div class="att-prog-bar">
						<!-- JS가 width % 를 조절해 진행률 표시 -->
						<div class="att-prog-fill" id="attProgFill" style="width: 0%"></div>
					</div>
				</div>

				<!-- 특정 일차 달성 시 보상 메시지 (JS가 텍스트 삽입) -->
				<div class="att-reward" id="attReward"></div>

			</div>
			<!-- /att-card -->

			<script>
			    var CSRF_TOKEN   = '${_csrf.token}';
			    var CSRF_HEADER  = '${_csrf.headerName}';
			    var CONTEXT_PATH = '<%=request.getContextPath()%>';
			</script>
			<script src="${path}/resources/js/attendance.js"></script>

		</div>
		<!-- /attendance -->


		<!-- ── 친구 패널 ──────────────────────────────────────── -->
		<div id="friend" class="tab-panel">

			<!-- 상단: 제목 + 버튼 -->
			<div class="friend-header">
				<div>
					<h3>친구 목록</h3>
					<c:if test="${not empty friendList}">
						<p>친구 ${fn:length(friendList)}명</p>
					</c:if>
				</div>
				<div class="friend-actions">
					<!-- 친구 추가 페이지로 이동 -->
					<button class="friend-btn"
						onclick="location.href='${pageContext.request.contextPath}/addfriend'">
						친구 추가</button>
					<!-- 수락 대기 중인 친구 요청 페이지로 이동 -->
					<button class="friend-btn"
						onclick="location.href='${pageContext.request.contextPath}/acceptfriend'">
						친구 수락</button>
				</div>
			</div>

			<!-- 친구가 없을 때 -->
			<c:if test="${empty friendList}">
				<div class="friend-empty">
					<p>친구가 없습니다</p>
				</div>
			</c:if>

			<!-- 친구 목록 -->
			<c:if test="${not empty friendList}">
				<c:forEach var="f" items="${friendList}">
					<div class="friend-item">
						<div class="friend-info">
							<%-- 프로필 이미지 (사용 시 주석 해제)
                    <img src="${path}/resources/profile/${f.profileImg}"
                         class="profile-img" alt="${f.memberName} 프로필"> --%>
							<div class="friend-text">
								<!-- 친구 이름 (receiverNo 기준으로 상대방 이름 표시) -->
								<span class="friend-name">${f.memberName}</span>
								<!-- 온라인 여부: status 'O' = 온라인 -->
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
			</c:if>

		</div>
		<!-- /friend -->

		<!-- ── 시간표 패널 ─────────────────────────────── -->
		<div id="timetable" class="tab-panel">

			<!-- 상단 바: 시간표 선택 드롭다운(좌) + +/- 버튼(우) -->
			<div class="tt-topbar">
				<div class="tt-title-wrap" id="ttTitleWrap">
					<!-- 드롭다운 버튼: onclick 제거, id 추가 -->
					<button class="tt-title-btn" id="ttTitleBtn">
						<span id="ttTitleText">2026년도 1학기 시간표</span> <span
							style="font-size: 11px">▼</span>
					</button>
					<div class="tt-dropdown" id="ttDropdown"></div>
					<div class="tt-plusminus">
						<!-- + 버튼: onclick 제거, id 추가 -->
						<button id="ttBtnAdd" title="시간표 추가" style="color: #4a90e2">+</button>

						<!-- − 버튼: onclick 제거, id 추가 -->
						<button id="ttBtnMinus" title="시간표 삭제" style="color: #E24B4A">−</button>
					</div>
				</div>
			</div>

			<!-- 시간표 그리드 (JS가 동적 렌더링) -->
			<div class="tt-grid-wrap">
				<div class="tt-grid" id="ttGrid"></div>
			</div>

			<!-- 삭제 모드 안내 메시지 -->
			<div class="tt-del-hint" id="ttDelHint"></div>

			<!-- 하단 버튼: 강의 추가 / 강의 삭제 -->
			<div class="tt-bottombar">
				<!-- 강의 추가 버튼: onclick 제거, id 추가 -->
				<button class="btn-tt-add" id="ttBtnOpenModal">강의 추가</button>

				<!-- 강의 삭제 버튼: onclick 제거 (id="ttBtnDel" 은 기존 유지) -->
				<button class="btn-tt-del" id="ttBtnDel">강의 삭제</button>
			</div>

			<!-- 강의 추가 모달 (버튼 클릭 시 펼쳐짐) -->
			<div class="tt-overlay" id="ttOverlay">
				<div class="tt-modal">
					<h3>강의 추가</h3>

					<label>강의명</label> <input type="text" id="ttInpTitle"
						placeholder="예: 데이터베이스"> <label>요일</label> <select
						id="ttInpDay">
						<option value="0">월요일</option>
						<option value="1">화요일</option>
						<option value="2">수요일</option>
						<option value="3">목요일</option>
						<option value="4">금요일</option>
					</select> <label>시작 시간</label> <select id="ttInpStart"></select> <label>종료
						시간</label> <select id="ttInpEnd"></select>

					<!-- 유효성 에러 메시지 출력 영역 -->
					<div class="tt-hint" id="ttModalHint"></div>

					<div class="tt-modal-actions">
						<!-- 확인 버튼: onclick 제거, id 추가 -->
						<button class="btn-tt-confirm" id="ttBtnConfirm">확인</button>

						<!-- 취소 버튼: onclick 제거, id 추가 -->
						<button class="btn-tt-cancel" id="ttBtnCancel">취소</button>
					</div>
				</div>
			</div>


			<script src="${path}/resources/js/schedule.js"></script>

		</div>
		<!-- /timetable -->


		<!-- ── 설정 패널 ───────────────────────────── -->
		<div id="setting" class="tab-panel">
			<h3>설정 영역</h3>
		</div>


	</div>
	<!-- /tab-content -->

</div>
<!-- /mypage-container -->


<jsp:include page="/WEB-INF/views/common2/footer.jsp" />
