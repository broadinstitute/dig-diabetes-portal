<script id="tfbsVariantTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="tfbsVariantTableTissueHeaderLabel"  type="x-tmpl-mustache">
<div class="varEpigeneticsLabel varAllEpigenetics varTfbsEpigenetics variantEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}">Epigenetics</div>
</script>

<script id="tfbsVariantTableTissueRowLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varTfbsEpigenetics  staticMethodLabels methodName_SPP  initialLinearIndex_{{indexInOneDimensionalArray}}">
tfbs&nbsp;<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/></div>
</script>

<script id="tfbsVariantTableTissueHeader"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varTfbsEpigenetics  initialLinearIndex_{{initialLinearIndex}}">{{tissueName}}</div>
</script>

<script id="tfbsVariantTableIndividualAnnotationLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varTfbsEpigenetics staticMethodLabels annotationName_SPP methodName_SPP initialLinearIndex_{{indexInOneDimensionalArray}} varAnnotation {{isBlank}}">
<div style="font-weight: bold">TFBS</div>
{{annotationName}}</div>
</script>

<script id="tfbsVariantTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{significanceValueAsString}}No div!
</script>

<script id="tfbsVariantTableBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField="{{significanceValue}}"
             class="varAllEpigenetics varTfbsEpigenetics tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">

                    {{#recordsExist}}

                     {{/recordsExist}}
                         {{#tissueRecords}}
 <div class="epigeneticCellElement tissueId_{{safeTissueId}} annotationName_{{annotation}}">
                               {{tissue_name}}
                            </div>
                          {{/tissueRecords}}
                      {{#recordsExist}}

                    {{/recordsExist}}
                    {{#recordsExist}}
                    {{/recordsExist}}
                    {{^recordsExist}}
                       No predicted connections
                    {{/recordsExist}}
               </div>
            </div>
</script>
