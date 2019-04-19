
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
               class="cellExpander" data-target="#mod_data_{{geneName}}"  style="color:black">{{cellPresentationString}}</a>
               <div  class="collapse openModInGeneTable" id="mod_data_{{geneName}}">
                    {{#recordsExist}}
                    {{#geneName}}
                     <div> {{.}}</div>
                    {{/geneName}}
                    {{#geneDescription}}
                       <div> {{.}}</div>
                    {{/geneDescription}}
                    <table class="openModInGeneTable" style="border: 0">
                     <thead>
                      <tr role="row">
                        <th style="border-top: 0;" class="text-center">ID</th>
                        <th style="border-top: 0;" class="text-center">Name</th>
                        <th style="border-top: 0;" class="text-center">Term</th>
                        <th style="border-top: 0;" class="text-center">Feature</th>
                      </tr>
                     </thead>
                     <tbody>
                    {{/recordsExist}}
                    {{#records}}
                       <tr role="row">
                           <td style="padding: 3px">{{MGI_Gene_Marker_ID}}</td>
                           <td style="padding: 3px">{{Name}}</td>
                           <td style="padding: 3px">{{Term}}</td>
                           <td style="padding: 3px">{{Feature_Type}}</td>
                       </tr>
                    {{/records}}
                    {{#recordsExist}}
                     </tbody>
                    </table>
                    {{/recordsExist}}
               </div>
            </div>
</script>

