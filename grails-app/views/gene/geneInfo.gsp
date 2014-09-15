<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:require modules="geneInfo"/>
    <r:layoutResources/>

</head>

<body>
<script>
    var loading = $('#spinner').show();
    $.ajax({
        cache:false,
        type:"post",
        url:"../geneInfoAjax",
        data:{geneName:'<%=geneName%>'},
        async:true,
        success: function (data) {
            fillTheGeneFields(data,
                    ${show_gwas},
                    ${show_exchp},
                    ${show_exseq},
                    ${show_sigma},
                    '<g:createLink controller="region" action="regionInfo" />',
                    '<g:createLink controller="trait" action="regionInfo" />',
                    '<g:createLink controller="variantSearch" action="gene" />') ;
            loading.hide();
        },
        error: function(jqXHR, exception) {
            loading.hide();
            errorReporter(jqXHR, exception) ;
        }
    });
    var  phenotype =  new UTILS.phenotypeListConstructor (decodeURIComponent("${phenotypeList}")) ;
</script>

<div id="main">

    <div class="container" >

        <div class="gene-info-container" >
            <div class="gene-info-view" >

    <h1>
        <em><%=geneName%></em>
        <a class="page-nav-link" href="#associations">Associations</a>
        <a class="page-nav-link" href="#populations">Populations</a>
        <a class="page-nav-link" href="#biology">Biology</a>
    </h1>



                <g:if test="${(geneName == "C19ORF80")||
                        (geneName == "PAM")||
                        (geneName == "HNF1A")||
                        (geneName == "SLC16A11")||
                        (geneName == "SLC30A8")||
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
                                function toggleGeneDescr(){
                                    if ($('#geneHolderBottom').is(':visible'))  {
                                        $('#geneHolderBottom').hide();
                                    }else {
                                        $('#geneHolderBottom').show();
                                    }
                                }
                            </script>


                        </div>
                        <a class="boldlink" id="gene-summary-expand" onclick="toggleGeneDescr()">click to expand</a>
                    </div>
                </g:if>





                <p><span id="uniprotSummaryGoesHere"></span></p>

    <div class="separator"></div>

    <g:render template="variantsAndAssociations" />

    <div class="separator"></div>

    <g:render template="variationAcrossContinents" />

    <div class="separator"></div>

     <g:render template="biologicalHypothesisTesting" />

     <div class="separator"></div>

     <g:render template="findOutMore" />

            </div>
        </div>
    </div>

</div>

</body>
</html>

