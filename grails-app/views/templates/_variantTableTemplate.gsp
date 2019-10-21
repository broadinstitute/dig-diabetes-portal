
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
        <div class="row" style="margin: 20px">
            <div class="col-sm-2 text-center" style="">
                <label style="padding-top:35px">Change genomic region or phenotype</label>
            </div>
            <div class="col-sm-8" style="border: 1px solid black">
                <div class="row">
                    <div class="col-sm-1 text-center"></div>
                    <div class="col-sm-2 text-center">
                        <label for="chromosomeInput" placeholder="Choose chromosome">chromosome</label>
                        <input id="chromosomeInput" type="text" size="8">
                    </div>
                    <div class="col-sm-1 text-center"></div>
                    <div class="col-sm-4 text-center">
                        <label for="startExtentInput" placeholder="Choose chromosome">start extent</label>
                        <input id="startExtentInput" type="text">
                    </div>
                    <div class="col-sm-4 text-center">
                        <label for="endExtentInput" placeholder="Choose chromosome">end extent</label>
                        <input id="endExtentInput" type="text">
                    </div>
                </div>
                <div class="row" style="margin-top: 15px">
                    <div class="col-md-10">
                        <label for="variantTablePhenotypePicker">Phenotype</label>
                        <select id="varishiftantTablePhenotypePicker" class="phenotypePicker" onchange="mpgSoftware.variantTable.refreshTableForPhenotype(this)"></select>
                    </div>
                                        <div class="col-md-2">
                        <button class="btn btn-secondary btn-default transpose" type="button" title="click to transpose table"
                        onclick="mpgSoftware.variantTable.refreshTableForPhenotype('#variantTablePhenotypePicker')">
                        Update</button>
                    </div>
                </div>
                %{--<div class="row" style="margin-top: 11px">--}%
                    %{--<div class="col-md-10">--}%
                    %{--</div>--}%
                    %{--<div class="col-md-2">--}%
                        %{--<button class="btn btn-secondary btn-default transpose" type="button" title="click to transpose table"--}%
                        %{--onclick="mpgSoftware.variantTable.refreshTableForPhenotype('#variantTablePhenotypePicker')">--}%
                        %{--Update</button>--}%
                    %{--</div>--}%
                %{--</div>--}%
            </div>
            <div class="col-sm-2"></div>
        </div>
        <div class="row" >
            %{--<div class="col-md-12">--}%
                %{--<div class="row">--}%
                    %{--<div class="col-md-8">--}%
                            %{--<label for="tissueToPhenotypePicker">Choose a phenotype</label>--}%
                            %{--<select id="tissueToPhenotypePicker" class="phenotypePicker" onchange="mpgSoftware.tissueTable.refreshTableForPhenotype(this)">--}%
                            %{--</select>--}%
                    %{--</div>--}%
                    %{--<div class="col-md-4"></div>--}%
                %{--</div>--}%
            %{--</div>--}%
        </div>

<div class="modal fade" id="gregorModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document" style="width: 90%">
    <div class="modal-content">
      <div class="modal-header text-center">
        <h5 class="modal-title" id="exampleModalLabel">GREGOR enrichments</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div id="gregorSubTableDiv" class="text-center">
            <div class="row">
                <div class="col-md-4"></div>
                <div class="col-md-4">
                    <div class="row">
                        <div class="col-xs-12">
                            <div id="gregorPValueSlider">
                                <div id="custom-handle" class="ui-slider-handle"></div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xs-3">
                            <div class="gregorPVals minimumGregorPValue left-text"></div>
                        </div>
                        <div class="col-xs-6"></div>
                        <div class="col-xs-3">
                            <div class="gregorPVals maximumGregorPValue right-text"></div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xs-4">
                        </div>
                        <div class="col-xs-4">
                            <div>Current value:</div>
                            <div class="gregorPVals dynamicDisplay"></div>
                        </div>
                        <div class="col-xs-4">
                        </div>
                    </div>
                </div>
                <div class="col-md-4"></div>
            </div>
            <table class="gregorSubTable">
            </table>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal"
        onclick="mpgSoftware.dynamicUi.reviseDisplayOfVariantTable('{{domTableSpecifier}}',2,'')">Close</button>
      </div>
    </div>
  </div>
</div>
                <div class="row">
                    <div class="col-md-4"></div>
                    <div class="col-md-4">
                          <button id="adjustFilterTableButton"  class="btn btn-primary btn-default" type="button"  data-toggle="modal" data-target="#gregorModal">
                            Adjust filters from GREGOR enrichment
                          </button>
                    </div>
                    <div class="col-md-4">
                        <span class="tool-label" style="z-index: 20">Epigenetic data&nbsp;&nbsp;
                            <a style="padding:0; text-decoration:none; color:inherit" class="glyphicon glyphicon-question-sign pop-bottom"
                            data-toggle="popover" role="button" data-trigger="focus" tabindex="0" animation="true" data-container="body"
                            data-placement="bottom" title="" data-html="true"
                            data-content="Click to toggle epigenetic data display." data-original-title="Transpose table"></a>
                        </span>
                        <button class="btn btn-secondary btn-default transpose" type="button" title="click to transpose table"
                        onclick="mpgSoftware.dynamicUi.reviseDisplayOfVariantTable('{{domTableSpecifier}}',1,this)">
                        Display
                        </button>
                          <button  class="btn btn-secondary btn-default transpose" type="button" title="click to transpose table" onclick="mpgSoftware.dynamicUi.transposeThisTable('{{domTableSpecifier}}')">
                            Transpose
                          </button>



                    </div>
                </div>
        <div class="row" >
        <div class="col-md-9"></div>
        <div class="col-md-3">
                            <div class="datatable-zoom-control">
                        <div class="tool-label">Zoom</div>
                        <button type="button" class="btn btn-default btn-secondary" aria-label="Zoom out" title="click to zoom out" onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('{{organizingDiv}}',false,event)">
                            <span class="glyphicon glyphicon-minus" aria-hidden="true" onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#mainVariantDiv',false,event)"></span>
                        </button>
                        <button type="button" class="btn btn-default btn-secondary" aria-label="Zoom in" title="click to zoom in" onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('{{organizingDiv}}',true,event)">
                            <span class="glyphicon glyphicon-plus" aria-hidden="true" onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#mainVariantDiv',true,event)"></span>
                        </button>

                    </div>
        </div>
        </div>
        <div class="row" >
            <div class="col-md-12" style="margin-top:60px">

                <div id="mainVariantDiv">
                    <table class="variantTableHolder">
                    </table>
                </div>
            </div>
        </div>
    </div>
</script>
