jQuery.fn.dataTableExt.oSort['allnumeric-asc']  = function(a,b) {
    var x = parseFloat(a);
    var y = parseFloat(b);
    if (!x) { x = 1; }
    if (!y) { y = 1; }
    return ((x < y) ? -1 : ((x > y) ?  1 : 0));
};

jQuery.fn.dataTableExt.oSort['allnumeric-desc']  = function(a,b) {
    var x = parseFloat(a);
    var y = parseFloat(b);
    if (!x) { x = 1; }
    if (!y) { y = 1; }
    return ((x < y) ? 1 : ((x > y) ?  -1 : 0));
};