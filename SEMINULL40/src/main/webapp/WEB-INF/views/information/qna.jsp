<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의하기</title>

<style>
    * {
        box-sizing: border-box;
        font-family: 'Malgun Gothic', sans-serif;
    }

    body {
        margin: 0;
        background-color: #f5f7fb;
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .qna-container {
        width: 100%;
        max-width: 600px;
        background: #fff;
        padding: 60px 40px;
        border-radius: 20px;
        box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        text-align: center;
    }

    .qna-icon {
        font-size: 48px;
        margin-bottom: 20px;
    }

    .qna-title {
        font-size: 36px;
        font-weight: bold;
        margin-bottom: 20px;
        color: #222;
    }

    .qna-desc {
        font-size: 18px;
        color: #555;
        margin-bottom: 10px;
    }

    .qna-sub {
        font-size: 16px;
        color: #777;
        margin-bottom: 30px;
    }

    .email-box {
        background-color: #eef4ff;
        padding: 16px;
        border-radius: 10px;
        font-weight: bold;
        margin-bottom: 30px;
        font-size: 16px;
    }

    .btn-group {
        display: flex;
        justify-content: center;
        gap: 15px;
    }

    .mail-btn {
        padding: 14px 28px;
        font-size: 16px;
        border-radius: 10px;
        background-color: #a2ccfe;
        color: #333;
        text-decoration: none;
        font-weight: bold;
    }

    .mail-btn:hover {
        background-color: #8dbdf7;
    }

    .back-btn {
        padding: 14px 28px;
        font-size: 16px;
        border-radius: 10px;
        background-color: #e5e7eb;
        color: #333;
        border: none;
        cursor: pointer;
    }

    .back-btn:hover {
        background-color: #d1d5db;
    }
</style>
</head>
<body>

<div class="qna-container">

    <div class="qna-icon">📩</div>

    <div class="qna-title">문의하기 (Q&A)</div>

    <div class="qna-desc">
        서비스 이용 중 궁금한 점이나 문제가 발생하셨나요?
    </div>

    <div class="qna-sub">
        아래 이메일로 문의해주시면 최대한 빠르게 답변드리겠습니다 😊
    </div>

    <div class="email-box">
        📧 camdulgi.help@gmail.com
    </div>

    <div class="btn-group">
        <a href="mailto:camdoolgi.help@gmail.com" class="mail-btn">
            메일 보내기
        </a>

        <button onclick="history.back()" class="back-btn">
            ← 돌아가기
        </button>
    </div>

</div>

</body>
</html>