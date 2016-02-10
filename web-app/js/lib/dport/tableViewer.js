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


        fillTheVariantTable = function (data, show_gene, show_exseq, show_exchp, variantRootUrl, geneRootUrl, dataSetDetermination, textStringObject, locale, copyText, printText) {
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

                var languageSetting = {}
                // check if the browser is using Spanish
                if ( locale.startsWith("es")  ) {
                    languageSetting = { url : '../../js/lib/i18n/table.es.json' }
                }

                $('#variantTable').dataTable({
                    iDisplayLength: 20,
                    bFilter: false,
                    aaSorting: [
                        [ 5, "asc" ]
                    ],
                    aoColumnDefs: [
                        { sType: "allnumeric", aTargets: [ 5, 6, 8, 10, 11, 12, 13 ] }
                    ],
                    language: languageSetting
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
                (vRec.results[0]["pVals"].length > 0) ) {
                var data = vRec.results[0]["pVals"];
                // first let's go through and process the metadata. For example we can make a data structure  with one
                // row for each phenotype (eventually these will correspond to the rows of the table).  as well, figure out
                //
                var phenotypeShortcut = {}; // shortcut to the right line
                var phenotypeCounter = 0;
                var phenoStruct = [];
                var mafValues = {};
                for (var i = 0; i < data.length; i++) {
                    var key = data [i].level;
                    var splitKey = key.split("^");
                    if (splitKey.length > 3) {
                        // P value handling
                        if (splitKey[1] !== 'NONE') {
                            var phenotypeMap = {'property': splitKey[0],
                                'phenotype': splitKey[1],
                                'meaning': splitKey[2],
                                'samplegroup': splitKey[3],
                                'pValue': data [i].count};
                            phenoStruct.push(phenotypeMap);
                        }

                        // maf value handling
                        if (splitKey[1] === 'NONE') {
                            var phenotypeMap = {'property': splitKey[0],
                                'phenotype': splitKey[1],
                                'meaning': splitKey[2],
                                'samplegroup': splitKey[3],
                                'pValue': data [i].count};
                            phenoStruct.push(phenotypeMap);
                        }

                    }
                }
            }
            return phenoStruct;
        },


        /***
         *  Receive an array of objects as input.  Some of those objects will share common fields, notably 'phenotype',
         *  'meaning', and 'samplegroup'.  Phenotype implies that the objects should be grouped together in the eventual table, either on
         *  the same line or adjacent lines.  Meaning we use instead of property name to organize columns in the table (since properties
         *  may differ, but meaning is more consistent).  Sample group we use to put together properties that are not dependent on phenotype
         *  such as Minor Allele Frequency.  By the end of this function we build a structure which can be used to build our on-screen
         *  table in a fairly straightforward way.
         *
         * @param arrayOfFields
         * @returns {{}}
         */
        buildIntoRows = function(arrayOfFields) {
            var combinedStructure = {};

            if ((typeof arrayOfFields !== 'undefined') &&
                (arrayOfFields.length > 0)) {

                // take a bunch of individual fields and build up the rows we will use

                //   start by extracting the phenotypes, since the rows are organized by phenotype
                var phenotypeList = [];
                for (var i = 0; i < arrayOfFields.length; i++) {
                    if (( typeof arrayOfFields[i].phenotype !== 'undefined') &&
                        (arrayOfFields[i].phenotype.length > 0)) {
                        var phenotype = arrayOfFields[i].phenotype;
                        if (phenotypeList.indexOf(phenotype) === -1) {
                            phenotypeList.push(phenotype);
                        }
                    }
                }

                // temp structure we can use to collect things
                var collectingObject = {};
                for ( var i = 0 ; i < phenotypeList.length ; i++ ) {
                    collectingObject [phenotypeList[i]]  = [];
                }

                // data set specific properties need to be blended in.  create a temporary data structure to hold them.
                var dataSetSpecificObject = {};
                for (var i = 0; i < arrayOfFields.length; i++) {
                    if (( typeof arrayOfFields[i].phenotype !== 'undefined') &&
                        (arrayOfFields[i].phenotype==='NONE') ) {
                        if ( typeof dataSetSpecificObject[arrayOfFields[i].samplegroup]  === 'undefined')  {
                            dataSetSpecificObject[arrayOfFields[i].samplegroup] = {};
                        }
                        dataSetSpecificObject[arrayOfFields[i].samplegroup][arrayOfFields[i].meaning] =  arrayOfFields[i];
                    }
                }

                // Now we know which phenotypes we have to work with, bring together all information that shares a phenotype
                //  At the same time let's figure out our column list
                var columnList = [];
                for (var i = 0; i < arrayOfFields.length; i++) {
                    if ( typeof arrayOfFields[i].phenotype !== 'undefined')  {
                        if (arrayOfFields[i].phenotype !== 'NONE'){
                            if ((arrayOfFields[i].pValue!==null)&&  // if there are no data we don't care about this field
                                (arrayOfFields[i].pValue!=='')){
                                collectingObject[arrayOfFields[i].phenotype].push(arrayOfFields[i]);
                                if (( typeof arrayOfFields[i].meaning !== 'undefined') &&
                                    ( arrayOfFields[i].meaning.length  > 0)) {
                                    if (columnList.indexOf(arrayOfFields[i].meaning)===-1)  {
                                        columnList.push(arrayOfFields[i].meaning);
                                    }
                                }
                                // if sample group match then assign this dataset to the same phenotype group
                                if ( typeof dataSetSpecificObject[arrayOfFields[i].samplegroup] !== 'undefined') {
                                    for (var dsSpecificName in dataSetSpecificObject[arrayOfFields[i].samplegroup]) {
                                        if (dataSetSpecificObject[arrayOfFields[i].samplegroup].hasOwnProperty(dsSpecificName)) {
                                            var mafDefined = false;
                                            for (var j = 0 ; j < collectingObject[arrayOfFields[i].phenotype].length ; j++) {
                                                if (collectingObject[arrayOfFields[i].phenotype][j].property === dsSpecificName)  {
                                                    mafDefined = true;
                                                }
                                            }
                                            if (!mafDefined)  {
                                                collectingObject[arrayOfFields[i].phenotype].push(dataSetSpecificObject[arrayOfFields[i].samplegroup][dsSpecificName]);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                columnList.push('samplegroup');

                // we should have everything we need to make the structure from which the table can be derived
                combinedStructure["columnList"] = columnList;
                combinedStructure["phenotypeRows"] = {};
                for (var phenotypeName in collectingObject) {
                    if (collectingObject.hasOwnProperty(phenotypeName)) {
                        var fieldsPerPhenotype =  collectingObject[phenotypeName];
                        if (fieldsPerPhenotype.length>0){
                            // we may have data from multiple sample groups.  For now, pick the lowest P
                            var allSampleGroups  = [];
                            for  (  var i = 0 ; i < fieldsPerPhenotype.length ; i++ ){
                                if (allSampleGroups.indexOf(fieldsPerPhenotype[i].samplegroup) === -1) {
                                    allSampleGroups.push (fieldsPerPhenotype[i].samplegroup);
                                }
                            }
                            var fieldsPerPhenotypeForFavoredSampleGroup=[];   // this will become an array of field arrays, so that we can have multiple groupings for each phenotype
                            if (allSampleGroups.length=== 1) {  // if only one sample group then use everything
                                fieldsPerPhenotypeForFavoredSampleGroup.push(fieldsPerPhenotype);
                            }  else {   // multiple sample groups.  Pick a favorite
                                // first create a sortable list of P values
                                var pValsToCompare = []; // array of objects
                                for  (  var i = 0 ; i < allSampleGroups.length ; i++ ){
                                    for  (  var j = 0 ; j < fieldsPerPhenotype.length ; j++ ){
                                        if ((fieldsPerPhenotype[j].samplegroup===allSampleGroups[i])&&
                                            (fieldsPerPhenotype[j].meaning==='P_VALUE')){
                                            pValsToCompare.push({'pval':fieldsPerPhenotype[j].pValue,'sg':fieldsPerPhenotype[j].samplegroup})
                                        }
                                    }
                                }
                                var chosenSampleGroup;
                                var sortedPValsToCompare = [];
                                if (pValsToCompare.length>0) {
                                    sortedPValsToCompare =  pValsToCompare.sort(function(a,b){return a.pval- b.pval;});
                                    chosenSampleGroup =  sortedPValsToCompare[0].sg;
                                } else {  // if there were no P values then pick the sample group arbitrarily
                                    chosenSampleGroup = allSampleGroups[0];
                                }
                                // now get the fields associated with the sample group
                                for ( var j = 0 ; j < sortedPValsToCompare.length ; j++ ){
                                    chosenSampleGroup =  sortedPValsToCompare[j].sg;
                                    var sampleGroupSpecificPhenotypeInfo = [];
                                    for  (  var i = 0 ; i < fieldsPerPhenotype.length ; i++ ){
                                        if (fieldsPerPhenotype[i].samplegroup===chosenSampleGroup){
                                            sampleGroupSpecificPhenotypeInfo.push(fieldsPerPhenotype[i]) ;
                                        }
                                    }
                                    fieldsPerPhenotypeForFavoredSampleGroup.push(sampleGroupSpecificPhenotypeInfo) ;
                                }
                            }
                            combinedStructure["phenotypeRows"] [phenotypeName]   = {};
                            for  (var i = 0; i < columnList.length; i++) {
                                combinedStructure["phenotypeRows"][phenotypeName][columnList [i]]  = '';
                            }
                            combinedStructure["phenotypeRows"][phenotypeName] = [];
                            for  (var i = 0; i < fieldsPerPhenotypeForFavoredSampleGroup.length; i++) {
                                var fieldAccumulator = {}; // temporary variable necessary only for clarity
                                for  (var j = 0; j < fieldsPerPhenotypeForFavoredSampleGroup[i].length; j++) {
                                    fieldAccumulator[fieldsPerPhenotypeForFavoredSampleGroup[i][j].meaning]  =   fieldsPerPhenotypeForFavoredSampleGroup[i][j].pValue;
                                    fieldAccumulator['samplegroup']  =   fieldsPerPhenotypeForFavoredSampleGroup[i][j].samplegroup;  // gets assigned multiple times but should always be the same
                                }
                                combinedStructure["phenotypeRows"][phenotypeName].push(fieldAccumulator);
                            }
                        }
                    }
                }
            }
            return combinedStructure;

        },





        fillTraitsPerVariantTable = function ( vRecO, show_gene, show_exseq, show_exchp,traitRootUrl ) {
            var retVal = "";
            if (!vRecO) {   // error condition
                return;
            }

            var vRec = deconvoluteVariantInfo(vRecO);
            var structureForBuildingTable = buildIntoRows (vRec) ;
            var rowCounter = 0;
            for (var phenotypeName in structureForBuildingTable["phenotypeRows"]) {
                if ((structureForBuildingTable["phenotypeRows"].hasOwnProperty(phenotypeName))&&
                    (phenotypeName!=="NONE")){

                    var rowsPerPhenotype =  structureForBuildingTable["phenotypeRows"] [phenotypeName];
                    for ( var i = 0 ; i < rowsPerPhenotype.length ; i++  ){
                        var row = rowsPerPhenotype[i];

                        if (i === 0){ // set up the row
                            retVal += "<tr id='"+phenotypeName+"' class='clickable' data-toggle='collapse' data-target='."+phenotypeName+"collapsed'>"
                        } else {
                            retVal += "<tr class='collapse out budgets "+phenotypeName+"collapsed'>"
                        }

                        // some shared variables
                        var convertedTrait=mpgSoftware.trans.translator(phenotypeName);
                        var convertedSampleGroup=mpgSoftware.trans.translator(row['samplegroup']);

                        // now start filling in the cells
                        retVal += "<td style='text-align: left'><div id='traitsTable"+(rowCounter)+"' class='sgIdentifierInTraitTable' datasetname='"+row['samplegroup']+"' phenotypename='"+phenotypeName+"'></div>";
                        retVal += "</td>";

                        // for now, restrict this link to GWAS data sets
                        if (convertedSampleGroup.indexOf('GWAS')>-1){ // GWAS data set - allow anchor
                            retVal += "<td><a href='"+traitRootUrl+"?trait="+phenotypeName+"&significance=5e-8'>"+convertedTrait+"</a></td>";
                        } else {
                            retVal += "<td>"+convertedTrait+"</td>";
                        }



                        retVal += "<td>";
                        if (( typeof row["P_VALUE"] !== 'undefined')&&(row["P_VALUE"]!== '')) {
                            retVal += (parseFloat(row["P_VALUE"]).toPrecision(3));
                            if ((i==0) && (rowsPerPhenotype.length>1)){
                                retVal += "<div class='glyphicon glyphicon-plus-sign pull-right' aria-hidden='true' data-toggle='tooltip' "+
                                    "data-placement='right' title='Click to toggle additional associations for "+convertedTrait+" across other data sets'></div>";
                            }
                        }
                        retVal += "</td>";


                        retVal += "<td>";
                        if (( typeof row["DIR"] !== 'undefined')&&(row["DIR"]!== '')) {
                            if ( row["DIR"] === 1 ) {
                                retVal += "<span class='assoc-up'>&uarr;</span>";
                            }
                            else if ( row["DIR"] === -1 ) {
                                retVal += "<span class='assoc-down'>&darr;</span>";
                            }
                        }
                        retVal += "</td>";

                        retVal += "<td>";
                        if (( typeof row["ODDS_RATIO"] !== 'undefined')&&(row["ODDS_RATIO"]!== '')) {
                            retVal += (parseFloat(row["ODDS_RATIO"]).toPrecision(3));
                        }
                        retVal += "</td>";


                        retVal += "<td>";
                        if (( typeof row["MAF"] !== 'undefined')&&(row["MAF"]!== '')) {
                            retVal += (parseFloat(row["MAF"]).toPrecision(3));
                        }
                        retVal += "</td>";


                        retVal += "<td>";
                        if (( typeof row["BETA"] !== 'undefined')&&(row["BETA"]!== '')) {
                            retVal += ( parseFloat(row["BETA"]).toPrecision(3));
                        }
                        retVal += "</td>";

                        retVal += "</tr>";
                        rowCounter++;
                    }

                }
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


    /* Sort col is *relative* to dynamic columns */
    var iterativeVariantTableFiller = function  (data, totCol, sortCol, divId,variantRootUrl,geneRootUrl,proteinEffectList,dataSetDetermination,locale,copyText,printText)  {

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

        var languageSetting = {}
        // check if the browser is using Spanish
        if ( locale.startsWith("es")  ) {
            languageSetting = { url : '../../js/lib/i18n/table.es.json' }
        }

        var table = $(divId).dataTable({
            iDisplayLength: 20,
            bFilter: false,
            aaSorting: [[ sortCol, "asc" ]],
            aoColumnDefs: [{sType: "allnumeric", aTargets: numericCol } ],
            language: languageSetting
        });


        var tableTools = new $.fn.dataTable.TableTools( table, {
            aButtons: [
                { "sExtends": "copy", "sButtonText": copyText },
                "csv",
                "xls",
                "pdf",
                { "sExtends": "print", "sButtonText": printText }
            ],
            sSwfPath: "../../js/DataTables-1.10.7/extensions/TableTools/swf/copy_csv_xls_pdf.swf"
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
        fillTheVariantTable: fillTheVariantTable,
        fillCollectedVariantsTable:fillCollectedVariantsTable,
        fillTraitsPerVariantTable:fillTraitsPerVariantTable
    }

}());