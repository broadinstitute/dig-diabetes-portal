var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.gregorSubTableVariantTable = (function () {
    "use strict";


    /***
     * 1) a function to process records
     * @param data
     * @param rawGeneAssociationRecords
     * @returns {*}
     */
    // var processRecordsFromGregor = function (data, arrayOfRecords) {
    //     if (( typeof data !== 'undefined')&&
    //         ( typeof data.data !== 'undefined')){
    //         arrayOfRecords.splice(0,arrayOfRecords.length);
    //         let arrayOfData = [];
    //         var recordsGroupedByVarId = _.groupBy(data.data, function (o) { return o.var_id });
    //         _.forEach(recordsGroupedByVarId, function (value,key) {
    //             var allRecordsForOneVariety = {name:key,arrayOfRecords:value};
    //             arrayOfData.push(allRecordsForOneVariety);
    //         });
    //         arrayOfRecords.push({header:{ },
    //             data:arrayOfData});
    //     }
    //     return arrayOfRecords;
    // };
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
            });
            const recordsOrderedByP = _.orderBy(allRecs,['p_value'],['asc']);
            geneRecord.header['annotations'] = _.map(_.uniqBy(allRecs,'annotation'),function(o){return o.annotation});
            geneRecord.header['ancestries'] = _.map(_.uniqBy(allRecs,'ancestry'),function(o){return o.ancestry});
            geneRecord.header['tissues'] = _.map(_.uniqBy(allRecs,'tissue'),function(o){return o.tissue.replace('\'','').toLowerCase()});
            const defaultGregorPValueUpperValue = _.last(_.take(recordsOrderedByP,5));
            geneRecord.header['defaultGregorPValueUpperValue'] = ( typeof defaultGregorPValueUpperValue === 'undefined')?1:defaultGregorPValueUpperValue.p_value;
            const minimumGregorPValue = _.first(recordsOrderedByP);
            geneRecord.header['minimumGregorPValue'] = ( typeof minimumGregorPValue === 'undefined')?0:minimumGregorPValue.p_value;
            const maximumGregorPValue = _.last(recordsOrderedByP);
            geneRecord.header['maximumGregorPValue'] = ( typeof maximumGregorPValue === 'undefined')?1:maximumGregorPValue.p_value;
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
            const numberOfQuantiles = 5;
            const quantileBreak = Math.floor(allRecs.length/numberOfQuantiles);
            const quantiles = [];
            _.forEach(_.range(0,numberOfQuantiles-1),function(rec, index){
                quantiles.push(allRecs.splice(index*quantileBreak,(index+1)*quantileBreak));
            });
            const quickLookup = {};
            _.forEach(quantiles,function(quantileArray,currentQuantile){
                _.forEach(quantileArray,function(rec) {
                    quickLookup[rec.annotation + "_" + rec.tissue_id] = {p_value:rec.p_value,quantile:currentQuantile};
                })
            });
            geneRecord.header['quickLookup'] =quickLookup;
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


    /***
     *  2) a function to display the processed records
     * @param idForTheTargetDiv
     * @param objectContainingRetrievedRecords
     */
    var displayGregorSubTable = function (idForTheTargetDiv, objectContainingRetrievedRecords, callingParameters ) {
        var handle = $( "#custom-handle" );
        var valueDisplay = $( "div.dynamicDisplay" );
        if (objectContainingRetrievedRecords.length<1) return;
        const minVal = (objectContainingRetrievedRecords[0].header.minimumGregorPValue<=1)?
            objectContainingRetrievedRecords[0].header.minimumGregorPValue:1;
        const maxVal = (objectContainingRetrievedRecords[0].header.maximumGregorPValue<=1)?
            objectContainingRetrievedRecords[0].header.maximumGregorPValue:1;
        const defaultGregorPValueUpperValue = objectContainingRetrievedRecords[0].header.defaultGregorPValueUpperValue;
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
        setGregorSubTableByPValue(defaultGregorPValueUpperValue);

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