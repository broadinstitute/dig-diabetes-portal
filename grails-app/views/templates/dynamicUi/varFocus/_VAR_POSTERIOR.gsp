<script id="variantPosteriorPValueCategoryLabel"  type="x-tmpl-mustache">
<div class="associationLabel initialLinearIndex_{{indexInOneDimensionalArray}}">
Association
</div>
</script>

<script id="variantPosteriorPValueSubcategoryLabel"  type="x-tmpl-mustache">
<div class="staticValuesLabelInTissueTable initialLinearIndex_{{indexInOneDimensionalArray}}">
posterior prob
<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/>
</div>
</script>

<script id="variantPosteriorPValueBody"  type="x-tmpl-mustache">
    <div  class="initialLinearIndex_{{indexInOneDimensionalArray}} text-center">
    {{posteriorPValueDisplayable}}
    </div>
</script>