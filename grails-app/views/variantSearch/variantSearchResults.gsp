<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:layoutResources/>
</head>

<body>
<script>

    jQuery.fn.dataTableExt.oSort['allnumeric-asc']  = function(a,b) {
        var x = parseFloat(a);
        var y = parseFloat(b);
        if (!x) { x = 1; }
        if (!y) { y = 1; }
        return ((x < y) ? -1 : ((x > y) ?  1 : 0));
    };

    jQuery.fn.dataTableExt.oSort['allnumeric-desc']  = function(a,b) {
        var x = parseFloat(a);
        var y = parseFloat(b);
        if (!x) { x = 1; }
        if (!y) { y = 1; }
        return ((x < y) ? 1 : ((x > y) ?  -1 : 0));
    };

    UTILS.postJson2('../variantSearch/variantSearchAjax',"<%=filter%>",
            ${show_gene},
            ${show_sigma},
            ${show_exseq},
            ${show_exchp},
            '<g:createLink controller="variant" action="variantInfo"  />',
            '<g:createLink controller="gene" action="geneInfo"  />');
    var uri_dec = decodeURIComponent("<%=filter%>");
</script>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >



                <h1>Variant Search Results</h1>
                <div class="separator"></div>

                <h3>Showing <span id="numberOfVariantsDisplayed"></span> variants that meet the following criteria:</h3>
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

                <p><a href="<g:createLink controller="variantSearch" action="variantSearch" />" class="boldlink">Click here to refine your results</a></p>


                <g:render template="../region/collectedVariantsForRegion" />



            </div>

        </div>
    </div>

</div>

</body>
</html>
