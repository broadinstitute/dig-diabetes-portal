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
            _.forEach(variant, function(value, key) {
                if (key.indexOf('^')>-1){
                    var splitKey = key.split('^');
                    if (splitKey[2] === 'P_VALUE'){
                        pValue=parseFloat(value);
                    } else if (splitKey[2] === 'BETA'){
                        betaValue=parseFloat(value);
                    } else if (splitKey[2] === 'ODDS_RATIO'){
                        orValue=parseFloat(value);
                    } else if (splitKey[2] === 'MAF'){
                        mafValue=parseFloat(value);
                    }
                }   else if (key === 'P_VALUE')  {
                    pValue=parseFloat(value);
                }
                else if (key === 'ODDS_RATIO')  {
                    orValue=parseFloat(value);
                }
                else if (key === 'MAF')  {
                    mafValue=parseFloat(value);
                }

            });

            var variantIdentifier =  (typeof variant.DBSNP_ID!=='undefined') ? variant.DBSNP_ID :  variant.VAR_ID;
            var variantNameAbbreviation = '';
            if (typeof variantIdentifier!=='undefined'){
                variantNameAbbreviation = (variantIdentifier.length > 14) ?   variantIdentifier.substring(0,13) :   variantIdentifier;
            }
            retVal.push("<a class='boldlink' href='../variantInfo/variantInfo/" + variantIdentifier + "'>" + variantNameAbbreviation + "</a>");
            // we may not have a closest gene; if so, just display an empty string
            var closestGeneLink = variant.CLOSEST_GENE ? "<a class='boldItlink' href='../gene/geneInfo/" + variant.CLOSEST_GENE + "'>" + variant.CLOSEST_GENE + "</a>" : ''
            retVal.push(closestGeneLink);
            if ($.isNumeric(pValue)){
                retVal.push("" + pValue.toPrecision(3));
            }else{
                retVal.push("");
            }
            var betaVal;
            if ($.isNumeric(betaValue)) {
                retVal.push("<span class='" + pValueGreyedOut + "'>" + betaValue.toPrecision(3) + "</span>");
            } else if ($.isNumeric(orValue)) {
                retVal.push("<span class='" + pValueGreyedOut + "'>" + orValue.toPrecision(3) + "</span>");
            } else {
                retVal.push("<span class='" + pValueGreyedOut + "'>--</span>");
            }
            retVal.push(($.isNumeric(mafValue)) ? ("" + mafValue.toPrecision(3)) : "");
            retVal.push("<a class='boldlink' href='./traitInfo/" + variantIdentifier + "'>click here</a>");
            return retVal;
        },

        iterativeTableFiller = function (variant, effectType, locale, copyText, printText) {
            $('#effectTypeHeader').empty();
            $('#effectTypeHeader').append(effectType);
            var languageSetting = {}
            // check if the browser is using Spanish
            if (locale.startsWith("es")) {
                languageSetting = {url: '../js/lib/i18n/table.es.json'}
            }
            var table = $('#phenotypeTraits').dataTable({
                pageLength: 25,
                filter: false,
                order: [[2, "asc"]],
                columnDefs: [{type: "scientific", targets: [2]}, {type: "allnumeric", targets: [3, 4]}],
                language: languageSetting,
                buttons: [
                    { extend: 'copy', text: copyText },
                    'csv',
                    'pdf',
                    { extend: 'print', text: printText }
                ]
            });
            var dataLength = variant.length;
            var effectsField = UTILS.determineEffectsTypeString('#phenotypeTraits');
            for (var i = 0; i < dataLength; i++) {
                var array = convertLineForPhenotypicTraitTable(variant[i], effectsField);
                $('#phenotypeTraits').dataTable().fnAddData(array, (i == 25) || (i == (dataLength - 1)));
            }
        };


        return {
            // public routines
            iterativeTableFiller: iterativeTableFiller
        }


    }());

})();