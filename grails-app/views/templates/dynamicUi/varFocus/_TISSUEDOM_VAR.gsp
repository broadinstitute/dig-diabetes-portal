<script id="sharedTableBodyTissueSpecific"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField="{{significanceValue}}"
             class="multiRecordCell varAllEpigenetics varAbcEpigenetics tissueId_{{safeTissueId}} methodName_{{method}}  annotationName_{{annotation}} significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               {{#uniqueTissueRecords}}
                  <div class="tissueDominantCell epigeneticCellElement tissueId_{{safeTissueId}}  methodName_{{method}} annotationName_{{annotation}}">
                    {{annotation_name}}
                  </div>
               {{/uniqueTissueRecords}}
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'ABC predictions for {{tissueName}}',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander"
               data-target="#depict_abc_{{tissueNameKey}}" style="color:black">all records&gt;&gt;
               </a>

               <div  class="collapse openEffectorGeneInformationInGeneTable" id="depict_abc_{{tissueNameKey}}">
                    {{#recordsExist}}
                        <table class="expandableDrillDownTable openEffectorGeneInformationInGeneTable" style="margin: 0 auto">
                         <thead>
                          <tr role="row">
                            <th class="text-center leftMostCol">Gene</th>
                            <th class="text-center otherCols">Tissue</th>
                            <th class="text-center otherCols">Value</th>
                          </tr>
                         </thead>
                         <tbody>
                     {{/recordsExist}}
                         {{#tissueRecords}}
                          <tr role="row">
                               <td class="leftMostCol"">{{gene_id}}</td>
                               <td class="text-center otherCols">{{tissue_name}}</td>
                               <td class="text-center otherCols">{{score}}</td>
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