<h4><g:message code="variantSearch.dataTypes.title" default="See variants from any combination of data types" /></h4>
<div class="row clearfix">
    <div class="col-md-6">
        <div id="datatypes-form">
<g:if test="${show_sigma}">
            <div class="radio">
                <label>
                    <input id="id_datatype_sigma" type="radio" name="datatype" value="sigma" />
                    <g:message code="variantSearch.dataTypes.sigmaSequencing" default="SIGMA sequencing" />
                </label>
            </div>
</g:if>
<g:if test="${show_exseq}">
            <div class="radio">
                <label>
                    <input id="id_datatype_exomeseq" type="radio" name="datatype" value="exomeseq" checked />
                    <g:message code="variantSearch.dataTypes.exomeSequencing" default="exome sequencing" />
                </label>
            </div>
</g:if>
<g:if test="${show_exchp}">
            <div class="radio">
                <label>
                    <input id="id_datatype_exomechip" type="radio" name="datatype" value="exomechip" />
                    <g:message code="variantSearch.dataTypes.exomeChipStudies" default="exome chip" />
                </label>
            </div>
</g:if>
<g:if test="${show_gwas}">
            <div class="radio">
                <label>
                    <input id="id_datatype_gwas" type="radio" name="datatype" value="gwas" />
                    <g:message code="variantSearch.dataTypes.diagramGwas" default="DIAGRAM GWAS" />
                </label>
            </div>
</g:if>
        </div>
    </div>
    <div class="col-md-6">

        <g:renderSigmaSection>
            <g:message code="variantSearch.dataTypes.sigmaHelpText" default="Select SIGMA to see results" />
        </g:renderSigmaSection>
        <g:renderNotSigmaSection>
            <g:message code="variantSearch.dataTypes.exomeSequencingHelpText" default="Select exome sequencing data" />
        </g:renderNotSigmaSection>



    </div>
</div>
