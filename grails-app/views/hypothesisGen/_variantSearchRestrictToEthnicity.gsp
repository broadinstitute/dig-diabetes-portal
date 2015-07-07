<h4>Set allele frequencies (use only if searching exome sequence data)</h4>
<div class="row clearfix">
    <div class="col-md-6">
        <div id="frequencies-form">
       <g:if test="${show_exseq}">
           <g:alleleFrequencyRange></g:alleleFrequencyRange>
        </g:if>
        </div>
    </div>
    <div class="col-md-6" style="display: none">
      <g:if test="${show_exseq}">
        <p>
            Allele frequencies can vary widely by population, and some variants may influence disease risk in one population but not another.
            For instance, <a href="http://www.ncbi.nlm.nih.gov/pubmed/24390345">a set of five variants</a>
            in the gene <em>SLC16A11</em> is common in people of Native American ancestry and increases T2D risk in that population;
        however, the variants are low-frequency or rare in other ancestry groups,
        and appear to play little to no role in T2D in Europeans.
        Thus, <em>SLC16A11</em> was not implicated in early GWAS of type 2 diabetes, which focused on people of European ancestry.
        </p>
      </g:if>
    </div>
</div>

