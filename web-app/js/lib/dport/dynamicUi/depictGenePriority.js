var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.depictGenePvalue = (function () {



    var processRecordsFromDepictGenePvalue = function (data, rawGeneAssociationRecords) {

        var dataArrayToProcess = [];
        if ( typeof data !== 'undefined'){
            _.forEach(data,function(oneRec){
                dataArrayToProcess = {
                    gene: oneRec.gene,
                    tissues: [{
                        gene: oneRec.gene,
                        value: oneRec.pvalue
                    }]
                };
            });


        }
        rawGeneAssociationRecords.push(dataArrayToProcess);
    }




// public routines are declared below
    return {
        processRecordsFromDepictGenePvalue: processRecordsFromDepictGenePvalue
    }
}());



