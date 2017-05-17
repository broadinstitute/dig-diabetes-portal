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
    });

    function setPdfViewer() {
        var pageHeader = 145;
        $('a.media').media({width: "100%", height: $(window).height() - pageHeader});
    }

</script>

%{--Main search page for application--}%
<div id="main">
    <div class="container content-wrapper">
        <h1 class="page-header">Resources</h1>
        <g:if test="${g.portalTypeString()?.equals('stroke')}">
            <a href="https://www.youtube.com/watch?v=jsgUxsd7Z4w" target="_blank">Video walkthrough</a>



        <ul class="tutorial"><li><a id="portalPdf" class="btn btn-default btn-sm"><g:message
                code="portal.introTutorial.title"/></a></li>
            <li><a id="variantPdf" class="btn btn-default btn-sm"><g:message
                    code="portal.variantFinderTutorial.title"/></a></li>
            %{--<li><a id="GAITPdf" class="btn btn-default btn-sm"><g:message--}%
                    %{--code="portal.GAITguide.title"/></a></li>--}%
            %{--<li><a id="VariantResultsPdf" class="btn btn-default btn-sm"><g:message--}%
                    %{--code="portal.variantResultsTableGuide.title"/></a></li>--}%
            %{--<li><a id="GeneticsGuidePdf" class="btn btn-default btn-sm"><g:message--}%
                    %{--code="portal.GeneticsGuide.title"/></a></li>--}%
            %{--<li><a id="PhenotypeGuidePdf" class="btn btn-default btn-sm"><g:message--}%
                    %{--code="portal.PhenotypeGuide.title"/></a></li>--}%
        </ul>

        </g:if>

        <g:elseif test="${g.portalTypeString()?.equals('t2d')}">


            <ul class="tutorial"><li><a id="portalPdf" class="btn btn-default btn-sm"><g:message
                    code="portal.introTutorial.title"/></a></li>
                <li><a id="variantPdf" class="btn btn-default btn-sm"><g:message
                        code="portal.variantFinderTutorial.title"/></a></li>
                <li><a id="GAITPdf" class="btn btn-default btn-sm"><g:message
                        code="portal.GAITguide.title"/></a></li>
                <li><a id="VariantResultsPdf" class="btn btn-default btn-sm"><g:message
                        code="portal.variantResultsTableGuide.title"/></a></li>
                <li><a id="GeneticsGuidePdf" class="btn btn-default btn-sm"><g:message
                        code="portal.GeneticsGuide.title"/></a></li>
                <li><a id="PhenotypeGuidePdf" class="btn btn-default btn-sm"><g:message
                code="portal.PhenotypeGuide.title"/></a></li>
            </ul>

        </g:elseif>
        <g:else>
        <ul class="tutorial"><li><a id="portalPdf" class="btn btn-default btn-sm"><g:message
                code="portal.introTutorial.title"/></a></li>
            <li><a id="variantPdf" class="btn btn-default btn-sm"><g:message
                    code="portal.variantFinderTutorial.title"/></a></li>
            <li><a id="GAITPdf" class="btn btn-default btn-sm"><g:message
                    code="portal.GAITguide.title"/></a></li>
            <li><a id="VariantResultsPdf" class="btn btn-default btn-sm"><g:message
                    code="portal.variantResultsTableGuide.title"/></a></li>
            <li><a id="GeneticsGuidePdf" class="btn btn-default btn-sm"><g:message
                    code="portal.GeneticsGuide.title"/></a></li>
        </g:else>

        <g:if test="${g.portalTypeString()?.equals('t2d')}">
            <a class="media" href="${links.introTutorial}">PDF File</a>
        </g:if>
        <g:elseif test="${g.portalTypeString()?.equals('mi')}">
            <a class="media" href="${links.miIntroTutorial}">PDF File</a>
        </g:elseif>
        <g:else>
            <a class="media" href="${links.strokeIntroTutorial}">PDF File</a>
        </g:else>
    </div>
</div>

</body>
</html>
