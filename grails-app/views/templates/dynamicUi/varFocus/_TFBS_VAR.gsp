<script id="tfbsVariantTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="tfbsVariantTableTissueHeaderLabel"  type="x-tmpl-mustache">
<div class="varEpigeneticsLabel varAllEpigenetics varTfbsEpigenetics variantEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}">Epigenetics</div>
</script>

<script id="tfbsVariantTableTissueRowLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varTfbsEpigenetics  staticMethodLabels methodName_SPP  initialLinearIndex_{{indexInOneDimensionalArray}}">
tfbs&nbsp;<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/></div>
</script>

<script id="tfbsVariantTableTissueHeader"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varTfbsEpigenetics  initialLinearIndex_{{initialLinearIndex}}">{{tissueName}}</div>
</script>

<script id="tfbsVariantTableIndividualAnnotationLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varTfbsEpigenetics  initialLinearIndex_{{initialLinearIndex}}">
<div style="font-weight: bold">TFBS</div>
{{annotationName}}</div>
</script>

<script id="tfbsVariantTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{significanceValueAsString}}No div!
</script>

%{--<script id="tfbsVariantTableBody"  type="x-tmpl-mustache">--}%
             %{--<div significance_sortField="{{significanceValue}}" sortField="{{significanceValue}}"--}%
             %{--class="varAllEpigenetics varTfbsEpigenetics tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">--}%
               %{--<a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'Open chromatin for {{tissueName}}',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander"--}%
               %{--data-target="#open_tfbs_{{tissueNameKey}}" style="color:black">tissues--}%
               %{--</a>--}%

               %{--<div  class="collapse openEffectorGeneInformationInGeneTable" id="open_tfbs_{{tissueNameKey}}">--}%
                    %{--{{#recordsExist}}--}%
                        %{--<table class="expandableDrillDownTable openEffectorGeneInformationInGeneTable" style="margin: 0 auto">--}%
                         %{--<thead>--}%
                          %{--<tr role="row">--}%
                            %{--<th class="text-center leftMostCol">Tissue</th>--}%
                            %{--<th class="text-center otherCols">TF</th>--}%
                          %{--</tr>--}%
                         %{--</thead>--}%
                         %{--<tbody>--}%
                     %{--{{/recordsExist}}--}%
                         %{--{{#tissueRecords}}--}%
                          %{--<tr class="epigeneticCellElement tissueId_{{safeTissueId}} annotationName_{{annotation}}" role="row">--}%
                               %{--<td class="text-center leftMostCol">{{tissue_name}}</td>--}%
                               %{--<td class="text-center otherCols">{{annotation}}</td>--}%
                           %{--</tr>--}%
                          %{--{{/tissueRecords}}--}%
                      %{--{{#recordsExist}}--}%
                         %{--</tbody>--}%
                        %{--</table>--}%
                    %{--{{/recordsExist}}--}%
                    %{--{{#recordsExist}}--}%
                    %{--{{/recordsExist}}--}%
                    %{--{{^recordsExist}}--}%
                       %{--No predicted connections--}%
                    %{--{{/recordsExist}}--}%
               %{--</div>--}%
            %{--</div>--}%
%{--</script>--}%
<script id="tfbsVariantTableBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField="{{significanceValue}}"
             class="varAllEpigenetics varTfbsEpigenetics tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">

                    {{#recordsExist}}

                     {{/recordsExist}}
                         {{#tissueRecords}}
 <div class="epigeneticCellElement tissueId_{{safeTissueId}} annotationName_{{annotation}}">
                               {{tissue_name}}
                            </div>
                          {{/tissueRecords}}
                      {{#recordsExist}}

                    {{/recordsExist}}
                    {{#recordsExist}}
                    {{/recordsExist}}
                    {{^recordsExist}}
                       No predicted connections
                    {{/recordsExist}}
               </div>
            </div>
</script>
