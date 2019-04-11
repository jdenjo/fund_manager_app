// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(document).ready(() => {

    document.querySelector('#new-trade').addEventListener('submit', (event) => {
        event.preventDefault();
        console.log("got here");
        console.log($("#ticker").value);

        fetch(`/stocks/new?ticker=${$("#ticker").val()}`)
            .then(res => res.json()).then(body => {
                if (body.error) {
                    $("#search-message").html("Stock does not exist");
                    $("#symbol").html("");
                    $("#name").html("");
                    $("#exchange").html("");
                    $("#price").html("");
                    $("#mcap").html("");
                    $("#vol").html("");
                
                } else {
                    console.log(body);
                    $("#search-message").html("");
                    $("#symbol").html(body.symbol);
                    $("#name").html(body.companyName);
                    $("#exchange").html(body.primaryExchange);
                    $("#price").html(toCurrency(body.latestPrice));
                    $("#mcap").html(toCurrency(body.marketCap));
                    $("#vol").html(numberWithCommas(body.latestVolume));
                    $("#volAmount").html(toCurrency(Math.round(body.latestVolume * body.latestPrice)));
                }
            }).catch(error => {
                console.log(error)
            })

    });

});

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}


function toCurrency(x) {
    return "$ " + x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}