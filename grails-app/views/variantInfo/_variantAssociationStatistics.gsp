<script>
    var phenotypeDatasetMapping = {};
    <g:applyCodec encodeAs="none">
    phenotypeDatasetMapping = ${phenotypeDatasetMapping};
    </g:applyCodec>

    var variantId = '<%=variantToSearch%>';

    var variantAssociationStrings = {
        genomeSignificance: '<g:message code="variant.variantAssociations.significance.genomeSignificance" default="GWAS significance" />',
        locusSignificance: '<g:message code="variant.variantAssociations.significance.locusSignificance" default="locus wide significance" />',
        nominalSignificance: '<g:message code="variant.variantAssociations.significance.nominalSignificance" default="nominal significance" />',
        nonSignificance: '<g:message code="variant.variantAssociations.significance.nonSignificance" default="no significance" />',
    };


    // this lives here so that the correct strings can be loaded by the server
    var toggleOtherAssociations = function () {
        var toggle = $('#toggleButton');
        var text = toggle.text();

        if (text == '${g.message(code:"variant.variantAssociations.expandAssociations", default:"expand associations for all traits")}') {
            // content is hidden
            toggle.text('${g.message(code:"variant.variantAssociations.hideAssociations", default:"hide associations")}');
            $('#otherTraitsSection').css({display: 'flex'});
        } else {
            // content is visible
            toggle.text('${g.message(code:"variant.variantAssociations.expandAssociations", default:"expand associations for all traits")}');
            $('#otherTraitsSection').css({display: 'none'});
        }
    };

    mpgSoftware.variantInfo.retrieveVariantPhenotypeData(phenotypeDatasetMapping,
            variantId,
            variantAssociationStrings,
            '${createLink(controller:'variantInfo',action: 'variantDescriptiveStatistics')}',
            '${g.defaultPhenotype()}');
</script>


<div class="container content-wrapper">
    <h5><g:message code="variant.info.associations.description"/></h5>
    <table>
        <tr>
            <td><g:message code="variant.variantAssociations.legend.directionOfEffect"
                       default="Direction of effect"/>:</td><td style="padding-right: 20px;"><span
                style="float: left;display:block; margin-right: 5px; margin-left: 5px;"><g:message
                    code="variant.variantAssociations.legend.up" default="up"/></span><span
                style="float: left;display:block; background-color: #33C; color:#fff;width: 10px;text-align:center; margin-right: 5px;">&#8593</span><span
                style="float: left;display:block; margin-right: 5px;"><g:message
                    code="variant.variantAssociations.legend.down" default="down"/></span><span
                style="float:left; display:block; background-color: #90f; color:#fff;width: 10px; text-align:center;">&#8595</span>
            </td>
            <td><g:message code="variant.variantAssociations.legend.dataset" default="Dataset"/>:</td><td style="padding-right: 20px;"><div
                style="background-color: #ccc; color: #fff; width:auto; margin-left: 5px; float: left; padding: 0 5px;"><span
                    style="color: #333; font-size: 12px;"><g:message code="variant.variantAssociations.legend.sampleSize"
                                                                     default="sample size"/></span> | <span
                    style="color: #F00; font-size: 12px;"><g:message code="variant.variantAssociations.legend.frequency"
                                                                     default="frequency"/></span> | <span
                    style="color:#33F; font-size: 12px;"><g:message code="variant.variantAssociations.legend.count"
                                                                    default="count"/></span></div>
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