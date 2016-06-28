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
            <g:else>
                $(".media").attr("href", "${links.strokeVariantFinderTutorial}");
                $(".media").find("iframe").attr("src", "${links.strokeVariantFinderTutorial}");
            </g:else>
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
        <h1 class="page-header">Tutorials</h1>
        <g:if test="${g.portalTypeString()?.equals('stroke')}">
            <a href="https://www.youtube.com/watch?v=jsgUxsd7Z4w" target="_blank">Video walkthrough</a>
        </g:if>
        <ul class="tutorial"><li><a id="portalPdf" class="btn btn-default btn-sm"><g:message
                code="portal.introTutorial.title"/></a></li>
            <li><a id="variantPdf" class="btn btn-default btn-sm"><g:message
                    code="portal.variantFinderTutorial.title"/></a></li></ul>
        <g:if test="${g.portalTypeString()?.equals('t2d')}">
            <a class="media" href="${links.introTutorial}">PDF File</a>
        </g:if>
        <g:else>
            <a class="media" href="${links.strokeIntroTutorial}">PDF File</a>
        </g:else>
    </div>
</div>

</body>
</html>
