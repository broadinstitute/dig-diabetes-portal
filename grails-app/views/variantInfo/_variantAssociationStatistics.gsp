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
    %{--if (${portalVersionBean.getExposeGreenBoxes()}){--}%
        %{--$("#containerForGreenBoxHolder").empty().append(--}%
            %{--Mustache.render( $('#greenBoxHolderTemplate')[0].innerHTML));--}%
    %{--}--}%
    %{--if (${portalVersionBean.getExposePhewasModule()}){--}%
        %{--$("#containerForPhewasHolder").empty().append(--}%
            %{--Mustache.render( $('#pheWASHolderTemplate')[0].innerHTML));--}%
    %{--}--}%
    mpgSoftware.variantInfo.storeVarInfoData({  'exposeGreenBoxes':'${portalVersionBean.getExposeGreenBoxes()}',
                                                'exposePhewasModule':'${portalVersionBean.getExposePhewasModule()}'});
    mpgSoftware.variantInfo.retrieveVariantPhenotypeData(phenotypeDatasetMapping,
            variantId,
            variantAssociationStrings,
            '${createLink(controller:'variantInfo',action: 'variantDescriptiveStatistics')}',
            '${g.defaultPhenotype()}');

    $(window).load( function() {
        mpgSoftware.associationStatistics.buildDynamicPage();
    });

</script>

<g:if test="${portalVersionBean.getExposePhewasModule()}">
    <p><g:message code="variant.PheWAShelp1a"></g:message>
        %{--<g:message code="variant.PheWAShelp1b"></g:message>--}%
    </p>
    <p><g:message code="variant.PheWAShelp2"></g:message></p>
</g:if>


<g:if test="${portalVersionBean.getExposeTraitDataSetAssociationView()}">

</g:if>
<g:else>
    <style>
    .phenotype-searchbox-wrapper {
        display: none;
    }
    #pheplot {
        display: none;
    }
    </style>
</g:else>

<g:if test="${portalVersionBean.getExposeGreenBoxes()}">


%{--<script id="greenBoxHolderTemplate" type="x-tmpl-mustache">--}%
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
</g:if>
%{--</script>--}%

<div id="pheWASGraphicsGoHere">

</div>


<g:if test="${portalVersionBean.getExposePhewasModule()}">
    <div class="container content-wrapper">
        <div id="phewas">
            <div class="text-right">
                <input id="phewasAllDatasets" type="checkbox">%{--onClick generalizedInitLocusZoom added later--}%
                <label for="phewasAllDatasets">Include all datasets</label></div>
        </div>
        <div id="plot"></div>
    </div>
    </div>
</g:if>

<g:if test="${portalVersionBean.getExposeForestPlot()}">
    <div class="container content-wrapper">
        <div id="forestPlot"></div>
    </div>
    </div>
</g:if>

