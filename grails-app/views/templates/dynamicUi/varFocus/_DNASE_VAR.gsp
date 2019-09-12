<script id="dnaseVariantTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="dnaseVariantTableTissueHeaderLabel"  type="x-tmpl-mustache">
<div class="initialLinearIndex_{{indexInOneDimensionalArray}}">Epigenetics</div>
</script>

<script id="dnaseVariantTableTissueRowLabel"  type="x-tmpl-mustache">
<div class="tissueTableHeader staticValuesLabelInTissueTable initialLinearIndex_{{indexInOneDimensionalArray}}">DNase&nbsp;<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/></div>
</script>

<script id="dnaseVariantTableTissueHeader"  type="x-tmpl-mustache">
<div class="tissueTableTissueHeader initialLinearIndex_{{initialLinearIndex}}">{{tissueName}}</div>
</script>

<script id="dnaseVariantTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{significanceValueAsString}}
</script>

<script id="dnaseVariantTableBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField="{{significanceValue}}"
             class="tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'ABC predictions for {{tissueName}}',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander"
               data-target="#open_chromatin_tissue_{{tissueNameKey}}" style="color:black">tissues
               </a>

               <div  class="collapse openEffectorGeneInformationInGeneTable" id="open_chromatin_tissue_{{tissueNameKey}}">
                    {{#recordsExist}}
                        <table class="expandableDrillDownTable openEffectorGeneInformationInGeneTable" style="margin: 0 auto">
                         <thead>
                          <tr role="row">
                            <th class="text-center leftMostCol">Tissue</th>
                            <th class="text-center otherCols">Value</th>
                          </tr>
                         </thead>
                         <tbody>
                     {{/recordsExist}}
                         {{#tissueRecords}}
                          <tr role="row">
                               <td class="text-center leftMostCol">{{SOURCE}}</td>
                               <td class="text-center otherCols">{{VALUE}}</td>
                           </tr>
                          {{/tissueRecords}}
                      {{#recordsExist}}
                         </tbody>
                        </table>
                    {{/recordsExist}}
                    {{#recordsExist}}
                    {{/recordsExist}}
                    {{^recordsExist}}
                       No predicted connections
                    {{/recordsExist}}
               </div>
            </div>
</script>
