var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.colocVariantTable = (function () {
    "use strict";

    /***
     * some objects that we can use to access shared prototype methods
     */
    const categorizor = new mpgSoftware.dynamicUi.sharedCategorizor.Categorizor();
    const sortUtility = new mpgSoftware.dynamicUi.sharedSortUtility.SortUtility();
    const renderData = new mpgSoftware.dynamicUi.sharednameRenderData.RenderData()



    const prepareDataForApiCall = function ( objectWithDataToPrepare ) {
        var variantsAsJson = "[]";
        var phenotype = objectWithDataToPrepare.getAccumulatorObject("phenotype", objectWithDataToPrepare.baseDomElement);
        if (objectWithDataToPrepare.getAccumulatorObject(objectWithDataToPrepare.nameOfAccumulatorFieldWithIndex,
            objectWithDataToPrepare.baseDomElement).length > 0) {
            const dataVector = objectWithDataToPrepare.getAccumulatorObject(objectWithDataToPrepare.nameOfAccumulatorFieldWithIndex,
                objectWithDataToPrepare.baseDomElement)[0].data;
            if (dataVector.length===0){return;}
            var variantNameArray = _.map(dataVector, function(variantRec){return variantRec.var_id;});
            variantsAsJson = "[\"" + variantNameArray.join("\",\"") + "\"]";
        }
        var dataForCall = {variants: variantsAsJson, phenotype: phenotype};
        return dataForCall;
    };




    /***
     * 1) a function to process records
     * @param data
     * @param rawGeneAssociationRecords
     * @returns {*}
     */
    var processRecordsFromColoc = function (data, arrayOfRecords) {
        if (( typeof data !== 'undefined')&&
            ( data.length > 0 )){
            const mappedToFamiliarNames = _.map(data, function(inrec){
                let outrec = inrec;
                outrec ["tissue_id"] = inrec["tissue"];
                outrec ["tissue_name"] = inrec["tissue"];
                return outrec;
            });
            arrayOfRecords.splice(0,arrayOfRecords.length);
            let dataGroupings = Object.getPrototypeOf(renderData).groupRawData(mappedToFamiliarNames,
                'COLOC',
                ['Colocalization']
            );
            arrayOfRecords.push({header:{ },
                data:dataGroupings});
        }
        return arrayOfRecords;
    };






    /***
     *  2) a function to display the processed records
     * @param idForTheTargetDiv
     * @param objectContainingRetrievedRecords
     */
    var displayTissueInformationFromColoc = function (idForTheTargetDiv, objectContainingRetrievedRecords, callingParameters ) {

        mpgSoftware.dynamicUi.displayForVariantTable(idForTheTargetDiv, // which table are we adding to
            callingParameters,
            function(records,tissueTranslations){
                return _.orderBy(records,['SOURCE'],['asc']);
            },
            Object.getPrototypeOf(renderData).variantTableAnnotationDominant,
            Object.getPrototypeOf(renderData).variantTableTissueDominant
        )

    };




    categorizor.categorizeSignificanceNumbers = Object.getPrototypeOf(categorizor).genePValueSignificance;

    const sortRoutine =  Object.getPrototypeOf(sortUtility).numericalComparisonWithEmptiesAtBottom;



// public routines are declared below
    return {
        prepareDataForApiCall:prepareDataForApiCall,
        processRecordsFromColoc: processRecordsFromColoc,
        displayTissueInformationFromColoc:displayTissueInformationFromColoc,
        sortRoutine:sortRoutine
    }
}());
