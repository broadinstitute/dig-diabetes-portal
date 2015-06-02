<div class="row clearfix">
    <div class="col-md-12">
        <div id="frequencies-form">
            <g:if test="${show_sigma}">
                <div class="checkbox">
                    <div class="row smallish">
                        <div class="col-xs-4">
                            <label>
                                <strong>Allele frequency:</strong>
                            </label>
                        </div>
                        <div class="col-xs-2" style="text-align: right">from</div>
                        <div class="col-xs-2">
                            <input type="text" class="form-control" id="ethnicity_af_sigma-min" />
                        </div>
                        <div class="col-xs-1" style="text-align: right">
                            to
                        </div>
                        <div class="col-xs-2">
                            <input type="text" class="form-control" id="ethnicity_af_sigma-max"/>
                        </div>
                    </div>
                </div>
            </g:if>
            <g:if test="${show_exseq}">
                <g:alleleFrequencyRangeAbbreviated></g:alleleFrequencyRangeAbbreviated>
            </g:if>
        </div>
    </div>
</div>

