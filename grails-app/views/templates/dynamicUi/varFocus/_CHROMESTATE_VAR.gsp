<script id="chromStateVariantTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="chromStateVariantTableTissueHeaderLabel"  type="x-tmpl-mustache">
<div class="varEpigeneticsLabel varAllEpigenetics varChromHmmEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}">Epigenetics</div>
</script>

<script id="chromStateVariantTableTissueRowLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varChromHmmEpigenetics variantEpigenetics staticMethodLabels methodName_ChromHMM initialLinearIndex_{{indexInOneDimensionalArray}}">ChromHMM&nbsp;<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/></div>
</script>

<script id="chromStateVariantTableTissueHeader"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varChromHmmEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}">{{tissueName}}</div>
</script>

<script id="chromStateVariantTableIndividualAnnotationLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varChromHmmEpigenetics variantEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}} varAnnotation methodName_ChromHMM staticMethodLabels annotationName_{{annotationName}} {{isBlank}}"
 sortField='ChromHMM{{annotationName}}'>
<div style="font-weight: bold">ChromHMM</div>
{{annotationName}}
</div>
</script>

<script id="chromStateVariantTableTissueSpecificHeaderLabel"  type="x-tmpl-mustache">
<div class="varEpigeneticsLabel varTissueEpigenetics varAllEpigenetics varAbcEpigenetics variantEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}"></div>
</script>


<script id="chromStateVariantTableTissueSpecificRowLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varAbcEpigenetics staticMethodLabels annotationName_{{annotation}} methodName_{{method}} {{isBlank}} tissueId_{{safeTissueId}} initialLinearIndex_{{indexInOneDimensionalArray}} varAnnotation"
  sortField='{{tissue_name}}'>
{{tissue_name}}</div>
</script>


<script id="chromStateVariantTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{significanceValueAsString}}
</script>
<script id="chromStateVariantTableBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField="{{significanceValue}}"
             class="multiRecordCell varAllEpigenetics varChromHmmEpigenetics chromState tissueCategory_{{tissueCategoryNumber}} methodName_{{method}} annotationName_{{annotation}} significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
                   {{#recordsExist}}

                     {{/recordsExist}}
                         {{#tissueRecords}}
                          <div class="epigeneticCellElement tissueId_{{safeTissueId}}  methodName_{{method}} annotationName_{{annotation}}">
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
<script id="chromStateVariantTableBodyTissueSpecific"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField="{{significanceValue}}"
             class="multiRecordCell varAllEpigenetics varChromHmmEpigenetics chromState tissueCategory_{{tissueCategoryNumber}} methodName_{{method}} annotationName_{{annotation}} significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
                   {{#recordsExist}}

                     {{/recordsExist}}
                         {{#tissueRecords}}
                          <div class="tissueDominantCell epigeneticCellElement tissueId_{{safeTissueId}}  methodName_{{method}} annotationName_{{annotation}}">
                                ChrommHmm
                               {{annotation}}
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
