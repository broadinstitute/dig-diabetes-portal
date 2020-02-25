
<script id="modTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="modTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>


<script id="dynamicGeneTableModSubCategory"  type="x-tmpl-mustache">
     <div significance_sortfield='{{index}}' class='subcategory initialLinearIndex_{{indexInOneDimensionalArray}}'
      sortField='{{index}}' subSortField='-1'>
     {{#dataAnnotation}}
          {{displaySubcategory}}
          <g:helpText title="gene.MOD.help.header" placement="bottom" body="gene.MOD.help.text"/>
     {{/dataAnnotation}}
     </div>
</script>



<script id="dynamicGeneTableModBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField={{numberOfRecords}}
             class="tissueCategory_{{tissueCategoryNumber}} significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'MOD matches for {{gene}}',mpgSoftware.dynamicUi.extractStraightFromTarget)"
               class="cellExpander" data-target="#mod_data_{{gene}}"  style="color:black">{{cellPresentationString}}</a>
               <div  class="collapse openModInGeneTable" id="mod_data_{{gene}}">
                    {{#recordsExist}}
                    {{#geneName}}
                     <div> {{.}}</div>
                    {{/geneName}}
                    {{#geneDescription}}
                       <div> {{.}}</div>
                    {{/geneDescription}}
                    <table class="expandableDrillDownTable openModInGeneTable">
                     <thead>
                      <tr role="row">
                        <th class="text-center leftMostCol">ID</th>
                        <th class="text-center otherCols">Name</th>
                        <th class="text-center otherCols">Term</th>
                      </tr>
                     </thead>
                     <tbody>
                    {{/recordsExist}}
                    {{#records}}
                       <tr role="row">
                           <td class="leftMostCol">{{MGI_Gene_Marker_ID}}</td>
                           <td class="otherCols">{{Name}}</td>
                           <td class="otherCols">{{Term}}</td>
                       </tr>
                    {{/records}}
                    {{#recordsExist}}
                     </tbody>
                    </table>
                    {{/recordsExist}}
               </div>
            </div>
</script>

