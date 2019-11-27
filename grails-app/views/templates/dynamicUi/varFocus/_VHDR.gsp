<script id="dynamicVariantTableHeader"  type="x-tmpl-mustache">

        <div sortStrategy="variantFocus" sortField="-1"  sortTerm="{{name1}}" class="variantHeaderHolder text-center {{initialLinearIndex}}">
           <div class="variantHeaderShifters text-center">
               <span class="glyphicon glyphicon-remove" aria-hidden="true" onclick="mpgSoftware.dynamicUi.removeColumn(event,this,'forward','#mainVariantDiv table.variantTableHolder','#mainVariantDivHolder')" ></span>
               <span class="glyphicon glyphicon-step-backward" aria-hidden="true" onclick="mpgSoftware.dynamicUi.shiftColumnsByOne(event,this,'backward','#mainVariantDiv table.variantTableHolder','#mainVariantDivHolder')"></span>
               <span class="glyphicon glyphicon-step-forward" aria-hidden="true" onclick="mpgSoftware.dynamicUi.shiftColumnsByOne(event,this,'forward','#mainVariantDiv table.variantTableHolder','#mainVariantDivHolder')"></span>

           </div>
           <div class="pull-left displayVariantNameHolder">
           <span class="displayVariantName">{{name}}</span>
           </div>
        </div>
        <div class="genePosition text-center">
        
        </div>


</script>