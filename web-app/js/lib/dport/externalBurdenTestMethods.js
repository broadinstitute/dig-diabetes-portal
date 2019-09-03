var mpgSoftware = mpgSoftware || {};

(function () {
    "use strict";

    mpgSoftware.externalBurdenTestMethods = (function () {

        var generateObjectForLdServer = function ( arrayOfVariants,
                                                   phenotype ){
            var chromosome;
            var startPosition;
            var endPosition;
            var returnValue;
            var refinedArrayOfVariants = _.map(arrayOfVariants, function (rawVariant){
                var extractedParts = UTILS.extractParts(rawVariant);
                if (typeof chromosome === 'undefined'){
                    chromosome = extractedParts.chromosome;
                }
                var position = _.parseInt(extractedParts.position);
                if ((typeof startPosition === 'undefined')||( startPosition >  position)){
                    startPosition = position;
                }
                if ((typeof endPosition === 'undefined')||( endPosition <  position)){
                    endPosition = position;
                }
                return extractedParts.chromosome+":"+extractedParts.position+"_"+extractedParts.reference+"/"+extractedParts.alternate;
            } );

            if (    ( typeof chromosome !== 'undefined' ) &&
                ( typeof startPosition !== 'undefined' ) &&
                ( typeof endPosition !== 'undefined' ) &&
                ( refinedArrayOfVariants.length>0 ) ) {
                returnValue = {
                    "chrom": chromosome,
                    "start": startPosition,
                    "stop": endPosition,
                    "genotypeDataset": 1,
                    "phenotypeDataset": 1,
                    "phenotype": phenotype,
                    "samples": "ALL",
                    "genomeBuild": "GRCh37",
                    "maskDefinitions": [
                        {
                            "id": 10,
                            "name": "On-the-fly mask",
                            "description": "Mask created on the fly, potentially by using a browser UI",
                            "genome_build": "GRCh37",
                            "group_type": "GENE",
                            "identifier_type": "ENSEMBL",
                            "groups": {
                                "CRELD2": refinedArrayOfVariants
                            }
                        }
                    ]
                }

            }
            return returnValue;
        }


        var buildUMichBurdenTestPromiseArray = function (url, covariance_request_spec, subtype, resultDisplayFunction ) {
            var promiseArray = [];
            var promise = $.ajax({
                cache: false,
                type: "post",
                contentType: "application/json",
                url: url,
                data: JSON.stringify(covariance_request_spec),
                async: true
            });
            promise.done(resp => {
                if (resp.ok) {
                    return resp.json();
                }
            });
            promise.fail( function (jqXHR, textStatus, errorThrown){
                    alert('Burden test calculation failed, text='+textStatus+', error='+errorThrown+'.');
                }
            );
            promiseArray.push(
                promise.then(
                    function(json){ // Use the returned covariance data to run aggregation tests and return results (note that runner.run() returns a Promise)
                        const [groups, variants] = raremetal.helpers.parsePortalJSON(json);
                        const runner = new raremetal.helpers.PortalTestRunner(groups, variants, [ // One or more test names can be specified!
                            // 'burden',
                            //'skat',
                            //'skat-o',
                            //'vt'
                            subtype
                        ]);
                        return runner.run();
                    }
                ).then(res=>{
                    resultDisplayFunction(res)
                }
                ).catch(e => {

                })
            );
            return promiseArray;
        };
        var buildAndRunUMichTest = function (asynchronousPromiseRunner, url, variableList, phenotype, subtype, displayResults) {
            var covariance_request_spec = generateObjectForLdServer(variableList,phenotype);
            asynchronousPromiseRunner(buildUMichBurdenTestPromiseArray(url, covariance_request_spec, subtype,displayResults),undefined);
        }
        var showOnlyRelevantInterfaceSections = function (currentDropdown) {
            const method = $(currentDropdown).val();
            switch(method){
                case 'sum':
                case 'max':
                    $('#chooseFiltersLocation').show();
                    $('#chooseCovariatesLocation').show();
                    $('#stratifyDesignation').attr("disabled", false);
                    break;
                case 'skat':
                case 'skat-o':
                case 'vt':
                case 'burden':
                    $('#chooseFiltersLocation').hide();
                    $('#chooseCovariatesLocation').hide();
                    $('#stratifyDesignation').attr("disabled", true);
                    break;
                default:
                    alert('unrecognized aggregation test type ='+method+'.');
                    break;
            }
        }


        return {
            // public routines
            showOnlyRelevantInterfaceSections:showOnlyRelevantInterfaceSections,
            buildAndRunUMichTest: buildAndRunUMichTest,
        }
    }());
})();