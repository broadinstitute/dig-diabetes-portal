

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

<g:render template="/templates/variantTableTemplate" />
<g:render template="/templates/dynamicUi/varFocus/VHDR" />
<g:render template="/templates/dynamicUi/varFocus/ABC_VAR" />
<g:render template="/templates/dynamicUi/varFocus/DNASE_VAR" />
<g:render template="/templates/dynamicUi/varFocus/K27AC_VAR" />
<g:render template="/templates/dynamicUi/varFocus/TFBS_VAR" />
<g:render template="/templates/dynamicUi/varFocus/VAR_CODING" />
<g:render template="/templates/dynamicUi/varFocus/VAR_SPLICE" />
<g:render template="/templates/dynamicUi/varFocus/VAR_UTR" />
<g:render template="/templates/dynamicUi/varFocus/VAR_PVALUE" />
<g:render template="/templates/dynamicUi/varFocus/VAR_POSTERIOR" />
<g:render template="/templates/dynamicUi/varFocus/CHROMESTATE_VAR" />
<g:render template="/templates/dynamicUi/varFocus/GREGOR_VAR" />
<g:render template="/templates/dynamicUi/varFocus/TFMOTIF_VAR" />