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
                                phenotype
                                ) {
        var igvDiv = document.getElementById(nameOfBase);
        const savedVariable = getVariable('#'+nameOfBase);
        startPosition = startPosition || 127000000
        endPosition = endPosition || 128000000
        chromosome = chromosome || "8"
        phenotype = phenotype || "T2D"
        const args = "?phenotype="+phenotype+
                    "&startPos="+startPosition+
                    "&endPos="+endPosition+
                    "&chromosome="+chromosome+
                    "&limit=500";
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
                    },
                    {
                        name: 'GWAS Catalog',
                        //type: 'annotation',

                        // can we use the old t2d code?
                        // type: 't2d',
                         trait: "T2D",
                        label: "Type 2 Diabetes: DIAGRAM GWAS",
                        maxLogP: 50,
                        height: 300,
                         pvalue: "P-value",
                        colorScale:  {
                            thresholds: [5e-8, 5e-4, 0.05],
                            colors: ["rgb(0,102,51)", "rgb(122,179,23)", "rgb(158,213,76)", "rgb(227,238,249)"]
                        },


                        type: 'gwas',
                        format: 'gtexgwas',



                        url: savedVariable['retrieveBottomLineVariants']+args,
                        //url: savedVariable['storedGWASData'],

                        indexed: false,
                        color: 'rgb(100,200,200)',
                        displayMode: 'EXPANDED',
                        order: Number.MAX_SAFE_INTEGER // 2nd to last track
                    }
                ]
            };

        igv.createBrowser(igvDiv, options)
            .then(function (browser) {
                console.log("Created IGV browser");
            });
    }


    return {
        setVariable:setVariable,
        igvLaunch: igvLaunch
    }
}());