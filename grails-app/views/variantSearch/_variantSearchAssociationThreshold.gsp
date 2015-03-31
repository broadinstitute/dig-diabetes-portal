<h4><g:message code="variantSearch.associationThreshold.title" default="Set type 2 diabetes association threshold" /></h4>
<div class="row clearfix">
    <div class="col-md-6">
        <div id="significance-form">
            <div class="radio">
                <label>
                    <input id="id_significance_genomewide" type="radio" name="significance" value="genomewide" />
                    <g:message code="variantSearch.associationThreshold.genomewide" default="genome-wide significance" />  |  &le; 5 x 10<sup>-8</sup>
                    <g:helpText title="variantSearch.associationThreshold.genomewideQ.help.header"  qplacer="2px 0 0 6px 0 0" placement="right" body="variantSearch.associationThreshold.genomewideQ.help.text"/>
                </label>
            </div>
            <div class="radio">
                <label for="id_significance_nominal">
                    <input id="id_significance_nominal" type="radio" name="significance" value="nominal" />
                    <g:message code="variantSearch.associationThreshold.nominal" default="nominal significance" /> | &le; .05
                    <g:helpText title="variantSearch.associationThreshold.nominalQ.help.header"  qplacer="2px 0 0 6px 0 0" placement="right" body="variantSearch.associationThreshold.nominalQ.help.text"/>
                </label>
            </div>
            <div class="radio">
                <input id="id_significance_custom" type="radio" name="significance" value="custom" />
                <g:message code="variantSearch.associationThreshold.custom" default="custom" />
                <input type="text" id="custom_significance_input"/>
                    <g:message code="variantSearch.associationThreshold.orStronger" default="or stronger" />
                    <g:helpText title="variantSearch.associationThreshold.orStrongerQ.help.header"  qplacer="2px 0 0 6px 0 0" placement="right" body="variantSearch.associationThreshold.orStrongerQ.help.text"/>
            </div>

        </div>
    </div>
    <div class="col-md-6">
        <g:message code="variantSearch.associationThreshold.helpText" default="help text" />
    </div>
</div>

