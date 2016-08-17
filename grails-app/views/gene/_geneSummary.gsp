<g:set var="annotatedGenes" value="${["C19ORF80",
                                      "PAM",
                                      "HNF1A",
                                      "SLC16A11",
                                      "SLC30A8",
                                      "WSF1"]}"/>

<g:if test="${annotatedGenes.contains(geneToSummarize)}">
    <div class="gene-summary">
        <div class="title"><g:message code="gene.header.geneSummary" default="Curated summary"/>
        <g:helpText title="gene.header.geneSummary.help.header" placement="right"
                    body="gene.header.geneSummary.help.text"/>
        </div>

        <div id="geneHolderTop" class="top">
            <script>
                var contents = '<g:renderGeneSummary geneFile="${geneName}-top" locale="${locale}"></g:renderGeneSummary>';
                $('#geneHolderTop').html(contents);
            </script>

        </div>

        <div class="bottom ishidden" id="geneHolderBottom" style="display: none;">
            <script>
                var contents = '<g:renderGeneSummary geneFile="${geneName}-bottom" locale="${locale}"></g:renderGeneSummary>';
                $('#geneHolderBottom').html(contents);
                function toggleGeneDescr() {
                    if ($('#geneHolderBottom').is(':visible')) {
                        $('#geneHolderBottom').hide();
                        $('#gene-summary-expand').html('<g:message code="gene.header.clickToExpand" default="click to expand"/>');
                    } else {
                        $('#geneHolderBottom').show();
                        $('#gene-summary-expand').html('<g:message code="gene.header.clickToCollapse" default="click to collapse"/>');
                    }
                }
            </script>

        </div>
        <a class="boldlink" id="gene-summary-expand" onclick="toggleGeneDescr()">
            <g:message code="gene.header.clickToExpand" default="click to expand"/>
        </a>
    </div>
</g:if>
<g:else>
    <p>
        <g:helpText title="gene.header.uniprotSummary.help.header" placement="right"
                    body="gene.header.uniprotSummary.help.text"/>
        <span id="uniprotSummaryGoesHere"></span>
    </p>
</g:else>
