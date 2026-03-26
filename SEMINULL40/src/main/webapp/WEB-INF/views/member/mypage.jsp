<%@ page contentType="text/html;charset=UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

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
	min-height: 100%;
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

						<div class="att-day-num" id="attDayNum">${attendCnt}</div>
						<div class="att-day-label">일차</div>
					</div>
				</div>

				<!-- 출석 체크 버튼 -->
				<div class="att-btn-wrap">
					<form action="${path}/attendance/check">
						<button class="att-btn" id="attBtn">출석 체크하기</button>
					</form>
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
						<!-- JS가 width를 백분율로 진행률 표시 -->
						<div class="att-prog-fill" id="attProgFill" style="width: 0%"></div>
					</div>
				</div>

				<!-- 특정 일차 달성 시 보상 메시지 (JS가 텍스트 삽입) -->
				<div class="att-reward" id="attReward"></div>

			</div>
			<!-- /att-card -->

			<script>
 			
 			var token = $("meta[name='_csrf']").attr("content");
 			var header = $("meta[name='_csrf_header']").attr("content");
			
 			
			// UI 업데이트 함수 (도형 생성 + 진행바 + 레이블)
	        function updateAttendanceUI(count) {
		        const maxDays = 7; // 목표 일수
		        
		        const currentCount = parseInt(count);
	            // (1) 상단 큰 숫자 업데이트
	            $("#attDayNum").text(currentCount);

	            // (2) 7개 도트(도형) 동적 생성 및 상태 표시
	            let dotsHtml = "";
	            for (let i = 1; i <= maxDays; i++) {
	                let statusClass = "";
	                let content = i + "일";

	                if (i <= currentCount) {
	                    statusClass = "done"; // 출석 완료
	                    content = "✓";
	                } else if (i === currentCount + 1 && currentCount < maxDays) {
	                    statusClass = "today"; // 다음 출석 예정
	                }

	                dotsHtml += '<div class="att-dot ' + statusClass + '">' +
                    '  <span>' + content + '</span>' +
                    '  <span class="di">' + (i <= currentCount ? "완료" : "일차") + '</span>' +
                    '</div>';
	            }
	            $("#attDots").html(dotsHtml);

	            
	            
	            
	            // (3) 진행률 바 및 레이블 업데이트
	            let progressPercent = (currentCount / maxDays) * 100;
	            if (progressPercent > 100) progressPercent = 100; // 7일 넘어가도 100% 고정
	            if (progressPercent < 0) progressPercent = 0;
	            
	            console.log("계산된 퍼센트:", progressPercent);

	            $("#attProgFill").css("width", progressPercent + "%");
	            $("#attProgLabel").text(currentCount + " / " + maxDays + "일");

	            // (4) 보상 메시지 처리
	            if (currentCount >= maxDays) {
	                $("#attReward").text("🎉 7일 출석 완료! 보상이 지급되었습니다.");
	                $("#attBtn").prop("disabled", true).text("출석 완료");
	            }
	        }
 			
 			
			    $(document).ready(function() {
			        // 1. 서버에서 전달받은 출석 횟수 (EL 사용)
			        // 만약 EL이 작동하지 않는 환경이라면 $("#attDayNum").text()로 가져옵니다.
			        let attendCount = Number("${attendCnt}"); 
    				console.log("초기 출석수:", attendCount);
					
    				if(isNaN(attendCount)) {
    					attendCount = 0;
    				}
    				
			        // 초기 화면 업데이트 실행
			        updateAttendanceUI(attendCount);

			        // 2. 출석 체크 버튼 클릭 이벤트 (AJAX)
			        $("#attBtn").on("click", function(e) {
			            e.preventDefault(); // 폼 기본 제출 막기
			            $.ajax({
			                url: "${path}/attendance/check",
			                type: "POST",
			                beforeSend: function(xhr) {
			                    xhr.setRequestHeader(header, token); // 토큰 전달 필수!
			                },
			                success: function(res) {
			                    if (res === "success") {
			                        alert("출석 체크가 완료되었습니다!");
			                        location.href = "${path}/member/mypage";
			                        location.reload();
			                        $("#attBtn").prop("disabled", true).text("출석 완료");
			                        
			                    } else if (res === "already_done") {
			                        alert("오늘은 이미 출석하셨습니다. 내일 다시 참여해주세요!");
			                        location.href = "${path}/member/mypage";
			                    } else {
			                        alert("로그인이 필요한 서비스입니다.");
			                    }	
			                },
			                error: function() {
			                    alert("서버 통신 오류가 발생했습니다.");
			                }
			            });
			            
			            updateAttendanceUI(attendCount);
			            
			        });

			    });
			    
			    
			</script>


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
		<div id="timetable" class="tab-panel">

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
		<div id="setting" class="tab-panel">

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
