function openModal(id) {
    document.getElementById(id).style.display = "block";
}

function closeModal(id) {
    document.getElementById(id).style.display = "none";
}

function openLectureUpdateModal(lectureNo, deptNo, lectureName, professorName) {
    document.getElementById("updateLectureNo").value = lectureNo;
    document.getElementById("updateDeptNo").value = deptNo;
    document.getElementById("updateLectureName").value = lectureName;
    document.getElementById("updateProfessorName").value = professorName;

    openModal('lectureUpdateModal');
}

document.addEventListener("DOMContentLoaded", function() {
    const overlay = document.getElementById("toast-overlay");

    if (overlay) {
        setTimeout(() => {
            overlay.style.display = "none";
        }, 1500);
    }
});