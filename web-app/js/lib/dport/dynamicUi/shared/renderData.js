var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.sharednameRenderData = (function () {

    var RenderData = function(){

    };

    RenderData.prototype.groupRawData =  function(  uniqueRecords,
                                                    currentMethod,
                                                    currentAnnotations,
                                                                     dataAnnotationTypeCode,
                                                                     significanceValue,
                                                                     tissueName ) {

        _.forEach(uniqueRecords, function (oneValue) {
            oneValue['safeTissueId'] = oneValue.tissue_id.replace(":", "_");
        });
        let dataGroupings = {
            groupByVarId: [],
            groupByAnnotation: [],
            groupByTissue: [],
            groupByTissueAnnotation: [],
            currentMethod: currentMethod,
            currentAnnotation: currentAnnotations
        };
        _.forEach(_.groupBy(uniqueRecords, function (o) {
            return o.var_id
        }), function (value, key) {
            dataGroupings.groupByVarId.push({name: key, arrayOfRecords: value});
        });
        _.forEach(_.groupBy(uniqueRecords, function (o) {
            return o.annotation
        }), function (recordsGroupedByAnnotation, annotation) {
            let groupedByAnnotation = {name: annotation, arrayOfRecords: []};
            _.forEach(_.groupBy(recordsGroupedByAnnotation, function (o) {
                return o.var_id
            }), function (recordsSubGroupedByVarId, varId) {
                groupedByAnnotation.arrayOfRecords.push({name: varId, arrayOfRecords: recordsSubGroupedByVarId});
            });
            dataGroupings.groupByAnnotation.push(groupedByAnnotation);
        });
        _.forEach(_.groupBy(uniqueRecords, function (o) {
            return o.tissue_id
        }), function (recordsGroupedByTissue, tissue) {
            let groupedByTissue = {
                name: tissue,
                tissue_name: recordsGroupedByTissue[0].tissue_name,
                safeTissueId: recordsGroupedByTissue[0].safeTissueId,
                arrayOfRecords: []
            };
            _.forEach(_.groupBy(recordsGroupedByTissue, function (o) {
                return o.var_id
            }), function (recordsSubGroupedByVarId, varId) {
                groupedByTissue.arrayOfRecords.push({name: varId, arrayOfRecords: recordsSubGroupedByVarId});
            });
            dataGroupings.groupByTissue.push(groupedByTissue);
        });
        return dataGroupings;
    };

    RenderData.prototype.variantTableAnnotationDominant =  function( allRecords,
                                                                     method,
                                                                     annotation,
                                                                     dataAnnotationTypeCode,
                                                                     significanceValue,
                                                                     tissueName ){
        const recordsCellPresentationString = "";
        const significanceCellPresentationString = "";
        return {
            tissueRecords:allRecords,
            uniqueTissueRecords:_.uniqBy(allRecords,'tissue_id'),
            recordsExist:(allRecords.length>0)?[1]:[],
            cellPresentationStringMap:{
                'Significance':significanceCellPresentationString,
                'Records':recordsCellPresentationString
            },
            dataAnnotationTypeCode:dataAnnotationTypeCode,
            significanceValue:significanceValue,
            tissueNameKey:( typeof tissueName !== 'undefined')?tissueName.replace(/ /g,"_"):'var_name_missing',
            tissueName:tissueName,
            tissuesFilteredByAnnotation:allRecords,
            method:method,
            annotation:annotation
        };

    };


    RenderData.prototype.variantTableTissueDominant =  function(    oneRecord,
                                                                    method,
                                                                    annotation,
                                                                    tissueId,
                                                                    existingCell,
                                                                    dataAnnotationTypeCode,
                                                                    significanceValue,
                                                                    tissueName ){
        let arrayOfRecords = [];
        if ( typeof existingCell === 'undefined'){
            alert('wtf -- this cell should never be undefined');
        } else {
            if (existingCell.dataAnnotationTypeCode !== 'EMP') {
                arrayOfRecords = existingCell.renderData.tissueRecords;
            }
            arrayOfRecords = _.concat(arrayOfRecords, oneRecord.arrayOfRecords);
            arrayOfRecords = _.uniq(arrayOfRecords);
        };
        const recordsCellPresentationString = "";
        const significanceCellPresentationString = "";
        return {
            tissueRecords:arrayOfRecords,
            uniqueTissueRecords:_.uniqBy(arrayOfRecords,'tissue_id'),
            recordsExist:(arrayOfRecords.length>0)?[1]:[],
            cellPresentationStringMap:{
                'Significance':significanceCellPresentationString,
                'Records':recordsCellPresentationString
            },
            dataAnnotationTypeCode:dataAnnotationTypeCode,
            significanceValue:significanceValue,
            tissueNameKey:( typeof tissueName !== 'undefined')?tissueName.replace(/ /g,"_"):'var_name_missing',
            tissueName:tissueName,
            tissuesFilteredByAnnotation:arrayOfRecords,
            method:method,
            annotation:annotation
        };

    };


    return {
        RenderData: RenderData
    }
}());