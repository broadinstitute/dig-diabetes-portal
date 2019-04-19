
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
                     <div>{{gene}}</div>
                    <table class="openDepictGeneSetInGeneTable" style="border: 0">
                     <thead>
                      <tr role="row">
                        <th style="border-top: 0;" class="text-center">pathway ID</th>
                        <th style="border-top: 0;" class="text-center">description</th>
                        <th style="border-top: 0;" class="text-center">p-value</th>
                        <th style="border-top: 0;" class="text-center">genes</th>
                      </tr>
                     </thead>
                     <tbody>
                    {{/recordsExist}}
                    {{#data}}
                      <tr role="row">
                           <td style="padding: 3px">{{pathway_id}}</td>
                           <td style="padding: 3px">{{pathway_description}}</td>
                           <td style="padding: 3px">{{pvalue_str}}</td>
                           <td style="padding: 3px">
                           <div>
                               <a onclick="mpgSoftware.dynamicUi.showAttachedData(event,'DEPICT gene set',mpgSoftware.dynamicUi.extractStraightFromTarget)" class="cellExpander" data-target="#depict_geneset_d{{pathway_id_str}}" title="{{#gene_list}}{{.}},{{/gene_list}}">{{number_genes}} genes</a>
                               <div  class="collapse holdMultipleElements openTissues" id="depict_geneset_d{{pathway_id_str}}" >
                               <table width=50>
                               <th>{{pathway_id}}</th>
                               <tbody>
                                 {{#gene_list}}
                                    <tr><td class="text-center">{{.}}</td></tr>
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
