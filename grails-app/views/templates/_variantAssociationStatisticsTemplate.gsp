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
                    <a style="float: left;" href="#forestTabHolder" aria-controls="forestTabHolder" role="tab" data-toggle="tab" onclick="mpgSoftware.traitsFilter.massageLZ();">Forest plot</a> <span class='new-dataset-flag' style="display: inline-flex; margin:-3px 0 0 -30px">&nbsp;</span>
                </li>
                {{/forestTab}}
                {{#exposeGreenBoxes}}
                <li role="presentation" class="variantTableLabels highImpacVariantChooser">
                    <a href="#exposeGreenBoxesHolder" aria-controls="exposeGreenBoxesHolder" role="tab" data-toggle="tab">Dataset specific details</a>
                </li>
                {{/exposeGreenBoxes}}
            </ul>
        </div>
    </div>

    <div class="tab-content">
    {{#phewasTab}}
        <div role="tabpanel" class="active tab-pane " id="phewasTabHolder">
            <div class="row"   style="border: none">

                <div class="container content-wrapper text-right">

                   <div id="phewas" class="btn-group btn-group-vertical text-left">
Choose associations to view:
                                                        <label  for="phewasBottomLineResults" class="radio">
                                <input class="radio" id="phewasBottomLineResults" name="optRadio" type="radio" checked>
                                Bottom line analysis&nbsp;
                                <g:helpText title="geneTable.BottomLine.phewas.help.header" placement="bottom" body="geneTable.BottomLine.phewas.help.text"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;<span class='new-dataset-flag' style="display: inline-flex; margin:-3px 0 0 -30px">&nbsp;</span></label>

                            <label  for="phewasTopVariants" class="radio">
                                <input class="radio" id="phewasTopVariants" name="optRadio" type="radio">
                                Smallest p-value&nbsp;
                            <g:helpText title="geneTable.TopVar.phewas.help.header" placement="bottom" body="geneTable.TopVar.phewas.help.text"/>
                            </label>

                            <label  for="phewasAllDatasets" class="radio">
                                <input class="radio" id="phewasAllDatasets" name="optRadio" type="radio">
                                All datasets&nbsp;
                            <g:helpText title="geneTable.AllDatasets.phewas.help.header" placement="bottom" body="geneTable.AllDatasets.phewas.help.text"/>
                            </label>

                            <label  for="phewasUseUKBB" class="radio">
                                <input class="radio" id="phewasUseUKBB" name="optRadio" type="radio">
                                UK Biobank analysis&nbsp;
                                <g:helpText title="geneTable.ukbb.phewas.help.header" placement="bottom" body="geneTable.ukbb.phewas.help.text"/>
                            </label>

                    </div>
                    <div id="phewasplot"></div>
            </div>
        </div>

    {{/phewasTab}}

    {{#forestTab}}
        <div role="tabpanel" class="active tab-pane" id="forestTabHolder">
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
