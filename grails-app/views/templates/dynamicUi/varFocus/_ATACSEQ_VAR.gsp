<script id="atacSeqVariantTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="atacSeqVariantTableTissueHeaderLabel"  type="x-tmpl-mustache">
<div class="varEpigeneticsLabel varAllEpigenetics varAtacSeqEpigenetics variantEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}">Epigenetics</div>
</script>

<script id="atacSeqVariantTableTissueRowLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varAtacSeqEpigenetics  staticMethodLabels annotationName_AccessibleChromatin methodName_MACS initialLinearIndex_{{indexInOneDimensionalArray}} varAnnotation {{isBlank}}"
  sortField='ATAC-seq'>
ATAC-seq&nbsp;<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/></div>
</script>

<script id="atacSeqVariantTableTissueHeader"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varAtacSeqEpigenetics  initialLinearIndex_{{initialLinearIndex}}">{{tissueName}}</div>
</script>


<script id="atacSeqVariantTableTissueSpecificHeaderLabel"  type="x-tmpl-mustache">
<div class="varEpigeneticsLabel varTissueEpigenetics varAllEpigenetics varAbcEpigenetics variantEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}"></div>
</script>


<script id="atacSeqVariantTableTissueSpecificRowLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varAtacSeqEpigenetics staticMethodLabels methodName_{{method}} annotationName_{{annotation}} tissueId_{{safeTissueId}} {{isBlank}} initialLinearIndex_{{indexInOneDimensionalArray}} varAnnotation"
  sortField='{{tissue_name}}'>
{{tissue_name}}</div>
</script>


<script id="atacSeqVariantTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{significanceValueAsString}}No div!
</script>

<script id="atacSeqVariantTableBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortfield="{{significanceValue}}"
             class="multiRecordCell varAllEpigenetics varAtacSeqEpigenetics tissueCategory_{{tissueCategoryNumber}} methodName_{{method}} annotationName_{{annotation}} significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">

                    {{#recordsExist}}

                     {{/recordsExist}}
                         {{#tissueRecords}}
                          <div class="epigeneticCellElement tissueId_{{safeTissueId}} methodName_{{method}} annotationName_{{annotation}}">
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

<script id="atacSeqVariantTableBodyTissueSpecific"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortfield="{{significanceValue}}"
             class="multiRecordCell varAllEpigenetics varAtacSeqEpigenetics tissueId_{{safeTissueId}} methodName_{{method}} annotationName_{{annotation}} significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">

                    {{#recordsExist}}

                     {{/recordsExist}}
                         {{#tissueRecords}}
                          <div class="tissueDominantCell epigeneticCellElement tissueId_{{safeTissueId}} methodName_{{method}} annotationName_{{annotation}}">
                               ATAC-seq
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

