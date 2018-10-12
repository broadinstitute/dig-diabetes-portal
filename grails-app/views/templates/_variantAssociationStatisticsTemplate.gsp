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
                {{#exposeGreenBoxes}}
                <li role="presentation" class="variantTableLabels highImpacVariantChooser">
                    <a href="#exposeGreenBoxesHolder" aria-controls="forestTabHolder" role="tab" data-toggle="tab">Dataset specific details</a>
                </li>
                {{/exposeGreenBoxes}}
            </ul>
        </div>
    </div>

    <div class="tab-content">
    {{#phewasTab}}
        <div role="tabpanel" class="active tab-pane " id="phewasTabHolder">
            <div class="row"   style="border: none">
                <div class="container content-wrapper">
                    <div id="phewas">
                        <div class="text-right">
                            <input id="phewasAllDatasets" type="checkbox">%{--onClick generalizedInitLocusZoom added later--}%
                            <label for="phewasAllDatasets">Include all datasets</label>
                        </div>
                                                <div class="text-right">
                                                <g:helpText title="geneTable.ukbb.phewas.help.header" placement="bottom" body="geneTable.ukbb.phewas.help.text"/>
                            <input id="phewasUseUKBB" type="checkbox">%{--onClick generalizedInitLocusZoom added later--}%
                            <label for="phewasUseUKBB">Use UKBB data</label>
                        </div>
                    </div>
                    <div id="plot"></div>
                </div>
            </div>
        </div>

{{/phewasTab}}

{{#forestTab}}
        <div role="tabpanel" class="tab-pane active" id="forestTabHolder">
            <div class="row"   style="border: none">
                <div class="container content-wrapper">
                    <div id="forestPlot"></div>
                </div>
            </div>
        </div>
{{/forestTab}}

{{#forestTab}}
        <div role="tabpanel" class="tab-pane" id="exposeGreenBoxesHolder">
    <div class="container content-wrapper">
        <g:if test="${g.portalTypeString()?.equals('stroke')}">
    <h5><g:message code="variant.info.stroke.associations.description"/></h5>
</g:if>
<g:elseif test="${g.portalTypeString()?.equals('mi')}">
    <h5><g:message code="variant.info.mi.associations.description"/></h5>
</g:elseif>
<g:else>
    <h5><g:message code="variant.info.associations.description"/></h5>
</g:else>

        <table>
            <tr>
                <td>
                    <g:message code="variant.variantAssociations.legend.colorkey" default="Color key"/>:
                </td>
                <td style="padding-right: 20px;"><div
                        style="background-color: #006633; color: #fff; width:auto; margin-left: 5px; float: left; padding: 0 5px;"><span
                            style="color: #FFFFFF; font-size: 12px;"><g:message code="variant.variantAssociations.legend.colorkey.genomewide"
                                                                                default="p &lt; 5e-8" />  <g:helpText title="variant.variantAssociations.colorkeyGenomewide.help.header" placement="bottom" body="variant.variantAssociations.colorkeyGenomewide.help.text"/></span>
                </div>
                </td>
                <td style="padding-right: 20px;"><div
                        style="background-color: #7AB317; color: #fff; width:auto; margin-left: 5px; float: left; padding: 0 5px;"><span
                            style="color: #FFFFFF; font-size: 12px;"><g:message code="variant.variantAssociations.legend.colorkey.locuswide"
                                                                                default="p &lt; 5e-5" />  <g:helpText title="variant.variantAssociations.colorkeyLocuswide.help.header" placement="bottom" body="variant.variantAssociations.colorkeyLocuswide.help.text"/></span>
                </div>
                </td>
                <td style="padding-right: 20px;"><div
                        style="background-color: #9ED54C; color: #fff; width:auto; margin-left: 5px; float: left; padding: 0 5px;"><span
                            style="color: #FFFFFF; font-size: 12px;"><g:message code="variant.variantAssociations.legend.colorkey.nominal"
                                                                                default="p &lt; 0.05" />  <g:helpText title="variant.variantAssociations.colorkeyNominal.help.header" placement="bottom" body="variant.variantAssociations.colorkeyNominal.help.text"/></span>
                </div>
                </td>
                <td><g:message code="variant.variantAssociations.legend.directionOfEffect"
                               default="Direction of effect"/>:</td><td style="padding-right: 20px;"><span
                    style="float: left;display:block; margin-right: 5px; margin-left: 5px;"><g:message
        code="variant.variantAssociations.legend.up" default="up"/></span><span
                    style="float: left;display:block; background-color: #33C; color:#fff;width: 10px;text-align:center; margin-right: 5px;">&#8593</span><span
                    style="float: left;display:block; margin-right: 5px;"><g:message
        code="variant.variantAssociations.legend.down" default="down"/></span><span
                    style="float:left; display:block; background-color: #90f; color:#fff;width: 10px; text-align:center;">&#8595</span>
                <span
                        style="float:left; display:block; width: 10px; ">&nbsp;</span>
                <g:helpText title="variant.variantAssociations.direction.help.header" placement="bottom" body="variant.variantAssociations.direction.help.text"/>
            </td>
                <td><g:message code="variant.variantAssociations.legend.dataset" default="Dataset"/>:</td><td style="padding-right: 20px;"><div
                    style="background-color: #ccc; color: #fff; width:auto; margin-left: 5px; float: left; padding: 0 5px;"><span
                        style="color: #333; font-size: 12px;"><g:message code="variant.variantAssociations.legend.sampleSize"
                                                                         default="sample size"/>  <g:helpText title="variant.variantAssociations.size.help.header" placement="bottom" body="variant.variantAssociations.size.help.text"/></span> | <span
                        style="color: #F00; font-size: 12px;"><g:message code="variant.variantAssociations.legend.frequency"
                                                                         default="frequency"/>  <g:helpText title="variant.alleleFrequency.help.header" placement="bottom" body="variant.alleleFrequency.help.text"/></span> | <span
                        style="color:#33F; font-size: 12px;"><g:message code="variant.variantAssociations.legend.count"
                                                                        default="count"/>  <g:helpText title="variant.variantAssociations.count.help.header" placement="bottom" body="variant.variantAssociations.count.help.text"/></span>
            </div>
            </td>

            </tr>
        </table>

        <div class="info-box-wrappers">
            <div id="primaryPhenotype" class="col-md-12 t2d-info-box-wrapper"></div>
            <h4 id="otherTraits"><i><g:message code="variant.variantAssociations.otherTraits"
                                               default="Other traits with one or more nominally significant associations:"/></i>
            </h4>
            <h4 id="noOtherTraits" style="display: none;"><i><g:message code="variant.variantAssociations.noOtherTraits"
                                                                        default="No other traits show nominally significant associations."/></i>
            </h4>
            <a id="toggleButton" class="btn btn-primary btn-sm" onClick="toggleOtherAssociations()"><g:message
        code="variant.variantAssociations.expandAssociations" default="expand associations for all traits"/></a>
            <div id="otherTraitsSection" class="col-md-12 other-traits-info-box-wrapper"
                 style="display: none; flex-wrap: wrap; padding-left:0; padding-right: 0;">
            </div>
        </div>

    </div>

        </div>
{{/forestTab}}

    </div>


</script>


<script id="greenBoxHolderTemplate" type="x-tmpl-mustache">
</script>
