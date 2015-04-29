// Some DOM assignments that we can encapsulate inside an immediate execution function.
(function () {

    jQuery.fn.dataTableExt.oSort['allnumeric-asc'] = function (a, b) {
        var x = parseFloat(a);
        var y = parseFloat(b);
        if (!x) {
            x = 1;
        }
        if (!y) {
            y = 1;
        }
        return ((x < y) ? -1 : ((x > y) ? 1 : 0));
    };

    jQuery.fn.dataTableExt.oSort['allnumeric-desc'] = function (a, b) {
        var x = parseFloat(a);
        var y = parseFloat(b);
        if (!x) {
            x = 1;
        }
        if (!y) {
            y = 1;
        }
        return ((x < y) ? 1 : ((x > y) ? -1 : 0));
    };

}());
var variantProcessing = (function () {


    /***
     * private functions
     */

    /***
     * Find the population with the highest frequency.
     *
     * @param variant
     * @returns {{highestFrequency: number, populationWithHighestFrequency: number, noData: boolean}}
     */
    var determineHighestFrequencyEthnicity = function (variant) {
        var highestValue = 0;
        var winningEthnicity = 0;
        var ethnicAbbreviation = ['AA', 'EA', 'SA', 'EU', 'HS'];
        var noData=true;
        for (var i = 0; i < ethnicAbbreviation.length; i++) {
            var stringValue = variant['_13k_T2D_' + ethnicAbbreviation[i] + '_MAF'];
            if (stringValue!==null){
                var realValue = parseFloat(stringValue);
                if (i==0){
                    highestValue = realValue;
                    winningEthnicity =  ethnicAbbreviation[i];
                } else {
                    noData=false;
                    if (realValue > highestValue) {
                        highestValue = realValue;
                        winningEthnicity =  ethnicAbbreviation[i];
                    }
                }
            }
        }
        if (noData === true){
            populationWithHighestFrequency = '--';
        }
        return  {highestFrequency:highestValue,
            populationWithHighestFrequency:winningEthnicity,
            noData:noData};
    };


    /***
     *
     * @param fullJson
     * @param show_gene
     * @param show_sigma
     * @param show_exseq
     * @param show_exchp
     * @param variantRootUrl
     * @param geneRootUrl
     * @param dataSetDetermination  tells us which data set we are using. Here is the mapping:
     * 0-> GWAS
     * 1-> Sigma
     * 2-> exome sequencing
     * 3-> exome chip
     * @returns {string}
     */
    var fillCollectedVariantsTable =  function ( fullJson,
                                            show_gene,
                                            show_sigma,
                                            show_exseq,
                                            show_exchp,
                                            variantRootUrl,
                                            geneRootUrl,
                                            dataSetDetermination) {
        var retVal = "";
        var vRec = fullJson.variants;
        if (!vRec)  {   // error condition
            return;
        }
        for ( var i=0 ; i<vRec.length ; i++ )    {
            retVal += "<tr>"

            // nearest gene
            if (show_gene) {
                retVal += "<td><a  href='"+geneRootUrl+"/"+vRec[i].CLOSEST_GENE+"' class='boldItlink'>"+vRec[i].CLOSEST_GENE+"</td>";
            }

            // variant
            if (vRec[i].ID) {
                retVal += "<td><a href='"+variantRootUrl+"/"+vRec[i].ID+"' class='boldlink'>"+vRec[i].CHROM+ ":" +vRec[i].POS+"</td>";
            } else {
                retVal += "<td></td>"
            }
            // rsid (DB SNP)
            if (vRec[i].DBSNP_ID) {
                retVal += "<td>"+vRec[i].DBSNP_ID+"</td>" ;
            } else {
                retVal += "<td></td>";
            }

            // protein change

            if (vRec[i].Protein_change) {
                retVal += "<td>"+vRec[i].Protein_change+"</td>" ;
            } else {
                retVal += "<td></td>";
            }

            // effect on protein
            if (vRec[i].Consequence) {
                var proteinEffectRepresentation = "";
                if ((typeof proteinEffectList !== "undefined" ) &&
                    (proteinEffectList.proteinEffectMap) &&
                    (proteinEffectList.proteinEffectMap [vRec[i].Consequence])){
                    proteinEffectRepresentation =  proteinEffectList.proteinEffectMap[vRec[i].Consequence];
                } else {
                    proteinEffectRepresentation =  vRec[i].Consequence;
                }
                proteinEffectRepresentation = proteinEffectRepresentation.replace(/[;,]/g,'<br/>');
                retVal += "<td>"+proteinEffectRepresentation+"</td>" ;
            } else {
                retVal += "<td></td>";
            }

            if (show_sigma) {

                // Source
                if (vRec[i].SIGMA_SOURCE)  {
                    retVal += "<td>" +UTILS.prettyUpSigmaSource (vRec[i].SIGMA_SOURCE)+"</td>";
                } else {
                    retVal += "<td></td>";
                }

                // P value
                if (vRec[i].SIGMA_T2D_P)  {
                    retVal += "<td>" +UTILS.realNumberFormatter(vRec[i].SIGMA_T2D_P)+"</td>";
                } else {
                    retVal += "<td></td>";
                }

                // odds ratio
                if (vRec[i].SIGMA_T2D_OR)  {
                    if (vRec[i].SIGMA_T2D_P)  {
                        var pValue = parseFloat (vRec[i].SIGMA_T2D_P);
                        if (($.isNumeric(pValue))&&(pValue>0.05)) {
                            retVal += "<td class='greyedout'>" + UTILS.realNumberFormatter(vRec[i].SIGMA_T2D_OR) + "</td>";
                        } else {
                            retVal += "<td>" +UTILS.realNumberFormatter(vRec[i].SIGMA_T2D_OR)+"</td>";
                        }
                    } else {
                        retVal += "<td>" +UTILS.realNumberFormatter(vRec[i].SIGMA_T2D_OR)+"</td>";
                    }

                } else {
                    retVal += "<td></td>";
                }

                // Case-control
                if ((typeof vRec[i].SIGMA_T2D_MINA!== "undefined") && (typeof vRec[i].SIGMA_T2D_MINU!== "undefined")&&
                    (vRec[i].SIGMA_T2D_MINA!== null) && (vRec[i].SIGMA_T2D_MINU!== null)){
                    retVal += "<td>" +vRec[i].SIGMA_T2D_MINA + "/" +vRec[i].SIGMA_T2D_MINU+"</td>";
                } else {
                    retVal += "<td></td>";
                }

                // frequency
                if (vRec[i].SIGMA_T2D_MAF)  {
                    retVal += "<td>" +UTILS.realNumberFormatter(vRec[i].SIGMA_T2D_MAF)+"</td>";
                } else {
                    retVal += "<td></td>";
                }

            }
            if (show_exseq) {

                var highFreq = determineHighestFrequencyEthnicity(vRec[i]);

                // P value
                // NOTE: we need to use trick here. We are going to present different columns
                //   depending on what data set the user is looking at
                var pValueToPresent = "";
                switch (2){
                    case 0:  pValueToPresent =  vRec[i].GWAS_T2D_PVALUE;
                        break;
                    case 1:  pValueToPresent =  vRec[i].SIGMA_T2D_P;
                        break;
                    case 2:  pValueToPresent =  vRec[i]._13k_T2D_P_EMMAX_FE_IV;
                        break;
                    case 3:  pValueToPresent =  vRec[i].EXCHP_T2D_P_value;
                        break;
                }
                if (pValueToPresent)  {
                    retVal += "<td>" +UTILS.realNumberFormatter(pValueToPresent)+"</td>";
                } else {
                    retVal += "<td></td>";
                }

                // odds ratio
                if (vRec[i]._13k_T2D_OR_WALD_DOS_FE_IV)  {
                    if (vRec[i]._13k_T2D_SE)  {
                        var pValue = parseFloat (vRec[i]._13k_T2D_SE);
                        if (($.isNumeric(pValue))&&(pValue>1)) {
                            retVal += "<td class='greyedout'>" + UTILS.realNumberFormatter(vRec[i]._13k_T2D_OR_WALD_DOS_FE_IV) + "</td>";
                        } else {
                            retVal += "<td>" +UTILS.realNumberFormatter(vRec[i]._13k_T2D_OR_WALD_DOS_FE_IV)+"</td>";
                        }
                    } else {
                        retVal += "<td>" +UTILS.realNumberFormatter(vRec[i]._13k_T2D_OR_WALD_DOS_FE_IV)+"</td>";
                    }
                } else {
                    retVal += "<td></td>";
                }

                // case/control
                // don't rule out zeros here – they're perfectly legal.  Nulls however are bad
                if ((typeof vRec[i]._13k_T2D_MINA!== "undefined") && (typeof vRec[i]._13k_T2D_MINU!== "undefined") &&
                    ( vRec[i]._13k_T2D_MINA!== null) && ( vRec[i]._13k_T2D_MINU!== null)){
                    retVal += "<td>" +vRec[i]._13k_T2D_MINA + "/" +vRec[i]._13k_T2D_MINU+"</td>";
                } else {
                    retVal += "<td></td>";
                }

                // highest frequency
                if (highFreq.highestFrequency)  {
                    retVal += "<td>" +UTILS.realNumberFormatter(highFreq.highestFrequency)+"</td>";
                } else {
                    retVal += "<td></td>";
                }

                // P value
                if ((highFreq.populationWithHighestFrequency)&&
                    (!highFreq.noData)){
                    retVal += "<td>" +highFreq.populationWithHighestFrequency+"</td>";
                } else {
                    retVal += "<td></td>";
                }

            }

            if (show_exchp) {

                var highFreq = determineHighestFrequencyEthnicity(vRec[i]);

                // P value
                if (vRec[i].EXCHP_T2D_P_value)  {
                    retVal += "<td>" +UTILS.realNumberFormatter(vRec[i].EXCHP_T2D_P_value)+"</td>";
                } else {
                    retVal += "<td></td>";
                }

                // odds ratio
                if (vRec[i].EXCHP_T2D_BETA)  {
                    var logExchipOddsRatio  =   parseFloat(vRec[i].EXCHP_T2D_BETA);
                    if ($.isNumeric(logExchipOddsRatio))  {

                        if (vRec[i].EXCHP_T2D_SE)  {
                            var pValue = parseFloat (vRec[i].EXCHP_T2D_SE);
                            if (($.isNumeric(pValue))&&(pValue>1)) {
                                retVal += "<td class='greyedout'>" + UTILS.realNumberFormatter(Math.exp(logExchipOddsRatio)) + "</td>";
                            } else {
                                retVal += "<td>" +UTILS.realNumberFormatter(Math.exp(logExchipOddsRatio))+"</td>";
                            }
                        } else {
                            retVal += "<td>" +UTILS.realNumberFormatter(Math.exp(logExchipOddsRatio))+"</td>";
                        }
                    }  else {
                        retVal += "<td></td>";
                    }
                } else {
                    retVal += "<td></td>";
                }


            }

            // P value TODO:  Referenced above as well. What's going on?
            if (vRec[i].GWAS_T2D_PVALUE)  {
                retVal += "<td>" +UTILS.realNumberFormatter(vRec[i].GWAS_T2D_PVALUE)+"</td>";
            } else {
                retVal += "<td></td>";
            }

            // odds ratio
            if (vRec[i].GWAS_T2D_OR)  {
                retVal += "<td>" +UTILS.realNumberFormatter(vRec[i].GWAS_T2D_OR)+"</td>";
            } else {
                retVal += "<td></td>";
            }

            retVal += "</tr>"
        }
        return retVal;
    },

//    lineInVariantsTable =  function ( line,
//                                                 show_gene,
//                                                 show_sigma,
//                                                 show_exseq,
//                                                 show_exchp,
//                                                 variantRootUrl,
//                                                 geneRootUrl,
//                                                 dataSetDetermination) {
//        var retVal = "";
//        if ((typeof line === 'undefined') ||
//            (!line))  {
//            return;
//        }
//
//            retVal += "<tr>"
//
//            // nearest gene
//            if (show_gene) {
//                retVal += "<td><a  href='"+geneRootUrl+"/"+line.CLOSEST_GENE+"' class='boldItlink'>"+line.CLOSEST_GENE+"</td>";
//            }
//
//            // variant
//            if (line.ID) {
//                retVal += "<td><a href='"+variantRootUrl+"/"+line.ID+"' class='boldlink'>"+line.CHROM+ ":" +line.POS+"</td>";
//            } else {
//                retVal += "<td></td>"
//            }
//            // rsid (DB SNP)
//            if (line.DBSNP_ID) {
//                retVal += "<td>"+line.DBSNP_ID+"</td>" ;
//            } else {
//                retVal += "<td></td>";
//            }
//
//            // protein change
//
//            if (line.Protein_change) {
//                retVal += "<td>"+line.Protein_change+"</td>" ;
//            } else {
//                retVal += "<td></td>";
//            }
//
//            // effect on protein
//            if (line.Consequence) {
//                var proteinEffectRepresentation = "";
//                if ((typeof proteinEffectList !== "undefined" ) &&
//                    (proteinEffectList.proteinEffectMap) &&
//                    (proteinEffectList.proteinEffectMap [line.Consequence])){
//                    proteinEffectRepresentation =  proteinEffectList.proteinEffectMap[line.Consequence];
//                } else {
//                    proteinEffectRepresentation =  line.Consequence;
//                }
//                proteinEffectRepresentation = proteinEffectRepresentation.replace(/[;,]/g,'<br/>');
//                retVal += "<td>"+proteinEffectRepresentation+"</td>" ;
//            } else {
//                retVal += "<td></td>";
//            }
//
//            if (show_sigma) {
//
//                // Source
//                if (line.SIGMA_SOURCE)  {
//                    retVal += "<td>" +UTILS.prettyUpSigmaSource (line.SIGMA_SOURCE)+"</td>";
//                } else {
//                    retVal += "<td></td>";
//                }
//
//                // P value
//                if (line.SIGMA_T2D_P)  {
//                    retVal += "<td>" +UTILS.realNumberFormatter(line.SIGMA_T2D_P)+"</td>";
//                } else {
//                    retVal += "<td></td>";
//                }
//
//                // odds ratio
//                if (line.SIGMA_T2D_OR)  {
//                    if (line.SIGMA_T2D_P)  {
//                        var pValue = parseFloat (line.SIGMA_T2D_P);
//                        if (($.isNumeric(pValue))&&(pValue>0.05)) {
//                            retVal += "<td class='greyedout'>" + UTILS.realNumberFormatter(line.SIGMA_T2D_OR) + "</td>";
//                        } else {
//                            retVal += "<td>" +UTILS.realNumberFormatter(line.SIGMA_T2D_OR)+"</td>";
//                        }
//                    } else {
//                        retVal += "<td>" +UTILS.realNumberFormatter(line.SIGMA_T2D_OR)+"</td>";
//                    }
//
//                } else {
//                    retVal += "<td></td>";
//                }
//
//                // Case-control
//                if ((typeof line.SIGMA_T2D_MINA!== "undefined") && (typeof line.SIGMA_T2D_MINU!== "undefined")&&
//                    (line.SIGMA_T2D_MINA!== null) && (line.SIGMA_T2D_MINU!== null)){
//                    retVal += "<td>" +line.SIGMA_T2D_MINA + "/" +line.SIGMA_T2D_MINU+"</td>";
//                } else {
//                    retVal += "<td></td>";
//                }
//
//                // frequency
//                if (line.SIGMA_T2D_MAF)  {
//                    retVal += "<td>" +UTILS.realNumberFormatter(line.SIGMA_T2D_MAF)+"</td>";
//                } else {
//                    retVal += "<td></td>";
//                }
//
//            }
//            if (show_exseq) {
//
//                var highFreq = determineHighestFrequencyEthnicity(line);
//
//                // P value
//                // NOTE: we need to use trick here. We are going to present different columns
//                //   depending on what data set the user is looking at
//                var pValueToPresent = "";
//                switch (2){
//                    case 0:  pValueToPresent =  line.GWAS_T2D_PVALUE;
//                        break;
//                    case 1:  pValueToPresent =  line.SIGMA_T2D_P;
//                        break;
//                    case 2:  pValueToPresent =  line._13k_T2D_P_EMMAX_FE_IV;
//                        break;
//                    case 3:  pValueToPresent =  line.EXCHP_T2D_P_value;
//                        break;
//                }
//                if (pValueToPresent)  {
//                    retVal += "<td>" +UTILS.realNumberFormatter(pValueToPresent)+"</td>";
//                } else {
//                    retVal += "<td></td>";
//                }
//
//                // odds ratio
//                if (line._13k_T2D_OR_WALD_DOS_FE_IV)  {
//                    if (line._13k_T2D_SE)  {
//                        var pValue = parseFloat (line._13k_T2D_SE);
//                        if (($.isNumeric(pValue))&&(pValue>1)) {
//                            retVal += "<td class='greyedout'>" + UTILS.realNumberFormatter(line._13k_T2D_OR_WALD_DOS_FE_IV) + "</td>";
//                        } else {
//                            retVal += "<td>" +UTILS.realNumberFormatter(line._13k_T2D_OR_WALD_DOS_FE_IV)+"</td>";
//                        }
//                    } else {
//                        retVal += "<td>" +UTILS.realNumberFormatter(line._13k_T2D_OR_WALD_DOS_FE_IV)+"</td>";
//                    }
//                } else {
//                    retVal += "<td></td>";
//                }
//
//                // case/control
//                // don't rule out zeros here – they're perfectly legal.  Nulls however are bad
//                if ((typeof line._13k_T2D_MINA!== "undefined") && (typeof line._13k_T2D_MINU!== "undefined") &&
//                    ( line._13k_T2D_MINA!== null) && ( line._13k_T2D_MINU!== null)){
//                    retVal += "<td>" +line._13k_T2D_MINA + "/" +line._13k_T2D_MINU+"</td>";
//                } else {
//                    retVal += "<td></td>";
//                }
//
//                // highest frequency
//                if (highFreq.highestFrequency)  {
//                    retVal += "<td>" +UTILS.realNumberFormatter(highFreq.highestFrequency)+"</td>";
//                } else {
//                    retVal += "<td></td>";
//                }
//
//                // P value
//                if ((highFreq.populationWithHighestFrequency)&&
//                    (!highFreq.noData)){
//                    retVal += "<td>" +highFreq.populationWithHighestFrequency+"</td>";
//                } else {
//                    retVal += "<td></td>";
//                }
//
//            }
//
//            if (show_exchp) {
//
//                var highFreq = determineHighestFrequencyEthnicity(line);
//
//                // P value
//                if (line.EXCHP_T2D_P_value)  {
//                    retVal += "<td>" +UTILS.realNumberFormatter(line.EXCHP_T2D_P_value)+"</td>";
//                } else {
//                    retVal += "<td></td>";
//                }
//
//                // odds ratio
//                if (line.EXCHP_T2D_BETA)  {
//                    var logExchipOddsRatio  =   parseFloat(line.EXCHP_T2D_BETA);
//                    if ($.isNumeric(logExchipOddsRatio))  {
//
//                        if (line.EXCHP_T2D_SE)  {
//                            var pValue = parseFloat (line.EXCHP_T2D_SE);
//                            if (($.isNumeric(pValue))&&(pValue>1)) {
//                                retVal += "<td class='greyedout'>" + UTILS.realNumberFormatter(Math.exp(logExchipOddsRatio)) + "</td>";
//                            } else {
//                                retVal += "<td>" +UTILS.realNumberFormatter(Math.exp(logExchipOddsRatio))+"</td>";
//                            }
//                        } else {
//                            retVal += "<td>" +UTILS.realNumberFormatter(Math.exp(logExchipOddsRatio))+"</td>";
//                        }
//                    }  else {
//                        retVal += "<td></td>";
//                    }
//                } else {
//                    retVal += "<td></td>";
//                }
//
//
//            }
//
//            // P value TODO:  Referenced above as well. What's going on?
//            if (line.GWAS_T2D_PVALUE)  {
//                retVal += "<td>" +UTILS.realNumberFormatter(line.GWAS_T2D_PVALUE)+"</td>";
//            } else {
//                retVal += "<td></td>";
//            }
//
//            // odds ratio
//            if (line.GWAS_T2D_OR)  {
//                retVal += "<td>" +UTILS.realNumberFormatter(line.GWAS_T2D_OR)+"</td>";
//            } else {
//                retVal += "<td></td>";
//            }
//
//            retVal += "</tr>"
//        }
//        return retVal;
//    },

     fillTheVariantTable = function (data, show_gene, show_sigma, show_exseq, show_exchp, variantRootUrl, geneRootUrl, dataSetDetermination, textStringObject) {
        $('#variantTableBody').append(fillCollectedVariantsTable(data,
            show_gene,
            show_sigma,
            show_exseq,
            show_exchp,
            variantRootUrl,
            geneRootUrl,
            dataSetDetermination, textStringObject));

        if (data.variants) {
            var totalNumberOfResults = data.variants.length;
            $('#numberOfVariantsDisplayed').append('' + totalNumberOfResults);
            if (show_sigma) {
                $('#variantTable').dataTable({
                    iDisplayLength: 20,
                    bFilter: false,
                    aaSorting: [
                        [ 6, "asc" ]
                    ],
                    aoColumnDefs: [
                        { sType: "allnumeric", aTargets: [ 6, 7, 8, 9, 10, 11 ] }
                    ]
                });
            } else {
                $('#variantTable').dataTable({
                    iDisplayLength: 20,
                    bFilter: false,
                    aaSorting: [
                        [ 5, "asc" ]
                    ],
                    aoColumnDefs: [
                        { sType: "allnumeric", aTargets: [ 5, 6, 8, 10, 11, 12, 13 ] }
                    ]
                });
            }
            if (totalNumberOfResults >= 1000) {
                $('#warnIfMoreThan1000Results').html( textStringObject.variantTableContext.tooManyResults );
            }

        }
    },


    fillTraitsPerVariantTable = function ( vRec, show_gene, show_sigma, show_exseq, show_exchp,phenotypeMap,traitRootUrl ) {
        var retVal = "";
        if (!vRec) {   // error condition
            return;
        }

        for (var i = 0; i < vRec.length; i++) {

            var trait = vRec [i] ;
            retVal += "<tr>"

            var convertedTrait=trait.TRAIT;
            if ((phenotypeMap) &&
                (phenotypeMap.phenotypeMap) &&
                (typeof phenotypeMap.phenotypeMap[trait.TRAIT] !== "undefined")) {
                convertedTrait=phenotypeMap.phenotypeMap[trait.TRAIT];
            }
            retVal += "<td><a href='"+traitRootUrl+"?trait="+trait.TRAIT+"&significance=5e-8'>"+convertedTrait+"</a></td>";

            retVal += "<td>" +(trait.PVALUE.toPrecision(3))+"</td>";

            retVal += "<td>";
            if (trait.DIR === "up") {
                retVal += "<span class='assoc-up'>&uarr;</span>";
            } else if (trait.DIR === "down") {
                retVal += "<span class='assoc-down'>&darr;</span>";
            }
            retVal += "</td>";

            retVal += "<td>";
            if (trait.ODDS_RATIO) {
                retVal += (trait.ODDS_RATIO.toPrecision(3));
            }
            retVal += "</td>";


            retVal += "<td>";
            if (trait.MAF) {
                retVal += (trait.MAF.toPrecision(3));
            }
            retVal += "</td>";


            retVal += "<td>";
            if (trait.BETA) {
                retVal += "beta: " + trait.BETA.toPrecision(3);
            } else if (trait.Z_SCORE){
                retVal += "z-score: " + trait.ZSCORE.toPrecision(3);
            }
            retVal += "</td>";


            retVal += "</tr>";
        }
        return retVal;
    }



    return {
        fillTheVariantTable: fillTheVariantTable,
        fillCollectedVariantsTable:fillCollectedVariantsTable,
        fillTraitsPerVariantTable:fillTraitsPerVariantTable
    }
}());
