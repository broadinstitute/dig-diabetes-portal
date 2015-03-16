<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="geneInfo"/>
    <r:layoutResources/>
    <%@ page import="dport.RestServerService" %>

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

    <!-- IGV js  and css code -->
    <link href="http://www.broadinstitute.org/igvdata/t2d/igv.css" type="text/css" rel="stylesheet">
    %{--<g:javascript base="http://iwww.broadinstitute.org/" src="/igvdata/t2d/igv-all.js" />--}%
    <g:javascript base="http://www.broadinstitute.org/" src="/igvdata/t2d/igv-all.min.js"/>
    <g:set var="restServer" bean="restServerService"/>
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
            var variantsAndAssociationsTableHeaders = {
                hdr1:'<g:message code="gene.variantassociations.table.colhdr.1" default="data type" />',
                hdr2:'<g:message code="gene.variantassociations.table.colhdr.2" default="sample size" />',
                hdr3:'<g:message code="gene.variantassociations.table.colhdr.3" default="total variants" />',
                hdr4:'<g:message code="gene.variantassociations.table.colhdr.4" default="genome wide" />',
                hdr5:'<g:message code="gene.variantassociations.table.colhdr.5" default="locus wide" />',
                hdr6:'<g:message code="gene.variantassociations.table.colhdr.6" default="nominal" />'
            };
            var variantsAndAssociationsPhenotypeAssociations = {
                significantAssociations:'<g:message code="gene.variantassociations.significantAssociations" default="variants were associated with"  args="[geneName]"/>',
                noSignificantAssociationsExist:'<g:message code="gene.variantassociations.noSignificantAssociations" default="no significant associations"/>'
            };
            var biologicalHypothesisTesting = {
                question1explanation:'<g:message code="gene.biologicalhypothesis.question1.explanation" default="explanation" args="[geneName]"/>',
                question1insufficient:'<g:message code="gene.biologicalhypothesis.question1.insufficientdata" default="insufficient data"/>',
                question1nominal:'<g:message code="gene.biologicalhypothesis.question1.nominaldifference" default="nominal difference"/>',
                question1significant:'<g:message code="gene.biologicalhypothesis.question1.significantdifference" default="significant difference"/>'
            };
            mpgSoftware.geneInfo.fillTheGeneFields(data,
                    ${show_gwas},
                    ${show_exchp},
                    ${show_exseq},
                    ${show_sigma},
                    '<g:createLink controller="region" action="regionInfo" />',
                    '<g:createLink controller="trait" action="traitSearch" />',
                    '<g:createLink controller="variantSearch" action="gene" />',
                    {variantsAndAssociationsTableHeaders:variantsAndAssociationsTableHeaders,
                     variantsAndAssociationsPhenotypeAssociations:variantsAndAssociationsPhenotypeAssociations,
                     biologicalHypothesisTesting:biologicalHypothesisTesting}
            );
            loading.hide();
        },
        error: function (jqXHR, exception) {
            loading.hide();
            core.errorReporter(jqXHR, exception);
        }
    });
    var phenotype = new UTILS.phenotypeListConstructor(decodeURIComponent("T2D%3Atype+2+diabetes%2CFastGlu%3Afasting+glucose%2CFastIns%3Afasting+insulin%2CProIns%3Afasting+proinsulin%2C2hrGLU_BMIAdj%3Atwo-hour+glucose%2C2hrIns_BMIAdj%3Atwo-hour+insulin%2CHOMAIR%3AHOMA-IR%2CHOMAB%3AHOMA-B%2CHbA1c%3AHbA1c%2CBMI%3ABMI%2CWHR%3Awaist-hip+ratio%2CHeight%3Aheight%2CTC%3Atotal+cholesterol%2CHDL%3AHDL+cholesterol%2CLDL%3ALDL+cholesterol%2CTG%3ATriglycerides%2CCAD%3Acoronary+artery+disease%2CCKD%3Achronic+kidney+disease%2CeGFRcrea%3AeGFR-creat+%28serum+creatinine%29%2CeGFRcys%3AeGFR-cys+%28serum+cystatin+C%29%2CUACR%3Aurinary+albumin-to-creatinine+ratio%2CMA%3Amicroalbuminuria%2CBIP%3Abipolar+disorder%2CSCZ%3Aschizophrenia%2CMDD%3Amajor+depressive+disorder"));
</script>

<div id="main">

<div class="container">

<div class="gene-info-container">
<div class="gene-info-view">

<h1>
    <em><%=geneName%></em>
</h1>



<g:if test="${(geneName == "C19ORF80") ||
        (geneName == "PAM") ||
        (geneName == "HNF1A") ||
        (geneName == "SLC16A11") ||
        (geneName == "SLC30A8") ||
        (geneName == "WFS1")}">
    <div class="gene-summary">
        <div class="title"><g:message code="gene.header.geneSummary" default="Curated summary"/></div>

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
                        $('#gene-summary-expand').html('click to expand');
                    } else {
                        $('#geneHolderBottom').show();
                        $('#gene-summary-expand').html('click to collapse');
                    }
                }
            </script>

        </div>
        <a class="boldlink" id="gene-summary-expand" onclick="toggleGeneDescr()">
            <g:message code="gene.header.clickToExpand" default="click to expand"/>
        </a>
    </div>
</g:if>

<p><span id="uniprotSummaryGoesHere"></span></p>


<div class="accordion" id="accordion2">
    <div class="accordion-group">
        <div class="accordion-heading">
            <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion2"
               href="#collapseOne" aria-expanded="true" >
                <h2><strong><g:message code="gene.variantassociations.title" default="Variants and associations"/></strong></h2>
            </a>
        </div>

        <div id="collapseOne" class="accordion-body collapse">
            <div class="accordion-inner">
                <g:render template="variantsAndAssociations"/>
            </div>
        </div>
    </div>

    <div class="separator"></div>

    <div class="accordion-group">
        <div class="accordion-heading">
            <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion2"
               href="#collapseIgv">
                <h2><strong><g:message code="gene.igv.title" default="Explore variants with IGV"/></strong></h2>
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
 <g:renderSigmaSection>
                igvLauncher.launch("#myDiv", "${geneName}","${restServer.currentRestServer()}",[1,0,0,1]);
 </g:renderSigmaSection>
 <g:renderT2dGenesSection>
                igvLauncher.launch("#myDiv", "${geneName}","${restServer.currentRestServer()}",[1,1,1,0]);
 </g:renderT2dGenesSection>

            }

        });
        $('#accordion2').on('show.bs.collapse', function (e) {
            if (e.target.id === "collapseThree") {
                if ((typeof mpgSoftware.geneInfo.retrieveDelayedBiologicalHypothesisOneDataPresenter() !== 'undefined') &&
                        (typeof mpgSoftware.geneInfo.retrieveDelayedBiologicalHypothesisOneDataPresenter().launch !== 'undefined')) {
                    mpgSoftware.geneInfo.retrieveDelayedBiologicalHypothesisOneDataPresenter().launch();
                }
            }
        });
        $('#accordion2').on('hide.bs.collapse', function (e) {
            if (e.target.id === "collapseThree") {
                if ((typeof mpgSoftware.geneInfo.retrieveDelayedBiologicalHypothesisOneDataPresenter() !== 'undefined') &&
                        (typeof mpgSoftware.geneInfo.retrieveDelayedBiologicalHypothesisOneDataPresenter().launch !== 'undefined')) {
                    mpgSoftware.geneInfo.retrieveDelayedBiologicalHypothesisOneDataPresenter().removeBarchart();
                }
            }
        });
        $('#collapseOne').collapse({hide: true})
    </script>

    <g:if test="${show_exseq}">

    <div class="separator"></div>

    <div class="accordion-group">
        <div class="accordion-heading">
            <a class="accordion-toggle  collapsed" data-toggle="collapse" data-parent="#accordion2"
               href="#collapseTwo">
                <h2><strong><g:message code="gene.continentalancestry.title" default="variation across continental ancestry"/></strong></h2>
            </a>
        </div>

        <div id="collapseTwo" class="accordion-body collapse">
            <div class="accordion-inner">
                <g:render template="variationAcrossContinents"/>
            </div>
        </div>
    </div>

    </g:if>

<g:if test="${show_exseq || show_sigma}">

    <div class="separator"></div>

    <div class="accordion-group">
        <div class="accordion-heading">
            <a class="accordion-toggle  collapsed" data-toggle="collapse" data-parent="#accordion2"
               href="#collapseThree">
                <h2><strong><g:message code="gene.biologicalhypothesis.title" default="variation across continental ancestry"/></strong></h2>
            </a>
        </div>

        <div id="collapseThree" class="accordion-body collapse">
            <div class="accordion-inner">
                <g:render template="biologicalHypothesisTesting"/>
            </div>
        </div>
    </div>

</g:if>

    <div class="separator"></div>

    <div class="accordion-group">
        <div class="accordion-heading">
            <a class="accordion-toggle  collapsed" data-toggle="collapse" data-parent="#accordion2"
               href="#findOutMore">
                <h2><strong><g:message code="gene.findoutmore.title" default="find out more"/></strong></h2>
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

