<style>
    .transcriptSummary {
        max-width: 24%;
        margin-right: 10px;
    }
    .transcriptSummary > ul {
        list-style: none;
        padding: 0;
    }
</style>


<div>
    <p id="variantSummaryText"><g:message code="variant.summaryText.summary" /></p>
    <h4><g:message code="variant.summaryText.transcriptHeader" default="Transcripts" /></h4>
    <div id="transcriptSummaries" style="display: flex; flex-wrap: wrap; width: 100%">
    </div>
   <div class="col-md-4"></div>
</div>

<script id="transcriptSummaryTemplate" type="x-tmpl-mustache">
    <div class="transcriptSummary" style="">
        <h5><b>{{ transcriptName }}</b></h5>
        <ul>
            {{ #referenceNucleotide }}<li><g:message code="variant.summaryText.refNucleotide" default="Reference nucleotide:" /> {{ referenceNucleotide }}</li>{{ /referenceNucleotide }}
            {{ #variantNucleotide }}<li><g:message code="variant.summaryText.varNucleotide" default="Variant nucleotide:" /> {{ variantNucleotide }}</li>{{ /variantNucleotide }}
            {{ #proteinChange }}<li><g:message code="variant.impactOnProtein.proteinChange" default="Protein change:" /> {{ proteinChange }}</li>{{ /proteinChange }}
            {{ #consequence }}<li><g:message code="variant.summaryText.consequence" default="Consequence:" /> {{ consequence }}</li>{{ /consequence }}
        </ul>
    </div>
</script>
