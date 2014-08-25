var UTILS = {
    /***
     * General-purpose utility that JavaScript ought to have.
     * @param map
     * @returns {{}}
     */
    invertMap: function (map){
        var inv={};
        var keys=Object.keys(map);
        for(var i=0;i<keys.length;i++){
            if (map[keys[i]]) {
                inv[map[keys[i]]]=keys[i];
            }
        }
        return inv;
    },
    /***
     * One of those things JavaScript ought to have. The only warning-- these maps must share no keys Or
     * else to lose  values
     * @param workingMap
     * @param mapFromWhichWeExtract
     * @returns Resulting concatenated map, though this is also available through the first input parameter
     */
    concatMap: function (workingMap,mapFromWhichWeExtract){
        if ( typeof(workingMap)=== "undefined") {
            workingMap = {};
        }
        if (mapFromWhichWeExtract)
        var keys=Object.keys(mapFromWhichWeExtract);
        for(var i=0;i<keys.length;i++) {
            workingMap[keys[i]] = mapFromWhichWeExtract [keys[i]];
        }
        return workingMap;
    },
    /***
     * Everyone seems to use three digits of precision. I wonder why
     * @param incoming
     * @returns {string}
     */
    realNumberFormatter:function(incoming){
       var value=parseFloat (incoming);
        return value.toPrecision(3);
    },
    /***
     * Take phenotype information delivered by the server and change it into a usable form.
     * NOTE: this is a constructor. Use it like this:
     *     var  phenotypeMap =  new phenotypeListConstructor (phenotypeListString) ;
     * NOTE: the incoming parameter will be encoded by grails by default. You need to run something like:
     *     var phenotypeListString  = decodeURIComponent("${phenotypeList}");
     * in order to convert the URL encoded string back into a usable form before calling
     * this constructor.
     * @param inString
     */
    phenotypeListConstructor: function (inString) {
        var keyValue = {};
        var arrayHolder = [];
        var listOfPhenotypes = inString.split(",");
        for (var i = 0; i < listOfPhenotypes.length; i++) {
            var phenotypeAndKey = listOfPhenotypes[i].split(":");
            var reclaimedKey = phenotypeAndKey [0];
            var reclaimedLabel = phenotypeAndKey [1].replace(/\+/g, ' ');
            keyValue  [reclaimedKey] = reclaimedLabel;
            arrayHolder.push({key: reclaimedKey,
                val: reclaimedLabel});
        }
        this.phenotypeMap = keyValue;
        this.phenotypeArray = arrayHolder;
    },
    /***
     * Take phenotype information delivered by the server and change it into a usable form.
     * NOTE: this is a constructor. Use it like this:
     *     var  phenotypeMap =  new phenotypeListConstructor (phenotypeListString) ;
     * NOTE: the incoming parameter will be encoded by grails by default. You need to run something like:
     *     var phenotypeListString  = decodeURIComponent("${phenotypeList}");
     * in order to convert the URL encoded string back into a usable form before calling
     * this constructor.
     * @param inString
     */
    proteinEffectListConstructor: function (inString) {
        var keyValue = {};
        var arrayHolder = [];
        var listOfProteinEffect = inString.split("~");
        for (var i = 0; i < listOfProteinEffect.length; i++) {
            var proteinEffectAndKey = listOfProteinEffect[i].split(":");
            var reclaimedKey = proteinEffectAndKey [0];
            var reclaimedLabel = proteinEffectAndKey [1].replace(/\+/g, ' ');
            keyValue  [reclaimedKey] = reclaimedLabel;
            arrayHolder.push({key: reclaimedKey,
                val: reclaimedLabel});
        }
        this.proteinEffectMap = keyValue;
        this.proteinEffectArray = arrayHolder;
    },

    frequencyCharacterization: function (proportion, cutoffs){
        var retVal = "";
        if (proportion === 0) {
            retVal += "unobserved" ;
        }
        else if (( proportion > 0) && ( proportion < 0)) {
            retVal += "private";
        }   // this is a strange conditional.  TODO is this really the right way to make this comparison?
        else if (( proportion > cutoffs[0]) && ( proportion < cutoffs[1])) {
            retVal += "rare";
        }
        else if (( proportion >= cutoffs[1] ) && ( proportion < cutoffs[2])) {
            retVal += "low frequency" ;
        }
        else if (( proportion >= cutoffs[2] )) {
            retVal += "common";
        }
        return retVal;
    },
    get_variant_repr: function(v) {
        return v.CHROM + ':' + v.POS;
    },

    get_variant_title: function(v,emergencyTitle) {
        if (v.DBSNP_ID) {
            return v.DBSNP_ID;
        } else {
            if (typeof v.CHROM!== "undefined") {
                return v.CHROM + ':' + v.POS;
            }  else {
                return  emergencyTitle;
            }

        }
    },
    variantInfoHeaderSentence: function (variant) {
        var returnValue = "";
        if (variant.IN_GENE) {
            returnValue += "lies in the gene <em>" +variant.IN_GENE+ "</em>";
        } else {
            returnValue += "is nearest to the gene <em>" +variant.CLOSEST_GENE+ "</em>";
        }
        return  returnValue;
    },
     get_highest_frequency: function(v) {
        var max = 0;
        var max_pop = '';
        _.each(['AA', 'EA', 'SA', 'EU', 'HS'], function(k) {
            var af = v['_13k_T2D_' + k + '_MAF'];
            if (af > max) {
                max = af;
                max_pop = k;
            }
        });
        return [max, max_pop];
    },

    get_simple_variant_effect: function(v) {
        if (v.MOST_DEL_SCORE == 1) {
            return 'protein-truncating'
        }
        else if (v.MOST_DEL_SCORE == 2) {
            return 'missense'
        }
        else if (v.MOST_DEL_SCORE == 3) {
            return 'synonymous-coding'
        }
        // if MOST_DEL_SCORE is null, treat it as 4
        else {
            return 'non-coding';
        }
    },

    getSimpleVariantsEffect: function(vMOST_DEL_SCORE) {
        if (vMOST_DEL_SCORE == 1) {
            return 'protein-truncating'
        }
        else if (vMOST_DEL_SCORE == 2) {
            return 'missense'
        }
        else if (vMOST_DEL_SCORE == 3) {
            return 'synonymous-coding'
        }
        // if MOST_DEL_SCORE is null, treat it as 4
        else {
            return 'non-coding';
        }
    },

    get_significance_text: function(significance) {
        if (significance < 5e-8) {
            return 'genome-wide';
        } else if (significance < 5e-2) {
            return 'nominal';
        } else {
            return
        }
    },

    get_lowest_p_value: function(variant) {
        var pval = 1;
        var datatype = '';
        if (variant.IN_EXCHP && variant.EXCHP_T2D_P_value < pval) {
            pval = variant.EXCHP_T2D_P_value;
            datatype = 'exome chip';
        }
        if (variant.IN_EXSEQ && variant._13k_T2D_P_EMMAX_FE_IV < pval) {
            pval = variant._13k_T2D_P_EMMAX_FE_IV;
            datatype = 'exome sequencing';
        }
        if (variant.IN_GWAS && variant.GWAS_T2D_PVALUE < pval) {
            pval = variant.GWAS_T2D_PVALUE;
            datatype = 'GWAS';
        }
        return [pval, datatype];
    },
    expandEthnicityDesignation: function (shortName) {
        var retVal = "";
        var ethnicAbbreviation = ['AA', 'EA', 'SA', 'EU', 'HS'];
        var ethnicityFullName = ["African-Americans", "East Asians", "South Asians", "Europeans", "Hispanics"];
        for (  var i = 0 ; i < ethnicAbbreviation.length ; i++ )  {
            if (shortName === (ethnicAbbreviation [i])) break;
        }
        if  (i < ethnicityFullName.length)  {
            retVal = ethnicityFullName [i]  ;
        }  else {
            retVal =  shortName;
        }
         return  retVal;
    },

    get_consequence_names: function(variant) {
        if (!variant.Consequence) return [];
        var keys = variant.Consequence.split(';');
        var names = [];
        _.each(keys, function(k) {
            if (!k) return;
            var consequence = _.find(CONSTANTS.so_consequences, function(c) { return c.key == k });
            if (consequence) {
                names.push(consequence.name);
            } else {
                names.push(k);
            }
        });
        return names;
    },

    fillAssociationsStatistics: function(variant,
                                         vMap,
                                         availableData,
                                         pValue,
                                         strongCutOff,
                                         weakCutOff,
                                         variantTitle,
                                         textStrongLine1,
                                         textStrongLine2,
                                         textMediumLine,
                                         textWeakLine,
                                         noDataLine ) {
        var retVal = "";
        var iMap = UTILS.invertMap(vMap);
        if (variant[iMap[availableData]]){
            retVal +="<p>";
            if (variant[iMap[pValue]] <= strongCutOff ) {
                retVal += "<strong>" + textStrongLine1 +" "+ variantTitle  +" "+ textStrongLine2;
            }
            if  (variant[iMap[pValue]]  >  strongCutOff  && variant[iMap[pValue]] <=   weakCutOff) {
                retVal += textMediumLine;
            }
            if  (variant[iMap[pValue]]  >  weakCutOff) {
                retVal  += textMediumLine;
            }
            if (variant[iMap[pValue]] <= strongCutOff ) {
                retVal += "</strong>" ;
            }
            retVal +="</p>"+
                   "<ul>"+
                    "<li>p-value from this analysis:"+variant[iMap[pValue]] + "</li>"+
                    "</ul>";
        } else {
            retVal += noDataLine;
        }
        return retVal;
    },
    fillAssociationStatisticsLinkToTraitTable: function(variant,
                                         vMap,
                                         weHaveData,
                                         dbsnp,
                                         variantId,
                                         rootTraitUrl) {
        var retVal = "";
        var iMap = UTILS.invertMap(vMap);
        if (variant[iMap[weHaveData]]) {
            retVal += ("<a class=\"boldlink\" href=\""+rootTraitUrl+"/" +
                ((variant[iMap[weHaveData]]) ? (variant[iMap[dbsnp]]) : (variant[iMap[variantId]])) +
                "\">Click here</a> to see a table of p-values for this variant across 25 traits studied in GWAS meta-analyses.");
        }
        return  retVal;
    },
    showPercentageAcrossEthnicities: function (variant) {
        var retVal = "";
        var ethnicAbbreviation = ['AA', 'EA', 'SA', 'EU', 'HS'];
        var ethnicityFullName = ["African-Americans", "East Asians", "South Asians", "Europeans", "Hispanics"];
        for (var i = 0; i < ethnicAbbreviation.length; i++) {
            var stringProportion = variant['_13k_T2D_' + ethnicAbbreviation[i] + '_MAF'];
            var proportion = parseFloat(stringProportion);
            retVal += "<li>";

            retVal += ((proportion*100).toPrecision(3) + " percent of " + ethnicityFullName [i]);
            retVal += "(";
            retVal += UTILS.frequencyCharacterization(proportion,[0,0.005,0.05]);
            retVal += (")" +
                "</li>");
        }
        return  retVal;
    },
    showPercentagesAcrossHeterozygousCarriers: function (variant, title) {
        var retVal = "";
        var heta  = parseFloat(variant["_13k_T2D_HETA"]);
        var hetu  = parseFloat(variant["_13k_T2D_HETU"]) ;
        retVal += ("<li>Number of people across datasets who carry one copy of " +title+ ": " + (parseFloat(heta)+parseFloat(hetu)) + "</li>");
        retVal += ("<li>Number of these carriers who have type 2 diabetes: " + (heta) + "</li>");
        retVal += ("<li>Number of people across datasets who carry one copy of " +title+ ": " + (hetu) + "</li>");
        return  retVal;
    },
    showPercentagesAcrossHomozygousCarriers: function (variant, title) {
        var retVal = "";
        var homa  = parseFloat(variant["_13k_T2D_HOMA"]) ;
        var homu  = parseFloat(variant["_13k_T2D_HOMU"]) ;
        retVal += ("<li>Number of people across datasets who carry two copies of  " +title+ ": " + (homa+homu) + "</li>");
        retVal += ("<li>Number of these carriers who have type 2 diabetes: " + (homa) + "</li>");
        retVal += ("<li>Number of people across datasets who carry one copy of " +title+ ": " + (homu) + "</li>");
        return  retVal;
    },
    eurocentricVariantCharacterization:  function (variant, title) {
        var retVal = "";
        var euroValue  = parseFloat(variant["EXCHP_T2D_MAF"]) ;
        if (variant["EXCHP_T2D_P_value"]) {
            retVal += ("<p>In exome chip data available on this portal, the minor allele frequency of "+title + " is "+
                (euroValue*100)+ " percent in Europeans ("+UTILS.frequencyCharacterization(euroValue, [0.000001,0.005,0.05])+ ")");
        }
        return retVal;
    },
    sigmaVariantCharacterization:  function (variant, title) {
        var retVal = "";
        var euroValue  = parseFloat(variant["SIGMA_T2D_MAF"]) ;
        if (variant["SIGMA_T2D_MAF"]) {
            retVal += ("<p>The minor allele frequency of "+title + " in <em>SIGMA</em> sequencing data is: "+
                (euroValue*100)+ " ("+UTILS.frequencyCharacterization(euroValue, [0.000001,0.005,0.05])+ ")");
        } else {
            retVal += ( "<p>This variant is not observed in SIGMA sequencing data.</p>");
        }
        return retVal;
    },
    verifyThatDisplayIsWarranted: function (fieldToTest, divToDisplayIfWeHaveData, giveToDisplayIfWeHaveNoData)  {
        if (!fieldToTest)  {
            divToDisplayIfWeHaveData.hide();
            giveToDisplayIfWeHaveNoData.show();
        } else {
            divToDisplayIfWeHaveData.show ();
            giveToDisplayIfWeHaveNoData.hide();
        }
    },
    variantInfoRadioChange: function (PolyPhen_SCORE, SIFT_SCORE, Condel_SCORE, MOST_DEL_SCORE, _13k_ANNOT_29_mammals_omega, Protein_position, Codons, Protein_change, PolyPhen_PRED, Consequence, Condel_PRED, SIFT_PRED) {
        var delScore = parseInt(MOST_DEL_SCORE);
        $('#annotationCodon').html(Codons);
        $('#annotationProteinChange').html(Protein_change);
        $('#ensembleSoAnnotation').html('<strong>' +Consequence+'</strong>');
        if (delScore=== 1){
            $('#variantTruncateProtein').html('<strong>yes</strong>');
        } else {
            $('#variantTruncateProtein').html('<strong>no</strong>');
        }
        $('#polyPhenPrediction').html('<strong>' +PolyPhen_PRED+'</strong>,<strong>'+PolyPhen_SCORE +'</strong>');
        $('#siftPrediction').html('<strong>' +SIFT_PRED+'</strong>,<strong>'+SIFT_SCORE +'</strong>');
        $('#condelPrediction').html('<strong>' +Condel_PRED+'</strong>,<strong>'+Condel_SCORE +'</strong>');
        if (delScore===  2)  {
            $('#mostDeleteScoreEquals2').css('display','block');
        } else{
            $('#mostDeleteScoreEquals2').css('display','none');
        }
        if (delScore<4) {
            $('#variationInfoEncodedProtein').css('display','block');
            $('#puntOnNoncodingVariant').css('display','none');
        } else{
            $('#variationInfoEncodedProtein').css('display','none');
            $('#puntOnNoncodingVariant').css('display','block');
        }

    },
    variantGenerateProteinsChooser:  function (variant, title) {
        var retVal = "";
        if (variant.MOST_DEL_SCORE && variant.MOST_DEL_SCORE < 4) {
            retVal += "<h2><strong>What effect does " +title+ " have on the encoded protein?</strong></h2>\n"+
            "<p>Choose one transcript below to see the predicted effect on the protein:</p>";
            var allKeys = Object.keys(variant._13k_T2D_TRANSCRIPT_ANNOT);
            for ( var  i=0 ; i<allKeys.length ; i++ ) {
                var checked = (i==0) ? ' checked ' : '';
                var annotation =variant._13k_T2D_TRANSCRIPT_ANNOT[allKeys[i]];
                retVal += ("<div class=\"radio-inline\">\n" +
                    "<label>\n"+
                    "<input "+checked+" class='transcript-radio' type='radio' name='transcript_check' id='transcript-" +allKeys[i] +
                    "' value='" +allKeys[i]+ "' onclick='UTILS.variantInfoRadioChange(" +
                    "\""+annotation['PolyPhen_SCORE']+ "\"," +
                    "\""+annotation['SIFT_SCORE']+ "\"," +
                    "\""+annotation['Condel_SCORE']+ "\"," +
                    "\""+annotation['MOST_DEL_SCORE']+ "\"," +
                    "\""+annotation['_13k_ANNOT_29_mammals_omega']+ "\"," +
                    "\""+annotation['Protein_position']+ "\"," +
                    "\""+annotation['Codons']+ "\"," +
                    "\""+annotation['Protein_change']+ "\"," +
                    "\""+annotation['PolyPhen_PRED']+ "\"," +
                    "\""+annotation['Consequence']+ "\"," +
                    "\""+annotation['Condel_PRED']+ "\"," +
                    "\""+annotation['SIFT_PRED']+ "\"" +
                    ")' >\n"+
                    allKeys[i]+"\n"+
                    "</label>\n"+
                    "</div>\n");
             }
            if (allKeys.length > 0){
                var annotation =variant._13k_T2D_TRANSCRIPT_ANNOT[allKeys[0]];
                UTILS.variantInfoRadioChange(annotation['PolyPhen_SCORE'],
                annotation['SIFT_SCORE'],
                annotation['Condel_SCORE'],
                annotation['MOST_DEL_SCORE'],
                annotation['_13k_ANNOT_29_mammals_omega'],
                annotation['Protein_position'],
                annotation['Codons'],
                annotation['Protein_change'],
                annotation['PolyPhen_PRED'],
                annotation['Consequence'],
                annotation['Condel_PRED'],
                annotation['SIFT_PRED'] );

            }


        }
        return retVal;
    },
    determineHighestFrequencyEthnicity: function (variant) {
        var highestValue = 0;
        var winningEthnicity = 0;
        var ethnicAbbreviation = ['AA', 'EA', 'SA', 'EU', 'HS'];
        var noData=true;
        for (var i = 0; i < ethnicAbbreviation.length; i++) {
            var stringValue = variant['_13k_T2D_' + ethnicAbbreviation[i] + '_MAF'];
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
        return  {highestFrequency:highestValue,
                 populationWithHighestFrequency:winningEthnicity,
                 noData:noData};
    },
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
    fillCollectedVariantsTable:  function ( fullJson,
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
                    if ((proteinEffectRepresentation)&&(proteinEffectRepresentation.length>0)) {
                        proteinEffectRepresentation = proteinEffectRepresentation.replace(/;/g,';\n')
                    }
                } else {
                    proteinEffectRepresentation =  vRec[i].Consequence;
                }
                retVal += "<td>"+proteinEffectRepresentation+"</td>" ;
            } else {
                retVal += "<td></td>";
            }

            if (show_sigma) {

                // Source
                if (vRec[i].SIGMA_SOURCE)  {
                    retVal += "<td>" +vRec[i].SIGMA_SOURCE+"</td>";
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
                    retVal += "<td>" +UTILS.realNumberFormatter(vRec[i].SIGMA_T2D_OR)+"</td>";
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

                // P value
                if (vRec[i].SIGMA_T2D_MAF)  {
                    retVal += "<td>" +vRec[i].SIGMA_T2D_MAF+"</td>";
                } else {
                    retVal += "<td></td>";
                }

            }
            if (show_exseq) {

                var highFreq = UTILS.determineHighestFrequencyEthnicity(vRec[i]);

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
                    retVal += "<td>" +UTILS.realNumberFormatter(vRec[i]._13k_T2D_OR_WALD_DOS_FE_IV)+"</td>";
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

                var highFreq = UTILS.determineHighestFrequencyEthnicity(vRec[i]);

                // P value
                if (vRec[i].EXCHP_T2D_P_value)  {
                    retVal += "<td>" +UTILS.realNumberFormatter(vRec[i].EXCHP_T2D_P_value)+"</td>";
                } else {
                    retVal += "<td></td>";
                }

                // odds ratio  TODO: I don't know what value this maps to!
                retVal += "<td></td>";

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
    extractAlleleFrequencyRanges: function(allFields) {
        var returnValue  = {};
        var differentEthnicities =  ['AA', 'EA', 'SA', 'EU', 'HS'];
        var minMax =  ['min','max'];
        for ( var i = 0 ; i < differentEthnicities.length ; i++ ) {
            for ( var j = 0 ; j < minMax.length ; j++ ) {
                var idValue = 'ethnicity_af_'+differentEthnicities[i] +'-' +minMax[j];
                returnValue[idValue] = $('#' +idValue).val();
            }
        }
         return returnValue;
    },
    /***
     * Extract all checked values from a set of checkboxes. The object returned  describes only the checkboxes
     * that have been checked -- it wasn't checked then there is no record
     * @param checkboxName
     * @param allFields
     * @returns {{}}
     */
    extractValFromCheckboxes: function(everyId) {
        var returnValue  = {};
        for ( var i = 0 ; i < everyId.length ; i++ ) {
            var domReference = $('#'+everyId[i]);
            if ((domReference) &&
                (domReference.is(':checked'))){
                returnValue [domReference.val()]   = 1;
            }
        }
        return returnValue;
    },
    /***
     * Extract The values of all listed text boxes. If the checkbox is empty then don't return a record for that text box
     * @param checkboxName
     * @param allFields
     * @returns {{}}
     */
    extractValFromTextboxes: function(everyId) {
        var returnValue  = {};
        for ( var i = 0 ; i < everyId.length ; i++ ) {
            var domReference = $('#'+everyId[i]);
            if ((domReference) && (domReference.val())){
                returnValue [everyId[i]]   = domReference.val();
            }
        }
        return returnValue;
    },
    extractValsFromCombobox: function(everyId) {
        var returnValue  = {};
        for ( var i = 0 ; i < everyId.length ; i++ ) {
            var domReference = $('#'+everyId[i]);
            if ((domReference) && (domReference.val())){
                returnValue [everyId[i]]   = domReference.val();
            }
        }
        return returnValue;
    },
    postQuery: function (path, params, method) {
    method = method || "post"; // Set method to post by default if not specified.

    // The rest of this code assumes you are not using a library.
    // It can be made less wordy if you use one.
    var form = document.createElement("form");
    form.setAttribute("method", method);
    form.setAttribute("action", path);

    for(var key in params) {
        if(params.hasOwnProperty(key)) {
            var hiddenField = document.createElement("input");
            hiddenField.setAttribute("type", "hidden");
            hiddenField.setAttribute("name", key);
            hiddenField.setAttribute("value", params[key]);

            form.appendChild(hiddenField);
        }
    }

    document.body.appendChild(form);
    form.submit();
} ,
    postJson: function (path, params) {
        // construct an HTTP request
        var xhr = new XMLHttpRequest();
        xhr.open('POST', path, true);
        xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');

        // send the collected data as JSON
        xhr.send(JSON.stringify(params));

        xhr.onloadend = function () {
            // done
        };

    } ,
    postJson2: function (path,
                         params,
                         show_gene,
                         show_sigma,
                         show_exseq,
                         show_exchp,
                         variantRootUrl,
                         geneRootUrl,
                         variantSearchAjaxUrl,
                         dataSetDetermination) {
        var loading = $('#spinner').show();
        loading.show();
        $.ajax({
            type:'POST',
            cache:false,
            data:{'keys':params},
            url:variantSearchAjaxUrl,
            async:true,
            success:function(data,textStatus){
                UTILS.fillTheVariantTable(data,
                    show_gene,
                    show_sigma,
                    show_exseq,
                    show_exchp,
                    variantRootUrl,
                    geneRootUrl,
                    dataSetDetermination);
                loading.hide();
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){
                loading.hide();
                //errorReporter(XMLHttpRequest, exception) ;
            }
        });
    }
    ,
    fillTheVariantTable:  function (data,
                                    show_gene,
                                    show_sigma,
                                    show_exseq,
                                    show_exchp,
                                    variantRootUrl,
                                    geneRootUrl,
                                    dataSetDetermination)  {
    $('#variantTableBody').append(UTILS.fillCollectedVariantsTable(data,
        show_gene,
        show_sigma,
        show_exseq,
        show_exchp,
        variantRootUrl,
        geneRootUrl,
        dataSetDetermination));

    if (data.variants)     {
        var totalNumberOfResults =  data.variants.length;
        $('#numberOfVariantsDisplayed').append(''+totalNumberOfResults);
        $('#variantTable').dataTable({
            iDisplayLength: 20,
            bFilter: false,
            aaSorting: [[ 5, "asc" ]],
            aoColumnDefs: [{ sType: "allnumeric", aTargets: [ 5, 6, 8, 10, 11, 12, 13 ] } ]
        });
        if (totalNumberOfResults >= 1000)  {
            $('#warnIfMoreThan1000Results').html("<p>"+
                "<em>Your search generated more than 1,000 variants."+
                "This portal currently displays only 1,000 at a time."+
                "Please refine your search. </em>"+
            "</p>")
        }

    }
    console.log('fillThe Fields');
},
    determineEffectsTypeHeader: function (data) {
        var returnValue = 'odds ratio';
        if ((data) && (data.length > 0)) {
            if (data[0].BETA) {
                returnValue = 'beta';
            } else if (data[0].ZSCORE){
                returnValue = 'zscore';
            }
        }
        return returnValue;
    },
    fillPhenotypicTraitTable:  function ( vRec, show_gene, show_sigma, show_exseq, show_exchp ) {
        var retVal = "";
        if (!vRec) {   // error condition
            return;
        }
        var effectsType = UTILS.determineEffectsTypeHeader (vRec);
        var effectsField = 'ODDS_RATIO';
        if (effectsType ==='beta'){
            effectsField = 'BETA';
        } if (effectsType ==='zscore'){
            effectsField = 'ZSCORE';
        }

        for (var i = 0; i < vRec.length; i++) {

            var variant = vRec [i] ;
            retVal += "<tr>"

            var pValueGreyedOut = (variant.PVALUE > .05)? "greyedout" :"normal";

            retVal += "<td><a class='boldlink' href='../variant/variantInfo/"+ variant.DBSNP_ID+"'>"+ variant.DBSNP_ID+"</a></td>";

            retVal += "<td><a class='boldItlink' href='../gene/geneInfo/"+ variant.CLOSEST_GENE+"'>"+ variant.CLOSEST_GENE+"</a></td>";

            retVal += "<td>"+ variant.PVALUE.toPrecision(3)+"</td>";

            retVal += "<td class='" +pValueGreyedOut+ "'>"+ variant[effectsField].toPrecision(3)+"</td>";

            retVal += "<td>";
            if (variant.MAF) {
                retVal += variant.MAF.toPrecision(3);
            }
            retVal += "</td>";

            retVal += "<td><a class='boldlink' href='./traitInfo/"+ variant.DBSNP_ID+"'>click here</a></td>";
        }
        return retVal;
    },
    fillTraitsPerVariantTable:  function ( vRec, show_gene, show_sigma, show_exseq, show_exchp ) {
        var retVal = "";
        if (!vRec) {   // error condition
            return;
        }

        for (var i = 0; i < vRec.length; i++) {

            var trait = vRec [i] ;
            retVal += "<tr>"

            retVal += "<td>" +trait.TRAIT+"</td>";

            retVal += "<td>" +(trait.PVALUE.toPrecision(3))+"</td>";

            retVal += "<td>";
            if (trait.DIR === "up") {
                retVal += "<span class='assoc-up'>&uarr;</span>";
            } else if (trait.DIR === "down") {
                retVal += "<span class='down-up'>&darr;</span>";
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






        };