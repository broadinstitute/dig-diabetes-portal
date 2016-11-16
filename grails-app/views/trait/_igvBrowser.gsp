
%{--Why I am forced to include style directives explicitly in this page and no other I do not know. There must be--}%
%{--something funny about IGV's use of CSS that is different than everything else in the application.  //TODO -- fix this--}%
<g:set var="restServer" bean="restServerService"/>
<script>
        function  igvSearch(searchString) {
                igv.browser.search(searchString);
                return true;
            }
</script>

<div id="myDiv">
<p>

<g:if test="${g.portalTypeString()?.equals('t2d')}">
    <g:message code="gene.igv.intro1" default="Use the browser"/>
    <g:renderT2dGenesSection>
        <g:message code="gene.igv.intro2" default="(non-Sigma databases)"/>
    </g:renderT2dGenesSection>
       <g:message code="gene.igv.intro3" default="or the traits"/>
    <g:renderT2dGenesSection>
       <g:message code="gene.igv.intro4" default="(GWAS)"/>
    </g:renderT2dGenesSection>
</g:if>
<g:else>
    <g:message code="gene.stroke.igv.intro1" default="Use the browser"/>
</g:else>

</p>

<br/>
<script>
</script>
<nav class="navbar" role="navigation" style="margin:0;padding:0">
        <div class="container-fluid">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse"
                        data-target="#bs-example-navbar-collapse-1"><span class="sr-only"><g:message code="controls.shared.igv.toggle_nav" /></span><span
                        class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button>
                %{--<a class="navbar-brand">IGV</a></div>--}%
            <div id="bs-example-navbar-collapse-1" class="collapse navbar-collapse" style="margin:0;padding:0">
                <ul class="nav navbar-nav navbar-left">
                    <li class="dropdown" id="tracks-menu-dropdown" style="margin:0;padding:0">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown"><g:message code="controls.shared.igv.tracks" /><b class="caret"></b></a>
                        <ul id="mytrackList" class="dropdown-menu" style="margin:0;padding:0">
                        </ul>
                    </li>
                </ul>
                %{--<div class="nav navbar-nav navbar-left">--}%
                    %{--<div class="well-sm">--}%
                        %{--<input id="goBoxInput" class="form-control" placeholder="Locus Search" type="text"--}%
                               %{--onchange="igvSearch($('#goBoxInput')[0].value)">--}%
                    %{--</div>--}%
                %{--</div>--}%
                %{--<div class="nav navbar-nav navbar-left">--}%
                    %{--<div class="well-sm">--}%
                        %{--<button id="goBox" class="btn btn-default" onclick="igvSearch($('#goBoxInput')[0].value)">--}%
                            %{--<g:message code="controls.shared.igv.search" />--}%
                        %{--</button>--}%
                    %{--</div>--}%
                %{--</div>--}%
                %{--<div class="nav navbar-nav navbar-right">--}%
                    %{--<div class="well-sm">--}%
                        %{--<div class="btn-group-sm"></div>--}%
                        %{--<button id="zoomOut" type="button" class="btn btn-default btn-sm"--}%
                                %{--onclick="igv.browser.zoomOut()">--}%
                            %{--<span class="glyphicon glyphicon-minus"></span></button>--}%
                        %{--<button id="zoomIn" type="button" class="btn btn-default btn-sm" onclick="igv.browser.zoomIn()">--}%
                            %{--<span class="glyphicon glyphicon-plus"></span></button>--}%
                    %{--</div>--}%
                %{--</div>--}%
            </div>
            </div>
        </div>
    </nav>

</div>
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

   var setUpIgv = function (locusName, serverName){
       var igvInitialization = function (dynamicTracks,renderData){
           var options;
           var additionalTracks = [
               {
                   url: "http://data.broadinstitute.org/igvdata/t2d/recomb_decode.bedgraph",
                   min: 0,
                   max: 7,
                   name: "<g:message code='controls.shared.igv.tracks.recomb_rate' />",
                   order: 9998
               },
//               {
//                   type: "sequence",
//                   order: -9999
//               },
               {
                   url: "//dn7ywbm9isq8j.cloudfront.net/annotations/hg19/genes/gencode.v18.collapsed.bed",
                   name: "<g:message code='controls.shared.igv.tracks.genes' />",
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



       var promise =  $.ajax({
           cache: false,
           type: "post",
           url: "${createLink(controller: 'trait', action: 'retrievePotentialIgvTracks')}",
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
                       url: '${createLink(controller:'trait', action:'getData', absolute:'true')}',
                       variantURL: '${createLink(controller:'variantInfo', action:'variantInfo', absolute:'true')}',
                       traitURL: '${createLink(controller:'trait', action:'traitInfo', absolute:'true')}'
                   };
                   $("#mytrackList").empty().append(Mustache.render( $('#phenotypeDropdownTemplate')[0].innerHTML,renderData));
                   options = igvInitialization(data.defaultTracks,renderData);
                   div = $("#myDiv")[0];
                   browser = igv.createBrowser(div, options);
               }
       );

     };

</script>

