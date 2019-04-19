var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.coloc = (function () {



    var processRecordsFromColoc = function (data, rawGeneAssociationRecords) {


        var dataArrayToProcess = [];
        if ( typeof data !== 'undefined'){
            var geneName = '';
            dataArrayToProcess = {
                tissues:_.map(data,function(oneRec){
                    geneName = oneRec.gene;
                    return oneRec;
                })
            };
            dataArrayToProcess ['gene'] = geneName;
        }
        rawGeneAssociationRecords.push(dataArrayToProcess);


        return rawGeneAssociationRecords;
    };




// public routines are declared below
    return {
        processRecordsFromColoc: processRecordsFromColoc
    }
}());
