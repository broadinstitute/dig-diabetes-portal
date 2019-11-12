<script id="dnaseVariantTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="dnaseVariantTableTissueHeaderLabel"  type="x-tmpl-mustache">
<div class="varEpigeneticsLabel varAllEpigenetics varDnaseEpigenetics variantEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}">Epigenetics</div>
</script>

<script id="dnaseVariantTableTissueRowLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varDnaseEpigenetics  staticMethodLabels annotationName_AccessibleChromatin methodName_MACS initialLinearIndex_{{indexInOneDimensionalArray}} varAnnotation {{isBlank}}"
 sortField=0>
ATAC-seq&nbsp;<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/></div>
</script>

<script id="dnaseVariantTableTissueHeader"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varDnaseEpigenetics  initialLinearIndex_{{initialLinearIndex}}">{{tissueName}}</div>
</script>

<script id="dnaseVariantTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{significanceValueAsString}}No div!
</script>
<script id="dnaseVariantTableBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortfield="{{significanceValue}}"
             class="varAllEpigenetics varDnaseEpigenetics tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">

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
</script>

