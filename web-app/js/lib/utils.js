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
    proteinEffectListConstructor: function (inString,helpText) {
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

    /***
     * We need a name for the variant
     * @param v
     * @param emergencyTitle
     * @returns {*}
     */
    get_variant_title: function(v,emergencyTitle) {
        var variantName;
        if (v){
            if (v.DBSNP_ID) {
                variantName = v.DBSNP_ID;
            } else if (v.ID) {
                variantName = v.ID;
            } else {
                variantName = emergencyTitle;
            }
        } else {
            variantName = emergencyTitle;
        }
        return variantName;
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
            // may or may not be bold
            if (variant[iMap[pValue]] <= strongCutOff ) {
                retVal += "<strong>";
            }
            // always needs descr
            retVal +=  (textStrongLine1 +" "+variantTitle+" ");
            if (variant[iMap[pValue]] <= strongCutOff ) {
                retVal += textStrongLine2;
            }
            if  (variant[iMap[pValue]]  >  strongCutOff  && variant[iMap[pValue]] <=   weakCutOff) {
                retVal += textMediumLine;
            }
            if  (variant[iMap[pValue]]  >  weakCutOff) {
                retVal  += textWeakLine;
            }
            if (variant[iMap[pValue]] <= strongCutOff ) {
                retVal += "</strong>" ;
            }
            retVal +="</p>"+
                   "<ul>"+
                    "<li>p-value from this analysis: "+variant[iMap[pValue]] + "</li>"+
                    "</ul>";
        } else {
            retVal += noDataLine;
        }
        return retVal;
    },


    sigmaVariantCharacterization:  function (variant, title) {
        var retVal = "";
        var euroValue  = parseFloat(variant["SIGMA_T2D_MAF"]) ;
        if (variant["SIGMA_T2D_MAF"]) {
            retVal += ("<p>The minor allele frequency of "+title + " in <em>SIGMA</em> sequencing data is: "+
                (euroValue*100).toPrecision(3)+ " ("+UTILS.frequencyCharacterization(euroValue, [0.000001,0.005,0.05])+ ")");
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
    /***
     * Watch out for this next function.  It is accessed only from variantInfo so you might think that it would belong in
     * variantInfo.js, but there is a trick.  Not only is it used during page set up but as well it is connected through an
     * onClick call back so that it responds to the user hitting a radio button. This means that the method needs to be
     * at once accessible down in the well encapsulated bowels of the JavaScript processing structure, but also needs to be
     * made available for top-level interactive user access. I could certainly achieve this goal by building the method at the
     * lowest level and then having a few calls calls that expose the UI through the layers of encapsulation, but it
     * would be a little messy and this method has quite a few parameters as it is. In this case I think it makes more sense
     * to leave it here in UTILS, though I'd be happy to discuss with any interested software engineers whether or not
     * minimizing complexity should trump minimizing shared API surface area over a beer some time.
     * @param PolyPhen_SCORE
     * @param SIFT_SCORE
     * @param Condel_SCORE
     * @param MOST_DEL_SCORE
     * @param _13k_ANNOT_29_mammals_omega
     * @param Protein_position
     * @param Codons
     * @param Protein_change
     * @param PolyPhen_PRED
     * @param Consequence
     * @param Condel_PRED
     * @param SIFT_PRED
     */
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
    geneFieldOrZero: function (geneInfo,filedNumber,defaultValue) {
    var retval = 0;
    var fieldName  = revG(filedNumber);
    if ((geneInfo)  && (fieldName.length>0)) {
        var fieldBreakdown = fieldName.split("."); // step into complex fields
        retval =   geneInfo[fieldBreakdown[0]];
        if ((retval)&&(fieldBreakdown.length>1)){
            for (  var i = 1 ; i < fieldBreakdown.length ; i++ ) {
                var nextLevelSpec =  fieldBreakdown[i];
                retval =  retval[nextLevelSpec];
            }
        }
    }
    if (!retval) {    // deal with a null.  Use a zero unless we are given an explicit alternative
        if (typeof defaultValue!=="undefined"){
            retval = defaultValue;
        }  else {
            retval=0;
        }
    }
    return retval;
},


    prettyUpSigmaSource:function (rawText){
        var returnValue;
        if (rawText === 'EXOME_CHIP'){
            returnValue = 'exome chip';
        } else if (rawText === 'OMNI'){
            returnValue = 'omni';
        } else if (rawText === 'EXOMES'){
            returnValue = 'exomes';
        }else {
            returnValue = rawText;
        }
        return returnValue;
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
    }





        };