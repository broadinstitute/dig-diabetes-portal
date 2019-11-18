<script id="variantPosteriorPValueCategoryLabel"  type="x-tmpl-mustache">
<div class="phenotypeRelatedData associationLabel initialLinearIndex_{{indexInOneDimensionalArray}}">
Association
</div>
</script>

<script id="variantPosteriorPValueSubcategoryLabel"  type="x-tmpl-mustache">
<div class="phenotypeRelatedData staticValuesLabelInTissueTable initialLinearIndex_{{indexInOneDimensionalArray}}" sortField=5>
posterior prob
<g:helpText title="tissueTable.DEPICT.help.header" placement="bottom" body="tissueTable.DEPICT.help.text"/>
</div>
</script>

<script id="variantPosteriorPValueBody"  type="x-tmpl-mustache">
    <div  class="phenotypeRelatedData initialLinearIndex_{{indexInOneDimensionalArray}} text-center" sortfield="{{posteriorPValue}}">
    {{posteriorPValueDisplayable}}
    </div>
</script>