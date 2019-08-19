
<script id="mainVariantTableOrganizer"  type="x-tmpl-mustache">
    <div class="container">
        <div class="row">
            <div class="text-center">
                <h1 class="dk-page-title">Variant enrichments for <span class="phenotypeSpecifier">{{phenotype}}</span></h1>
            </div>
        </div>
        <p><g:message code="tissueTable.interface-help1"></g:message>
<g:helpText title="tissueTable.overall.help.header" placement="bottom" body="tissueTable.help.text"/>
<g:message code="tissueTable.interface-help2"></g:message></p>
<p><g:message code="tissueTable.interface-help3"></g:message></p>
        <div class="row">
            <div class="col-sm-12">
                <div class="datatable-control-box">
                    <div class="datatable-transpose-control">
                        <div class="tool-label">Transpose table&nbsp;&nbsp;<a style="padding:0; text-decoration:none; color:inherit" class="glyphicon glyphicon-question-sign pop-bottom" data-toggle="popover" role="button" data-trigger="focus" tabindex="0" animation="true" data-container="body" data-placement="bottom" title="" data-html="true" data-content="Click to pivot the table so that rows become columns and columns become rows." data-original-title="Transpose table"></a></div>
                        <button class="btn btn-secondary btn-default transpose" type="button" title="click to transpose table" onclick="mpgSoftware.dynamicUi.transposeThisTable('{{domTableSpecifier}}')">
                            Transpose
                        </button>
                    </div>

                    <div class="datatable-zoom-control">
                        <div class="tool-label">Zoom</div>
                        <button type="button" class="btn btn-default btn-secondary" aria-label="Zoom out" title="click to zoom out" onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('{{organizingDiv}}',false,event)">
                            <span class="glyphicon glyphicon-minus" aria-hidden="true" onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#mainTissueDiv',false,event)"></span>
                        </button>
                        <button type="button" class="btn btn-default btn-secondary" aria-label="Zoom in" title="click to zoom in" onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('{{organizingDiv}}',true,event)">
                            <span class="glyphicon glyphicon-plus" aria-hidden="true" onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#mainTissueDiv',true,event)"></span>
                        </button>

                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="row">
                    <div class="col-md-12">
                        <label for="tissueToPhenotypePicker">Choose a phenotype</label>
                        <select id="tissueToPhenotypePicker" class="phenotypePicker" onchange="mpgSoftware.tissueTable.refreshTableForPhenotype(this)">
                        </select>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div id="mainVariantDiv">
                    <table class="variantTableHolder">
                    </table>
                </div>
            </div>
        </div>
    </div>
</script>
