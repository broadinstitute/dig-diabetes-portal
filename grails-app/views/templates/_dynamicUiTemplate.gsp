%{--called from displayVariantRecordsFromVariantQtlSearch--}%
<script id="dynamicVariantTable"  type="x-tmpl-mustache">

    <table  class="table">
    {{#variantsExist}}
    <tr>
        <th  scope="row">Variants</th>
        {{/variantsExist}}
        {{#uniqueVariants}}
            <th  scope="col">{{variantName}}</th>
        {{/uniqueVariants}}
        {{#variantsExist}}
    </tr>
    {{/variantsExist}}

    {{#variantPhenotypesExist}}
    <tr>
        <th  scope="row">Phenotype</th>
        {{/variantPhenotypesExist}}
        {{#variantPhenotypeQtl}}
            <td >{{#phenotypes}}
            <div>{{phenotypeName}}</div>
            {{/phenotypes}}
            </td>
        {{/variantPhenotypeQtl}}
        {{#variantPhenotypesExist}}
    </tr>
    {{/variantPhenotypesExist}}


    </table>
</script>



<script id="emptySummaryVariantAnnotationRecord"  type="x-tmpl-mustache">
     <div class="summaryVariantAnnotationRecord" sortField=0>
     </div>
</script>


<script id="emptyRecord"  type="x-tmpl-mustache">
     <div class="{{initialLinearIndex}} {{otherClasses}}" sortField="A">
                     <div>{{constText}}</div>
     </div>
</script>


<script id="dynamicEqtlVariantTableBodySummaryRecord"  type="x-tmpl-mustache">
     <div class="summaryVariantRecord {{category}}" geneNumber={{geneNumber}}  tissueNumber={{tissueNumber}} sortField={{tissueNumber}}>
     <div>G:{{geneNumber}}</div>
     <div>T:{{tissueNumber}}</div>
     </div>
</script>




<script id="dynamicEqtlVariantTableBody"  type="x-tmpl-mustache">

{{#.}}
     <div class="variantRecordExists {{category}}" value={{value}}  geneName="{{geneName}}" sortField=1>
     {{geneName}}
     {{value}}
     </div>
{{/.}}
{{^.}}
     <div class="individualTissueRecord"   sortField=0></div>
{{/.}}
</script>



<script id="dynamicDnaseVariantTableBody"  type="x-tmpl-mustache">
{{#.}}
     <div class="variantRecordExists {{category}} tissueTable {{quantileIndicator}}" value={{value}}  tissueName="{{tissueName}}" sortField=1>
     {{tissueName}}
     {{value}}
     </div>
{{/.}}
{{^.}}
     <div class="individualTissueRecord"   sortField=0></div>
{{/.}}
</script>



<script id="dynamicDnaseVariantTableBodySummaryRecord"  type="x-tmpl-mustache">
     <div class="summaryVariantRecord {{category}}"   tissueNumber={{tissueNumber}} sortField={{tissueNumber}}>
     <div>T:{{tissueNumber}}</div>
     </div>
</script>


<script id="dynamicH3k27acVariantTableBody"  type="x-tmpl-mustache">
{{#.}}
     <div class="variantRecordExists {{category}} tissueTable {{quantileIndicator}}" value={{value}}  tissueName="{{tissueName}}" sortField=1>
     {{value}}
     </div>
{{/.}}
{{^.}}
     <div class="individualTissueRecord"   sortField=0></div>
{{/.}}

</script>



<script id="dynamicH3k27acVariantTableBodySummaryRecord"  type="x-tmpl-mustache">
     <div class="summaryVariantRecord {{category}}"   tissueNumber={{tissueNumber}} sortField={{tissueNumber}}>
     <div>T:{{tissueNumber}}</div>
     </div>
</script>




<script id="dynamicVariantHeader"  type="x-tmpl-mustache">

            <div class="variantTableVarHeader columnNumber_{{index}}" sortterm="{{variantName}}">{{variantName}}</div>

</script>

<script id="dynamicVariantBody"  type="x-tmpl-mustache">

        {{#variantPhenotypeQtl}}
           {{#phenotypes}}
            <div>{{phenotypeName}}</div>
            {{/phenotypes}}
        {{/variantPhenotypeQtl}

</script>


<script id="dynamicVariantCellAnnotations"  type="x-tmpl-mustache">
      {{#variantAnnotationIsPresent}}
      <div class="credset.present"></div>
      {{/variantAnnotationIsPresent}}
      {{^variantAnnotationIsPresent}}
      <div class="credset.absent"></div>
      {{/variantAnnotationIsPresent}}
</script>

<script id="dynamicVariantCellAssociations"  type="x-tmpl-mustache">
      <div sortField="{{valueToDisplay}}">{{valueToDisplay}}</div>
 </script>


%{--Called from displayRefinedModContext, displayTissuesPerGeneFromEqtl, displayRefinedGenesInARange--}%
<script id="dynamicGeneTable"  type="x-tmpl-mustache">
    <table  class="table">
    {{#genesExist}}
    <tr>
        <th>gene</th>
        {{/genesExist}}
        {{#uniqueGenes}}
            <th  scope="col">{{name}}</th>
        {{/uniqueGenes}}
        {{#genesExist}}
    </tr>
    {{/genesExist}}

    {{#genesPositionsExist}}
    <tr>
        <th  scope="row">Position</th>
        {{/genesPositionsExist}}
        {{#genePositions}}
            <td >{{name}}</td>
        {{/genePositions}}
        {{#genesPositionsExist}}
    </tr>
    {{/genesPositionsExist}}

    {{#eqtlTissuesExist}}
    <tr>
        <th  scope="row">Tissues with eQTLs</th>
        {{/eqtlTissuesExist}}
        {{#uniqueEqtlGenes}}
            <td >
            {{#tissues}}
                <div>
                    {{tissueName}}
                </div>
            {{/tissues}}
            </td>
        {{/uniqueEqtlGenes}}
       {{#eqtlTissuesExist}}
    </tr>
    {{/eqtlTissuesExist}}


    {{#geneModsExist}}
    <tr>
        <th  scope="row">Associated mouse phenotypes</th>
        {{/geneModsExist}}
        {{#geneModTerms}}
            <td >
            {{#mods}}
                <div>
                    {{modName}}
                </div>
            {{/mods}}
            </td>
        {{/geneModTerms}}
       {{#geneModsExist}}
    </tr>
    {{/geneModsExist}}


    </table>
</script>




<script id="sharedCategoryWriter"  type="x-tmpl-mustache">
     <div significance_sortfield='0' sortField='{{index}}' subSortField='-1' class='{{row.subcategory}} initialLinearIndex_{{indexInOneDimensionalArray}} categoryName'>
           <div class="geneAnnotationShifters text-center">
                <span class="glyphicon glyphicon-step-backward" aria-hidden="true" onclick="mpgSoftware.dynamicUi.shiftColumnsByOne(event,this,'backward','table.combinedGeneTableHolder','#configurableUiTabStorage')"></span>
                <span class="glyphicon glyphicon-step-forward" aria-hidden="true" onclick="mpgSoftware.dynamicUi.shiftColumnsByOne(event,this,'forward','table.combinedGeneTableHolder','#configurableUiTabStorage')"></span>
            </div>
     {{#dataAnnotation}}
          {{displayCategory}}
     {{/dataAnnotation}}
     </div>
</script>




%{--a new and reduced form of dynamicGeneTable initially for displayRefinedModContext--}%
<script id="dynamicGeneTableHeader"  type="x-tmpl-mustache">

            {{name}}

</script>
















%{--a new and reduced form of dynamicGeneTable initially for displayRefinedModContext--}%
<script id="dynamicGeneTableEqtlHeader"  type="x-tmpl-mustache">

            {{geneName}}

</script>

<script id="dynamicGeneTableEqtlBody"  type="x-tmpl-mustache">

            {{#tissues}}
                <div>
                    {{tissueName}}
                </div>
            {{/tissues}}

</script>




<script id="dynamicGeneTableEqtlSummaryBody"  type="x-tmpl-mustache">
            <div significance_sortField="{{significanceValue}}" sortField={{numberOfTissues}}
            class="tissueCategory_{{tissueCategoryNumber}} significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'eQTLs for {{geneName}}',mpgSoftware.dynamicUi.extractStraightFromTarget);"
               class="cellExpander" data-target="#eqtl_{{geneName}}" style="color:black">{{cellPresentationString}}</a>
               %{--<div  class="popup">--}%
               <div  class="collapse openEqtlInGeneTable popuptext" id="eqtl_{{geneName}}">
                    {{#tissuesExist}}
                    <table class="openEqtlInGeneTable" style="border: 0">
                     <thead>
                      <tr role="row">
                        <th style="border-right: 0;border-top: 0;" class="text-center">tissue</th>
                        <th style="border-right: 0;" class="text-center">value</th>
                      </tr>
                     </thead>
                     <tbody>
                    {{/tissuesExist}}
                    {{#tissues}}
                       <tr role="row">
                           <td style="padding: 3px">{{tissueName}}</td>
                           <td style="border-right: 0; padding: 3px">{{value}}</td>
                       </tr>
                    {{/tissues}}
                    {{#tissuesExist}}
                     </tbody>
                    </table>
                    {{/tissuesExist}}
               </div>
               %{--</div>--}%
            </div>
</script>





%{--Called from displayGenesPerTissueFromEqtl--}%

<script id="dynamicTissueTable"  type="x-tmpl-mustache">
    <table  class="table">
    {{#tissuesExist}}
    <tr>
        <th>tissue</th>
        {{/tissuesExist}}
        {{#uniqueTissues}}
            <th  scope="col">{{name}}</th>
        {{/uniqueTissues}}
        {{#tissuesExist}}
    </tr>
    {{/tissuesExist}}

    {{#genesPositionsExist}}
    <tr>
        <th  scope="row">Position</th>
        {{/genesPositionsExist}}
        {{#genePositions}}
            <td >{{name}}</td>
        {{/genePositions}}
        {{#genesPositionsExist}}
    </tr>
    {{/genesPositionsExist}}

    {{#eqtlGenesExist}}
    <tr>
        <th  scope="row">Tissues with eQTLs</th>
        {{/eqtlGenesExist}}
        {{#geneTissueEqtls}}
            <td >
            {{#genes}}
                <div>
                    {{geneName}}
                </div>
            {{/genes}}
            </td>
        {{/geneTissueEqtls}}
       {{#eqtlGenesExist}}
    </tr>
    {{/eqtlGenesExist}}

    </table>
</script>


%{--Called from displayGenesPerTissueFromEqtl,displayGenesFromColocalization--}%
<script id="dynamicColocalizationGeneTable"  type="x-tmpl-mustache">

    <table  class="table">
    {{#colocsExist}}
    <tr>
        <th  scope="row">Phenotypes</th>
        {{/colocsExist}}
        {{#phenotypesByColocalization}}
            <th  scope="col">{{geneName}}</th>
        {{/phenotypesByColocalization}}
        {{#colocsExist}}
    </tr>
    {{/colocsExist}}

    {{#colocsExist}}
    <tr>
        <th  scope="row">For each phenotype</th>
        {{/colocsExist}}
        {{#phenotypesByColocalization}}
            <td >
            <div><a data-toggle="collapse" class="cellExpander" data-target="#tissues_{{geneName}}">tissues={{numberOfTissues}}</a>
               <div  class="collapse holdMultipleElements openTissues" id="tissues_{{geneName}}">
                    {{#tissues}}
                       <div>{{.}}</div>
                    {{/tissues}}
                    <div id="tooltip_tissues_{{geneName}}"></div>
                    <div id="graphic_tissues_{{geneName}}"></div>
               </div>
            </div>
            <div><a data-toggle="collapse" class="cellExpander" data-target="#phenotypes_{{geneName}}">phenotypes={{numberOfPhenotypes}}</a>
               <div  class="collapse holdMultipleElements" id="phenotypes_{{geneName}}">
                    {{#phenotypes}}
                       <div>{{.}}</div>
                    {{/phenotypes}}
               </div>
            </div>
            <div><a data-toggle="collapse" class="cellExpander" data-target="#varId_{{geneName}}">variants={{numberOfVariants}}</a>
               <div  class="collapse holdMultipleElements" id="varId_{{geneName}}">
                    {{#varId}}
                       <div>{{.}}</div>
                    {{/varId}}
               </div>
            </div>
            </td>
        {{/phenotypesByColocalization}}
        {{#colocsExist}}
    </tr>
    {{/colocsExist}}


    </table>
</script>



%{--Called from displayGenesFromColocalization,displayTissuesFromColocalization--}%
<script id="dynamicColocalizationTissueTable"  type="x-tmpl-mustache">

    <table  class="table">
    {{#colocsTissuesExist}}
    <tr>
        <th  scope="row">Tissues</th>
        {{/colocsTissuesExist}}
        {{#phenotypesByColocalization}}
            <th  scope="col">{{tissueName}}</th>
        {{/phenotypesByColocalization}}
        {{#colocsTissuesExist}}
    </tr>
    {{/colocsTissuesExist}}

    {{#phenotypeColocsExist}}
    <tr>
        <th  scope="row">For each tissue</th>
        {{/phenotypeColocsExist}}
        {{#phenotypesByColocalization}}
            <td >
            <div><a data-toggle="collapse" class="cellExpander" data-target="#tissues_{{tissueName}}">phenotypes={{numberOfPhenotypes}}</a>
               <div  class="collapse holdMultipleElements" id="tissues_{{tissueName}}">
                    {{#phenotypes}}
                       <div>{{.}}</div>
                    {{/phenotypes}}
               </div>
            </div>
            <div><a data-toggle="collapse" class="cellExpander" data-target="#genes_{{tissueName}}">genes={{numberOfGenes}}</a>
               <div  class="collapse holdMultipleElements" id="genes_{{tissueName}}">
                    {{#genes}}
                       <div>{{.}}</div>
                    {{/genes}}
               </div>
            </div>
            <div><a data-toggle="collapse" class="cellExpander" data-target="#varId_{{tissueName}}">variants={{numberOfVariants}}</a>
               <div  class="collapse holdMultipleElements" id="varId_{{tissueName}}">
                    {{#varId}}
                       <div>{{.}}</div>
                    {{/varId}}
               </div>
            </div>
            </td>
        {{/phenotypesByColocalization}}
        {{#phenotypeColocsExist}}
    </tr>
    {{/phenotypeColocsExist}}


    </table>
</script>



%{--Called from displayPhenotypesFromColocalization--}%
<script id="dynamicColocalizationPhenotypeTable"  type="x-tmpl-mustache">

    <table  class="table">
    {{#phenotypesExist}}
    <tr>
        <th  scope="row">Phenotypes</th>
        {{/phenotypesExist}}
        {{#uniquePhenotypes}}
            <th  scope="col">{{phenotypeName}}</th>
        {{/uniquePhenotypes}}
        {{#phenotypesExist}}
    </tr>
    {{/phenotypesExist}}

    {{#phenotypeColocsExist}}
    <tr>
        <th  scope="row">For each phenotype</th>
        {{/phenotypeColocsExist}}
        {{#phenotypesByColocalization}}
            <td >
            <div><a data-toggle="collapse" class="cellExpander" data-target="#tissues_{{phenotypeName}}">tissues={{numberOfTissues}}</a>
               <div  class="collapse holdMultipleElements" id="tissues_{{phenotypeName}}">
                    {{#tissues}}
                       <div>{{.}}</div>
                    {{/tissues}}
               </div>
            </div>
            <div><a data-toggle="collapse" class="cellExpander" data-target="#genes_{{phenotypeName}}">genes={{numberOfGenes}}</a>
               <div  class="collapse holdMultipleElements" id="genes_{{phenotypeName}}">
                    {{#genes}}
                       <div>{{.}}</div>
                    {{/genes}}
               </div>
            </div>
            <div><a data-toggle="collapse" class="cellExpander" data-target="#varId_{{phenotypeName}}">variants={{numberOfVariants}}</a>
               <div  class="collapse holdMultipleElements" id="varId_{{phenotypeName}}">
                    {{#varId}}
                       <div>{{.}}</div>
                    {{/varId}}
               </div>
            </div>
            </td>
        {{/phenotypesByColocalization}}
        {{#phenotypeColocsExist}}
    </tr>
    {{/phenotypeColocsExist}}


    </table>
</script>




%{--Called from displayTissuesFromAbc--}%
<script id="dynamicAbcTissueTable"  type="x-tmpl-mustache">
    <table  class="table">
    {{#abcTissuesExist}}
    <tr>
        <th  scope="row">Sources</th>
        {{/abcTissuesExist}}
        {{#tissuesByAbc}}
            <th  scope="col">{{tissueName}}</th>
        {{/tissuesByAbc}}
        {{#abcTissuesExist}}
    </tr>
    {{/abcTissuesExist}}

    {{#abcTissuesExist}}
    <tr>
        <th  scope="row"></th>
        {{/abcTissuesExist}}
        {{#tissuesByAbc}}
            <td >
            <div><a onclick="mpgSoftware.dynamicUi.showAttachedData(event)" class="cellExpander" data-target="#genes_{{tissueName}}">genes={{numberOfGenes}}</a>
               <div  class="collapse holdMultipleElements" id="genes_{{tissueName}}">
                    {{#gene}}
                       <div>{{.}}</div>
                    {{/gene}}
               </div>
            </div>

            <div><a onclick="mpgSoftware.dynamicUi.showAttachedData(event)" class="cellExpander" data-target="#experiments_{{tissueName}}">experiments={{numberOfExperiments}}</a>
               <div  class="collapse holdMultipleElements" id="experiments_{{tissueName}}">
                    {{#experiment}}
                       <div>{{.}}</div>
                       <div id="chart2_{{tissueName}}"></div>
                    {{/experiment}}
               </div>
            </div>

            </td>
        {{/tissuesByAbc}}
        {{#abcTissuesExist}}
    </tr>
    {{/abcTissuesExist}}
    </table>
</script>



%{--Called from displayGenesFromAbc--}%
<script id="dynamicAbcGeneTable"  type="x-tmpl-mustache">
    <table  class="table">
    {{#abcGenesExist}}
    <tr>
        <th  scope="row">Genes</th>
        {{/abcGenesExist}}
        {{#genesByAbc}}
            <th  scope="col"><div class="geneName text-center">{{geneName}}</div><div class="genePosition">chromosome {{chrom}}: {{regionStart}}-{{regionEnd}}</div></th>
        {{/genesByAbc}}
        {{#abcGenesExist}}
    </tr>
    {{/abcGenesExist}}

    {{#abcGenesExist}}
    <tr>
        <th  scope="row"></th>
        {{/abcGenesExist}}
        {{#genesByAbc}}
            <td >
            <div><a onclick="mpgSoftware.dynamicUi.showAttachedData(event)" class="cellExpander" data-target="#tissues_{{geneName}}">tissues={{numberOfTissues}}</a>
               <div  class="collapse holdMultipleElements openTissues" id="tissues_{{geneName}}">
                    <div id="tooltip_tissues_{{geneName}}"></div>
                    <div id="graphic_tissues_{{geneName}}"></div>
               </div>
            </div>

            <div><a onclick="mpgSoftware.dynamicUi.showAttachedData(event)" class="cellExpander" data-target="#experiments_{{geneName}}">experiments={{numberOfExperiments}}</a>
               <div  class="collapse holdMultipleElements" id="experiments_{{geneName}}">
                    {{#experiment}}
                       <div>{{.}}</div>
                    {{/experiment}}
               </div>
            </div>

            </td>
        {{/genesByAbc}}
        {{#abcGenesExist}}
    </tr>
    {{/abcGenesExist}}




    {{#geneModsExist}}
    <tr>
        <th  scope="row">Associated mouse phenotypes</th>
        {{/geneModsExist}}
        {{#geneModTerms}}
            <td >
            {{#mods}}
                <div>
                    {{modName}}
                </div>
            {{/mods}}
            </td>
        {{/geneModTerms}}
       {{#geneModsExist}}
    </tr>
    {{/geneModsExist}}




    </table>
</script>



%{--Called from displayGenesFromAbc--}%
<script id="dynamicGeneTableHeaderV2"  type="x-tmpl-mustache">
       %{--<span class="title-collapsed title-genetic-evidence">--}%
            <div sortStrategy="alphabetical" sortField="-1"  sortTerm="{{name1}}" class="geneName text-center {{initialLinearIndex}}">
               <div class="geneHeaderShifters text-center">
                   <span class="glyphicon glyphicon-step-backward" aria-hidden="true" onclick="mpgSoftware.dynamicUi.shiftColumnsByOne(event,this,'backward','table.combinedGeneTableHolder','#configurableUiTabStorage')"></span>
                   <span class="glyphicon glyphicon-step-forward" aria-hidden="true" onclick="mpgSoftware.dynamicUi.shiftColumnsByOne(event,this,'forward','table.combinedGeneTableHolder','#configurableUiTabStorage')"></span>
               </div>
               <div class="pull-right">
                   <span class="glyphicon glyphicon-remove" aria-hidden="true" onclick="mpgSoftware.dynamicUi.removeColumn(event,this,'forward','table.combinedGeneTableHolder','#configurableUiTabStorage')" style="padding: 0 8px 0 0"></span>
               </div>
               <span class="displayGeneName">{{name2}}</span>
            </div>
            <div class="genePosition text-center">
            {{chromosome}}: {{addrStart}}-{{addrEnd}}
            </div>
       %{--</span>--}%
       %{--<span class="effector-ui-wrapper">--}%
            %{--<span class="glyphicon glyphicon-resize-full expand-trigger" aria-hidden="true" title="View collapsed columns" onclick="expandColumns('genetic-evidence');"></span>--}%
            %{--<span class="glyphicon glyphicon-resize-small collapse-trigger inactive" aria-hidden="true" title="Collapse columns" onclick="collapseColumns('genetic-evidence');"></span>--}%
            %{--<span class="glyphicon glyphicon-move" aria-hidden="true" title="Drag and drop cell"></span>--}%
            %{--<span class="glyphicon glyphicon-step-backward" aria-hidden="true" title="Move cell to far left"></span>--}%
            %{--<span class="glyphicon glyphicon-step-forward" aria-hidden="true" title="Move cell to far right"></span>--}%
            %{--<span class="glyphicon glyphicon-sort" aria-hidden="true" title="Sort table by the column"></span>--}%
            %{--<span class="glyphicon glyphicon-cog" aria-hidden="true" title="Open column filter" onclick="openFilter('genetic-evidence');"></span>--}%
        %{--</span>--}%
        %{--<span class="options-icon"><span class="glyphicon glyphicon-option-vertical" aria-hidden="true"></span>--}%

</script>






%{--Called from displayGenesFromAbc--}%
<script id="dynamicAbcGeneTableHeader"  type="x-tmpl-mustache">

            <div class="geneName">{{geneName}}</div><div class="genePosition">chromosome {{chrom}}: {{regionStart}}-{{regionEnd}}</div>

</script>
<script id="dynamicAbcGeneTableBody"  type="x-tmpl-mustache">
            <div significance_sortField="{{significanceValue}}" sortField={{numberOfTissues}}
            class="tissueCategory_{{tissueCategoryNumber}}  significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               <a
               onclick="mpgSoftware.dynamicUi.showAttachedData(event,'ABC for {{geneName}}',mpgSoftware.dynamicUi.extractStraightFromTarget)"
                class="cellExpander" data-target="#abc_{{geneName}}" style="color:black">{{cellPresentationString}}</a>
               <a
               onclick="mpgSoftware.dynamicUi.showAttachedData(event,'ABC for {{geneName}}',mpgSoftware.dynamicUi.createOutOfRegionGraphic)"
                class="cellExpander" data-target="#tissues_{{geneName}}"  style="color:black">
               <span class="glyphicon glyphicon-zoom-in" aria-hidden="true" data-target="#tissues_{{geneName}}"></span>
               &nbsp;
               </a>
               <div  class="collapse holdMultipleElements openTissues" id="tissues_{{geneName}}">
                    <div id="tooltip_tissues_{{geneName}}"></div>
                    <div id="graphic_tissues_{{geneName}}"></div>
               </div>
               <div  class="collapse openAbcInGeneTable" id="abc_{{geneName}}">

                    {{#tissuesExist}}
                    <table class="openAbcInGeneTable" style="border: 0">
                     <thead>
                      <tr role="row">
                        <th style="border-top: 0;" class="text-center">tissue</th>
                        <th style="border-top: 0;border-right: 0;" class="text-center">value</th>
                      </tr>
                     </thead>
                     <tbody>
                    {{/tissuesExist}}
                    {{#tissues}}
                       <tr role="row">
                           <td style="padding: 3px">{{tissueName}}</td>
                           <td style="border-right: 0; padding: 3px">{{value}}</td>
                       </tr>
                    {{/tissues}}
                    {{#tissuesExist}}
                     </tbody>
                    </table>
                    {{/tissuesExist}}
               </div>
            </div>




</script>




%{--Called from displayPhenotypeRecordsFromVariantQtlSearch--}%
<script id="dynamicPhenotypeTable"  type="x-tmpl-mustache">

    <table  class="table">
    {{#phenotypesExist}}
    <tr>
        <th  scope="row">Phenotypes</th>
        {{/phenotypesExist}}
        {{#uniquePhenotypes}}
            <th  scope="col">{{phenotypeName}}</th>
        {{/uniquePhenotypes}}
        {{#phenotypesExist}}
    </tr>
    {{/phenotypesExist}}

    {{#phenotypeVariantsExist}}
    <tr>
        <th  scope="row">Variants</th>
        {{/phenotypeVariantsExist}}
        {{#phenotypeVariantQtl}}
            <td >{{#variants}}
            <div>{{variantName}}</div>
            {{/variants}}
            </td>
        {{/phenotypeVariantQtl}}
        {{#phenotypeVariantsExist}}
    </tr>
    {{/phenotypeVariantsExist}}


    </table>
</script>



<script id="headerInteractivity"  type="x-tmpl-mustache">
 <span class="title-collapsed title-genetic-evidence">GENETIC EVIDENCE</span>
 <span class="effector-ui-wrapper">
  <span class="glyphicon glyphicon-resize-full expand-trigger" aria-hidden="true" title="View collapsed columns" onclick="expandColumns('genetic-evidence');"></span>
  <span class="glyphicon glyphicon-resize-small collapse-trigger inactive" aria-hidden="true" title="Collapse columns" onclick="collapseColumns('genetic-evidence');"></span>
  <span class="glyphicon glyphicon-move" aria-hidden="true" title="Drag and drop cell"></span>
  <span class="glyphicon glyphicon-step-backward" aria-hidden="true" title="Move cell to far left"></span>
  <span class="glyphicon glyphicon-step-forward" aria-hidden="true" title="Move cell to far right"></span>
  <span class="glyphicon glyphicon-sort" aria-hidden="true" title="Sort table by the column"></span>
  <span class="glyphicon glyphicon-cog" aria-hidden="true" title="Open column filter" onclick="openFilter('genetic-evidence');"></span>
 </span>
 <span class="options-icon"><span class="glyphicon glyphicon-option-vertical" aria-hidden="true"></span>
</script>





<g:render template="/templates/dynamicUi/geneFocus/GHDR" />
<g:render template="/templates/dynamicUi/geneFocus/FIR" />
<g:render template="/templates/dynamicUi/geneFocus/SKA" />
<g:render template="/templates/dynamicUi/geneFocus/MET" />
<g:render template="/templates/dynamicUi/geneFocus/DEP_GS" />
<g:render template="/templates/dynamicUi/geneFocus/DEP_GP" />
<g:render template="/templates/dynamicUi/geneFocus/ECA" />
<g:render template="/templates/dynamicUi/geneFocus/COL" />
<g:render template="/templates/dynamicUi/geneFocus/MOD" />
<g:render template="/templates/dynamicUi/geneFocus/EFF" />