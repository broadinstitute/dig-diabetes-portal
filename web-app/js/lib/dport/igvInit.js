var mpgSoftware = mpgSoftware || {};  // encapsulating variable

mpgSoftware.igvInit = (function () {

    const setVariable = function (nameOfBase,objectToRemember) {
         $(nameOfBase).data("dataHolder",objectToRemember);
    };

    const getVariable = function (nameOfBase) {
        return $(nameOfBase).data("dataHolder");
    };

    const igvLaunch = function (nameOfBase,
                                chromosome,
                                startPosition,
                                endPosition,
                                phenotype,
                                limit
                                ) {
        var igvDiv = document.getElementById(nameOfBase);
        const savedVariable = getVariable('#'+nameOfBase);
        startPosition = startPosition || 41233047;
        endPosition = endPosition || 41235646;
        chromosome = chromosome || "17"
        phenotype = phenotype || "T2D"
        limit = limit || 200
        const args = "?phenotype="+phenotype+
                    "&startPos="+startPosition+
                    "&endPos="+endPosition+
                    "&chromosome="+chromosome+
                    "&limit="+limit;
        var options =
            {
                genome: "hg38",
                locus: "chr"+chromosome+":"+startPosition+"-"+endPosition,
                clickHandler:  function(){alert("click handler")},
                init:  function(){alert("init")},
                tracks: [
                    {
                        "name": "HG00103",
                        "url": "https://s3.amazonaws.com/1000genomes/data/HG00103/alignment/HG00103.alt_bwamem_GRCh38DH.20150718.GBR.low_coverage.cram",
                        "indexURL": "https://s3.amazonaws.com/1000genomes/data/HG00103/alignment/HG00103.alt_bwamem_GRCh38DH.20150718.GBR.low_coverage.cram.crai",
                        "format": "cram"
                    }
                    ,
                    {
                        "name": "Sample BAM",
                        "url": "https://idea-cdn.s3.eu-west-2.amazonaws.com/out.marked.bam",
                        "indexURL": "https://idea-cdn.s3.eu-west-2.amazonaws.com/out.marked.bai",
                        "format": "bam"
                    },
                    {
                        name: "gnomAD coverage at 10x",
                        url:  "https://s3.us-east-2.amazonaws.com/ccrs/tracks/gnomad-coverage.bw",
                        type: "wig",
                        color: function(value) {
                            var c;
                            if (value < 0.5){
                                c = "#ff8c00"
                            }
                            if (value >= 0.5){
                                c = "#add8e6"
                            }
                            return c
                        },
                        height: 50,
                        order: 10,
                        visibilityWindow: 500000
                    },
                    {
                        url: 'https://s3.us-east-2.amazonaws.com/ccrs/tracks/gerp.bw',
                        name: 'Genomic Evolutionary Rate Profiling',
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
                        order: 14
                    }

                    // ,
                    // {
                    //     name: 'GWAS Catalog',
                    //     //type: 'annotation',
                    //
                    //      trait: "T2D",
                    //      label: "Type 2 Diabetes: DIAGRAM GWAS",
                    //      maxLogP: 50,
                    //      height: 300,
                    //      pvalue: "P-value",
                    //      colorScale:  {
                    //         thresholds: [5e-8, 5e-4, 0.05],
                    //         colors: ["rgb(0,102,51)", "rgb(122,179,23)", "rgb(158,213,76)", "rgb(227,238,249)"]
                    //      },
                    //
                    //
                    //     type: 'gwas',
                    //     format: 'gtexgwas',
                    //
                    //
                    //
                    //     url: savedVariable['retrieveBottomLineVariants']+args,
                    //     //url: savedVariable['storedGWASData'],
                    //
                    //     indexed: false,
                    //     color: 'rgb(100,200,200)',
                    //     displayMode: 'EXPANDED',
                    //     order: Number.MAX_SAFE_INTEGER // 2nd to last track
                    // }
                ]
            };

        igv.createBrowser(igvDiv, options)
            .then(function (browser) {
                igv.browser = browser;
                var genesInList = {};
                console.log("Created IGV browser");

                browser.on('trackclick', function (track, popoverData) {
                    var symbol = null;
                    if ( ( typeof track !== 'undefined') &&
                        ( track.name == 'Refseq Genes') &&
                        ( typeof popoverData !== 'undefined') ){
                        popoverData.forEach(function (nameValue) {
                            if (nameValue.name && nameValue.name.toLowerCase() === 'name') {
                                symbol = nameValue.value;
                            }
                            if (symbol && !genesInList[symbol]) {
                                genesInList[symbol] = true;
                                $("#geneList").append('<li><a href="https://uswest.ensembl.org/Multi/Search/Results?q=' + symbol + '">' + symbol + '</a></li>');
                            }
                        });
                    }

                    // Prevent default pop-over behavior
                    return false;
                });

            });

        document.addEventListener("DOMContentLoaded", function () {
            alert("DOMContentLoaded");
        });
    }


    return {
        setVariable:setVariable,
        igvLaunch: igvLaunch
    }
}());