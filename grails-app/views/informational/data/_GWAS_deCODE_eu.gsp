<script class="panel-body" id="GWAS_DeCODE_eu_script" type="x-tmpl-mustache">

                    <h4><g:message code="informational.shared.headers.dataset"></g:message></h4>

<p><g:message code="informational.data.download.deCODE"></g:message></p>

            <h4><g:message code="informational.shared.headers.publications"></g:message></h4>

        <p><div class="paper">
<g:message code="informational.shared.publications.Styrkarsdottir_2019_NatCommun"></g:message><br>
<g:message code="informational.shared.publications.Styrkarsdottir_2019_NatCommun.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
<div class="citation"><g:message code="informational.shared.publications.Styrkarsdottir_2019_NatCommun.citation"></g:message> </div>
</div></p>

<h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
<ul>
<li><g:message code="metadata.TotHipArea"></g:message></li>
<li><g:message code="metadata.FNarea"></g:message></li>
<li><g:message code="metadata.TrochanterArea"></g:message></li>
<li><g:message code="metadata.IntertrochArea"></g:message></li>
<li><g:message code="metadata.LSarea"></g:message></li>
</ul>


%{--<h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>--}%
    %{--<table class="table table-condensed table-responsive table-striped">--}%

%{--<tr><th>Samples</th><th>Cohort</th><th>Ancestry</th></tr>--}%
%{--<tr><td>426,824</td><td>UK Biobank</td><td><European</td></tr>--}%



    %{--</table>--}%



    <h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
<p><g:message code="informational.data.exptsumm.deCODE"></g:message></p>

   <h4>Accessing Bone size GWAS results</h4>
<p><g:message code="informational.data.accessing.deCODE1"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.deCODE2"></g:message></p>



</script>