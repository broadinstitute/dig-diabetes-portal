<script id="ldsrTissueTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="ldsrTissueTableTissueHeaderLabel"  type="x-tmpl-mustache">
<div class="initialLinearIndex_{{indexInOneDimensionalArray}}">Tissues</div>
</script>

<script id="ldsrTissueTableTissueRowLabel"  type="x-tmpl-mustache">
<div class="tissueTableHeader staticValuesLabelInTissueTable initialLinearIndex_{{indexInOneDimensionalArray}}">LDSR <g:helpText title="gene.COLOC.help.header" placement="bottom" body="gene.COLOC.help.text"/></div>
</script>

<script id="ldsrTissueTableTissueHeader"  type="x-tmpl-mustache">
<div class="tissueTableTissueHeader initialLinearIndex_{{initialLinearIndex}}">{{tissueName}}</div>
</script>

<script id="ldsrTissueTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{significanceValueAsString}}
</script>

<script id="ldsrTissueTableSubCategory"  type="x-tmpl-mustache">
     <div significance_sortfield='{{index}}' class='subcategory initialLinearIndex_{{indexInOneDimensionalArray}}'
      sortField='{{index}}' subSortField='-1'>
     {{#dataAnnotation}}
          {{displaySubcategory}}
          <g:helpText title="gene.COLOC.help.header" placement="bottom" body="gene.COLOC.help.text"/>
     {{/dataAnnotation}}
     </div>
</script>


<script id="ldsrTissueTableBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField="{{significanceValue}}"
             class="tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'ldsr predictions for {{tissueName}}',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander"
               data-target="#effector_gene_{{tissueNameKey}}" style="color:black"> {{cellPresentationString}}
               </a>

               <div  class="collapse openEffectorGeneInformationInGeneTable" id="effector_gene_{{tissueNameKey}}">
                    {{#recordsExist}}
                        <table class="expandableDrillDownTable openEffectorGeneInformationInGeneTable" style="margin: 0 auto">
                         <thead>
                          <tr role="row">
                            <th class="text-center otherCols">ancestry</th>
                            <th class="text-center otherCols">p-value</th>
                          </tr>
                         </thead>
                         <tbody>
                     {{/recordsExist}}
                         {{#tissueRecords}}
                          <tr role="row">
                               <td class="otherCols">{{ancestry}}</td>
                               <td class="otherCols">{{pValueString}}</td>
                           </tr>
                          {{/tissueRecords}}
                      {{#recordsExist}}
                         </tbody>
                        </table>
                    {{/recordsExist}}
                    {{#recordsExist}}
                    {{/recordsExist}}
                    {{^recordsExist}}
                       No predictions achieve nominal significance (p-value<0.05)
                    {{/recordsExist}}
               </div>
            </div>
</script>
