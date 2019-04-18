var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.depictGeneSets = (function () {



    var processRecordsFromDepictGeneSet = function (data, rawGeneAssociationRecords) {

        var dataArrayToProcess = [];
        if ( typeof data !== 'undefined'){
            dataArrayToProcess = {  gene:data.gene,
                                    tissues:data.data };
        }
        rawGeneAssociationRecords.push(dataArrayToProcess);


        return rawGeneAssociationRecords;
    }




// public routines are declared below
    return {
        processRecordsFromDepictGeneSet: processRecordsFromDepictGeneSet
    }
}());



