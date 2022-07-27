import { Dropzone } from "dropzone";

window.onload = function() {
    $("input[type=submit]").prop("disabled", true);
}
/*window.onload = function() {
    document.getElementById("submit").addEventListener("click", function (event) {
        Dropzone.forElement('#filedrop').removeAllFiles(true);
        $('.dz-preview').empty();
        $('.dz-message').show();
        event.initEvent();
    });
}*/

//const submitButton = document.querySelector("#submit");
//submitButton.disabled = true;
/*
submitButton.click(function () {
    $('.dz-preview').empty();
    $('.dz-message').show();
    Dropzone.forElement('#filedrop').removeAllFiles();
});*/
/*
submitButton.addEventListener("click", function (event) {
    event.preventDefault();
    $('.dz-preview').empty();
    $('.dz-message').show();
    Dropzone.forElement('#filedrop').removeAllFiles();
});*/
/*
let input_form = document.querySelector("#filedrop");
input_form.addEventListener("change", stateHandle);

function stateHandle() {
    //if (input_form.isEmpty()) {
    if (input_form.value === "") {
        submitButton.disabled = true;
    } else {
        submitButton.disabled = false;
    }
}
*/


