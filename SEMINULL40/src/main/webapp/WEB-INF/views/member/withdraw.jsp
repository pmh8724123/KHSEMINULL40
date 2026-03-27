<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 
회원탈퇴 페이지 (withdraw.jsp)
	- Spring Security CSRF 토큰을 meta 태그로 선언하여
    Ajax 요청 시 헤더에 실어 보냄 
--%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />



<%-- Font Awesome : 아이콘 라이브러리 CDN --%>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
	
<link rel="stylesheet" href="${path}/resources/css/withdraw.css">


<%-- ===================== HTML 본문 시작 ========================= --%>
<jsp:include page="/WEB-INF/views/common2/header.jsp" />

<div class="withdraw-page">

	<%-- 페이지 제목 : 왼쪽 빨간 세로선으로 경고성 페이지임을 표시 --%>
	<h1 class="withdraw-page-title">회원 탈퇴</h1>

	<%-- ───────────────────────────────────────────
         메인 카드
         탈퇴 폼(#withdrawCard)과 완료 안내(#withdrawSuccess)
         Ajax 결과에 따라 JS가 두 영역을 교체(show/hide)
         교체 되는 지점 = withdraw-success 
    ─────────────────────────────────────────── --%>
	<div class="withdraw-card">

		<%-- ── 탈퇴 폼 영역 ─────────────────────── --%>
		<div id="withdrawCard">

			<%-- 카드 헤더 : 아이콘 + 제목 + 부제 --%>
			<div class="withdraw-card-header">
				<div class="icon-box">
					<i class="fa-solid fa-user-xmark"></i>
				</div>
				<div class="header-text">
					<h2>회원 탈퇴</h2>
					<p>탈퇴 전 아래 내용을 꼭 확인해주세요</p>
				</div>
			</div>

			<%-- 탈퇴 시 삭제되는 항목 경고 --%>
			<div class="warn-box">
				<p class="warn-title">
					<i class="fa-solid fa-triangle-exclamation"></i> 탈퇴 시 아래 정보가 즉시
					삭제됩니다
				</p>
				<ul>
					<li>저장된 시간표 및 강의 정보</li>
					<li>출석 체크 기록 및 포인트</li>
					<li>등록된 친구 목록</li>
					<li>개인 계정 정보 (아이디, 이메일, 학과 정보)</li>
					<li>삭제된 데이터는 복구가 불가능합니다</li>
				</ul>
			</div>

			<div class="withdraw-divider"></div>

			<%-- 탈퇴 사유 드롭다운 --%>
			<div class="field-wrap">
				<label>탈퇴 사유 <span class="required">*</span></label> <select
					id="withdrawReason">
					<option value="">-- 사유를 선택해주세요 --</option>
					<option value="notUsed">더 이상 사용하지 않아요</option>
					<option value="inconvenient">서비스 이용이 불편해요</option>
					<option value="privacy">개인정보 보호가 걱정돼요</option>
					<option value="other">기타</option>
				</select>
			</div>

			<%-- 비밀번호 확인 : 본인 인증 목적 --%>
			<div class="field-wrap">
				<label>현재 비밀번호 <span class="required">*</span></label> <input
					type="password" id="withdrawPw" placeholder="현재 비밀번호를 입력해주세요">
			</div>

			<div class="withdraw-divider"></div>

			<%-- 탈퇴 동의 체크박스 : 체크하지 않으면 JS에서 전송 차단 --%>
			<div class="agree-box">
				<label> <input type="checkbox" id="withdrawAgree"> 위
					내용을 모두 확인했으며, 회원 탈퇴에 동의합니다. 탈퇴 후 데이터가 복구되지 않음을 이해합니다.
				</label>
			</div>

			<%-- 유효성 / 서버 오류 메시지 출력 (JS가 채움) --%>
			<div class="withdraw-hint" id="withdrawHint"></div>

			<%-- 하단 버튼 --%>
			<div class="withdraw-actions">
				<%-- 취소 : 마이페이지 설정 탭으로 복귀 --%>
				<button class="btn-cancel"
					onclick="location.href='${path}/member/mypage'">
					<i class="fa-solid fa-arrow-left" style="margin-right: 5px"></i> 취소
				</button>

				<%-- 탈퇴 확인 : doWithdraw() 호출 --%>
				<button class="btn-withdraw" id="btnWithdraw" onclick="doWithdraw()">
					<i class="fa-solid fa-user-xmark" style="margin-right: 5px"></i>
					탈퇴하기
				</button>
			</div>

		</div>
		<%-- /withdrawCard (폼 영역 끝) --%>


		<%-- ── 탈퇴 완료 안내 영역 ──────────────────
             기본 none → Ajax 성공 시 block 으로 전환
             3초 카운트다운 후 메인 페이지로 자동 이동
        ─────────────────────────────────────────── --%>
		<div class="withdraw-success" id="withdrawSuccess">
			<div class="success-icon">
				<i class="fa-regular fa-circle-check"></i>
			</div>
			<h3>탈퇴가 완료되었습니다</h3>
			<p>
				그동안 이용해 주셔서 감사합니다.<br> 잠시 후 메인 페이지로 이동합니다.
			</p>
		</div>

	</div>
	<%-- /withdraw-card --%>

</div>
<%-- /withdraw-page --%>

<script>
	/*
	 doWithdraw()

	 "탈퇴하기" 버튼 클릭 시 실행되는 메인 함수

	 처리 순서
	 1. 입력값 수집 (사유 / 비밀번호 / 동의 체크)
	 2. 클라이언트 유효성 검사 → 실패 시 힌트 메시지 표시 후 중단
	 3. 버튼 비활성화 (중복 클릭 방지)
	 4. CSRF 토큰을 헤더에 실어 Ajax POST 전송
	 5. 성공 응답(result: 'ok') → 완료 화면 전환 + 3초 후 메인 이동
	 6. 실패 응답 또는 통신 오류 → 힌트 메시지 표시 + 버튼 재활성화
	 */
	function doWithdraw() {

		/* ── 1. 입력값 수집 ──────────────────────────────────────── */
		var hint = document.getElementById('withdrawHint');
		var reason = document.getElementById('withdrawReason').value;
		var pw = document.getElementById('withdrawPw').value.trim();
		var agreed = document.getElementById('withdrawAgree').checked;
		var btn = document.getElementById('btnWithdraw');

		/* 이전 힌트 메시지 초기화 */
		hint.style.color = '#E24B4A';
		hint.textContent = '';

		/* ── 2. 클라이언트 유효성 검사 ──────────────────────────── */

		/* 탈퇴 사유 미선택 시 전송 중단 */
		if (!reason) {
			hint.textContent = '탈퇴 사유를 선택해주세요.';
			return;
		}

		/* 비밀번호 미입력 시 전송 중단 */
		if (!pw) {
			hint.textContent = '현재 비밀번호를 입력해주세요.';
			return;
		}

		/* 동의 체크 미완료 시 전송 중단 */
		if (!agreed) {
			hint.textContent = '탈퇴 동의에 체크해주세요.';
			return;
		}

		/* ── 3. 버튼 비활성화 (중복 제출 방지) ──────────────────── */
		btn.disabled = true;
		btn.textContent = '처리 중...';

		/* ── 4. Ajax POST 전송 ─────────────────────────────────── */
		$
				.ajax({
					url : '${path}/withdraw/confirm',
					type : 'POST',
					contentType : 'application/json',
					headers : {
						'${_csrf.headerName}' : '${_csrf.token}'
					},
					data : JSON.stringify({
						reason : reason,
						curPw : pw
					}),

					/* ── 5. 성공 콜백 ─────────────────────────────────────
					   서버 응답 형식 예시
					     성공 : { "result": "ok" }
					     실패 : { "result": "fail", "message": "비밀번호가 틀립니다." }
					────────────────────────────────────────────────────── */
					success : function(data) {

						if (data.result === 'ok') {

							/*
							탈퇴 완료 화면으로 전환
								폼 영역(#withdrawCard)을 숨기고
								완료 안내(#withdrawSuccess)를 보이게 교체
							 */
							document.getElementById('withdrawCard').style.display = 'none';
							document.getElementById('withdrawSuccess').style.display = 'block';

							/*
							 	3초(3000ms) 후 마이페이지로 자동 이동
							 	setTimeout : 지정한 시간이 지난 뒤 콜백을 한 번만 실행하는 Web API
							 */
							setTimeout(function() {
								location.href = '${path}/member/mypage';
							}, 3000);

						} else {
							/* 서버가 실패(result !== 'ok')로 응답한 경우 메시지 표시 */
							hint.textContent = data.message
									|| '탈퇴에 실패했습니다. 다시 시도해주세요.';

							/* 버튼을 다시 활성화, 재시도 허용하기 */
							btn.disabled = false;
							btn.innerHTML = '<i class="fa-solid fa-user-xmark" style="margin-right:5px"></i>탈퇴하기';
						}
					},

					/* ── 6. 통신 오류 콜백 ───────────────────────────────
					   네트워크 단절, 서버 500 에러 등 HTTP 수준 오류 발생 시 실행
					────────────────────────────────────────────────────── */
					error : function() {
						hint.textContent = '서버와 연결할 수 없습니다. 잠시 후 다시 시도해주세요.';

						/* 버튼 복원 */
						btn.disabled = false;
						btn.innerHTML = '<i class="fa-solid fa-user-xmark" style="margin-right:5px"></i>탈퇴하기';
					}
				});
	}
</script>

<jsp:include page="/WEB-INF/views/common2/footer.jsp" />
