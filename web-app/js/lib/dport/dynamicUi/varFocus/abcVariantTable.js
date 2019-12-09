var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.abcVariantTable = (function () {
    "use strict";

    /***
     * some objects that we can use to access shared prototype methods
     */
    const categorizor = new mpgSoftware.dynamicUi.sharedCategorizor.Categorizor();
    const sortUtility = new mpgSoftware.dynamicUi.sharedSortUtility.SortUtility();
    const renderData = new mpgSoftware.dynamicUi.sharednameRenderData.RenderData()

    /***
     * 1) a function to process records
     * @param data
     * @param rawGeneAssociationRecords
     * @returns {*}
     */
    var processRecordsFromAbc = function (data, arrayOfRecords) {
        if (( typeof data !== 'undefined')&&
            ( typeof data.data !== 'undefined')){
            arrayOfRecords.splice(0,arrayOfRecords.length);
            const myData = data.data;
            let uniqueRecords = _.uniqWith(
                myData,
                (recA, recB) =>
                    recA.annotation === recB.annotation &&
                    recA.var_id === recB.var_id &&
                    recA.tissue_id === recB.tissue_id &&
                    recA.gene_id === recB.gene_id
            );
            //uniqueRecords = _.filter(uniqueRecords,function(rec){return rec.gene_id!==null});
            let dataGroupings = Object.getPrototypeOf(renderData).groupRawData(_.filter(uniqueRecords,function(rec){return rec.gene_id!==null}),
                'ABC',
                ['GenePrediction']
            );
            arrayOfRecords.push({header:{
                },
                data:dataGroupings});

        }
        return arrayOfRecords;
    };



    /***
     *  2) a function to display the processed records
     * @param idForTheTargetDiv
     * @param objectContainingRetrievedRecords
     */
    var displayTissueInformationFromAbc = function (idForTheTargetDiv, objectContainingRetrievedRecords, callingParameters ) {

        mpgSoftware.dynamicUi.displayForVariantTable(idForTheTargetDiv, // which table are we adding to
            callingParameters,
            function(records,tissueTranslations){
                //return _.orderBy(_.filter(records,function(o){return (o.p_value<0.05)}),['p_value'],['asc']);
                return _.orderBy(records,['SOURCE'],['asc']);
            },
            Object.getPrototypeOf(renderData).variantTableAnnotationDominant,
            Object.getPrototypeOf(renderData).variantTableTissueDominant
        )

    };



    /***
     *  3) set of categorizor routines
     * @type {Categorizor}
     */
    categorizor.categorizeSignificanceNumbers = Object.getPrototypeOf(categorizor).genePValueSignificance;

    const sortBinaryDisplay = function(a, b, direction, currentSortObject){
        var initialLinearIndexA = mpgSoftware.dynamicUi.extractClassBasedIndex($(a),"initialLinearIndex_");
        var initialLinearIndexB = mpgSoftware.dynamicUi.extractClassBasedIndex($(b),"initialLinearIndex_");
        const displayA = $('div.initialLinearIndex_'+initialLinearIndexA+".yesDisplay");
        const displayB = $('div.initialLinearIndex_'+initialLinearIndexB+".yesDisplay");

        var x = (displayA.length) ? 1 : 0;
        var y = (displayB.length) ? 1 : 0;
        return (x < y) ? 1 : (x > y) ? -1 : 0;
    };

    const sortRoutine =  sortBinaryDisplay;



// public routines are declared below
    return {
        processRecordsFromAbc: processRecordsFromAbc,
        displayTissueInformationFromAbc:displayTissueInformationFromAbc,
        sortRoutine:sortRoutine
    }
}());
