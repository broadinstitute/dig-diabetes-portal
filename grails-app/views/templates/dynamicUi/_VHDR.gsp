<script id="dynamicVariantTableHeader"  type="x-tmpl-mustache">

        <div sortStrategy="alphabetical" sortField="-1"  sortTerm="{{name1}}" class="geneName text-center {{initialLinearIndex}}">
           <div class="geneHeaderShifters text-center">
               <span class="glyphicon glyphicon-step-backward" aria-hidden="true" onclick="mpgSoftware.dynamicUi.shiftColumnsByOne(event,this,'backward','table.combinedGeneTableHolder')"></span>
               <span class="glyphicon glyphicon-step-forward" aria-hidden="true" onclick="mpgSoftware.dynamicUi.shiftColumnsByOne(event,this,'forward','table.combinedGeneTableHolder')"></span>
           </div>
           <div class="pull-right">
               <span class="glyphicon glyphicon-remove" aria-hidden="true" onclick="mpgSoftware.dynamicUi.removeColumn(event,this,'forward','table.combinedGeneTableHolder')" style="padding: 0 8px 0 0"></span>
           </div>
           <span class="displayGeneName">{{name}}</span>
        </div>
        <div class="genePosition text-center">
        
        </div>


</script>