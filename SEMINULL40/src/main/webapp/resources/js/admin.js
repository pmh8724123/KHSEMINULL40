function openModal(id) {
    document.getElementById(id).style.display = "block";
}

function closeModal(id) {
    document.getElementById(id).style.display = "none";
}

document.addEventListener("DOMContentLoaded", function() {
    const overlay = document.getElementById("toast-overlay");

    if (overlay) {
        setTimeout(() => {
            overlay.style.display = "none";
        }, 1500);
    }
});
