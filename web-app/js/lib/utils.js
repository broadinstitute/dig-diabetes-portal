var mpgSoftware = mpgSoftware || {};

var UTILS = {
    /***
     * Everyone seems to use three digits of precision. I wonder why
     * @param incoming
     * @returns {string}
     */
    realNumberFormatter: function (incoming, precision) {
        // if precision isn't defined, default to 3
        precision = precision || 3;
        var returnValue = "";
        if (incoming !=  null ){
            var value = parseFloat(incoming);
            returnValue = value.toPrecision(precision);
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
    disableClickPropagation: function(event){
        event.stopPropagation();
    },
    /**
     * Parses the input to the specified number of digits, returning a float
     * without trailing zeros
     * @param numberToParse
     * @param precision
     */
    parseANumber: function(numberToParse, precision) {
        // if precision isn't defined, default to 10
        precision = precision || 10;
        var stringedNumber = UTILS.realNumberFormatter(numberToParse, precision);
        return parseFloat(stringedNumber);
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
                    var datasets = _.chain(sampleGroupMap).values().sortBy('technology').value();
                    callBack (phenotypeName,datasets,passThruValues);
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
                options.append($("<option />").val(dataSetList[i]).text(dataSetList[i]));
            }
        }
    },
    // phenotypesToOmit is an array of the phenotype keys that should not be included
    fillPhenotypeCompoundDropdown: function (dataSetJson,phenotypeDropDownIdentifier,includeDefault, phenotypesToOmit,portaltype) { // help text for each row
        if ((typeof dataSetJson !== 'undefined')  &&
            (typeof dataSetJson["is_error"] !== 'undefined')&&
            (dataSetJson["is_error"] === false))
        {
            var options = $(phenotypeDropDownIdentifier);
            options.empty();
            var groupList = dataSetJson.dataset;

            // if ((typeof includeDefault !== 'undefined') &&
            //     (includeDefault)){
            //     options.append("<option selected hidden value=default>-- &nbsp;&nbsp;select a phenotype&nbsp;&nbsp; --</option>");
            // }

            // move GLYCEMIC to the front of the list, so it's the first section
            // to display
            var keys = Object.keys(groupList);
            if(portaltype == "t2d"){
                if (keys.indexOf("GLYCEMIC")>-1){
                    keys.splice(keys.indexOf("GLYCEMIC"), 1);
                    keys.unshift("GLYCEMIC");
                    //$('#datasetDependent').prop( "disabled", false );
                    //var phenotype = UTILS.extractValsFromCombobox(['phenotype']).phenotype;
                    mpgSoftware.variantWF.retrieveDatasets("T2D", 'dependent');

                }
            }
            else if (portaltype == "stroke"){
            if (keys.indexOf("ISCHEMIC STROKE")>-1){
                keys.splice(keys.indexOf("ISCHEMIC STROKE"), 1);
                keys.unshift("ISCHEMIC STROKE");
                mpgSoftware.variantWF.retrieveDatasets("allstroke", 'dependent');
            }

        }
            else if (portaltype == "ibd"){
                if (keys.indexOf("INFLAMMATORY BOWEL")>-1){
                    keys.splice(keys.indexOf("INFLAMMATORY BOWEL"), 1);
                    keys.unshift("INFLAMMATORY BOWEL");
                }
                $('#datasetDependent').prop( "disabled", false );

            }
            else if (portaltype == "mi"){
                if (keys.indexOf("MYOCARDIAL INFARCTION")>-1){
                    keys.splice(keys.indexOf("INFLAMMATORY BOWEL"), 1);
                    keys.unshift("INFLAMMATORY BOWEL");
                }
                $('#datasetDependent').prop( "disabled", false );
            }


            // if the OTHER key is defined, then move it to the bottom of the list
            // currently, this should only appear on the variant search page, and will be going away soon
            // I know that "soon" usually means in a couple years in the software world, but I mean
            // it this time, I swear
            if(keys.indexOf('OTHER') >= 0) {
                keys.splice(keys.indexOf('OTHER'), 1);
                keys.push('OTHER');
            }

            for (var x = 0; x < keys.length; x++) {
                var key = keys[x];
                if (groupList.hasOwnProperty(key)) {
                    var groupContents = groupList[key];
                    options.append("<optgroup label='"+key+"'>");
                    for (var j = 0; j < groupContents.length; j++) {
                        if(_.includes(phenotypesToOmit, groupContents[j][0])) {
                            continue;
                        }
                        options.append($("<option />").val(groupContents[j][0])
                            // add some whitespace to create indentation
                            .html("&nbsp;&nbsp;&nbsp;" + groupContents[j][1]));
                    }
                    options.append("</optgroup>");
                }
            }

            // enable the input
            options.prop('disabled', false);

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

            retVal += "<td><a class='boldlink' href='../variantInfo/variantInfo/" + variant.DBSNP_ID + "'>" + variant.DBSNP_ID + "</a></td>";

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
        var posRe = new RegExp(":[0-9]+\<"); // retrieve text, but with angle brackets
        var re2 = new RegExp("[0-9]+"); // specifically get the presumed integer
        if (typeof fullAnchor !== 'undefined') {
            var textWithAngles = fullAnchor.match(re);
            if ( textWithAngles === null ) {
                textWithAngles = fullAnchor.match(posRe);
            }
            if ( (typeof textWithAngles !== 'undefined') &&
                ( textWithAngles !== null ) &&
                (textWithAngles.length > 0) ) {
                var textWithoutAngles = textWithAngles[0].match(re2);
                if ( (typeof textWithoutAngles !== 'undefined') &&
                    ( textWithoutAngles !== null ) &&
                    (textWithoutAngles.length > 0) ) {
                    var textWeWant = textWithoutAngles[0];
                    returnValue = parseInt (textWeWant,10);
                }
            }
        }
        return returnValue;
    },
    extractAnchorTextAsString : function (fullAnchor){
        var returnValue = '';
        var re = new RegExp(/\>[a-z\d\s\-\(\)]+\</i); // retrieve text, but with angle brackets
        var re2 = new RegExp(/[a-z\d\s\-\(\)]+/i); // specifically get the presumed integer
        if (typeof fullAnchor !== 'undefined') {
            var textWithAngles = fullAnchor.match(re);
            if ( (typeof textWithAngles !== 'undefined') &&
                ( textWithAngles !== null) &&
                (textWithAngles.length > 0) ) {
                var textWithoutAngles = textWithAngles[0].match(re2);
                if ( (typeof textWithoutAngles !== 'undefined') &&
                    (textWithoutAngles.length > 0) ) {
                    returnValue = textWithoutAngles[0];
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
                var sampleGroupNamePlus = $('#'+nodeName[0]).attr('translatedName');
                if ( (typeof sampleGroupNamePlus !== 'undefined') &&
                    (sampleGroupNamePlus.length > 0) ) {
                    // var sampleGroupName = sampleGroupNamePlus.substring(0,sampleGroupNamePlus.indexOf('-'));
                    var sampleGroupName = sampleGroupNamePlus;
                    returnValue = sampleGroupName;
                }
            }
        }
        return returnValue;
    },
    extractHeaderTextWJqueryAsString : function (fullAnchor){
        var returnValue = 0;
        if (typeof fullAnchor !== 'undefined') {
            var returnValue = $(fullAnchor).attr('convertedSampleGroup');
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
                var sampleGroupNamePlus = $('#'+nodeName[0]).attr('translatedName');
                if ( (typeof sampleGroupNamePlus !== 'undefined') &&
                    (sampleGroupNamePlus.length > 0) ) {
                    var sampleGroupName = sampleGroupNamePlus;
                    returnValue = sampleGroupName;
                }
            }
        }
        return returnValue;
    },
    labelIndenter : function (tableId) {
        var rowSGLabel = $('#'+tableId+' td.vandaRowTd div.vandaRowHdr');
        if (typeof rowSGLabel !== 'undefined'){
            var adjustmentMadeSoCheckAgain;
            var indentationMultiplier = 0;
            var usedAsCore = [];
            var indentation = 0;
           // var sortedRowSGLabel = rowSGLabel.sort(orderFields);
            sortedRowSGLabel = rowSGLabel;
            do {
                var coreSGName = undefined;
                var lastPhenotype = undefined;
                indentationMultiplier++;
                adjustmentMadeSoCheckAgain = false;
                for ( var i = 0 ; i < sortedRowSGLabel.length ; i++ ){
                    var currentDiv = $(sortedRowSGLabel[i]);
                    var sampleGroupName = currentDiv.attr('convertedsamplegroup');
                    var phenotypeName = currentDiv.attr('phenotypename');
                    var haveSeenItBefore = false;
                    for (var j = 0 ; j < usedAsCore.length ; j++){
                        if ((usedAsCore[j].sg===sampleGroupName)&&
                            (usedAsCore[j].ph===phenotypeName)){
                            haveSeenItBefore = true;
                        }
                    }
                    if ( (typeof coreSGName === 'undefined')&&
                         (!haveSeenItBefore) ){
                        coreSGName = sampleGroupName;
                        lastPhenotype = phenotypeName;
                        usedAsCore.push({'sg':coreSGName,'ph':phenotypeName});
                    } else {

                        if ((sampleGroupName.indexOf(coreSGName)>-1)&&
                            (lastPhenotype === phenotypeName)&&
                            (!haveSeenItBefore)){
                            indentation = 12*indentationMultiplier;
                            currentDiv.css('padding-left',indentation+'px');
                            adjustmentMadeSoCheckAgain = true;
                        } else {
                           if (!haveSeenItBefore){ // you only get to be the core once
                                coreSGName = sampleGroupName;
                                lastPhenotype = phenotypeName;
                                usedAsCore.push({'sg':coreSGName,'ph':phenotypeName});
                            }
                        }
                    }
                }
            } while(adjustmentMadeSoCheckAgain);
            if (indentation === 0){ // if nothing was intentionally indented then let's reset all the padding to zero
                sortedRowSGLabel.css('padding-left','0px');
            }
        }
    },
    jsTreeDataRetriever : function (divId,tableId,phenotypeName,sampleGroupName,retrieveJSTreeAjax){
        var dataPasser = {phenotype:phenotypeName,sampleGroup:sampleGroupName};
        $(divId).jstree({
            core : {
                animation : 0,
                check_callback : true,
                themes : { "stripes" : false },
                data : {
                    type: "post",
                    url:  retrieveJSTreeAjax,
                    data: function (c,i) {
                        return dataPasser;
                    },
                    metadata: dataPasser
                }
            },
            checkbox: {
                keep_selected_style: false,
                three_state: false
            },
            plugins: [ "themes","core", "wholerow", "checkbox", "json_data", "ui", "types"]
        });
        $(divId).on ('after_open.jstree', function (e, data) {
            for ( var i = 0 ; i < data.node.children.length ; i++ )  {
                $(divId).jstree("select_node", '#'+data.node.children[i]+' .jstree-checkbox', true);
            }
        });
        $(divId).on ('load_node.jstree', function (e, data) {
            // this removes the dataset text that was put in as a placeholder
            $(divId + ' + p').remove();
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


    },
    jsTreeDataRetrieverPhenoSpec : function (divId,tableId,phenotypeName,sampleGroupName,retrieveJSTreeAjax,executeWhenDone,executeWhenDoneParm,ewdArray){
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
              // sgsWeHaveAlready.push({'ds':currentDiv.attr('datasetname'),'ph':currentDiv.attr('phenotypename')});
                sgsWeHaveAlready.push(""+currentDiv.attr('datasetname')+"_"+currentDiv.attr('phenotypename'));
            }
            var listToDelete = [];
            for ( var i = 0 ; i < data.node.children_d.length ; i++ )  {
                var nodeId =  data.node.children_d[i];
                if (data.node.children.indexOf(nodeId)==-1){ // elements in children_d and NOT children are actual child nodes.
                    // Elements in children can be self pointers for a node, which we don't want to delete
                    var sampleGroupPieces = nodeId.split('-');
                    var sampleGroupName = sampleGroupPieces[0]+"_"+sampleGroupPieces[3];
                    if (sgsWeHaveAlready.indexOf(sampleGroupName)>-1){
                        listToDelete.push(data.node.children_d[i]);
                    }
                }
            }
            for ( var i = 0 ; i < listToDelete.length ; i++ )  {
                $(divId).jstree("delete_node", listToDelete[i]);
            }
            if (typeof executeWhenDone !== 'undefined'){
                executeWhenDone(executeWhenDoneParm,ewdArray);
            }

        });


    },
    extractFieldBasedOnMeaning: function(valueObjectArray,desiredMeaningField,defaultvalue){
        var returnValue = defaultvalue;
        for (var i = 0 ; i < valueObjectArray.length ; i++ ){
            var splitValues = valueObjectArray[i].level.split('^');
            if (splitValues.length > 2){
                if (splitValues[2] === desiredMeaningField){
                    returnValue =  valueObjectArray[i].count;
                    break;
                }
            }
        }
        return returnValue;
    },
    boxQuartiles: function (d) {
        var accumulator = [];
        d.forEach(function (x) {
            accumulator.push(x.v);
        });
        return [
            d3.quantile(accumulator, .25),
            d3.quantile(accumulator, .5),
            d3.quantile(accumulator, .75)
        ];
    },
    /***
     * take an array and break it into distribution information with  numberOfBinsRequested bins
     *
     *
     * @param incomingArray
     * @param numberOfBinsRequested:
     * @param accessor
     * @returns {  binSize // how big is each bin (all bins are the same size)
     *    min // smallest value
     *    max // highest value
     *    binMap // map, where keys are counting numbers (0 to  numberOfBinsRequested-1)
     *  }
     *   Note: error condition is implied if  binSize===0
     *
     */
    distributionMapper: function (incomingArray,numberOfBinsRequested,accessor) {
        var defAcc = function (x){return x},
            sortedSet,
            numberOfElements,
            currentBin = 1,
            curBinCounter = 0,
            binWalker,
            returnValue = {binSize:0,binMap:d3.map()};  // indicate error state to begin with
        if (( typeof accessor !== 'undefined')){
            defAcc =  accessor;  // use custom accessor if requested
        }
        if ( ( typeof incomingArray !== 'undefined')    &&
            ( incomingArray.length > 0)    &&
            ( typeof numberOfBinsRequested !== 'undefined') &&
            ( numberOfBinsRequested  >  0)) {   //with all obvious error states ruled out we can start processing
            numberOfElements =  incomingArray.length;
            sortedSet =  incomingArray.sort (function (a,b){return (defAcc (a)-defAcc (b)); }); // sort in ascending order
            returnValue.min =  defAcc(sortedSet[0]);
            returnValue.max =  defAcc(sortedSet[numberOfElements-1]);
            if ((returnValue.max-returnValue.min) > 0){  // make sure ranges nonzero
                // we are ready to count the elements in each bin
                returnValue.binSize =  (returnValue.max-returnValue.min)/numberOfBinsRequested;
                binWalker = returnValue.min+(currentBin*returnValue.binSize);
                for ( var i = 0 ; i < numberOfElements ; i++ )   {
                    while (defAcc(incomingArray[i])>binWalker) {
                        returnValue.binMap.set(currentBin,curBinCounter);
                        curBinCounter = 0;
                        currentBin++;
                        binWalker = returnValue.min+(currentBin*returnValue.binSize);
                    } ;
                    curBinCounter++;
                }
                returnValue.binMap.set(numberOfBinsRequested,curBinCounter);
            }
        }
        return returnValue;
    },


    // takes in a dataset map with cohorts and returns a flattened array of {dataset, name} objects
    flattenDatasetMap: function(map, depth) {
        var toReturn = [];
        _.forEach(_.keys(map), function(dataset) {
            var prefix = '-'.repeat(depth);
            toReturn.push({
                name: prefix + map[dataset].name,
                value: dataset
            });
            var childDatasets = _.chain(map[dataset]).omit('name').value();
            if(_.keys(childDatasets).length > 0) {
                var childrenResults = UTILS.flattenDatasetMap(childDatasets, depth + 1);
                toReturn = toReturn.concat(childrenResults);
            }
        });
        return toReturn;
    },

    processChromatinStateData: function(data){
        var renderData = {'recordsExist': false};
        if ((typeof data !== 'undefined') &&
            (typeof data.variants !== 'undefined') &&
            (!data.variants.is_error)){
            var rawSortedData = _.sortBy(data.variants.variants,[function(item) {
                return parseInt(item.element.split('_')[0], 10);
            }, function(item) {
                return item.source;
            }]);
            var sortedData = [];
            _.forEach(rawSortedData,function(o){
                sortedData.push({'CHROM':o.CHROM,
                    'START':o.START,
                    'STOP':o.STOP,
                    'source':o.source_trans,
                    'element':o.element_trans
                })
            })
            var uniqueElements = _.uniqBy(sortedData,function(item) {
                return item.element;
            });
            var uniqueTissues = _.uniqBy(sortedData,function(item) {
                return item.source;
            });
            var dataMatrix = [];
            for (var i = 0 ; i < uniqueTissues.length ; i++ ) {
                var currentRow = [];
                for (var j = 0 ; j < uniqueElements.length ; j++){

                    if (_.find(sortedData, {source:uniqueTissues[i].source,element:uniqueElements[j].element})){
                        currentRow.push(1);
                    } else {
                        currentRow.push(0);
                    }
                }
                dataMatrix.push(currentRow);
            }
            var arrayOfArraysGroupedByTissue = [];
            for (var j = 0 ; j < uniqueTissues.length ; j++){

                var arrayGroupedByTissue = _.filter(sortedData, {source:uniqueTissues[j].source});
                arrayOfArraysGroupedByTissue.push(arrayGroupedByTissue);
            }
            var allUniqueElementNames = _.map(uniqueElements,'element');
            var allUniqueTissueNames = _.map(uniqueTissues,'source');
            uniqueElements.push({element:'ALL'});
            uniqueTissues.push({source:'ALL'});

            renderData = {  'recordsExist': (sortedData.length>1),
                'indivRecords':sortedData,
                'uniqueElements':allUniqueElementNames,
                'uniqueElementsPlusAll':uniqueElements,
                'uniqueTissues':allUniqueTissueNames,
                'uniqueTissuesPlusAll':uniqueTissues,
                'dataMatrix':dataMatrix,
                'arrayOfArraysGroupedByTissue':arrayOfArraysGroupedByTissue,
                'regionStart':data.variants.region_start,
                'regionEnd':data.variants.region_end
            };

        }
        return renderData;
    }



};
