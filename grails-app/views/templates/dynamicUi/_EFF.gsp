<script id="effectorGeneTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="effectorGeneTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{significanceValue}} {{value}}
</script>

<script id="dynamicGeneTableEffectorGeneSubCategory"  type="x-tmpl-mustache">
     <div significance_sortfield='{{index}}' class='subcategory initialLinearIndex_{{indexInOneDimensionalArray}}'
      sortField='{{index}}' subSortField='-1'>
     {{#dataAnnotation}}
          {{displaySubcategory}}
          <g:helpText title="gene.COLOC.help.header" placement="bottom" body="gene.COLOC.help.text"/>
     {{/dataAnnotation}}
     </div>
</script>


<script id="dynamicGeneTableEffectorGeneBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField={{numberOfRecords}}
             class="tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'effector gene records {{gene}}',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander"
               data-target="#effector_gene_{{gene}}" style="color:black">{{cellPresentationString}}</a>
               <div  class="collapse openColocInGeneTable" id="effector_gene_{{gene}}">
                    {{#recordsExist}}
                    <table class="expandableDrillDownTable openColocInGeneTable">
                     <thead>
                      <tr role="row">
                        <th class="text-center leftMostCol">tissue</th>
                        <th class="text-center otherCols">pp coloc snp exists</th>
                        <th class="text-center otherCols">pp snp coloc</th>
                        <th class="text-center otherCols">var_id</th>
                      </tr>
                     </thead>
                     <tbody>
                    {{/recordsExist}}
                    {{#records}}
                      <tr role="row">
                           <td class="leftMostCol">{{tissue}}</td>
                           <td class="otherCols">{{prob_exists_coloc}}</td>
                           <td class="otherCols">{{conditional_prob_snp_coloc}}</td>
                           <td class="otherCols">{{var_id}}</td>
                       </tr>

                    {{/records}}
                    {{#recordsExist}}
                     </tbody>
                    </table>
                    {{/recordsExist}}
               </div>
            </div>
</script>
