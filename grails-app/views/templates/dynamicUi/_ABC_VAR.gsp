<script id="abcVariantTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="abcVariantTableTissueHeaderLabel"  type="x-tmpl-mustache">
<div class="initialLinearIndex_{{indexInOneDimensionalArray}}">Tissues</div>
</script>

<script id="abcVariantTableTissueRowLabel"  type="x-tmpl-mustache">
<div class="tissueTableHeader staticValuesLabelInTissueTable initialLinearIndex_{{indexInOneDimensionalArray}}">DEPICT p-value&nbsp;<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/></div>
</script>

<script id="abcVariantTableTissueHeader"  type="x-tmpl-mustache">
<div class="tissueTableTissueHeader initialLinearIndex_{{initialLinearIndex}}">{{tissueName}}</div>
</script>

<script id="abcVariantTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{significanceValueAsString}}
</script>

<script id="abcVariantTableSubCategory"  type="x-tmpl-mustache">
     <div significance_sortfield='{{index}}' class='subcategory initialLinearIndex_{{indexInOneDimensionalArray}}'
      sortField='{{index}}' subSortField='-1'>
     {{#dataAnnotation}}
          {{displaySubcategory}}
          <g:helpText title="gene.COLOC.help.header" placement="bottom" body="gene.COLOC.help.text"/>
     {{/dataAnnotation}}
     </div>
</script>


<script id="abcVariantTableBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField="{{significanceValue}}"
             class="tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'DEPICT enrichments for {{tissueName}}',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander"
               data-target="#depict_tissue_{{tissueNameKey}}" style="color:black"> {{cellPresentationString}}
               </a>

               <div  class="collapse openEffectorGeneInformationInGeneTable" id="depict_tissue_{{tissueNameKey}}">
                    {{#recordsExist}}
                        <table class="expandableDrillDownTable openEffectorGeneInformationInGeneTable" style="margin: 0 auto">
                         <thead>
                          <tr role="row">
                            <th class="text-center leftMostCol">p-values</th>
                          </tr>
                         </thead>
                         <tbody>
                     {{/recordsExist}}
                         {{#tissueRecords}}
                          <tr role="row">
                               <td class="leftMostCol" style="border-right: 0">{{pValueString}}</td>
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
