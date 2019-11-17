<script id="coaccessibilityVariantTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="coaccessibilityVariantTableTissueHeaderLabel"  type="x-tmpl-mustache">
<div class="varEpigeneticsLabel varAllEpigenetics varCoaccessibilityEpigenetics variantEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}">Epigenetics</div>
</script>

<script id="coaccessibilityVariantTableTissueRowLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varCoaccessibilityEpigenetics staticMethodLabels annotationName_GenePrediction methodName_cicero  {{isBlank}} initialLinearIndex_{{indexInOneDimensionalArray}} varAnnotation"
 sortField=0>
coaccessibility&nbsp;<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/></div>
</script>

<script id="coaccessibilityVariantTableTissueSpecificHeaderLabel"  type="x-tmpl-mustache">
<div class="varEpigeneticsLabel varTissueEpigenetics varAllEpigenetics varCoaccessibilityEpigenetics variantEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}">coaccessibility</div>
</script>


<script id="coaccessibilityVariantTableTissueSpecificRowLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varCoaccessibilityEpigenetics staticMethodLabels annotationName_GenePrediction methodName_cicero  {{isBlank}} initialLinearIndex_{{indexInOneDimensionalArray}} varAnnotation"
 sortField=0>
{{tissue_name}}</div>
</script>

<script id="coaccessibilityVariantTableTissueHeader"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varCoaccessibilityEpigenetics initialLinearIndex_{{initialLinearIndex}}">{{tissueName}}</div>
</script>

<script id="coaccessibilityVariantTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{significanceValueAsString}}
</script>



<script id="coaccessibilityVariantTableBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField="{{significanceValue}}"
             class="varAllEpigenetics varCoaccessibilityEpigenetics tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
                <div>
               {{#tissueRecords}}
                  <div class="epigeneticCellElement tissueId_{{safeTissueId}} annotationName_{{annotation}}">
                    {{tissue_name}}
                  </div>
               {{/tissueRecords}}
               </div>
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'coaccessibility predictions for {{tissueName}}',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander"
               data-target="#depict_coaccessibility_{{tissueNameKey}}" style="color:black">all tissues&gt;&gt;
               </a>

               <div  class="collapse openEffectorGeneInformationInGeneTable" id="depict_coaccessibility_{{tissueNameKey}}">
                    {{#recordsExist}}
                        <table class="expandableDrillDownTable openEffectorGeneInformationInGeneTable" style="margin: 0 auto">
                         <thead>
                          <tr role="row">
                            <th class="text-center leftMostCol">Gene</th>
                            <th class="text-center otherCols">Tissue</th>
                            <th class="text-center otherCols">Value</th>
                          </tr>
                         </thead>
                         <tbody>
                     {{/recordsExist}}
                         {{#tissueRecords}}
                          <tr role="row">
                               <td class="leftMostCol"">{{gene_id}}</td>
                               <td class="text-center otherCols">{{tissue_name}}</td>
                               <td class="text-center otherCols">{{score}}</td>
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
