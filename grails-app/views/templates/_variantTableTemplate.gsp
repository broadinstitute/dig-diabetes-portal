
<script id="mainVariantTableOrganizer"  type="x-tmpl-mustache">


<div class="modal fade" id="gregorModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document" style="width: 90%">
    <div class="modal-content" style="height:1000px">
      <div class="modal-header text-center">
        <h4 class="modal-title gregorModalLabel">Adjust GREGOR enrichments</h4>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"
        onclick="mpgSoftware.dynamicUi.filterEpigeneticTable('{{domTableSpecifier}}', undefined, '{{baseDomElement}}')">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div id="gregorSubTableDiv" class="text-center">
            <div class="row pvFilterController">
                <div class="col-md-4 text-right">
                    <label class="form-check-label" for="gregorPValuesCheckbox">
                    Filter by GREGOR p-values
                    </label>
                    <input class="form-check-input" type="radio"  name="preferredQuantityForFiltering" value="" id="gregorPValuesCheckbox"
                    onchange="mpgSoftware.dynamicUi.gregorSubTableVariantTable.deemphasizeOneFilter('div.pvFilterController',['div.feFilterController'])" checked>
                </div>
                <div class="col-md-4">
                    <div class="row">
                        <div class="col-xs-12">
                            <div id="gregorPValueSlider"
                    onclick="mpgSoftware.dynamicUi.gregorSubTableVariantTable.deemphasizeOneFilter('div.pvFilterController',['div.feFilterController'])">
                                <div id="custom-handle" class="ui-slider-handle"></div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xs-3">
                            <div class="gregorPVals minimumGregorPValue text-left"></div>
                        </div>
                        <div class="col-xs-6"></div>
                        <div class="col-xs-3">
                            <div class="gregorPVals maximumGregorPValue text-right"></div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                   <div class="row">
                        <div class="col-xs-12 text-left gregorPVals">
                        Display cells with p-values &lt;
                            <span class="dynamicDisplay"></span>
                        </div>
                        <div class="col-xs-4">
                        </div>
                    </div>
                </div>
            </div>
            <div class="row feFilterController" style="margin-top: 4px; opacity: 0.5">
                <div class="col-md-4 text-right">
                    <label class="form-check-label" for="gregorFoldEnrichmentsCheckbox">
                    Filter by GREGOR fold enrichments
                    </label>
                    <input class="form-check-input" type="radio"  name="preferredQuantityForFiltering" value="" id="gregorFoldEnrichmentsCheckbox"
                    onchange="mpgSoftware.dynamicUi.gregorSubTableVariantTable.deemphasizeOneFilter('div.feFilterController',['div.pvFilterController'])" >
                </div>
                <div class="col-md-4">
                    <div class="row">
                        <div class="col-xs-12">
                            <div id="gregorFEValueSlider"
                    onclick="mpgSoftware.dynamicUi.gregorSubTableVariantTable.deemphasizeOneFilter('div.feFilterController',['div.pvFilterController'])">
                                <div id="custom-fe-handle" class="ui-slider-handle"></div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xs-3">
                            <div class="gregorPVals minimumGregorFEValue text-left"></div>
                        </div>
                        <div class="col-xs-6"></div>
                        <div class="col-xs-3">
                            <div class="gregorPVals maximumGregorFEValue text-right"></div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="row">
                        <div class="col-xs-12 text-left gregorPVals">
                            <div>Display cells with fold enrichments &gt; <span class="dynamicFEDisplay"></span></div>
                        </div>
                    </div>
                </div>
            </div>

            <table class="gregorSubTable table responsive" style="font-size: 11px">
            </table>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal"
        onclick="mpgSoftware.dynamicUi.filterEpigeneticTable('{{domTableSpecifier}}',undefined,'{{baseDomElement}}')">Close</button>
      </div>
    </div>
  </div>
</div>



    {{#displayIndependentRangeControl}}
    <div class="container-fluid">
        <div class="row">
            <div class="text-center">
                <h1 class="dk-page-title">Variant FOCUS table for <span class="phenotypeSpecifier">{{phenotype}}</span></h1>
            </div>
        </div>
        <div  style="font-size: 16px;">
            <p><g:message code="variantTable.introduction.1"></g:message><g:message code="variantTable.introduction.2"></g:message>
                <g:helpText title="variantTable.overall.help.header" placement="bottom" body="variantTable.help.text"/>

                <g:message code="variantTable.introduction.3"></g:message></p>
        </div>


        <div class="row" style="margin: 20px">
            <div class="col-sm-2 text-center" style="">
                <label style="padding-top:35px">Change genomic region or phenotype</label>
            </div>
            <div class="col-sm-8" style="border: 1px solid black; max-width: 730px">
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
                        <select id="variantTablePhenotypePicker" class="phenotypePicker" onchange="mpgSoftware.variantTable.refreshTableForPhenotype(this)"></select>
                    </div>
                    <div class="col-md-2">
                        <button class="btn btn-secondary btn-default transpose" type="button" title="click to update table"
                        onclick="mpgSoftware.variantTable.refreshTableForPhenotype('#variantTablePhenotypePicker')">
                        Update</button>
                    </div>
                </div>

            </div>
        </div>
        {{/displayIndependentRangeControl}}
        {{^displayIndependentRangeControl}}
%{--        create these dom elements, which will never be displayed, only for the purpose letting the calling code know the phenotype.  Necessary because sometimes the pages stand alone, and needs to manage its own phenotype,--}%
%{--        but other times the table sits in a larger page which will handle the phenotype choices.--}%
        <div class="neverDisplay" style="display: none">
        <ul>
        <li class="chosenPhenotype" id="{{phenotype}}">
        </ul>
        </div>
        {{/displayIndependentRangeControl}}

                <div class="container-fluid">
                    <div class="col-md-6">
                        <h5 style="font-size: 16px;">Table filter</h5>
                        <div class="well well-sm row" style="border-top-right-radius: 0; border-bottom-right-radius: 0; border-right: none;">
                            <div class="col-md-12" style="border-bottom:0.5px solid #ccc">
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
                    </div>

                    <div class="col-md-3">
                        <h5 style="font-size: 16px; margin-left:15px;"></h5>
                        <div class="well well-sm row" style="margin-top: 37px; height: 88.5px; border-top-left-radius: 0; border-bottom-left-radius: 0; border-left: none;">

                            <div class="datatable-zoom-control">
                                <div class="tool-label">Order by</div>

                                <button  class="btn btn-secondary btn-default transpose" type="button" title="click to order by method" onclick="mpgSoftware.dynamicUi.displayVariantTablePerTissue('{{domTableSpecifier}}', false)">
                                        Annotation
                                      </button>

                                <button  class="btn btn-secondary btn-default transpose" type="button" title="click to order by tissue" onclick="mpgSoftware.dynamicUi.displayVariantTablePerTissue('{{domTableSpecifier}}', true)">
                                    Tissue
                                  </button>


                            </div>

                            <div class="datatable-zoom-control">
                                <div class="variantTableFilterChoice">
                                    <div class="tool-label">Display</div>
                                    <label class="form-check-label" for="displayBlankRows">
                                    Blank rows&nbsp;&nbsp;
                                    </label>
                                    <input class="form-check-input" type="checkbox" value="" id="displayBlankRows" checked>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-3">

                        <h5 style="font-size: 16px; margin-left:15px;">Table view control</h5>
                        <div class="well well-sm row" style="margin-left: 2px; height: 88.5px;">
                            <div class="datatable-zoom-control">
                                <div class="tool-label">Direction</div>
                                <button  class="btn btn-secondary btn-default transpose actualTransposeButton" type="button" title="click to transpose table" onclick="mpgSoftware.dynamicUi.transposeThisTable('{{domTableSpecifier}}','{{baseDomElement}}')">
                                Transpose
                              </button>
                            </div>

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

        <div class="row" >
            <div class="col-md-8">
                <div class="row">
                    <div class="col-md-3">

                    </div>

                    <div class="col-md-3 text-right">

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
    </div>
</script>
