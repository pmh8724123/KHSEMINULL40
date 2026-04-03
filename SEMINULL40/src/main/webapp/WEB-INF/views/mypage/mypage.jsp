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
						<strong>보유 포인트: ${userPoint} P</strong>
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

					<div class="friend-item"
						onclick="viewFriendTimetable(${f.friendNo}, '${f.friendName}')"
						style="cursor: pointer;">
						<span class="friend-name">${f.friendName}</span>


						<button
							onclick="event.stopPropagation(); location.href='${path}/mypage?category=timetable&friendNo=${f.friendNo}'"
							class="btn-view-tt">시간표 보기</button>

						<button class="friend-delete-btn"
							onclick="event.stopPropagation(); deleteFriend(${f.friendNo})">친구
							삭제</button>
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

			<c:if test="${isFriend}">
				<div
					style="background: #f0f7ff; padding: 10px; text-align: center; border-radius: 5px; margin-bottom: 10px;">
					<strong style="color: #4a90e2;">친구의 시간표를 조회 중입니다.</strong>
					<button
						onclick="location.href='${pageContext.request.contextPath}/mypage?category=timetable'"
						style="margin-left: 10px; font-size: 15px; border: none; background: #ddd; padding: 3px 8px; border-radius: 15px; cursor: pointer; background-color: 4a90e2;">
						내 시간표로 돌아가기</button>
				</div>
			</c:if>

			<!-- 상단 바: 시간표 선택 드롭다운(좌) ,  +/- 버튼(우) -->
			<div class="tt-topbar">
				<div class="tt-title-wrap" id="ttTitleWrap">
					<!-- 드롭다운 버튼: onclick 제거, id 추가 -->
					<button class="tt-title-btn" id="ttTitleBtn">
						<span id="ttTitleText">시간표가 없습니다</span> <span
							style="font-size: 11px">▼</span>
					</button>
					<div class="tt-dropdown" id="ttDropdown"></div>
					<c:if test="${!isFriend}">
						<div class="tt-plusminus">
							<!--  + 버튼 : prompt로 강의 제목을 받고, 그 강의에 대한 요일, 시간 설정 -->
							<button id="ttBtnAdd" title="시간표 추가" style="color: #4a90e2">+</button>

							<!--  - 버튼 : 클릭 시 삭제 모드 활성화  -->
							<button id="ttBtnMinus" title="시간표 삭제" style="color: #E24B4A">−</button>
						</div>
					</c:if>
				</div>
			</div>

			<!-- 시간표 그리드 (JS가 동적 렌더링) -->
			<div class="tt-grid-wrap">
				<div class="tt-grid" id="ttGrid"></div>
			</div>

			<!-- 삭제 모드 안내 메시지 -->
			<div class="tt-del-hint" id="ttDelHint"></div>

			<!-- 하단 버튼: 강의 추가 / 강의 삭제 -->
			<c:if test="${!isFriend}">
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
			</c:if>
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
		    // 전역 변수 및 경로 설정
		    const path = "${pageContext.request.contextPath}"; 
		    let tempSelectedLecture = null;
		    let emptyMsg = '';
		    
		    // 시간표 리스트 db에서 뽑기
		    const initialScheduleData = [
		        <c:if test="${not empty scheduleList}">
		            <c:forEach var="s" items="${scheduleList}" varStatus="status">
		            {
		                lectureNo: ${s.lectureNo != null ? s.lectureNo : 0},
		                schtitleNo: ${s.schtitleNo != null ? s.schtitleNo : 0},
		                schtitleName: '${s.schtitleName != null ? s.schtitleName : "내 시간표"}', 
		                lectureName: '${s.lectureName != null ? s.lectureName : ""}',
		                scheduleDay: ${s.scheduleDay != null ? s.scheduleDay : 0},
		                startTime: ${s.startTime != null ? s.startTime : 0},
		                endTime: ${s.endTime != null ? s.endTime : 0}
		            }${not status.last ? ',' : ''}
		            </c:forEach>
		        </c:if>
		    ];


		    // 즉시 실행 함수 대신 일반 스코프로 관리 (버튼 클릭 이슈 방지)
		    const DAYS        = ['월','화','수','목','금'];
		    const START_HOUR  = 9;
		    const END_HOUR    = 17;
		    const TIME_H      = 36;
		    const TOTAL_TIMES = (END_HOUR - START_HOUR) * 2;
		
		    let timetables = [{ name: '시간표', courses: [] }];
		    let currentIdx = 0;
		    let deleteMode = false;
		
		    // 시간표를 생성 로직
			function loadTimetable() {
			    // JSP에서 전달받은 initialScheduleData가 있는지 확인
			    if (initialScheduleData && initialScheduleData.length > 0) {
			        const titleMap = new Map();
			        initialScheduleData.forEach(item => {
			            if(!titleMap.has(item.schtitleNo)) {
			                titleMap.set(item.schtitleNo, item.schtitleName);
			            }
			        });
			

			        timetables = Array.from(titleMap).map(([no, name]) => ({
			            schtitleNo: no, 
			            name: name,
			            courses: initialScheduleData
			                .filter(c => c.schtitleNo === no)
			                .map(c => ({
			                    scheduleNo: c.scheduleNo,
			                    lectureNo: c.lectureNo,
			                    title: c.lectureName,
			                    scheduleDay: c.scheduleDay,
			                    startTime: c.startTime,
			                    endTime: c.endTime
			                }))
			        }));
			    } else {
			    	emptyMsg = '<div style="position:absolute; text-align:center; padding-top:100px; color:#black;">';
			    	+ '<p>등록된 시간표가 없습니다.</p>';
			    	+ '<p style="font-size:0.9em;">상단 [+] 버튼을 눌러 새 시간표를 만들어보세요!</p></div>';
			        timetables = []; 
			        document.getElementById('ttGrid').innerHTML = emptyMsg;
			            
			        return;
			    }
			    currentIdx = 0;
			    updateDropdown();
			    ttRenderGrid();
			}
			
		    
		    // 변경 사항을 db에 저장 시킴.
			function saveToDatabase() {
			    const currentTable = timetables[currentIdx];
			    
			    // 디버깅용 로그 (전송 직전 상태 확인)
			    console.log("현재 인덱스:", currentIdx);
			    console.log("현재 시간표 데이터:", currentTable);

			 	// 1. 이름이 no든 schtitleNo든 값이 있으면 가져오기
			    const targetNo = currentTable.schtitleNo || currentTable.no;

			    console.log("검증 중인 번호:", targetNo); // 여기서 1이 찍히는지 확인

			    // 2. 조건문 수정: null, undefined, 빈 문자열만 체크 (0이나 1은 통과해야 함)
			    if (targetNo === undefined || targetNo === null || targetNo === "") {
			        console.error("저장 실패: 번호가 없습니다.", currentTable);
			        return;
			    }

			    const payload = {
			        schtitleNo: Number(targetNo),
			        courses: currentTable.courses.map(c => ({
			            lectureNo: c.lectureNo,
			            scheduleDay: c.scheduleDay,
			            startTime: c.startTime,
			            endTime: c.endTime
			        }))
			    };

			    const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;
			    const csrfToken = document.querySelector('meta[name="_csrf"]').content;

			    fetch(path + '/schedule/save', {
			        method: 'POST',
			        headers: {
			            'Content-Type': 'application/json',
			            [csrfHeader]: csrfToken
			        },
			        body: JSON.stringify(payload)
			    })
			    .then(res => res.json())
			    .then(data => {
			        if(data.success) console.log("DB 동기화 완료 (삭제 및 저장)");
			    })
			    .catch(err => console.error("저장 실패:", err));
			}
		
		    // 시간표 영역 생성.
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
		        for (let s = 0; s < TOTAL_TIMES; s++) {
		            const sl = document.createElement('div');
		            sl.className = 'tt-time-time';
		            sl.textContent = s % 2 === 0 ? String(START_HOUR + s / 2).padStart(2, '0') : '';
		            timeCol.appendChild(sl);
		        }
		        grid.appendChild(timeCol);
			
		        
		        // 요일별 데이터
		        const courses = timetables[currentIdx].courses;
		        DAYS.forEach((_, dayIdx) => {
		            const col = document.createElement('div');
		            col.className = 'tt-day-col';
		            for (let s = 0; s < TOTAL_TIMES; s++) {
		                const line = document.createElement('div');
		                line.className = 'tt-row-line';
		                col.appendChild(line);
		            }
		
		            courses.filter(c => Number(c.scheduleDay) === dayIdx).forEach(c => {
		                const block = document.createElement('div');
		                block.className = 'tt-block' + (deleteMode ? ' delete-mode' : '');
		                block.style.top = (c.startTime - START_HOUR * 2) * TIME_H + 'px';
		                block.style.height = (c.endTime - c.startTime) * TIME_H + 'px';
		                
		                block.innerHTML = '<span>' + c.title + '</span>' +
		                  '<span style="font-size:10px; opacity:.8">' + 
		                  TimeToTime(c.startTime) + '~' + TimeToTime(c.endTime) + 
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
			
		    
		    
		 // 친구 목록의 버튼/이름 클릭 시 호출될 함수
		    function viewFriendTimetable(friendNo, friendName) {
		        fetch('${path}/schedule/friendSchedule?friendNo=${friendNo}')
		            .then(res => res.json())
		            .then(data => {
		                if (!data || data.length === 0) {
		                    alert("해당 친구는 등록된 시간표가 없습니다.");
		                    return;
		                }

		                // 1. 기존 timetables 구조에 맞게 데이터 가공
		                const titleMap = new Map();
		                data.forEach(item => {
		                    if(!titleMap.has(item.schtitleNo)) {
		                        titleMap.set(item.schtitleNo, item.schtitleName);
		                    }
		                });

		                // 2. 전역 변수 timetables 업데이트 (친구 데이터로 덮어쓰기)
		                timetables = Array.from(titleMap).map(([no, name]) => ({
		                    schtitleNo: no, 
		                    name: friendName + "님의 " + name, // 누구의 시간표인지 표시
		                    courses: data
		                        .filter(c => c.schtitleNo === no)
		                        .map(c => ({
		                            scheduleNo: c.scheduleNo,
		                            lectureNo: c.lectureNo,
		                            title: c.lectureName,
		                            scheduleDay: c.scheduleDay,
		                            startTime: c.startTime,
		                            endTime: c.endTime
		                        }))
		                }));

		                // 3. 현재 인덱스 초기화 및 화면 렌더링
		                currentIdx = 0;
		                updateDropdown();
		                ttRenderGrid();
		                
		                // 4. 친구 시간표 조회 모드이므로 편집 버튼들 숨기기
		                setReadOnlyMode(true);
		            })
		            .catch(err => console.error("친구 시간표 로드 실패:", err));
		    }

		    // 편집 버튼들을 숨기거나 보여주는 유틸리티
		    function setReadOnlyMode(isRead) {
		        const editButtons = ['ttBtnAdd', 'ttBtnMinus', 'ttBtnOpenModal', 'ttBtnDel'];
		        editButtons.forEach(id => {
		            const btn = document.getElementById(id);
		            if(btn) btn.style.display = isRead ? 'none' : 'inline-block';
		        });
		        
		        // 삭제 모드 강제 해제
		        deleteMode = false;
		        const delBtn = document.getElementById('ttBtnDel');
		        if(delBtn) delBtn.classList.remove('active');
		        document.getElementById('ttDelHint').textContent = isRead ? '(친구 시간표 조회 중)' : '';
		    }
		    
		    
		    
		    
		    
		    
		    // 시간 설정에 대한 코드 
		    function TimeToTime(time) {
		        let h = Math.floor(time / 2);
		        return h + (time % 2 === 0 ? ':00' : ':30');
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
			
		    
		    
		    // 강의 추가 모달 창 : 강의 추가 버튼 누르면 시간표에 모습이 보이는 창.
		    // 강의 추가 모달 창 열기 및 기존 값 초기화
		    function ttOpenModal() {
		    	
		    	// 시간표 존재 여부 체크
		        // timetables 배열이 비었거나, 현재 인덱스의 데이터가 없는 경우
		        if (!timetables || timetables.length === 0) {
		            alert("생성된 시간표가 없습니다. 상단의 [+] 버튼을 눌러 시간표를 먼저 생성해주세요.");
		            return; // 함수 종료 (모달 안 열림)
		        }

		        // 만약 선택된 시간표는 있는데 schtitleNo가 유효하지 않은 경우 (혹시 모를 예외 처리)
		        const currentTable = timetables[currentIdx];
		        if (!currentTable || !currentTable.schtitleNo) {
		            alert("유효한 시간표가 선택되지 않았습니다. 다시 시도해주세요.");
		            return;
		        }
		        
		        document.getElementById('ttInpTitle').value = '';
		        document.getElementById('ttSelectedNo').value = '';
		        document.getElementById('ttModalHint').textContent = '';
		        buildTimeOptions(document.getElementById('ttInpStart'), 9, 0);
		        buildTimeOptions(document.getElementById('ttInpEnd'), 10, 0);
		        document.getElementById('ttOverlay').classList.add('open');
		    }
			
		    // 강의 추가 모달 창 닫기
		    function ttCloseModal() {
		        document.getElementById('ttOverlay').classList.remove('open');
		    }
			
		    
		    // 상세 모달 창의 확인 버튼
		    function ttConfirmAdd() {
		        const title = document.getElementById('ttInpTitle').value.trim();
		        const lectureNo = document.getElementById('ttSelectedNo').value;
		        const scheduleDay = parseInt(document.getElementById('ttInpDay').value);
		        const startTime = parseInt(document.getElementById('ttInpStart').value);
		        const endTime = parseInt(document.getElementById('ttInpEnd').value);
		        const hintEl = document.getElementById('ttModalHint');
		
		        if (!lectureNo) { hintEl.textContent = '강의를 검색한 후 목록에서 선택해주세요.'; return; }
		        if (endTime <= startTime) { hintEl.textContent = '종료 시간은 시작 시간보다 늦어야 합니다.'; return; }
		
		        const overlap = timetables[currentIdx].courses.some(c => 
		            c.scheduleDay === scheduleDay && !(endTime <= c.startTime || startTime >= c.endTime)
		        );
		        if (overlap) { hintEl.textContent = '해당 시간에 이미 강의가 있습니다.'; return; }
		
		        timetables[currentIdx].courses.push({
		            lectureNo: parseInt(lectureNo),
		            title: title, 
		            scheduleDay: scheduleDay,
		            startTime: startTime,
		            endTime: endTime
		        });
		
		        saveToDatabase();
		        ttCloseModal();
		        ttRenderGrid();
		    }
			
		    
		    // 각 버튼에 대한 이벤트들
		    function initEvents() {

		    	
		        const inpTitle = document.getElementById('ttInpTitle');
		        const resDiv = document.getElementById('ttSearchRes');
		
		        document.getElementById('ttBtnOpenModal').onclick = ttOpenModal;
		        document.getElementById('ttBtnConfirm').onclick = ttConfirmAdd;
		        document.getElementById('ttBtnCancel').onclick = ttCloseModal;
				
		        
		        // 삭제 모드 토글 기능
		        document.getElementById('ttBtnDel').onclick = ttDeleteMode;
		        
		        function ttDeleteMode() {
			        if (!timetables || timetables.length === 0) {
			            alert("생성된 시간표가 없습니다. 상단의 [+] 버튼을 눌러 시간표를 먼저 생성해주세요.");
			            return; // 함수 종료 (모달 안 열림)
			        }
		        	
		            deleteMode = !deleteMode;
		            this.classList.toggle('active', deleteMode);
		            document.getElementById('ttDelHint').textContent = deleteMode ? '삭제할 강의를 클릭하세요.' : '';
		            ttRenderGrid();
		        };
				
		        
		        // 새로운 시간표 생성. 최초 생성을 안하면 에러 발생.
		        document.getElementById('ttBtnAdd').onclick = () => {
		            const newName = prompt("새로운 시간표 이름을 입력하세요", "시간표");
		            if (!newName) return;

		            const csrfToken = document.querySelector('meta[name="_csrf"]').content;
		            const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;

		            fetch(path + '/schedule/insertTitle', {
		                method: 'POST',
		                headers: { 'Content-Type': 'application/json', [csrfHeader]: csrfToken },
		                body: JSON.stringify({ schtitleName: newName }) 
		            })
		            .then(res => res.json())
		            .then(data => {
						
		                if(data && data.schtitleNo) {
		                    const newTable = { 
		                        schtitleNo: data.schtitleNo, 
		                        name: newName, 
		                        courses: [] 
		                    };
		                    
		                    timetables.push(newTable);
		                    currentIdx = timetables.length - 1;
		                    
		                    updateDropdown();
		                    ttRenderGrid();
		                    alert("새 시간표가 생성되었습니다.");
		                }
		            });
		        };
				
		        
		        // 드롭다운 아래에 - 버튼. 시간표 삭제 버튼
		        document.getElementById('ttBtnMinus').onclick = () => {
		        	if (timetables.length === 0) return alert("삭제할 시간표가 없습니다.");
		            
		            const targetName = timetables[currentIdx].name; // 삭제할 시간표 이름
		            
				    const currentTable = timetables[currentIdx];
				    const targetNo = currentTable.schtitleNo || currentTable.no;
		            
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
		                    	schtitleNo: targetNo
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
		        

				
		        // 모달 창의 검색 칸.  2글자 이상의 키워드를 작성해야 검색 목록이 뜸.
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
		    
		    // 상세 모달 : 검색으로 나온 강의 클릭 시 나오는 창.
		    // 상세 모달 창 열기 
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
			
		    
		    // 상세 모달 창의 취소 버튼
		    function closeDetailModal() {
		        document.getElementById('ttDetailOverlay').style.display = 'none';
		        tempSelectedLecture = null;
		    }
			
		    
		    // 상세 모달 창의 확인 버튼
		    function confirmDetailAdd() {
		        const scheduleDay = parseInt(document.getElementById('detailDay').value);
		        const startTime = parseInt(document.getElementById('detailStart').value);
		        const endTime = parseInt(document.getElementById('detailEnd').value);
		        const hintEl = document.getElementById('detailHint');

		        // 1. 유효성 검사
		        if (endTime <= startTime) {
		            hintEl.textContent = '종료 시간은 시작 시간보다 늦어야 합니다.';
		            return;
		        }

		        // 2. 중복 검사
		        const overlap = timetables[currentIdx].courses.some(c => 
		            c.scheduleDay === scheduleDay && !(endTime <= c.startTime || startTime >= c.endTime)
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
		            startTime: startTime,
		            endTime: endTime
		        });

		        // 4. 후처리
		        saveToDatabase();
		        
		        ttRenderGrid();
		        closeDetailModal();
		    }
		    
		    
		    // 시간표를 드롭다운으로 표시 
		    function updateDropdown() {
		        const dropdown = document.getElementById('ttDropdown');
		        const titleText = document.getElementById('ttTitleText');
		        if(!dropdown || !titleText) return;

		        dropdown.innerHTML = ''; // 기존 목록 비우기
		        
		        if (timetables.length > 0) {
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
		        } else {
		            titleText.textContent = "시간표 없음";
		        }
		    }
		
		    document.addEventListener('DOMContentLoaded', () => {
		    	const isFriendMode = ${isFriend};
				
		        if (!isFriendMode) {
		        	emptyMsg = '<div style="position:absolute; text-align:center; padding-top:100px; color:#black;">';
			    	+ '<p>친구에게 등록된 시간표가 없습니다.</p>';
		            initEvents(); // 내 시간표일 때만 클릭 이벤트들(모달 열기, 삭제 등) 활성화
		        } else {
		            // 조회 모드일 때 필요한 최소한의 이벤트만 실행 (예: 드롭다운 메뉴 열기)
		            const titleBtn = document.getElementById('ttTitleBtn');
		            if(titleBtn) {
		                titleBtn.onclick = (e) => {
		                    e.stopPropagation();
		                    document.getElementById('ttDropdown').classList.toggle('open');
		                };
		            }
		        }
		    
		        loadTimetable();
		    });	   
		    
		</script>

		</div>
		<!-- /timetable -->


		<!-- ── 설정 패널 ───────────────────────────── -->
		<!-- <div id="setting" class="tab-panel"> -->
		<div id="setting"
			class="tab-panel ${category == 'setting' ? 'active' : ''}">
			<div class="setting-card">
				<h3 class="setting-card-title">개인정보 수정</h3>
				<div class="setting-form">

					<div class="setting-field">
						<label>현재 비밀번호 확인</label>
						<div style="display: flex; gap: 10px;">
							<input type="password" id="settingCurPw"
								placeholder="현재 비밀번호를 입력하세요" style="flex: 1;">
							<button type="button" class="setting-check-btn"
								onclick="verifyPassword()" id="verifyBtn">확인</button>
						</div>
					</div>

					<hr style="margin: 20px 0; border: 0; border-top: 1px dashed #ddd;">

					<div id="updateFields">
						<div class="setting-field">
							<label>아이디</label> <input type="text" id="settingId"
								value="${loginUser.memId}" disabled>
						</div>
						<div class="setting-field">
							<label>학번</label> <input type="text" id="settingStuNo"
								value="${loginUser.studentNo}" disabled>
						</div>
						<div class="setting-field">
							<label>전화번호</label> <input type="text" id="settingPhone"
								value="${loginUser.phone}" disabled>
						</div>
						<div class="setting-field">
							<label>학과 선택</label> <select id="settingDeptNo" disabled>
								<option value="${loginUser.deptNo}">기존 학과 유지</option>
							</select>
						</div>
						<div class="setting-field">
							<label>새 비밀번호</label> <input type="password" id="settingNewPw"
								placeholder="변경 시에만 입력" disabled>
						</div>
						<div class="setting-field">
							<label>새 비밀번호 확인</label> <input type="password"
								id="settingNewPwCk" placeholder="새 비밀번호 다시 입력" disabled>
						</div>

						<div class="setting-hint" id="settingHint"></div>
						<button class="setting-save-btn" id="saveBtn"
							onclick="saveSetting()" disabled>저장</button>
					</div>

					<hr style="margin: 20px 0; border: 0; border-top: 1px dashed #ddd;">

					<div class="setting-field">
						<form:form action="${path}/member/logout" method="post"
							style="margin:0;">
							<button type="submit" class="setting-logout-btn">로그아웃</button>
						</form:form>
					</div>

					<div class="setting-field">
						<a href="${path}/setting/withdraw" class="setting-withdraw-btn">
							회원탈퇴</a>
					</div>
				</div>
			</div>
			<script>
			// CSRF 토큰 설정
			const token = document.querySelector('meta[name="_csrf"]').content;
			const header = document.querySelector('meta[name="_csrf_header"]').content;
			

			
			// [1단계] 현재 비밀번호 확인
			function verifyPassword() {
			    const curPw = document.getElementById('settingCurPw').value;
			    const hint = document.getElementById('settingHint');
				
			    if (!curPw) {
			        alert("현재 비밀번호를 입력해주세요.");
			        return;
			    }
			
				const params = new URLSearchParams();
			    params.append('curPw', curPw);
			    
			    fetch('${path}/setting/verifyPw', {
			        method: 'POST',
			        headers: {
			            [header]: token
			        },
			        body: params
			    })
			    .then(res => res.json())
			    .then(data => {
			        if (data.result === 'ok') {
			            alert("인증되었습니다. 정보를 수정할 수 있습니다.");
			            // 모든 필드 잠금 해제
			            const inputs = document.querySelectorAll('#updateFields input, #saveBtn, #settingDeptNo');
			            inputs.forEach(input => input.disabled = false);
			            
			            loadDeptList();
			            
			            // 인증 버튼과 비밀번호 창은 수정 못하게 막기
			            document.getElementById('settingCurPw').disabled = true;
			            document.getElementById('verifyBtn').disabled = true;
			            hint.textContent = "";
			        } else {
			            hint.style.color = '#E24B4A';
			            hint.textContent = "비밀번호가 일치하지 않습니다.";
			        }
			    })
			    .catch(err => console.error("Error:", err));
			}
			
			
			// 학과 리스트 로드 함수
			function loadDeptList() {
			    const deptSelect = document.getElementById('settingDeptNo');
			    const currentDeptNo = "${loginUser.deptNo}"; // 기존 학과 번호

			    fetch('${path}/setting/deptList')
			        .then(res => res.json())
			        .then(list => {


			            list.forEach(dept => {
			                const option = document.createElement('option');
			                option.value = dept.DEPT_NO;
			                option.textContent = dept.DEPT_NAME;
			                
			                // 현재 내 학과를 기본 선택값으로 설정
			                if (dept.DEPT_NO == currentDeptNo) {
			                    option.selected = true;
			                }
			                deptSelect.appendChild(option);
			            });
			        })
			        .catch(err => console.error("학과 로드 실패:", err));
			}
			
			
			
			// 정보 저장
			function saveSetting() {
			    const hint = document.getElementById('settingHint');
			    const newPw = document.getElementById('settingNewPw').value.trim();
			    const newPwCk = document.getElementById('settingNewPwCk').value.trim();
			
			    if (newPw && newPw !== newPwCk) {
			        hint.style.color = '#E24B4A';
			        hint.textContent = '새 비밀번호가 일치하지 않습니다.';
			        return;
			    }
			
			    const params = new URLSearchParams();
			    params.append('memId', document.getElementById('settingId').value.trim());
			    params.append('studentNo', document.getElementById('settingStuNo').value.trim());
			    params.append('phone', document.getElementById('settingPhone').value.trim());
			    params.append('deptNo', document.getElementById('settingDeptNo').value);
			    params.append('curPw', document.getElementById('settingCurPw').value);
			    params.append('newPw', document.getElementById('settingNewPw').value.trim());
			
			    fetch('${path}/setting/update', {
			        method: 'POST',
			        headers: {
			            [header]: token
			        },
			        body: params
			    })
			    .then(res => res.json())
			    .then(data => {
			        if (data.result === 'ok') {
			            alert("회원 정보가 성공적으로 수정되었습니다.");
			            location.reload(); 
			        } else {
			            hint.style.color = '#E24B4A';
			            hint.textContent = data.message || '저장에 실패했습니다.';
			        }
			    })
			    .catch(err => console.error("Error:", err));
			}

			
			</script>
		</div>


	</div>
	<!-- /tab-content -->

</div>
<!-- /mypage-container -->


<jsp:include page="/WEB-INF/views/common2/footer.jsp" />
