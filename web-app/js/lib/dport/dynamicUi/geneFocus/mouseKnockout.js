/***
 * mouse knockout data
 *
 * The following externally visible functions are required:
 *          a function to process records
 *          a function to display the processed records
 * As well, always create a 'new mpgSoftware.dynamicUi.Categorizor()', and try to use its prototype functions.
 * If you like, you can always override the definitions for:
 *          categorizeTissueNumbers
 *           categorizeSignificanceNumbers
 * @type {*|{}}
 */


var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.mouseKnockout = (function () {

    const prepareDataForApiCall = function ( objectWithDataToPrepare ) {
        var dataForCall = _.map(objectWithDataToPrepare.getAccumulatorObject(objectWithDataToPrepare.nameOfAccumulatorFieldWithIndex,
            objectWithDataToPrepare.baseDomElement), function (o) {
            return {
                gene: o.name,
            }
        });
        return dataForCall;
    };


    var processRecordsFromMod = function (data, rawGeneAssociationRecords) {
        var dataArrayToProcess = [];
        if ( typeof data !== 'undefined'){
            dataArrayToProcess = {  gene:data.gene,
                tissues:data.records
            };
        }
        rawGeneAssociationRecords.push(dataArrayToProcess);
    };



    var displayRefinedModContext = function (idForTheTargetDiv, objectContainingRetrievedRecords, callingParameters) {
        mpgSoftware.dynamicUi.displayForGeneTable(callingParameters.placeToDisplayData, // which table are we adding to
            callingParameters,
            '', // we may wish to pull out one record for summary purposes
            function(records,tissueTranslations){
                return _.map(_.orderBy(records,["symbol"],["asc"]),function(tissueRecord){
                    return {  Feature_Type: tissueRecord.Feature_Type,
                        Human_gene: tissueRecord.Human_gene,
                        Term: tissueRecord.Term,
                        MGI_Gene_Marker_ID:tissueRecord.MGI_Gene_Marker_ID,
                        Name: tissueRecord.Name,
                        Symbol: tissueRecord.Symbol
                    }});
            },
            function(records, // all records
                     recordsCellPresentationString,// record count cell text
                     significanceCellPresentationString,// significance cell text
                     dataAnnotationTypeCode,// driving code
                     significanceValue,
                     gene ){ // value of significance for sorting
                return {
                    cellPresentationStringMap:{ Records:recordsCellPresentationString,
                        Significance:significanceCellPresentationString },
                    numberOfRecords:records.length,
                    tissueCategoryNumber:categorizor.categorizeTissueNumbers( records.length ),
                    significanceCategoryNumber:categorizor.categorizeSignificanceNumbers( records, "MOD" ),
                    recordsExist:(records.length)?[1]:[],
                    gene:gene,
                    significanceValue:significanceValue,
                    records:records
                }
            } );

    };


    var categorizor = new mpgSoftware.dynamicUi.Categorizor();

    categorizor.categorizeSignificanceNumbers = function ( significance, datatype, overrideValue ){
        // significance is not a meaningful concept for the mouse knockout data, so return a 6, which means make the background white
        return 6;
    }

    let sortUtility = new mpgSoftware.dynamicUi.SortUtility();
    const sortRoutine = Object.getPrototypeOf(sortUtility).numericalComparisonWithEmptiesAtBottom;



// public routines are declared below
    return {
        prepareDataForApiCall:prepareDataForApiCall,
        displayRefinedModContext:displayRefinedModContext,
        processRecordsFromMod: processRecordsFromMod,
        sortRoutine:sortRoutine
    }
}());
