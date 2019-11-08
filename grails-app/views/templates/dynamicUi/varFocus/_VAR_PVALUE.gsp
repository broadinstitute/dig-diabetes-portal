<script id="variantPValueCategoryLabel"  type="x-tmpl-mustache">
<div class="phenotypeRelatedData associationLabel initialLinearIndex_{{indexInOneDimensionalArray}}">
Association
</div>
</script>

<script id="variantPValueSubcategoryLabel"  type="x-tmpl-mustache">
<div class="phenotypeRelatedData staticValuesLabelInTissueTable initialLinearIndex_{{indexInOneDimensionalArray}}" sortField=6>
pValue
<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/>
</div>
</script>

<script id="variantPValueBody"  type="x-tmpl-mustache">
    <div  class="phenotypeRelatedData initialLinearIndex_{{indexInOneDimensionalArray}} text-center" sortfield="{{pValue}}">
    {{pValueDisplayable}}
    </div>
</script>