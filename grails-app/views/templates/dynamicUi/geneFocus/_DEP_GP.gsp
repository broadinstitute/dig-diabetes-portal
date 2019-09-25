
<script id="depictGenePvalueTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="depictGenePvalueTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
p={{significanceValueAsString}}
</script>


<script id="depictGeneTableSubCategory"  type="x-tmpl-mustache">
     <div significance_sortfield='{{index}}' class='subcategory initialLinearIndex_{{indexInOneDimensionalArray}}'
      sortField='{{index}}' subSortField='-1'>
     {{#dataAnnotation}}
          {{displaySubcategory}}
          <g:helpText title="gene.DEPICTprior.help.header" placement="bottom" body="gene.DEPICTprior.help.text"/>
     {{/dataAnnotation}}
     </div>
</script>


<script id="depictGeneTableBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField={{numberOfRecords}}
             class="tissueCategory_{{tissueCategoryNumber}} significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'DEPICT predictions for {{gene}}',mpgSoftware.dynamicUi.extractStraightFromTarget)"
               class="cellExpander" data-target="#depict_data_{{gene}}" style="color:black">{{cellPresentationString}}</a>
               <div  class="collapse openDepictInGeneTable" id="depict_data_{{gene}}">
                    {{#recordsExist}}
                    <table class="expandableDrillDownTable openDepictInGeneTable" style="border: 0">
                     <thead>
                      <tr role="row">
                        <th class="text-center onlyCol">p-value</th>
                      </tr>
                     </thead>
                     <tbody>
                    {{/recordsExist}}
                    {{#data}}
                       <tr role="row">
                           <td class="text-center onlyCol">p-value = {{value}}</td>
                       </tr>
                    {{/data}}
                    {{#recordsExist}}
                     </tbody>
                    </table>
                    {{/recordsExist}}
               </div>
            </div>
</script>

