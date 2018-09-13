<script id="boxTemplate" type="x-tmpl-mustache">
    %{--if emptyBlock is true, then show an invisible box to make the phenotypes line up nicely--}%
    {{ ^emptyBlock }}
    <li class=" {{ boxClass }}" style="background-color: {{ backgroundColor }};">
        <h3 style="color: {{ datasetAndPValueTextColor }};">{{{ dataset }}}</h3>
        <div style="position: absolute; left: 0; bottom: 0; width:100%; display: flex; flex-direction: column; align-items: center">
            <div style="color: {{ datasetAndPValueTextColor }}; padding-top: 2px; padding-bottom: 2px; width: 100%" >
                <span class="p-value">{{ pValueText }}</span>
                <span class="p-value-significance">{{ pValueSignificance }}</span>
            </div>
            <div style="background-color: {{ oddsRatioOrEffectTextBackgroundColor }}; padding-top: 2px; padding-bottom: 2px; width: 100%" >
                <span style='display:block; left: 5px; position:absolute; font-size: 12px; margin-top: 2px;'>{{ effectArrow }}</span><span class="extra-info">{{ oddsRatioOrEffectText }}</span>
            </div>
            <div style="color: white; background-color: #bbb; padding-top: 2px; padding-bottom: 2px; width: 100%; display: flex; justify-content: space-around; align-items: center" >
                <span class="extra-info" style="color: #333;"><strong>{{ count }}</strong></span> | <span class="extra-info" style="color: #f03;"><strong>{{ freqInCases }}</strong></span> | <span class="extra-info" style="color: #30f;"><strong>{{ countInCases }}</strong></span>
            </div>
        </div>
    </li>
    {{ /emptyBlock }}
    {{ #emptyBlock }}
    <li class=" {{ boxClass }}">
    </li>
    {{ /emptyBlock }}
</script>

<script id="phenotypeTemplate" type="x-tmpl-mustache">
    <div id="{{ rowId }}" class="info-box-holder {{ rowClass }}" style="border-color: {{ phenotypeColor }};">
        <h3 style="color: {{ phenotypeColor }}">{{ phenotypeName }}</h3>
        <ul></ul>
    </div>
</script>

<script id="phenotypePerVariantTemplate" type="x-tmpl-mustache">
    <div class="row">
        <div class="col-xs-12">
            <ul class="nav nav-tabs" role="tablist">
                {{#phewasTab}}
                <li role="presentation" class="active variantTableLabels commonVariantChooser">
                    <a href="#phewasTabHolder" aria-controls="phewasTabHolder" role="tab" data-toggle="tab" onclick="mpgSoftware.traitsFilter.massageLZ();">PheWAS plot</a>
                </li>
                {{/phewasTab}}
                {{#forestTab}}
                <li role="presentation" class="variantTableLabels highImpacVariantChooser">
                    <a href="#forestTabHolder" aria-controls="forestTabHolder" role="tab" data-toggle="tab" onclick="mpgSoftware.traitsFilter.massageLZ();">Forest plot</a>
                </li>
                {{/forestTab}}
            </ul>
        </div>
    </div>

</script>