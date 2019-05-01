
<script id="depictGeneSetTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="depictGeneSetTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
p={{significanceValueAsString}} ({{recordDescription}})
</script>


<script id="depictGeneSetSubCategory"  type="x-tmpl-mustache">
     <div significance_sortfield='{{index}}' class='subcategory initialLinearIndex_{{indexInOneDimensionalArray}}'
      sortField='{{index}}' subSortField='-1'>
     {{#dataAnnotation}}
          {{displaySubcategory}}
          <g:helpText title="gene.DEPICTsets.help.header" placement="bottom" body="gene.DEPICTsets.help.text"/>
     {{/dataAnnotation}}
    </div>
</script>


<script id="depictGeneSetBody"  type="x-tmpl-mustache">

             <div significance_sortField="{{significanceValue}}" sortField={{numberOfRecords}}
             class="tissueCategory_{{tissueCategoryNumber}} significanceCategory_{{significanceCategoryNumber}} {{initialLinearIndex}}">
               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'DEPICT gene set containing {{geneName}}',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander"
               data-target="#depict_geneset_{{gene}}" style="color:black">{{cellPresentationString}}</a>
               <div  class="collapse openDepictGeneSetInGeneTable" id="depict_geneset_{{gene}}">
                    {{#recordsExist}}
                    <table class="expandableDrillDownTable openDepictGeneSetInGeneTable">
                     <thead>
                      <tr role="row">
                        <th class="text-center leftMostCol">pathway ID</th>
                        <th class="text-center otherCols">description</th>
                        <th class="text-center otherCols">p-value</th>
                        <th class="text-center otherCols">genes</th>
                      </tr>
                     </thead>
                     <tbody>
                    {{/recordsExist}}
                    {{#data}}
                      <tr role="row">
                           <td class="leftMostCol">{{pathway_id}}</td>
                           <td class="otherCols">{{pathway_description}}</td>
                           <td class="otherCols">{{value}}</td>
                           <td class="otherCols">
                           <div>
                               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'DEPICT gene set',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander" data-target="#depict_geneset_d{{pathway_id_str}}" title="{{#gene_list}}{{.}},{{/gene_list}}">{{number_genes}} genes</a>
                               <div  class="collapse holdMultipleElements openTissues" id="depict_geneset_d{{pathway_id_str}}" >
                               <table class="expandableDrillDownTable">
                               <th class="onlyCol center-text">{{pathway_id}}</th>
                               <tbody>
                                 {{#gene_list}}
                                    <tr><td class="onlyCol center-text">{{.}}</td></tr>
                                 {{/gene_list}}
                               </tbody>
                               </table>
                               </div>
                           </div>
                           </td>
                       </tr>

                    {{/data}}
                    {{#recordsExist}}
                     </tbody>
                    </table>
                    {{/recordsExist}}
               </div>
            </div>
</script>
