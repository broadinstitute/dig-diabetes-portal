/***
 * the gene headers that are required for the gene table
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

mpgSoftware.dynamicUi.geneHeaders = (function () {
    "use strict";



    /***
     *   1) a function to process records
     * Gene proximity search
     * @param data
     * @param rawGeneAssociationRecords
     * @returns {*}
     */
    var processRecordsFromProximitySearch = function (data, rawGeneAssociationRecords) {
        //var returnObject = {
        //    rawData: [],
        //    uniqueGenes: [],
        //    genePositions: [],
        //    uniqueTissues: [],
        //    genesPositionsExist: function () {
        //        return (this.genePositions.length > 0) ? [1] : [];
        //    },
        //    genesExist: function () {
        //        return (this.uniqueGenes.length > 0) ? [1] : [];
        //    }
        //};
        var geneInfoArray = [];
        if (( typeof data !== 'undefined') &&
            ( data !== null ) &&
            (data.is_error === false ) &&
            ( typeof data.listOfGenes !== 'undefined')) {
            if (data.listOfGenes.length === 0) {
                alert(' No genes in the specified region')
            } else {
                _.forEach(data.listOfGenes, function (geneRec) {
                    //returnObject.rawData.push(geneRec);
                    //if (!returnObject.uniqueGenes.includes(geneRec.name2)) {
                    //    returnObject.uniqueGenes.push({name: geneRec.name2});
                    //    returnObject.genePositions.push({name: geneRec.chromosome + ":" + geneRec.addrStart + "-" + geneRec.addrEnd});
                    if ( typeof _.find(rawGeneAssociationRecords,{name:geneRec.name2}) === 'undefined'){
                        var chromosomeString = _.includes(geneRec.chromosome, "chr") ? geneRec.chromosome.substr(3) : geneRec.chromosome;
                        rawGeneAssociationRecords.push({
                                chromosome: chromosomeString,
                                startPos: geneRec.addrStart,
                                endPos: geneRec.addrEnd,
                                name: geneRec.name2,
                                id: geneRec.id
                            }
                        );
                    }

                    //}
                    ;
                });
            }
        }
        // we have a list of all the genes in the range.  Let's remember that information.
        //setAccumulatorObject("geneNameArray", returnObject.uniqueGenes);
        //rawGeneAssociationRecords.push(geneInfoArray);
        return rawGeneAssociationRecords;


        //setAccumulatorObject("geneInfoArray", geneInfoArray);
        //return returnObject;
    };


    var displayRefinedGenesInARange = function (idForTheTargetDiv, objectContainingRetrievedRecords) {
        mpgSoftware.dynamicUi.displayHeaderForGeneTable('table.combinedGeneTableHolder', // which table are we adding to
            'GHDR', // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
            'geneInfoArray');


        //var selectorForIidForTheTargetDiv = idForTheTargetDiv;
        //$(selectorForIidForTheTargetDiv).empty();
        //
        ////addAdditionalResultsObject({refinedGenesInARange: objectContainingRetrievedRecords});
        //
        //
        //var intermediateDataStructure = new IntermediateDataStructure();
        //
        //if (typeof objectContainingRetrievedRecords.rawData !== 'undefined') {
        //    // set up the headers, and give us an empty row of column cells
        //    _.forEach(objectContainingRetrievedRecords.rawData, function (oneRecord,index) {
        //        intermediateDataStructure.headerNames.push(oneRecord.name1);
        //        intermediateDataStructure.headerContents.push(Mustache.render($("#dynamicGeneTableHeaderV2")[0].innerHTML, oneRecord));
        //        // alert('needs to be fixed 1');
        //        intermediateDataStructure.headers.push(new IntermediateStructureDataCell(oneRecord.name1,
        //            Mustache.render($("#dynamicGeneTableHeaderV2")[0].innerHTML, oneRecord),"geneHeader asc ",'LIT'));
        //    });
        //
        //    intermediateDataStructure.tableToUpdate = "table.combinedGeneTableHolder";
        //}
        //
        //
        //prepareToPresentToTheScreen("#dynamicGeneHolder div.dynamicUiHolder",
        //    '#dynamicGeneTable',
        //    objectContainingRetrievedRecords,
        //    clearBeforeStarting,
        //    intermediateDataStructure,
        //    true,
        //    'geneTableGeneHeaders');

    };


    /***
     *  2) a function to display the processed records
     * @param idForTheTargetDiv
     * @param objectContainingRetrievedRecords
     */
    var displayGenesFromColoc = function (idForTheTargetDiv, objectContainingRetrievedRecords) {
        mpgSoftware.dynamicUi.displayHeaderForGeneTable('table.combinedGeneTableHolder', // which table are we adding to
            'GHDR', // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
            'rawColoInfo', // name of the persistent field where the data we received is stored
            'geneInfoArray', // we may wish to pull out one record for summary purposes
            function(records,tissueTranslations){
                return _.map(_.orderBy(records,["prob_exists_coloc"],["desc"]),function(tissueRecord){
                    return {  tissue: tissueRecord.tissue_trans,
                        conditional_prob_snp_coloc: UTILS.realNumberFormatter(""+tissueRecord.conditional_prob_snp_coloc),
                        unconditional_prob_snp_coloc: UTILS.realNumberFormatter(""+tissueRecord.unconditional_prob_snp_coloc),
                        prob_exists_coloc: UTILS.realNumberFormatter(""+tissueRecord.prob_exists_coloc),
                        var_id: tissueRecord.var_id,
                        value:tissueRecord.prob_exists_coloc,
                        numericalValue: tissueRecord.prob_exists_coloc
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
                    significanceCategoryNumber:categorizor.categorizeSignificanceNumbers( records[0].prob_exists_coloc, "COL" ),
                    recordsExist:(records.length)?[1]:[],
                    gene:gene,
                    significanceValue:significanceValue,
                    records:records
                }
            } );
    };


    /***
     *  3) set of categorizor routines
     * @type {Categorizor}
     */
    var categorizor = new mpgSoftware.dynamicUi.Categorizor();
    categorizor.categorizeSignificanceNumbers = Object.getPrototypeOf(categorizor).posteriorProbabilitySignificance;



// public routines are declared below
    return {
        processRecordsFromProximitySearch: processRecordsFromProximitySearch,
        displayRefinedGenesInARange:displayRefinedGenesInARange
    }
}());
