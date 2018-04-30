<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="media"/>
    %{--<r:require modules="portalHome"/>--}%
    <r:layoutResources/>
    <style>
    a.media {
        display: block;
    }

    div.media {
        font-size: small;
        margin: 25px;
        margin: auto
    }

    div.media div {
        font-style: italic;
        color: #888;
    }

    ul.tutorial {
        padding: 0;
        margin-left: -10px;
    }

    ul.tutorial li {
        display: inline;
        font-size: 1.5em;
        padding-right: 15px;
        margin-left: 10px;
        border-right: 1px solid #ccc;
    }

    ul.tutorial li:last-child {
        border-right: 0px;
    }

    ul.tutorial li a, ul.tutorial li a:hover {
        text-decoration: none;
    }
    </style>
</head>

<body>

<script>
    $(function () {
        setPdfViewer();

        $("#portalPdf").click(function () {
            <g:if test="${g.portalTypeString()?.equals('t2d')}">
                $(".media").attr("href", "${links.introTutorial}");
                $(".media").find("iframe").attr("src", "${links.introTutorial}");
            </g:if>
            <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                $(".media").attr("href", "${links.miIntroTutorial}");
                $(".media").find("iframe").attr("src", "${links.miIntroTutorial}");
            </g:elseif>
            <g:else>
                $(".media").attr("href", "${links.strokeIntroTutorial}");
                $(".media").find("iframe").attr("src", "${links.strokeIntroTutorial}");
            </g:else>
        });

        $("#variantPdf").click(function () {
            <g:if test="${g.portalTypeString()?.equals('t2d')}">
                $(".media").attr("href", "${links.variantFinderTutorial}");
                $(".media").find("iframe").attr("src", "${links.variantFinderTutorial}");
            </g:if>
            <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                $(".media").attr("href", "${links.miVariantFinderTutorial}");
                $(".media").find("iframe").attr("src", "${links.miVariantFinderTutorial}");
            </g:elseif>
            <g:else>
                $(".media").attr("href", "${links.strokeVariantFinderTutorial}");
                $(".media").find("iframe").attr("src", "${links.strokeVariantFinderTutorial}");
            </g:else>
        });

        $("#GAITPdf").click(function () {
            $(".media").attr("href", "${links.GAITguide}");
            $(".media").find("iframe").attr("src", "${links.GAITguide}");

        });

        $("#VariantResultsPdf").click(function () {
            $(".media").attr("href", "${links.VariantResultsTableGuide}");
            $(".media").find("iframe").attr("src", "${links.VariantResultsTableGuide}");

        });

        $("#GeneticsGuidePdf").click(function () {
            $(".media").attr("href", "${links.GeneticsGuide}");
            $(".media").find("iframe").attr("src", "${links.GeneticsGuide}");

        });

        $("#PhenotypeGuidePdf").click(function () {
            $(".media").attr("href", "${links.PhenotypeGuide}");
            $(".media").find("iframe").attr("src", "${links.PhenotypeGuide}");

        });

        $("#StrokePhenotypeGuidePdf").click(function () {
            $(".media").attr("href", "${links.StrokePhenotypeGuide}");
            $(".media").find("iframe").attr("src", "${links.StrokePhenotypeGuide}");

        });

        $("#GenePageGuidePdf").click(function () {
            $(".media").attr("href", "${links.GenePageGuide}");
            $(".media").find("iframe").attr("src", "${links.GenePageGuide}");

        });

        $("#CDKPGenePageGuidePdf").click(function () {
            $(".media").attr("href", "${links.CDKPGenePageGuide}");
            $(".media").find("iframe").attr("src", "${links.CDKPGenePageGuide}");
        });

        $("#testPdf").click(function () {
            $(".media").attr("href", "https://s3.amazonaws.com/broad-portal-resources/tutorials/CVDKP_gene_page_guide.pdf");
            $(".media").find("iframe").attr("src", "https://s3.amazonaws.com/broad-portal-resources/tutorials/CVDKP_gene_page_guide.pdf");
        });

        $("#MIgenePdf").click(function () {
            $(".media").attr("href", "https://s3.amazonaws.com/broad-portal-resources/tutorials/CVDKP_gene_page_guide.pdf");
            $(".media").find("iframe").attr("src", "https://s3.amazonaws.com/broad-portal-resources/tutorials/CVDKP_gene_page_guide.pdf");
        });

        $("#MIVFPdf").click(function () {
            $(".media").attr("href", "https://s3.amazonaws.com/broad-portal-resources/tutorials/CVDKP_VF_Tutorial.pdf");
            $(".media").find("iframe").attr("src", "https://s3.amazonaws.com/broad-portal-resources/tutorials/CVDKP_VF_Tutorial.pdf");
        });

        $("#SDKPPhenotypeGuidePdf").click(function () {
            $(".media").attr("href", "https://s3.amazonaws.com/broad-portal-resources/sleep/SDKP_phenotype_reference_guide.pdf");
            $(".media").find("iframe").attr("src", "https://s3.amazonaws.com/broad-portal-resources/sleep/SDKP_phenotype_reference_guide.pdf");
        });
        
    });

    function setPdfViewer() {
        var pageHeader = 145;
        $('a.media').media({width: "100%", height: $(window).height() - pageHeader});
    }

</script>

%{--Main search page for application--}%
<div id="main">
    <div class="container content-wrapper">
        <h1 class="dk-page-title">Resources</h1>
        <g:if test="${g.portalTypeString()?.equals('stroke')}">


            <div class="tutorial" style="margin-bottom: 15px; text-align: center">
                <div class="btn dk-t2d-blue dk-video-button dk-right-column-buttons-compact "><a href="https://www.youtube.com/watch?v=jsgUxsd7Z4w" target="_blank">Video walkthrough</a></div>
            <div class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact "><a id="portalPdf"><g:message
                code="portal.introTutorial.title"/></a></div>
            <div class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact "><a id="CDKPGenePageGuidePdf"><g:message
                    code="portal.GenePageGuide.title"/></a></div>
                <div class="btn dk-t2d-green dk-tutorial-button dk-right-column-buttons-compact "><a id="GAITPdf"><g:message
                        code="portal.GAITguide.title"/></a></div>
            <div class="btn dk-t2d-green dk-tutorial-button dk-right-column-buttons-compact "><a id="variantPdf"><g:message
                    code="portal.variantFinderTutorial.title"/></a></div>
            <div class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact "><a id="VariantResultsPdf"><g:message
                    code="portal.variantResultsTableGuide.title"/></a></div>
            <div class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact "><a id="StrokePhenotypeGuidePdf"><g:message
                    code="portal.PhenotypeGuide.title"/></a></div>
                <div class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact "><a id="GeneticsGuidePdf"><g:message
                        code="portal.GeneticsGuide.title"/></a></div>
        </div>

        </g:if>

        <g:elseif test="${g.portalTypeString()?.equals('t2d')}">


            <div class="tutorial" style="margin-bottom: 15px; text-align: center">
                <div class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact "><a id="portalPdf"><g:message
                    code="portal.introTutorial.title"/></a></div>
                <div class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact"><a id="GenePageGuidePdf"><g:message
                        code="portal.GenePageGuide.title"/></a></div>
                <div class="btn dk-t2d-green dk-tutorial-button dk-right-column-buttons-compact"><a id="GAITPdf"><g:message
                        code="portal.GAITguide.title"/></a></div>
                <div class="btn dk-t2d-green dk-tutorial-button dk-right-column-buttons-compact"><a id="variantPdf"><g:message
                        code="portal.variantFinderTutorial.title"/></a></div>
                <div class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact"><a id="VariantResultsPdf"><g:message
                        code="portal.variantResultsTableGuide.title"/></a></div>
                <div class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact"><a id="PhenotypeGuidePdf"><g:message
                code="portal.PhenotypeGuide.title"/></a></div>
                <div class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact"><a id="GeneticsGuidePdf"><g:message
                        code="portal.GeneticsGuide.title"/></a></div>

            </div>

        </g:elseif>

<g:elseif test="${g.portalTypeString()?.equals('mi')}">

            <div class="tutorial" style="margin-bottom: 15px; text-align: center">
                <div class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact "><a id="portalPdf"><g:message
                    code="portal.introTutorial.title"/></a></div>
                <div class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact "><a id="MIgenePdf"><g:message
                        code="portal.GenePageGuide.title"/></a></div>
                <div class="btn dk-t2d-green dk-tutorial-button dk-right-column-buttons-compact "><a id="GAITPdf"><g:message
                        code="portal.GAITguide.title"/></a></div>
                <div class="btn dk-t2d-green dk-tutorial-button dk-right-column-buttons-compact "><a id="MIVFPdf"><g:message
                        code="portal.variantFinderTutorial.title"/></a></div>
                <div class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact "><a id="VariantResultsPdf"><g:message
                        code="portal.variantResultsTableGuide.title"/></a></div>
                <div class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact "><a id="GeneticsGuidePdf"><g:message
                        code="portal.GeneticsGuide.title"/></a></div>
            </div>

    </g:elseif>

        <g:elseif test="${g.portalTypeString()?.equals('epilepsy')}">

            <div class="tutorial" style="margin-bottom: 15px; text-align: center">
                <div class="btn dk-t2d-green dk-tutorial-button dk-right-column-buttons-compact "><a id="GAITPdf"><g:message
                        code="portal.GAITguide.title"/></a></div>
                <div class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact "><a id="VariantResultsPdf"><g:message
                        code="portal.variantResultsTableGuide.title"/></a></div>
                <div class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact "><a id="GeneticsGuidePdf"><g:message
                        code="portal.GeneticsGuide.title"/></a></div>
            </div>

        </g:elseif>

        <g:elseif test="${g.portalTypeString()?.equals('sleep')}">

            <div class="tutorial" style="margin-bottom: 15px; text-align: center">
                <div class="btn dk-t2d-green dk-tutorial-button dk-right-column-buttons-compact "><a id="SDKPPhenotypeGuidePdf"><g:message
                        code="portal.PhenotypeGuide.title"/></a></div>

            </div>

        </g:elseif>

        <g:if test="${g.portalTypeString()?.equals('t2d')}">
            <a class="media" href="${links.introTutorial}">PDF File</a>
        </g:if>
        <g:elseif test="${g.portalTypeString()?.equals('mi')}">
            <a class="media" href="${links.miIntroTutorial}">PDF File</a>
        </g:elseif>
        <g:elseif test="${g.portalTypeString()?.equals('epilepsy')}">
            Tutorials will go here.
        </g:elseif>
        <g:elseif test="${g.portalTypeString()?.equals('sleep')}">
            <a class="media" href="${links.SDKPPhenotypeGuide}">PDF File</a>
        </g:elseif>
        <g:else>
            <a class="media" href="${links.strokeIntroTutorial}">PDF File</a>
        </g:else>
    </div>
</div>

</body>
</html>
