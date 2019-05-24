
<script id="dynamicFullEffectorGeneTableHeader"  type="x-tmpl-mustache">

        <div sortStrategy="alphabetical" sortField="-1"  sortTerm="{{name1}}"
        class="sortClass_{{name}} {{groupKey}} {{groupName}} BigGroupNum{{groupNum}} groupNum{{groupNum}} withinGroupNum{{withinGroupNum}} text-center initialLinearIndex_{{initialLinearIndex}}">
            <span class="groupHelpText {{name}}" style="display:none">{{{groupHelpText}}}</span>
            <span class="columnHelpText {{name}}">{{{columnHelpText}}}</span>
            <span class="groupDisplayName displayMethodName {{name}}" methodKey="{{name}}" style="display:none">{{groupDisplayName}}
                <span class="glyphicon glyphicon-resize-full expand-trigger" aria-hidden="true" title="View collapsed columns"
                onclick="mpgSoftware.dynamicUi.expandColumns(event,this,'forward','table.fullEffectorGeneTableHolder');"
                style="display: none"></span>
                <span class="glyphicon glyphicon-resize-small collapse-trigger" aria-hidden="true" title="Collapse columns"
                onclick="mpgSoftware.dynamicUi.contractColumns(event,this,'forward','table.fullEffectorGeneTableHolder');"></span>
            </span>

            <span class="columnDisplayName displayMethodName {{name}}" methodKey="{{name}}">{{columnDisplayName}}
                <span class="glyphicon glyphicon-resize-full expand-trigger" aria-hidden="true" title="View collapsed columns"
                onclick="mpgSoftware.dynamicUi.expandColumns(event,this,'forward','table.fullEffectorGeneTableHolder');"
                style="display: none"></span>
                <span class="glyphicon glyphicon-resize-small collapse-trigger" aria-hidden="true" title="Collapse columns"
                onclick="mpgSoftware.dynamicUi.contractColumns(event,this,'forward','table.fullEffectorGeneTableHolder');"></span>
            </span>


            %{--<span class="glyphicon glyphicon-option-vertical options-icon" aria-hidden="true" title="Open column filter"--}%
            %{--onclick="mpgSoftware.dynamicUi.openFilter('genetic-evidence');"></span>--}%






        </div>


</script>

<script id="fegtCellBody"  type="x-tmpl-mustache">
<div class="initialLinearIndex_{{initialLinearIndex}} groupNum{{groupNumber}} fedtCell" sortField="{{categoryName}}" sortNumber="{{sortNumber}}">
{{#Combined_category}}
<div class="accentuate fedt">
    {{textToDisplay}}&nbsp;
    </div>
{{/Combined_category}}
{{#Gene_name}}
<div class="fedt">
        <a target="_blank" href="../gene/geneInfo/{{linkSafeText}}">{{textToDisplay}}</a>
    </div>
{{/Gene_name}}

{{#Genetic_combined}}
 <div class="fedt text-center">
 {{#exomeSequenceCallOut}}

                <a
               onclick="mpgSoftware.dynamicUi.showAttachedData(event,'T2D gene burden for {{geneName}}',mpgSoftware.dynamicUi.retrieveDataFromServer)"
                class="cellExpander" data-target="#geneBurdenTest_{{geneName}}"  style="color:black">
               <span class="glyphicon glyphicon-zoom-in" aria-hidden="true" data-target="#geneBurdenTest_{{geneName}}"></span>&nbsp;
               {{displayValue}}
               </a>
               <div  class="collapse opengeneSkatAssociationInGeneTable" id="geneBurdenTest_{{geneName}}">
                        <div  id="geneBurdenTestDetails_{{geneName}}"></div>
               </div>
 {{/exomeSequenceCallOut}}
 {{^exomeSequenceCallOut}}
    {{textToDisplay}}
 {{/exomeSequenceCallOut}}
</div>
{{/Genetic_combined}}
{{#Genomic_combined}}
<div class="fedt text-center">
    {{textToDisplay}}&nbsp;
</div>
{{/Genomic_combined}}
{{#Perturbation_combined}}
 <div class="fedt text-center">
    {{textToDisplay}}&nbsp;
</div>
{{/Perturbation_combined}}
{{#Semantic_score}}
 <div class="fedt text-center">
    {{textToDisplay}}&nbsp;
</div>
{{/Semantic_score}}
{{#FishHomo}}
 <div class="fedt">
    {{textToDisplay}}&nbsp;
</div>
{{/FishHomo}}
{{#additional_reference}}
 <div class="fedt ">
    {{textToDisplay}}&nbsp;
</div>
{{/additional_reference}}
</div>
</script>

<script id="effectorGeneTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{Combined_category}}
</script>

<script id="dynamicGeneTableEffectorGeneSubCategory"  type="x-tmpl-mustache">
     <div significance_sortfield='{{index}}' class='subcategory initialLinearIndex_{{indexInOneDimensionalArray}}'
      sortField='{{index}}' subSortField='-1'>
     {{#dataAnnotation}}
          {{displaySubcategory}}
          <g:helpText title="gene.COLOC.help.header" placement="bottom" body="gene.COLOC.help.text"/>
     {{/dataAnnotation}}
     </div>
</script>


<script id="dynamicGeneTableEffectorGeneBody"  type="x-tmpl-mustache">
             <div significance_sortField="{{significanceValue}}" sortField={{numberOfRecords}}
             class="tissueCategory_{{tissueCategoryNumber}}   significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'effector gene records {{gene}}',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander"
               data-target="#effector_gene_{{gene}}" style="color:black">
               {{#data}}
               {{value.Combined_category}}
               {{/data}}
               </a>
               <div  class="collapse openEffectorGeneInformationInGeneTable" id="effector_gene_{{gene}}">
                    {{#data}}
                    <table class="expandableDrillDownTable openEffectorGeneInformationInGeneTable">
                     <thead>
                      <tr role="row">
                        <th class="text-center leftMostCol">category</th>
                        <th class="text-center otherCols">value</th>
                      </tr>
                     </thead>
                     <tbody>
                      <tr role="row">
                           <td class="leftMostCol">Genetic combined</td>
                           <td class="otherCols">{{value.Genetic_combined}}</td>
                       </tr>
                       <tr role="row">
                           <td class="leftMostCol">Genomic combined</td>
                           <td class="otherCols">{{value.Genomic_combined}}</td>
                       </tr>
                       <tr role="row">
                           <td class="leftMostCol">Perturbation combined</td>
                           <td class="otherCols">{{value.Perturbation_combined}}</td>
                       </tr>
                     </tbody>
                    </table>
                    {{/data}}
               </div>
            </div>
</script>

<script id="fillUpTheGeneBurdenSpecifics"  type="x-tmpl-mustache">
<div  class=" opengeneSkatAssociationInGeneTable" id="geneSkatAssociation_{{gene}}">
    {{#tissuesExist}}
    <table class="expandableDrillDownTable openSkatInGeneTable" style="border: 0">
        <thead>
        <tr role="row">
            <th class="text-center leftMostCol">technique</th>
            <th class="text-center otherCols">p-value</th>
        </tr>
        </thead>
        <tbody>
        {{/tissuesExist}}
        {{#tissues}}
        <tr role="row">
            <td class="leftMostCol">{{tissueName}}</td>
            <td class="otherCols">{{value}}</td>
        </tr>
        {{/tissues}}
        {{#tissuesExist}}
        </tbody>
    </table>
    {{/tissuesExist}}
</div>
</script>
