var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.geneBurdenSkat = (function () {



    var processGeneSkatAssociationRecords = function (data,rawGeneAssociationRecords) {

        if ( ( typeof data !== 'undefined') &&
            (  data.is_error !== true ) &&
            (  data.numRecords > 0 ) &&
            ( typeof data.variants !== 'undefined' ) ){
            var geneRecord = {};
            _.forEach(data.variants[0], function (oneRec) {
                _.forEach(oneRec, function(sampleRecord,tissue){
                    if ((tissue==='GENE')||(tissue==='Gene')) {
                        geneRecord['gene'] = sampleRecord;
                        geneRecord['tissues'] = [];
                    } else if (tissue==='TISSUE_TRANSLATIONS') {
                        geneRecord['TISSUE_TRANSLATIONS'] = sampleRecord;
                    } else {
                        _.forEach(sampleRecord, function (phenotypeRecord, dataset) {
                            _.forEach(phenotypeRecord, function (number, phenotypeString) {

                                if (number !== null) {
                                    geneRecord['tissues'].push({tissue: tissue, value: number});

                                }
                            })
                        });
                    }
                });
            });
            if ((typeof geneRecord !== 'undefined')&&(typeof geneRecord.gene !== 'undefined')){
                rawGeneAssociationRecords.push(geneRecord);
            }
        }



        return rawGeneAssociationRecords;

    };



// public routines are declared below
    return {
        processGeneSkatAssociationRecords: processGeneSkatAssociationRecords
    }
}());
