<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>

<body>
<script>
    var variant;
    $.ajax({
        cache:false,
        type:"get",
        url:"../variantAjax/"+"<%=variantToSearch%>",
        async:true,
        success: function (data) {
            fillTheFields(data) ;
            console.log(' fields have been filled')
        }
    });
    function fillTheFields (data)  {
        variant =  data['variant'];
        $('#variantTitle').append(UTILS.get_variant_title(variant));
        $('#variantCharacterization').append(UTILS.getSimpleVariantsEffect(variant.MOST_DEL_SCORE));
        $('#describingVariantAssociation').append(UTILS.variantInfoHeaderSentence(variant));
        var pVal= UTILS.get_lowest_p_value(variant);
        $('#variantPValue').append((parseFloat (pVal[0])).toPrecision(4));
        $('#variantInfoGeneratingDataSet').append(pVal[1]);
   }
</script>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >


                <h1>
                    <span id="variantTitle"></span>
                    <a class="page-nav-link" href="#associations">Associations</a>
                    <a class="page-nav-link" href="#populations">Populations</a>
                    <a class="page-nav-link" href="#biology">Biology</a>
                </h1>

                <g:render template="variantPageHeader" />

                %{--<g:if test="(gene_info.GENE_SUMMARY_TOP)">--}%
                %{--<div class="gene-summary">--}%
                    %{--<div class="title">Curated Summary</div>--}%

                    %{--<div class="top">--}%
                        %{--<%=gene_info.GENE_SUMMARY_TOP%>--}%
                    %{--</div>--}%

                    %{--<div class="bottom ishidden" style="display: none;">--}%
                        %{--<%=gene_info.GENE_SUMMARY_BOTTOM%>--}%
                    %{--</div>--}%
                    %{--<a class="boldlink" id="gene-summary-expand">click to expand</a>--}%
                %{--</div>--}%
            %{--</g:if>--}%

            %{--<script>--}%
                %{--var geneInfo = {};--}%
                %{--geneInfo.variationTable =  [] ;--}%
                %{--<g:each in="${0..(variationTable.size()-1)}">--}%
                %{--geneInfo.variationTable.push({"cohort":"${variationTable[it]["COHORT"]}",--}%
                    %{--"participants": "${variationTable[it]["NS"]}",--}%
                    %{--"variants": "${variationTable[it]["TOTAL"]}",--}%
                    %{--"common": "${variationTable[it]["COMMON"]}",--}%
                    %{--"lowfrequency": "${variationTable[it]["LOW_FREQUENCY"]}",--}%
                    %{--"rare": "${variationTable[it]["RARE"]}"--}%
                %{--});--}%
                %{--</g:each>--}%

            %{--</script>--}%


            %{--<p><strong>Uniprot Summary:</strong> <%=gene_info.Function_description%></p>--}%

            %{--<div class="separator"></div>--}%

            %{--<g:render template="variantsAndAssociations" />--}%

            %{--<div class="separator"></div>--}%

            %{--<g:render template="variationAcrossContinents" />--}%

            %{--<div class="separator"></div>--}%

            %{--<g:render template="biologicalHypothesisTesting" />--}%

            %{--<div class="separator"></div>--}%

            %{--<g:render template="findOutMore" />--}%

            </div>

        </div>
    </div>

</div>

</body>
</html>

