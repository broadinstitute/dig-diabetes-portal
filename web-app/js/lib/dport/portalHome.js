$(function () {
    "use strict";

    /***
     * type ahead recognizing genes
     */
    $('#generalized-input').typeahead({
        source: function (query, process) {
            $.get('<g:createLink controller="gene" action="index"/>', {query: query}, function (data) {
                process(data);
            })
        }
    });

    /***
     * respond to end-of-search-line button
     */
    $('#generalized-go').on('click', function () {
        var somethingSymbol = $('#generalized-input').val();
        if (somethingSymbol) {
            window.location.href = "${createLink(controller:'gene',action:'findTheRightDataPage')}/" + somethingSymbol;
        }
    });

    /***
     * capture enter key, make it equivalent to clicking on end-of-search-line button
     */
    $("input").keypress(function (e) { // capture enter keypress
        var k = e.keyCode || e.which;
        if (k == 13) {
            $('#generalized-go').click();
        }
    });

    /***
     *  Launch find variants associated with other traits
     */
    $('#trait-input').on('change', function () {
        var trait_val = $('#trait-input option:selected').val();
        var significance = 5e-8;
        if (trait_val == "" || significance == 0) {
            alert('Please choose a trait and enter a valid significance!')
        } else {
            window.location.href = "${createLink(controller:'trait',action:'traitSearch')}" + "?trait=" + trait_val + "&significance=" + significance;
        }
    });


});

