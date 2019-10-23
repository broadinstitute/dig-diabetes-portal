 <script id="abcVariantTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="abcVariantTableTissueHeaderLabel"  type="x-tmpl-mustache">
<div class="varEpigeneticsLabel varAllEpigenetics varAbcEpigenetics variantEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}">Epigenetics</div>
</script>

<script id="abcVariantTableTissueRowLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varAbcEpigenetics staticMethodLabels annotationName_ABC methodName_ABC  initialLinearIndex_{{indexInOneDimensionalArray}}">ABC&nbsp;<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/></div>
</script>

<script id="abcVariantTableTissueHeader"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varAbcEpigenetics initialLinearIndex_{{initialLinearIndex}}">{{tissueName}}</div>
</script>

<script id="abcVariantTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{significanceValueAsString}}
</script>

<script id="varAllEpigenetics varAbcEpigenetics abcVariantTableSubCategory"  type="x-tmpl-mustache">
     <div significance_sortfield='{{index}}' class='subcategory initialLinearIndex_{{indexInOneDimensionalArray}}'
      sortField='{{index}}' subSortField='-1'>
     {{#dataAnnotation}}
          {{displaySubcategory}}
          <g:helpText title="gene.COLOC.help.header" placement="bottom" body="gene.COLOC.help.text"/>
     {{/dataAnnotation}}
     </div>
</script>


<script id="abcVariantTableBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField="{{significanceValue}}"
             class="epigeneticCellElement tissueId_none annotationName_ABC varAllEpigenetics varAbcEpigenetics tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
                <div>
               {{#tissueRecords}}
                  <div class="text-center">{{details.SOURCE}}</div>
               {{/tissueRecords}}
               </div>
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'ABC predictions for {{tissueName}}',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander"
               data-target="#depict_abc_{{tissueNameKey}}" style="color:black">expand&gt;&gt;
               </a>

               <div  class="collapse openEffectorGeneInformationInGeneTable" id="depict_abc_{{tissueNameKey}}">
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
                               <td class="leftMostCol"">{{details.GENE}}</td>
                               <td class="text-center otherCols">{{details.SOURCE}}</td>
                               <td class="text-center otherCols">{{details.VALUE}}</td>
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
