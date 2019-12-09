var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.sharedSortUtility = (function () {

    var SortUtility = function(){

    };
    SortUtility.prototype.simpleIntegerComparison = function(a, b, direction, currentSortObject){
        const defaultSearchField = currentSortObject.desiredSearchTerm;
        var x = parseInt($(a).attr(defaultSearchField));
        var y = parseInt($(b).attr(defaultSearchField));
        return ((x < y) ? -1 : ((x > y) ? 1 : 0));
    };
    SortUtility.prototype.textComparisonWithEmptiesAtBottom = function(a, b, direction, currentSortObject){
        const defaultSearchField = currentSortObject.desiredSearchTerm;
        const textA = $(a).attr(defaultSearchField).toUpperCase();
        const textAEmpty = (textA.length===0);
        const textB = $(b).attr(defaultSearchField).toUpperCase();
        const textBEmpty = (textB.length===0);
        if ( textAEmpty && textBEmpty ) {
            return 0;
        }
        else if ( textAEmpty ) {
            if (direction==='asc') {
                return -1;
            } else {
                return 1;
            }
        }else if ( textBEmpty )
        {
            if (direction==='asc') {
                return 1;
            } else {
                return -1;
            }
        }
        return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
    }
    SortUtility.prototype.textComparisonWithEmptiesAtBottom = function(a, b, direction, currentSortObject){
        const defaultSearchField = currentSortObject.desiredSearchTerm;
        const textA = $(a).attr(defaultSearchField).toUpperCase();
        const textAEmpty = (textA.length===0);
        const textB = $(b).attr(defaultSearchField).toUpperCase();
        const textBEmpty = (textB.length===0);
        if ( textAEmpty && textBEmpty ) {
            return 0;
        }
        else if ( textAEmpty ) {
            if (direction==='asc') {
                return -1;
            } else {
                return 1;
            }
        }else if ( textBEmpty )
        {
            if (direction==='asc') {
                return 1;
            } else {
                return -1;
            }
        }
        return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
    };
    SortUtility.prototype.numericalComparisonWithEmptiesAtBottom = function(a, b, direction, currentSortObject){
        const defaultSearchField = currentSortObject.desiredSearchTerm;
        var x = parseFloat($(a).attr(defaultSearchField));
        if (isNaN(x)){
            x = parseInt($(a).attr('subSortField'));
        }
        var y = parseFloat($(b).attr(defaultSearchField));
        if (isNaN(y)){
            y = parseInt($(b).attr('subSortField'));
        }
        if (isNaN(x) || isNaN(y)){
            return emptyFieldHandler(isNaN(x),isNaN(y), direction);
        }else {
            return ((x < y) ? -1 : ((x > y) ? 1 : 0));
        }
    };
    SortUtility.prototype.notSortable = function(a, b, direction, currentSortObject){
        return 0;
    }


    return {
        SortUtility: SortUtility
    }
}());