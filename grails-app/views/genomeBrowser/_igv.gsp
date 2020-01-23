

<script>
    $( document ).ready(function() {
        // var igvDiv = document.getElementById("igv-div");
        // var options =
        //     {
        //         genome: "hg38",
        //         locus: "chr8:127,736,588-127,739,371",
        //         tracks: [
        //             {
        //                 "name": "HG00103",
        //                 "url": "https://s3.amazonaws.com/1000genomes/data/HG00103/alignment/HG00103.alt_bwamem_GRCh38DH.20150718.GBR.low_coverage.cram",
        //                 "indexURL": "https://s3.amazonaws.com/1000genomes/data/HG00103/alignment/HG00103.alt_bwamem_GRCh38DH.20150718.GBR.low_coverage.cram.crai",
        //                 "format": "cram"
        //             }
        //         ]
        //     };
        //
        // igv.createBrowser(igvDiv, options)
        //     .then(function (browser) {
        //         console.log("Created IGV browser");
        //     });
        mpgSoftware.igvInit.setVariable('#igv-div',
            {
                storedGWASData:'${g.createLink(controller: "variantInfo", action: "gwasFile")}',
                storedGWASData2:'${g.createLink(controller: "variantInfo", action: "gwasFile2")}',
                rawAPIData:'${createLink(controller: "trait", action: "retrievePotentialIgvTracks")}'
            });
        mpgSoftware.igvInit.igvLaunch('igv-div');
        // new igv.Browser.T2dTrack({
        //     url: rootServer + "trait-search",
        //     type: "t2d",
        //     trait: "T2D",
        //     label: "Type 2 Diabetes: DIAGRAM GWAS",
        //     pvalue: "PVALUE",
        //     colorScale:  {
        //         thresholds: [5e-8, 5e-4, 0.05],
        //         colors: ["rgb(0,102,51)", "rgb(122,179,23)", "rgb(158,213,76)", "rgb(227,238,249)"]
        //     },
        //     description: '<strong>Type 2 diabetes: GWAS</strong><br/>Results in this track are from a GWAS meta-analysis of 69,033 people conducted by the DIAGRAM consortium.'
        // })

    });
</script>