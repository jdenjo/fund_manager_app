// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(document).ready(() => {

    $('.plus-dropdown').click((event) => {

        if (event.currentTarget.innerHTML == "+") {
            $(`.${event.currentTarget.id}`).show();
            event.currentTarget.innerHTML = "-"
        } else {
            $(`.${event.currentTarget.id}`).hide();
            event.currentTarget.innerHTML = "+"
        }

    });


});