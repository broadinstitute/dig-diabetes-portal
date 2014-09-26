<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:require modules="geneInfo"/>
    <r:layoutResources/>



    <!-- IGV Bootstrap css -->
    <link href="http://www.broadinstitute.org/igvdata/t2d/igv.css" type="text/css" rel="stylesheet">

    %{--<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->--}%
    %{--<!--[if lt IE 9]>--}%
    %{--<script src="//oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>--}%
    %{--<script src="//oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>--}%
    %{--<![endif]-->--}%

    %{--<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>--}%

    <!-- Bootstrap -->
    %{--<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>--}%
    <g:javascript src="lib/igv/vendor/inflate.js" />
    <g:javascript src="lib/igv/vendor/zlib_and_gzip.min.js" />
    <g:javascript base="http://www.broadinstitute.org/" src="/igvdata/t2d/igv-all.min.js" />
    <!-- IGV js code -->
    <script src="http://www.broadinstitute.org/igvdata/t2d/igv-all.min.js"></script>




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
            core.errorReporter(jqXHR, exception) ;
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







    <div class="accordion" id="accordion2">
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseOne">
                    Variants and associations
                </a>
            </div>
            <div id="collapseOne" class="accordion-body collapse in">
                <div class="accordion-inner">
                     <g:render template="variantsAndAssociations" />
                </div>
            </div>
        </div>


        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseIgv">
                    Integrative Genomics Viewer
                </a>
            </div>
            <div id="collapseIgv" class="accordion-body collapse">
                <div class="accordion-inner">
                    <g:render template="../trait/igvBrowser" />
                </div>
            </div>
        </div>



        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseTwo">
                    Variation across continental ancestry groups
                </a>
            </div>
            <div id="collapseTwo" class="accordion-body collapse">
                <div class="accordion-inner">
                    <g:render template="variationAcrossContinents" />
                </div>
            </div>
        </div>

        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseThree">
                    Biological hypothesis testing
                </a>
            </div>
            <div id="collapseThree" class="accordion-body collapse">
                <div class="accordion-inner">
                    <g:render template="biologicalHypothesisTesting" />
                </div>
            </div>
        </div>
    </div>

     <g:render template="findOutMore" />

            </div>
        </div>
    </div>

</div>

</body>
</html>

