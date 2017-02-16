
<g:set var="restServer" bean="restServerService"/>
<script>
        function  igvSearch(searchString) {
                igv.browser.search(searchString);
                return true;
            }
</script>
<script id="igvHolderTemplate"  type="x-tmpl-mustache">

<div id="myDiv">
<p>

{{igvIntro}}

</p>

<br/>

    <nav class="navbar" role="navigation" style="margin:0;padding:0">
        <div class="container-fluid">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse"
                        data-target="#bs-example-navbar-collapse-1"><span class="sr-only"><g:message code="controls.shared.igv.toggle_nav" /></span><span
                        class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button>
            <div id="bs-example-navbar-collapse-1" class="collapse navbar-collapse" style="margin:0;padding:0">
                <ul class="nav navbar-nav navbar-left">
                    <li class="dropdown" id="tracks-menu-dropdown" style="margin:0;padding:0">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown"><g:message code="controls.shared.igv.tracks" /><b class="caret"></b></a>
                        <ul id="mytrackList" class="dropdown-menu" style="margin:0;padding:0">
                        </ul>
                    </li>
                </ul>
            </div>
            </div>
        </div>
    </nav>

</div>
</script>
<script id="phenotypeDropdownTemplate"  type="x-tmpl-mustache">
                    {{ #dataSources }}
                        <li>
                        <a onclick="igv.browser.loadTrack({ type: '{{type}}',
                            url: '{{url}}',
                                trait: '{{trait}}',
                                dataset: '{{dataset}}',
                                pvalue: '{{pvalue}}',
                                name: '{{name}}',
                                variantURL: '{{variantURL}}',
                                traitURL: '{{traitURL}}'
                            })">{{name}}</a>
                        </li>
                    {{ /dataSources }}
                    {{ ^dataSources }}
                    <li>No phenotypes available</li>
                    {{ /dataSources }}
</script>

<script type="text/javascript">

   var setUpIgv = function (locusName,
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
                   url: "http://data.broadinstitute.org/igvdata/t2d/recomb_decode.bedgraph",
                   min: 0,
                   max: 7,
                   name: recombinationMessage,
                   order: 9998
               },
               {
                   url: "//dn7ywbm9isq8j.cloudfront.net/annotations/hg19/genes/gencode.v18.collapsed.bed",
                   name: geneMessage,
                   order: 10000
               }
           ];
           options = {
               id: "hg19",
               showKaryo: true,
               showRuler: false,
               showCommandBar: true,
               fastaURL: "//dn7ywbm9isq8j.cloudfront.net/genomes/seq/hg19/hg19.fasta",
               cytobandURL: "//dn7ywbm9isq8j.cloudfront.net/genomes/seq/hg19/cytoBand.txt",
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
                   div = $("#myDiv")[0];
                   browser = igv.createBrowser(div, options);
               }
       );

     };

</script>

