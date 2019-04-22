
var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.mouseKnockout = (function () {



    var processRecordsFromMod = function (data, rawGeneAssociationRecords) {

        var dataArrayToProcess = [];
        if ( typeof data !== 'undefined'){
            dataArrayToProcess = {  gene:data.gene,
                tissues:data.records
            };
        }
        rawGeneAssociationRecords.push(dataArrayToProcess);
    };




// public routines are declared below
    return {
        processRecordsFromMod: processRecordsFromMod
    }
}());
