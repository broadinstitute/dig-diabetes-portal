<script id="gregorTissueTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="gregorTissueTableTissueHeaderLabel"  type="x-tmpl-mustache">
<div class="initialLinearIndex_{{indexInOneDimensionalArray}}">Tissues</div>
</script>

<script id="gregorTissueTableTissueRowLabel"  type="x-tmpl-mustache">
<div class="tissueTableHeader staticValuesLabelInTissueTable initialLinearIndex_{{indexInOneDimensionalArray}}">GREGOR <g:helpText title="tissueTable.GREGOR.help.header" placement="bottom" body="tissueTable.GREGOR.help.text"/>
            <span class="glyphicon glyphicon-cog options-icon pull-right" aria-hidden="true" title="Open column filter"
onclick="mpgSoftware.dynamicUi.displayAnnotationFilter(event,this);"></span>
</div>
</script>

<script id="gregorTissueTableTissueHeader"  type="x-tmpl-mustache">
<div class="tissueTableTissueHeader initialLinearIndex_{{initialLinearIndex}}">{{tissueName}}</div>
</script>

<script id="gregorTissueTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{significanceValueAsString}}
</script>

<script id="gregorTissueTableSubCategory"  type="x-tmpl-mustache">
     <div significance_sortfield='{{index}}' class='subcategory initialLinearIndex_{{indexInOneDimensionalArray}}'
      sortField='{{index}}' subSortField='-1'>
     {{#dataAnnotation}}
          {{displaySubcategory}}
          <g:helpText title="gene.COLOC.help.header" placement="bottom" body="gene.COLOC.help.text"/>
     {{/dataAnnotation}}
     </div>
</script>


<script id="gregorTissueTableBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField="{{significanceValue}}"
             class="tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'GREGOR predictions for {{tissueName}}',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander"
               data-target="#gregor_tissue_table_{{tissueNameKey}}" style="color:black"> {{cellPresentationString}}
               </a>

               <div  class="collapse openEffectorGeneInformationInGeneTable" id="gregor_tissue_table_{{tissueNameKey}}">
                    {{#recordsExist}}
                        <table class="expandableDrillDownTable openEffectorGeneInformationInGeneTable">
                         <thead>
                          <tr role="row">
                            <th class="text-center leftMostCol">annotation</th>
                            <th class="text-center otherCols">ancestry</th>
                            <th class="text-center otherCols">p-value</th>
                          </tr>
                         </thead>
                         <tbody>
                     {{/recordsExist}}
                         {{#tissueRecords}}
                          <tr role="row">
                               <td class="leftMostCol">{{annotation}}</td>
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
