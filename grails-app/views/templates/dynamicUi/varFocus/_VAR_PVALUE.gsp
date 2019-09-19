<script id="variantPValueCategoryLabel"  type="x-tmpl-mustache">
<div class="initialLinearIndex_{{indexInOneDimensionalArray}}">
Association
</div>
</script>

<script id="variantPValueSubcategoryLabel"  type="x-tmpl-mustache">
<div class="staticValuesLabelInTissueTable initialLinearIndex_{{indexInOneDimensionalArray}}">
pValue
<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/>
</div>
</script>

<script id="variantPValueBody"  type="x-tmpl-mustache">
    <div  class="initialLinearIndex_{{indexInOneDimensionalArray}}">
    {{pValueDisplayable}}
    </div>
</script>