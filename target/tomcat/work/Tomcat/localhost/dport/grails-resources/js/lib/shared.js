/*
Contains JS that is shared across pages
 */

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

var get_operator_display = function(operator) {
    if (operator == 'EQ') {
        return 'equal to';
    }
    else if (operator == 'GT') {
        return 'greater than';
    }
    else if (operator == 'GTE') {
        return 'greater than or equal to';
    }
    else if (operator == 'LT') {
        return 'less than';
    }
    if (operator == 'LTE') {
        return 'less than or equal to';
    }
    else {
        return operator;
    }
};
