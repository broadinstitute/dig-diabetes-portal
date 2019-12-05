<script id="atacSeqVariantTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="atacSeqVariantTableTissueHeaderLabel"  type="x-tmpl-mustache">
<div class="varEpigeneticsLabel varAllEpigenetics varAtacSeqEpigenetics variantEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}">Epigenetics</div>
</script>

<script id="atacSeqVariantTableTissueRowLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varAtacSeqEpigenetics  staticMethodLabels annotationName_AccessibleChromatin methodName_MACS initialLinearIndex_{{indexInOneDimensionalArray}} varAnnotation {{isBlank}}"
 sortField=0>
ATAC-seq&nbsp;<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/></div>
</script>

<script id="atacSeqVariantTableTissueHeader"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varAtacSeqEpigenetics  initialLinearIndex_{{initialLinearIndex}}">{{tissueName}}</div>
</script>


<script id="atacSeqVariantTableTissueSpecificHeaderLabel"  type="x-tmpl-mustache">
<div class="varEpigeneticsLabel varTissueEpigenetics varAllEpigenetics varAbcEpigenetics variantEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}">ATAC-seq</div>
</script>


<script id="atacSeqVariantTableTissueSpecificRowLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varAbcEpigenetics staticMethodLabels annotationName_GenePrediction methodName_MACS  {{isBlank}} initialLinearIndex_{{indexInOneDimensionalArray}} varAnnotation"
 sortField=0>
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

