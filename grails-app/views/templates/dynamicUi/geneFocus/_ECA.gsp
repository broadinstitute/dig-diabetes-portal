
<script id="eCaviarTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="eCaviarTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
CLPP={{significanceValueAsString}} ({{recordDescription}})
</script>


<script id="eCaviarSubCategory"  type="x-tmpl-mustache">
     <div significance_sortfield='{{index}}' class='subcategory initialLinearIndex_{{indexInOneDimensionalArray}}'
      sortField='{{index}}' subSortField='-1'>
      {{#dataAnnotation}}
         {{displaySubcategory}}
         <g:helpText title="gene.eCAVIAR.help.header" placement="bottom" body="gene.eCAVIAR.help.text"/>
      {{/dataAnnotation}}
     </div>
</script>




<script id="eCaviarBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField={{numberOfRecords}}
             class="tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'eCAVIAR records referencing {{gene}}',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander"
               data-target="#eCaviar_{{gene}}" style="color:black">{{cellPresentationString}}</a>
               <div  class="collapse openDepictGeneSetInGeneTable" id="eCaviar_{{gene}}">
                    {{#recordsExist}}
                    <table class="expandableDrillDownTable openDepictGeneSetInGeneTable" style="border: 0">
                     <thead>
                      <tr role="row">
                        <th class="text-center leftMostCol">tissue</th>
                        <th class="text-center otherCols">post_prob</th>
                        <th class="text-center otherCols">variant</th>
                      </tr>
                     </thead>
                     <tbody>
                    {{/recordsExist}}
                    {{#records}}
                      <tr role="row">
                           <td class="leftMostCol">{{tissue}}</td>
                           <td class="otherCols">{{clpp}}</td>
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

