var igvLauncher = igvLauncher || {};  // encapsulating variable

(function () {

    var referenceVersion = "hg19",
        fastaURL = "//dn7ywbm9isq8j.cloudfront.net/genomes/seq/hg19/hg19.fasta",
        cytobandURL = "//dn7ywbm9isq8j.cloudfront.net/genomes/seq/hg19/cytoBand.txt",
        recomboBedGraph = "http://data.broadinstitute.org/igvdata/t2d/recomb_decode.bedgraph",
        genesBed = "//dn7ywbm9isq8j.cloudfront.net/annotations/hg19/genes/gencode.v18.collapsed.bed";

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
                fastaURL: fastaURL,
                cytobandURL: cytobandURL,
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
    igvLauncher.setUpIgv = function (locusName,
                             sectionSelector,
                             recombinationMessage,//"<g:message code='controls.shared.igv.tracks.recomb_rate' />"
                             geneMessage,//"<g:message code='controls.shared.igv.tracks.genes' />"
                             retrieveIgvTracks,//"${createLink(controller: 'trait', action: 'retrievePotentialIgvTracks')}",
                             getDataUrl,// '${createLink(controller:'trait', action:'getData', absolute:'false')}',
                             variantURL,// '${createLink(controller:'variantInfo', action:'variantInfo', absolute:'true')}',
                             traitURL,// '${createLink(controller:'trait', action:'traitInfo', absolute:'true')}'
                             igvIntro, // 'Here is IGV...'
                             preferredPheno // display only this phenotype by default
        ){

        var igvInitialization = function (dynamicTracks,renderData){
            var options;
            var additionalTracks = [
                {
                    url: recomboBedGraph,
                    min: 0,
                    max: 7,
                    name: recombinationMessage,
                    order: 9998
                },
                {
                    url: genesBed,
                    name: geneMessage,
                    order: 10000
                }
            ];
            options = {
                id: referenceVersion,
                showKaryo: true,
                showRuler: false,
                showCommandBar: true,
                fastaURL: fastaURL,
                cytobandURL: cytobandURL,
                locus: locusName,
                flanking: 100000,
                tracks: []
            };
            _.forEach(dynamicTracks,function(o){
                var newTrack = o;
                newTrack.url = renderData.url;
                newTrack.variantURL = renderData.variantURL;
                newTrack.traitURL = renderData.traitURL;
                options.tracks.push(newTrack);
            });
            options.tracks = dynamicTracks;
            _.forEach(additionalTracks,function(o){
                options.tracks.push(o);
            });
            return options;
        };

        $(sectionSelector).empty().append(Mustache.render( $('#igvHolderTemplate')[0].innerHTML,{igvIntro:igvIntro}));
        var rGetDataUrl = getDataUrl,
            rVariantURL = variantURL,
            rTraitURL = traitURL,
            rPreferredPheno = preferredPheno;

        var promise =  $.ajax({
            cache: false,
            type: "post",
            url: retrieveIgvTracks,
            data: {typeOfTracks: 'T2D'           },
            async: true
        });
        promise.done(
            function (data) {
                var div,
                    options,
                    browser;
                var renderData = {
                    dataSources: data.allSources,
                    url: rGetDataUrl,
                    variantURL: rVariantURL,
                    traitURL: rTraitURL
                };
                $("#mytrackList").empty().append(Mustache.render( $('#phenotypeDropdownTemplate')[0].innerHTML,renderData));
                if (typeof rPreferredPheno !== 'undefined'){
                    var capturedPhenotypeTrack =  _.find(data.allSources,{'trait':rPreferredPheno});
                    if (typeof capturedPhenotypeTrack !== 'undefined') {
                        data.defaultTracks = [capturedPhenotypeTrack];
                    }
                }
                options = igvInitialization(data.defaultTracks,renderData);
                div = $("#igvDiv")[0];
                browser = igv.createBrowser(div, options);
            }
        );

    };


})();