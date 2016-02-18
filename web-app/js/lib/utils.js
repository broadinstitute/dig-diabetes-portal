var mpgSoftware = mpgSoftware || {};

var UTILS = {
    /***
     * General-purpose utility that JavaScript ought to have.
     * @param map
     * @returns {{}}
     */
    invertMap: function (map) {
        var inv = {};
        var keys = Object.keys(map);
        for (var i = 0; i < keys.length; i++) {
            if (map[keys[i]]) {
                inv[map[keys[i]]] = keys[i];
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
    concatMap: function (workingMap, mapFromWhichWeExtract) {
        if (typeof(workingMap) === "undefined") {
            workingMap = {};
        }
        if (mapFromWhichWeExtract)
            var keys = Object.keys(mapFromWhichWeExtract);
        if (typeof keys !== 'undefined') {
            for (var i = 0; i < keys.length; i++) {
                workingMap[keys[i]] = mapFromWhichWeExtract [keys[i]];
            }
        }
        return workingMap;
    },
    /***
     * Everyone seems to use three digits of precision. I wonder why
     * @param incoming
     * @returns {string}
     */
    realNumberFormatter: function (incoming) {
        var returnValue = "(null)";
        if (incoming !=  null ){
            var value = parseFloat(incoming);
            returnValue = value.toPrecision(3);
        }
        return returnValue;
    },
    convertStringToNumber: function (incoming) {
        var returnValue = null;
        if (incoming !=  null ){
            return parseFloat(incoming);
        } else {
            return  null;
        }
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
    proteinEffectListConstructor: function (inString, helpText) {
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
    retrieveSampleGroupsbyTechnologyAndPhenotype : function(technologies,phenotype, actionUrl, callBack, passThru){
        var phenotypeName = phenotype;
        var passThruValues = passThru;
        var compareDatasetsByTechnology = function (a, b) {
            if (a.technology < b. technology) return -1;
            if (a.technology > b. technology) return 1;
            return 0;
        }
        $.ajax({
            cache: false,
            type: "post",
            url: actionUrl,
            data: {phenotype:phenotype,
                technologies: technologies},
            async: true,
            success: function (data) {
                if (( data !==  null ) &&
                    ( typeof data !== 'undefined') &&
                    ( typeof data.sampleGroupMap !== 'undefined' )  ) {
                    var sampleGroupMap = data.sampleGroupMap;
                    if (typeof sampleGroupMap !== 'undefined'){
                        var dataSetNames =  Object.keys(sampleGroupMap);
                        var dataSetArray = [];
                        for (var i = 0; i < dataSetNames.length; i++) {
                            dataSetArray.push(sampleGroupMap[dataSetNames[i]]);
                        }
                        var sortedDataSetArray = dataSetArray.sort(compareDatasetsByTechnology);
                        var dataSetPropertyValues = [];
                        for (var i = 0; i < sortedDataSetArray.length; i++) {
                            if (sortedDataSetArray[i]) {
                                dataSetPropertyValues.push(sortedDataSetArray[i]);
                            }
                        }
                        callBack (phenotypeName,dataSetPropertyValues,passThruValues);

                    }
                }
            },
            error: function (jqXHR, exception) {
                core.errorReporter(jqXHR, exception);
            }
        });
    },
    frequencyCharacterization: function (proportion, cutoffs) {
        var retVal = "";
        if (proportion === 0) {
            retVal += "unobserved";
        }
        else if (( proportion > 0) && ( proportion < 0)) {
            retVal += "private";
        }   // this is a strange conditional.  TODO is this really the right way to make this comparison?
        else if (( proportion > cutoffs[0]) && ( proportion < cutoffs[1])) {
            retVal += "rare";
        }
        else if (( proportion >= cutoffs[1] ) && ( proportion < cutoffs[2])) {
            retVal += "low frequency";
        }
        else if (( proportion >= cutoffs[2] )) {
            retVal += "common";
        }
        return retVal;
    },
    get_variant_repr: function (v) {
        return v.CHROM + ':' + v.POS;
    },

    /***
     * We need a name for the variant
     * @param v
     * @param emergencyTitle
     * @returns {*}
     */
    get_variant_title: function (v, emergencyTitle) {
        var variantName;
        if (v) {
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
    variantInfoHeaderSentence: function (inGene,closestGene,gene,liesInString,isNearestToString) {
        var returnValue = "";
        if (inGene) {
            returnValue += (liesInString+" <a href='../../gene/geneInfo/"+gene+"'>" + gene + "</a>");
        } else {
            returnValue += (isNearestToString+" <a href='../../gene/geneInfo/"+closestGene+"'>" + closestGene + "</a>");
        }
        return  returnValue;
    },
    get_highest_frequency: function (v) {
        var max = 0;
        var max_pop = '';
        _.each(['AA', 'EA', 'SA', 'EU', 'HS'], function (k) {
            var af = v['_13k_T2D_' + k + '_MAF'];
            if (af > max) {
                max = af;
                max_pop = k;
            }
        });
        return [max, max_pop];
    },

    get_simple_variant_effect: function (v) {
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

    getSimpleVariantsEffect: function (vMOST_DEL_SCORE) {
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

    get_significance_text: function (significance) {
        if (significance < 5e-8) {
            return 'genome-wide';
        } else if (significance < 5e-2) {
            return 'nominal';
        } else {
            return
        }
    },

    // try map way of doing it
    // pass in sequencing tech as key, p-value as value
    get_lowest_p_value_from_map: function (pValueMap) {
        // map has sequencing tech as key, p-value as value
        var pValue = 1;
        var dataType = '';

        for (var key in pValueMap) {
            if (pValueMap.hasOwnProperty(key)) {
                var pValueTemp = pValueMap[key];
                if ((pValueTemp != null) && (pValueTemp < pValue)) {
                    pValue = pValueMap[key];
                    dataType = key;
                }
            }
        }
        return [pValue, dataType];
    },

    get_lowest_p_value: function (variant) {
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
        for (var i = 0; i < ethnicAbbreviation.length; i++) {
            if (shortName === (ethnicAbbreviation [i])) break;
        }
        if (i < ethnicityFullName.length) {
            retVal = ethnicityFullName [i];
        } else {
            retVal = shortName;
        }
        return  retVal;
    },

    get_consequence_names: function (variant) {
        if (!variant.Consequence) return [];
        var keys = variant.Consequence.split(';');
        var names = [];
        _.each(keys, function (k) {
            if (!k) return;
            var consequence = _.find(CONSTANTS.so_consequences, function (c) {
                return c.key == k
            });
            if (consequence) {
                names.push(consequence.name);
            } else {
                names.push(k);
            }
        });
        return names;
    },

    fillAssociationsStatistics: function (variant, vMap, availableData, pValue, strongCutOff, weakCutOff, variantTitle, textStrongLine1, textStrongLine2, textMediumLine, textWeakLine, noDataLine) {
        var retVal = "";
        var iMap = UTILS.invertMap(vMap);
        if (variant[iMap[availableData]]) {
            retVal += "<p>";
            // may or may not be bold
            if (variant[iMap[pValue]] <= strongCutOff) {
                retVal += "<strong>";
            }
            // always needs descr
            retVal += (textStrongLine1 + " " + variantTitle + " ");
            if (variant[iMap[pValue]] <= strongCutOff) {
                retVal += textStrongLine2;
            }
            if (variant[iMap[pValue]] > strongCutOff && variant[iMap[pValue]] <= weakCutOff) {
                retVal += textMediumLine;
            }
            if (variant[iMap[pValue]] > weakCutOff) {
                retVal += textWeakLine;
            }
            if (variant[iMap[pValue]] <= strongCutOff) {
                retVal += "</strong>";
            }
            retVal += "</p>" +
                "<ul>" +
                "<li>p-value from this analysis: " + variant[iMap[pValue]] + "</li>" +
                "</ul>";
        } else {
            retVal += noDataLine;
        }
        return retVal;
    },
    verifyThatDisplayIsWarranted: function (fieldToTest, divToDisplayIfWeHaveData, giveToDisplayIfWeHaveNoData) {
        if (!fieldToTest) {
            divToDisplayIfWeHaveData.hide();
            giveToDisplayIfWeHaveNoData.show();
        } else {
            divToDisplayIfWeHaveData.show();
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
        $('#ensembleSoAnnotation').html('<strong>' + Consequence + '</strong>');
        if (delScore === 1) {
            $('#variantTruncateProtein').html('<strong>yes</strong>');
        } else {
            $('#variantTruncateProtein').html('<strong>no</strong>');
        }
        $('#polyPhenPrediction').html('<strong>' + PolyPhen_PRED + '</strong>,<strong>' + PolyPhen_SCORE + '</strong>');
        $('#siftPrediction').html('<strong>' + SIFT_PRED + '</strong>,<strong>' + SIFT_SCORE + '</strong>');
        $('#condelPrediction').html('<strong>' + Condel_PRED + '</strong>,<strong>' + Condel_SCORE + '</strong>');
        if (delScore === 2) {
            $('#mostDeleteScoreEquals2').css('display', 'block');
        } else {
            $('#mostDeleteScoreEquals2').css('display', 'none');
        }
        if (delScore < 4) {
            $('#variationInfoEncodedProtein').css('display', 'block');
            $('#puntOnNoncodingVariant').css('display', 'none');
        } else {
            $('#variationInfoEncodedProtein').css('display', 'none');
            $('#puntOnNoncodingVariant').css('display', 'block');
        }

    },
    variantGenerateProteinsChooser: function (variant, title) {
        var retVal = "";
        if (variant.MOST_DEL_SCORE && variant.MOST_DEL_SCORE < 4) {
            retVal += "<h2><strong>What effect does " + title + " have on the encoded protein?</strong></h2>\n" +
                "<p>Choose one transcript below to see the predicted effect on the protein:</p>";
            var allKeys = Object.keys(variant._13k_T2D_TRANSCRIPT_ANNOT);
            for (var i = 0; i < allKeys.length; i++) {
                var checked = (i == 0) ? ' checked ' : '';
                var annotation = variant._13k_T2D_TRANSCRIPT_ANNOT[allKeys[i]];
                retVal += ("<div class=\"radio-inline\">\n" +
                    "<label>\n" +
                    "<input " + checked + " class='transcript-radio' type='radio' name='transcript_check' id='transcript-" + allKeys[i] +
                    "' value='" + allKeys[i] + "' onclick='UTILS.variantInfoRadioChange(" +
                    "\"" + annotation['PolyPhen_SCORE'] + "\"," +
                    "\"" + annotation['SIFT_SCORE'] + "\"," +
                    "\"" + annotation['Condel_SCORE'] + "\"," +
                    "\"" + annotation['MOST_DEL_SCORE'] + "\"," +
                    "\"" + annotation['_13k_ANNOT_29_mammals_omega'] + "\"," +
                    "\"" + annotation['Protein_position'] + "\"," +
                    "\"" + annotation['Codons'] + "\"," +
                    "\"" + annotation['Protein_change'] + "\"," +
                    "\"" + annotation['PolyPhen_PRED'] + "\"," +
                    "\"" + annotation['Consequence'] + "\"," +
                    "\"" + annotation['Condel_PRED'] + "\"," +
                    "\"" + annotation['SIFT_PRED'] + "\"" +
                    ")' >\n" +
                    allKeys[i] + "\n" +
                    "</label>\n" +
                    "</div>\n");
            }
            if (allKeys.length > 0) {
                var annotation = variant._13k_T2D_TRANSCRIPT_ANNOT[allKeys[0]];
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
                    annotation['SIFT_PRED']);

            }


        }
        return retVal;
    },
    geneFieldOrZero: function (geneInfo, filedNumber, defaultValue) {
        var retval = 0;
        var fieldName = revG(filedNumber);
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


    prettyUpSigmaSource: function (rawText) {
        var returnValue;
        if (rawText === 'EXOME_CHIP') {
            returnValue = 'exome chip';
        } else if (rawText === 'OMNI') {
            returnValue = 'omni';
        } else if (rawText === 'EXOMES') {
            returnValue = 'exomes';
        } else {
            returnValue = rawText;
        }
        return returnValue;
    },

    extractAlleleFrequencyRanges: function (allFields) {
        var returnValue = {};
        var differentEthnicities = ['AA', 'EA', 'SA', 'EU', 'HS'];
        var minMax = ['min', 'max'];
        for (var i = 0; i < differentEthnicities.length; i++) {
            for (var j = 0; j < minMax.length; j++) {
                var idValue = 'ethnicity_af_' + differentEthnicities[i] + '-' + minMax[j];
                returnValue[idValue] = $('#' + idValue).val();
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
    extractValFromCheckboxes: function (everyId) {
        var returnValue = {};
        for (var i = 0; i < everyId.length; i++) {
            var domReference = $('#' + everyId[i]);
            if ((domReference) &&
                (domReference.is(':checked'))) {
                returnValue [domReference.val()] = 1;
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
    extractValFromTextboxes: function (everyId) {
        var returnValue = {};
        for (var i = 0; i < everyId.length; i++) {
            var domReference = $('#' + everyId[i]);
            if ((domReference) && (domReference.val())) {
                returnValue [everyId[i]] = domReference.val();
            }
        }
        return returnValue;
    },
    extractValsFromCombobox: function (everyId) {
        var returnValue = {};
        for (var i = 0; i < everyId.length; i++) {
            var domReference = $('#' + everyId[i]);
            if ((domReference) && (domReference.val())) {
                returnValue [everyId[i]] = domReference.val();
            }
        }
        return returnValue;
    },
    fillPhenotypeDropdown: function (dataSetJson,phenotypeDropDownIdentifier) { // help text for each row
        if ((typeof dataSetJson !== 'undefined')  &&
            (typeof dataSetJson["is_error"] !== 'undefined')&&
            (dataSetJson["is_error"] === false))
        {
            var numberOfRecords = parseInt (dataSetJson ["numRecords"]);
            var options = $(phenotypeDropDownIdentifier);
            options.empty();
            var dataSetList = dataSetJson ["dataset"];
            for ( var i = 0 ; i < numberOfRecords ; i++ ){
                options.append($("<option />").val(dataSetList[i]).text(mpgSoftware.trans.translator(dataSetList[i])));
            }
        }
    },
    fillPhenotypeCompoundDropdown: function (dataSetJson,phenotypeDropDownIdentifier,includeDefault) { // help text for each row
        if ((typeof dataSetJson !== 'undefined')  &&
            (typeof dataSetJson["is_error"] !== 'undefined')&&
            (dataSetJson["is_error"] === false))
        {
            console.log("filling the phenotype dropdown", dataSetJson);
            var numberOfRecords = parseInt (dataSetJson ["numRecords"]);
            var options = $(phenotypeDropDownIdentifier);
            options.empty();
            var groupList = dataSetJson ["dataset"];

            if ((typeof includeDefault !== 'undefined') &&
                (includeDefault)){
                options.append("<option selected hidden>-- &nbsp;&nbsp;select a phenotype&nbsp;&nbsp; --</option>");
            }

            for (var key in groupList) {
                if (groupList.hasOwnProperty(key)) {
                    if (key==='GLYCEMIC')  {
                        var groupContents = groupList[key];
                        options.append("<optgroup label='"+key+"'>");
                        for (var j = 0; j < groupContents.length; j++) {
                            options.append($("<option />").val(groupContents[j]).text(mpgSoftware.trans.translator(groupContents[j])));
                        }
                        options.append("</optgroup>");
                    }
                }
            }
            for (var key in groupList) {
                if (groupList.hasOwnProperty(key)) {
                    if (key!=='GLYCEMIC')  {
                        var groupContents = groupList[key];
                        options.append("<optgroup label='"+key+"'>");
                        for (var j = 0; j < groupContents.length; j++) {
                            options.append($("<option />").val(groupContents[j]).text(mpgSoftware.trans.translator(groupContents[j])));
                        }
                        options.append("</optgroup>");
                    }
                }
            }

        }
    },

    /***
     * We need to make sure that all the fields have values before starting the plotting routines. I'll formalize
     * this check, and cover both nulls and undefined
     * @param variant
     * @param fieldNameArray
     */
    nullsExist: function (variant, fieldNameArray) {
        var returnValue = false;
        //First take care of the pathological cases
        if (typeof variant === 'undefined') {
            return true;
        }
        if (typeof fieldNameArray === 'undefined') {
            return false;
        }
        for (var i = 0; i < fieldNameArray.length; i++) {
            if ((variant[fieldNameArray[i]] === null) ||
                (typeof variant[fieldNameArray[i]] === 'undefined')) {
                returnValue = true;
                break;
            }
        }
        return returnValue;
    },
    nullSafetyTest: function (fieldArray) {
        var returnValue = false;
        //First take care of the pathological cases
        if (typeof fieldArray === 'undefined') {
            return false;
        }
        for (var i = 0; i < fieldArray.length; i++) {
            if ((fieldArray[i] === null) ||
                (typeof fieldArray[i] === 'undefined') ||
                isNaN(fieldArray[i])) {
                returnValue = true;
                break;
            }
        }
        return returnValue;
    },
    /***
     * general-purpose way of posting a query. Fake a bunch of hidden variables to store
     * everything in the object params.
     * @param path
     * @param params
     * @param method
     */
    postQuery: function (path, params, method) {
        method = method || "post"; // Set method to post by default if not specified.

        var form = document.createElement("form");
        form.setAttribute("method", method);
        form.setAttribute("action", path);

        if (typeof params !== 'undefined') {
            for (var key in params) {
                if (params.hasOwnProperty(key)) {
                    var hiddenField = document.createElement("input");
                    hiddenField.setAttribute("type", "hidden");
                    hiddenField.setAttribute("name", key);
                    hiddenField.setAttribute("value", params[key]);

                    form.appendChild(hiddenField);
                }
            }
        }

        document.body.appendChild(form);
        form.submit();
    },
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

    },
    determineEffectsTypeHeader: function (data) {
        var returnValue = 'odds ratio';
        if ((data) && (data.length > 0)) {
            if (data[0].BETA) {
                returnValue = 'beta';
            } else if (data[0].ZSCORE) {
                returnValue = 'zscore';
            }
        }
        return returnValue;
    },
    determineEffectsTypeString: function (effectsType) {
        var effectsField = 'ODDS_RATIO';
        if (effectsType === 'beta') {
            effectsField = 'BETA';
        }
        if (effectsType === 'zscore') {
            effectsField = 'ZSCORE';
        }
        return effectsField;
    },

    /***
     * I don't think this is used anymore
     * @param vRec
     * @param show_gene
     * @param show_exseq
     * @param show_exchp
     * @returns {string}
     */
    fillPhenotypicTraitTable: function (vRec, show_gene, show_exseq, show_exchp) {
        var retVal = "";
        if (!vRec) {   // error condition
            return;
        }
        var effectsType = UTILS.determineEffectsTypeHeader(vRec);
        var effectsField = 'ODDS_RATIO';
        if (effectsType === 'beta') {
            effectsField = 'BETA';
        }
        if (effectsType === 'zscore') {
            effectsField = 'ZSCORE';
        }

        for (var i = 0; i < vRec.length; i++) {

            var variant = vRec [i];
            retVal += "<tr>"

            var pValueGreyedOut = (variant.PVALUE > .05) ? "greyedout" : "normal";

            retVal += "<td><a class='boldlink' href='../variant/variantInfo/" + variant.DBSNP_ID + "'>" + variant.DBSNP_ID + "</a></td>";

            retVal += "<td><a class='boldItlink' href='../gene/geneInfo/" + variant.CLOSEST_GENE + "'>" + variant.CLOSEST_GENE + "</a></td>";

            retVal += "<td>" + variant.PVALUE.toPrecision(3) + "</td>";

            retVal += "<td class='" + pValueGreyedOut + "'>" + variant[effectsField].toPrecision(3) + "</td>";

            retVal += "<td>";
            if (variant.MAF) {
                retVal += variant.MAF.toPrecision(3);
            }
            retVal += "</td>";

            retVal += "<td><a class='boldlink' href='./traitInfo/" + variant.DBSNP_ID + "'>click here</a></td>";
        }
        return retVal;
    },

    extractAnchorTextAsInteger : function (fullAnchor){
        var returnValue = 0;
        var re = new RegExp("\>[0-9]+\<"); // retrieve text, but with angle brackets
        var re2 = new RegExp("[0-9]+"); // specifically get the presumed integer
        if (typeof fullAnchor !== 'undefined') {
            var textWithAngles = fullAnchor.match(re);
            if ( (typeof textWithAngles !== 'undefined') &&
                (textWithAngles.length > 0) ) {
                var textWithoutAngles = textWithAngles[0].match(re2);
                if ( (typeof textWithoutAngles !== 'undefined') &&
                    (textWithoutAngles.length > 0) ) {
                    var textWeWant = textWithoutAngles[0];
                    returnValue = parseInt (textWeWant,10);
                }
            }
        }
        return returnValue;
    },
    extractHeaderTextAsString : function (fullAnchor){
        var returnValue = 0;
        var re = new RegExp("vandaRow[0-9]+"); // retrieve text that identifies node
        if (typeof fullAnchor !== 'undefined') {
            var nodeName = fullAnchor.match(re);
            if ( (typeof nodeName !== 'undefined') &&
                (nodeName.length > 0) ) {
                // var sampleGroupNamePlus = $('#'+nodeName[0]+'>ul>li').attr('id');
                var sampleGroupNamePlus = $('#'+nodeName[0]).attr('datasetname');
                if ( (typeof sampleGroupNamePlus !== 'undefined') &&
                    (sampleGroupNamePlus.length > 0) ) {
                    // var sampleGroupName = sampleGroupNamePlus.substring(0,sampleGroupNamePlus.indexOf('-'));
                    var sampleGroupName = sampleGroupNamePlus;
                    returnValue = mpgSoftware.trans.translator(sampleGroupName);
                }
            }
        }
        return returnValue;
    },
    extractConHeaderTextAsString : function (fullAnchor){
        var returnValue = 0;
        var re = new RegExp("mafTableRow[0-9]+"); // retrieve text that identifies node
        if (typeof fullAnchor !== 'undefined') {
            var nodeName = fullAnchor.match(re);
            if ( (typeof nodeName !== 'undefined') &&
                (nodeName.length > 0) ) {
                var sampleGroupNamePlus = $('#'+nodeName[0]).attr('datasetname');
                if ( (typeof sampleGroupNamePlus !== 'undefined') &&
                    (sampleGroupNamePlus.length > 0) ) {
                    var sampleGroupName = sampleGroupNamePlus;
                    returnValue = mpgSoftware.trans.translator(sampleGroupName);
                }
            }
        }
        return returnValue;
    },
    jsTreeDataRetriever : function (divId,tableId,phenotypeName,sampleGroupName,retrieveJSTreeAjax){
        var dataPasser = {phenotype:phenotypeName,sampleGroup:sampleGroupName};
        $(divId).jstree({
            "core" : {
                "animation" : 0,
                "check_callback" : true,
                "themes" : { "stripes" : false },
                'data' : {
                    'type': "post",
                    'url' :  retrieveJSTreeAjax,
                    'data': function (c,i) {
                        return dataPasser;
                    },
                    'metadata': dataPasser
                }
            },
            "checkbox" : {
                "keep_selected_style" : false,
                "three_state": false
            },
            "plugins" : [  "themes","core", "wholerow", "checkbox", "json_data", "ui", "types"]
        });
        $(divId).on ('after_open.jstree', function (e, data) {
            for ( var i = 0 ; i < data.node.children.length ; i++ )  {
                $(divId).jstree("select_node", '#'+data.node.children[i]+' .jstree-checkbox', true);
            }
        }) ;
        $(divId).on ('load_node.jstree', function (e, data) {
            var existingNodes = $(tableId+' td.vandaRowTd div.vandaRowHdr');
            var sgsWeHaveAlready = [];
            for ( var i = 0 ; i < existingNodes.length ; i++ ){
                var currentDiv = $(existingNodes[i]);
                sgsWeHaveAlready.push(currentDiv.attr('datasetname'));
            }
            var listToDelete = [];
            for ( var i = 0 ; i < data.node.children_d.length ; i++ )  {
                var nodeId =  data.node.children_d[i];
                if (data.node.children.indexOf(nodeId)==-1){ // elements in children_d and NOT children are actual child nodes.
                    // Elements in children can be self pointers for a node, which we don't want to delete
                    var sampleGroupName = nodeId.substring(0,nodeId.indexOf('-'));
                    if (sgsWeHaveAlready.indexOf(sampleGroupName)>-1){
                        listToDelete.push(data.node.children_d[i]);
                    }
                }
            }
            for ( var i = 0 ; i < listToDelete.length ; i++ )  {
                $(divId).jstree("delete_node", listToDelete[i]);
            }

        });


    }





};


(function () {
    "use strict";


    mpgSoftware.trans = (function () {

        var translations;
        var translator = function (incoming) {
            console.log("translating", incoming);
            var returnValue='';
            if (typeof incoming !== 'undefined') {
                var newForm = translations['v' + incoming];
                if (typeof newForm === 'undefined') {
                    console.log('No translation for ' + incoming);
                    returnValue = incoming;
                } else {
                    returnValue = newForm;
                }
            }
            return returnValue;
        };
        var abbrevtrans = function (incoming, sizeLimit) {
            var returnValue=translator(incoming);
            if ((typeof returnValue !== 'undefined') &&
                (returnValue !== null) &&
                (returnValue))
                return returnValue;
        };

        translations = {
            vT2D: "type 2 diabetes",
            vBMI: "BMI",
            vCHOL: "cholesterol",
            vDBP: "diastolic blood pressure",
            vFG: "fasting glucose",
            vFI: "fasting insulin",
            vHBA1C: "HbA1c",
            vHDL: "HDL cholesterol",
            vHEIGHT: "height",
            vHIPC: "hip circumference",
            vLDL: "LDL cholesterol",
            vSBP: "systolic blood pressure",
            vTG: "triglycerides",
            vWAIST: "waist circumference",
            vWHR: "waist-hip ratio",
            vCAD: "coronary artery disease",
            vCKD: "chronic kidney disease",
            vUACR: "urinary albumin-to-creatinine ratio",
            veGFRcrea: "eGFR-creat (serum creatinine)",
            veGFRcys: "eGFR-cys (serum cystatin C)",
            vTC: "total cholesterol",
            v2hrG: "two-hour glucose",
            v2hrI: "two-hour insulin",
            vHOMAB: "HOMA-B",
            vHOMAIR: "HOMA-IR",
            vMA: "microalbuminuria",
            vPI: "proinsulin levels",
            vBIP: "bipolar disorder",
            vMDD: "major depressive disorder",
            vSCZ: "schizophrenia",
            vSTRK: "stroke",
            v13k: "13K exome sequence analysis",
            v13k_aa_genes: "13K exome sequence analysis: African-Americans",
            v13k_ea_genes: "13K exome sequence analysis: East Asians",
            v13k_eu: "13K exome sequence analysis: Europeans",
            v13k_eu_genes: "13K exome sequence analysis: Europeans, T2D-GENES cohorts",
            v13k_eu_go: "13K exome sequence analysis: Europeans, GoT2D cohorts",
            v13k_hs_genes: "13K exome sequence analysis: Latinos",
            v13k_sa_genes: "13K exome sequence analysis: South Asians",
            v17k: "17K exome sequence analysis",
            v17k_aa: "17K exome sequence analysis: African-Americans",
            v17k_aa_genes: "17K exome sequence analysis: African-Americans, T2D-GENES cohorts",
            v17k_aa_genes_aj: "17K exome sequence analysis: African-Americans, Jackson Heart Study cohort",
            v17k_aa_genes_aw: "17K exome sequence analysis: African-Americans, Wake Forest Study cohort",
            v17k_ea_genes: "17K exome sequence analysis: East Asians",
            v17k_ea_genes_ek: "17K exome sequence analysis: East Asians, Korea Association Research Project (KARE) and Korean National Institute of Health (KNIH) cohort",
            v17k_ea_genes_es: "17K exome sequence analysis: East Asians, Singapore Diabetes Cohort Study and Singapore Prospective Study Program cohort",
            v17k_eu: "17K exome sequence analysis: Europeans",
            v17k_eu_genes: "17K exome sequence analysis: Europeans, T2D-GENES cohorts",
            v17k_eu_genes_ua: "17K exome sequence analysis: Europeans, Longevity Genes in Founder Populations (Ashkenazi) cohort",
            v17k_eu_genes_um: "17K exome sequence analysis: Europeans, Metabolic Syndrome in Men (METSIM) Study cohort",
            v17k_eu_go: "17K exome sequence analysis: Europeans, GoT2D cohorts",
            v17k_hs: "17K exome sequence analysis: Latinos",
            v17k_hs_genes: "17K exome sequence analysis: Latinos, T2D-GENES cohorts",
            v17k_hs_genes_ha: "17K exome sequence analysis: Latinos, San Antonio cohort",
            v17k_hs_genes_hs: "17K exome sequence analysis: Latinos, Starr County cohort",
            v17k_hs_sigma: "17K exome sequence analysis: Latinos, SIGMA cohorts",
            v17k_hs_sigma_mec: "17K exome sequence analysis: Multiethnic Cohort (MEC)",
            v17k_hs_sigma_mexb1: "17K exome sequence analysis: UNAM/INCMNSZ Diabetes Study (UIDS) cohort",
            v17k_hs_sigma_mexb2: "17K exome sequence analysis: Diabetes in Mexico Study (DMS) cohort",
            v17k_hs_sigma_mexb3: "17K exome sequence analysis: Mexico City Diabetes Study (MCDS) cohort",
            v17k_sa_genes: "17K exome sequence analysis: South Asians",
            v17k_sa_genes_sl: "17K exome sequence analysis: South Asians, LOLIPOP cohort",
            v17k_sa_genes_ss: "17K exome sequence analysis: South Asians, Singapore Indian Eye Study cohort",
            v26k: "26K exome sequence analysis",
            v26k_aa: "26K exome sequence analysis: all African-Americans",
            v26k_aa_esp: "26K exome sequence analysis: African-Americans, all ESP cohorts",
            v26k_aa_genes: "26K exome sequence analysis: African-Americans, T2D-GENES cohorts",
            v26k_aa_genes_aj: "26K exome sequence analysis: African-Americans, Jackson Heart Study cohort",
            v26k_aa_genes_aw: "26K exome sequence analysis: African-Americans, Wake Forest Study cohort",
            v26k_ea_genes: "26K exome sequence analysis: East Asians",
            v26k_ea_genes_ek: "26K exome sequence analysis: East Asians, Korea Association Research Project (KARE) and Korean National Institute of Health (KNIH) cohort",
            v26k_ea_genes_es: "26K exome sequence analysis: East Asians, Singapore Diabetes Cohort Study and Singapore Prospective Study Program cohort",
            v26k_eu: "26K exome sequence analysis: Europeans",
            v26k_eu_esp: "26K exome sequence analysis: Europeans, all ESP cohorts",
            v26k_eu_genes: "26K exome sequence analysis: Europeans, T2D-GENES cohorts",
            v26k_eu_genes_ua: "26K exome sequence analysis: Europeans, Longevity Genes in Founder Populations (Ashkenazi) cohort",
            v26k_eu_genes_um: "26K exome sequence analysis: Europeans, Metabolic Syndrome in Men (METSIM) Study cohort",
            v26k_eu_go: "26K exome sequence analysis: Europeans, GoT2D cohorts",
            v26k_eu_lucamp: "26K exome sequence analysis: Europeans, LuCamp cohort",
            v26k_hs: "26K exome sequence analysis: Latinos",
            v26k_hs_genes: "26K exome sequence analysis: Latinos, T2D-GENES cohorts",
            v26k_hs_genes_ha: "26K exome sequence analysis: Latinos, San Antonio cohort",
            v26k_hs_genes_hs: "26K exome sequence analysis: Latinos, Starr County cohort",
            v26k_hs_sigma: "26K exome sequence analysis: Latinos, SIGMA cohorts",
            v26k_hs_sigma_mec: "26K exome sequence analysis: Multiethnic Cohort (MEC)",
            v26k_hs_sigma_mexb1: "26K exome sequence analysis: UNAM/INCMNSZ Diabetes Study (UIDS) cohort",
            v26k_hs_sigma_mexb2: "26K exome sequence analysis: Diabetes in Mexico Study (DMS) cohort",
            v26k_hs_sigma_mexb3: "26K exome sequence analysis: Mexico City Diabetes Study (MCDS) cohort",
            v26k_sa_genes: "26K exome sequence analysis: South Asians",
            v26k_sa_genes_sl: "26K exome sequence analysis: South Asians, LOLIPOP cohort",
            v26k_sa_genes_ss: "26K exome sequence analysis: South Asians, Singapore Indian Eye Study cohort",
            v82k: "82K exome chip analysis",
            vAfrican_American: "African-American",
            vBETA: "effect size (beta)",
            vCARDIoGRAM: "CARDIoGRAM GWAS",
            vCHROM: "chromosome",
            vCKDGenConsortium: "CKDGen GWAS",
            vCLOSEST_GENE: "nearest gene",
            vCondel_PRED: "condel prediction",
            vConsequence: "consequence",
            vDBSNP_ID: "dbSNP ID",
            vDIAGRAM: "DIAGRAM GWAS",
            vDirection: "direction of effect",
            vDIR: "direction of effect",
            vEAC_PH: "effect allele count",
            vEAF: "effect allele frequency",
            vEast_Asian: "East Asian",
            vEuropean: "European",
            vExChip: "exome chip",
            vExChip_82k: "82k exome chip analysis",
            vExChip_82k_mdv1: "82k exome chip analysis",
            vExChip_82k_mdv2: "82k exome chip analysis",
            vExChip_SIGMA1_mdv1: "SIGMA exome chip analysis",
            vExChip_SIGMA1_mdv2: "SIGMA exome chip analysis",
            vExChip_SIGMA1_mdv3: "SIGMA exome chip analysis",
            vExSeq: "exome sequencing",
            vExSeq_13k: "13K exome sequence analysis",
            vExSeq_13k_aa_genes_mdv1: "13K exome sequence analysis: African-Americans",
            vExSeq_13k_aa_genes_mdv2: "13K exome sequence analysis: African-Americans",
            vExSeq_13k_aa_genes_mdv3: "13K exome sequence analysis: African-Americans",
            vExSeq_13k_ea_genes_mdv1: "13K exome sequence analysis: East Asians",
            vExSeq_13k_ea_genes_mdv2: "13K exome sequence analysis: East Asians",
            vExSeq_13k_ea_genes_mdv3: "13K exome sequence analysis: East Asians",
            vExSeq_13k_eu_genes_mdv1: "13K exome sequence analysis: Europeans, T2D-GENES cohorts",
            vExSeq_13k_eu_go_mdv1: "13K exome sequence analysis: Europeans, GoT2D cohorts",
            vExSeq_13k_eu_mdv1: "13K exome sequence analysis: Europeans",
            vExSeq_13k_eu_mdv2: "13K exome sequence analysis: Europeans",
            vExSeq_13k_eu_mdv3: "13K exome sequence analysis: Europeans",
            vExSeq_13k_hs_genes_mdv1: "13K exome sequence analysis: Latinos",
            vExSeq_13k_hs_genes_mdv2: "13K exome sequence analysis: Latinos",
            vExSeq_13k_hs_genes_mdv3: "13K exome sequence analysis: Latinos",
            vExSeq_13k_mdv1: "13K exome sequence analysis",
            vExSeq_13k_mdv2: "13K exome sequence analysis",
            vExSeq_13k_mdv3: "13K exome sequence analysis",
            vExSeq_13k_sa_genes_mdv1: "13K exome sequence analysis: South Asians",
            vExSeq_13k_sa_genes_mdv2: "13K exome sequence analysis: South Asians",
            vExSeq_13k_sa_genes_mdv3: "13K exome sequence analysis: South Asians",
            vExSeq_17k: "17K exome sequence analysis",
            vExSeq_17k_aa_genes_aj_mdv2: "17K exome sequence analysis: African-Americans, Jackson Heart Study cohort",
            vExSeq_17k_aa_genes_aw_mdv2: "17K exome sequence analysis: African-Americans, Wake Forest Study cohort",
            vExSeq_17k_aa_genes_mdv2: "17K exome sequence analysis: African-Americans, T2D-GENES cohorts",
            vExSeq_17k_aa_mdv2: "17K exome sequence analysis: African-Americans",
            vExSeq_17k_ea_genes_ek_mdv2: "17K exome sequence analysis: East Asians, Korea Association Research Project (KARE) and Korean National Institute of Health (KNIH) cohort",
            vExSeq_17k_ea_genes_es_mdv2: "17K exome sequence analysis: East Asians, Singapore Diabetes Cohort Study and Singapore Prospective Study Program cohort",
            vExSeq_17k_ea_genes_mdv2: "17K exome sequence analysis: East Asians",
            vExSeq_17k_eu_genes_mdv2: "17K exome sequence analysis: Europeans, T2D-GENES cohorts",
            vExSeq_17k_eu_genes_ua_mdv2: "17K exome sequence analysis: Europeans, Longevity Genes in Founder Populations (Ashkenazi) cohort",
            vExSeq_17k_eu_genes_um_mdv2: "17K exome sequence analysis: Europeans, Metabolic Syndrome in Men (METSIM) Study cohort",
            vExSeq_17k_eu_go_mdv2: "17K exome sequence analysis: Europeans, GoT2D cohorts",
            vExSeq_17k_eu_mdv2: "17K exome sequence analysis: Europeans",
            vExSeq_17k_hs_genes_ha_mdv2: "17K exome sequence analysis: Latinos, San Antonio cohort",
            vExSeq_17k_hs_genes_hs_mdv2: "17K exome sequence analysis: Latinos, Starr County cohort",
            vExSeq_17k_hs_genes_mdv2: "17K exome sequence analysis: Latinos, T2D-GENES cohorts",
            vExSeq_17k_hs_mdv2: "17K exome sequence analysis: Latinos",
            vExSeq_17k_hs_sigma_mdv2: "17K exome sequence analysis: Latinos, SIGMA cohorts",
            vExSeq_17k_hs_sigma_mec_mdv2: "17K exome sequence analysis: Multiethnic Cohort (MEC)",
            vExSeq_17k_hs_sigma_mexb1_mdv2: "17K exome sequence analysis: UNAM/INCMNSZ Diabetes Study (UIDS) cohort",
            vExSeq_17k_hs_sigma_mexb2_mdv2: "17K exome sequence analysis: Diabetes in Mexico Study (DMS) cohort",
            vExSeq_17k_hs_sigma_mexb3_mdv2: "17K exome sequence analysis: Mexico City Diabetes Study (MCDS) cohort",
            vExSeq_17k_mdv2: "17K exome sequence analysis",
            vExSeq_17k_sa_genes_mdv2: "17K exome sequence analysis: South Asians",
            vExSeq_17k_sa_genes_sl_mdv2: "17K exome sequence analysis: South Asians, LOLIPOP cohort",
            vExSeq_17k_sa_genes_ss_mdv2: "17K exome sequence analysis: South Asians, Singapore Indian Eye Study cohort",
            vExSeq_26k_mdv3: "26K exome sequence analysis",
            vExSeq_26k_aa_mdv3: "26K exome sequence analysis: all African-Americans",
            vExSeq_26k_aa_esp_mdv3: "26K exome sequence analysis: African-Americans, all ESP cohorts",
            vExSeq_26k_aa_genes_mdv3: "26K exome sequence analysis: African-Americans, T2D-GENES cohorts",
            vExSeq_26k_aa_genes_aj_mdv3: "26K exome sequence analysis: African-Americans, Jackson Heart Study cohort",
            vExSeq_26k_aa_genes_aw_mdv3: "26K exome sequence analysis: African-Americans, Wake Forest Study cohort",
            vExSeq_26k_ea_genes_mdv3: "26K exome sequence analysis: East Asians",
            vExSeq_26k_ea_genes_ek_mdv3: "26K exome sequence analysis: East Asians, Korea Association Research Project (KARE) and Korean National Institute of Health (KNIH) cohort",
            vExSeq_26k_ea_genes_es_mdv3: "26K exome sequence analysis: East Asians, Singapore Diabetes Cohort Study and Singapore Prospective Study Program cohort",
            vExSeq_26k_eu_mdv3: "26K exome sequence analysis: Europeans",
            vExSeq_26k_eu_esp_mdv3: "26K exome sequence analysis: Europeans, all ESP cohorts",
            vExSeq_26k_eu_genes_mdv3: "26K exome sequence analysis: Europeans, T2D-GENES cohorts",
            vExSeq_26k_eu_genes_ua_mdv3: "26K exome sequence analysis: Europeans, Longevity Genes in Founder Populations (Ashkenazi) cohort",
            vExSeq_26k_eu_genes_um_mdv3: "26K exome sequence analysis: Europeans, Metabolic Syndrome in Men (METSIM) Study cohort",
            vExSeq_26k_eu_go_mdv3: "26K exome sequence analysis: Europeans, GoT2D cohorts",
            vExSeq_26k_eu_lucamp_mdv3: "26K exome sequence analysis: Europeans, LuCamp cohort",
            vExSeq_26k_hs_mdv3: "26K exome sequence analysis: Latinos",
            vExSeq_26k_hs_genes_mdv3: "26K exome sequence analysis: Latinos, T2D-GENES cohorts",
            vExSeq_26k_hs_genes_ha_mdv3: "26K exome sequence analysis: Latinos, San Antonio cohort",
            vExSeq_26k_hs_genes_hs_mdv3: "26K exome sequence analysis: Latinos, Starr County cohort",
            vExSeq_26k_hs_sigma_mdv3: "26K exome sequence analysis: Latinos, SIGMA cohorts",
            vExSeq_26k_hs_sigma_mec_mdv3: "26K exome sequence analysis: Multiethnic Cohort (MEC)",
            vExSeq_26k_hs_sigma_mexb1_mdv3: "26K exome sequence analysis: UNAM/INCMNSZ Diabetes Study (UIDS) cohort",
            vExSeq_26k_hs_sigma_mexb2_mdv3: "26K exome sequence analysis: Diabetes in Mexico Study (DMS) cohort",
            vExSeq_26k_hs_sigma_mexb3_mdv3: "26K exome sequence analysis: Mexico City Diabetes Study (MCDS) cohort",
            vExSeq_26k_sa_genes_mdv3: "26K exome sequence analysis: South Asians",
            vExSeq_26k_sa_genes_sl_mdv3: "26K exome sequence analysis: South Asians, LOLIPOP cohort",
            vExSeq_26k_sa_genes_ss_mdv3: "26K exome sequence analysis: South Asians, Singapore Indian Eye Study cohort",
            vFMISS_17k: "missing genotype rate, 17K exome sequence analysis",
            vFMISS_19k: "missing genotype rate, 19K exome sequence analysis",
            vF_MISS: "missing genotype rate",
            vGENE: "gene",
            vGENO_26k: "call rate, 26K exome sequencing analysis",
            vGIANT: "GIANT GWAS",
            vGLGC: "GLGC GWAS",
            vGWAS: "GWAS",
            vGWAS_CARDIoGRAM: "CARDIoGRAM GWAS",
            vGWAS_CARDIoGRAM_mdv1: "CARDIoGRAM GWAS",
            vGWAS_CARDIoGRAM_mdv2: "CARDIoGRAM GWAS",
            vGWAS_CKDGenConsortium: "CKDGen GWAS",
            vGWAS_CKDGenConsortium_mdv1: "CKDGen GWAS",
            vGWAS_CKDGenConsortium_mdv2: "CKDGen GWAS",
            vGWAS_DIAGRAM: "DIAGRAM GWAS",
            vGWAS_DIAGRAM_mdv1: "DIAGRAM GWAS",
            vGWAS_DIAGRAM_mdv2: "DIAGRAM GWAS",
            vGWAS_GIANT: "GIANT GWAS",
            vGWAS_GIANT_mdv1: "GIANT GWAS",
            vGWAS_GIANT_mdv2: "GIANT GWAS",
            vGWAS_GLGC: "GLGC GWAS",
            vGWAS_GLGC_mdv1: "GLGC GWAS",
            vGWAS_GLGC_mdv2: "GLGC GWAS",
            vGWAS_MAGIC: "MAGIC GWAS",
            vGWAS_MAGIC_mdv1: "MAGIC GWAS",
            vGWAS_MAGIC_mdv2: "MAGIC GWAS",
            vGWAS_PGC: "PGC GWAS",
            vGWAS_PGC_mdv1: "PGC GWAS",
            vGWAS_PGC_mdv2: "PGC GWAS",
            vGWAS_SIGMA1_mdv1: "GWAS SIGMA",
            vGWAS_SIGMA1_mdv2: "GWAS SIGMA",
            vGWAS_SIGMA1_mdv3: "GWAS SIGMA",
            vHETA: "number of heterozygous cases",
            vHETU: "number of heterozygous controls",
            vHOMA: "number of homozygous cases",
            vHOMU: "number of homozygous controls",
            vHispanic: "Latino",
            vIN_EXSEQ: "in exome sequencing",
            vIN_GENE: "enclosing gene",
            vLOG_P_HWE_MAX_ORIGIN: "log(p-value), hardy-weinberg equilibrium",
            vMAC: "minor allele count",
            vMAC_PH: "minor allele count",
            vMAF: "minor allele frequency",
            vMAGIC: "MAGIC GWAS",
            vMINA: "case minor allele counts",
            vMINU: "control minor allele counts",
            vMOST_DEL_SCORE: "deleteriousness category",
            vMixed: "mixed",
            vNEFF: "effective sample size",
            vN_PH: "sample size",
            vOBSA: "number of cases genotyped",
            vOBSU: "number of controls genotyped",
            vODDS_RATIO: "odds ratio",
            vOR_FIRTH: "odds ratio",
            vOR_FIRTH_FE_IV: "odds ratio",
            vOR_FISH: "odds ratio",
            vOR_WALD: "odds ratio",
            vOR_WALD_DOS: "odds ratio",
            vOR_WALD_DOS_FE_IV: "odds ratio",
            vOR_WALD_FE_IV: "odds ratio",
            vPGC: "PGC GWAS",
            vPOS: "position",
            vP_EMMAX: "p-value",
            vP_EMMAX_FE_IV: "p-value",
            vP_EMMAX_FE_IV_AW: "p-value",
            vP_FIRTH: "p-value",
            vP_FIRTH_FE_IV: "p-value",
            vP_FIRTH_FE_IV_AW: "p-value",
            vP_FE_INV: "p-value",
            vP_VALUE: "p-value",
            vPolyPhen_PRED: "PolyPhen prediction",
            vProtein_change: "protein change",
            vQCFAIL: "failed quality control",
            vSE: "std. error",
            vSIFT_PRED: "SIFT prediction",
            vSouth_Asian: "South Asian",
            vTRANSCRIPT_ANNOT: "annotations across transcripts",
            vVAR_ID: "variant ID",
            vmdv1: "version 1",
            vmdv2: "version 2",
            vmdv3: "version 3"
        };
        return {translator:translator}
    }());

}());

