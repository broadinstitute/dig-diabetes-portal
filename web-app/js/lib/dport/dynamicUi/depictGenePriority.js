var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.depictGenePvalue = (function () {



    var processRecordsFromDepictGenePvalue = function (data, rawGeneAssociationRecords) {

        var dataArrayToProcess = [];
        if ( typeof data !== 'undefined'){
            var geneName = '';
            dataArrayToProcess = {
                tissues:_.map(data,function(oneRec){
                    geneName = oneRec.gene;
                    return {
                        gene:oneRec.gene,
                        chrom:oneRec.region_chr,
                        start_pos:oneRec.region_start,
                        stop_pos:oneRec.region_end,
                        dataset:oneRec.dataset,
                        value:oneRec.pvalue
                    };
                })
            };
            dataArrayToProcess ['gene'] = geneName;
        }
        rawGeneAssociationRecords.push(dataArrayToProcess);


        return rawGeneAssociationRecords;
    }




// public routines are declared below
    return {
        processRecordsFromDepictGenePvalue: processRecordsFromDepictGenePvalue
    }
}());



