<h4><g:message code="variantSearch.setAlleleFrequencies.title" default="Set allele frequencies (use only if searching exome sequence data)" /></h4>
<div class="row clearfix">
    <div class="col-md-6">
        <div id="frequencies-form">
       <g:if test="${show_exseq}">
           <g:alleleFrequencyRange></g:alleleFrequencyRange>
        </g:if>
        </div>
    </div>
    <div class="col-md-6">
      <g:if test="${show_exseq}">
        <p>
            <g:message code="variantSearch.setAlleleFrequencies.exomeSequencingHelpText" default="Exome sequencing help text" />
        </p>
      </g:if>
    </div>
</div>

