<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>강의 평가 작성</title>
<style>
	:root{
		--primary-blue : #a2cfff;
		--btn-blue : #32a2ff;
		--bg-color : #f2f7ff;
		--card-border : #333;
	}

	body{
		background-color : var(--bg-color);
		font-family: 'Pretendard', -apple-system, sans-serif;
		margin : 0;
		display : flex;
		justify-content : center;
		align-items : center;
		height : 100vh;	
	}
	
	.evaluation-card{
		background : white;
		border : 1px solid var(--card-border);
		border-radius : 25px;
		width : 750px;
		height : 400px;
		padding : 40px;
		position : relative;
		box-shadow : 0 10px 30px rgba(0,0,0,0.05);
		box-sizing : border-box;
	}
	
	.lecture-info-header { 
		background-color : var(--primary-blue);
		border-raduis : 15px;
		padding : 20px 30px;
		display : inline-block;
		min-width : 350px;
	}
	
	.lecture-info-header div{
		font-size : 18px;
		font-weight : bold;
		color : #333;
		margin : 4px 0;
	}
	
	.star-container {
		position : absolute;
		top : 60px;
		right : 40px;
		background : #efefef;
		padding : 10px 20px;
		border-radius : 20px;
	}
	
	.star-rating{
		display : flex;
		flex-direction : row-reverser;
		font-size : 24px;
	}
	
	.star-rating label{
		color : #ccc;
		cursor : pointer;
		padding : 0 2px;
		transition : 0.2s;
	}
	
	.star-rating input : checked ~ label,
	.star-rating label : hover,
	.star-rating label : hover ~ label{
		color : #4a90e2;
	}
	
	.bottom-area{
		margin-top : 100px;
		display : flex;
		justify-content : space-between;
		align-items : flex-end;
	}
	
	.selection-row {
		display : flex;
		gap : 20px;
	}
	
	.bottom-area{
		margin-top : 100px;
		display : flex;
		justify-content : space-between;
		align-items : flex-end;
	}
	
	.selection-row{
		display : flex;
		gap : 20px;
	}
	
    /* 드롭다운(셀렉트박스) 스타일 */
    .custom-select {
        border: 1px solid var(--card-border);
        border-radius: 15px;
        padding: 12px 20px;
        font-size: 16px;
        font-weight: bold;
        background: white;
        cursor: pointer;
        outline: none;
        min-width: 130px;
        appearance: none; /* 기본 화살표 제거 */
        background-image: url('data:image/svg+xml;charset=US-ASCII,<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="black" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9l6 6 6-6"/></svg>');
        background-repeat: no-repeat;
        background-position: right 10px center;
    }

    /* 평가 버튼 (오른쪽 하단) */
    .submit-btn {
        background-color: var(--btn-blue);
        color: black;
        border: 1px solid var(--card-border);
        border-radius: 15px;
        padding: 12px 50px;
        font-size: 18px;
        font-weight: bold;
        cursor: pointer;
        transition: 0.2s;
    }

    .submit-btn:hover {
        opacity: 0.8;
    }
</style>
</head>
<body>
	
	<div class="evaluation-card">
		<form action="insert" method="post">
			<!-- 강의 번호 숨겨서 전달 -->
			<input type="hidden" name="lectureNo" value="${lecture.lectureNo}">
			
			<!-- 강의 정보 박스 -->
			<div class="lecture-info-header">
				<div>${lecture.uniName}</div>
				<div>${lecture.lectureName} - ${lecture.professorName} 교수님</div>
			</div>
			
			<!-- 별점 선택 영역 -->
      		<div class="star-container">
                <div class="star-rating">
                    <input type="radio" id="star5" name="totalScore" value="5"><label for="star5">★</label>
                    <input type="radio" id="star4" name="totalScore" value="4"><label for="star4">★</label>
                    <input type="radio" id="star3" name="totalScore" value="3" checked><label for="star3">★</label>
                    <input type="radio" id="star2" name="totalScore" value="2"><label for="star2">★</label>
                    <input type="radio" id="star1" name="totalScore" value="1"><label for="star1">★</label>
                </div>
            </div>
			
			<div class="bottom-area">
				<div class="selection-row">
					<!-- 과제 양 선택 -->
					<select name="homework" class="custom-select" required>
						<option value="" disabled selected>과제 양 ↓</option>
						<option value="1">많음</option>
						<option value="2">보통</option>
						<option value="3">적음</option>
						<option value="4">없음</option>
					</select>
					
					<!-- 성적 스타일 선택 -->
					<select name="grade" class="custom-select" required>
						<option value="" disabled selected>성적 ↓</option>
						<option value="1">너그러움</option>
						<option value="2">보통</option>
						<option value="3">깐깐함</option>
					</select>
				</div>
			
			<!-- 평가 완료 버튼 -->
			<button type="submit" class="submit-btn">평가</button>
		  </div>
		</form>
	</div>
	
	
</body>
</html>