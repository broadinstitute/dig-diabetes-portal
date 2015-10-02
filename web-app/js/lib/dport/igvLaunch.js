var igvLauncher = igvLauncher || {};  // encapsulating variable

(function () {

    igvLauncher.launch = function (divIdentifier,geneName,rootServer,exclusionList) {
        if (!igv.browser) {
            var div, options, browser,
            potentialTracks = [
                new igv.Browser.T2dTrack({
                    url: rootServer + "trait-search",
                    type: "t2d",
                    trait: "T2D",
                    label: "Type 2 Diabetes: DIAGRAM GWAS",
                    pvalue: "PVALUE",
                    colorScale:  {
                        thresholds: [5e-8, 5e-4, 0.05],
                        colors: ["rgb(0,102,51)", "rgb(122,179,23)", "rgb(158,213,76)", "rgb(227,238,249)"]
                    },
                    description: '<strong>Type 2 diabetes: GWAS</strong><br/>Results in this track are from a GWAS meta-analysis of 69,033 people conducted by the DIAGRAM consortium.'
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