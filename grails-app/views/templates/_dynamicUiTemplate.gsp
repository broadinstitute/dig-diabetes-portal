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




<script id="dynamicEqtlVariantTableBodySummaryRecord"  type="x-tmpl-mustache">
     <div class="summaryVariantRecord {{category}}" geneNumber={{geneNumber}}  tissueNumber={{tissueNumber}}>
     <div>G:{{geneNumber}}</div>
     <div>T:{{tissueNumber}}</div>
     </div>
</script>




<script id="dynamicEqtlVariantTableBody"  type="x-tmpl-mustache">

{{#.}}
     <div class="variantRecordExists {{category}}" value={{value}}  geneName="{{geneName}}">
     {{geneName}}
     {{value}}
     </div>
{{/.}}

</script>


<script id="dynamicVariantHeader"  type="x-tmpl-mustache">

            {{variantName}}

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
      <div>{{valueToDisplay}}</div>
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




%{--a new and reduced form of dynamicGeneTable initially for displayRefinedModContext--}%
<script id="dynamicGeneTableHeader"  type="x-tmpl-mustache">

            {{name}}

</script>

<script id="dynamicGeneTableBody"  type="x-tmpl-mustache">


            {{#mods}}
                <div>
                    {{modName}}
                </div>
            {{/mods}}




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

                <div>
                    <div><a data-toggle="collapse" data-target="#tissues_{{geneName}}">tissues={{numberOfTissues}}</a>
                      <div  class="collapse holdMultipleElements openTissues" id="tissues_{{geneName}}">
                           {{#tissues}}
                              <div>{{tissueName}}</div>
                           {{/tissues}}
                           <div id="tooltip_tissues_{{geneName}}"></div>
                           <div id="graphic_tissues_{{geneName}}"></div>
                      </div>
                    </div>
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
            <div><a data-toggle="collapse" data-target="#tissues_{{geneName}}">tissues={{numberOfTissues}}</a>
               <div  class="collapse holdMultipleElements openTissues" id="tissues_{{geneName}}">
                    {{#tissues}}
                       <div>{{.}}</div>
                    {{/tissues}}
                    <div id="tooltip_tissues_{{geneName}}"></div>
                    <div id="graphic_tissues_{{geneName}}"></div>
               </div>
            </div>
            <div><a data-toggle="collapse" data-target="#phenotypes_{{geneName}}">phenotypes={{numberOfPhenotypes}}</a>
               <div  class="collapse holdMultipleElements" id="phenotypes_{{geneName}}">
                    {{#phenotypes}}
                       <div>{{.}}</div>
                    {{/phenotypes}}
               </div>
            </div>
            <div><a data-toggle="collapse" data-target="#varId_{{geneName}}">variants={{numberOfVariants}}</a>
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
            <div><a data-toggle="collapse" data-target="#tissues_{{tissueName}}">phenotypes={{numberOfPhenotypes}}</a>
               <div  class="collapse holdMultipleElements" id="tissues_{{tissueName}}">
                    {{#phenotypes}}
                       <div>{{.}}</div>
                    {{/phenotypes}}
               </div>
            </div>
            <div><a data-toggle="collapse" data-target="#genes_{{tissueName}}">genes={{numberOfGenes}}</a>
               <div  class="collapse holdMultipleElements" id="genes_{{tissueName}}">
                    {{#genes}}
                       <div>{{.}}</div>
                    {{/genes}}
               </div>
            </div>
            <div><a data-toggle="collapse" data-target="#varId_{{tissueName}}">variants={{numberOfVariants}}</a>
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
            <div><a data-toggle="collapse" data-target="#tissues_{{phenotypeName}}">tissues={{numberOfTissues}}</a>
               <div  class="collapse holdMultipleElements" id="tissues_{{phenotypeName}}">
                    {{#tissues}}
                       <div>{{.}}</div>
                    {{/tissues}}
               </div>
            </div>
            <div><a data-toggle="collapse" data-target="#genes_{{phenotypeName}}">genes={{numberOfGenes}}</a>
               <div  class="collapse holdMultipleElements" id="genes_{{phenotypeName}}">
                    {{#genes}}
                       <div>{{.}}</div>
                    {{/genes}}
               </div>
            </div>
            <div><a data-toggle="collapse" data-target="#varId_{{phenotypeName}}">variants={{numberOfVariants}}</a>
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
            <div><a data-toggle="collapse" data-target="#genes_{{tissueName}}">genes={{numberOfGenes}}</a>
               <div  class="collapse holdMultipleElements" id="genes_{{tissueName}}">
                    {{#gene}}
                       <div>{{.}}</div>
                    {{/gene}}
               </div>
            </div>

            <div><a data-toggle="collapse" data-target="#experiments_{{tissueName}}">experiments={{numberOfExperiments}}</a>
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
            <th  scope="col"><div class="geneName">{{geneName}}</div><div class="genePosition">chromosome {{chrom}}: {{regionStart}}-{{regionEnd}}</div></th>
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
            <div><a data-toggle="collapse" data-target="#tissues_{{geneName}}">tissues={{numberOfTissues}}</a>
               <div  class="collapse holdMultipleElements openTissues" id="tissues_{{geneName}}">
                    <div id="tooltip_tissues_{{geneName}}"></div>
                    <div id="graphic_tissues_{{geneName}}"></div>
               </div>
            </div>

            <div><a data-toggle="collapse" data-target="#experiments_{{geneName}}">experiments={{numberOfExperiments}}</a>
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

            <div class="geneName">{{name1}}</div><div class="genePosition">chromosome {{chromosome}}: {{addrStart}}-{{addrEnd}}</div>

</script>






%{--Called from displayGenesFromAbc--}%
<script id="dynamicAbcGeneTableHeader"  type="x-tmpl-mustache">

            <div class="geneName">{{geneName}}</div><div class="genePosition">chromosome {{chrom}}: {{regionStart}}-{{regionEnd}}</div>

</script>
<script id="dynamicAbcGeneTableBody"  type="x-tmpl-mustache">

            <div><a data-toggle="collapse" data-target="#tissues_{{geneName}}">tissues={{numberOfTissues}}</a>
               <div  class="collapse holdMultipleElements openTissues" id="tissues_{{geneName}}">
                    <div id="tooltip_tissues_{{geneName}}"></div>
                    <div id="graphic_tissues_{{geneName}}"></div>
               </div>
            </div>

            <div><a data-toggle="collapse" data-target="#experiments_{{geneName}}">experiments={{numberOfExperiments}}</a>
               <div  class="collapse holdMultipleElements" id="experiments_{{geneName}}">
                    {{#experiment}}
                       <div>{{.}}</div>
                    {{/experiment}}
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

