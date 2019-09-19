<script id="variantPosteriorPValueCategoryLabel"  type="x-tmpl-mustache">
<div class="variantAnnotation initialLinearIndex_{{indexInOneDimensionalArray}}">
Association
</div>
</script>

<script id="variantPosteriorPValueSubcategoryLabel"  type="x-tmpl-mustache">
<div class="variantAnnotation staticValuesLabelInTissueTable initialLinearIndex_{{indexInOneDimensionalArray}}">
posterior p-value
<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/>
</div>
</script>

<script id="variantPosteriorPValueBody"  type="x-tmpl-mustache">
    <div  class="variantAnnotation  initialLinearIndex_{{indexInOneDimensionalArray}}">
    {{posteriorPValueDisplayable}}
    </div>
</script>