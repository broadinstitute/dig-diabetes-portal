

<script id="geneFirthAssociationTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="geneFirthAssociationTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
p={{significanceValue}} ({{recordDescription}})
</script>



<script id="geneFirthAssociationTableSubCategory"  type="x-tmpl-mustache">
     <div significance_sortfield='{{index}}' class='subcategory initialLinearIndex_{{indexInOneDimensionalArray}}'
      sortField='{{index}}' subSortField='-1'>
     {{#dataAnnotation}}
          {{displaySubcategory}}
          <g:helpText title="gene.firth.help.header" placement="bottom" body="gene.firth.help.text"/>
     {{/dataAnnotation}}
     </div>
</script>


<script id="geneFirthAssociationTableBody"  type="x-tmpl-mustache">

            <div significance_sortField="{{significanceValue}}" sortField={{numberOfRecords}}
            class="tissueCategory_{{tissueCategoryNumber}} significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'Firth associations for {{gene}}',mpgSoftware.dynamicUi.extractStraightFromTarget)"
               class="cellExpander" data-target="#geneFirthAssociation_{{gene}}"  style="color:black">{{cellPresentationString}}</a>
               <div  class="collapse opengeneFirthAssociationInGeneTable" id="geneFirthAssociation_{{gene}}">
                    {{#tissuesExist}}
                    <table class="openMetaXcanInGeneTable" style="border: 0">
                     <thead>
                      <tr role="row">
                        <th style="border-top: 0" class="text-center">technique</th>
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

