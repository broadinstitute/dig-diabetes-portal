<h4><g:message code="variantSearch.setAlleleFrequencies.title" default="Set allele frequencies (use only if searching exome sequence data)" /></h4>
<div class="row clearfix">
    <div class="col-md-6">
        <div id="frequencies-form">
        <g:if test="${show_sigma}">
            <div class="checkbox">
                        <div class="row">
                            <div class="col-xs-4">
                                <label>
                                    <strong>Allele frequency:</strong>
                                </label>
                            </div>
                            <div class="col-xs-2" style="text-align: right">from</div>
                            <div class="col-xs-2">
                                <input type="text" class="form-control" id="ethnicity_af_sigma" />
                            </div>
                            <div class="col-xs-1" style="text-align: right">
                                to
                            </div>
                            <div class="col-xs-2">
                                <input type="text" class="form-control" id="ethnicity_af_sigma"/>
                            </div>
                        </div>
                    </div>
       </g:if>
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
      <g:if test="${show_sigma}">
        <p>
            <g:message code="variantSearch.setAlleleFrequencies.sigmaHelpText" default="Sigma help text" />
        </p>
      </g:if>
    </div>
</div>

