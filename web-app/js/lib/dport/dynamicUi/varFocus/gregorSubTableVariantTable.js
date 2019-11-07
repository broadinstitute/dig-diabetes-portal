var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.gregorSubTableVariantTable = (function () {
    "use strict";



const fieldsForPValue = {
    numericalField:'p_value',
    directionOfIncreasingSignificance:'asc',
    defaultValueField:'defaultGregorPValueUpperValue',
    strongestAssociationField:'minimumGregorPValue',
    weakestAssociationField:'maximumGregorPValue',
    numberOfQuantiles: 5,
    quickLookupField:'quickLookup'
};
    const fieldsForFEValue = {
        numericalField:'fe_value',
        directionOfIncreasingSignificance:'desc',
        defaultValueField:'defaultGregorFEValue',
        strongestAssociationField:'maximumGregorFEValue',
        weakestAssociationField:'minimumGregorFEValue',
        numberOfQuantiles: 5,
        quickLookupField:'quickLookupFE'
    };

   const createFilteringRanges = function(allRecs,geneRecord,
                                          fieldMapping) {
       const recordsOrderedBySignificance = _.orderBy(allRecs,[fieldMapping.numericalField],[fieldMapping.directionOfIncreasingSignificance]);
       const defaultValue = _.last(_.take(recordsOrderedBySignificance,5));
      geneRecord.header[fieldMapping.defaultValueField] = ( typeof defaultValue === 'undefined')?1:defaultValue[fieldMapping.numericalField];
      const mostSignificantValue = _.first(recordsOrderedBySignificance);
      geneRecord.header[fieldMapping.strongestAssociationField] = ( typeof mostSignificantValue === 'undefined')?0:mostSignificantValue[fieldMapping.numericalField];
      const leastSignificantValue = _.last(recordsOrderedBySignificance);
      geneRecord.header[fieldMapping.weakestAssociationField] = ( typeof leastSignificantValue === 'undefined')?1:leastSignificantValue[fieldMapping.numericalField];
       const quantileBreak = Math.floor(allRecs.length/fieldMapping.numberOfQuantiles);
       const quantiles = [];
       _.forEach(_.range(0,fieldMapping.numberOfQuantiles-1),function(rec, index){
           quantiles.push(recordsOrderedBySignificance.splice(index*quantileBreak,(index+1)*quantileBreak));
       });
       const quickLookup = {};
       _.forEach(quantiles,function(quantileArray,currentQuantile){
           _.forEach(quantileArray,function(rec) {
               quickLookup[rec.annotation + "_" + rec.tissue_id] = {p_value:rec[fieldMapping.numericalField],quantile:currentQuantile};
           })
       });
      geneRecord.header[fieldMapping.quickLookupField] =quickLookup;
   }





    /***
     * 1) a function to process records
     * @param data
     * @param rawGeneAssociationRecords
     * @returns {*}
     */
    var processRecordsFromGregor = function (data,rawGeneAssociationRecords) {

        if ( ( typeof data !== 'undefined') &&
            ( typeof data.data !== 'undefined') &&
            (  data.data.length > 0)){
            var geneRecord = {header:{}, data:[]};
            let everyAncestry = _.map(_.uniqBy(data.data,'ancestry'),function(o){return o.ancestry});
            let allRecs = data.data;
            if (_.includes(everyAncestry,"EU")){
                allRecs = _.filter(data.data,["ancestry","EU"])
            } else if (everyAncestry.length>0){
                allRecs = _.filter(data.data,["ancestry",_.first(everyAncestry)])
            }
            _.forEach(allRecs, function (oneRec) {
                oneRec['p_value'] = _.min([oneRec.p_value,1.0]);
                oneRec['fe_value'] = (oneRec.expected_in_beb_index_snp > 0) ? (oneRec.in_beb_index_snp / oneRec.expected_in_beb_index_snp) : 0;
                oneRec['safeTissueId'] = oneRec.tissue_id.replace(":","_");
            });
            // const recordsOrderedByP = _.orderBy(allRecs,['p_value'],['asc']);
            geneRecord.header['annotations'] = _.map(_.uniqBy(allRecs,'annotation'),function(o){return o.annotation});
            geneRecord.header['ancestries'] = _.map(_.uniqBy(allRecs,'ancestry'),function(o){return o.ancestry});
            geneRecord.header['tissues'] = _.map(_.uniqBy(allRecs,'tissue'),function(o){return o.tissue.replace('\'','').toLowerCase()});
            createFilteringRanges(allRecs,geneRecord,fieldsForPValue);
            createFilteringRanges(allRecs,geneRecord,fieldsForFEValue);


            let bestAnnos = [];
            _.forEach(_.uniqBy(allRecs,'annotation'),function(oo){
                if ((oo.method==='MACS')||(oo.method==='ChromHMM')){
                    let temp = oo;
                    temp['prettyAnnotation'] = oo.annotation.match(/[A-Z][a-z]+/g).join(" ");
                    bestAnnos.push(temp);
                }else{
                    let temp = oo;
                    temp['prettyAnnotation'] = oo.annotation;
                    bestAnnos.push(temp);
                }
            });
            geneRecord.header['bestAnnotations'] = bestAnnos;
            geneRecord.header['bestAncestries'] = _.uniqBy(allRecs,'ancestry');
            geneRecord.header['bestTissues'] = _.uniqBy(allRecs,'tissue');
            // add an additional tissue name
            let vectorWithAllRecords = [];
            _.forEach(allRecs, function (oneRec) {
                let holder = oneRec;
                holder['safeTissueId'] = oneRec.tissue_id.replace(":","_");
                vectorWithAllRecords.push(holder)
            });

            geneRecord.data = _.groupBy(vectorWithAllRecords,'tissue');
            rawGeneAssociationRecords.push(geneRecord);
        }
        return rawGeneAssociationRecords;
    };




    var createSingleDnaseCell = function (recordsPerTissue,dataAnnotationType) {
        var significanceValue = 0;
        var returnValue = {};
        if (( typeof recordsPerTissue !== 'undefined')&&
            (recordsPerTissue.length>0)){
            var mostSignificantRecord=recordsPerTissue[0];

            significanceValue = mostSignificantRecord.value;
            returnValue['significanceValue'] = significanceValue;
            returnValue['significanceCellPresentationString'] = Mustache.render($('#'+dataAnnotationType.dataAnnotation.significanceCellPresentationStringWriter)[0].innerHTML,
                {significanceValue:significanceValue,
                    recordsPerTissue:recordsPerTissue,
                    significanceValueAsString:UTILS.realNumberFormatter(""+significanceValue),
                    recordDescription:mostSignificantRecord.tissue,
                    numberRecords:recordsPerTissue.length});
        }
        return returnValue;
    };

const setGregorSubTableByPValue = function(currentValue){
    $('div.gregorVariantTableBody').filter(function() {return $(this).attr("sortField") <= currentValue;}).show();
    $('div.gregorVariantTableBody').filter(function() {return $(this).attr("sortField") > currentValue;}).hide();
    $('div.gregorSubTableRow').filter(function() {return $(this).attr("sortvalue") <= currentValue;}).find('input.gregorSubTableRowHeader').prop('checked', true);
    $('div.gregorSubTableRow').filter(function() {return $(this).attr("sortvalue") > currentValue;}).find('input.gregorSubTableRowHeader').prop('checked', false);
    $('div.gregorSubTableHeader').filter(function() {return $(this).attr("sortvalue") <= currentValue;}).find('input.gregorSubTableRowHeader').prop('checked', true);
    $('div.gregorSubTableHeader').filter(function() {return $(this).attr("sortvalue") > currentValue;}).find('input.gregorSubTableRowHeader').prop('checked', false);

};


    const setGregorSubTableByFEValue = function(currentValue){
        $('div.gregorVariantTableBody').filter(function() {return $(this).attr("sortFEField") >= currentValue;}).show();
        $('div.gregorVariantTableBody').filter(function() {return $(this).attr("sortFEField") < currentValue;}).hide();
        $('div.gregorSubTableRow').filter(function() {return $(this).attr("sortFEvalue") >= currentValue;}).find('input.gregorSubTableRowHeader').prop('checked', true);
        $('div.gregorSubTableRow').filter(function() {return $(this).attr("sortFEvalue") < currentValue;}).find('input.gregorSubTableRowHeader').prop('checked', false);
        $('div.gregorSubTableHeader').filter(function() {return $(this).attr("sortFEvalue") >= currentValue;}).find('input.gregorSubTableRowHeader').prop('checked', true);
        $('div.gregorSubTableHeader').filter(function() {return $(this).attr("sortFEvalue") < currentValue;}).find('input.gregorSubTableRowHeader').prop('checked', false);

    };


const setUpFilterAndSlider = function (retrievedRecords,valueDisplay ){
    const minVal = (retrievedRecords.header.minimumGregorPValue<=1)?
        retrievedRecords.header.minimumGregorPValue:1;
    const maxVal = (retrievedRecords.header.maximumGregorPValue<=1)?
        retrievedRecords.header.maximumGregorPValue:1;
    const defaultGregorPValueUpperValue = retrievedRecords.header.defaultGregorPValueUpperValue;
    const logMinVal = 0-Math.log10(minVal);
    const logMaxVal = 0-Math.log10(maxVal);
    $( "#gregorPValueSlider" ).slider({
        range: "max",
        min: 0,
        max: 100,
        value: ((logMinVal+Math.log10(defaultGregorPValueUpperValue))/(logMinVal-logMaxVal))*100,
        create: function() {
            valueDisplay.text( UTILS.realNumberFormatter(defaultGregorPValueUpperValue));

        },
        slide: function( event, ui ) {
            const currentValue = Math.pow(10, 0-(logMinVal+(ui.value*(logMaxVal-logMinVal)/100.0)));
            valueDisplay.text( UTILS.realNumberFormatter(currentValue) );
            setGregorSubTableByPValue(currentValue);
        }
    });
    $('div.minimumGregorPValue').text(UTILS.realNumberFormatter(minVal));
    $('div.maximumGregorPValue').text(UTILS.realNumberFormatter(maxVal));
};
    const setUpFEFilterAndSlider = function (retrievedRecords,valueDisplay ){
        const minVal = retrievedRecords.header.minimumGregorFEValue;
        const maxVal = retrievedRecords.header.maximumGregorFEValue;
        const defaultGregorFEValue = retrievedRecords.header.defaultGregorFEValue;
        $( "#gregorFEValueSlider" ).slider({
            range: "max",
            min: minVal,
            max: maxVal,
            value: minVal,
            step:(maxVal-minVal)/100.0,
            create: function() {
                valueDisplay.text( UTILS.realNumberFormatter(minVal));

            },
            slide: function( event, ui ) {
                const currentValue = ui.value;
                valueDisplay.text( UTILS.realNumberFormatter(currentValue) );
                setGregorSubTableByFEValue(currentValue);
            }
        });
        $('div.minimumGregorFEValue').text(UTILS.realNumberFormatter(minVal));
        $('div.maximumGregorFEValue').text(UTILS.realNumberFormatter(maxVal));
    }



    /***
     *  2) a function to display the processed records
     * @param idForTheTargetDiv
     * @param objectContainingRetrievedRecords
     */
    var displayGregorSubTable = function (idForTheTargetDiv, objectContainingRetrievedRecords, callingParameters ) {
      //  var handle = $( "#custom-handle" );
        var valueDisplay = $( "div.dynamicDisplay" );
        var valueFEDisplay = $( "div.dynamicFEDisplay" );
        if (objectContainingRetrievedRecords.length<1) return;
        // const minVal = (objectContainingRetrievedRecords[0].header.minimumGregorPValue<=1)?
        //     objectContainingRetrievedRecords[0].header.minimumGregorPValue:1;
        // const maxVal = (objectContainingRetrievedRecords[0].header.maximumGregorPValue<=1)?
        //     objectContainingRetrievedRecords[0].header.maximumGregorPValue:1;
        // const defaultGregorPValueUpperValue = objectContainingRetrievedRecords[0].header.defaultGregorPValueUpperValue;
        // const logMinVal = 0-Math.log10(minVal);
        // const logMaxVal = 0-Math.log10(maxVal);
        // $( "#gregorPValueSlider" ).slider({
        //     range: "max",
        //         min: 0,
        //         max: 100,
        //         value: ((logMinVal+Math.log10(defaultGregorPValueUpperValue))/(logMinVal-logMaxVal))*100,
        //     create: function() {
        //         valueDisplay.text( UTILS.realNumberFormatter(defaultGregorPValueUpperValue));
        //
        //     },
        //     slide: function( event, ui ) {
        //         const currentValue = Math.pow(10, 0-(logMinVal+(ui.value*(logMaxVal-logMinVal)/100.0)));
        //         valueDisplay.text( UTILS.realNumberFormatter(currentValue) );
        //         setGregorSubTableByPValue(currentValue);
        //     }
        // });
        // $('div.minimumGregorPValue').text(UTILS.realNumberFormatter(minVal));
        // $('div.maximumGregorPValue').text(UTILS.realNumberFormatter(maxVal));
        setUpFilterAndSlider(objectContainingRetrievedRecords[0],valueDisplay);
        setUpFEFilterAndSlider(objectContainingRetrievedRecords[0],valueFEDisplay);
        mpgSoftware.dynamicUi.displayGregorSubTableForVariantTable(idForTheTargetDiv, // which table are we adding to
            callingParameters.code, // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
            callingParameters.nameOfAccumulatorField, // name of the persistent field where the data we received is stored
            // take all the records for each row and insert them into the intermediateDataStructure
            function(tissueRecords,
                     recordsCellPresentationString,
                     significanceCellPresentationString,
                     dataAnnotationTypeCode,
                     significanceValue,
                     tissueName ){
                return {
                    tissueRecords:tissueRecords,
                    recordsExist:(tissueRecords.length>0)?[1]:[],
                    cellPresentationStringMap:{
                        'Significance':significanceCellPresentationString,
                        'Records':recordsCellPresentationString
                    },
                    dataAnnotationTypeCode:dataAnnotationTypeCode,
                    significanceValue:significanceValue,
                    tissueNameKey:( typeof tissueName !== 'undefined')?tissueName.replace(/ /g,"_"):'var_name_missing',
                    tissueName:tissueName,
                    tissuesFilteredByAnnotation:tissueRecords};

            },
            createSingleDnaseCell
        );
         setGregorSubTableByPValue(objectContainingRetrievedRecords[0].header.defaultGregorPValueUpperValue);
        mpgSoftware.dynamicUi.filterEpigeneticTable("#mainVariantDiv table.variantTableHolder");
    };



    /***
     *  3) set of categorizor routines
     * @type {Categorizor}
     */
    var categorizor = new mpgSoftware.dynamicUi.Categorizor();
    categorizor.categorizeSignificanceNumbers = Object.getPrototypeOf(categorizor).genePValueSignificance;




// public routines are declared below
    return {
        processRecordsFromGregor: processRecordsFromGregor,
        displayGregorSubTable:displayGregorSubTable
    }
}());