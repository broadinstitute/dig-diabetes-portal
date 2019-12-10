<script id="tfMotifVariantTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="tfMotifVariantTableTissueHeaderLabel"  type="x-tmpl-mustache">
<div class="annotationLabel variantAnnotationCompress variantAnnotation variantHasMotifOverlap variantEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}">Epigenetics</div>
</script>

<script id="tfMotifVariantTableTissueRowLabel"  type="x-tmpl-mustache">
<div class="variantAnnotationCompress variantHasMotifOverlap staticValuesLabelInTissueTable initialLinearIndex_{{indexInOneDimensionalArray}}  {{isBlank}}"
 sortField=7>
TF motif overlap&nbsp;<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/></div>
</script>

<script id="tfMotifVariantTableTissueHeader"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varTfMotifEpigenetics  initialLinearIndex_{{initialLinearIndex}}">{{tissueName}}</div>
</script>

<script id="tfMotifVariantTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{significanceValueAsString}}No div!
</script>

<script id="tfMotifVariantTableBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField="{{significanceValue}}"
             class="varAllEpigenetics varTfMotifEpigenetics tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}} text-center">

                <div>
               {{#tissueRecords}}

               {{/tissueRecords}}
               </div>
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'TF binding motifs overlapping {{var_id}}',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander"
               data-target="#tf_motif_{{tissueName}}" style="color:blue">motifs
               </a>

                <div  class="collapse openEffectorGeneInformationInGeneTable" id="tf_motif_{{tissueName}}">
                    {{#recordsExist}}
                        <table class="expandableDrillDownTable openEffectorGeneInformationInGeneTable" style="margin: 0 auto">
                         <thead>
                          <tr role="row">
                            <th class="text-center leftMostCol">TF</th>
                            <th class="text-center otherCols">Position</th>
                            <th class="text-center otherCols">ref score</th>
                            <th class="text-center otherCols">alt score</th>
                            <th class="text-center otherCols">delta</th>
                          </tr>
                         </thead>
                         <tbody>
                     {{/recordsExist}}
                         {{#tissueRecords}}
                         <div class="annotationName_{{annotation}}">
                          <tr role="row">
                               <td class="leftMostCol"">{{annotation}}</td>
                               <td class="text-center otherCols">{{position}}</td>
                               <td class="text-center otherCols">{{ref_scorepp}}</td>
                               <td class="text-center otherCols">{{alt_scorepp}}</td>
                               <td class="text-center otherCols">{{deltapp}}</td>
                           </tr>
                            </div>
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

<script id="tfMotifVariantTableBodyTissueSpecific"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField="{{significanceValue}}"
             class="varAllEpigenetics varTfMotifEpigenetics tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}} text-center">

                <div>
               {{#tissueRecords}}

               {{/tissueRecords}}
               </div>
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'TF binding motifs overlapping {{var_id}}',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander"
               data-target="#tf_motif_{{tissueName}}" style="color:blue">motifs
               </a>

                <div  class="collapse openEffectorGeneInformationInGeneTable" id="tf_motif_{{tissueName}}">
                    {{#recordsExist}}
                        <table class="expandableDrillDownTable openEffectorGeneInformationInGeneTable" style="margin: 0 auto">
                         <thead>
                          <tr role="row">
                            <th class="text-center leftMostCol">TF</th>
                            <th class="text-center otherCols">Position</th>
                            <th class="text-center otherCols">ref score</th>
                            <th class="text-center otherCols">alt score</th>
                            <th class="text-center otherCols">delta</th>
                          </tr>
                         </thead>
                         <tbody>
                     {{/recordsExist}}
                         {{#tissueRecords}}
                         <div class="annotationName_{{annotation}}">
                          <tr role="row">
                               <td class="leftMostCol"">{{annotation}}</td>
                               <td class="text-center otherCols">{{position}}</td>
                               <td class="text-center otherCols">{{ref_scorepp}}</td>
                               <td class="text-center otherCols">{{alt_scorepp}}</td>
                               <td class="text-center otherCols">{{deltapp}}</td>
                           </tr>
                            </div>
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
