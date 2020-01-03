%{--This file builds the outline of the whole tissue table--}%

<script id="mainTissueTableOrganizer"  type="x-tmpl-mustache">
    <div class="container-fluid" style="padding: 0 2.5%;">


        <div>
            <div class="focus-page-header-wrapper">
                <div class="focus-page-header-header">
                    <div style="width:55%;">Title</div>
                    <div style="width:45%;">Phenotype</div>
                </div>
                <div class="focus-page-header-content">
                    <div class="focus-page-title" style="width:55%;">
                        Tissue FOCUS table
                    </div>
                    <div class="focus-page-title" style="width:45%;"><span class="phenotypeSpecifier">{{phenotype}}</span></div>
                </div>
            </div>
        </div>

        <div class="well well-variant-page focus-table-introduction">
            <g:message code="tissueTable.interface-help1"></g:message>
            <g:helpText title="tissueTable.overall.help.header" placement="bottom" body="tissueTable.help.text"/>
            <g:message code="tissueTable.interface-help2"></g:message></p>
            <p><g:message code="tissueTable.interface-help3"></g:message>
        </div>

        <div class="well well-variant-page">

            <div class="container-fluid">

                <div class="col-md-8" style="padding: 0;" >
                    <h5 style="font-size: 16px; margin-left:15px;">Choose a phenotype</h5>
                    <div class="focus-table-settings-wrapper well well-sm">
                    <div class="focus-table-settings-header">
                            <div style="width:100%;">Phenotype</div>
                        </div>
                        <div class="focus-table-settings-content">
                            <div class="" style="width:100%;">
                                <select id="tissueToPhenotypePicker" class="phenotypePicker form-control input-sm" onchange="mpgSoftware.tissueTable.refreshTableForPhenotype(this)"></select>
                            </div>

                        </div>
                    </div>
                </div>


                <div class="col-md-4" style="padding: 0; padding-left:5px;" >
                    <h5 style="font-size: 16px; margin-left:15px;">Table view control</h5>
                    <div class="datatable-control-box well well-sm" style="width:100%;">
                        <div class="datatable-transpose-control">
                            <div class="tool-label">Transpose table&nbsp;&nbsp;<a style="padding:0; text-decoration:none; color:inherit" class="glyphicon glyphicon-question-sign pop-bottom" data-toggle="popover" role="button" data-trigger="focus" tabindex="0" animation="true" data-container="body" data-placement="bottom" title="" data-html="true" data-content="Click to pivot the table so that rows become columns and columns become rows." data-original-title="Transpose table"></a></div>
                            <button class="btn btn-secondary btn-default transpose" type="button" title="click to transpose table" onclick="mpgSoftware.dynamicUi.transposeThisTable('#mainTissueDiv table.tissueTableHolder','#mainTissueDiv')">
                                Transpose
                            </button>
                        </div>

                        <div class="datatable-zoom-control">
                            <div class="tool-label">Zoom</div>
                            <button type="button" class="btn btn-default btn-secondary" aria-label="Zoom out" title="click to zoom out" onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#mainTissueDiv',false,event)">
                                <span class="glyphicon glyphicon-minus" aria-hidden="true" onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#mainTissueDiv',false,event)"></span>
                            </button>
                            <button type="button" class="btn btn-default btn-secondary" aria-label="Zoom in" title="click to zoom in" onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#mainTissueDiv',true,event)">
                                <span class="glyphicon glyphicon-plus" aria-hidden="true" onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#mainTissueDiv',true,event)"></span>
                            </button>

                        </div>
                    </div>
                </div>

                <div class="col-md-12">
                    <div id="tissueTableHolder" class="mainEffectorDiv">
                        <table class="tissueTableHolder">
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </div>
</script>
