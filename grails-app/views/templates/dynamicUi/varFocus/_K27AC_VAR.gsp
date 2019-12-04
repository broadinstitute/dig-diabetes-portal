<script id="h3k27acVariantTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="h3k27acVariantTableTissueHeaderLabel"  type="x-tmpl-mustache">
<div class="varEpigeneticsLabel varAllEpigenetics varH3k27acEpigenetics variantEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}">Epigenetics</div>
</script>

<script id="h3k27acVariantTableTissueRowLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varH3k27acEpigenetics  staticMethodLabels annotationName_H3K27AC methodName_NA initialLinearIndex_{{indexInOneDimensionalArray}} varAnnotation {{isBlank}}"
 sortField=0>
H3K27AC&nbsp;<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/></div>
</script>

<script id="h3k27acVariantTableTissueHeader"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varH3k27acEpigenetics  initialLinearIndex_{{initialLinearIndex}}">{{tissueName}}</div>
</script>


<script id="h3k27acVariantTableTissueSpecificHeaderLabel"  type="x-tmpl-mustache">
<div class="varEpigeneticsLabel varTissueEpigenetics varAllEpigenetics varAbcEpigenetics variantEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}">H3K27AC</div>
</script>


<script id="h3k27acVariantTableTissueSpecificRowLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varAbcEpigenetics staticMethodLabels annotationName_H3K27AC methodName_NA  {{isBlank}} initialLinearIndex_{{indexInOneDimensionalArray}} varAnnotation"
 sortField=0>
{{tissue_name}}</div>
</script>


<script id="h3k27acVariantTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{significanceValueAsString}}No div!
</script>
<script id="h3k27acVariantTableBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortfield="{{significanceValue}}"
             class="varAllEpigenetics varH3k27acEpigenetics tissueCategory_{{tissueCategoryNumber}} methodName_{{method}} significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">

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

