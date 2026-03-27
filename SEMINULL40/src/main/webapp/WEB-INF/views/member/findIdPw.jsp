<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>아이디/비밀번호 찾기</title>

<style>
    body {
        margin: 0;
        font-family: 'Pretendard', sans-serif;
        background-color: #f6f7fb;

        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }

    .wrapper {
        width: 1000px;
    }

    .card-wrapper {
        display: flex;
        gap: 40px;
    }

    .card {
        flex: 1;
        background: #e3e9f1;
        border-radius: 20px;
        height: 600px;
        position: relative;
        padding: 0 40px;
        box-sizing: border-box;
        text-align: center;
    }

    .card h2 {
        position: absolute;
        top: 50px;
        left: 50%;
        transform: translateX(-50%);
        margin: 0;
        font-size: 30px;
    }

    .form-area {
        position: absolute;
        top: 160px;
        left: 40px;
        right: 40px;
    }

    .form-control {
        width: 100%;
        height: 50px;
        border-radius: 12px;
        border: 1px solid #ccc;
        padding: 0 15px;
        margin-bottom: 30px;
        font-size: 14px;
        box-sizing: border-box;
    }

    .result-area {
        margin-top: 30px;
        text-align: left;
    }

    /* 🔥 라벨 */
    .result-label {
        font-size: 14px;
        margin-bottom: 8px;
    }

    .result-box {
        height: 80px;
        border-radius: 10px;
        background: #ffffff;
        border: 1px solid #d0d7e2;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 14px;
        color: #333;
    }

    .btn {
        position: absolute;
        bottom: 30px;
        left: 40px;
        right: 40px;

        height: 50px;
        border-radius: 12px;
        border: none;
        background: #3a8edb;
        color: white;
        font-size: 15px;
        cursor: pointer;
    }

    .btn:hover {
        background: #2f78be;
    }
</style>

</head>
<body>

<div class="wrapper">

    <div class="card-wrapper">

        <!-- 아이디 찾기 -->
        <div class="card">
            <h2>아이디 찾기</h2>

            <form:form action="${pageContext.request.contextPath}/member/findIdPw" method="post">
            	<input type="hidden" name="type" value="id">
                <div class="form-area">
                    <input class="form-control" type="text" name="memName" placeholder="이름">
                    <input class="form-control" type="text" name="phone" placeholder="전화번호">

                    <!-- 결과 영역 -->
                    <div class="result-area">
                        <div class="result-label">아이디 :</div>
                        <div class="result-box">
                            ${idResult != null ? idResult : "조회결과가 존재하지 않습니다."}
                        </div>
                    </div>
                </div>

                <button class="btn">아이디 찾기</button>
            </form:form>
        </div>

        <!-- 비밀번호 찾기 -->
        <div class="card">
            <h2>비밀번호 찾기</h2>

            <form:form action="${pageContext.request.contextPath}/member/findIdPw" method="post">
            	<input type="hidden" name="type" value="pw">
                <div class="form-area">
                    <input class="form-control" type="text" name="memId" placeholder="아이디">
                    <input class="form-control" type="text" name="phone" placeholder="전화번호">

                    <!-- 결과 영역 -->
                    <div class="result-area">
                        <div class="result-label">비밀번호 :</div>
                        <div class="result-box">
                            ${pwResult != null ? pwResult : "조회결과가 존재하지 않습니다."}
                        </div>
                    </div>
                </div>

                <button class="btn">비밀번호 찾기</button>
            </form:form>
        </div>

    </div>

</div>

</body>
</html>