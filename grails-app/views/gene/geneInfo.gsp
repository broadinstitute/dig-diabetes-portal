<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:require modules="geneInfo"/>
    <r:layoutResources/>

    <link type="application/font-woff">
    <link type="application/vnd.ms-fontobject">
    <link type="application/x-font-ttf">
    <link type="font/opentype">

    <link href="http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" type="text/css"
          rel="stylesheet">

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="//oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="//oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <!-- Bootstrap -->
    <g:javascript src="lib/igv/vendor/inflate.js"/>
    <g:javascript src="lib/igv/vendor/zlib_and_gzip.min.js"/>

    %{--<g:javascript base="http://www.broadinstitute.org/" src="/igvdata/t2d/igv-all.min.js" />--}%
    <!-- IGV js  and css code -->
    <link href="http://www.broadinstitute.org/igvdata/t2d/igv.css" type="text/css" rel="stylesheet">
    %{--<g:javascript base="http://iwww.broadinstitute.org/" src="/igvdata/t2d/igv-all.js" />--}%
    <g:javascript base="http://www.broadinstitute.org/" src="/igvdata/t2d/igv-all.min.js"/>

</head>

<body>
<script>
    var loading = $('#spinner').show();
    $.ajax({
        cache: false,
        type: "post",
        url: "../geneInfoAjax",
        data: {geneName: '<%=geneName%>'},
        async: true,
        success: function (data) {
            fillTheGeneFields(data,
                    ${show_gwas},
                    ${show_exchp},
                    ${show_exseq},
                    ${show_sigma},
                    '<g:createLink controller="region" action="regionInfo" />',
                    '<g:createLink controller="trait" action="regionInfo" />',
                    '<g:createLink controller="variantSearch" action="gene" />');
            loading.hide();
        },
        error: function (jqXHR, exception) {
            loading.hide();
            core.errorReporter(jqXHR, exception);
        }
    });
    var phenotype = new UTILS.phenotypeListConstructor(decodeURIComponent("${phenotypeList}"));
</script>

<div id="main">

    <div class="container">

        <div class="gene-info-container">
            <div class="gene-info-view">

                <h1>
                    <em><%=geneName%></em>
                    <a class="page-nav-link" href="#associations">Associations</a>
                    <a class="page-nav-link" href="#populations">Populations</a>
                    <a class="page-nav-link" href="#biology">Biology</a>
                </h1>



                <g:if test="${(geneName == "C19ORF80") ||
                        (geneName == "PAM") ||
                        (geneName == "HNF1A") ||
                        (geneName == "SLC16A11") ||
                        (geneName == "SLC30A8") ||
                        (geneName == "WFS1")}">
                    <div class="gene-summary">
                        <div class="title">Curated Summary</div>

                        <div id="geneHolderTop" class="top">
                            <script>
                                var contents = '<g:renderGeneSummary geneFile="${geneName}-top"></g:renderGeneSummary>';
                                $('#geneHolderTop').html(contents);
                            </script>

                        </div>

                        <div class="bottom ishidden" id="geneHolderBottom" style="display: none;">
                            <script>
                                var contents = '<g:renderGeneSummary geneFile="${geneName}-bottom"></g:renderGeneSummary>';
                                $('#geneHolderBottom').html(contents);
                                function toggleGeneDescr() {
                                    if ($('#geneHolderBottom').is(':visible')) {
                                        $('#geneHolderBottom').hide();
                                    } else {
                                        $('#geneHolderBottom').show();
                                    }
                                }
                            </script>

                        </div>
                        <a class="boldlink" id="gene-summary-expand" onclick="toggleGeneDescr()">click to expand</a>
                    </div>
                </g:if>

                <p><span id="uniprotSummaryGoesHere"></span></p>


                <div class="accordion" id="accordion2">
                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2"
                               href="#collapseOne">
                                <h2><strong>Variants and associations</strong></h2>
                            </a>
                        </div>

                        <div id="collapseOne" class="accordion-body collapse in">
                            <div class="accordion-inner">
                                <g:render template="variantsAndAssociations"/>
                            </div>
                        </div>
                    </div>


                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2"
                               href="#collapseIgv">
                                <h2><strong>Integrative Genomics Viewer</strong></h2>
                            </a>
                        </div>

                        <div id="collapseIgv" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="../trait/igvBrowser"/>
                            </div>
                        </div>
                    </div>
                    <script>
                        $('#accordion2').on('show.bs.collapse', function (e) {
                            if (e.target.id === "collapseIgv") {
                           //     $(document).ready(function () {
                                if (!igv.browser) {
                                    var div, options, browser;

                                    div = $("#myDiv")[0];
                                    options = {
                                        showKaryo: false,
                                        locus: '${geneName}',
                                        fastaURL: "//igvdata.broadinstitute.org/genomes/seq/hg19/hg19.fasta",
                                        cytobandURL: "//igvdata.broadinstitute.org/genomes/seq/hg19/cytoBand.txt",
                                        tracks: [
                                            %{--new igv.T2dTrack({--}%
                                                %{--url: "${grailsApplication.config.server.URL}trait-search",--}%
%{--//                                                url: "http://t2dgenetics.org/mysql/rest/server/trait-search",--}%
                                                %{--type: "t2d",--}%
                                                %{--trait: "T2D",--}%
                                                %{--label: "Type 2 Diabetes"--}%
                                            %{--}),--}%
                                            new igv.T2dTrack({
                                                url: "${grailsApplication.config.server.URL}trait-search",
                                                type: "t2d",
                                                trait: "T2D",
                                                label: "Type 2 Diabetes",
                                                pvalue: "PVALUE"

                                            }),
                                            new igv.T2dTrack({
                                                url: "${grailsApplication.config.server.URL}variant-search",
                                                trait: "T2D",
                                                label: "Exome Chip",
                                                pvalue: "EXOME_T2D_P_value"
                                            }),
                                            new igv.T2dTrack({
                                                url: "${grailsApplication.config.server.URL}variant-search",
                                                trait: "T2D",
                                                label: "Exome Sequencing",
                                                pvalue: "_13k_T2D_P_EMMAX_FE_IV"
                                            }),





                                            new igv.WIGTrack({
                                                url: "//www.broadinstitute.org/igvdata/t2d/recomb_decode.bedgraph",
                                                label: "Recombination rate",
                                                order: 9998
                                            }),
                                            new igv.SequenceTrack({order: 9999}),
                                            new igv.GeneTrack({
                                                url: "//igvdata.broadinstitute.org/annotations/hg19/genes/gencode.v18.collapsed.bed",
                                                label: "Genes",
                                                order: 9998

                                            })
                                        ]
                                    };
                                    browser = igv.createBrowser(options);
                                    div.appendChild(browser.div);
                                    browser.startup();
                                    igv.browser.resize();

                                }

                               //  });

                            }
                            console.log('collapseIgv shown')
                        });
                        $('#accordion2').on('show.bs.collapse', function (e) {
                            if (e.target.id === "collapseThree") {
                                if ((typeof delayedDataPresentation !== 'undefined') &&
                                        (typeof delayedDataPresentation.launch !== 'undefined')) {
                                    delayedDataPresentation.launch();
                                }
                            }
                        });
                        $('#accordion2').on('hide.bs.collapse', function (e) {
                            if (e.target.id === "collapseThree") {
                                if ((typeof delayedDataPresentation !== 'undefined') &&
                                        (typeof delayedDataPresentation.launch !== 'undefined')) {
                                    delayedDataPresentation.removeBarchart();
                                }
                            }
                        });
                        $('#collapseOne').collapse({hide: true})
                    </script>


                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2"
                               href="#collapseTwo">
                                <h2><strong>Variation across continental ancestry groups</strong></h2>
                            </a>
                        </div>

                        <div id="collapseTwo" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="variationAcrossContinents"/>
                            </div>
                        </div>
                    </div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2"
                               href="#collapseThree">
                                <h2><strong>Biological hypothesis testing</strong></h2>
                            </a>
                        </div>

                        <div id="collapseThree" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="biologicalHypothesisTesting"/>
                            </div>
                        </div>
                    </div>
                </div>


                <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2"
                           href="#findOutMore">
                            <h2><strong>Find out more</strong></h2>
                        </a>
                    </div>

                    <div id="findOutMore" class="accordion-body collapse">
                        <div class="accordion-inner">
                            <g:render template="findOutMore"/>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

</div>

</body>
</html>

