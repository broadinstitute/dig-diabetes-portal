var mpgSoftware = mpgSoftware || {};  // encapsulating variable

mpgSoftware.igvInit = (function () {

    var HASH_PREFIX = "#/locus/";
    var currentHash = window.location.hash;
    //var locus = (0 === currentHash && currentHash.indexOf(HASH_PREFIX)) ? currentHash.substr(HASH_PREFIX.length) : "chr1:155,160,475-155,184,282";


    const setVariable = function (nameOfBase,objectToRemember) {
         $(nameOfBase).data("dataHolder",objectToRemember);
    };

    const getVariable = function (nameOfBase) {
        return $(nameOfBase).data("dataHolder");
    };

    const addToStoredVariantList = function (nameOfBase,variantToAdd) {
        const savedVariable = getVariable('#'+nameOfBase);
        const existingVariantList = savedVariable.storedVariantList;
        if ( typeof existingVariantList === 'undefined') { // no variants stored yet
            savedVariable["storedVariantList"] = [savedVariable.storedVariantList];
        } else {
            if (!_.includes(existingVariantList,variantToAdd)){
                existingVariantList.push(variantToAdd);
            }
        }
    };


    const generateAddToStoredVariantListFunction = function (nameOfBase) {
        // return a function preset with the nameOfBase variable
        return function (variantToAdd) {
            const savedVariable = getVariable('#'+nameOfBase);
            const existingVariantList = savedVariable.storedVariantList;
            if ( typeof existingVariantList === 'undefined') { // no variants stored yet
                savedVariable["storedVariantList"] = [variantToAdd];
            } else { // add to the existing variant list
                if (!_.includes(existingVariantList,variantToAdd)){
                    existingVariantList.push(variantToAdd);
                }
            }
            return existingVariantList;
        };
    };



    const igvLaunch = function (nameOfBase,
                                chromosome,
                                startPosition,
                                endPosition,
                                phenotype,
                                limit
                                ) {
        document.addEventListener("DOMContentLoaded", function () {
            alert("DOMContentLoaded");
        });
        var igvDiv = document.getElementById(nameOfBase);
        const savedVariable = getVariable('#'+nameOfBase);
        startPosition = startPosition || 36089936;
        endPosition = endPosition || 36110735;
        chromosome = chromosome || "17";
        phenotype = phenotype || "T2D";
        limit = limit || 200;
        const args = "?phenotype="+phenotype+
                    "&startPos="+startPosition+
                    "&endPos="+endPosition+
                    "&chromosome="+chromosome+
                    "&limit="+limit;
        var options =
            {
                genome: "hg38",
                locus: "chr"+chromosome+":"+startPosition+"-"+endPosition,
                // locus: [
                //     "myc",
                //     "egfr"
                // ],
                queryParametersSupported: true,
                promisified: true,
                // roi: [
                //     {
                //         name: 'ROI set 1',
                //         url: 'https://s3.amazonaws.com/igv.org.test/data/roi/roi_bed_1.bed',
                //         indexed: false,
                //         color: "rgba(68, 134, 247, 0.25)"
                //     }
                // ],
                tracks: [
                    // {
                    //     type: "annotation",
                    //     format: "bed",
                    //     url: "https://dig-humgen.s3.amazonaws.com/atac_seq.uberon_0000017.bed.gz",
                    //     indexURL: "https://dig-humgen.s3.amazonaws.com/atac_seq.uberon_0000017.bed.gz.tbi",
                    //     name: "ATAC-seq",
                    //     visibilityWindow: 10000000
                    // },
                    {
                        "name": "HG00103",
                        "url": "https://s3.amazonaws.com/1000genomes/data/HG00103/alignment/HG00103.alt_bwamem_GRCh38DH.20150718.GBR.low_coverage.cram",
                        "indexURL": "https://s3.amazonaws.com/1000genomes/data/HG00103/alignment/HG00103.alt_bwamem_GRCh38DH.20150718.GBR.low_coverage.cram.crai",
                        "format": "cram",
                        "order": 50
                    }
                    ,
                    // {
                    //     "name": "Sample BAM",
                    //     "url": "https://idea-cdn.s3.eu-west-2.amazonaws.com/out.marked.bam",
                    //     "indexURL": "https://idea-cdn.s3.eu-west-2.amazonaws.com/out.marked.bai",
                    //     "format": "bam",
                    //     height: 100,
                    //     "order": 51
                    // },
                    // {
                    //     name: "gnomAD coverage at 10x",
                    //     url:  "https://s3.us-east-2.amazonaws.com/ccrs/tracks/gnomad-coverage.bw",
                    //     type: "wig",
                    //     color: function(value) {
                    //         var c;
                    //         if (value < 0.5){
                    //             c = "#ff8c00"
                    //         }
                    //         if (value >= 0.5){
                    //             c = "#add8e6"
                    //         }
                    //         return c
                    //     },
                    //     height: 50,
                    //     visibilityWindow: 500000
                    // },
                    {
                        url: 'https://www.encodeproject.org/files/ENCFF000ASF/@@download/ENCFF000ASF.bigWig',
                        name: 'GM12878 H3K4me3',
                        color: 'rgb(200,0,0)',
                        "order": 52
                    },
                    // {
                    //     url: 'https://www.encodeproject.org/files/ENCFF000AST/@@download/ENCFF000AST.bigWig',
                    //     name: 'GM12878 H3K4me3',
                    //     color: 'rgb(0,0,150)',
                    //     autoscaleGroup: '1',
                    //     min: -5,
                    //     max: 5
                    // },
                    {
                        url: 'https://s3.us-east-2.amazonaws.com/ccrs/tracks/gerp.bw',
                        name: 'GERP',
                        type: "wig",
                        color: function(value) {
                            var c;
                            if (value < 1.7){
                                c = "rgb(0,0,255)"
                            }
                            if (value >= 1.7){
                                c = "rgb(255,0,0)"
                            }
                            return c
                        },
                        "order": 53
                    }
                    ,
                    // {
                    //      name: 'T2D GWAS',
                    //      trait: "T2D",
                    //      label: "Type 2 Diabetes: DIAGRAM GWAS",
                    //      maxLogP: 10,
                    //      height: 200,
                    //      pvalue: "P-value",
                    //      colorScale:  {
                    //         thresholds: [5e-8, 5e-4, 0.05],
                    //         colors: ["rgb(0,102,51)", "rgb(122,179,23)", "rgb(158,213,76)", "rgb(227,238,249)"]
                    //      },
                    //
                    //     type: 'gwas',
                    //     format: 'gtexgwas',
                    //
                    //     url: savedVariable['retrieveBottomLineVariants']+args,
                    //
                    //     rememberVariant: generateAddToStoredVariantListFunction(nameOfBase),
                    //
                    //     indexed: false,
                    //     color: 'rgb(100,200,200)',
                    //     displayMode: 'EXPANDED',
                    //     autoHeight: true,
                    //     // autoscaleGroup: '2',
                    //     autoscale: true
                    //     // order: Number.MAX_SAFE_INTEGER // 2nd to last track
                    // }
                ]
            };

        igv.createBrowser(igvDiv, options)
            .then(function (browser) {
                igv.browser = browser;
                var genesInList = {};
                var variantsInList = {};
                console.log("Created IGV browser");

                browser.on('trackclick', function (track, popoverData) {

                    if ( ( typeof track !== 'undefined') &&
                        ( track.config.type == 'gwas') &&
                        ( typeof popoverData !== 'undefined') ){
                        let variantIdentifier =  null ;
                        popoverData.forEach(function (nameValue) {
                            if (nameValue.name && nameValue.name === 'ID') {
                                variantIdentifier = nameValue.value;
                            }
                            if (variantIdentifier && !variantsInList[variantIdentifier]) {
                                variantsInList[variantIdentifier] = true;
                                $("#variantList").append('<li><a class="variantIdentifier '+variantIdentifier+'" href="#' + variantIdentifier + '">' + variantIdentifier + '</a></li>');
                            }
                        });
                        return true;
                    } else  if ( ( typeof track !== 'undefined') &&
                        ( track.config.name == 'Refseq Genes') &&
                        ( typeof popoverData !== 'undefined') ){
                        let symbol = null;
                        popoverData.forEach(function (nameValue) {
                            if (nameValue.name && nameValue.name.toLowerCase() === 'name') {
                                symbol = nameValue.value;
                            }
                            if (symbol && !genesInList[symbol]) {
                                genesInList[symbol] = true;
                                $("#geneList").append('<li><a href="https://uswest.ensembl.org/Multi/Search/Results?q=' + symbol + '">' + symbol + '</a></li>');
                            }
                        });
                        // popoverData.forEach(function (nameValue) {
                        //     if (nameValue.name && nameValue.name.toLowerCase() === 'name') {
                        //         symbol = nameValue.value;
                        //     }
                        //     if (symbol && !genesInList[symbol]) {
                        //         genesInList[symbol] = true;
                        //         $("#geneList").append('<li><a href="https://uswest.ensembl.org/Multi/Search/Results?q=' + symbol + '">' + symbol + '</a></li>');
                        //     }
                        // });
                        return false;
                    }


                    // Prevent default pop-over behavior
                    return false;
                });

                browser.on('locuschange', function (referenceFrame) {
                    //window.location.replace(HASH_PREFIX + referenceFrame.label);
                });
                browser.on('trackdragend', function (a) {
                   // alert('trackdragend');
                });


            });


    }


    return {
        setVariable:setVariable,
        igvLaunch: igvLaunch
    }
}());