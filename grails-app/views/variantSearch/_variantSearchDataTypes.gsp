<h4>See variants from any combination of data types</h4>
<div class="row clearfix">
    <div class="col-md-6">
        <div id="datatypes-form">
<g:if test="${show_sigma}">
            <div class="radio">
                <label>
                    <input id="id_datatype_sigma" type="radio" name="datatype" value="sigma" />
                    SIGMA sequencing
                </label>
            </div>
</g:if>
<g:if test="${show_exseq}">
            <div class="radio">
                <label>
                    <input id="id_datatype_exomeseq" type="radio" name="datatype" value="exomeseq" />
                    exome sequencing studies of type 2 diabetes
                </label>
            </div>
</g:if>
<g:if test="${show_exchp}">
            <div class="radio">
                <label>
                    <input id="id_datatype_exomechip" type="radio" name="datatype" value="exomechip" />
                    exome chip studies of type 2 diabetes
                </label>
            </div>
</g:if>
<g:if test="${show_gwas}">
            <div class="radio">
                <label>
                    <input id="id_datatype_gwas" type="radio" name="datatype" value="gwas" />
                    DIAGRAM GWAS data for type 2 diabetes
                </label>
            </div>
</g:if>
        </div>
    </div>
    <div class="col-md-6">
        Select exome sequencing data (n≈13,000) to see every variant in an exon (or less than 50bp upstream of an exon) across ~95 percent of the genome. Select exome chip data (n≈82,000) to see ~80 percent of low-frequency non-synonymous variants (>.5 percent minor allele frequency) in Europeans, as well as common variants associated with T2D at genome-wide significance as of 2012. Select GWAS data (n≈69,000) to access results from DIAGRAM-3, the largest current GWAS dataset for type 2 diabetes.
    </div>
</div>
