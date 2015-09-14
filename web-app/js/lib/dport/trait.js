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




        return {
            // private routines MADE PUBLIC FOR UNIT TESTING ONLY (find a way to do this in test mode only)
            fillTheTraitsPerVariantFields: fillTheTraitsPerVariantFields
        }


    }());

})();
