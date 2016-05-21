<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    %{--<r:require modules="portalHome"/>--}%
    <r:layoutResources/>
</head>

<body>

%{--Main search page for application--}%
<div id="main">
    <div class="container">
        <div class="row">

            %{--video--}%
            <div class="row sectionBuffer" style="padding: 25px">
                <div class="col-md-offset-2 col-md-8 col-sm-12">
                    <g:if test="${g.portalTypeString()?.equals('t2d')}">
                        <h2><a  class="standardLinks" href="${links.introTutorial}" target="_blank"><g:message code="portal.introTutorial.title"/></a></h2>
                        <h2><a  class="standardLinks" href="${links.variantFinderTutorial}" target="_blank"><g:message code="portal.variantFinderTutorial.title"/></a></h2>
                    </g:if>
                    <g:else>
                        <h2><a  class="standardLinks" href="${links.strokeIntroTutorial}" target="_blank"><g:message code="portal.introTutorial.title"/></a></h2>
                        <h2><a  class="standardLinks" href="${links.strokeVariantFinderTutorial}" target="_blank"><g:message code="portal.variantFinderTutorial.title"/></a></h2>
                    </g:else>
                </div>

                <div class="col-md-2">
                </div>

            </div>

        </div>
    </div>
</div>

</body>
</html>
