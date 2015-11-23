<h4><g:message code='hypothesisGen.variantSearchRestrictToEthnicity.title'/></h4>
<div class="row clearfix">
    <div class="col-md-6">
        <div id="frequencies-form">
       <g:if test="${show_exseq}">
           <g:alleleFrequencyRange></g:alleleFrequencyRange>
        </g:if>
        </div>
    </div>
    <div class="col-md-6" style="display: none">
      <g:if test="${show_exseq}">
        <g:message code='hypothesisGen.variantSearchRestrictToEthnicity.desc'/>
      </g:if>
    </div>
</div>

