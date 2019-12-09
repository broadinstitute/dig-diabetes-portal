var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.sharednameRenderData = (function () {

    var RenderData = function(){

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
    RenderData.prototype.variantTableTissueDominant =  function( allRecords,
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


    return {
        RenderData: RenderData
    }
}());