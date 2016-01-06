var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.geneInfo = (function () {

        var delayedDataPresentation = {},

            /***
             *    geneInfoJsonMap:  Access the interior of the JSON records  symbolically
             */
            geneInfoJsonMap = (function () {
                var geneInfoRec = {
                        ID: 1,
                        CHROM: 2,
                        BEG: 3,
                        END: 4,
                        Function_description: 5,
                        _13k_T2D_VAR_TOTAL: 6,
                        _13k_T2D_ORIGIN_VAR_TOTALS: 7,
                        HS: 8,
                        AA: 9,
                        EU: 10,
                        EA: 11,
                        SA: 12,
                        SING: 13,
                        RARE: 14,
                        LOW_FREQUENCY: 15,
                        COMMON: 16,
                        TOTAL: 17,
                        NS: 18,
                        _17k_T2D_lof_NVAR: 19,
                        _17k_T2D_lof_MINA_MINU_RET: 20,
                        _17k_T2D_lof_P_METABURDEN: 21,
                        _13k_T2D_GWS_TOTAL: 22,
                        _13k_T2D_NOM_TOTAL: 23,
                        EXCHP_T2D_VAR_TOTALS: 24,
                        EXCHP_T2D_GWS_TOTAL: 25,
                        EXCHP_T2D_NOM_TOTAL: 26,
                        GWS_TRAITS: 27,
                        GWAS_T2D_GWS_TOTAL: 28,
                        GWAS_T2D_NOM_TOTAL: 29,
                        GWAS_T2D_VAR_TOTAL: 30,
                        EXCHP_T2D_VAR_TOTALS_EU_TOTAL: 31,
                        SIGMA_T2D_VAR_TOTAL: 32,
                        SIGMA_T2D_GWS_TOTAL: 33,
                        SIGMA_T2D_NOM_TOTAL: 34,
                        _17k_T2D_lof_OBSA: 35,
                        _17k_T2D_lof_OBSU: 36,
                        GWAS_T2D_LWS_TOTAL: 37,
                        EXCHP_T2D_LWS_TOTAL: 38,
                        _13k_T2D_LWS_TOTAL: 39,
                        SIGMA_T2D_lof_OBSA: 40,
                        SIGMA_T2D_lof_OBSU: 41,
                        SIGMA_T2D_lof_NVAR: 42,
                        SIGMA_T2D_lof_MINA: 43,
                        SIGMA_T2D_lof_MINU: 44,
                        SIGMA_T2D_lof_P: 45
                    },
                    revG = function (d) {
                        var v;
                        switch (d) {
                            case 1:
                                v = "ID";
                                break;
                            case 2:
                                v = "CHROM";
                                break;
                            case 3:
                                v = "BEG";
                                break;
                            case 4:
                                v = "END";
                                break;
                            case 5:
                                v = "Function_description";
                                break;
                            case 6:
                                v = "_13k_T2D_VAR_TOTAL";
                                break;
                            case 7:
                                v = "_13k_T2D_ORIGIN_VAR_TOTALS";
                                break;
                            case 8:
                                v = "HS";
                                break;
                            case 9:
                                v = "AA";
                                break;
                            case 10:
                                v = "EU";
                                break;
                            case 11:
                                v = "EA";
                                break;
                            case  12:
                                v = "SA";
                                break;
                            case  13:
                                v = "SING";
                                break;
                            case  14:
                                v = "RARE";
                                break;
                            case  15:
                                v = "LOW_FREQUENCY";
                                break;
                            case  16:
                                v = "COMMON";
                                break;
                            case  17:
                                v = "TOTAL";
                                break;
                            case  18:
                                v = "NS";
                                break;
                            case  19:
                                v = "_17k_T2D_lof_NVAR";
                                break;
                            case  20:
                                v = "_17k_T2D_lof_MINA_MINU_RET";
                                break;
                            case  21:
                                v = "_17k_T2D_lof_P_METABURDEN";
                                break;
                            case  22:
                                v = "_13k_T2D_GWS_TOTAL";
                                break;
                            case  23:
                                v = "_13k_T2D_NOM_TOTAL";
                                break;
                            case  24:
                                v = "EXCHP_T2D_VAR_TOTALS";
                                break;
                            case  25:
                                v = "EXCHP_T2D_GWS_TOTAL";
                                break;
                            case  26:
                                v = "EXCHP_T2D_NOM_TOTAL";
                                break;
                            case  27:
                                v = "GWS_TRAITS";
                                break;
                            case  28:
                                v = "GWAS_T2D_GWS_TOTAL";
                                break;
                            case  29:
                                v = "GWAS_T2D_NOM_TOTAL";
                                break;
                            case  30:
                                v = "GWAS_T2D_VAR_TOTAL";
                                break;
                            case  31:
                                v = "EXCHP_T2D_VAR_TOTALS.EU.TOTAL";
                                break;
                            case  32:
                                v = "SIGMA_T2D_VAR_TOTAL";
                                break;
                            case  33:
                                v = "SIGMA_T2D_GWS_TOTAL";
                                break;
                            case  34:
                                v = "SIGMA_T2D_NOM_TOTAL";
                                break;
                            case  35:
                                v = "_17k_T2D_lof_OBSA";
                                break;
                            case  36:
                                v = "_17k_T2D_lof_OBSU";
                                break;
                            case  37:
                                v = "GWAS_T2D_LWS_TOTAL";
                                break;
                            case  38:
                                v = "EXCHP_T2D_LWS_TOTAL";
                                break;
                            case  40:
                                v = "SIGMA_T2D_lof_OBSA";
                                break;
                            case  41:
                                v = "SIGMA_T2D_lof_OBSU";
                                break;
                            case  42:
                                v = "SIGMA_T2D_lof_NVAR";
                                break;
                            case  43:
                                v = "SIGMA_T2D_lof_MINA";
                                break;
                            case  44:
                                v = "SIGMA_T2D_lof_MINU";
                                break;
                            case  45:
                                v = "SIGMA_T2D_lof_P";
                                break;
                            default:
                                v = "";
                        }
                        return v;
                    },
                    fieldName = function (fieldId) {
                        return revG(fieldId);
                    },
                    fieldSymbol = function () {
                        return  geneInfoRec;
                    };
                return {
                    fieldName: fieldName,
                    fieldSymbol: fieldSymbol
                }
            }()),


            /***
             * Pushback  the region of a search from a gene
             * @param geneExtentBeginning
             * @returns {number}
             */
            expandRegionBegin = function (geneExtentBeginning) {
                if (geneExtentBeginning) {
                    return Math.max(geneExtentBeginning - 500000, 0);
                } else {
                    return 0;
                }
            },


            /***
             *
             * @param geneExtentEnding
             * @returns {*}
             */
            expandRegionEnd = function (geneExtentEnding) {
                if (geneExtentEnding) {
                    return geneExtentEnding + 500000;
                } else {
                    return 0;
                }
            },

            /***
             * Access an expected field iin the JSON.  If the expected result is absent  or undefined
             * then return a numeric zero.
             *
             * @param geneInfo
             * @param filedNumber
             * @param defaultValue
             * @returns {number}
             */
            geneFieldOrZero = function (geneInfo, filedNumber, defaultValue) {
                var retval = 0;
                var fieldName = geneInfoJsonMap.fieldName(filedNumber);
                if ((geneInfo) && (fieldName.length > 0)) {
                    var fieldBreakdown = fieldName.split("."); // step into complex fields
                    retval = geneInfo[fieldBreakdown[0]];
                    if ((retval) && (fieldBreakdown.length > 1)) {
                        for (var i = 1; i < fieldBreakdown.length; i++) {
                            var nextLevelSpec = fieldBreakdown[i];
                            retval = retval[nextLevelSpec];
                        }
                    }
                }
                if (!retval) {    // deal with a null.  Use a zero unless we are given an explicit alternative
                    if (typeof defaultValue !== "undefined") {
                        retval = defaultValue;
                    } else {
                        retval = 0;
                    }
                }
                return retval;
            },

            /***
             *  Fill out some DOM structures conditionally. Used in the  variant and associations table on the gene info page
             * @param rawGeneInfo
             * @param show_gwas
             * @param show_exchp
             * @param show_exseq
             * @param rootRegionUrl
             * @param rootTraitUrl
             * @param rootVariantUrl
             * @param significanceStrings
             */
            fillVarianceAndAssociations = function (rawGeneInfo, show_gwas, show_exchp, show_exseq, rootRegionUrl, rootTraitUrl, rootVariantUrl, significanceStrings) {

                // show traits
                if (show_gwas) {
                    var htmlAccumulator = "";
                    if (rawGeneInfo["GWS_TRAITS"]) {
                        var traitArray = rawGeneInfo["GWS_TRAITS"];
                        if (traitArray.length > 0) {
                            htmlAccumulator += ("<strong> " +
                                "<p>" + significanceStrings.significantAssociations + "</p>" +
                                "<ul>");
                            for (var i = 0; i < traitArray.length; i++) {
                                var traitRepresentation = "";
                                if ((typeof phenotype !== "undefined" ) &&
                                    (phenotype.phenotypeMap) &&
                                    (phenotype.phenotypeMap [traitArray[i]])) {

                                    traitRepresentation = phenotype.phenotypeMap [traitArray[i]];

                                } else {
                                    traitRepresentation = traitArray[i];
                                }
                                if (!(traitRepresentation.indexOf('diabetes') > -1)) {  // special case: don't include diabetes, since it is above in table
                                    htmlAccumulator += ("<li><a href='" + rootTraitUrl + "?trait=" + traitArray[i] + "&significance=5e-8'>" + traitRepresentation + "</a></li>")
                                }
                            }
                            htmlAccumulator += ("</ul>" +
                                "</strong>");
                        }
                    } else {
                        htmlAccumulator += "<p>" + significanceStrings.noSignificantAssociationsExist + "</p>"
                    }
                    $('#gwasTraits').append(htmlAccumulator);
                }
            },

            /***
             * convenience method to build an anchor with all the right fields
             * @param displayableContents
             * @param geneName
             * @param filter
             * @param rootVariantUrl
             * @returns {string}
             */
            buildAnchorForVariantSearches = function (displayableContents, geneName, filter, rootVariantUrl) {
                var returnValue = "";
                returnValue += ("<a class='boldlink' href='" + rootVariantUrl + "/" + geneName + "?filter=" + filter + "'>" +
                    displayableContents + "</a>");
                return  returnValue;
            },

        /***
         *
         * @param rawGeneInfo
         * @param show_gwas
         * @param show_exchp
         * @param show_exseq
         * @param rootVariantUrl
         */
        fillVariationAcrossEthnicity = function (rawGeneInfo, show_gwas, show_exchp, show_exseq, rootVariantUrl,continentalAncestryText
            ) {
            var chooseAncestryStrings = function (ethnicityKey,continentalAncestryText,datatype){
                var returnValue = {ancestry:'unknown',
                                   helpText:'',
                                   datatype:''};
                if (('AA' === ethnicityKey) && ('sequence' === datatype)){
                    returnValue.ancestry = continentalAncestryText.continentalAA;
                    returnValue.helpText = continentalAncestryText.continentalAAQ;
                    returnValue.datatype = continentalAncestryText.continentalAAdatatype;
                } else if (('EA' === ethnicityKey) && ('sequence' === datatype)){
                    returnValue.ancestry = continentalAncestryText.continentalEA;
                    returnValue.helpText = continentalAncestryText.continentalEAQ;
                    returnValue.datatype = continentalAncestryText.continentalEAdatatype;
                } else if (('SA' === ethnicityKey) && ('sequence' === datatype)){
                    returnValue.ancestry = continentalAncestryText.continentalSA;
                    returnValue.helpText = continentalAncestryText.continentalSAQ;
                    returnValue.datatype = continentalAncestryText.continentalSAdatatype;
                } else if (('EU' === ethnicityKey) && ('sequence' === datatype)){
                    returnValue.ancestry = continentalAncestryText.continentalEU;
                    returnValue.helpText = continentalAncestryText.continentalEUQ;
                    returnValue.datatype = continentalAncestryText.continentalEUdatatype;
                } else if (('HS' === ethnicityKey) && ('sequence' === datatype)){
                    returnValue.ancestry = continentalAncestryText.continentalHS;
                    returnValue.helpText = continentalAncestryText.continentalHSQ;
                    returnValue.datatype = continentalAncestryText.continentalHSdatatype;
                } else if  (('EU' === ethnicityKey) && ('chip' === datatype)){
                    returnValue.ancestry = continentalAncestryText.continentalEUchip;
                    returnValue.helpText = continentalAncestryText.continentalEUchipQ;
                    returnValue.datatype = continentalAncestryText.continentalEUchipDatatype;
                };
                return returnValue;
            };
            if (true){
                if ((rawGeneInfo) &&
                    (rawGeneInfo["_13k_T2D_ORIGIN_VAR_TOTALS"])) {
                    var ethnicityMap = rawGeneInfo["_13k_T2D_ORIGIN_VAR_TOTALS"];
                    for (var ethnicityKey in ethnicityMap) {
                        if (ethnicityMap.hasOwnProperty(ethnicityKey)) {
                            var ethnicityRec = ethnicityMap[ethnicityKey];
                            //not using sing right now
                            var sing = (ethnicityRec ["SING"]) ? (ethnicityRec ["SING"]) : 0;
                            var rare = (ethnicityRec ["RARE"]) ? (ethnicityRec ["RARE"]) : 0;
                            var displayableRare = rare;
                            var lowFrequency = (ethnicityRec ["LOW_FREQUENCY"]) ? (ethnicityRec ["LOW_FREQUENCY"]) : 0;
                            var common = (ethnicityRec ["COMMON"]) ? (ethnicityRec ["COMMON"]) : 0;
                            var total = (ethnicityRec ["TOTAL"]) ? (ethnicityRec ["TOTAL"]) : 0;
                            var ns = (ethnicityRec ["NS"]) ? (ethnicityRec ["NS"]) : 0;
                            var ethnicity = chooseAncestryStrings(ethnicityKey,continentalAncestryText,'sequence');
                            $('#continentalVariationTableBody').append('<tr>' +
                                '<td>' + ethnicity.ancestry +
                                ethnicity.helpText + '</td>' +
                                '<td>' + ethnicity.datatype +'</td>' +
                                '<td>' + ns + '</td>' +
                                '<td>' + buildAnchorForVariantSearches(total, rawGeneInfo["ID"], 'total-' + ethnicityKey, rootVariantUrl) + '</td>' +
                                '<td>' + buildAnchorForVariantSearches(common, rawGeneInfo["ID"], 'common-' + ethnicityKey, rootVariantUrl) + '</td>' +
                                '<td>' + buildAnchorForVariantSearches(lowFrequency, rawGeneInfo["ID"], 'lowfreq-' + ethnicityKey, rootVariantUrl) + '</td>' +
                                '<td>' + buildAnchorForVariantSearches(displayableRare, rawGeneInfo["ID"], 'rare-' + ethnicityKey, rootVariantUrl) + '</td>' +
                                '</tr>');
                        }
                    }

                    if (rawGeneInfo["EXCHP_T2D_VAR_TOTALS"]) {
                        var excomeChip = rawGeneInfo["EXCHP_T2D_VAR_TOTALS"];
                        if (excomeChip["EU"]) {
                            var excomeChipEuropean = excomeChip["EU"];
                            var ethnicity = chooseAncestryStrings("EU",continentalAncestryText,'chip');
                            if (excomeChipEuropean["NS"]) {
                                $('#continentalVariationTableBody').append('<tr>' +
                                    '<td>'+ ethnicity.ancestry +
                                    ethnicity.helpText +'</td>' +
                                    '<td>' + ethnicity.datatype +'</td>' +
                                    '<td>' + excomeChipEuropean["NS"] + '</td>' +
                                    '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["TOTAL"], rawGeneInfo["ID"], 'total-exchp', rootVariantUrl) + '</td>' +
                                    '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["COMMON"], rawGeneInfo["ID"], 'common-exchp', rootVariantUrl) + '</td>' +
                                    '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["LOW_FREQUENCY"], rawGeneInfo["ID"], 'lowfreq-exchp', rootVariantUrl) + '</td>' +
                                    '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["RARE"], rawGeneInfo["ID"], 'rare-exchp', rootVariantUrl) + '</td>' +
                                    '</tr>');

                            }
                        }

                    }
                }


            }


            else if (false){
                if (ethnicitySequence) {
                    var ethnicityMap = ethnicitySequence;
                    for (var ethnicityKey in ethnicityMap) {
                        if (ethnicityMap.hasOwnProperty(ethnicityKey)) {
                            var ethnicityRec = ethnicityMap[ethnicityKey];
                            //not using sing right now
                            var sing = (ethnicityRec["sing"]) ? (ethnicityRec ["sing"]) : 0;
                            var rare = (ethnicityRec ["rare"]) ? (ethnicityRec ["rare"]) : 0;
                            var displayableRare = rare;
                            var lowFrequency = (ethnicityRec ["lowFrequency"]) ? (ethnicityRec ["lowFrequency"]) : 0;
                            var common = (ethnicityRec ["common"]) ? (ethnicityRec ["common"]) : 0;
                            var total = (ethnicityRec ["total"]) ? (ethnicityRec ["total"]) : 0;
                            var ns = (ethnicityRec ["ns"]) ? (ethnicityRec ["ns"]) : 0;
                            var ethnicity = chooseAncestryStrings(ethnicityKey, continentalAncestryText, 'sequence');
                            $('#continentalVariationTableBody').append('<tr>' +
                                '<td>' + ethnicity.ancestry +
                                ethnicity.helpText + '</td>' +
                                '<td>' + ethnicity.datatype + '</td>' +
                                '<td>' + ns + '</td>' +
                                '<td>' + buildAnchorForVariantSearches(total, geneId, 'total-' + ethnicityKey, rootVariantUrl) + '</td>' +
                                '<td>' + buildAnchorForVariantSearches(common, geneId, 'common-' + ethnicityKey, rootVariantUrl) + '</td>' +
                                '<td>' + buildAnchorForVariantSearches(lowFrequency, geneId, 'lowfreq-' + ethnicityKey, rootVariantUrl) + '</td>' +
                                '<td>' + buildAnchorForVariantSearches(displayableRare, geneId, 'rare-' + ethnicityKey, rootVariantUrl) + '</td>' +
                                '</tr>');
                        }
                    }

                    if (ethnicityChip ) {
                        var excomeChip = ethnicityChip;
                        if (excomeChip["EU"]) {
                            var excomeChipEuropean = excomeChip["EU"];
                            var ethnicity = chooseAncestryStrings("EU", continentalAncestryText, 'chip');
                            if (excomeChipEuropean["NS"]) {
                                $('#continentalVariationTableBody').append('<tr>' +
                                    '<td>' + ethnicity.ancestry +
                                    ethnicity.helpText + '</td>' +
                                    '<td>' + ethnicity.datatype + '</td>' +
                                    '<td>' + excomeChipEuropean["ns"] + '</td>' +
                                    '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["total"], geneId, 'total-exchp', rootVariantUrl) + '</td>' +
                                    '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["common"], geneId, 'common-exchp', rootVariantUrl) + '</td>' +
                                    '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["lowFrequency"], geneId, 'lowfreq-exchp', rootVariantUrl) + '</td>' +
                                    '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["rare"], geneId, 'rare-exchp', rootVariantUrl) + '</td>' +
                                    '</tr>');

                            }
                        }

                    }

                }

            }
        };






        var fillVariationAcrossEthnicityTable = function ( show_gwas, show_exchp, show_exseq, rootVariantUrl,
                                                           continentalAncestryText,ethnicitySequence,ethnicityChip,geneId) {
            var chooseAncestryStrings = function (ethnicityKey,continentalAncestryText,datatype){
                var returnValue = {ancestry:'unknown',
                    helpText:'',
                    datatype:''};
                if (('AA' === ethnicityKey) && ('sequence' === datatype)){
                    returnValue.ancestry = continentalAncestryText.continentalAA;
                    returnValue.helpText = continentalAncestryText.continentalAAQ;
                    returnValue.datatype = continentalAncestryText.continentalAAdatatype;
                } else if (('EA' === ethnicityKey) && ('sequence' === datatype)){
                    returnValue.ancestry = continentalAncestryText.continentalEA;
                    returnValue.helpText = continentalAncestryText.continentalEAQ;
                    returnValue.datatype = continentalAncestryText.continentalEAdatatype;
                } else if (('SA' === ethnicityKey) && ('sequence' === datatype)){
                    returnValue.ancestry = continentalAncestryText.continentalSA;
                    returnValue.helpText = continentalAncestryText.continentalSAQ;
                    returnValue.datatype = continentalAncestryText.continentalSAdatatype;
                } else if (('EU' === ethnicityKey) && ('sequence' === datatype)){
                    returnValue.ancestry = continentalAncestryText.continentalEU;
                    returnValue.helpText = continentalAncestryText.continentalEUQ;
                    returnValue.datatype = continentalAncestryText.continentalEUdatatype;
                } else if (('HS' === ethnicityKey) && ('sequence' === datatype)){
                    returnValue.ancestry = continentalAncestryText.continentalHS;
                    returnValue.helpText = continentalAncestryText.continentalHSQ;
                    returnValue.datatype = continentalAncestryText.continentalHSdatatype;
                } else if  (('EU' === ethnicityKey) && ('chip' === datatype)){
                    returnValue.ancestry = continentalAncestryText.continentalEUchip;
                    returnValue.helpText = continentalAncestryText.continentalEUchipQ;
                    returnValue.datatype = continentalAncestryText.continentalEUchipDatatype;
                };
                return returnValue;
            };
            var mapAncestryToLowercase = function (ethnicKey){// as a workaround let's flip the case locally to make the anchor we need
                var returnValue = 'hs'; // should never happen, but for now we make this trod upon minority the default
                switch (ethnicKey){
                    case 'AA':returnValue = 'aa'; break;
                    case 'EA':returnValue = 'ea'; break;
                    case 'SA':returnValue = 'sa'; break;
                    case 'EU':returnValue = 'eu'; break;
                    case 'HS':returnValue = 'hs'; break;
                    case 'EU':returnValue = 'eu'; break;
                    default: break;
                }
                return returnValue;
            }
            //  directly executed code begins below this line
            $('#continentalVariationTableBody tr').remove() // start by removing any existing records (since we launched every time the accordion opens)
            if (ethnicitySequence) {
                var ethnicityMap = ethnicitySequence;
                for (var ethnicityKey in ethnicityMap) {
                    if (ethnicityMap.hasOwnProperty(ethnicityKey)) {
                        var ethnicityRec = ethnicityMap[ethnicityKey];
                        //not using sing right now
                        var sing = (ethnicityRec["sing"]) ? (ethnicityRec ["sing"]) : 0;
                        var rare = (ethnicityRec ["rare"]) ? (ethnicityRec ["rare"]) : 0;
                        var displayableRare = rare;
                        var lowFrequency = (ethnicityRec ["lowFrequency"]) ? (ethnicityRec ["lowFrequency"]) : 0;
                        var common = (ethnicityRec ["common"]) ? (ethnicityRec ["common"]) : 0;
                        var total = (ethnicityRec ["total"]) ? (ethnicityRec ["total"]) : 0;
                        var ns = (ethnicityRec ["ns"]) ? (ethnicityRec ["ns"]) : 0;
                        var ethnicity = chooseAncestryStrings(ethnicityKey, continentalAncestryText, 'sequence');
                        $('#continentalVariationTableBody').append('<tr>' +
                            '<td>' + ethnicity.ancestry +
                            ethnicity.helpText + '</td>' +
                            '<td>' + ethnicity.datatype + '</td>' +
                            '<td>' + ns + '</td>' +
                            '<td>' + buildAnchorForVariantSearches(total, geneId, 'total-' + mapAncestryToLowercase (ethnicityKey), rootVariantUrl) + '</td>' +
                            '<td>' + buildAnchorForVariantSearches(common, geneId, 'common-' + mapAncestryToLowercase (ethnicityKey), rootVariantUrl) + '</td>' +
                            '<td>' + buildAnchorForVariantSearches(lowFrequency, geneId, 'lowfreq-' + mapAncestryToLowercase (ethnicityKey), rootVariantUrl) + '</td>' +
                            '<td>' + buildAnchorForVariantSearches(displayableRare, geneId, 'rare-' + mapAncestryToLowercase (ethnicityKey), rootVariantUrl) + '</td>' +
                            '</tr>');
                    }
                }

                if (ethnicityChip ) {
                    var excomeChip = ethnicityChip;
                    if (excomeChip["EU"]) {
                        var excomeChipEuropean = excomeChip["EU"];
                        var ethnicity = chooseAncestryStrings("EU", continentalAncestryText, 'chip');
                        if (excomeChipEuropean["NS"]||excomeChipEuropean["total"]||excomeChipEuropean["common"]||excomeChipEuropean["lowFrequency"]||excomeChipEuropean["rare"]) {
                            $('#continentalVariationTableBody').append('<tr>' +
                                '<td>' + ethnicity.ancestry +
                                ethnicity.helpText + '</td>' +
                                '<td>' + ethnicity.datatype + '</td>' +
                                '<td>' + excomeChipEuropean["ns"] + '</td>' +
                                '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["total"], geneId, 'total-exchp', rootVariantUrl) + '</td>' +
                                '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["common"], geneId, 'common-exchp', rootVariantUrl) + '</td>' +
                                '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["lowFrequency"], geneId, 'lowfreq-exchp', rootVariantUrl) + '</td>' +
                                '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["rare"], geneId, 'rare-exchp', rootVariantUrl) + '</td>' +
                                '</tr>');

                        }
                    }

                }

            }

        };
















        var buildAnchorForRegionVariantSearches = function (displayableContents, geneName, significanceFilter, dataset, regionSpecification, rootVariantUrl, phenotype) {
            var returnValue = "";
            returnValue += ("<a class='boldlink' href='" + rootVariantUrl + "/" + geneName + "?sig=" + significanceFilter +
                "&dataset=" + dataset + "&region=" + regionSpecification + "&phenotype=" + phenotype + "'>" +
                displayableContents + "</a>");
            return  returnValue;
        };
        var buildAnchorForGeneVariantSearches = function (displayableContents, geneName, significanceFilter, dataset, junk, rootVariantUrl, phenotype) {
            var returnValue = "";
            returnValue += ("<a class='boldlink' href='" + rootVariantUrl + "/" + geneName + "?sig=" + significanceFilter +
                "&dataset=" + dataset + "&phenotype=" + phenotype +"'>" +
                displayableContents + "</a>");
            return  returnValue;
        };
        var fillVariantsAndAssociationLine = function (geneName,// our gene record
                                                       dataSetCode,// code for data set -- must be gwas,exomechip,exomeseq,or sigma
                                                       dataSetName,// code for data set -- must be gwas,exomechip,exomeseq,or sigma
                                                       sampleSize, // listed sample size for this data set
                                                       genomicRegion, // region specified as in this example: chr1:209348715-210349783
                                                       valueArray, // data for this row
                                                       columnMap, // since we are doing a whole row we need to know about all columns
                                                       anchorBuildingFunction,  // which anchor building function should we use
                                                       emphasizeGwas,    // 0->no emphasis, 1-> Emphasize middle row, 2-> Emphasize bottom row
                                                       rootVariantUrl, // root URL is the basis for callbacks
                                                       rowHelpText,
                                                       phenotype) { // help text for each row
            if (geneName) {
                var dataSetNameForUser;
                switch (dataSetCode) {
                    case 'GWAS':
                        dataSetNameForUser = rowHelpText.genomeWide+
                            rowHelpText.genomeWideQ;
                        break;
                    case 'ExChip':
                        dataSetNameForUser = rowHelpText.exomeChip+
                            rowHelpText.exomeChipQ;
                        break;
                    case 'ExSeq':
                        dataSetNameForUser =  rowHelpText.exomeSequence+
                            rowHelpText.exomeSequenceQ;
                        break;
                    case 'sigma':
                        dataSetNameForUser =  rowHelpText.sigma+
                            rowHelpText.sigmaQ;
                        break;
                    default:
                        dataSetNameForUser = dataSetName;
                }
                var tableRow = '';
                tableRow += '<tr>' +
                    '<td>' + dataSetNameForUser + '</td>' +
                    '<td>' + sampleSize + '</td>';
                for ( var i = 0 ; i < columnMap.length ; i++ ) {
                    tableRow += '<td>';
                    tableRow += anchorBuildingFunction(valueArray[i], geneName, columnMap[i].value, dataSetCode, genomicRegion, rootVariantUrl, phenotype)
                    tableRow += '</td>';
                }
                tableRow += '</tr>';
                $('#variantsAndAssociationsTableBody').append(tableRow);
            }
        };
        var fillVariantsAndAssociationsTable = function (emphasisRequired,show_gwas, show_exchp, show_exseq, rootVariantUrl, headers,rowHelpText,
                                                         chromosomeNumber,extentBegin,extentEnd,
                                                         rowInformation,columnInformation,
                                                         valueHolder,
                                                         geneName,
                                                         phenotype) {

            var geneInfo;
            var regionSpecifier =  chromosomeNumber + ":" +
                extentBegin + "-" +
                extentEnd;

           // var emphasisRequired = emphasisRecommended(geneInfo);
            var emphasizeGwas = (0);
            var headerRow = "<tr>" +
                "<th>" + headers.hdr1 + "</th>" +
                "<th>" + headers.hdr2 + "</th>";
            for ( var i = 0 ; i < columnInformation.length ; i++ ) {
                var significanceString =  columnInformation[i].value;
                var significance =  parseFloat(significanceString);
                headerRow += "<th>" + columnInformation[i].name;
                if (significance===0.00000005){
                    headerRow += headers.gwasSig;
                } else if (significance===0.00005){
                    headerRow += headers.locusSig;
                } else if (significance===0.05){
                    headerRow += headers.nominalSig;
                } else if ((significance > 0)  && (significance < 1)){
                    headerRow +=  "<br/><span class='headersubtext'>p&nbsp;&lt;&nbsp;"+significance.toPrecision(2)+"</span>";
                }
                headerRow += "</th>";
            }
            headerRow += "</tr>";
            $('#variantsAndAssociationsHead').append(headerRow);
            for ( var row = 0 ; row < rowInformation.length ; row++ ) {
                var rowName = rowInformation[row].name;
                var rowCode = rowInformation[row].value;
                var rowCount = rowInformation[row].count;
                var rowProcessorFunction;
                // we either search by region or by gene name.  We need to decide which reference to build
                if ((typeof rowCode !== 'undefined') &&
                    (rowCode.indexOf('GWAS')>-1)){
                    rowProcessorFunction = buildAnchorForRegionVariantSearches;
                } else {
                    rowProcessorFunction = buildAnchorForGeneVariantSearches;
                }
                fillVariantsAndAssociationLine(geneName, rowCode, rowName, rowCount, regionSpecifier,
                    valueHolder[row],columnInformation,
                    rowProcessorFunction, emphasizeGwas, rootVariantUrl, rowHelpText,phenotype);

            }
        };




        var fillUpBarChart = function (peopleWithDiseaseNumeratorString, peopleWithDiseaseDenominatorString, peopleWithoutDiseaseNumeratorString, peopleWithoutDiseaseDenominatorString, traitString) {
            var peopleWithDiseaseDenominator,
                peopleWithoutDiseaseDenominator,
                peopleWithDiseaseNumerator,
                peopleWithoutDiseaseNumerator,
                calculatedPercentWithDisease,
                calculatedPercentWithoutDisease,
                proportionWithDiseaseDescriptiveString,
                proportionWithoutDiseaseDescriptiveString;
            if ((typeof peopleWithDiseaseDenominatorString !== 'undefined') &&
                (typeof peopleWithoutDiseaseDenominatorString !== 'undefined')) {
                peopleWithDiseaseDenominator = parseInt(peopleWithDiseaseDenominatorString);
                peopleWithoutDiseaseDenominator = parseInt(peopleWithoutDiseaseDenominatorString);
                peopleWithDiseaseNumerator = parseInt(peopleWithDiseaseNumeratorString);
                peopleWithoutDiseaseNumerator = parseInt(peopleWithoutDiseaseNumeratorString);
                if (( peopleWithDiseaseDenominator !== 0 ) &&
                    ( peopleWithoutDiseaseDenominator !== 0 )) {
                    calculatedPercentWithDisease = (100 * (peopleWithDiseaseNumerator / peopleWithDiseaseDenominator));
                    calculatedPercentWithoutDisease = (100 * (peopleWithoutDiseaseNumerator / peopleWithoutDiseaseDenominator));
                    proportionWithDiseaseDescriptiveString = "(" + peopleWithDiseaseNumerator + " out of " + peopleWithDiseaseDenominator + ")";
                    proportionWithoutDiseaseDescriptiveString = "(" + peopleWithoutDiseaseNumerator + " out of " + peopleWithoutDiseaseDenominator + ")";
                    var dataForBarChart = [
                            { value: calculatedPercentWithDisease,
                                barname: 'have ' + traitString,
                                barsubname: '(cases)',
                                barsubnamelink: '',
                                inbar: '',
                                descriptor: proportionWithDiseaseDescriptiveString},
                            {value: calculatedPercentWithoutDisease,
                                barname: 'do not have ' + traitString,
                                barsubname: '(controls)',
                                barsubnamelink: '',
                                inbar: '',
                                descriptor: proportionWithoutDiseaseDescriptiveString}
                        ],
                        roomForLabels = 120,
                        maximumPossibleValue = (Math.max(calculatedPercentWithDisease, Math.min(100, calculatedPercentWithoutDisease) * 1.5)),
                        labelSpacer = 10;

                    var margin = {top: 0, right: 20, bottom: 0, left: 50},
                        width = 800 - margin.left - margin.right,
                        height = 150 - margin.top - margin.bottom;


                    // use trait string as name as well
                    var barChart = baget.barChart(traitString)
                        .width(width)
                        .height(height)
                        .margin(margin)
                        .roomForLabels(roomForLabels)
                        .maximumPossibleValue(maximumPossibleValue)
                        .labelSpacer(labelSpacer)
                        .dataHanger("#chart", dataForBarChart);

                    d3.select("#chart").call(barChart.render);
                    return barChart;
                }

            }

        };
        var fillBiologicalHypothesisTesting = function (geneInfo, show_gwas, show_exchp, show_exseq, rootVariantUrl, fillBiologicalHypothesisTesting) {
            var // raw values
                bhtPeopleWithVariant = 0,
                bhtPeopleWithoutVariant = 0,
                numberOfVariants,
                proportionsWithDisease,
                bhtMetaBurdenForDiabetes,
            // temp values
                arrayOfProportionsWithDisease,
            // useful values
                peopleWithDiseaseDenominator,
                peopleWithDiseaseNumerator,
                peopleWithoutDiseaseDenominator,
                peopleWithoutDiseaseNumerator,
                retainBarchartPtr;

            if (show_exseq) {
                numberOfVariants = geneFieldOrZero(geneInfo, geneInfoJsonMap.fieldSymbol()._17k_T2D_lof_NVAR);
                proportionsWithDisease = geneFieldOrZero(geneInfo, geneInfoJsonMap.fieldSymbol()._17k_T2D_lof_MINA_MINU_RET);
                bhtPeopleWithVariant = geneFieldOrZero(geneInfo, geneInfoJsonMap.fieldSymbol()._17k_T2D_lof_OBSA);
                bhtPeopleWithoutVariant = geneFieldOrZero(geneInfo, geneInfoJsonMap.fieldSymbol()._17k_T2D_lof_OBSU);
                bhtMetaBurdenForDiabetes = geneFieldOrZero(geneInfo, geneInfoJsonMap.fieldSymbol()._17k_T2D_lof_P_METABURDEN);

                // this one value comes back in the form of a very inconvenient string.  Break it down.
                if (proportionsWithDisease) {
                    arrayOfProportionsWithDisease = proportionsWithDisease.split('/');
                    if (arrayOfProportionsWithDisease.length > 1) {
                        peopleWithDiseaseNumerator = arrayOfProportionsWithDisease[0];
                        peopleWithoutDiseaseNumerator = arrayOfProportionsWithDisease[1];
                        peopleWithDiseaseDenominator = bhtPeopleWithVariant*2;
                        peopleWithoutDiseaseDenominator = bhtPeopleWithoutVariant*2;
                    }
                }

            }

            // String describing whether or not we have variants.  If we do then provide a link.
            if (numberOfVariants > 0) {
                $('#possibleCarrierVariantsLink').append("<a class='variantlink' id='linkToVariantsPredictedToTruncate' " +
                        "href='" + rootVariantUrl + "/" + (geneInfo["ID"]) + "?filter=ptv" + "'>" +
                        numberOfVariants + "</a> " + fillBiologicalHypothesisTesting.question1explanation
                );
            } else {
                $('#possibleCarrierVariantsLink').append(fillBiologicalHypothesisTesting.question1insufficient);
            }


            // The bar chart graphic
            if ((peopleWithDiseaseNumerator) ||
                (peopleWithDiseaseDenominator) &&
                (peopleWithoutDiseaseNumerator) &&
                (peopleWithoutDiseaseDenominator)) {
                delayedDataPresentation = {functionToRun: fillUpBarChart,
                    peopleWithDiseaseNumerator: peopleWithDiseaseNumerator,
                    peopleWithDiseaseDenominator: peopleWithDiseaseDenominator,
                    peopleWithoutDiseaseNumerator: peopleWithoutDiseaseNumerator,
                    peopleWithoutDiseaseDenominator: peopleWithoutDiseaseDenominator,
                    barchartPtr: retainBarchartPtr,
                    launch: function () {
                        retainBarchartPtr = fillUpBarChart(peopleWithDiseaseNumerator, peopleWithDiseaseDenominator, peopleWithoutDiseaseNumerator, peopleWithoutDiseaseDenominator, 'T2D');
                        return retainBarchartPtr;
                    },
                    removeBarchart: function () {
                        if ((typeof retainBarchartPtr !== 'undefined') &&
                            (typeof retainBarchartPtr.clear !== 'undefined')) {
                            retainBarchartPtr.clear();
                        }
                        $('#significanceDescriptorFormatter').empty();
                        $('#possibleCarrierVariantsLink').empty();
                    }
                };
            }

            // Colorful square describing significance
            if (bhtMetaBurdenForDiabetes > 0) {
                var degreeOfSignificance = '';
                if (bhtMetaBurdenForDiabetes < 5e-8) {
                    degreeOfSignificance = fillBiologicalHypothesisTesting.question1significant;
                } else if (bhtMetaBurdenForDiabetes < 5e-2) {
                    degreeOfSignificance = fillBiologicalHypothesisTesting.question1nominal;
                }
                ;
                $('#significanceDescriptorFormatter').append("<div class='significantDifference'>" +
                    "<div id='describePValueInBiologicalHypothesis' class='significantDifferenceText'>" +
                    "<p class='slimDescription'>" + degreeOfSignificance + "</p>\n" +
                    "<p  id='bhtMetaBurdenForDiabetes' class='slimDescription'>p=" + (bhtMetaBurdenForDiabetes.toPrecision(3)) +
                    fillBiologicalHypothesisTesting.question1significantQ+ "</p>" +
                    "</div>" +
                    "</div>");
            }

        };


        var fillUniprotSummary = function (geneInfo) {
            var funcDescrLine = "";
            if ((geneInfo) && (geneInfo["Function_description"])) {
                funcDescrLine += ("<strong>Uniprot Summary:</strong> " + geneInfo['Function_description']);
            } else {
                funcDescrLine += "No uniprot summary available for this gene"
            }

            $('#uniprotSummaryGoesHere').append(funcDescrLine);
        };
        var retrieveDelayedBiologicalHypothesisOneDataPresenter = function () {
            return delayedDataPresentation;
        };

        var retrieveGeneInfoRec = function () {
            return geneInfoJsonMap.fieldSymbol();
        };

        var fillTheGeneFields = function ( data, show_gwas, show_exchp, show_exseq,
                                          rootRegionUrl, rootTraitUrl, rootVariantUrl, textStringObject) {
            var rawGeneInfo = data['geneInfo'];
            fillUniprotSummary(rawGeneInfo);
//            fillBiologicalHypothesisTesting(rawGeneInfo, show_gwas, show_exchp, show_exseq,
//                rootVariantUrl,
//                textStringObject.biologicalHypothesisTesting);
        };


            var fillTheVariantAndAssociationsTableFromNewApi = function (data, show_gwas, show_exchp, show_exseq,
                                                                         rootRegionUrl, rootTraitUrl, rootVariantUrl,
                                                                         textStringObject,
                                                                         chromosomeNumber,extentBegin,extentEnd,
                                                                         rowInformation,columnInformation,
                                                                         valueHolder,
                                                                         geneName,
                                                                         phenotype) {
                fillVariantsAndAssociationsTable(false, show_gwas, show_exchp, show_exseq,
                    rootVariantUrl,
                    textStringObject.variantsAndAssociationsTableHeaders,
                    textStringObject.variantsAndAssociationsRowHelpText,
                    chromosomeNumber,
                    extentBegin,
                    extentEnd,
                    rowInformation,columnInformation,
                    valueHolder,
                    geneName,
                    phenotype
                );
            }






        return {
            // private routines MADE PUBLIC FOR UNIT TESTING ONLY (find a way to do this in test mode only)
            expandRegionBegin: expandRegionBegin,
            expandRegionEnd: expandRegionEnd,
            geneFieldOrZero: geneFieldOrZero,
            fillVarianceAndAssociations: fillVarianceAndAssociations,
            retrieveGeneInfoRec: retrieveGeneInfoRec,
            buildAnchorForVariantSearches: buildAnchorForVariantSearches,
            fillVariantsAndAssociationLine:fillVariantsAndAssociationLine,


            // public routines
            fillTheGeneFields: fillTheGeneFields,
            fillBiologicalHypothesisTesting: fillBiologicalHypothesisTesting,
            fillVariationAcrossEthnicityTable:fillVariationAcrossEthnicityTable,
            retrieveDelayedBiologicalHypothesisOneDataPresenter: retrieveDelayedBiologicalHypothesisOneDataPresenter,
            fillTheVariantAndAssociationsTableFromNewApi: fillTheVariantAndAssociationsTableFromNewApi,
            fillUpBarChart: fillUpBarChart
        }


    }());

})();
