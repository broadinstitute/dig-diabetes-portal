<script id="gregorVariantTableNumberRecordsCellPresentationString"  type="x-tmpl-mustache">
records={{numberRecords}}
</script>

<script id="gregorVariantTableTissueHeaderLabel"  type="x-tmpl-mustache">
<div class="varAllEpigenetics varGregorEpigenetics variantEpigenetics initialLinearIndex_{{indexInOneDimensionalArray}}">Epigenetics</div>
</script>

<script id="gregorVariantTableRowHeaderLabel"  type="x-tmpl-mustache">
<div class="gregorSubTableHeader tissueId_{{safeTissueId}}"  sortValue="{{p_value}}">
<div><input class="gregorSubTableRowHeader" type="checkbox" value="{{safeTissueId}}"></div>{{tissue}}</div>
</script>

<script id="gregorSubTableHeaderHeader"  type="x-tmpl-mustache">
<div class="gregorSubTableRow annotationName_{{annotation}} methodName_{{method}} text-center" sortValue="{{p_value}}">
<div><input class="gregorSubTableRowHeader" type="checkbox" value="{{annotation}}_{{method}}"></div>
{{annotation}}</div>
</script>

<script id="gregorVariantTableSignificanceCellPresentationString"  type="x-tmpl-mustache">
{{significanceValueAsString}}No div!
</script>

<script id="gregorVariantTableBody"  type="x-tmpl-mustache">
 <div class="gregorVariantTableBody" sortField='{{p_value}}'>{{prettyPValue}}</div>
</script>
