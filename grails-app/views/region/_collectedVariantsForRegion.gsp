<p><em>For variants that do not reach significance, odds ratios may be unreliable.</em></p>


<table id="variantTable" class="table table-striped basictable">
    <thead>
        <tr>
<g:if test="${show_gene}">
<th></th>
</g:if>
<th></th>
<th></th>
<th></th>
<th></th>
<g:if test="${show_sigma}">
<th colspan="5" class="datatype-header">SIGMA</th>
</g:if>
<g:if test="${show_exseq}">
<th colspan="5" class="datatype-header">exome sequencing</th>
</g:if>
<g:if test="${show_exchp}">
<th colspan="2" class="datatype-header">exome chip</th>
</g:if>
<th colspan="2" class="datatype-header">DIAGRAM</th>
</tr>
<tr>
<g:if test="${show_gene}"><th>nearest gene</th></g:if>
    <th>variant</th>
    <th>rsid</th>
    <th>protein change</th>
    <th>effect on protein</th>
<g:if test="${show_sigma}">
    <th style="min-width: 80px;">source</th>
    <th style="min-width: 80px;">p-value</th>
    <th style="min-width: 80px;">odds ratio</th>
    <th>case/control</th>
    <th>frequency</th>
</g:if>
<g:if test="${show_exseq}">
    <th style="min-width: 80px;">p-value</th>
    <th style="min-width: 80px;">odds ratio</th>
    <th>case/control</th>
    <th>highest frequency</th>
    <th>population with highest frequency</th>
</g:if>
<g:if test="${show_exchp}">
    <th style="min-width: 80px;">p value</th>
    <th style="min-width: 80px;">odds ratio</th>
</g:if>
    <th style="min-width: 80px;">p value</th>
    <th style="min-width: 80px;">odds ratio</th>
</tr>
</thead>
<tbody id="variantTableBody">
</tbody>
</table>