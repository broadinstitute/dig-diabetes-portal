/***
 * the MAGMA data connecting genes to phenotype
 *
 * The following externally visible functions are required:
 *         1) a function to process records
 *         2) a function to display the processed records
 * As well, always create a 'new mpgSoftware.dynamicUi.Categorizor()' as a means of building a
 *         3) set of categorizor routines
 * and try to use its prototype functions.  If you like, you can always override the definitions for:
 *          categorizeTissueNumbers
 *           categorizeSignificanceNumbers
 * @type {*|{}}
 */
var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.magmaGeneAssociation = (function () {
    "use strict";



    const prepareDataForApiCall = function ( objectWithDataToPrepare ) {
        var phenotype = objectWithDataToPrepare.getAccumulatorObject("phenotype", objectWithDataToPrepare.baseDomElement);
        var genesAsJson = "[]";
        if (objectWithDataToPrepare.getAccumulatorObject(objectWithDataToPrepare.nameOfAccumulatorFieldWithIndex,
            objectWithDataToPrepare.baseDomElement).length > 0) {
            const dataVector = objectWithDataToPrepare.getAccumulatorObject(objectWithDataToPrepare.nameOfAccumulatorFieldWithIndex,
                objectWithDataToPrepare.baseDomElement);
            if (dataVector.length===0){return;}
            var geneNameArray = _.map(dataVector, function(geneRec){return geneRec.name;});
            genesAsJson = "[\"" + geneNameArray.join("\",\"") + "\"]";
        }
        return { genes: genesAsJson, phenotype: phenotype };
    };





    /***
     * 1) a function to process records
     * @param data
     * @param rawGeneAssociationRecords
     * @returns {*}
     */
    var processRecordsFromMagma = function (data, rawGeneAssociationRecords) {
        //var dataArrayToProcess = [];
        if (( typeof data !== 'undefined')&&
            ( typeof data.data !== 'undefined')&&
            ( data.data.length > 0)){
            _.forEach(data.data,function(oneRec){
                rawGeneAssociationRecords.push({
                    gene: oneRec.gene,
                    tissues: [oneRec]
                });
            });
        }
        //rawGeneAssociationRecords.push(dataArrayToProcess);
    };


    /***
     *  2) a function to display the processed records
     * @param idForTheTargetDiv
     * @param objectContainingRetrievedRecords
     */
    var displayGenesFromMagma = function (idForTheTargetDiv, objectContainingRetrievedRecords, callingParameters) {

        mpgSoftware.dynamicUi.displayForGeneTable(callingParameters.placeToDisplayData, // which table are we adding to
            callingParameters,
            '', // we may wish to pull out one record for summary purposes
            function(records,tissueTranslations){
                return _.map(_.sortBy(records,['value']),function(tissueRecord){
                    let returnVal = tissueRecord;
                    returnVal['displayablePValue'] = UTILS.realNumberFormatter(''+tissueRecord.pvalue);
                    returnVal['value'] = UTILS.realNumberFormatter(''+tissueRecord.pvalue);
                    returnVal['displayableZValue'] = UTILS.realNumberFormatter(''+tissueRecord.zstat);
                    return returnVal});
            },
            function(records, // all records
                     recordsCellPresentationString,// record count cell text
                     significanceCellPresentationString,// significance cell text
                     dataAnnotationTypeCode,// driving code
                     significanceValue,
                     gene ){ // value of significance for sorting
                return {  numberOfRecords:records.length,
                    cellPresentationStringMap:{ Records:recordsCellPresentationString,
                        Significance:significanceCellPresentationString },
                    recordsExist:(records.length)?[1]:[],
                    gene:gene,
                    tissueCategoryNumber:categorizor.categorizeTissueNumbers( records.length ),
                    significanceCategoryNumber:categorizor.categorizeSignificanceNumbers( significanceValue ),
                    significanceValue:significanceValue,
                    data:records
                }
            } );

    };



    /***
     *  3) set of categorizor routines
     * @type {Categorizor}
     */
    var categorizor = new mpgSoftware.dynamicUi.Categorizor();
    categorizor.categorizeSignificanceNumbers = Object.getPrototypeOf(categorizor).genePValueSignificance;

    let sortUtility = new mpgSoftware.dynamicUi.SortUtility();
    const sortRoutine = Object.getPrototypeOf(sortUtility).numericalComparisonWithEmptiesAtBottom;


// public routines are declared below
    return {
        prepareDataForApiCall:prepareDataForApiCall,
        processRecordsFromMagma: processRecordsFromMagma,
        displayGenesFromMagma:displayGenesFromMagma,
        sortRoutine:sortRoutine
    }
}());
