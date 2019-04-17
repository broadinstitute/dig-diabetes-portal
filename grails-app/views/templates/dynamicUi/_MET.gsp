
<script id="metaxcanTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="metaxcanTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
p={{significanceValue}} ({{recordDescription}})
</script>



<script id="metaxcanTableSubCategory"  type="x-tmpl-mustache">
     <div significance_sortfield='{{index}}' class='subcategory initialLinearIndex_{{indexInOneDimensionalArray}}'
      sortField='{{index}}' subSortField='-1'>
     {{#dataAnnotation}}
          {{displaySubcategory}}
          <g:helpText title="gene.MetaXcan.help.header" placement="bottom" body="gene.MetaXcan.help.text"/>
     {{/dataAnnotation}}
    </div>
</script>

<script id="metaxcanTableBody"  type="x-tmpl-mustache">

            <div significance_sortField="{{significanceValue}}" sortField={{numberOfRecords}}
            class="tissueCategory_{{tissueCategoryNumber}} significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'MetaXcan for {{gene}}',mpgSoftware.dynamicUi.extractStraightFromTarget)"
               class="cellExpander" data-target="#MetaXcan_{{gene}}"  style="color:black">{{cellPresentationString}}</a>
               <div  class="collapse openMetaXcanInGeneTable" id="MetaXcan_{{gene}}">
                    {{#tissuesExist}}
                    <table class="openMetaXcanInGeneTable" style="border: 0">
                     <thead>
                      <tr role="row">
                        <th style="border-top: 0" class="text-center">tissue</th>
                        <th style="border-top: 0;border-right: 0;" class="text-center">p-value</th>
                      </tr>
                     </thead>
                     <tbody>
                    {{/tissuesExist}}
                    {{#tissues}}
                       <tr role="row">
                           <td style="padding: 3px">{{tissueName}}</td>
                           <td style="border-right: 0;padding: 3px">{{value}}</td>
                       </tr>
                    {{/tissues}}
                    {{#tissuesExist}}
                     </tbody>
                    </table>
                    {{/tissuesExist}}
               </div>
            </div>
</script>


