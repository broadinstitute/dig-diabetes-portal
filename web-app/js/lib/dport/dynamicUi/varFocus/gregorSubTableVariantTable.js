var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.gregorSubTableVariantTable = (function () {
    "use strict";


    let rememberCutOffs  = {};   // what has the user chosen as the current value cut offs?
    const fieldDescribingCombinationStrategy = 'span.textualDescriptionOfFilteringStrategy';
    const fieldsForPValue = {
        numericalField:'p_value',
        directionOfIncreasingSignificance:'asc',
        defaultValueField:'defaultGregorPValueUpperValue',
        strongestAssociationField:'minimumGregorPValue',
        weakestAssociationField:'maximumGregorPValue',
        numberOfQuantiles: 5,
        quickLookupField:'quickLookup',
        rememberCutOff:'p_value_cutoff',
    };
    const fieldsForFEValue = {
        numericalField:'fe_value',
        directionOfIncreasingSignificance:'desc',
        defaultValueField:'defaultGregorFEValue',
        strongestAssociationField:'maximumGregorFEValue',
        weakestAssociationField:'minimumGregorFEValue',
        numberOfQuantiles: 5,
        quickLookupField:'quickLookupFE',
        rememberCutOff:'fe_value_cutoff',
    };

   const createFilteringRanges = function(allRecs,geneRecord,
                                          fieldMapping) {
       const recordsOrderedBySignificance = _.orderBy(allRecs,[fieldMapping.numericalField],[fieldMapping.directionOfIncreasingSignificance]);
       const defaultValue = _.last(_.take(recordsOrderedBySignificance,5));
       rememberCutOffs[fieldMapping.rememberCutOff] = defaultValue[fieldMapping.numericalField];
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
            //geneRecord.header['annotations'] = _.map(_.uniqBy(allRecs,'annotation'),function(o){return o.annotation});
            // we need to be unique by both annotation and method
            const uniqueByAnnotationAndMethod = _.uniqBy(allRecs,(elem)=>[elem.annotation,elem.method].join());
            geneRecord.header['annotationAndMethod'] = _.map(uniqueByAnnotationAndMethod,function(o){return o.annotation+"_"+o.method});
            geneRecord.header['annotations'] = _.map(uniqueByAnnotationAndMethod,function(o){return o.annotation});
            geneRecord.header['ancestries'] = _.map(_.uniqBy(allRecs,'ancestry'),function(o){return o.ancestry});
            geneRecord.header['tissues'] = _.map(_.uniqBy(allRecs,'tissue'),function(o){return o.tissue.replace('\'','').toLowerCase()});
            createFilteringRanges(allRecs,geneRecord,fieldsForPValue);
            createFilteringRanges(allRecs,geneRecord,fieldsForFEValue);


            let bestAnnos = [];
            _.forEach(uniqueByAnnotationAndMethod,function(oo){
                let temp = oo;
                switch (oo.method){
                    case 'MACS':
                    case 'ChromHMM':
                        temp['prettyAnnotation'] = oo.annotation.match(/([A-Z][a-z]+)|([0-9]+)/g).join(" ");
                        break;
                    case 'NA':
                        temp['prettyAnnotation'] = oo.annotation;
                        break;
                    case 'ABC':
                    case 'cicero':
                    case 'CHiCAGO':
                        temp['prettyAnnotation'] = oo.method;
                        break;
                    default:
                        temp['prettyAnnotation']= oo.annotation;
                        break;
                }
                // if ((oo.method==='MACS')||(oo.method==='ChromHMM')){
                //     temp['prettyAnnotation'] = oo.annotation.match(/([A-Z][a-z]+)|([0-9]+)/g).join(" ");
                // }else{
                //     temp['prettyAnnotation'] = oo.annotation;
                // }
                temp['anno_hdr_fe_value'] = _.first(_.orderBy(_.filter (allRecs,{'annotation':oo.annotation}),['fe_value'],['desc'])).fe_value;
                bestAnnos.push(temp);

            });
            geneRecord.header['bestAnnotationAndMethods'] = bestAnnos;
            geneRecord.header['bestAncestries'] = _.uniqBy(allRecs,'ancestry');
            geneRecord.header['bestTissues'] = _.map(_.uniqBy(allRecs,'tissue'),function(oo){
                oo['tissue_hdr_fe_value'] = _.first(_.orderBy(_.filter (allRecs,{'tissue':oo.tissue}),['fe_value'],['desc'])).fe_value;
                return oo;
            });
            // add an additional tissue name
            let vectorWithAllRecords = [];
            _.forEach(allRecs, function (oneRec) {
                let holder = oneRec;
                holder['safeTissueId'] = oneRec.tissue_id.replace(":","_");
                holder['annotationAndMethod'] = oneRec.annotation+"_"+oneRec.method;
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
    setGregorSubTableByPValueAndFEValue();
    // $('div.gregorVariantTableBody').filter(function() {return $(this).attr("sortField") <= currentValue;}).show();
    // $('div.gregorVariantTableBody').filter(function() {return $(this).attr("sortField") > currentValue;}).hide();
    // $('div.gregorSubTableRow').filter(function() {return $(this).attr("sortvalue") <= currentValue;}).find('input.gregorSubTableRowHeader').prop('checked', true);
    // $('div.gregorSubTableRow').filter(function() {return $(this).attr("sortvalue") > currentValue;}).find('input.gregorSubTableRowHeader').prop('checked', false);
    // $('div.gregorSubTableHeader').filter(function() {return $(this).attr("sortvalue") <= currentValue;}).find('input.gregorSubTableRowHeader').prop('checked', true);
    // $('div.gregorSubTableHeader').filter(function() {return $(this).attr("sortvalue") > currentValue;}).find('input.gregorSubTableRowHeader').prop('checked', false);
};


    const setGregorSubTableByFEValue = function(currentValue){
        setGregorSubTableByPValueAndFEValue();
        // $('div.gregorVariantTableBody').filter(function() {return $(this).attr("sortFEField") >= currentValue;}).show();
        // $('div.gregorVariantTableBody').filter(function() {return $(this).attr("sortFEField") < currentValue;}).hide();
        // $('div.gregorSubTableRow').filter(function() {return $(this).attr("sortFEvalue") >= currentValue;}).find('input.gregorSubTableRowHeader').prop('checked', true);
        // $('div.gregorSubTableRow').filter(function() {return $(this).attr("sortFEvalue") < currentValue;}).find('input.gregorSubTableRowHeader').prop('checked', false);
        // $('div.gregorSubTableHeader').filter(function() {return $(this).attr("sortFEvalue") >= currentValue;}).find('input.gregorSubTableRowHeader').prop('checked', true);
        // $('div.gregorSubTableHeader').filter(function() {return $(this).attr("sortFEvalue") < currentValue;}).find('input.gregorSubTableRowHeader').prop('checked', false);

    };


    const setGregorSubTableByPValueAndFEValue = function(){
        const currentPValue = rememberCutOffs[fieldsForPValue.rememberCutOff];
        const currentFEValue = rememberCutOffs[fieldsForFEValue.rememberCutOff];
        const andTheCutoffs = ($(fieldDescribingCombinationStrategy).text()==='AND');
        let fieldPasses;
        let fieldFails;
        let valuePasses;
        let valueFails;
        if (andTheCutoffs) {
            fieldPasses = function () {
                return (($(this).attr("sortField") <= currentPValue) &&
                    ($(this).attr("sortFEField") >= currentFEValue));
            };
            fieldFails = function () {
                return (($(this).attr("sortField") > currentPValue) ||
                    ($(this).attr("sortFEField") < currentFEValue));
            };

            valuePasses = function () {
                return (($(this).attr("sortvalue") <= currentPValue) &&
                    ($(this).attr("sortFEvalue") >= currentFEValue));
            };
            valueFails = function () {
                return (($(this).attr("sortvalue") > currentPValue) ||
                    ($(this).attr("sortFEvalue") < currentFEValue));
            };
        } else {
            fieldPasses = function () {
                return (($(this).attr("sortField") <= currentPValue) ||
                    ($(this).attr("sortFEField") >= currentFEValue));
            };
            fieldFails = function () {
                return (($(this).attr("sortField") > currentPValue) &&
                    ($(this).attr("sortFEField") < currentFEValue));
            };
            valuePasses = function () {
                return (($(this).attr("sortvalue") <= currentPValue) ||
                    ($(this).attr("sortFEvalue") >= currentFEValue));
            };
            valueFails = function () {
                return (($(this).attr("sortvalue") > currentPValue) &&
                    ($(this).attr("sortFEvalue") < currentFEValue));
            };
        }
        $('div.gregorVariantTableBody').filter(fieldPasses).show();
        $('div.gregorVariantTableBody').filter(fieldFails).hide();
        $('div.gregorSubTableRow').filter(valuePasses).find('input.gregorSubTableRowHeader').prop('checked', true);
        $('div.gregorSubTableRow').filter(valueFails).find('input.gregorSubTableRowHeader').prop('checked', false);
        $('div.gregorSubTableHeader').filter(valuePasses).find('input.gregorSubTableRowHeader').prop('checked', true);
        $('div.gregorSubTableHeader').filter(valueFails).find('input.gregorSubTableRowHeader').prop('checked', false);
    };

    const changeCombinationStrategy= function(){
        const domElementName = fieldDescribingCombinationStrategy;
        if (( typeof domElementName === 'undefined') ||
            (domElementName.length  === 0 )){
            alert('expected a domElementName to describe the indicator field');
            return;
        }
        const domElement = $(domElementName);
        if ( domElement.length !== 1){
            alert('expected the dom name="'+domElementName+'" to correspond to a unique element on the page.');
            return;
        }
        if (domElement.text()==='AND'){
            domElement.text('OR');
        } else if (domElement.text()==='OR'){
            domElement.text('AND');
        } else {
            alert('Unexpected value for text name = "'+domElement.text()+'".');
        }
        setGregorSubTableByPValueAndFEValue();
    }



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
            rememberCutOffs[fieldsForPValue.rememberCutOff] = Math.pow(10, 0-(logMinVal+(ui.value*(logMaxVal-logMinVal)/100.0)));
            valueDisplay.text( UTILS.realNumberFormatter(rememberCutOffs[fieldsForPValue.rememberCutOff]) );
            //setGregorSubTableByPValue(rememberCutOffs[fieldsForPValue.rememberCutOff]);
            setGregorSubTableByPValueAndFEValue();
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
            value: defaultGregorFEValue,
            step:(maxVal-minVal)/100.0,
            create: function() {
                rememberCutOffs[fieldsForFEValue.rememberCutOff] = defaultGregorFEValue;
                valueDisplay.text( UTILS.realNumberFormatter(defaultGregorFEValue));
            },
            slide: function( event, ui ) {
                rememberCutOffs[fieldsForFEValue.rememberCutOff] = ui.value;
                valueDisplay.text( UTILS.realNumberFormatter(rememberCutOffs[fieldsForFEValue.rememberCutOff]) );
                // setGregorSubTableByFEValue(rememberCutOffs[fieldsForFEValue.rememberCutOff]);
                setGregorSubTableByPValueAndFEValue();
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
        var valueDisplay = $( "span.dynamicDisplay" );
        var valueFEDisplay = $( "span.dynamicFEDisplay" );
        if (objectContainingRetrievedRecords.length<1) return;
        setUpFilterAndSlider(objectContainingRetrievedRecords[0],valueDisplay);
        setUpFEFilterAndSlider(objectContainingRetrievedRecords[0],valueFEDisplay);
        mpgSoftware.dynamicUi.displayGregorSubTableForVariantTable(idForTheTargetDiv, // which table are we adding to
            // callingParameters.code, // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
            // callingParameters.nameOfAccumulatorField, // name of the persistent field where the data we received is stored
            callingParameters,
            // take all the records for each row and insert them into the intermediateDataStructure
            function( rawGregorRecord ){
                return rawGregorRecord;
            },
            createSingleDnaseCell
        );
        //setGregorSubTableByPValue(objectContainingRetrievedRecords[0].header.defaultGregorPValueUpperValue);
        setGregorSubTableByPValueAndFEValue()
        mpgSoftware.dynamicUi.filterEpigeneticTable("#mainVariantDiv table.variantTableHolder",
                                                    false,
                                                    callingParameters.baseDomElement );
    };


    const deemphasizeOneFilter = function(itemToEmphasize,arrayOfItemsToDeemphasize){
        const domItemToEmphasize = $(itemToEmphasize);
        _.forEach(arrayOfItemsToDeemphasize,function (oneItemToDeemphasize){
            $(oneItemToDeemphasize).css('opacity',0.5)
        });
        domItemToEmphasize.css('opacity',1.0);
        if (domItemToEmphasize.find('span.dynamicDisplay').length>0){
            const valueToWhichWePayAttention = $( "span.dynamicDisplay" );
            const valueAsANumber = UTILS.convertStringToNumber(valueToWhichWePayAttention.text());
            setGregorSubTableByPValue(valueAsANumber);
        } else if (domItemToEmphasize.find('span.dynamicFEDisplay').length>0){
            const valueToWhichWePayAttention = $( "span.dynamicFEDisplay" );
            const valueAsANumber = UTILS.convertStringToNumber(valueToWhichWePayAttention.text());
            setGregorSubTableByFEValue(valueAsANumber);
        }
    }


    /***
     *  3) set of categorizor routines
     * @type {Categorizor}
     */
    var categorizor = new mpgSoftware.dynamicUi.Categorizor();
    categorizor.categorizeSignificanceNumbers = Object.getPrototypeOf(categorizor).genePValueSignificance;




// public routines are declared below
    return {
        processRecordsFromGregor: processRecordsFromGregor,
        displayGregorSubTable:displayGregorSubTable,
        deemphasizeOneFilter:deemphasizeOneFilter,
        changeCombinationStrategy:changeCombinationStrategy,
        setGregorSubTableByPValueAndFEValue:setGregorSubTableByPValueAndFEValue
    }
}());