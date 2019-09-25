
<script id="emptyBodyRecord"  type="x-tmpl-mustache">
                <div class="{{initialLinearIndex}} {{otherClasses}}" sortField=0 significance_sortfield='0.0'>
                {{constText}}
                </div>
</script>


<script id="emptyHeaderRecord"  type="x-tmpl-mustache">
     <div class="{{initialLinearIndex}} {{otherClasses}}" sortField="A">
                     <div>{{constText}}</div>
     </div>
</script>



<script id="sharedCategoryWriter"  type="x-tmpl-mustache">
     <div significance_sortfield='0' sortField='{{index}}' subSortField='-1' class='{{row.subcategory}} initialLinearIndex_{{indexInOneDimensionalArray}} categoryName'>
           <div class="geneAnnotationShifters text-center">
                <span class="glyphicon glyphicon-step-backward" aria-hidden="true" onclick="mpgSoftware.dynamicUi.shiftColumnsByOne(event,this,'backward','table.combinedGeneTableHolder')"></span>
                <span class="glyphicon glyphicon-step-forward" aria-hidden="true" onclick="mpgSoftware.dynamicUi.shiftColumnsByOne(event,this,'forward','table.combinedGeneTableHolder')"></span>
            </div>
     {{#dataAnnotation}}
          {{displayCategory}}
     {{/dataAnnotation}}
     </div>
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

