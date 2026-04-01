<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<style>
    /* 모달 배경 */
    .modal-overlay {
        display: none; 
        position: fixed; 
        top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0, 0, 0, 0.5); 
        z-index: 9999;
        justify-content: center; align-items: center;
    }

    .evaluation-card {
        background: white; border: 1px solid #333; border-radius: 25px;
        width: 750px; padding: 40px; position: relative;
        box-shadow: 0 10px 30px rgba(0,0,0,0.2); box-sizing: border-box;
        overflow: visible;
    }
    .close-modal { position: absolute; top: 20px; right: 25px; font-size: 35px; cursor: pointer; color: #666; }

    .lecture-info-header { 
        background-color: #a2cfff; border-radius: 15px; padding: 20px 30px; 
        width: 60%; position: relative;
    }
    .uni-name { font-size: 18px; font-weight: bold; margin-bottom: 8px; }
    
    .search-input-wrapper { position: relative; width: 100%; }
    .lecture-search-input { 
        width: 100%; border: none; background: rgba(255,255,255,0.8); 
        padding: 10px 12px; border-radius: 8px; font-size: 16px; outline: none;
        cursor: pointer; box-sizing: border-box;
    }
    
    #search-results {
        position: absolute; 
        top: 105%; left: 0; width: 100%;
        background: white; border: 2px solid #32a2ff; border-radius: 8px;
        z-index: 100000 !important;
        display: none; max-height: 200px; overflow-y: auto;
        box-shadow: 0 8px 16px rgba(0,0,0,0.2);
    }
    .search-item { 
        padding: 12px 15px; cursor: pointer; border-bottom: 1px solid #f0f0f0; 
        font-size: 15px; color: #333; text-align: left; background: white;
    }
    .search-item:hover { background: #eef7ff; color: #32a2ff; }

    .star-container { position: absolute; top: 60px; right: 40px; background: #efefef; padding: 10px 20px; border-radius: 20px; }
    .star-rating { display: flex; flex-direction: row-reverse; font-size: 24px; }
    .star-rating input { display: none; }
    .star-rating label { color: #ccc; cursor: pointer; padding: 0 2px; }
    .star-rating input:checked ~ label, 
    .star-rating label:hover, 
    .star-rating label:hover ~ label { color: #4a90e2; }

    .bottom-area { margin-top: 80px; display: flex; justify-content: space-between; align-items: flex-end; }
    .selection-row { display: flex; gap: 20px; }
    .custom-select { border: 1px solid #333; border-radius: 15px; padding: 12px 20px; font-size: 16px; cursor: pointer; }
    .submit-btn { background-color: #32a2ff; border: 1px solid #333; border-radius: 15px; padding: 12px 50px; font-size: 18px; font-weight: bold; cursor: pointer; color: white; }
</style>

<div id="evalModal" class="modal-overlay">
    <div class="evaluation-card">
        <span class="close-modal">&times;</span>
        <!-- 1. action 경로 확인: 컨트롤러의 @PostMapping("/insert")와 일치해야 함 -->
        <form action="${pageContext.request.contextPath}/rating/insert" method="post" id="evalForm">
            <!-- CSRF 토큰 필수 -->
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <!-- 2. name="lectureNo"가 VO 필드명과 일치해야 함 -->
            <input type="hidden" name="lectureNo" id="selectedLectureNo">
            
            <div class="lecture-info-header">
                <div class="uni-name"><sec:authentication property="principal.member.uniName"/></div>
                <div class="search-input-wrapper">
                    <input type="text" id="lectureSearch" class="lecture-search-input" 
                           placeholder="클릭하여 강의 선택 또는 검색" autocomplete="off">
                    <div id="search-results"></div>
                </div>
            </div>

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
                    <select name="homework" class="custom-select" required>
                        <option value="" disabled selected>과제 양 ↓</option>
                        <option value="1">많음</option><option value="2">보통</option>
                        <option value="3">적음</option><option value="4">없음</option>
                    </select>
                    <select name="grade" class="custom-select" required>
                        <option value="" disabled selected>성적 ↓</option>
                        <option value="1">너그러움</option><option value="2">보통</option><option value="3">깐깐함</option>
                    </select>
                </div>
                <button type="submit" class="submit-btn">평가 등록</button>
            </div>
        </form>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    function openEvalModal(no, name, prof) {
        $('#evalForm')[0].reset();
        $('#search-results').empty().hide();
        
        if(no) {
            // [평가하기] 클릭 시
            $('#selectedLectureNo').val(no);
            $('#lectureSearch').val(name + " - " + prof).prop('readonly', true).css('background', '#f0f0f0');
        } else {
            // [글쓰기] 클릭 시
            $('#selectedLectureNo').val('');
            $('#lectureSearch').val('').prop('readonly', false).css('background', 'white');
        }
        $('#evalModal').css('display', 'flex');
    }

    $(document).ready(function() {
        const userUniNo = '<sec:authentication property="principal.member.uniNo"/>';

        function fetchLectures(keyword = "") {
            if ($('#lectureSearch').prop('readonly')) return;

            $.ajax({
                url: '${pageContext.request.contextPath}/rating/api/search',
                data: { keyword: keyword, uniNo: userUniNo },
                success: function(data) {
                    let html = '';
                    if(data && data.length > 0) {
                        data.forEach(function(l) {
                            const lNo = l.lectureNo || l.LECTURENO;
                            const lName = l.lectureName || l.LECTURENAME;
                            const pName = l.professorName || l.PROFESSORNAME;
                            
                            html += '<div class="search-item" data-no="' + lNo + '" data-name="' + lName + '" data-prof="' + pName + '">'
                                  + lName + ' - ' + pName
                                  + '</div>';
                        });
                        $('#search-results').html(html).show();
                    } else {
                        $('#search-results').html('<div class="search-item" style="cursor:default;">결과가 없습니다.</div>').show();
                    }
                }
            });
        }

        $('#lectureSearch').on('focus input', function() {
            fetchLectures($(this).val().trim());
        });

        $(document).on('mousedown', '.search-item', function() {
            const no = $(this).attr('data-no');
            const name = $(this).attr('data-name');
            const prof = $(this).attr('data-prof');
            
            if(no && no !== "undefined") {
                $('#selectedLectureNo').val(no); 
                $('#lectureSearch').val(name + " - " + prof);
                $('#search-results').hide();
            }
        });

        $('#lectureSearch').on('blur', function() {
            setTimeout(() => { $('#search-results').hide(); }, 200);
        });

        // [중요] 폼 제출 시 최종 확인 스크립트 추가
        $('#evalForm').on('submit', function(e) {
            const lectureNo = $('#selectedLectureNo').val();
            
            console.log("제출 시도 - 강의번호:", lectureNo);
            
            if(!lectureNo || lectureNo === "" || lectureNo === "0") {
                alert("강의를 선택해주셔야 평가가 가능합니다.");
                $('#lectureSearch').focus();
                e.preventDefault(); // 전송 중단
                return false;
            }
            return true; // 전송 진행
        });

        $('.close-modal').on('click', () => $('#evalModal').hide());
        $(window).on('click', (e) => { if($(e.target).hasClass('modal-overlay')) $('#evalModal').hide(); });
    });
</script>