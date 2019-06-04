<script id="effectorGeneTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="effectorGeneTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{Combined_category}}
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
               data-target="#effector_gene_{{gene}}" style="color:black">
               {{#data}}
               {{value.Combined_category}}
               {{/data}}
               </a>
               <div  class="collapse openEffectorGeneInformationInGeneTable" id="effector_gene_{{gene}}">
                    {{#data}}
                    <table class="expandableDrillDownTable openEffectorGeneInformationInGeneTable">
                     <thead>
                      <tr role="row">
                        <th class="text-center leftMostCol">category</th>
                        <th class="text-center otherCols">value</th>
                      </tr>
                     </thead>
                     <tbody>
                      <tr role="row">
                           <td class="leftMostCol">Genetic combined</td>
                           <td class="otherCols">{{value.Genetic_combined}}</td>
                       </tr>
                       <tr role="row">
                           <td class="leftMostCol">Genomic combined</td>
                           <td class="otherCols">{{value.Genomic_combined}}</td>
                       </tr>
                       <tr role="row">
                           <td class="leftMostCol">Perturbation combined</td>
                           <td class="otherCols">{{value.Perturbation_combined}}</td>
                       </tr>
                     </tbody>
                    </table>
                    {{/data}}
               </div>
            </div>
</script>
