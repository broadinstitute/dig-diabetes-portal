<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:require modules="tableViewer"/>
    <r:layoutResources/>
</head>

<body>
<script>


    var  proteinEffectList =  new UTILS.proteinEffectListConstructor (decodeURIComponent("${proteinEffectsList}")) ;
    UTILS.postJson2('../variantSearch/variantSearchAjax',"<%=filter%>",
            ${show_gene},
            ${show_sigma},
            ${show_exseq},
            ${show_exchp},
            '<g:createLink controller="variant" action="variantInfo"  />',
            '<g:createLink controller="gene" action="geneInfo"  />',
            '<g:createLink controller="variantSearch" action="variantSearchAjax" />',
            ${dataSetDetermination} );
    var uri_dec = decodeURIComponent("<%=filter%>");
    var encodedParameters = decodeURIComponent("<%=encodedParameters%>");

</script>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >



                <h1><g:message code="variantTable.searchResults.title" default="Variant Search Results" /></h1>
                <div class="separator"></div>

                <h3><g:message code="variantTable.searchResults.meetFollowingCriteria1" default="Showing" /> <span id="numberOfVariantsDisplayed"></span>
                    <g:message code="variantTable.searchResults.meetFollowingCriteria2" default="variants that meet the following criteria:" /></h3>
                <script>
                    if (uri_dec)     {
                        $('#tempfilter').append(uri_dec.split('+').join());
                    }
                </script>
                <ul>
                 <g:each in="${filterDescriptions}" >
                     <li>${it}</li>
                 </g:each>
                 </ul>

                <div id="warnIfMoreThan1000Results"></div>

                <p><a href="<g:createLink controller='variantSearch' action='variantSearch' params='[encParams:"${encodedParameters}"]'/>" class='boldlink'>
                    <g:message code="variantTable.searchResults.clickToRefine" default="Click here to refine your results" /></a></p>


                <g:render template="../region/collectedVariantsForRegion" />



            </div>

        </div>
    </div>

</div>

</body>
</html>
