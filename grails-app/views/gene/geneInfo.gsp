<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="datatables"/>
    <r:require modules="geneInfo"/>
    <r:require modules="crossMap"/>
    <r:require modules="igv"/>
    <r:require module="locusZoom"/>
    <r:require module="mustache"/>
    <r:layoutResources/>
    <%@ page import="org.broadinstitute.mpg.RestServerService" %>

    <link type="application/font-woff">
    <link type="application/vnd.ms-fontobject">
    <link type="application/x-font-ttf">
    <link type="font/opentype">

    <g:set var="restServer" bean="restServerService"/>


    <style>
    b, strong {
        color: #052090;
    }
    .parentsFont {
        font-family: inherit;
        font-weight: inherit;
        font-size: inherit;
    }
</style>
</head>

<body>
<div id="rSpinner" class="dk-loading-wheel center-block" style="display:none">
    <img src="${resource(dir: 'images', file: 'ajax-loader.gif')}" alt="Loading"/>
</div>
<script>
    var loading = $('#spinner').show();
    $.ajax({
        cache: false,
        type: "post",
        url: '<g:createLink controller="gene" action="geneInfoAjax"/>',
        data: {geneName: '<%=geneName%>'},
        async: true
    }).done(function (data) {
        var variantsAndAssociationsTableHeaders = {
            hdr1: '<g:message code="gene.variantassociations.table.colhdr.1" default="data type" />',
            hdr2: '<g:message code="gene.variantassociations.table.colhdr.2" default="sample size" />',
            hdr3: '<g:message code="gene.variantassociations.table.colhdr.3" default="total variants" />',
            hdr4: '<g:message code="gene.variantassociations.table.colhdr.4a" default="genome wide" />' +
            '<g:helpText title="gene.variantassociations.table.colhdr.4.help.header" placement="top" body="gene.variantassociations.table.colhdr.4.help.text" qplacer="2px 0 0 6px"/>' +
            '<g:message code="gene.variantassociations.table.colhdr.4b" default="genome wide" />',
            hdr5: '<g:message code="gene.variantassociations.table.colhdr.5a" default="locus wide" />' +
            '<g:helpText title="gene.variantassociations.table.colhdr.5.help.header" placement="top" body="gene.variantassociations.table.colhdr.5.help.text" qplacer="2px 0 0 6px"/>' +
            '<g:message code="gene.variantassociations.table.colhdr.5b" default="locus wide" />',
            hdr6: '<g:message code="gene.variantassociations.table.colhdr.6a" default="nominal" />' +
            '<g:helpText title="gene.variantassociations.table.colhdr.6.help.header" placement="top" body="gene.variantassociations.table.colhdr.6.help.text" qplacer="2px 0 0 6px"/>' +
            '<g:message code="gene.variantassociations.table.colhdr.6b" default="nominal" />'
        };
        var variantsAndAssociationsPhenotypeAssociations = {
            significantAssociations: '<g:message code="gene.variantassociations.significantAssociations" default="variants were associated with"  args="[geneName]"/>',
            noSignificantAssociationsExist: '<g:message code="gene.variantassociations.noSignificantAssociations" default="no significant associations"/>'
        };
        var biologicalHypothesisTesting = {
            question1explanation: '<g:message code="gene.biologicalhypothesis.question1.explanation" default="explanation" args="[geneName]"/>',
            question1insufficient: '<g:message code="gene.biologicalhypothesis.question1.insufficientdata" default="insufficient data"/>',
            question1nominal: '<g:message code="gene.biologicalhypothesis.question1.nominaldifference" default="nominal difference"/>',
            question1significant: '<g:message code="gene.biologicalhypothesis.question1.significantdifference" default="significant difference"/>',
            question1significantQ: '<g:helpText title="gene.biologicalhypothesis.question1.significance.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.biologicalhypothesis.question1.significance.help.text"/>'
        };
        var variantsAndAssociationsRowHelpText = {
            genomeWide: '<g:message code="gene.variantassociations.table.rowhdr.gwas" default="gwas"/>',
            genomeWideQ: '<g:helpText title="gene.variantassociations.table.rowhdr.gwas.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.variantassociations.table.rowhdr.gwas.help.text"/>',
            exomeChip: '<g:message code="gene.variantassociations.table.rowhdr.exomeChip" default="gwas"/>',
            exomeChipQ: '<g:helpText title="gene.variantassociations.table.rowhdr.exomeChip.help.header"  qplacer="2px 0 0 6px" placement="right" body="gene.variantassociations.table.rowhdr.exomeChip.help.text"/>',
            sigma: '<g:message code="gene.variantassociations.table.rowhdr.sigma" default="gwas"/>',
            sigmaQ: '<g:helpText title="gene.variantassociations.table.rowhdr.sigma.help.header"  qplacer="2px 0 0 6px" placement="right" body="gene.variantassociations.table.rowhdr.sigma.help.text"/>',
            exomeSequence: '<g:message code="gene.variantassociations.table.rowhdr.exomeSequence" default="gwas"/>',
            exomeSequenceQ: '<g:helpText title="gene.variantassociations.table.rowhdr.exomeSequence.help.header" qplacer="2px 0 0 6px" placement="right"  body="gene.variantassociations.table.rowhdr.exomeSequence.help.text"/>'
        };
        continentalAncestryText = {
            continentalAA: '<g:message code="gene.continentalancestry.title.rowhdr.AA" default="gwas"/>',
            continentalAAQ: '<g:helpText title="gene.continentalancestry.title.rowhdr.AA.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.AA.help.text"/>',
            continentalAAdatatype: '<g:message code="gene.continentalancestry.datatype.exomeSequence" default="exome sequence"/>' +
            '<g:helpText title="gene.continentalancestry.datatype.exomeSequence.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.datatype.exomeSequence.help.text"/>',
            continentalEA: '<g:message code="gene.continentalancestry.title.rowhdr.EA" default="gwas"/>',
            continentalEAQ: '<g:helpText title="gene.continentalancestry.title.rowhdr.EA.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.EA.help.text"/>',
            continentalEAdatatype: '<g:message code="gene.continentalancestry.datatype.exomeSequence" default="exome sequence"/>',
            continentalSA: '<g:message code="gene.continentalancestry.title.rowhdr.SA" default="gwas"/>',
            continentalSAQ: '<g:helpText title="gene.continentalancestry.title.rowhdr.SA.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.SA.help.text"/>',
            continentalSAdatatype: '<g:message code="gene.continentalancestry.datatype.exomeSequence" default="exome sequence"/>',
            continentalEU: '<g:message code="gene.continentalancestry.title.rowhdr.EU" default="gwas"/>',
            continentalEUQ: '<g:helpText title="gene.continentalancestry.title.rowhdr.EU.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.EU.help.text"/>',
            continentalEUdatatype: '<g:message code="gene.continentalancestry.datatype.exomeSequence" default="exome sequence"/>',
            continentalHS: '<g:message code="gene.continentalancestry.title.rowhdr.HS" default="gwas"/>',
            continentalHSQ: '<g:helpText title="gene.continentalancestry.title.rowhdr.HS.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.HS.help.text"/>',
            continentalHSdatatype: '<g:message code="gene.continentalancestry.datatype.exomeSequence" default="exome sequence"/>',
            continentalEUchip: '<g:message code="gene.continentalancestry.title.rowhdr.chipEU" default="gwas"/>',
            continentalEUchipQ: '<g:helpText title="gene.continentalancestry.title.rowhdr.chipEU.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.chipEU.help.text"/>',
            continentalEUchipDatatype: '<g:message code="gene.continentalancestry.datatype.exomeChip" default="exome chip"/>' +
            '<g:helpText title="gene.continentalancestry.datatype.exomeChip.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.datatype.exomeChip.help.text"/>'

        };
        mpgSoftware.geneInfo.fillTheGeneFields(data,
                ${show_gwas},
                ${show_exchp},
                ${show_exseq},
                '<g:createLink controller="region" action="regionInfo" />',
                '<g:createLink controller="trait" action="traitSearch" />',
                '<g:createLink controller="variantSearch" action="gene" />',
                {
                    variantsAndAssociationsTableHeaders: variantsAndAssociationsTableHeaders,
                    variantsAndAssociationsPhenotypeAssociations: variantsAndAssociationsPhenotypeAssociations,
                    biologicalHypothesisTesting: biologicalHypothesisTesting,
                    variantsAndAssociationsRowHelpText: variantsAndAssociationsRowHelpText,
                    continentalAncestryText: continentalAncestryText
                }
        );
        $('[data-toggle="popover"]').popover({
            animation: true,
            html: true,
            template: '<div class="popover" role="tooltip"><div class="arrow"></div><h5 class="popover-title"></h5><div class="popover-content"></div></div>'
        });

        var genePageExtent = 100000;

        var positioningInformation = {
            chromosome: data.geneInfo.CHROM,
            startPosition: data.geneInfo.BEG - genePageExtent,
            endPosition: data.geneInfo.END + genePageExtent
        };
        $(document).ready(function() {
            // call this inside the ready function because the page is still loading when the the parent
            // ajax calls returns
            var portalType = "t2d";
            <g:if test="${g.portalTypeString()?.equals('stroke')}">
            portalType = "stroke";
            </g:if>
            if (portalType === 't2d'){
                mpgSoftware.locusZoom.initializeLZPage('geneInfo', null, positioningInformation);
            }
            $('span[data-textfield="variantName"]').append(data.geneInfo.ID);
            $('#variantPageText').hide();
            $('#genePageText').show();
        });


        $(".pop-top").popover({placement: 'top'});
        $(".pop-right").popover({placement: 'right'});
        $(".pop-bottom").popover({placement: 'bottom'});
        $(".pop-left").popover({placement: 'left'});
        $(".pop-auto").popover({placement: 'auto'});
        loading.hide();
    }).fail(function (jqXHR, exception) {
        loading.hide();
        core.errorReporter(jqXHR, exception);
    });
</script>

<div id="main">

    <div class="container">

        <div class="gene-info-container">
            <div class="gene-info-view">

                <h1>
                    <em><%=geneName%></em>
                </h1>
                <g:set var="annotatedGenes" value="${["C19ORF80",
                                                      "PAM",
                                                      "HNF1A",
                                                      "SLC16A11",
                                                      "SLC30A8",
                                                      "WSF1"]}"/>

                <g:if test="${annotatedGenes.contains(geneName)}">
                    <div class="gene-summary">
                        <div class="title"><g:message code="gene.header.geneSummary" default="Curated summary"/>
                        <g:helpText title="gene.header.geneSummary.help.header" placement="right"
                                    body="gene.header.geneSummary.help.text"/>
                        </div>

                        <div id="geneHolderTop" class="top">
                            <script>
                                var contents = '<g:renderGeneSummary geneFile="${geneName}-top" locale="${locale}"></g:renderGeneSummary>';
                                $('#geneHolderTop').html(contents);
                            </script>

                        </div>

                        <div class="bottom ishidden" id="geneHolderBottom" style="display: none;">
                            <script>
                                var contents = '<g:renderGeneSummary geneFile="${geneName}-bottom" locale="${locale}"></g:renderGeneSummary>';
                                $('#geneHolderBottom').html(contents);
                                function toggleGeneDescr() {
                                    if ($('#geneHolderBottom').is(':visible')) {
                                        $('#geneHolderBottom').hide();
                                        $('#gene-summary-expand').html('<g:message code="gene.header.clickToExpand" default="click to expand"/>');
                                    } else {
                                        $('#geneHolderBottom').show();
                                        $('#gene-summary-expand').html('<g:message code="gene.header.clickToCollapse" default="click to collapse"/>');
                                    }
                                }
                            </script>

                        </div>
                        <a class="boldlink" id="gene-summary-expand" onclick="toggleGeneDescr()">
                            <g:message code="gene.header.clickToExpand" default="click to expand"/>
                        </a>
                    </div>
                </g:if>

                <p>
                    <g:helpText title="gene.header.uniprotSummary.help.header" placement="right"
                                body="gene.header.uniprotSummary.help.text"/>
                    <span id="uniprotSummaryGoesHere"></span>
                </p>


                <div class="accordion" id="accordion2">
                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion2"
                               href="#collapseOne" aria-expanded="true">
                                <h2><strong><g:message code="gene.variantassociations.title"
                                                       default="Variants and associations"/></strong></h2>
                            </a>
                        </div>

                        <div id="collapseOne" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="variantsAndAssociations"/>
                            </div>
                        </div>
                    </div>


                    <g:if test="${g.portalTypeString()?.equals('t2d')}">

                        <div class="separator"></div>
                        <g:render template="/widgets/gwasRegionSummary"
                                  model="['phenotypeList': phenotypeList, 'regionSpecification': regionSpecification]"/>

                    </g:if>
                    <g:if test="${1}">

                        <div class="separator"></div>

                        <div class="accordion-group">
                            <div class="accordion-heading">
                                <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion2"
                                   href="#collapseIgv">
                                    <h2><strong><g:message code="gene.igv.title"
                                                           default="Explore variants with IGV"/></strong></h2>
                                </a>
                            </div>

                            <div id="collapseIgv" class="accordion-body collapse">
                                <div class="accordion-inner">
                                    <g:render template="../trait/igvBrowser"/>
                                </div>
                            </div>
                        </div>

                        <script>
                            $('#accordion2').on('shown.bs.collapse', function (e) {
                                if (e.target.id === "collapseIgv") {
                                    setUpIgv('<%=geneName%>');
                                    <g:renderT2dGenesSection>
                                    %{--igvLauncher.launch("#myDiv", "${geneName}","${restServer.currentRestServer()}",[1,1,1,0]);--}%
                                    </g:renderT2dGenesSection>

                                }

                            });
                            $('#collapseOne').collapse({hide: true})
                        </script>

                    </g:if>
                    <script>
                        $('#collapseOne').collapse({hide: true})
                    </script>





                    <g:if test="${show_exseq}">

                        <div class="separator"></div>

                        <div class="accordion-group">
                            <div class="accordion-heading">
                                <a class="accordion-toggle  collapsed" data-toggle="collapse" data-parent="#accordion2"
                                   href="#collapseTwo">
                                    <h2><strong><g:message code="gene.continentalancestry.title"
                                                           default="variation across continental ancestry"/></strong>
                                    </h2>
                                </a>
                            </div>

                            <g:render template="variationAcrossContinents"/>

                        </div>

                    </g:if>

                    <g:if test="${false}">

                        <div class="separator"></div>

                        <div class="accordion-group">
                            <div class="accordion-heading">
                                <a class="accordion-toggle  collapsed" data-toggle="collapse" data-parent="#accordion2"
                                   href="#collapseThree">
                                    <h2><strong><g:message code="gene.biologicalhypothesis.title"
                                                           default="variation across continental ancestry"/></strong>
                                    </h2>
                                </a>
                            </div>

                            <div id="collapseThree" class="accordion-body collapse">
                                <div class="accordion-inner">
                                    <g:render template="biologicalHypothesisTesting"/>
                                </div>
                            </div>
                        </div>

                    </g:if>


                    <g:if test="${g.portalTypeString()?.equals('t2d')}">
                        <div class="separator"></div>

                        <g:render template="/widgets/locusZoomPlot"/>

                        <div class="separator"></div>

                        <g:render template="/widgets/burdenTestShared" model="['variantIdentifier': '', 'modifiedTitle': 'Interactive burden test (GAIT for genes)' ]"/>


                    </g:if>

                    <div class="separator"></div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse" data-parent="#accordion2"
                               href="#findOutMore">
                                <h2><strong><g:message code="gene.findoutmore.title" default="find out more"/></strong>
                                </h2>
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

</div>

</body>
</html>

