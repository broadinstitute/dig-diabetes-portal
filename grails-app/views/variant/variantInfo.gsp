<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:require modules="variantInfo"/>
    <r:layoutResources/>
    <%@ page import="dport.RestServerService" %>
    <%
        RestServerService   restServerService = grailsApplication.classLoader.loadClass('dport.RestServerService').newInstance()
    %>
    <style>
.parentsFont {
    font-family: inherit;
    font-weight: inherit;
    font-size: inherit;
}
    </style>
</head>

<body>

<script>
    var variant;
    var loading = $('#spinner').show();
    $.ajax({
        cache:false,
        type:"get",
        url:"../variantAjax/"+"<%=variantToSearch%>",
        async:true,
        success: function (data) {
            fillTheFields(data,
                    "<%=variantToSearch%>",
                    "<g:createLink controller='trait' action='traitInfo' />") ;
            loading.hide();
        },
        error: function(jqXHR, exception) {
            loading.hide();
            core.errorReporter(jqXHR, exception) ;
        }
    });
</script>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >


                <h1>
                    <strong><span id="variantTitle" class="parentsFont"></span></strong>
                </h1>

                <g:render template="variantPageHeader" />

                <div class="accordion" id="accordionVariant">
                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordionVariant"
                               href="#collapseVariantAssociationStatistics">
                                <h2><strong>Is <b><span id="variantTitleInAssociationStatistics"></span></b> associated with T2D or related traits?</strong></h2>
                            </a>
                        </div>

                        <div id="collapseVariantAssociationStatistics" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="variantAssociationStatistics" />
                            </div>
                        </div>
                    </div>

                <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordionVariant"
                           href="#collapseHowCommonIsVariant">
                            <h2><strong>How common is <span id="populationsHowCommonIs" class="parentsFont"></span>?</strong></h2>
                        </a>
                    </div>

                    <div id="collapseHowCommonIsVariant" class="accordion-body collapse">
                        <div class="accordion-inner">
                            <g:render template="howCommonIsVariant" />
                        </div>
                    </div>
                </div>


                <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordionVariant"
                           href="#collapseCarrierStatusImpact">
                            <h2><strong>How does carrier status affect disease risk?</strong></h2>
                        </a>
                    </div>

                    <div id="collapseCarrierStatusImpact" class="accordion-body collapse">
                        <div class="accordion-inner">
                            <g:render template="carrierStatusImpact" />
                        </div>
                    </div>
                </div>


                <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordionVariant"
                           href="#collapseAffectOfVariantOnProtein">
                            <div id="effectOfVariantOnProteinTitle"></div>
                        </a>
                    </div>

                    <div id="collapseAffectOfVariantOnProtein" class="accordion-body collapse">
                        <div class="accordion-inner">
                            <g:render template="effectOfVariantOnProtein" />
                        </div>
                    </div>
                </div>



                <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordionVariant"
                           href="#collapseFindOutMore">
                            <h2><strong>Find out more</strong></h2>
                        </a>
                    </div>

                    <div id="collapseFindOutMore" class="accordion-body collapse">
                        <div class="accordion-inner">
                            <g:render template="findOutMore" />
                        </div>
                    </div>
                </div>


            </div>



            </div>

        </div>
    </div>

</div>
<script>
    $('#accordionVariant').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseIgv") {

            if (!igv.browser) {
                var div, options, browser;

                div = $("#myDiv")[0];
                options = {
                    showKaryo: false,
                    locus: '${geneName}',
                    fastaURL: "//igvdata.broadinstitute.org/genomes/seq/hg19/hg19.fasta",
                    cytobandURL: "//igvdata.broadinstitute.org/genomes/seq/hg19/cytoBand.txt",
                    tracks: [
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
                            pvalue: "EXCHP_T2D_P_value"
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
    $('#accordionVariant').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseHowCommonIsVariant") {
            if ((typeof delayedDataPresentation !== 'undefined') &&
                    (typeof delayedDataPresentation.launch !== 'undefined')) {
                delayedDataPresentation.launch();
            }
        }
    });
    $('#accordionVariant').on('hide.bs.collapse', function (e) {
        if (e.target.id === "collapseHowCommonIsVariant") {
            if ((typeof delayedDataPresentation !== 'undefined') &&
                    (typeof delayedDataPresentation.launch !== 'undefined')) {
                delayedDataPresentation.removeBarchart();
            }
        }
    });
    $('#collapseOne').collapse({hide: true})
</script>

</body>
</html>

