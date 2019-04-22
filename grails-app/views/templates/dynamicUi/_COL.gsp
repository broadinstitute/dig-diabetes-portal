
<script id="colocTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="colocTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
CLPP={{significanceValueAsString}} ({{recordDescription}})
</script>



<script id="colocSubCategory"  type="x-tmpl-mustache">
     <div significance_sortfield='{{index}}' class='subcategory initialLinearIndex_{{indexInOneDimensionalArray}}'
      sortField='{{index}}' subSortField='-1'>
     {{#dataAnnotation}}
          {{displaySubcategory}}
          <g:helpText title="gene.COLOC.help.header" placement="bottom" body="gene.COLOC.help.text"/>
     {{/dataAnnotation}}
     </div>
</script>


<script id="colocBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField={{numberOfRecords}}
             class="tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'COLOC records referencing {{gene}}',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander"
               data-target="#COLOC_{{gene}}" style="color:black">{{cellPresentationString}}</a>
               <div  class="collapse openColocInGeneTable" id="COLOC_{{gene}}">
                    {{#recordsExist}}
                    <table class="openColocInGeneTable" style="border: 0">
                     <thead>
                      <tr role="row">
                        <th style="border-top: 0;" class="text-center">tissue</th>
                        <th style="border-top: 0;" class="text-center">pp coloc snp exists</th>
                        <th style="border-top: 0;" class="text-center">pp snp coloc</th>
                        <th style="border-top: 0;" class="text-center">var_id</th>
                      </tr>
                     </thead>
                     <tbody>
                    {{/recordsExist}}
                    {{#records}}
                      <tr role="row">
                           <td style="padding: 3px">{{tissue}}</td>
                           <td style="padding: 3px">{{prob_exists_coloc}}</td>
                           <td style="padding: 3px">{{conditional_prob_snp_coloc}}</td>
                           <td style="padding: 3px">{{var_id}}</td>
                       </tr>

                    {{/records}}
                    {{#recordsExist}}
                     </tbody>
                    </table>
                    {{/recordsExist}}
               </div>
            </div>
</script>


