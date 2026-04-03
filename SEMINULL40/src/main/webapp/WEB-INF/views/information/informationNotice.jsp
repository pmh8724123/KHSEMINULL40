<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항</title>

<style>
    * {
        box-sizing: border-box;
    }

    body {
        margin: 0;
        background-color: #f5f7fb;
        font-family: 'Malgun Gothic', sans-serif;
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .notice-container {
        width: 100%;
        max-width: 600px;
        background: #fff;
        padding: 60px 40px;
        border-radius: 20px;
        box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        text-align: center;
    }

    .notice-icon {
        font-size: 48px;
        margin-bottom: 20px;
    }

    .notice-title {
        font-size: 40px;
        font-weight: bold;
        color: #222;
        margin-bottom: 20px;
    }

    .notice-main {
        font-size: 24px;
        font-weight: bold;
        color: #333;
        margin-bottom: 12px;
    }

    .notice-sub {
        font-size: 18px;
        color: #666;
        margin-bottom: 40px;
    }

    .back-btn {
        display: inline-block;
        padding: 16px 36px;
        font-size: 20px;
        font-weight: bold;
        border: none;
        border-radius: 12px;
        background-color: #a2ccfe;
        color: #333;
        cursor: pointer;
    }

    .back-btn:hover {
        background-color: #8dbdf7;
    }
</style>
</head>
<body>

    <div class="notice-container">
        <div class="notice-icon">🐥</div>
        <div class="notice-title">공지사항</div>
        <div class="notice-main">아직 준비 중이에요!</div>
        <div class="notice-sub">더 좋은 기능으로 곧 찾아올게요 🙌</div>

        <button type="button" class="back-btn" onclick="history.back()">← 돌아가기</button>
    </div>

</body>
</html>