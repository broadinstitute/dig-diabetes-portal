
<script id="mainVariantTableOrganizer"  type="x-tmpl-mustache">
    <div class="container">
        <div class="row">
            <div class="text-center">
                <h1 class="dk-page-title">Variant FOCUS table for <span class="phenotypeSpecifier">{{phenotype}}</span></h1>
            </div>
        </div>
        <p><g:message code="variantTable.introduction.1"></g:message><g:message code="variantTable.introduction.2"></g:message>
<g:helpText title="variantTable.overall.help.header" placement="bottom" body="variantTable.help.text"/>

<g:message code="variantTable.introduction.3"></g:message></p>
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
                        <button class="btn btn-secondary btn-default transpose" type="button" title="click to update table"
                        onclick="mpgSoftware.variantTable.refreshTableForPhenotype('#variantTablePhenotypePicker')">
                        Update</button>
                    </div>
                </div>
            </div>
            <div class="col-sm-2"></div>
        </div>
        <div class="row" >
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
        onclick="mpgSoftware.dynamicUi.filterEpigeneticTable('{{domTableSpecifier}}')">Close</button>
%{--        onclick="mpgSoftware.dynamicUi.reviseDisplayOfVariantTable('{{domTableSpecifier}}',2,'')">Close</button>--}%
      </div>
    </div>
  </div>
</div>
                <div class="row">
                    <div class="col-md-8" style="border:0.5px solid #eee">
                        <div class="row" style="border-bottom:0.5px solid #ccc">
                            <div class="col-md-4">
                                 <div class="variantTableFilterChoice">
                                    <input class="form-check-input" type="radio"  name="preferredAnnotationFiltering" value="" id="gregorFilterCheckbox" checked>
                                    <label class="form-check-label" for="gregorFilterCheckbox">
                                    GREGOR filter
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-8">
                                <div class="variantTableFilterChoice">
                                    <button id="adjustFilterTableButton"  class="btn  btn-link" type="button"  data-toggle="modal" data-target="#gregorModal" onclick="$('#gregorFilterCheckbox').prop('checked',true)">
                                    Adjust filters from GREGOR enrichment
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <div class="variantTableFilterChoice">
                                    <input class="form-check-input" type="radio" name="preferredAnnotationFiltering" value="" id="methodFilterCheckbox">
                                    <label class="form-check-label" for="methodFilterCheckbox">
                                    Choose desired methods
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-8">
                                <div class="variantTableFilterChoice">
                                     <span style="display: inline-block; float: none; vertical-align: middle; width: 100%">
                                        <label class="specifyAnnotationsText" for="annotationSelectorChoice">Specify annotations explicitly:</label>
                                        <g:helpText title="tissue.selection.help.header" placement="top" body="tissue.selection.help.text"/>
                                         <select id="annotationSelectorChoice" multiple="multiple">
                                        </select>
                                     </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="row" >
                            <div class="col-md-6"></div>
                            <div class="col-md-6">
                              <button  class="btn btn-secondary btn-default transpose" type="button" title="click to transpose table" onclick="mpgSoftware.dynamicUi.transposeThisTable('{{domTableSpecifier}}')">
                                Transpose
                              </button>
                            </div>
                        </div>
                        <div class="row" >
                            <div class="col-md-offset-6 col-md-6">
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
                    </div>
                </div>

        <div class="row" >
            <div class="col-md-8">
                <div class="row">
                    <div class="col-md-9">

                    </div>
                    <div class="col-md-3 text-right">
                        <div class="variantTableFilterChoice">
                            <label class="form-check-label" for="displayBlankRows">
                            Display blank rows&nbsp;&nbsp;
                            </label>
                            <input class="form-check-input" type="checkbox" value="" id="displayBlankRows" checked>
                        </div>
                    </div>
                </div>

            </div>
            <div class="col-md-4">

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
