// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(document).ready(() => {

    $(".stock-details").hide();

    if (document.querySelector('#new-trade')) {
        document.querySelector('#new-trade').addEventListener('submit', (event) => {
            event.preventDefault();
            console.log("got here");
            console.log($("#ticker").value);

            fetch(`/stocks/new?ticker=${$("#ticker").val()}`)
                .then(res => res.json()).then(body => {
                    if (body.error) {
                        $("#search-message").html("Stock does not exist");
                        $(".stock-details").hide();
                        $("#company").val("");
                        $("#exchange").val("");
                        $("#price").val("");
                        $("#mcap").val("");
                        $("#vol").val("");
                        $("#transaction_price").val("");
                        $("#transaction_sector").val("");

                    } else {
                        $(".stock-details").show();
                        $("#search-message").html("");
                        $("#transaction_ticker").val(body.symbol);
                        $("#company").val(body.companyName);
                        $("#exchange").val(body.primaryExchange);
                        $("#price").val(toCurrency(body.latestPrice));
                        $("#mcap").val(toCurrency(body.marketCap));
                        $("#vol").val(numberWithCommas(body.latestVolume));
                        $("#transaction_price").val(body.latestPrice);
                        $("#transaction_sector").val(body.sector);
                    }
                }).catch(error => {
                    console.log(error)
                })

        });
    }

    if (document.querySelector('#transaction_priceType_limit')) {
        document.querySelector('#transaction_priceType_limit').addEventListener('click', (event) => {
            $("#transaction_price").removeAttr('readonly');
        })
    }

    if (document.querySelector('#transaction_priceType_market')) {
        document.querySelector('#transaction_priceType_market').addEventListener('click', (event) => {
            $("#transaction_price").attr('readonly','readonly');
        })
    }

});

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}


function toCurrency(x) {
    return "$ " + x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}