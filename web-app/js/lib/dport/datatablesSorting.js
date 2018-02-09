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

    jQuery.fn.dataTableExt.oSort['checkBoxGait-asc'] = function (a, b) {
        var x = $(a);
        var y = $(b);
        var xCmp = true;
        var yCmp = true;
        if (x) {
            xCmp = $('#'+x.attr('id')).prop('checked');
        }
        if (y) {
            yCmp = $('#'+y.attr('id')).prop('checked');
        }
        if (xCmp===yCmp) { return 0 }
        else if ((!xCmp)&&yCmp) {return 1}
        else if (xCmp&&(!yCmp)) {return -1};
    };

    jQuery.fn.dataTableExt.oSort['checkBoxGait-desc'] = function (a, b) {
        var x = $(a);
        var y = $(b);
        var xCmp = true;
        var yCmp = true;
        if (x) {
            xCmp = $('#'+x.attr('id')).prop('checked');
        }
        if (y) {
            yCmp = $('#'+y.attr('id')).prop('checked');
        }
        if (xCmp===yCmp) { return 0 }
        else if (xCmp&&(!yCmp)) {return 1}
        else if ((!xCmp)&&yCmp) {return -1};
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
            if (a==="") {
                return -100;
            } else {
                return parseFloat(a);
            }
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

    jQuery.extend( jQuery.fn.dataTableExt.oSort, {
        // sort by chromosome and start position
        "positionIndicator-pre": function ( a ) {
            if (a==='')  {return 0;}
            var split1 = a.split(':');
            if (split1.length!==2)  {return 0;}
            var split2 = split1[1].split('-');
            if (split2.length!==2)  {return 0;}
            var startPos = 0;
            var chromosomeMatch = 0;
            if ( /^\d+$/.test(split2[0])){
                startPos = parseInt(split2[0]);
            }
            if ( /^\d+$/.test(split1[0])){
                chromosomeMatch = parseInt(split1[0]);
            } else if (split1[0]==='X') {
                chromosomeMatch = 23;
            } else if (split1[0]==='Y') {
                chromosomeMatch = 24;
            }
            return {'start':startPos,'chrom':chromosomeMatch};
            //return startPos;
        },
        "positionIndicator-asc": function ( a, b ) {
            if (a['chrom']!== b['chrom']) {
                return ((a['chrom']< b['chrom']) ? -1 : ((a['chrom'] > b['chrom']) ? 1 : 0));
            } else {
                return ((a['start'] < b['start']) ? -1 : ((a['start'] > b['start']) ? 1 : 0));
            }
        },

        "positionIndicator-desc": function ( a, b ) {
            if (a['chrom']!== b['chrom']) {
                return ((a['chrom']< b['chrom']) ? 1 : ((a['chrom'] > b['chrom']) ? -1 : 0));
            } else {
                return ((a['start'] < b['start']) ? 1 : ((a['start'] > b['start']) ? -1 : 0));
            }
        }
    } );


}());