// this file contains all the extra sort functions that need to be added
// onto datatables

(function () {
    jQuery.fn.dataTableExt.oSort['allAnchor-asc'] = function (a, b) {
        var x = UTILS.extractAnchorTextAsInteger(a);
        var y = UTILS.extractAnchorTextAsInteger(b);
        if (!x) {
            x = 0;
        }
        if (!y) {
            y = 0;
        }
        return ((x < y) ? -1 : ((x > y) ? 1 : 0));
    };

    jQuery.fn.dataTableExt.oSort['allAnchor-desc'] = function (a, b) {
        var x = UTILS.extractAnchorTextAsInteger(a);
        var y = UTILS.extractAnchorTextAsInteger(b);
        if (!x) {
            x = 0;
        }
        if (!y) {
            y = 0;
        }
        return ((x < y) ? 1 : ((x > y) ? -1 : 0));
    };

    jQuery.fn.dataTableExt.oSort['stringAnchor-asc'] = function (a, b) {
        var x = UTILS.extractAnchorTextAsString(a);
        var y = UTILS.extractAnchorTextAsString(b);
        return (x.localeCompare(y));
    };

    jQuery.fn.dataTableExt.oSort['stringAnchor-desc'] = function (a, b) {
        var x = UTILS.extractAnchorTextAsString(a);
        var y = UTILS.extractAnchorTextAsString(b);
        return (y.localeCompare(x));
    };

    jQuery.fn.dataTableExt.oSort['headerAnchor-asc'] = function (a, b) {
        var str1 = UTILS.extractHeaderTextWJqueryAsString(a);
        var str2 = UTILS.extractHeaderTextWJqueryAsString(b);
        if (!str1) {
            str1 = '';
        }
        if (!str2) {
            str2 = '';
        }
        return str1.localeCompare(str2);
    };

    jQuery.fn.dataTableExt.oSort['headerAnchor-desc'] = function (a, b) {
        var str1 = UTILS.extractHeaderTextWJqueryAsString(b);
        var str2 = UTILS.extractHeaderTextWJqueryAsString(a);
        if (!str1) {
            str1 = '';
        }
        if (!str2) {
            str2 = '';
        }
        return str2.localeCompare(str1);
    };

    jQuery.extend( jQuery.fn.dataTableExt.oSort, {
        "scientific-pre": function ( a ) {
            return parseFloat(a);
        },

        "scientific-asc": function ( a, b ) {
            return ((a < b) ? -1 : ((a > b) ? 1 : 0));
        },

        "scientific-desc": function ( a, b ) {
            return ((a < b) ? 1 : ((a > b) ? -1 : 0));
        }
    } );

    jQuery.fn.dataTableExt.oSort['headerConAnchor-asc']  = function(a,b) {
        var str1 = UTILS.extractConHeaderTextAsString(a);
        var str2 = UTILS.extractConHeaderTextAsString(b);
        if (!str1) { str1 = ''; }
        if (!str2) { str2 = ''; }
        return str1.localeCompare(str2);
    };

    jQuery.fn.dataTableExt.oSort['headerConAnchor-desc']  = function(a,b) {
        var str1 = UTILS.extractConHeaderTextAsString(a);
        var str2 = UTILS.extractConHeaderTextAsString(b);
        if (!str1) { str1 = ''; }
        if (!str2) { str2 = ''; }
        return str2.localeCompare(str1);
    };


}());