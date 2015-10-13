<%@ page import="org.broadinstitute.mpg.diabetes.util.PortalConstants" %>
<script>
    function chgRadioButton(buttonLabel) {
        if (buttonLabel === '${PortalConstants.PROTEIN_PREDICTION_EFFECT_MISSENSE_CODE}') {
            $('#missense-options').show();
        } else {
            $('#missense-options').hide();
        }
    }
    ;
</script>

<g:render template="variantWFFeedback"/>

<div class="panel panel-default">

    <div class="panel-body">

        <div class="panel-group" id="accordion">
            <div>

                    <div class="panel-body">

                        <div class="row clearfix" id="clauseCreation" style="display: none">
                            %{--Help the user remember whether they are creating--}%
                            <div class="searchBuilderIntentionSeparator">

                                <div class="col-sm-offset-3 col-sm-6 searchBuilderIntentionBox">
                                    <span class="searchBuilderIntentionPrompt">
                                        <g:message code="searchBuilder.clauseCreation.reminder" default="creating a new data filter" />
                                    </span>
                                </div>
                                <div class="col-sm-3"></div>

                            </div>
                        </div>

                        <div class="row clearfix" id="clauseEdit" style="display: none">
                            %{--Help the user remember whether they are editing or creating--}%
                            <div class="searchBuilderIntentionSeparator">

                                <div class="col-sm-offset-3 col-sm-6 searchBuilderIntentionBox">
                                    <span class="searchBuilderIntentionPrompt">
                                        <g:message code="searchBuilder.clauseEditing.reminder" default="creating a new data filter" />
                                    </span>
                                </div>
                                <div class="col-sm-3"></div>

                            </div>
                        </div>


                        <div class="row clearfix">
                            %{--Here is the phenotype section--}%
                            <div class="primarySectionSeparator">
                                <div class="col-sm-offset-1 col-md-3" style="text-align: right">
                                    <span class="searchBuilderPrompt"><g:message code="searchBuilder.traitOrDisease.prompt" default="trait or disease of interest" /></span>
                                </div>

                                <div class="col-md-5">
                                    <select name="" id="phenotype" class="form-control btn-group btn-input clearfix"
                                            onchange="mpgSoftware.firstResponders.respondToPhenotypeSelection()"
                                            onclick="mpgSoftware.firstResponders.respondToPhenotypeSelection()">
                                        <g:renderPhenotypeOptions/>
                                    </select>

                                </div>

                                <div class="col-md-1">
                                    <g:helpText title="variantSearch.wfRequest.phenotype.help.header" placement="right"
                                                body="variantSearch.wfRequest.phenotype.help.text" qplacer="10px 0 0 0"/>
                                </div>

                                <div class="col-md-2">

                                </div>
                            </div>
                        </div>

                        <div class="row clearfix">
                            %{--Here is the data set section--}%
                            <div class="primarySectionSeparator" id="dataSetChooser" style="display:none">
                                <div class="col-sm-offset-1 col-md-3" style="text-align: right">
                                    <span class="searchBuilderPrompt"><g:message code="searchBuilder.dataset.prompt" default="data set" /></span>
                                </div>

                                <div class="col-md-5">
                                    <select name="" id="dataSet" class="form-control btn-group btn-input clearfix"
                                            onchange="mpgSoftware.firstResponders.respondToDataSetSelection()"
                                            onclick="mpgSoftware.firstResponders.respondToDataSetSelection()">
                                    </select>

                                </span>

                                </div>

                                <div class="col-md-1">
                                    <g:helpText title="variantSearch.wfRequest.dataSet.help.header" placement="right"
                                                body="variantSearch.wfRequest.dataSet.help.text" qplacer="10px 0 0 0"/>
                                </div>

                                <div class="col-md-2">

                                </div>

                            </div>
                        </div>


                        <div id="filterHolder">

                        </div>
                    </div>

            </div>
            <div>

                <a data-toggle="collapse"  data-parent="#accordion" href="#cPropertiesSection"><span id="cPropertyToggleText">Open advanced filtering</span></a>

                <div id="cPropertiesSection" class="panel-collapse collapse">
                    <div class="panel-body">
                        <div class="row clearfix" style="margin:0 0 15px 0">
                            <div class="col-md-1" style="text-align: right"></div>

                            <div class="col-md-5" style="text-align: right">
                                <g:render template="variantRestrictToRegion2"></g:render>
                            </div>

                            <div class="col-md-5" style="text-align: right">
                                <g:render template="variantEffectOnProteins2"></g:render>
                            </div>

                            <div class="col-md-1" style="text-align: right"></div>

                        </div>
                    </div>
                </div>
            </div>
        </div>








        <span class="pull-right">
            <button class="btn btn-med btn-primary variant-filter-button"
                    onclick="mpgSoftware.variantWF.cancelThisFieldCollection()">Cancel</button>
            <button class="btn btn-med btn-primary variant-filter-button"
                    onclick="mpgSoftware.variantWF.gatherFieldsAndPostResults()">Build request &gt;&gt;</button>

        </span>

    </div>
</div>


<script>
    $('#accordion').on('show.bs.collapse', function (e) {
        if (e.target.id === "cPropertiesSection") {
            $("#cPropertyToggleText").text('Close advanced filtering');
        }
    });
    $('#accordion').on('hide.bs.collapse', function (e) {
        if (e.target.id === "cPropertiesSection") {
            $("#cPropertyToggleText").text('Open advanced filtering');        }
    });

</script>