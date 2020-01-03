<script id="geneFocusTable"  type="x-tmpl-mustache">
{{#dynamicUiTab}}
<div class="row" style="border: none; {{suppressionOfRange}}">
    <div id="configurableUiTabStorage" style="display: none"></div>
    <div class="col-sm-12">
        Current context:
    </div>
    <div class="col-sm-6">
        <div class="contextHolder">
            <div id="contextDescription">

            </div>
        </div>
    </div>
    <div class="col-sm-4">
        <button class="btn btn-secondary" type="button" data-toggle="collapse" data-target="#collapseContextRefiner" aria-expanded="false" aria-controls="collapseContextRefiner">
            Refine context
        </button>
        <div class="collapse" id="collapseContextRefiner">
            <div  style="margin-top: 10px">
                <div class="card card-body">
                    <div id="contextControllersInDynamicUi">

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-sm-2 text-right">
        <button class="btn btn-secondary" type="button" onclick="$('#retrieveMultipleRecordsTest').click()" aria-controls="collapseContextRefiner">
            Refresh table
        </button>
    </div>
</div>

<div class="row" style="border: none; {{suppressionOfAllDynamicUiTabs}}">
    <div class="col-sm-12">
        <ul class="nav nav-tabs">
            <li class="nav-item active" style="{{suppressionOfGeneTable}}">
                <a class="nav-link sub-tab" href="#dynamicGeneHolder" role="tab" data-toggle="tab">Gene</a>
            </li>
            <li class="nav-item" style="{{suppressionOfVariantTable}}">
                <a class="nav-link sub-tab" href="#dynamicVariantHolder" role="tab" data-toggle="tab">Variant</a>
            </li>
            <li class="nav-item"  style="display: none">
                <a class="nav-link sub-tab" href="#dynamicTissueHolder" role="tab" data-toggle="tab">Tissue</a>
            </li>
            <li class="nav-item"  style="display: none">
                <a class="nav-link sub-tab" href="#dynamicPhenotypeHolder" role="tab" data-toggle="tab">Phenotype</a>
            </li>
        </ul>
    </div>
</div>

<div class="">
    <div role="tabpanel" class="" id="dynamicGeneHolder">

        <div class="">
            <div class="col-sm-12">

                <div class="row">
                    <div class="col-sm-12">
                        <div class="directorButtonHolder">

                        </div>
                    </div>
                </div>

                <div style="font-size: 16px;"><p><g:message code="GenePrioritization.interface.help1"></g:message>
                <g:helpText title="gene.overall.help.header" placement="bottom" body="gene.overall.help.text"/>
                    <g:message code="GenePrioritization.interface.help2"></g:message></p>


                </div>

                <div class="row">
                    <div class="col-sm-12">
                        <div class="datatable-control-box">
                            <div class="datatable-transpose-control">
                                <div class="tool-label">Transpose table&nbsp;&nbsp;<g:helpText title="table.transpose.help.header" placement="bottom" body="table.transpose.help.text"/></div>
                                <button class="btn btn-secondary btn-default transpose" type="button" title="click to transpose table"
                                        onclick = "mpgSoftware.dynamicUi.transposeThisTable('table.combinedGeneTableHolder','#configurableUiTabStorage')">
                                    Transpose
                                </button>
                            </div>
                            <div class="datatable-cell-color-control">
                                <div class="tool-label">View:</div>


                                <button type="button" class="btn btn-secondary first-btn significance active" aria-label="click to organize by greatest significance"
                                        title="click to organize by greatest significance" onclick="mpgSoftware.dynamicUi.setColorButtonActive(event,['tissues'],'table.combinedGeneTableHolder','#configurableUiTabStorage');">Significance
                                </button>

                                <button type="button" class="btn btn-secondary last-btn tissues" aria-label="click to organized by number of associated tissues"
                                        title="click to organized by number of associated tissues" onclick="mpgSoftware.dynamicUi.setColorButtonActive(event,['significance'],'table.combinedGeneTableHolder','#configurableUiTabStorage');">Records

                                </button>
                            </div>


                            <div class="datatable-zoom-control">
                                <div class="tool-label">Zoom</div>
                                <button type="button" class="btn btn-default btn-secondary" aria-label="Zoom out"  title="click to zoom out"
                                        onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#dynamicGeneHolder',false,event)">
                                    <span class="glyphicon glyphicon-minus" aria-hidden="true"
                                          onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#dynamicGeneHolder',false,event)"></span>
                                </button>
                                <button type="button" class="btn btn-default btn-secondary" aria-label="Zoom in"  title="click to zoom in"
                                        onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#dynamicGeneHolder',true,event)">
                                    <span class="glyphicon glyphicon-plus" aria-hidden="true"
                                          onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#dynamicGeneHolder',true,event)"></span>
                                </button>

                            </div>
                        </div>
                    </div>
                </div>
                <table class="combinedGeneTableHolder">
                </table>

            </div>
        </div>
    </div>
    <div role="tabpanel" class="tab-pane" id="dynamicVariantHolder">

        <div class="row" style="display:none">
            <div class="col-sm-12 sub-content">
                <div class="directorButtonHolder">

                </div>

            </div>
        </div>

        <div class="row">
            <div class="col-sm-12">

                <table class="combinedVariantTableHolder" style="border:0">
                </table>
            </div>
        </div>


    </div>
    <div role="tabpanel" class="tab-pane" id="dynamicTissueHolder" style="display: none">

        <div class="row">
            <div class="col-sm-12 sub-content">
                <h3>Tissue director</h3>
                <div class="directorButtonHolder">

                </div>
                <h3> Results </h3>
                <div class="resultsTableHolder">
                    <div class="dynamicUiHolder">
                    </div>
                </div>

            </div>
        </div>
    </div>
    <div role="tabpanel" class="tab-pane " id="dynamicPhenotypeHolder"  style="display: none">

        <div class="row">
            <div class="col-sm-12 sub-content">
                <h3>Phenotype director</h3>
                <div class="directorButtonHolder">

                </div>
                <h3> Results </h3>
                <div class="resultsTableHolder">
                    <div class="dynamicUiHolder">
                    </div>
                </div>

            </div>
        </div>

    </div>
</div>

{{/dynamicUiTab}}
</script>