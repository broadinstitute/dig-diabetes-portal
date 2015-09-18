var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.trait = (function () {

        var fillTheTraitsPerVariantFields = function  (data,
                                                       traitsPerVariantTableBody,
                                                       traitsPerVariantTable,
                                                       showGene,
                                                       showExomeSequence,
                                                       showExomeChip,
                                                       traitUrl)  {
            var variant =  data['traitInfo'];
            $(traitsPerVariantTableBody).append(variantProcessing.fillTraitsPerVariantTable(variant,
                showGene,
                showExomeSequence,
                showExomeChip,
                traitUrl));
            var table = $(traitsPerVariantTable).dataTable({
                iDisplayLength: 25,
                bFilter: false,
                aaSorting: [[ 1, "asc" ]],
                aoColumnDefs: [{ sType: "allnumeric", aTargets: [ 1, 3, 4 ] } ]
            });
            var tableTools = new $.fn.dataTable.TableTools( table, {
                "buttons": [
                    "copy",
                    "csv",
                    "xls",
                    "pdf",
                    { "type": "print", "buttonText": "Print" }
                ],
                "sSwfPath": "../../js/DataTables-1.10.7/extensions/TableTools/swf/copy_csv_xls_pdf.swf"
            } );
            $( tableTools.fnContainer() ).insertAfter(traitsPerVariantTable);
            };


        var getDbSnpId = function (data) {
            var dbSnpId;

            if ((typeof data !== 'undefined') &&
                (typeof data.results !== 'undefined')  &&
                (typeof data.results[0] !== 'undefined')  &&
                (typeof data.results[0]["pVals"] !== 'undefined')  &&
                (data.results[0]["pVals"].length > 0) ) {

                // loop through and find the 'DBSNP_ID' level key to get the dbSnpId
                for ( var i = 0 ; i < data.results[0]["pVals"].length ; i++ ) {
                    var key = data.results[0]["pVals"][i].level;
                    if (key === 'DBSNP_ID') {
                        dbSnpId = data.results[0]["pVals"][i].count;
                        // alert('DB SNP is: ' + dbSnpId);
                        break;
                    }
                }
            }

            return dbSnpId;
        };

        return {
            // private routines MADE PUBLIC FOR UNIT TESTING ONLY (find a way to do this in test mode only)
            fillTheTraitsPerVariantFields: fillTheTraitsPerVariantFields,
            getDbSnpId: getDbSnpId
        }


    }());

})();
