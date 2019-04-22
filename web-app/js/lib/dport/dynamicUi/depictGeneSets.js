var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.depictGeneSets = (function () {



    var processRecordsFromDepictGeneSet = function (data, rawGeneAssociationRecords) {

        var dataArrayToProcess = [];
        if ( typeof data !== 'undefined'){
            dataArrayToProcess = {  gene:data.gene,
                                    tissues:_.map(data.data,function(oneRec){
                                        return {
                                            gene:oneRec.gene,
                                            gene_list:oneRec.gene_list,
                                            pathway_description:oneRec.pathway_description,
                                            pathway_id:oneRec.pathway_id,
                                            tissue:oneRec.pathway_id,
                                            value:oneRec.pvalue
                                        };
                                    })
            };
        }
        rawGeneAssociationRecords.push(dataArrayToProcess);


        return rawGeneAssociationRecords;
    }




// public routines are declared below
    return {
        processRecordsFromDepictGeneSet: processRecordsFromDepictGeneSet
    }
}());



