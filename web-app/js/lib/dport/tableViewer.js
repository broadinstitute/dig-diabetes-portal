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


        fillTheVariantTable = function (data, show_gene, show_exseq, show_exchp, variantRootUrl, geneRootUrl, dataSetDetermination, textStringObject) {
            $('#variantTableBody').append(fillCollectedVariantsTable(data,
                show_gene,
                show_exseq,
                show_exchp,
                variantRootUrl,
                geneRootUrl,
                dataSetDetermination, textStringObject));

            if (data.variants) {
                var totalNumberOfResults = data.variants.length;
                $('#numberOfVariantsDisplayed').append('' + totalNumberOfResults);
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
                if (totalNumberOfResults >= 1000) {
                    $('#warnIfMoreThan1000Results').html( textStringObject.variantTableContext.tooManyResults );
                }

            }
        },

      deconvoluteVariantInfo = function(vRec){
          var retstat = [];

          if ((typeof vRec !== 'undefined') &&
              (typeof vRec.results !== 'undefined')  &&
              (typeof vRec.results[0] !== 'undefined')  &&
              (typeof vRec.results[0]["pVals"] !== 'undefined')  &&
              (vRec.results[0]["pVals"].length > 0) ){
              var data =  vRec.results[0]["pVals"];
              // first let's go through and process the metadata. For example we can make a data structure  with one
              // row for each phenotype (eventually these will correspond to the rows of the table).  as well, figure out
              //
              var phenotypeShortcut = {}; // shortcut to the right line
              var phenotypeCounter = 0;
              var phenoStruct = [];
              var mafValues = {};
              for ( var i = 0 ; i < data.length ; i++ ){
                  var key = data [i].level;
                  var splitKey = key.split("^");
                  if (splitKey.length>1){
                      // P value handling
                      if (splitKey[0] === 'P_VALUE'){
                          var phenotypeMap = {'phenotype':splitKey[1],'pValue':data [i].count};
                          phenotypeShortcut[splitKey[1]] = phenotypeCounter++;
                          phenoStruct.push(phenotypeMap);
                       }

                      // maf value handling
                      if (splitKey[0] === 'MAF'){
                          var sampleGroup = splitKey[1];
                          var splitSampleGroup = sampleGroup.split("_");
                          if (splitSampleGroup.length>2){
                              mafValues[splitSampleGroup[1]]  = data [i].count;
                          }
                      }

                  }
              }


              var currentPhenotype;
              var phenotypeRow;
              var rowPointer;
              var currentPhenotypeList;
              var splitPhenotypeList;
              var mafGroup;
              var mafValue = 0;

              // ow we go through the list again.  Now we can use the list of phenotypes we compiled the first time through
              //  and assign all of the values we find to somewhere in that phenotype list
              for ( var i = 0 ; i < data.length ; i++ ){
                  var key = data [i].level;
                  var splitKey = key.split("^");
                  if (splitKey.length>1) {
                      if ((splitKey[0] === 'P_VALUE') || (splitKey[0] === 'MAF')) continue;
                      if (splitKey[0] === 'ODDS_RATIO'){
                          currentPhenotype = splitKey[1];
                          phenotypeRow = phenotypeShortcut[currentPhenotype];
                          rowPointer = phenoStruct[phenotypeRow];
                          rowPointer['oddsRatio'] = data [i].count;
                      }
                      if (splitKey[0] === 'BETA'){
                          currentPhenotype = splitKey[1];
                          phenotypeRow = phenotypeShortcut[currentPhenotype];
                          rowPointer = phenoStruct[phenotypeRow];
                          rowPointer['beta'] = data [i].count;
                      }
                      if (splitKey[0] === 'DIR'){
                          currentPhenotype = splitKey[1];
                          phenotypeRow = phenotypeShortcut[currentPhenotype];
                          rowPointer = phenoStruct[phenotypeRow];
                          rowPointer['DIR'] = data [i].count;
                      }
                      if (splitKey[0] === 'MAPPER'){
                          mafGroup = splitKey[1];
                          mafValue = mafValues[mafGroup];
                          phenotypeRow = phenotypeShortcut[currentPhenotype];
                          rowPointer = phenoStruct[phenotypeRow];
                          currentPhenotypeList = data [i].count;
                          splitPhenotypeList = currentPhenotypeList.split(',');
                          for ( var j = 0 ; j < splitPhenotypeList.length ; j++ ) {
                              phenotypeRow = phenotypeShortcut[splitPhenotypeList[j]];
                              rowPointer = phenoStruct[phenotypeRow];
                              rowPointer['maf'] = mafValue;
                          }
                      }
                  }
              }

          }
          return phenoStruct;
      }




        fillTraitsPerVariantTable = function ( vRecO, show_gene, show_exseq, show_exchp,traitRootUrl ) {
            var retVal = "";
            if (!vRecO) {   // error condition
                return;
            }

            var vRec = deconvoluteVariantInfo(vRecO);

            for (var i = 0; i < vRec.length; i++) {

                var trait = vRec [i] ;
                retVal += "<tr>"

                var convertedTrait=mpgSoftware.trans.translator(trait.phenotype);

                retVal += "<td><a href='"+traitRootUrl+"?trait="+trait.phenotype+"&significance=5e-8'>"+convertedTrait+"</a></td>";

                retVal += "<td>" +((trait.pValue !== null)?trait.pValue.toPrecision(3):'')+"</td>";

                retVal += "<td>";
                if (trait.DIR === 1) {
                    retVal += "<span class='assoc-up'>&uarr;</span>";
                } else if (trait.DIR === -1) {
                    retVal += "<span class='assoc-down'>&darr;</span>";
                }
                retVal += "</td>";

                retVal += "<td>";
                if (trait.oddsRatio) {
                    retVal += (trait.oddsRatio.toPrecision(3));
                }
                retVal += "</td>";


                retVal += "<td>";
                if (trait.maf) {
                    retVal += (trait.maf.toPrecision(3));
                }
                retVal += "</td>";


                retVal += "<td>";
                if (trait.beta) {
                    retVal += "beta: " + trait.beta.toPrecision(3);
                } else if (trait.Z_SCORE){
                    retVal += "z-score: " + trait.ZSCORE.toPrecision(3);
                }
                retVal += "</td>";


                retVal += "</tr>";
            }
            return retVal;
        }
    var contentExists = function (field){
        return ((typeof field !== 'undefined') && (field !== null) );
    };
    var noop = function (field){return field;};
    var lineBreakSubstitution = function (field){
        return (contentExists(field))?field.replace(/[;,]/g,'<br/>'):'';
    };
    var grayOutOnValue = function (displayField,contingencyField){
        var retVal = "";
        if (contingencyField) {
            var pValue = parseFloat(contingencyField);
            if (($.isNumeric(pValue)) && (pValue > 1)) {
                retVal += "<span class='greyedout'>" + UTILS.realNumberFormatter(displayField) + "</span>";
            } else {
                retVal += "" +UTILS.realNumberFormatter(displayField);
            }
        }else{
            retVal += "" +UTILS.realNumberFormatter(displayField);
        }
        return retVal;
    };
    var grayOutBetaValue = function (displayField,contingencyField){
        var retVal = "";
        var logExchipOddsRatio  =   parseFloat(displayField);
        if ($.isNumeric(logExchipOddsRatio))  {
            if (contingencyField)  {
                var pValue = parseFloat (contingencyField);
                if (($.isNumeric(pValue))&&(pValue>1)) {
                    retVal += "<span class='greyedout'>" + UTILS.realNumberFormatter(logExchipOddsRatio) + "</span>";
                } else {
                    retVal += ""+UTILS.realNumberFormatter(logExchipOddsRatio);
                }
            } else {
                retVal += UTILS.realNumberFormatter(logExchipOddsRatio);
            }
        }  else {
            retVal += "";
        }

        return retVal;
    };



    var singleLineOfVariantTable = function( variant,show_gene,show_exseq,show_exchp,variantRootUrl,geneRootUrl,proteinEffectList) {
        var arrayToBuild = [];
        stringWithLink(arrayToBuild,geneRootUrl,(contentExists (geneRootUrl)),noop,variant.CLOSEST_GENE,variant.CLOSEST_GENE,"");
        stringWithLink(arrayToBuild,variantRootUrl,((contentExists (variantRootUrl)) && (variant.ID)),noop,variant.ID,variant.CHROM+ ":" +variant.POS,"");
        simpleString(arrayToBuild,(variant.DBSNP_ID),noop,variant.DBSNP_ID,"");
        simpleString(arrayToBuild,(variant.Protein_change&& (variant.Protein_change !== 'null')),noop,variant.Protein_change,"");
        simpleString(arrayToBuild,((variant.Consequence)&&(contentExists(proteinEffectList))&&
            (contentExists(proteinEffectList.proteinEffectMap))&&(contentExists(proteinEffectList.proteinEffectMap[variant.Consequence]))),
            lineBreakSubstitution,proteinEffectList.proteinEffectMap[variant.Consequence],lineBreakSubstitution((variant.Consequence && (variant.Consequence !== 'null'))?variant.Consequence:""));
        if (show_exseq){
            var highFreq = determineHighestFrequencyEthnicity(variant);
            simpleString(arrayToBuild,(variant._13k_T2D_P_EMMAX_FE_IV),UTILS.realNumberFormatter,variant._13k_T2D_P_EMMAX_FE_IV,"");
            simpleString(arrayToBuild,(variant._13k_T2D_OR_WALD_DOS_FE_IV),noop,grayOutOnValue (variant._13k_T2D_OR_WALD_DOS_FE_IV,variant._13k_T2D_SE),"");
            simpleString(arrayToBuild,(contentExists (variant._13k_T2D_MINA) && contentExists (typeof variant._13k_T2D_MINU)),noop,(""+variant._13k_T2D_MINA + "/" +variant._13k_T2D_MINU),"");
            simpleString(arrayToBuild,(highFreq.highestFrequency),UTILS.realNumberFormatter,highFreq.highestFrequency,"");
            simpleString(arrayToBuild,((highFreq.populationWithHighestFrequency)&&(!highFreq.noData)),noop,highFreq.populationWithHighestFrequency,"");
        }
        if (show_exchp){
            var highFreq = determineHighestFrequencyEthnicity(variant);
            simpleString(arrayToBuild,(variant.EXCHP_T2D_P_value),UTILS.realNumberFormatter,variant.EXCHP_T2D_P_value,"");
            simpleString(arrayToBuild,(variant.EXCHP_T2D_BETA),noop,grayOutBetaValue (variant.EXCHP_T2D_BETA,variant.EXCHP_T2D_SE),"");
            simpleString(arrayToBuild,(variant.GWAS_T2D_PVALUE),UTILS.realNumberFormatter,variant.GWAS_T2D_PVALUE,"");
            simpleString(arrayToBuild,(variant.GWAS_T2D_OR),UTILS.realNumberFormatter,variant.GWAS_T2D_OR,"");
        }
        return arrayToBuild;
    };





    /* Sort col is *relative* to dynamic columns */
    var iterativeVariantTableFiller = function  (data, totCol, sortCol, divId,variantRootUrl,geneRootUrl,proteinEffectList,dataSetDetermination)  {

        // Some of the common properties are nonnumeric.  We have type information but for right now I'm going to kludge it.
        //  TODO: Passed down the type information for each common property and use it to determine which are numeric and which aren't
        // Then, assume all remaining columns are numeric.

        var stringColumns = []
        var numericCol = []
        var colIndex;
        for (colIndex = 0; colIndex < data.columns.cproperty.length; colIndex++) {
           var prop = data.columns.cproperty[colIndex];
            if ((prop === 'VAR_ID')||
                (prop === 'DBSNP_ID')||
                (prop === 'CHROM')||         // technically the datatype is a string, but we usually want to treat it like an integer
                (prop === 'CLOSEST_GENE')||
                (prop === 'Condel_PRED')||
                (prop === 'Consequence')||
                (prop === 'GENE')||
                (prop === 'PolyPhen_PRED')||
                (prop === 'SIFT_PRED')||
                (prop === 'TRANSCRIPT_ANNOT')){
                stringColumns.push(colIndex);
            } else {
                numericCol.push(colIndex);
            }
        }
        while (colIndex<totCol){
            numericCol.push(colIndex++);
        }



        //need to figure out how to add aaSorting and aoColumnDefs
//        $(divId).dataTable({
//            iDisplayLength: 20,
//            bFilter: false,
//            aaSorting: [[ sortCol + fixedCol, "asc" ]],
//            aoColumnDefs: [{sType: "allnumeric", aTargets: numericCol } ]
//        });
        // need to be more flexible now that the number of rows is variable
        var table = $(divId).dataTable({
            iDisplayLength: 20,
            bFilter: false,
            aaSorting: [[ sortCol, "asc" ]],
            aoColumnDefs: [{sType: "allnumeric", aTargets: numericCol } ]
        });
        var tableTools = new $.fn.dataTable.TableTools( table, {
            "buttons": [
                "copy",
                "csv",
                "xls",
                "pdf",
                { "type": "print", "buttonText": "Print me!" }
            ],
            "sSwfPath": "../../js/DataTables-1.10.7/extensions/TableTools/swf/copy_csv_xls_pdf.swf"
        } );
        $( tableTools.fnContainer() ).insertAfter(divId);

        var variantList =  data.variants
        var dataLength = variantList ? variantList.length : 0;

        for ( var i = 0 ; i < dataLength ; i++ ){
            var array = []
            var variant = {}
            for (var j = 0; j < variantList[i].length; j++) {
                for (prop in variantList[i][j]) {
                    variant[prop] = variantList[i][j][prop]
                }
            }
//            array.push(getStringWithLink(geneRootUrl,(contentExists (geneRootUrl)),noop,variant.CLOSEST_GENE,variant.CLOSEST_GENE,""));
//            array.push(getStringWithLink(variantRootUrl,((contentExists (variantRootUrl)) && (variant.VAR_ID)),noop,variant.VAR_ID,variant.CHROM+ ":" +variant.POS,""));
//            array.push(getSimpleString((variant.DBSNP_ID),noop,variant.DBSNP_ID,""));
//            array.push(getSimpleString((variant.Protein_change&& (variant.Protein_change !== 'null')),noop,variant.Protein_change,""));
//            array.push(getSimpleString(((variant.Consequence)&&(contentExists(proteinEffectList))&&
//                    (contentExists(proteinEffectList.proteinEffectMap))&&(contentExists(proteinEffectList.proteinEffectMap[variant.Consequence]))),
//                lineBreakSubstitution,proteinEffectList.proteinEffectMap[variant.Consequence],lineBreakSubstitution((variant.Consequence && (variant.Consequence !== 'null'))?variant.Consequence:"")));

            for (var cpropIndex in data.columns.cproperty) {
                var cprop =  data.columns.cproperty[cpropIndex];
                var value = variant[cprop];
                if (cprop === "VAR_ID")  {
                    array.push(getStringWithLinkForVarId(variantRootUrl,((contentExists (variantRootUrl)) && (variant.VAR_ID)),noop,variant.VAR_ID,variant.CHROM+ ":" +variant.POS,variant.VAR_ID));
                } else if (cprop === "CHROM") {
                    array.push(getSimpleString((variant.CHROM),noop,variant.CHROM,""));
                }  else if (cprop === "POS") {
                    array.push(getSimpleString((variant.POS),noop,variant.POS,""));
                }  else if (cprop === "DBSNP_ID") {
                    array.push(getSimpleString((variant.DBSNP_ID),noop,variant.DBSNP_ID,""));
                }  else if (cprop === "CLOSEST_GENE") {
                    array.push(getStringWithLink(geneRootUrl,(contentExists (geneRootUrl)),noop,variant.CLOSEST_GENE,variant.CLOSEST_GENE,""));
                }  else if (cprop === "GENE") {
                    array.push(getStringWithLink(geneRootUrl,(contentExists (geneRootUrl)),noop,variant.GENE,variant.GENE,""));
                }  else if (cprop === "IN_GENE") {
                    array.push(getSimpleString((variant.IN_GENE),noop,variant.IN_GENE,""));
                }  else if (cprop === "Protein_change") {
                    array.push(getSimpleString((variant.Protein_change&& (variant.Protein_change !== 'null')),noop,variant.Protein_change,""));
                }  else if (cprop === "Consequence") {
                    array.push(getSimpleString(((variant.Consequence)&&(contentExists(proteinEffectList))&&
                            (contentExists(proteinEffectList.proteinEffectMap))&&(contentExists(proteinEffectList.proteinEffectMap[variant.Consequence]))),
                        lineBreakSubstitution,proteinEffectList.proteinEffectMap[variant.Consequence],lineBreakSubstitution((variant.Consequence && (variant.Consequence !== 'null'))?variant.Consequence:"")));
                }  else if (cprop === "IN_EXSEQ") {
                    array.push(getSimpleString((variant.IN_EXSEQ),noop,variant.IN_EXSEQ,""));
                }  else if (cprop === "SIFT_PRED") {
                    array.push(getSimpleString((variant.SIFT_PRED),noop,variant.SIFT_PRED,""));
//                }  else if (cprop === ) {
                }
                else if (cprop === "Condel_PRED") {
                    array.push(getSimpleString((variant.Condel_PRED),noop,variant.Condel_PRED,""));
                }
                else if (cprop === "MOST_DEL_SCORE") {
                    array.push(getSimpleString((variant.MOST_DEL_SCORE),noop,variant.MOST_DEL_SCORE,""));
                }
                else if (cprop === "PolyPhen_PRED") {
                    array.push(getSimpleString((variant.PolyPhen_PRED),noop,variant.PolyPhen_PRED,""));
                }
                else if (cprop === "SIFT_PRED") {
                    array.push(getSimpleString((variant.SIFT_PRED),noop,variant.SIFT_PRED,""));
                }
                else if (cprop === "TRANSCRIPT_ANNOT") {
                    array.push(getSimpleString((variant.TRANSCRIPT_ANNOT),noop,variant.TRANSCRIPT_ANNOT,""));
                }
                else {
                    array.push(getSimpleString((variant[cprop]),noop,variant[cprop],""));
                }
            }



            for (var pheno in data.columns.dproperty) {
                for (var dataset in data.columns.dproperty[pheno]) {
                    for (var k = 0; k < data.columns.dproperty[pheno][dataset].length; k++) {
                        var column = data.columns.dproperty[pheno][dataset][k]
                        array.push(getSimpleString((variant[column][dataset]),Math.round(variant[column][dataset]) == variant[column][dataset] ? noop : UTILS.realNumberFormatter,variant[column][dataset],""));
                    }
                }
            }

            for (var pheno in data.columns.pproperty) {
                for (var dataset in data.columns.pproperty[pheno]) {
                    for (var k = 0; k < data.columns.pproperty[pheno][dataset].length; k++) {
                        var column = data.columns.pproperty[pheno][dataset][k]
                        array.push(getSimpleString((variant[column][dataset][pheno]),Math.round(variant[column][dataset][pheno]) == variant[column][dataset][pheno] ? noop : UTILS.realNumberFormatter,variant[column][dataset][pheno],""));
                    }
                }
            }
            $(divId).dataTable().fnAddData( array, (i==25) || (i==(dataLength-1)));
        }
    };

    var oldIterativeVariantTableFiller = function  (data, divId, show_gene, show_exseq, show_exchp,variantRootUrl,geneRootUrl,proteinEffectList)  {
        var variantList =  data['variants'];
            $(divId).dataTable({
                iDisplayLength: 20,
                bFilter: false,
                bDestroy:true,
                aaSorting: [[ 5, "asc" ]],
                aoColumnDefs: [{sType: "allnumeric", aTargets: [ 5, 6, 8, 10, 11, 12, 13 ] } ]
            });
        var dataLength = variantList.length;


        for ( var i = 0 ; i < dataLength ; i++ ){
            var variant = {};
            var row = 0;
            var array;
            variant["DBSNP_ID"]=variantList[i].pVals[row++].count;
            variant["ID"]=variantList[i].pVals[row++].count;
            variant["CHROM"]=variantList[i].pVals[row++].count;
            variant["POS"]=variantList[i].pVals[row++].count;
            variant["CLOSEST_GENE"]=variantList[i].pVals[row++].count;
            variant["Protein_change"]=variantList[i].pVals[row++].count;
            variant["Consequence"]=variantList[i].pVals[row++].count;
            variant["_13k_T2D_P_EMMAX_FE_IV"]=variantList[i].pVals[row++].count;
            variant["_13k_T2D_OR_WALD_DOS_FE_IV"]=variantList[i].pVals[row++].count;
            variant["_13k_T2D_SE"]=1;//variantList[i].pVals[row++].count;
            row++; row++;
            variant["_13k_T2D_MINA"]=variantList[i].pVals[row++].count;
            variant["_13k_T2D_MINU"]=variantList[i].pVals[row++].count;
            variant["_13k_T2D_"+variantList[i].pVals[row].level+"_MAF"]=variantList[i].pVals[row++].count;
            variant["_13k_T2D_"+variantList[i].pVals[row].level+"_MAF"]=variantList[i].pVals[row++].count;
            variant["_13k_T2D_"+variantList[i].pVals[row].level+"_MAF"]=variantList[i].pVals[row++].count;
            variant["_13k_T2D_"+variantList[i].pVals[row].level+"_MAF"]=variantList[i].pVals[row++].count;
            variant["_13k_T2D_"+variantList[i].pVals[row].level+"_MAF"]=variantList[i].pVals[row++].count;
            variant["_13k_T2D_"+variantList[i].pVals[row].level+"_MAF"]=variantList[i].pVals[row++].count;
            variant["EXCHP_T2D_P_value"]=variantList[i].pVals[row++].count;
            variant["EXCHP_T2D_BETA"]=variantList[i].pVals[row++].count;
            variant["GWAS_T2D_PVALUE"]=variantList[i].pVals[row++].count;
            variant["GWAS_T2D_OR"]=variantList[i].pVals[row++].count;
            array = singleLineOfVariantTable(variant,show_gene, show_exseq, show_exchp,variantRootUrl,geneRootUrl,proteinEffectList);
            $(divId).dataTable().fnAddData( array, (i==25) || (i==(dataLength-1)));
        }
    };

    var getStringWithLink  = function(urlRoot, contingent, modder, linkField,displayField, alternate){
        var retVal = alternate;
        if (contingent){
            retVal = "<a  href='"+urlRoot+"/"+linkField+"' class='boldItlink'>"+modder(displayField);
        }
        return retVal

    };
    var getStringWithLinkForVarId  = function(urlRoot, contingent, modder, linkField,displayField, alternate){
        var retVal = alternate;
        if (contingent){
            if (displayField) {
                if (displayField.indexOf('undefined') === -1)   {
                    retVal = "<a  href='" + urlRoot + "/" + linkField + "' class='boldItlink'>" + modder(displayField);
                }  else {
                    retVal = "<a  href='" + urlRoot + "/" + linkField + "' class='boldItlink'>" + modder(alternate);
                }
            }
        }
        return retVal
    };
    var stringWithLink  = function(arrayToBuild, urlRoot, contingent, modder, linkField,displayField, alternate){
        arrayToBuild.push(getStringWithLink(urlRoot, contingent, modder, linkField,displayField, alternate))
    };
    var getSimpleString  = function(contingent,  modder,  displayField, alternate){
        var retVal = alternate;
        if (contingent){
            retVal = ""+ modder (displayField);
        }
        return retVal
    };
    var simpleString  = function(arrayToBuild,  contingent,  modder,  displayField, alternate){
        arrayToBuild.push(getSimpleString(contingent,  modder,  displayField, alternate));
    };

    return {
        iterativeVariantTableFiller:iterativeVariantTableFiller,
        oldIterativeVariantTableFiller:oldIterativeVariantTableFiller,
        fillTheVariantTable: fillTheVariantTable,
        fillCollectedVariantsTable:fillCollectedVariantsTable,
        fillTraitsPerVariantTable:fillTraitsPerVariantTable
    }

}());
