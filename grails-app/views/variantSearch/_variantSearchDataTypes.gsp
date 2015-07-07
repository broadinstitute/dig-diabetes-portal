<h4><g:message code="variantSearch.dataTypes.title" default="See variants from any combination of data types" /></h4>
<div class="row clearfix">
    <div class="col-md-6">
        <div id="datatypes-form">
<g:if test="${show_exseq}">
            <div class="radio">
                <label>
                    <input id="id_datatype_exomeseq" type="radio" name="datatype" value="exomeseq" checked />
                    <g:message code="variantSearch.dataTypes.exomeSequencing" default="exome sequencing" />
                    <g:helpText title="variantSearch.dataTypes.sigmaSequencingQ.help.header"  qplacer="2px 0 0 6px 0 0" placement="right" body="variantSearch.dataTypes.sigmaSequencingQ.help.text"/>
                </label>
            </div>
</g:if>
<g:if test="${show_exchp}">
            <div class="radio">
                <label>
                    <input id="id_datatype_exomechip" type="radio" name="datatype" value="exomechip" />
                    <g:message code="variantSearch.dataTypes.exomeChipStudies" default="exome chip" />
                    <g:helpText title="variantSearch.dataTypes.sigmaSequencingQ.help.header"  qplacer="2px 0 0 6px 0 0" placement="right" body="variantSearch.dataTypes.sigmaSequencingQ.help.text"/>
                </label>
            </div>
</g:if>
<g:if test="${show_gwas}">
            <div class="radio">
                <label>
                    <input id="id_datatype_gwas" type="radio" name="datatype" value="gwas" />
                    <g:message code="variantSearch.dataTypes.diagramGwas" default="DIAGRAM GWAS" />
                    <g:helpText title="variantSearch.dataTypes.sigmaSequencingQ.help.header"  qplacer="2px 0 0 6px 0 0" placement="right" body="variantSearch.dataTypes.sigmaSequencingQ.help.text"/>
                </label>
            </div>
</g:if>
        </div>
    </div>
    <div class="col-md-6">

        <g:renderT2dGenesSection>
            <g:message code="variantSearch.dataTypes.exomeSequencingHelpText" default="Select exome sequencing data" />
        </g:renderT2dGenesSection>



    </div>
</div>
