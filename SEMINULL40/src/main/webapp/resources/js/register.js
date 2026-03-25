const contextPath = document.body.dataset.contextPath;

// 아이디 변수
const memId = document.getElementById("memId");
const idMsg = document.getElementById("idMsg");
		
// 비밀번호 변수
const memPw = document.getElementById("memPw");
const memPwConfirm = document.getElementById("memPwConfirm");
const pwMsg = document.getElementById("pwMsg");
		
// 이름 변수
const memName = document.getElementById("memName");
const nameMsg = document.getElementById("nameMsg");

// 학교 변수
const uni = document.getElementById("uniSelect");
const uniMsg = document.getElementById("uniMsg");

// 학과 변수
const dept = document.getElementById("deptSelect");
const deptMsg = document.getElementById("deptMsg");

// 학번 변수
const sno = document.getElementById("studentNo");
const snoMsg = document.getElementById("snoMsg");

// 전화번호 변수
const phone = document.getElementById("phone");
const pMsg = document.getElementById("phoneMsg");
		
// 아이디 이벤트리스너
memId.addEventListener("input", function() {
	value = this.value;

	if(value == "") {
		idMsg.innerHTML = "아이디를 입력해 주세요";
		return;
	}

	if(value.length > 0 && value.length < 4 || value.length > 20) {
		idMsg.innerHTML = "4~20자로 입력해 주세요";
		return;
	}

	idMsg.innerHTML = "&nbsp;";
});
		
// 비밀번호 이벤트리스너
memPw.addEventListener("input", function() {
	if(this.value == "") {
		pwMsg.innerHTML = "비밀번호를 입력해 주세요";
	}
	else if(this.value.length < 8) {
		pwMsg.innerHTML = "8자 이상 입력해 주세요";
	}
	else if(this.value !== memPwConfirm.value) {
		pwMsg.innerHTML = "비밀번호 입력이 동일하지 않습니다";
	}
	else {
		pwMsg.innerHTML = "&nbsp;";
	}
});
memPwConfirm.addEventListener("input", function() {
	if(this.value !== memPw.value) {
		pwMsg.innerHTML = "비밀번호 입력이 동일하지 않습니다";
	}
	else {
		pwMsg.innerHTML = "&nbsp;";
	}
});
	
// 이름 이벤트리스너
memName.addEventListener("input", function() {
	if(this.value == "") {
		nameMsg.innerHTML = "이름을 입력해 주세요";
	}
	else {
		nameMsg.innerHTML = "&nbsp;";
	}
});

// 학교 선택 이벤트리스너
uni.addEventListener("change", function() {
	const uniNo = this.value;

	if(uniNo == "") {
		dept.innerHTML = "<option value=''>학과 선택</option>";
		uniMsg.innerHTML = "학교를 선택해 주세요";
		return;
	}

	uniMsg.innerHTML = "&nbsp;";

	fetch(contextPath + "/member/deptList?uniNo=" + uniNo).then(res => res.json()).then(data => {
		let options = "<option value=''>학과 선택</option>";

		data.forEach(dept => {
		    options += `<option value="${dept.deptNo}">${dept.deptName}</option>`;
		});

		dept.innerHTML = options;
	});
});

// 학과 선택 이벤트리스너
dept.addEventListener("change", function() {
	if(dept.value == "") {
		deptMsg.innerHTML = "학과를 선택해 주세요";
		return;
	}

	deptMsg.innerHTML = "&nbsp;";
});

// 학번 리스너
sno.addEventListener("input", function() {
	if(this.value == "") {
		snoMsg.innerHTML = "학번을 입력해 주세요";
		return;
	}

	snoMsg.innerHTML = "&nbsp;";
});

// 전화번호 리스너
phone.addEventListener("input", function() {
	if(this.value == "") {
		pMsg.innerHTML = "전화번호를 입력해 주세요";
		return;
	}

	pMsg.innerHTML = "&nbsp;";
});