var igvLauncher = igvLauncher || {};  // encapsulating variable

(function () {

    igvLauncher.launch = function (divIdentifier,geneName,rootServer,exclusionList) {
        if (!igv.browser) {
            var div, options, browser,
            potentialTracks = [
                new igv.T2dTrack({
                    url: rootServer + "trait-search",
                    type: "t2d",
                    trait: "T2D",
                    label: "Type 2 Diabetes: GWAS",
                    pvalue: "PVALUE",
                    colorScale:  {
                        thresholds: [5e-8, 5e-4, 0.05],
                        colors: ["rgb(0,102,51)", "rgb(122,179,23)", "rgb(158,213,76)", "rgb(227,238,249)"]
                    },
                    description: '<strong>Type 2 diabetes: GWAS</strong><br/>Results in this track are from a GWAS meta-analysis of 69,033 people conducted by the DIAGRAM consortium.'
                }),
                new igv.T2dTrack({
                    url: rootServer + "variant-search",
                    trait: "T2D",
                    label: "Type 2 Diabetes: Exome Chip",
                    pvalue: "EXCHP_T2D_P_value",
                    colorScale:  {
                        thresholds: [5e-8, 5e-4, 0.05],
                        colors: ["rgb(0,102,51)", "rgb(122,179,23)", "rgb(158,213,76)", "rgb(227,238,249)"]
                    },
                    description: '<strong>Type 2 diabetes: exome chip</strong><br/>Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.'

                }),
                new igv.T2dTrack({
                    url: rootServer + "variant-search",
                    trait: "T2D",
                    label: "Type 2 Diabetes: Exome Sequencing",
                    pvalue: "_13k_T2D_P_EMMAX_FE_IV",
                    colorScale:  {
                        thresholds: [5e-8, 5e-4, 0.05],
                        colors: ["rgb(0,102,51)", "rgb(122,179,23)", "rgb(158,213,76)", "rgb(227,238,249)"]
                    },
                    description: '<strong>Type 2 diabetes: exome sequencing</strong><br/>Results in this track are from a study of 12,940 people conducted by the T2D-GENES and GoT2D consortia.'

                }),


                new igv.WIGTrack({
                    url: "//www.broadinstitute.org/igvdata/t2d/recomb_decode.bedgraph",
                    label: "Recombination rate",
                    order: 9998,
                    colorScale:  {
                        thresholds: [5e-8, 5e-4, 0.05],
                        colors: ["rgb(0,102,51)", "rgb(122,179,23)", "rgb(158,213,76)", "rgb(227,238,249)"]
                    }
                }),
                new igv.SequenceTrack({order: 9999}),
                new igv.GeneTrack({
                    url: "//igvdata.broadinstitute.org/annotations/hg19/genes/gencode.v18.collapsed.bed",
                    label: "Genes",
                    order: 9998,
                    colorScale:  {
                        thresholds: [5e-8, 5e-4, 0.05],
                        colors: ["rgb(0,102,51)", "rgb(122,179,23)", "rgb(158,213,76)", "rgb(227,238,249)"]
                    }

                })
            ];


            div = $(divIdentifier)[0];
            options = {
                showKaryo: false,
                locus: ""+geneName,
                fastaURL: "//igvdata.broadinstitute.org/genomes/seq/hg19/hg19.fasta",
                cytobandURL: "//igvdata.broadinstitute.org/genomes/seq/hg19/cytoBand.txt",
                tracks: [
                ]
            };
            for ( var i = 0 ; i < potentialTracks.length ; i++ ) {
                if ((typeof exclusionList!=='undefined')&&
                    (typeof exclusionList[i]!=='undefined')) {   //consider exclusion
                    if ((exclusionList[i]) > 0) {
                        options.tracks.push(potentialTracks[i]);
                    }
                } else {
                    options.tracks.push(potentialTracks[i]);
                }


            }
            browser = igv.createBrowser(options);
            div.appendChild(browser.div);
            browser.startup();

        }



    };

})();