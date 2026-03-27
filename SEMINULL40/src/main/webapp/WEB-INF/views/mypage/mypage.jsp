<%@ page contentType="text/html;charset=UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<c:set var="path" value="${pageContext.request.contextPath}" />


<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<!-- 1순위 적용 -->
<link rel="stylesheet" href="${path}/resources/css/mainpage.css">


<link rel="stylesheet" href="${path}/resources/css/attendance.css">

<link rel="stylesheet" href="${path}/resources/css/friends.css">

<link rel="stylesheet" href="${path}/resources/css/schedule.css">

<link rel="stylesheet" href="${path}/resources/css/setting.css">


<!-- =============================================
     공통 마이페이지 스타일 
     색상 : 기존 파란 계열 (#A1CFFF, #4a90e2) + 보라 계열 (#534AB7)
============================================= -->
<style>

/* ── 전체 컨테이너 ──────────────────────────────
   마이페이지 전체를 감싸는 최상위 박스            */
.mypage-container {
	width: 800px;
	margin: 50px auto; /* 좌우 여백 확보 (작은 화면 대비) */
	padding: 0 16px;
	box-sizing: border-box;
}

/* ── 페이지 제목 ────────────────────────────────
   "마이페이지" 타이틀 영역                        */
.title {
	margin-bottom: 24px;
	font-size: 26px;
	font-weight: 700;
	color: #1a1a1a;
	letter-spacing: -0.5px; /* 자간 조임으로 타이틀 정돈 */
}

/* ── 탭 버튼 감싸는 래퍼 ───────────────────────
   탭 메뉴를 가운데 정렬                           */
.tab-wrapper {
	display: flex;
	justify-content: center;
	margin: 0 0 0px 0;
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
	border: 1px solid #4a90e2;
	background: white;
	cursor: pointer;
	border-radius: 10px;
	font-size: 14px;
	font-weight: 500;
	color: #4a90e2;
	transition: background 0.2s, color 0.2s, transform 0.1s;
	/* 전환 애니메이션 */
	display: flex;
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
	/* min-height: 100%; */
	border: none;
	box-sizing: border-box;
}

/* ── 활성화된 패널 ──────────────────────────────
   선택됐을 때만 보이게 선택은 .active로 구별                          */
.tab-panel.active {
	display: block;
}

#friend.tab-panel.active {
	display: flex;
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


<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="mypage-container">

	<h1 class="title">마이페이지</h1>

	<!-- 탭 버튼 영역 -->
	<div class="tab-wrapper">
		<div class="tab-menu">
			<button class="tab-btn ${category == 'attendance' ? 'active' : ''}" onclick="showTab('attendance')">
				<i class="fa-regular fa-calendar-check"></i> 출석체크
			</button>
			<button class="tab-btn ${category == 'friend' ? 'active' : ''}" onclick="showTab('friend')">
				<i class="fa-solid fa-user-group"></i> 친구
			</button>
			<button class="tab-btn ${category == 'timetable' ? 'active' : ''}" onclick="showTab('timetable')">
				<i class="fa-solid fa-calendar-days"></i> 시간표
			</button>
			<button class="tab-btn ${category == 'setting' ? 'active' : ''}" onclick="showTab('setting')">
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
        function showTab(tabName) {
        	location.href = "${pageContext.request.contextPath}/mypage?category=" + tabName;
        }
    </script>


	<!-- =============================================
         탭 콘텐츠 영역
         모든 패널이 tab-content 안에 형제로 위치해야
         showTab() 의 display 제어가 정상 동작
    ============================================= -->
	<div class="tab-content">
		<!-- ── 출석체크 패널 ─────────────────────── -->
		<!-- <div id="attendance" class="tab-panel active"> -->
		<div id="attendance"
			class="tab-panel ${category == 'attendance' ? 'active' : ''}">
			<div class="att-card">

				<!-- 카드 헤더: 제목(좌) + 현재 일차(우) -->
				<div class="att-header">
					<div>
						<p class="att-title">출석 체크</p>
						<p class="att-sub">7일 출석하고 포인트를 받으세요!</p>
					</div>
					<div style="text-align: right">
						<div class="att-day-num">${attCnt}</div>
						<div class="att-day-label">일차</div>
					</div>
				</div>

				<form:form action="${path}/attendance/updateAtt" method="post">
					<div class="att-btn-wrap" name>
						<c:choose>
							<c:when test="${attCnt >= 7}">
								<button class="att-btn" disabled>출석 완료</button>
							</c:when>

							<c:when test="${checkedToday}">
								<button class="att-btn" disabled style="font-size: 12px">
									내일 오전 12시에 가능합니다</button>
							</c:when>

							<c:otherwise>
								<button type="submit" class="att-btn">출석 체크하기</button>
							</c:otherwise>
						</c:choose>
					</div>
				</form:form>

				<div class="att-days">
					<c:forEach var="i" begin="1" end="7">
						<c:set var="cls" value="att-dot" />

						<c:if test="${i <= attCnt}">
							<c:set var="cls" value="${cls} done" />
						</c:if>

						<c:if test="${i == attCnt + 1}">
							<c:set var="cls" value="${cls} today" />
						</c:if>

						<div class="${cls}">
							<span>${i}</span> <span class="di"> <c:choose>
									<c:when test="${i <= attCnt}">✔</c:when>
									<c:otherwise>일</c:otherwise>
								</c:choose>
							</span>
						</div>
					</c:forEach>
				</div>

				<!-- 진행률 바 -->
				<div class="att-progress-wrap">
					<div class="att-prog-labels">
						<span>진행률</span> <span>${attCnt} / 7일</span>
					</div>
					<div class="att-prog-bar">
						<div class="att-prog-fill" style="width: ${(attCnt / 7.0) * 100}%">
						</div>
					</div>
				</div>

				<div class="att-reward">
					<c:choose>
						<c:when test="${attCnt == 5}">포인트 +10</c:when>
						<c:when test="${attCnt == 6}">포인트 +10</c:when>
						<c:when test="${attCnt == 7}">포인트 +50 (7일 달성!)</c:when>
					</c:choose>
				</div>

			</div>
		</div>




		<!-- /attendance -->


		<!-- ── 친구 패널 ──────────────────────────────────────── -->
		<!-- <div id="friend" class="tab-panel"> -->
		<div id="friend"
			class="tab-panel ${category == 'friend' ? 'active' : ''}">
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
						onclick="location.href='${path}/addfriend'">친구 추가</button>
					<!-- 수락 대기 중인 친구 요청 페이지로 이동 -->
					<button class="friend-btn"
						onclick="location.href='${path}/acceptfriend'">친구 수락</button>
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
                         class="profile-img" alt="${f.memName} 프로필"> --%>
							<div class="friend-text">
								<!-- 친구 이름 / receiverNo(memNo) 기준으로 상대방 이름 표시 -->
								<span class="friend-name">${f.memName}</span>
								<!-- 온라인 여부 / status 'O' = 온라인 -->
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
		<!-- <div id="timetable" class="tab-panel"> -->
		<div id="timetable"
			class="tab-panel ${category == 'timetable' ? 'active' : ''}">

			<!-- 상단 바: 시간표 선택 드롭다운(좌) ,  +/- 버튼(우) -->
			<div class="tt-topbar">
				<div class="tt-title-wrap" id="ttTitleWrap">
					<!-- 드롭다운 버튼: onclick 제거, id 추가 -->
					<button class="tt-title-btn" id="ttTitleBtn">
						<span id="ttTitleText">2026년도 1학기 시간표</span> <span
							style="font-size: 11px">▼</span>
					</button>
					<div class="tt-dropdown" id="ttDropdown"></div>
					<div class="tt-plusminus">
						<!--  + 버튼 : prompt로 강의 제목을 받고, 그 강의에 대한 요일, 시간 설정 -->
						<button id="ttBtnAdd" title="시간표 추가" style="color: #4a90e2">+</button>

						<!--  - 버튼 : 클릭 시 삭제 모드 활성화  -->
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
		<!-- <div id="setting" class="tab-panel"> -->
		<div id="setting"
			class="tab-panel ${category == 'setting' ? 'active' : ''}">

			<!-- 개인정보 수정 카드 -->
			<div class="setting-card">
				<h3 class="setting-card-title">개인정보 수정</h3>

				<div class="setting-form">

					<!-- 프로필 이미지 -->
					<%-- <div class="setting-profile-wrap">
						<div class="setting-profile-img-box">
							<img id="settingProfilePreview"
								src="${path}/resources/profile/${loginUser.profileImg}"
								alt="프로필 이미지"
								onerror="this.src='${path}/resources/img/default_profile.png'"> 
						</div>
						<label class="setting-profile-btn" for="settingProfileInput">
							이미지 변경 </label> <input type="file" id="settingProfileInput"
							accept="image/*" style="display: none"
							onchange="previewProfile(this)">
					</div>	--%>


					<!-- 아이디 -->
					<div class="setting-field">
						<label>아이디</label> <input type="text" id="settingId"
							placeholder="새 아이디를 입력하세요" value="${loginUser.memId}">
					</div>

					<!-- 학번 -->
					<div class="setting-field">
						<label>학번</label> <input type="text" id="settingName"
							placeholder="새 학번을 입력하세요" value="${loginUser.studentNo}">
					</div>

					<!-- 전화번호 -->
					<div class="setting-field">
						<label>전화번호</label> <input type="email" id="settingEmail"
							placeholder="새 전화번호를 입력하세요" value="${loginUser.phone}">
					</div>

					<!-- 학과 번호 -->
					<div class="setting-field">
						<label>학과 번호</label> <input type="text" id="settingDeptNo"
							placeholder="학과 번호를 입력하세요" value="${loginUser.deptNo}">
					</div>

					<!-- 현재 비밀번호 -->
					<div class="setting-field">
						<label>현재 비밀번호</label> <input type="password" id="settingCurPw"
							placeholder="현재 비밀번호를 입력하세요">
					</div>

					<!-- 새 비밀번호 -->
					<div class="setting-field">
						<label>새 비밀번호</label> <input type="password" id="settingNewPw"
							placeholder="새 비밀번호를 입력하세요 (변경 시에만 입력)">
					</div>

					<!-- 새 비밀번호 확인 -->
					<div class="setting-field">
						<label>새 비밀번호 확인</label> <input type="password"
							id="settingNewPwCk" placeholder="새 비밀번호를 다시 입력하세요">
					</div>

					<!-- 유효성 메시지 -->
					<div class="setting-hint" id="settingHint"></div>

					<button class="setting-save-btn" onclick="saveSetting()">저장</button>

				</div>
			</div>

			<!-- 로그아웃 / 회원탈퇴 카드 -->
			<div class="setting-card">
				<button class="setting-logout-btn"
					onclick="location.href='${path}/logout'">로그아웃</button>
				<button class="setting-withdraw-btn" onclick="confirmWithdraw()">
					회원 탈퇴</button>
			</div>
			<script>
			// 프로필 이미지 미리보기
			// 파일 선택 즉시 서버 전송 없이 브라우저에서 바로 이미지를 미리 보여주는 기능
			function previewProfile(input) {
				
				// 파일 선택됐는지 확인
			    if (input.files && input.files[0]) {
			        const reader = new FileReader();
			        
			        reader.onload = e => {
			            document.getElementById('settingProfilePreview').src = e.target.result;
			        };
			        
			        // 변환 완료시 onload 실행
			        reader.readAsDataURL(input.files[0]);
			    }
			}

			// 저장
			function saveSetting() {
			    const hint    = document.getElementById('settingHint');
			    const curPw   = document.getElementById('settingCurPw').value.trim();
			    const newPw   = document.getElementById('settingNewPw').value.trim();
			    const newPwCk = document.getElementById('settingNewPwCk').value.trim();

			    hint.style.color = '#E24B4A';
			    hint.textContent = '';

			    // 새 비밀번호 입력 시 현재 비밀번호 필수
			    if (newPw && !curPw) {
			        hint.textContent = '현재 비밀번호를 입력해주세요.';
			        return;
			    }	

			    // 새 비밀번호 확인 일치
			    if (newPw && newPw !== newPwCk) {
			        hint.textContent = '새 비밀번호가 일치하지 않습니다.';
			        return;
			    }

			    // FormData로 파일 포함 전송
			    const formData = new FormData();
			    formData.append('memName',  document.getElementById('settingName').value.trim());
			    formData.append('memId',    document.getElementById('settingId').value.trim());
			    formData.append('email', document.getElementById('settingEmail').value.trim());
			    formData.append('deptNo',      document.getElementById('settingDeptNo').value.trim());
			    formData.append('curPw',       curPw);
			    formData.append('newPw',       newPw);

			    const profileFile = document.getElementById('settingProfileInput').files[0];
			    if (profileFile) {
			        formData.append('profileImg', profileFile);
			    }

			    // Ajax 전송
			    $.ajax({
			        url        : '${path}/setting/update',
			        type       : 'POST',
			        data       : formData,
			        processData: false,   // FormData는 jQuery가 변환하면 안 됨
			        contentType: false,   // FormData는 Content-Type 자동 설정
			        headers    : { '${_csrf.headerName}': '${_csrf.token}' },

			        success: function(data) {
			            if (data.result === 'ok') {
			                hint.style.color = '#16a34a';
			                hint.textContent = '저장되었습니다.';
			            } else {
			                hint.style.color = '#E24B4A';
			                hint.textContent = data.message || '저장에 실패했습니다.';
			            }
			        },

			        error: function() {
			            hint.style.color = '#E24B4A';
			            hint.textContent = '서버와 연결할 수 없습니다.';
			        }
			    });
			}

			// 회원탈퇴
			function confirmWithdraw() {
			    if (confirm('회원 탈퇴 페이지로 이동하시겠습니까?')) {
			        location.href = '${path}/member/withdraw';
			    }
			}
			
			</script>


		</div>
		<!-- /setting -->


	</div>
	<!-- /tab-content -->

</div>
<!-- /mypage-container -->


<jsp:include page="/WEB-INF/views/common2/footer.jsp" />
