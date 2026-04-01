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
			<button class="tab-btn ${category == 'attendance' ? 'active' : ''}"
				onclick="showTab('attendance')">
				<i class="fa-regular fa-calendar-check"></i> 출석체크
			</button>
			<button class="tab-btn ${category == 'friend' ? 'active' : ''}"
				onclick="showTab('friend')">
				<i class="fa-solid fa-user-group"></i> 친구
			</button>
			<button class="tab-btn ${category == 'timetable' ? 'active' : ''}"
				onclick="showTab('timetable')">
				<i class="fa-solid fa-calendar-days"></i> 시간표
			</button>
			<button class="tab-btn ${category == 'setting' ? 'active' : ''}"
				onclick="showTab('setting')">
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
					<div class="att-btn-wrap">
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
						onclick="location.href='${path}/friends/addfriend'">친구 추가</button>
					<!-- 수락 대기 중인 친구 요청 페이지로 이동 -->
					<button class="friend-btn"
						onclick="location.href='${path}/friends/acceptfriend'">친구
						수락</button>
				</div>
			</div>

			<!-- 친구 목록 -->
			<c:if test="${not empty friendList}">
				<c:forEach var="f" items="${friendList}">
					<div class="friend-item">
						<div class="friend-text">
							<span class="friend-name">${f.friendName}</span>
						</div>
						<button class="friend-delete-btn"
							onclick="deleteFriend(${f.friendNo})">친구 삭제</button>
					</div>
				</c:forEach>
			</c:if>

			<!-- 친구 삭제 기능 -->
			<script>
			function deleteFriend(friendNo) {
			    if (confirm("정말 삭제하시겠습니까?")) {
			    	
			    	const token = document.querySelector('meta[name="_csrf"]').content;
			        const header = document.querySelector('meta[name="_csrf_header"]').content;
			    	
			        fetch('${path}/friends/delete', {
			            method: 'POST',
			            headers: { 
			            	'Content-Type': 'application/json', 
			            	[header]: token
			            },
			            body: JSON.stringify({ friendNo: friendNo })
			        })
			        .then(res => res.json())
			        .then(data => {
			            if (data.result === 'success') {
			                alert("삭제되었습니다.");
			                location.reload(); // 화면 새로고침
			            } else {
			                alert("삭제에 실패했습니다.");
			            }
			        })
			        .catch(err => console.error("Error:", err));
			    }
			}
			</script>


			<!-- 친구가 없을 때 -->
			<c:if test="${empty friendList}">
				<div class="friend-empty">
					<p>친구가 없습니다</p>
				</div>
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
						<span id="ttTitleText">나의 시간표</span> <span style="font-size: 11px">▼</span>
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
				<!-- 				
				검색 기능 ui
				<div class="lecture-search-wrap">
					<input type="text" id="lectureSearchInp" placeholder="강의명 검색...">
					<ul id="searchResultList">
					</ul>
				</div> 
-->

				<!-- 강의 추가 버튼: onclick 제거, id 추가 -->
				<button class="btn-tt-add" id="ttBtnOpenModal">강의 추가</button>

				<!-- 강의 삭제 버튼: onclick 제거 (id="ttBtnDel" 은 기존 유지) -->
				<button class="btn-tt-del" id="ttBtnDel">강의 삭제</button>
			</div>

			<!-- 강의 추가 모달 (버튼 클릭 시 펼쳐짐) -->
			<div class="tt-overlay" id="ttOverlay">
				<div class="tt-modal">
					<label>강의 검색</label>
					<div style="position: relative; flex: 1;">
						<input type="text" id="ttInpTitle" autocomplete="off"
							placeholder="강의명을 입력하세요"> <input type="hidden"
							id="ttSelectedNo">
						<div id="ttSearchRes" class="tt-search-results"></div>
					</div>

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


			<!-- 강의 상세 보기 -->
			<div id="ttDetailOverlay" class="tt-modal-overlay"
				style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 10000; justify-content: center; align-items: center;">
				<div class="tt-modal-content"
					style="background: white; padding: 20px; border-radius: 8px; width: 350px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);">
					<h3 id="detailLectureName" style="margin-top: 0; color: #333;">강의명</h3>
					<p id="detailProfessor" style="color: #666; font-size: 14px;">교수님
						성함</p>
					<hr>

					<div style="margin-bottom: 15px;">
						<label>요일 선택</label> <select id="detailDay"
							style="width: 100%; padding: 8px; margin-top: 5px;">
							<option value="0">월요일</option>
							<option value="1">화요일</option>
							<option value="2">수요일</option>
							<option value="3">목요일</option>
							<option value="4">금요일</option>
						</select>
					</div>

					<div style="display: flex; gap: 10px; margin-bottom: 20px;">
						<div style="flex: 1;">
							<label>시작 시간</label> <select id="detailStart"
								style="width: 100%; padding: 8px; margin-top: 5px;"></select>
						</div>
						<div style="flex: 1;">
							<label>종료 시간</label> <select id="detailEnd"
								style="width: 100%; padding: 8px; margin-top: 5px;"></select>
						</div>
					</div>

					<p id="detailHint"
						style="color: red; font-size: 12px; height: 15px;"></p>

					<div style="display: flex; justify-content: flex-end; gap: 10px;">
						<button onclick="closeDetailModal()"
							style="padding: 8px 15px; background: #ccc; border: none; border-radius: 4px; cursor: pointer;">취소</button>
						<button onclick="confirmDetailAdd()"
							style="padding: 8px 15px; background: #4A90E2; color: white; border: none; border-radius: 4px; cursor: pointer;">시간표에
							추가</button>
					</div>
				</div>
			</div>


			<script>
		    // 1. 전역 변수 및 경로 설정
		    const path = "${pageContext.request.contextPath}"; 
		    let tempSelectedLecture = null;
		    
		    const initialScheduleData = [
		        <c:if test="${not empty scheduleList}">
		            <c:forEach var="s" items="${scheduleList}" varStatus="status">
		            {
		                lectureNo: ${s.lectureNo != null ? s.lectureNo : 0},
		                scheduleTitle: '${s.scheduleTitle != null ? s.scheduleTitle : "내 시간표"}', 
		                lectureName: '${s.lectureName != null ? s.lectureName : ""}',
		                scheduleDay: ${s.scheduleDay != null ? s.scheduleDay : 0},
		                startSlot: ${s.startSlot != null ? s.startSlot : 0},
		                endSlot: ${s.endSlot != null ? s.endSlot : 0}
		            }${not status.last ? ',' : ''}
		            </c:forEach>
		        </c:if>
		    ];

		    // 페이지 로드 시 실행
		    window.onload = function() {
		        loadTimetable(); // 이 함수가 initialScheduleData를 읽어서 timetables 배열을 만듭니다.
		        initEvents();    // 검색창 이벤트 등 초기화
		    };
		
		    // 즉시 실행 함수 대신 일반 스코프로 관리 (버튼 클릭 이슈 방지)
		    const DAYS        = ['월','화','수','목','금'];
		    const START_HOUR  = 9;
		    const END_HOUR    = 17;
		    const SLOT_H      = 36;
		    const TOTAL_SLOTS = (END_HOUR - START_HOUR) * 2;
		
		    let timetables = [{ name: '나의 시간표', courses: [] }];
		    let currentIdx = 0;
		    let deleteMode = false;
		
		    // ── 서버 통신 로직 ──────────────────────────────
		    function loadTimetable() {
		        if (typeof initialScheduleData !== 'undefined' && initialScheduleData.length > 0) {
		            // scheduleTitle 기준으로 유니크한 시간표 이름 추출
		            const tableNames = [...new Set(initialScheduleData.map(c => c.scheduleTitle))];
		            
		            timetables = tableNames.map(name => {
		                return {
		                    name: name,
		                    courses: initialScheduleData
		                        .filter(c => c.scheduleTitle === name)
		                        .map(c => ({
		                            lectureNo: c.lectureNo,
		                            title: c.lectureName, // 화면에 그릴 땐 과목명 사용
		                            scheduleDay: parseInt(c.scheduleDay),
		                            startSlot: parseInt(c.startSlot),
		                            endSlot: parseInt(c.endSlot)
		                        }))
		                };
		            });
		            currentIdx = 0;
		        }
		        else {
		            timetables = [{ name: '나의 시간표', courses: [] }];
		            currentIdx = 0;
		        }
		        updateDropdown();
		        ttRenderGrid();
		    }
		
		    function saveToDatabase() {
		    	
		        const currentTable = timetables[currentIdx];
		        
		        const payload = currentTable.courses.map(c => ({
		            lectureNo: c.lectureNo,
		            scheduleTitle: currentTable.name, 
		            lectureName: c.title,           
		            scheduleDay: c.scheduleDay	,
		            startSlot: c.startSlot, 
		            endSlot: c.endSlot
		        }));
		        
		        console.log("서버로 보낼 데이터(Payload):", payload);
		
		        const csrfToken = document.querySelector('meta[name="_csrf"]');
		        const csrfHeader = document.querySelector('meta[name="_csrf_header"]');
		        const headers = { 'Content-Type': 'application/json' };
		        if(csrfToken && csrfHeader) headers[csrfHeader.content] = csrfToken.content;
		    
		        fetch(path + '/schedule/save', {
		            method: 'POST',
		            headers: headers,
		            body: JSON.stringify(payload)
		        })
		        .then(res => res.json())
		        .then(data => { if(data.success) console.log("DB 저장 완료"); })
		        .catch(err => console.error("저장 오류:", err));
		    }
		
		    // ── 그리드 렌더링 ────────────────────────────
		    function ttRenderGrid() {
		        const grid = document.getElementById('ttGrid');
		        if(!grid) return;
		        grid.innerHTML = '';
		
		        // 헤더(요일)
		        const emptyCell = document.createElement('div');
		        emptyCell.className = 'tt-header-cell';
		        grid.appendChild(emptyCell);
		        DAYS.forEach(d => {
		            const h = document.createElement('div');
		            h.className = 'tt-header-cell';
		            h.textContent = d;
		            grid.appendChild(h);
		        });
		
		        // 시간 열
		        const timeCol = document.createElement('div');
		        timeCol.className = 'tt-time-col';
		        for (let s = 0; s < TOTAL_SLOTS; s++) {
		            const sl = document.createElement('div');
		            sl.className = 'tt-time-slot';
		            sl.textContent = s % 2 === 0 ? String(START_HOUR + s / 2).padStart(2, '0') : '';
		            timeCol.appendChild(sl);
		        }
		        grid.appendChild(timeCol);
		
		        // 요일별 데이터
		        const courses = timetables[currentIdx].courses;
		        DAYS.forEach((_, dayIdx) => {
		            const col = document.createElement('div');
		            col.className = 'tt-day-col';
		            for (let s = 0; s < TOTAL_SLOTS; s++) {
		                const line = document.createElement('div');
		                line.className = 'tt-row-line';
		                col.appendChild(line);
		            }
		
		            courses.filter(c => Number(c.scheduleDay) === dayIdx).forEach(c => {
		                const block = document.createElement('div');
		                block.className = 'tt-block' + (deleteMode ? ' delete-mode' : '');
		                block.style.top = (c.startSlot - START_HOUR * 2) * SLOT_H + 'px';
		                block.style.height = (c.endSlot - c.startSlot) * SLOT_H + 'px';
		                
		                block.innerHTML = '<span>' + c.title + '</span>' +
		                  '<span style="font-size:10px; opacity:.8">' + 
		                  slotToTime(c.startSlot) + '~' + slotToTime(c.endSlot) + 
		                  '</span>';
		                
		                block.onclick = (e) => {
		                    if (!deleteMode) return;
		                    e.stopPropagation();
		                    timetables[currentIdx].courses = timetables[currentIdx].courses.filter(item => item !== c);
		                    saveToDatabase();
		                    ttRenderGrid();
		                };
		                col.appendChild(block);
		            });
		            grid.appendChild(col);
		        });
		    }
		
		    // ── 유틸리티 ──
		    function slotToTime(slot) {
		        let h = Math.floor(slot / 2);
		        return h + (slot % 2 === 0 ? ':00' : ':30');
		    }
		
		    function buildTimeOptions(selectEl, defaultHour, defaultMin) {
		        if(!selectEl) return;
		        selectEl.innerHTML = '';
		        for (let h = START_HOUR; h <= END_HOUR; h++) {
		            ['00', '30'].forEach(m => {
		                if (h === END_HOUR && m === '30') return;
		                let val = h * 2 + (m === '30' ? 1 : 0);
		                let opt = document.createElement('option');
		                opt.value = val;
		                opt.textContent = h + ':' + m;
		                if (h === defaultHour && parseInt(m) === defaultMin) opt.selected = true;
		                selectEl.appendChild(opt);
		            });
		        }
		    }
		
		    function ttOpenModal() {
		        document.getElementById('ttInpTitle').value = '';
		        document.getElementById('ttSelectedNo').value = '';
		        document.getElementById('ttModalHint').textContent = '';
		        buildTimeOptions(document.getElementById('ttInpStart'), 9, 0);
		        buildTimeOptions(document.getElementById('ttInpEnd'), 10, 0);
		        document.getElementById('ttOverlay').classList.add('open');
		    }
		
		    function ttCloseModal() {
		        document.getElementById('ttOverlay').classList.remove('open');
		    }
		
		    function ttConfirmAdd() {
		        const title = document.getElementById('ttInpTitle').value.trim();
		        const lectureNo = document.getElementById('ttSelectedNo').value;
		        const scheduleDay = parseInt(document.getElementById('ttInpDay').value);
		        const startSlot = parseInt(document.getElementById('ttInpStart').value);
		        const endSlot = parseInt(document.getElementById('ttInpEnd').value);
		        const hintEl = document.getElementById('ttModalHint');
		
		        if (!lectureNo) { hintEl.textContent = '강의를 검색한 후 목록에서 선택해주세요.'; return; }
		        if (endSlot <= startSlot) { hintEl.textContent = '종료 시간은 시작 시간보다 늦어야 합니다.'; return; }
		
		        const overlap = timetables[currentIdx].courses.some(c => 
		            c.scheduleDay === scheduleDay && !(endSlot <= c.startSlot || startSlot >= c.endSlot)
		        );
		        if (overlap) { hintEl.textContent = '해당 시간에 이미 강의가 있습니다.'; return; }
		
		        timetables[currentIdx].courses.push({
		            lectureNo: parseInt(lectureNo),
		            title: title, 
		            scheduleDay: scheduleDay,
		            startSlot: startSlot,
		            endSlot: endSlot
		        });
		
		        saveToDatabase();
		        ttCloseModal();
		        ttRenderGrid();
		    }
		
		    function initEvents() {
		        const inpTitle = document.getElementById('ttInpTitle');
		        const resDiv = document.getElementById('ttSearchRes');
		
		        document.getElementById('ttBtnOpenModal').onclick = ttOpenModal;
		        document.getElementById('ttBtnConfirm').onclick = ttConfirmAdd;
		        document.getElementById('ttBtnCancel').onclick = ttCloseModal;
		
		        document.getElementById('ttBtnDel').onclick = function() {
		            deleteMode = !deleteMode;
		            this.classList.toggle('active', deleteMode);
		            document.getElementById('ttDelHint').textContent = deleteMode ? '삭제할 강의를 클릭하세요.' : '';
		            ttRenderGrid();
		        };
		
		        document.getElementById('ttBtnAdd').onclick = () => {
		            const newName = prompt("새로운 시간표 이름을 입력하세요", "나의 시간표");
		            if (newName) {
		                timetables.push({ name: newName, courses: [] });
		                currentIdx = timetables.length - 1;
		                updateDropdown();
		                ttRenderGrid();
		            }
		        };
		
		        document.getElementById('ttBtnMinus').onclick = () => {
		            if (timetables.length <= 1) return alert("최소 하나의 시간표는 유지해야 합니다.");
		            
		            const targetName = timetables[currentIdx].name; // 삭제할 시간표 이름
		            
		            if (confirm("'" + targetName + "'을 삭제하시겠습니까?")) {
		                // 1. 서버에 삭제 요청
		                const csrfToken = document.querySelector('meta[name="_csrf"]');
		                const csrfHeader = document.querySelector('meta[name="_csrf_header"]');
		                const headers = { 'Content-Type': 'application/json' };
		                if(csrfToken && csrfHeader) headers[csrfHeader.content] = csrfToken.content;

		                // 삭제 전용 경로(예: /schedule/deleteTable)로 요청
		                fetch(path + '/schedule/deleteTable', {
		                    method: 'POST',
		                    headers: headers,
		                    body: JSON.stringify({ 
		                        scheduleTitle: targetName 
		                    })
		                })
		                .then(res => res.json())
		                .then(data => {
		                    if(data.success) {
		                        // 2. 서버 삭제 성공 시 화면에서도 제거
		                        timetables.splice(currentIdx, 1);
		                        currentIdx = 0;
		                        updateDropdown();
		                        ttRenderGrid();
		                        alert("삭제되었습니다.");
		                    }
		                });
		            }
		        };
		        

		
		        if (inpTitle) {
		            inpTitle.oninput = (e) => {
		                const keyword = e.target.value.trim();
		             	// 2글자 이상 입력 안하면 검색 안됌
		                if (keyword.length < 2) { resDiv.style.display = 'none'; return; } 
		                
		                fetch(path + '/schedule/searchLecture?keyword=' + encodeURIComponent(keyword))
		                    .then(res => res.json())
		                    .then(data => {
		                        resDiv.innerHTML = '';
		                        if (data.length === 0) { resDiv.style.display = 'none'; return; }
		                        data.forEach(lecture => {
		                            const item = document.createElement('div');
		                            item.style.cssText = 'padding: 10px; cursor: pointer; border-bottom: 1px solid #eee;';
		                            item.innerHTML = item.innerHTML = '<strong>' + lecture.lectureName + '</strong> ' +
		                            '<small>(' + lecture.professorName + ')</small>';
		                            item.onclick = function() {
		                                // 1. 첫 번째 로직 (값 세팅)
		                                inpTitle.value = lecture.lectureName;
		                                const selectedNoEl = document.getElementById('ttSelectedNo');
		                                if (selectedNoEl) {
		                                    selectedNoEl.value = lecture.lectureNo;
		                                }

		                                // 2. 두 번째 로직 (모달 띄우기 및 정리)
		                                tempSelectedLecture = lecture; // 서버에서 받아온 lecture 객체 저장
		                                openDetailModal(lecture);      // 상세 설정 모달 열기
		                                
		                                resDiv.style.display = 'none'; // 검색 목록 닫기
		                                inpTitle.value = '';           // 입력창 비우기 (선택 완료됐으므로)
		                            };
		                            resDiv.appendChild(item);
		                        });
		                        resDiv.style.display = 'block';
		                    });
		            };
		        }
		
		        // 검색창 외 클릭 시 닫기
		        document.addEventListener('click', (e) => {
		            if (e.target !== inpTitle) resDiv.style.display = 'none';
		        });
		
		        document.getElementById('ttTitleBtn').onclick = (e) => {
		            e.stopPropagation();
		            document.getElementById('ttDropdown').classList.toggle('open');
		        };
		    }
		    
		    function openDetailModal(lecture) {
		        const overlay = document.getElementById('ttDetailOverlay');
		        document.getElementById('detailLectureName').textContent = lecture.lectureName;
		        document.getElementById('detailProfessor').textContent = lecture.professorName + ' 교수님';
		        document.getElementById('detailHint').textContent = '';

		        // 시간 옵션 생성 (기존 buildTimeOptions 재사용)
		        buildTimeOptions(document.getElementById('detailStart'), 9, 0);
		        buildTimeOptions(document.getElementById('detailEnd'), 10, 0);

		        overlay.style.display = 'flex'; // 모달 보이기
		    }

		    function closeDetailModal() {
		        document.getElementById('ttDetailOverlay').style.display = 'none';
		        tempSelectedLecture = null;
		    }

		    function confirmDetailAdd() {
		        const scheduleDay = parseInt(document.getElementById('detailDay').value);
		        const startSlot = parseInt(document.getElementById('detailStart').value);
		        const endSlot = parseInt(document.getElementById('detailEnd').value);
		        const hintEl = document.getElementById('detailHint');

		        // 1. 유효성 검사
		        if (endSlot <= startSlot) {
		            hintEl.textContent = '종료 시간은 시작 시간보다 늦어야 합니다.';
		            return;
		        }

		        // 2. 중복 검사
		        const overlap = timetables[currentIdx].courses.some(c => 
		            c.scheduleDay === scheduleDay && !(endSlot <= c.startSlot || startSlot >= c.endSlot)
		        );
		        if (overlap) {
		            hintEl.textContent = '해당 시간에 이미 강의가 있습니다.';
		            return;
		        }

		        // 3. 데이터 추가
		        timetables[currentIdx].courses.push({
		            lectureNo: tempSelectedLecture.lectureNo,
		            title: tempSelectedLecture.lectureName,
		            scheduleDay: scheduleDay,
		            startSlot: startSlot,
		            endSlot: endSlot
		        });

		        // 4. 후처리
		        saveToDatabase();
		        
		        ttRenderGrid();
		        closeDetailModal();
		    }
		    
		    function updateDropdown() {
		        const dropdown = document.getElementById('ttDropdown');
		        const titleText = document.getElementById('ttTitleText');
		        if(!dropdown || !titleText) return;
		
		        dropdown.innerHTML = '';
		        titleText.textContent = timetables[currentIdx].name;
		
		        timetables.forEach((tt, idx) => {
		            const item = document.createElement('div');
		            item.className = 'tt-dropdown-item';
		            item.textContent = tt.name;
		            item.onclick = () => {
		                currentIdx = idx;
		                titleText.textContent = tt.name;
		                dropdown.classList.remove('open');
		                ttRenderGrid();
		            };
		            dropdown.appendChild(item);
		        });
		    }
		
		    document.addEventListener('DOMContentLoaded', () => {
		        initEvents();
		        loadTimetable();
		    });	    
		</script>

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
			<form:form action="${contextPath}/member/logout" method="post">
					<button class="setting-logout-btn" type="submit" class="logout">로그아웃</button>	
			</form:form>
				<button class="setting-withdraw-btn" onclick="confirmWithdraw()">
					회원 탈퇴</button>
			</div>
			<script>
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
