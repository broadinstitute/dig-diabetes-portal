
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

    <g:message code="gene.igv.intro1" default="Use the browser"/>
    <g:renderT2dGenesSection>
        <g:message code="gene.igv.intro2" default="(non-Sigma databases)"/>
    </g:renderT2dGenesSection>
       <g:message code="gene.igv.intro3" default="or the traits"/>
    <g:renderT2dGenesSection>
       <g:message code="gene.igv.intro4" default="(GWAS)"/>
    </g:renderT2dGenesSection>
     .
</p>

<br/>
<script>
</script>
<nav class="navbar" role="navigation">
        <div class="container-fluid">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse"
                        data-target="#bs-example-navbar-collapse-1"><span class="sr-only">Toggle navigation</span><span
                        class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button>
                <a class="navbar-brand">IGV</a></div>
            <div id="bs-example-navbar-collapse-1" class="collapse navbar-collapse">
                <ul class="nav navbar-nav navbar-left">
                    <li class="dropdown" id="tracks-menu-dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Tracks<b class="caret"></b></a>
                        <ul id="trackList" class="dropdown-menu">
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                            url: 'http://dig-api-qa.broadinstitute.org/qa/gs/getData',
                            trait: 'T2D',
                            dataset: 'ExSeq_17k_mdv2',
                            pvalue: 'P_EMMAX_FE_IV_17k',
                            name: 'Type II Diabetes',
                            variantURL: 'http://www.type2diabetesgenetics.org/variant/variantInfo/',
                            traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })">Type 2 Diabetes</a>
                            </li>
                         </ul>
                    </li>
                </ul>
                <div class="nav navbar-nav navbar-left">
                    <div class="well-sm">
                        <input id="goBoxInput" class="form-control" placeholder="Locus Search" type="text"
                               onchange="igvSearch($('#goBoxInput')[0].value)">
                    </div>
                </div>
                <div class="nav navbar-nav navbar-left">
                    <div class="well-sm">
                        <button id="goBox" class="btn btn-default" onclick="igvSearch($('#goBoxInput')[0].value)">
                            Search
                        </button>
                    </div>
                </div>
                <div class="nav navbar-nav navbar-right">
                    <div class="well-sm">
                        <div class="btn-group-sm"></div>
                        <button id="zoomOut" type="button" class="btn btn-default btn-sm"
                                onclick="igv.browser.zoomOut()">
                            <span class="glyphicon glyphicon-minus"></span></button>
                        <button id="zoomIn" type="button" class="btn btn-default btn-sm" onclick="igv.browser.zoomIn()">
                            <span class="glyphicon glyphicon-plus"></span></button>
                    </div>
                </div>
            </div>
        </div>
    </nav>

</div>
<script type="text/javascript">

   var setUpIgv = function (){

        var div,
                options,
                browser;

        div = $("#myDiv")[0];
        options = {
            showKaryo: false,
            showCommandBar: false,
            fastaURL: "//dn7ywbm9isq8j.cloudfront.net/genomes/seq/hg19/hg19.fasta",
            cytobandURL: "//dn7ywbm9isq8j.cloudfront.net/genomes/seq/hg19/cytoBand.txt",
            locus: 'slc30a8',
            flanking: 100000,
            tracks: [
                {
                    type: "t2d",
                    url: "http://dig-api-prod.broadinstitute.org/prod/gs/getData",
                    trait: "T2D",
                    dataset: "ExSeq_17k_mdv2",
                    pvalue: "P_EMMAX_FE_IV_17k",
                    name: "Type II Diabetes",
                    variantURL: "http://www.type2diabetesgenetics.org/variantInfo/variantInfo/",
                    traitURL: "http://www.type2diabetesgenetics.org/trait/traitInfo/"
                },
                {
                    url: "http://data.broadinstitute.org/igvdata/t2d/recomb_decode.bedgraph",
                    min: 0,
                    max: 7,
                    name: "Recombination rate",
                    order: 9998
                },
                {
                    type: "sequence",
                    order: -9999
                },
                {
                    url: "//dn7ywbm9isq8j.cloudfront.net/annotations/hg19/genes/gencode.v18.collapsed.bed",
                    name: "Genes",
                    order: 10000
                }
            ]
        };

        browser = igv.createBrowser(div, options);
    };

</script>

