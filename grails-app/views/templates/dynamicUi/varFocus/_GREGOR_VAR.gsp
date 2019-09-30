<script id="gregorVariantTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="gregorVariantTableTissueHeaderLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varGregorEpigenetics variantEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}">Epigenetics</div>
</script>

<script id="gregorVariantTableTissueRowLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varGregorEpigenetics  staticValuesLabelInTissueTable initialLinearIndex_{{indexInOneDimensionalArray}}">ATAC-seq&nbsp;<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/></div>
</script>

<script id="gregorVariantTableTissueHeader"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varGregorEpigenetics  initialLinearIndex_{{initialLinearIndex}}">{{tissueName}}</div>
</script>

<script id="gregorVariantTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{significanceValueAsString}}No div!
</script>

<script id="gregorVariantTableBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField="{{significanceValue}}"
             class="varAllEpigenetics varGregorEpigenetics tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'Open chromatin for {{tissueName}}',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander"
               data-target="#open_chromatin_tissue_{{tissueNameKey}}" style="color:black">tissues
               </a>

               <div  class="collapse openEffectorGeneInformationInGeneTable" id="open_chromatin_tissue_{{tissueNameKey}}">
                    {{#recordsExist}}
                        <table class="expandableDrillDownTable openEffectorGeneInformationInGeneTable" style="margin: 0 auto">
                         <thead>
                          <tr role="row">
                            <th class="text-center onlyCol">Tissue</th>
                          </tr>
                         </thead>
                         <tbody>
                     {{/recordsExist}}
                         {{#tissueRecords}}
                          <tr role="row">
                               <td class="text-center onlyCol">{{tissue_name}}</td>
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
