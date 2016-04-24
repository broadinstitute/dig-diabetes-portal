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
        variantPValues: '<g:message code="variant.variantAssociations.variantPValues" default="click here to see a table of P values" />',
        sourceDiagram: '<g:message code="variant.variantAssociations.source.diagram" default="diagram GWAS" />',
        sourceDiagramQ: '<g:helpText title="variant.variantAssociations.source.diagramQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.source.diagramQ.help.text"/>',
        sourceExomeChip: '<g:message code="variant.variantAssociations.source.exomeChip" default="Exome chip" />',
        sourceExomeChipQ: '<g:helpText title="variant.variantAssociations.source.exomeChipQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.source.exomeChipQ.help.text"/>',
        sourceExomeSequence: '<g:message code="variant.variantAssociations.source.exomeSequence" default="Exome sequence" />',
        sourceExomeSequenceQ: '<g:helpText title="variant.variantAssociations.source.exomeSequenceQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.source.exomeSequenceQ.help.text"/>',
        sourceSigma: '<g:message code="variant.variantAssociations.source.sigma" default="Sigma" />',
        sourceSigmaQ: '<g:helpText title="variant.variantAssociations.source.sigmaQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.source.sigmaQ.help.text"/>',
        associationPValueQ: '<g:helpText title="variant.variantAssociations.pValue.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.pValue.help.text"/>',
        associationOddsRatioQ: '<g:helpText title="variant.variantAssociations.oddsRatio.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.oddsRatio.help.text"/>'
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
    <table class="table table-condensed">
        <tr>
            <th>Direction of effect</th><th>Dataset</th><th>Glossary</th>
        </tr>
        <tr>
            <td><span style="float: left;display:block; margin-right: 5px;">up</span><span
                    style="float: left;display:block; background-color: #33C; color:#fff;width: 10px;text-align:center; margin-right: 5px;">&#8593</span><span
                    style="float: left;display:block; margin-right: 5px;">down</span><span
                    style="float:left; display:block; background-color: #90f; color:#fff;width: 10px; text-align:center;">&#8595</span>
            </td>
            <td>
                <div style="background-color: #ccc; color: #fff; width:auto; margin:auto; float: left; padding: 0 5px;">
                    <strong style="color: #333;">sample size</strong> |
                    <strong style="color: #F00;">frequency in cases</strong> |
                    <strong style="color:#33F;">count in cases</strong>
                </div>
            </td>
            <td><button class="btn btn-default btn-sm" data-container="body" data-toggle="popover"
                        data-content="${g.message(code: 'variant.variantAssociations.pValue.help.text')}"
                        data-trigger="focus">P-value</button>
                <button class="btn btn-default btn-sm" data-container="body" data-toggle="popover"
                        data-content="${g.message(code: 'variant.variantAssociations.MAF.help.text')}"
                        data-trigger="focus">MAF</button>
                <button class="btn btn-default btn-sm" data-container="body" data-toggle="popover"
                        data-content="${g.message(code: 'variant.variantAssociations.effect.help.text')}"
                        data-trigger="focus">Effect</button>
            </td>
        </tr>
    </table>

    <div class="info-box-wrappers">
        <div id="primaryPhenotype" class="col-md-12 t2d-info-box-wrapper"></div>
        <h4><i><g:message code="variant.variantAssociations.otherTraits"
                          default="Other traits with one or more nominally significant associations:"/></i></h4>
        <a id="toggleButton" class="btn btn-primary btn-sm" onClick="toggleOtherAssociations()"><g:message
                code="variant.variantAssociations.expandAssociations" default="expand associations for all traits"/></a>

        <div id="otherTraitsSection" class="col-md-12 other-traits-info-box-wrapper"
             style="display: none; flex-wrap: wrap; padding-left:0; padding-right: 0;">
        </div>
    </div>
</div>

<script id="boxTemplate" type="x-tmpl-mustache">
    <li class=" {{ boxClass }}" style="background-color: {{ backgroundColor }};">
        <h3 style="color: {{ datasetAndPValueTextColor }};">{{ dataset }}</h3>
        <div style="position: absolute; left: 0; bottom: 0; width:100%; display: flex; flex-direction: column; align-items: center">
            <div style="color: {{ datasetAndPValueTextColor }}; padding-top: 2px; padding-bottom: 2px; width: 100%" >
                <span class="p-value">{{ pValueText }}</span>
                <span class="p-value-significance">{{ pValueSignificance }}</span>
            </div>
            <div style="background-color: {{ oddsRatioOrEffectTextBackgroundColor }}; padding-top: 2px; padding-bottom: 2px; width: 100%" >
                <span class="extra-info">{{ oddsRatioOrEffectText }}</span>
            </div>
            <div style="color: white; background-color: #bbb; padding-top: 2px; padding-bottom: 2px; width: 100%; display: flex; justify-content: space-around; align-items: center" >
                <span class="extra-info" style="color: #333;"><strong>{{ count }}</strong></span> | <span class="extra-info" style="color: #f03;"><strong>{{ freqInCases }}</strong></span> | <span class="extra-info" style="color: #30f;"><strong>{{ countInCases }}</strong></span>
            </div>
        </div>
    </li>
</script>

<script id="phenotypeTemplate" type="x-tmpl-mustache">
    <div id="{{ rowId }}" class="info-box-holder {{ rowClass }}" style="border-color: {{ phenotypeColor }};">
        <h3 style="color: {{ phenotypeColor }}">{{ phenotypeName }}</h3>
        <ul></ul>
    </div>
</script>