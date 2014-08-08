<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>

<body>

<div id="main">

    <div class="container" >

        <div class="gene-info-container" >
            <div class="gene-info-view" >

    <h1>
        <em><%=gene_info.ID%></em>
        <a class="page-nav-link" href="#associations">Associations</a>
        <a class="page-nav-link" href="#populations">Populations</a>
        <a class="page-nav-link" href="#biology">Biology</a>
    </h1>



                <g:if test="${(geneName == "C19orf80")||
                        (geneName == "PAM")||
                        (geneName == "SLC30A8")||
                        (geneName == "WFS1")}">
                    <div class="gene-summary">
                        <div class="title">Curated Summary</div>

                        <div id="geneHolderTop" class="top">
                            <script>
                                var contents = "<g:renderGeneSummary geneFile="${geneName}-top"></g:renderGeneSummary>";
                                $('#geneHolderTop').html(contents);
                            </script>

                        </div>

                        <div class="bottom ishidden" id="geneHolderBottom" style="display: none;">
                            <script>
                                // var contents = "$<g:renderGeneSummary geneFile="${geneName}-bottom"></g:renderGeneSummary>";
                                var contents = "<%=renderGeneSummary(geneFile:"${geneName}-bottom")%>";
                                $('#geneHolderBottom').html(contents);
                            </script>

                            %{--<%=gene_info.GENE_SUMMARY_BOTTOM%>--}%
                        </div>
                        <a class="boldlink" id="gene-summary-expand">click to expand</a>
                    </div>
                </g:if>




                <script>
         var geneInfo = {};
         geneInfo.variationTable =  [] ;
         <g:if test="${variationTable}">
             <g:each in="${0..(variationTable.size()-1)}">
             if (variationTable[it]) {
                 geneInfo.variationTable.push({"cohort": "${(variationTable[it]["COHORT"])}",
                     "participants": "${variationTable[it]["NS"]}",
                     "variants": "${variationTable[it]["TOTAL"]}",
                     "common": "${variationTable[it]["COMMON"]}",
                     "lowfrequency": "${variationTable[it]["LOW_FREQUENCY"]}",
                     "rare": "${variationTable[it]["RARE"]}"
                 });
             }
             </g:each>
         </g:if>

    </script>


    <p><strong>Uniprot Summary:</strong> <%=gene_info.Function_description%></p>

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

