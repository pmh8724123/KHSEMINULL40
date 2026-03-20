			(function() {
			
			    // ── 상수 ─────────────────────────────────────────
			    const DAYS        = ['월','화','수','목','금'];
			    const START_HOUR  = 9;
			    const END_HOUR    = 17;
			    const SLOT_H      = 36;                           // 30분 슬롯 픽셀 높이
			    const TOTAL_SLOTS = (END_HOUR - START_HOUR) * 2; // 총 슬롯 수
			
			    // ── 상태 ─────────────────────────────────────────
			    let timetables = [{ name: '2026년도 1학기 시간표', courses: [] }];
			    let currentIdx = 0;
			    let deleteMode = false;
			
			    // ── 슬롯 인덱스 → "H:MM" 변환 ────────────────────
			    function slotToTime(slot) {
			        return Math.floor(slot / 2) + ':' + (slot % 2 === 0 ? '00' : '30');
			    }
			
			    // ── 시간 선택 옵션 빌드 (30분 단위) ──────────────
			    function buildTimeOptions(selectEl, defaultHour, defaultMin) {
			        selectEl.innerHTML = '';
			        for (var h = START_HOUR; h <= END_HOUR; h++) {
			            ['00', '30'].forEach(function(m) {
			                if (h === END_HOUR && m === '30') return;
			                var val = h * 2 + (m === '30' ? 1 : 0);
			                var opt = document.createElement('option');
			                opt.value       = val;
			                opt.textContent = h + ':' + m;
			                if (h === defaultHour && parseInt(m) === defaultMin) opt.selected = true;
			                selectEl.appendChild(opt);
			            });
			        }
			    }
			
			    // ── 그리드 전체 렌더링 ────────────────────────────
			    function ttRenderGrid() {
			        var grid = document.getElementById('ttGrid');
			        grid.innerHTML = '';
			
			        // 헤더: 빈 셀 + 요일명
			        var emptyCell = document.createElement('div');
			        emptyCell.className = 'tt-header-cell';
			        grid.appendChild(emptyCell);
			
			        DAYS.forEach(function(d) {
			            var h = document.createElement('div');
			            h.className   = 'tt-header-cell';
			            h.textContent = d;
			            grid.appendChild(h);
			        });
			
			        // 시간 열: 정시만 숫자 표시
			        var timeCol = document.createElement('div');
			        timeCol.className = 'tt-time-col';
			        for (var s = 0; s < TOTAL_SLOTS; s++) {
			            var sl = document.createElement('div');
			            sl.className   = 'tt-time-slot';
			            sl.textContent = s % 2 === 0 ? String(START_HOUR + s / 2).padStart(2, '0') : '';
			            timeCol.appendChild(sl);
			        }
			        grid.appendChild(timeCol);
			
			        // 요일별 열: 배경선 + 강의 블록
			        var courses = timetables[currentIdx].courses;
			        DAYS.forEach(function(_, dayIdx) {
			            var col = document.createElement('div');
			            col.className = 'tt-day-col';
			
			            // 배경 가로선
			            for (var s = 0; s < TOTAL_SLOTS; s++) {
			                var line = document.createElement('div');
			                line.className = 'tt-row-line';
			                col.appendChild(line);
			            }
			
			            // 해당 요일 강의 블록 배치
			            courses.filter(function(c) { return c.day === dayIdx; })
			                   .forEach(function(c) {
			                var block = document.createElement('div');
			                block.className = 'tt-block' + (deleteMode ? ' delete-mode' : '');
			                block.style.top    = (c.startSlot - START_HOUR * 2) * SLOT_H + 'px';
			                block.style.height = (c.endSlot - c.startSlot) * SLOT_H + 'px';
			                // JSP EL 충돌 방지: 문자열 연결 사용
			                block.innerHTML = '<span>' + c.title + '</span>'
			                    + '<span style="font-size:10px; color:#185FA5; opacity:.8">'
			                    + slotToTime(c.startSlot) + '~' + slotToTime(c.endSlot)
			                    + '</span>';
			                // 삭제 모드일 때만 클릭으로 강의 제거
			                block.addEventListener('click', (function(course) {
			                    return function() {
			                        if (!deleteMode) return;
			                        var idx = timetables[currentIdx].courses.indexOf(course);
			                        timetables[currentIdx].courses.splice(idx, 1);
			                        ttRenderGrid();
			                    };
			                })(c)); // 클로저로 c 캡처 (forEach 루프 변수 문제 방지)
			                col.appendChild(block);
			            });
			            grid.appendChild(col);
			        });
			    }
			
			    // ── 드롭다운 목록 렌더링 ─────────────────────────
				// ── 드롭다운 목록 렌더링 (드래그로 순서 변경 가능) ──
				function ttRenderDropdown() {
				    var dd = document.getElementById('ttDropdown');
				    dd.innerHTML = '';
				
				    timetables.forEach(function(t, i) {
				        var item = document.createElement('div');
				        item.className   = 'tt-dropdown-item' + (i === currentIdx ? ' active' : '');
				        item.draggable   = true;          // 드래그 가능하게 설정
				        item.dataset.idx = i;             // 인덱스를 data 속성으로 저장
				
				        // 드래그 핸들 아이콘 (⠿ 점 6개)
				        var handle = document.createElement('span');
				        handle.className   = 'tt-drag-handle';
				        handle.textContent = '⠿';
				        handle.title       = '드래그하여 순서 변경';
				
				        // 시간표 이름 텍스트
				        var label = document.createElement('span');
				        label.textContent = t.name;
				
				        item.appendChild(handle);
				        item.appendChild(label);
				
				        // ── 드래그 이벤트 ─────────────────────────────
				
				        // 드래그 시작: 드래그 중인 항목 인덱스 저장
				        item.addEventListener('dragstart', function(e) {
				            e.dataTransfer.setData('text/plain', i);
				            item.classList.add('dragging');  // 드래그 중 스타일
				        });
				
				        // 드래그 끝: 스타일 원복
				        item.addEventListener('dragend', function() {
				            item.classList.remove('dragging');
				            // 모든 drag-over 스타일 제거
				            dd.querySelectorAll('.tt-dropdown-item').forEach(function(el) {
				                el.classList.remove('drag-over');
				            });
				        });
				
				        // 다른 항목 위로 드래그 진입 시: 위치 표시
				        item.addEventListener('dragover', function(e) {
				            e.preventDefault();  // drop 허용을 위해 필수
				            item.classList.add('drag-over');
				        });
				
				        // 다른 항목에서 드래그 벗어날 때: 스타일 제거
				        item.addEventListener('dragleave', function() {
				            item.classList.remove('drag-over');
				        });
				
				        // 드롭: 두 항목의 순서를 실제로 교체
				        item.addEventListener('drop', function(e) {
				            e.preventDefault();
				            var fromIdx = parseInt(e.dataTransfer.getData('text/plain')); // 드래그 출발 인덱스
				            var toIdx   = parseInt(item.dataset.idx);                     // 드롭 대상 인덱스
				
				            if (fromIdx === toIdx) return; // 같은 자리면 무시
				
				            // 배열에서 두 항목 위치 교체
				            var moved = timetables.splice(fromIdx, 1)[0]; // 출발 항목 꺼내기
				            timetables.splice(toIdx, 0, moved);            // 대상 위치에 삽입
				
				            // currentIdx가 이동한 항목이면 따라가기
				            if (currentIdx === fromIdx) {
				                currentIdx = toIdx;
				            } else if (currentIdx > fromIdx && currentIdx <= toIdx) {
				                currentIdx--;  // 당겨진 경우
				            } else if (currentIdx < fromIdx && currentIdx >= toIdx) {
				                currentIdx++;  // 밀린 경우
				            }
				
				            ttRenderDropdown(); // 목록 다시 그리기
				        });
				
				        // 항목 클릭: 해당 시간표로 전환
				        label.addEventListener('click', function() {
				            currentIdx = i;
				            document.getElementById('ttTitleText').textContent = t.name;
				            dd.classList.remove('open');
				            document.getElementById('ttTitleBtn').classList.remove('open');
				            deleteMode = false;
				            ttUpdateDeleteBtn();
				            ttRenderGrid();
				        });
				
				        dd.appendChild(item);
				    });
				}
			
			    // ── 삭제 버튼 & 힌트 UI 업데이트 ─────────────────
			    function ttUpdateDeleteBtn() {
			        var btn  = document.getElementById('ttBtnDel');
			        var hint = document.getElementById('ttDelHint');
			        if (deleteMode) {
			            btn.classList.add('active');
			            hint.textContent = '삭제할 강의를 클릭하세요. 버튼을 다시 누르면 삭제 모드가 종료됩니다.';
			        } else {
			            btn.classList.remove('active');
			            hint.textContent = '';
			        }
			    }
			
			    // ── 강의 추가 모달 열기 ───────────────────────────
			    function ttOpenModal() {
			        document.getElementById('ttInpTitle').value        = '';
			        document.getElementById('ttModalHint').textContent = '';
			        buildTimeOptions(document.getElementById('ttInpStart'), 9,  0);
			        buildTimeOptions(document.getElementById('ttInpEnd'),  10,  0);
			        document.getElementById('ttOverlay').classList.add('open');
			    }
			
			    // ── 강의 추가 모달 닫기 ───────────────────────────
			    function ttCloseModal() {
			        document.getElementById('ttOverlay').classList.remove('open');
			    }
			
			    // ── 강의 추가 확인 ────────────────────────────────
			    function ttConfirmAdd() {
			        var title     = document.getElementById('ttInpTitle').value.trim();
			        var day       = parseInt(document.getElementById('ttInpDay').value);
			        var startSlot = parseInt(document.getElementById('ttInpStart').value);
			        var endSlot   = parseInt(document.getElementById('ttInpEnd').value);
			        var hint      = document.getElementById('ttModalHint');
			
			        if (!title)               { hint.textContent = '강의명을 입력해주세요.'; return; }
			        if (endSlot <= startSlot) { hint.textContent = '종료 시간은 시작 시간보다 늦어야 합니다.'; return; }
			
			        // 시간 겹침 체크
			        var overlap = timetables[currentIdx].courses.some(function(c) {
			            return c.day === day && !(endSlot <= c.startSlot || startSlot >= c.endSlot);
			        });
			        
			        if (overlap) { 
			        	hint.textContent = '해당 시간에 이미 강의가 있습니다.'; 
			        	return; 
			        	}
			
			        timetables[currentIdx].courses.push({ title: title, day: day, startSlot: startSlot, endSlot: endSlot });
			        ttCloseModal();
			        ttRenderGrid();
			    }
			
			    // ── 이벤트 바인딩 ─────────────────────────────────
			    // JSP는 DOM이 이미 완성된 후 스크립트 실행 → DOMContentLoaded 불필요
			    // 바로 바인딩해도 안전함
			
			    // 드롭다운 토글 버튼
			    document.getElementById('ttTitleBtn').addEventListener('click', function(e) {
			        e.stopPropagation(); // 외부 클릭 감지와 충돌 방지
			        var dd  = document.getElementById('ttDropdown');
			        var btn = document.getElementById('ttTitleBtn');
			        var isOpen = dd.classList.contains('open');
			        dd.classList.toggle('open');
			        btn.classList.toggle('open');
			        if (!isOpen) ttRenderDropdown(); // 열릴 때만 목록 재렌더링
			    });
			
			    // 드롭다운 외부 클릭 시 닫기 (중복 제거 후 1번만 등록)
			    document.addEventListener('click', function(e) {
			        var titleBtn = document.getElementById('ttTitleBtn');
			        var dd       = document.getElementById('ttDropdown');
			        if (titleBtn && dd && !titleBtn.contains(e.target)) {
			            dd.classList.remove('open');
			            titleBtn.classList.remove('open');
			        }
			    });
			
			    // 시간표 추가 버튼 (+)
			    document.getElementById('ttBtnAdd').addEventListener('click', function() {
			        var name = prompt('새 시간표 이름을 입력하세요', '새 시간표');
			        if (!name) return;
			        timetables.push({ name: name.trim(), courses: [] });
			        currentIdx = timetables.length - 1;
			        document.getElementById('ttTitleText').textContent = timetables[currentIdx].name;
			        deleteMode = false;
			        ttUpdateDeleteBtn();
			        ttRenderGrid();
			    });
			
			    // 시간표 삭제 버튼 (-)
			    document.getElementById('ttBtnMinus').addEventListener('click', function() {
			        if (timetables.length === 1) {
			            alert('시간표는 최소 1개 이상 있어야 합니다.');
			            return;
			        }
			        if (!confirm('"' + timetables[currentIdx].name + '" 시간표를 삭제할까요?')) return;
			        timetables.splice(currentIdx, 1);
			        currentIdx = Math.max(0, currentIdx - 1);
			        document.getElementById('ttTitleText').textContent = timetables[currentIdx].name;
			        deleteMode = false;
			        ttUpdateDeleteBtn();
			        ttRenderGrid();
			    });
			
			    // 강의 추가 버튼
			    document.getElementById('ttBtnOpenModal').addEventListener('click', ttOpenModal);
			
			    // 강의 삭제 모드 토글 버튼
			    document.getElementById('ttBtnDel').addEventListener('click', function() {
			        deleteMode = !deleteMode;
			        ttUpdateDeleteBtn();
			        ttRenderGrid();
			    });
			
			    // 모달 확인 버튼
			    document.getElementById('ttBtnConfirm').addEventListener('click', ttConfirmAdd);
			
			    // 모달 취소 버튼
			    document.getElementById('ttBtnCancel').addEventListener('click', ttCloseModal);
			
			    // ── 초기 렌더링 ───────────────────────────────────
			    ttRenderGrid();
			
			})();