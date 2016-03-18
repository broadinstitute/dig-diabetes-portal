var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.phenotype = (function () {

        /***
         * format a single line for the phenotypic trait table
         * @param variant
         * @param effectsField
         * @param show_gene
         * @param show_exseq
         * @param show_exchp
         * @returns {Array}
         */
        var convertLineForPhenotypicTraitTable = function (variant, effectsField) {
                var retVal = [];
                var pValueGreyedOut = (variant.P_VALUE > .05) ? "greyedout" : "normal";
                var pValue='';
                var orValue='';
                var betaValue='';
                var mafValue='';
                for (var key in variant) {
                    if (variant.hasOwnProperty(key)) {
                        if (key.indexOf('^')>-1){
                            var splitKey = key.split('^');
                            if (splitKey[0] === 'P_VALUE'){
                                pValue=parseFloat(variant[key]);
                            } else if (splitKey[0] === 'BETA'){
                                betaValue=parseFloat(variant[key]);
                            } else if (splitKey[0] === 'ODDS_RATIO'){
                                orValue=parseFloat(variant[key]);
                            } else if (splitKey[0] === 'ODDS_RATIO'){
                                mafValue=parseFloat(variant[key]);
                            }
                        }
                    }
                }
                retVal.push("<a class='boldlink' href='../variantInfo/variantInfo/" + variant.DBSNP_ID + "'>" + variant.DBSNP_ID + "</a>");
                retVal.push("<a class='boldItlink' href='../gene/geneInfo/" + variant.CLOSEST_GENE + "'>" + variant.CLOSEST_GENE + "</a>");
                if ($.isNumeric(pValue)){
                    retVal.push("" + pValue.toPrecision(3));
                }else{
                    retVal.push("");
                }
                var betaVal;
                if ($.isNumeric(betaValue)) {
                    retVal.push("<span class='" + pValueGreyedOut + "'>" + betaValue.toPrecision(3) + "</span>");
                } else {
                    retVal.push("<span class='" + pValueGreyedOut + "'>--</span>");
                }
                retVal.push(($.isNumeric(mafValue)) ? ("" + mafValue.toPrecision(3)) : "");
                retVal.push("<a class='boldlink' href='./traitInfo/" + variant.DBSNP_ID + "'>click here</a>");
                return retVal;
            },

            iterativeTableFiller = function (variant, show_gene, show_exseq, show_exchp, locale, copyText, printText) {
                var effectTypeTitle = UTILS.determineEffectsTypeHeader(variant);
                var effectTypeString = UTILS.determineEffectsTypeString(effectTypeTitle);
                $('#effectTypeHeader').append(effectTypeTitle);
                var languageSetting = {}
                // check if the browser is using Spanish
                if (locale.startsWith("es")) {
                    languageSetting = {url: '../js/lib/i18n/table.es.json'}
                }
                var table = $('#phenotypeTraits').dataTable({
                    iDisplayLength: 25,
                    bFilter: false,
                    aaSorting: [[2, "asc"]],
                    aoColumnDefs: [{sType: "allnumeric", aTargets: [2, 3, 4]}],
                    language: languageSetting
                });
                var tableTools = new $.fn.dataTable.TableTools(table, {
                    "aButtons": [
                        {"sExtends": "copy", "sButtonText": copyText},
                        "csv",
                        "xls",
                        "pdf",
                        {"sExtends": "print", "sButtonText": printText}
                    ],
                    "sSwfPath": "../js/DataTables-1.10.7/extensions/TableTools/swf/copy_csv_xls_pdf.swf"
                });
                $(tableTools.fnContainer()).insertAfter('#phenotypeTraits');
                var dataLength = variant.length;
                var effectsField = UTILS.determineEffectsTypeString('#phenotypeTraits');
                for (var i = 0; i < dataLength; i++) {
                    var array = convertLineForPhenotypicTraitTable(variant[i], effectsField, show_gene, show_exseq, show_exchp);
                    $('#phenotypeTraits').dataTable().fnAddData(array, (i == 25) || (i == (dataLength - 1)));
                }
            };


        return {
            // public routines
            iterativeTableFiller: iterativeTableFiller
        }


    }());

})();