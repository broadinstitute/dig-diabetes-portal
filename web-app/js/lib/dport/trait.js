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
                                                       traitUrl,
                                                       locale,
                                                       copyText,
                                                       printText)  {
            var variant =  data['traitInfo'];
//            $(traitsPerVariantTableBody).append(variantProcessing.fillTraitsPerVariantTable(variant,
//                showGene,
//                showExomeSequence,
//                showExomeChip,
//                traitUrl));

            $('[data-toggle="tooltip"]').tooltip({container: 'body'});
            var languageSetting = {}
            // check if the browser is using Spanish
            if ( locale.startsWith("es")  ) {
                languageSetting = { url : '../../js/lib/i18n/table.es.json' }
            }

            var table = $(traitsPerVariantTable).dataTable({
                iDisplayLength: 250,
                bFilter: false,
                bPaginate: false,
                aaSorting: [[ 0, "asc" ]],
                sDom: '<"top">rt<"bottom"flp><"clear">',
                aoColumnDefs: [ { sType: "allnumeric", aTargets: [ 2, 4, 5, 6 ] },
                    { sType: "stringAnchor", aTargets: [ 1 ] },
                    {sType: "headerAnchor", aTargets: [0] },
                    { "orderData": [ 0, 1 ],    "targets": 0 },
//                    { "sClass": "pull-me-left", "aTargets": [ 0 ] },
                    { "width": "80px", "aTargets": [ 4,5,6 ] },
                    { "width": "90px", "aTargets": [ 3 ] },
                    { "width": "100px", "aTargets": [ 2 ] }],
                createdRow: function ( row, data, index ) {
//                    if ( data[5].replace(/[\$,]/g, '') * 1 > 150000 ) {
//                       // $('td', row).eq(5).addClass('highlight');
//                    }
                    var rowPtr = $(row);
                    if ($(data[0]).hasClass('indexRow')){
                        var convertedSampleGroup = $(data[0]).attr('convertedSampleGroup');
                        var rowsPerPhenotype = parseInt($(data[0]).attr('rowsPerPhenotype'));
                        rowPtr.attr('id',$(data[0]).attr('phenotypename'));
                        rowPtr.attr('class','clickable');
                        rowPtr.attr('data-toggle','collapse');
                        rowPtr.attr('data-target',"."+$(data[0]).attr('phenotypename')+"collapsed");
                        rowPtr.attr('id',$(data[0]).attr('phenotypename'));
                        if ((rowsPerPhenotype>1)&&(convertedSampleGroup.indexOf(':')===-1))
                        $(rowPtr.children()[1]).append("<div class='glyphicon glyphicon-plus-sign pull-right' aria-hidden='true' data-toggle='tooltip' "+
                            "data-placement='right' title='Click to toggle additional associations for "+convertedSampleGroup+" across other data sets'></div>");
                    } else {
                        rowPtr.attr('class',"collapse out budgets "+$(data[0]).attr('phenotypename')+"collapsed");
                    }
                },
                language: languageSetting
            });
            var tableTools = new $.fn.dataTable.TableTools( table, {
                "aButtons": [
                    { "sExtends": "copy", "sButtonText": copyText },
                    "csv",
                    "xls",
                    "pdf",
                    { "sExtends": "print", "sButtonText": printText }
                ],
                "sSwfPath": "../../js/DataTables-1.10.7/extensions/TableTools/swf/copy_csv_xls_pdf.swf"
            } );
            variantProcessing.addTraitsPerVariantTable(variant,
                traitsPerVariantTable,
                traitUrl,0);
           // $( tableTools.fnContainer() ).insertAfter(traitsPerVariantTable);
        };


        var addMoreTraitsPerVariantFields = function  (data,
                                                       traitsPerVariantTableBody,
                                                       traitsPerVariantTable,
                                                       showGene,
                                                       showExomeSequence,
                                                       showExomeChip,
                                                       traitUrl,
                                                       locale,
                                                       copyText,
                                                       printText,
                                                       existingRows)  {
            var variant =  data['traitInfo'];
            var languageSetting = {};
            // check if the browser is using Spanish
            variantProcessing.addTraitsPerVariantTable(variant,
                traitsPerVariantTable,
                traitUrl,
                existingRows);
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
            addMoreTraitsPerVariantFields:addMoreTraitsPerVariantFields,
            getDbSnpId: getDbSnpId
        }


    }());

})();

