var mpgSoftware = mpgSoftware || {};




mpgSoftware.geneSignalSummaryMethods = (function () {
    var loading = $('#rSpinner');


    var buildCommonTable = function(selectionToFill,
                                    variantInfoUrl,
                                      cvar){

        var commonTable  = $(selectionToFill).dataTable({
                "bDestroy": true,
                "className": "compact",
                "bAutoWidth" : false,
                "order": [[ 1, "asc" ]],
                "columnDefs": [
                     { "name": "VAR_ID",   "targets": [0], "type":"allAnchor", "title":"Variant ID",
                        "sWidth": "20%" },
                    { "name": "DBSNP_ID",   "targets": [1], "title":"dbSNP ID",
                        "sWidth": "20%"  },
                    { "name": "PVALUE",   "targets": [2], "title":"p-Value",
                        "sWidth": "15%"  },
                    { "name": "EFFECT",   "targets": [3], "title":"Effect",
                        "sWidth": "15%" },
                    { "name": "DS",   "targets": [4], "title":"Data set",
                        "sWidth": "30%" }
                ],
                "order": [[ 2, "asc" ]],
                "scrollY":        "300px",
                "scrollCollapse": true,
                "paging":         false,
                "bFilter": true,
                "bLengthChange" : true,
                "bInfo":false,
                "bProcessing": true,
                "fnRowCallback": function( nRow, aData, iDisplayIndex ) {
                   nRow.className = $(aData[0]).attr('custag');
                   return nRow;
                 }
            }
        );
 //       $(selectionToFill).DataTable().clear();
        _.forEach(cvar,function(variantRec){
            var arrayOfRows = [];
            var variantID = variantRec.id;
            arrayOfRows.push('<a href="'+variantInfoUrl+'/'+variantID+'" class="boldItlink" custag="'+variantRec.CAT+'">'+variantID+'</a>');
            var DBSNP_ID = (variantRec.rsId)?variantRec.rsId:'';
            arrayOfRows.push(DBSNP_ID);
            arrayOfRows.push(variantRec.P_VALUE);
            arrayOfRows.push(variantRec.BETA);
            arrayOfRows.push(variantRec.dsr);
            $(selectionToFill).dataTable().fnAddData( arrayOfRows );
        });
        //$(selectionToFill +" thead tr th").addClass('niceHeaders');

    };



// public routines are declared below
    return {
        buildCommonTable:buildCommonTable
    }

}());

