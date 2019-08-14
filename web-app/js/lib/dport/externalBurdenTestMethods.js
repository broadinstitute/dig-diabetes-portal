var mpgSoftware = mpgSoftware || {};

(function () {
    "use strict";

    mpgSoftware.externalBurdenTestMethods = (function () {

        var sample_mask_payload = {
            "chrom": "22",
            "start": 50276998,
            "stop": 50357719,
            "genotypeDataset": 1,
            "phenotypeDataset": 1,
            "phenotype": "ldl",
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
                        "CRELD2": [
                            "22:50312454_C/T",
                            "22:50313452_C/T",
                            "22:50313465_C/A",
                            "22:50315537_A/G",
                            "22:50315971_C/G",
                            "22:50316015_C/T",
                            "22:50316301_A/G",
                            "22:50316902_G/A",
                            "22:50316906_C/T",
                            "22:50317418_C/T",
                            "22:50318061_G/C",
                            "22:50318402_C/T",
                            "22:50318757_C/T",
                            "22:50319373_C/T",
                            "22:50319968_G/A",
                            "22:50320921_G/A"
                        ]
                    }
                }
            ]
        };

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


        var buildUMichBurdenTestPromiseArray = function (url, covariance_request_spec, subtype ) {
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
                    alert('LD server call failed, text='+textStatus+', error='+errorThrown+'.');
                }
            );
            promiseArray.push(
                promise.then(
                    function(json){ // Use the returned covariance data to run aggregation tests and return results (note that runner.run() returns a Promise)
                        const [groups, variants] = raremetal.helpers.parsePortalJSON(json);
                        const runner = new raremetal.helpers.PortalTestRunner(groups, variants, [ // One or more test names can be specified!
                            // 'burden',
                            //'skat',
                            //'vt'
                            subtype
                        ]);
                        return runner.run();
                    }
                ).then(res =>
                    {
                        console.log(`Ran ${res.length} test(s)`);
                        console.log(res);
                    }
                ).catch(e => {
                    results.value = 'Calculations failed; see JS console for details.'
                })
            );
            return promiseArray;
        };
        var buildAndRunUMichTest = function (asynchronousPromiseRunner, url, variableList, phenotype, subtype) {
            var covariance_request_spec = generateObjectForLdServer(variableList,phenotype);
            asynchronousPromiseRunner(buildUMichBurdenTestPromiseArray(url, covariance_request_spec, subtype),undefined);
        }



        // When the page loads, get the data and display the results
        // var results = document.getElementById('results-display');
        // buildAndRunScatTest('http://raremetal.type2diabeteskb.org/aggregation/covariance', generateObjectForLdServer([
        //     "22:50312454_C/T",
        //     "22:50313452_C/T",
        //     "22:50313465_C/A",
        //     "22:50315537_A/G",
        //     "22:50315971_C/G",
        //     "22:50316015_C/T",
        //     "22:50316301_A/G",
        //     "22:50316902_G/A",
        //     "22:50316906_C/T",
        //     "22:50317418_C/T",
        //     "22:50318061_G/C",
        //     "22:50318402_C/T",
        //     "22:50318757_C/T",
        //     "22:50319373_C/T",
        //     "22:50319968_G/A",
        //     "22:50320921_G/A"
        // ], "LDL"));
        return {
            // public routines
            buildAndRunUMichTest: buildAndRunUMichTest,
        }
    }());
})();