// attendance.js

(function() {

    // ── 상수 ─────────────────────────────────────────
    // contextPath: 빈 문자열로 기본값 설정 (JSTL 못 쓰는 .js 파일 대응)
	var contextPath = (typeof CONTEXT_PATH !== 'undefined') ? CONTEXT_PATH : '';
	var ATT_TOTAL   = 7;
	var ATT_REWARDS = {
	    5: '포인트 +10',
	    6: '포인트 +10',
	    7: '포인트 +50 (7일 달성!)'
	};

    // CSRF: meta 태그가 없을 수 있으므로 null 체크 후 꺼냄
    var csrfMeta     = document.querySelector('meta[name="_csrf"]');
    var csrfHdrMeta  = document.querySelector('meta[name="_csrf_header"]');
	var csrfToken  = (typeof CSRF_TOKEN  !== 'undefined') ? CSRF_TOKEN
	               : (document.querySelector('meta[name="_csrf"]')
	                  ? document.querySelector('meta[name="_csrf"]').getAttribute('content') : '');
	var csrfHeader = (typeof CSRF_HEADER !== 'undefined') ? CSRF_HEADER
	               : (document.querySelector('meta[name="_csrf_header"]')
	                  ? document.querySelector('meta[name="_csrf_header"]').getAttribute('content')
	                  : 'X-CSRF-TOKEN');

    // ── 상태 변수 ─────────────────────────────────────
    var attChecked   = 0;      // 연속 출석 완료 일수 (DB에서 로드)
    var checkedToday = false;  // 오늘 이미 출석했는지 여부

    // ── 화면 렌더링 ───────────────────────────────────
    function attRender() {
        var dots = document.getElementById('attDots');
        if (!dots) return; // 요소 없으면 중단
        dots.innerHTML = '';

        // 1~7 도형 생성
        for (var i = 1; i <= ATT_TOTAL; i++) {
            var d   = document.createElement('div');
            var cls = 'att-dot';
            if (i <= attChecked)           cls += ' done';
            else if (i === attChecked + 1) cls += ' today';
            d.className = cls;
            d.innerHTML = '<span>' + i + '</span>'
                        + '<span class="di">'
                        + (i <= attChecked ? '&#10003;' : '일')
                        + '</span>';
            dots.appendChild(d);
        }

        // 일차 숫자
        document.getElementById('attDayNum').textContent    = Math.min(attChecked + 1, ATT_TOTAL);

        // 진행률 바
        document.getElementById('attProgLabel').textContent = attChecked + ' / ' + ATT_TOTAL + '일';
        document.getElementById('attProgFill').style.width  = (attChecked / ATT_TOTAL * 100) + '%';

        // 버튼 상태
        var btn = document.getElementById('attBtn');
        if (!btn) return;

        if (attChecked >= ATT_TOTAL) {
            // 7일 모두 완료
            btn.disabled       = true;
            btn.textContent    = '출석 완료';
            btn.style.fontSize = '';
        } else if (checkedToday) {
            // 오늘 출석 완료 → 내일 자정까지 비활성
            btn.disabled       = true;
            btn.textContent    = '내일 오전 12시에 가능합니다';
            btn.style.fontSize = '12px';
        } else {
            // 출석 가능
            btn.disabled       = false;
            btn.textContent    = '출석 체크하기';
            btn.style.fontSize = '';
        }

        // 보상 메시지
        document.getElementById('attReward').textContent = ATT_REWARDS[attChecked] || '';
    }

    // ── DB에서 출석 상태 로드 ─────────────────────────
    function attLoadStatus() {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', contextPath + '/attendance/status', true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                var res      = JSON.parse(xhr.responseText);
                attChecked   = res.currentDay;
                checkedToday = res.checkedToday;
                attRender();
            }
        };
        xhr.send();
    }

    // ── 출석 체크 실행 ────────────────────────────────
    function attCheck() {
        if (checkedToday || attChecked >= ATT_TOTAL) return;

        var xhr = new XMLHttpRequest();
        xhr.open('POST', contextPath + '/attendance/check', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        // CSRF 토큰이 있을 때만 헤더 추가
        if (csrfToken) xhr.setRequestHeader(csrfHeader, csrfToken);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                var res = JSON.parse(xhr.responseText);
                if (res.success) {
                    attChecked   = res.currentDay;
                    checkedToday = true;
                } else {
                    checkedToday = true;
                }
                attRender();
            }
        };
        xhr.send();
    }

    // ── 버튼 이벤트 바인딩 ────────────────────────────
    // onclick 속성 대신 addEventListener 사용 (IIFE 안 함수 접근 불가 문제 해결)
    var btn = document.getElementById('attBtn');
    if (btn) btn.addEventListener('click', attCheck);

    // ── 초기 실행 ─────────────────────────────────────
    attLoadStatus();

})();