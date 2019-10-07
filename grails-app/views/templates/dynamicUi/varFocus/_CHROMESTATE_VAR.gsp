<script id="chromStateVariantTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="chromStateVariantTableTissueHeaderLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varChromHmmEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}">Epigenetics</div>
</script>

<script id="chromStateVariantTableTissueRowLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varChromHmmEpigenetics variantEpigenetics staticMethodLabels methodName_ChromHMM initialLinearIndex_{{indexInOneDimensionalArray}}">ChromHMM&nbsp;<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/></div>
</script>

<script id="chromStateVariantTableTissueHeader"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varChromHmmEpigenetics initialLinearIndex_{{initialLinearIndex}}">{{tissueName}}</div>
</script>

<script id="chromStateVariantTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{significanceValueAsString}}
</script>

<script id="chromStateVariantTableBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField="{{significanceValue}}"
             class="varAllEpigenetics varChromHmmEpigenetics chromState tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'Chromatin state predictions for {{tissueName}}',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander"
               data-target="#chromState_tissue_{{tissueNameKey}}" style="color:black">tissues
               </a>

               <div  class="collapse openEffectorGeneInformationInGeneTable" id="chromState_tissue_{{tissueNameKey}}">
                    {{#recordsExist}}
                        <table class="expandableDrillDownTable openEffectorGeneInformationInGeneTable" style="margin: 0 auto">
                         <thead>
                          <tr role="row">
                            <th class="text-center leftMostCol">Tissue</th>
                            <th class="text-center otherCols">Annotation</th>
                          </tr>
                         </thead>
                         <tbody>
                     {{/recordsExist}}
                         {{#tissueRecords}}
                          <tr class="epigeneticCellElement tissueId_{{safeTissueId}} annotationName_{{annotation}}" role="row">
                               <td class="text-center leftMostCol">{{tissue_name}}</td>
                               <td class="text-center otherCols">{{annotation}}</td>
                           </tr>
                          {{/tissueRecords}}
                      {{#recordsExist}}
                         </tbody>
                        </table>
                    {{/recordsExist}}
                    {{#recordsExist}}
                    {{/recordsExist}}
                    {{^recordsExist}}
                       No predicted connections
                    {{/recordsExist}}
               </div>
            </div>
</script>
