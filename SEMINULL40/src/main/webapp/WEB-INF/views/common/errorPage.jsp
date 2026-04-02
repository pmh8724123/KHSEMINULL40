<%-- 	<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="Errorcontainer">
	
		<jsp:include page="/WEB-INF/views/common/header.jsp" />
		
		
		
		<jsp:include page="/WEB-INF/views/common/footer.jsp" />
	
	</div>
</body>
</html> --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>에러 발생 🐦</title>

    <style>
        body {
            margin: 0;
            font-family: 'Pretendard', sans-serif;
            background: linear-gradient(135deg, #74b9ff, #a29bfe);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .error-container {
            background: white;
            padding: 50px;
            border-radius: 20px;
            text-align: center;
            width: 400px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }

        .error-code {
            font-size: 80px;
            font-weight: bold;
            color: #6c5ce7;
        }

        .error-title {
            font-size: 24px;
            margin: 10px 0;
        }

        .error-message {
            color: #555;
            margin-bottom: 30px;
        }

        .btn {
            display: inline-block;
            padding: 12px 20px;
            margin: 5px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
            transition: 0.2s;
        }

        .home-btn {
            background: #6c5ce7;
            color: white;
        }

        .back-btn {
            background: #dfe6e9;
            color: #2d3436;
        }

        .btn:hover {
            transform: translateY(-2px);
            opacity: 0.9;
        }

        .bird {
            font-size: 50px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

<div class="error-container">
    <div class="bird">🐦</div>

    <!-- 상태 코드 -->
    <div class="error-code">
        ${statusCode}
    </div>

    <!-- 제목 -->
    <div class="error-title">
        캠둘기가 길을 잃었어요...
    </div>

    <!-- 메시지 -->
    <div class="error-message">
        요청하신 페이지를 찾을 수 없거나<br>
        서버에서 문제가 발생했어요 😢
    </div>

    <!-- 버튼 -->
    <a href="/" class="btn home-btn">홈으로 가기</a>
    <a href="javascript:history.back()" class="btn back-btn">뒤로 가기</a>
</div>

</body>
</html>