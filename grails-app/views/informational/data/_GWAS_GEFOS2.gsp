<script class="panel-body" id="GWAS_GEFOS2_script" type="x-tmpl-mustache">

                    <h4><g:message code="informational.shared.headers.dataset"></g:message></h4>

<p><g:message code="informational.data.download.GEFOS2"></g:message></p>

            <h4><g:message code="informational.shared.headers.publications"></g:message></h4>

        <p><div class="paper">
<g:message code="informational.shared.publications.Estrada_2012_NatGenet"></g:message><br>
<g:message code="informational.shared.publications.Estrada_2012_NatGenet.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
<div class="citation"><g:message code="informational.shared.publications.Estrada_2012_NatGenet.citation"></g:message> </div>
</div></p>

<h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
<ul>
<li><g:message code="metadata.LSBMD"></g:message></li>
<li><g:message code="metadata.FNBMD"></g:message></li>
</ul>

<h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>
    <table class="table table-condensed table-responsive table-striped">

%{--<tr><th>Samples</th><th>Cohort</th><th>Ancestry</th></tr>--}%
%{--<tr><td>426,824</td><td>UK Biobank</td><td><European</td></tr>--}%
Table of cohort information coming soon!


    </table>

<h4><g:message code="informational.shared.headers.project"></g:message></h4>
<p><img src="${resource(dir: 'images/organizations', file: 'GEFOS_logo.png')}" style="width: 120px; margin-right: 15px"
        align="left">
</p>

<h4>Genetic Factors for Osteoporosis (GEFOS) Consortium <small><a href="http://www.gefos.org/" target="_blank">Learn more ></a></small></h4>
<p>&nbsp;</p>


    <h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
<p><g:message code="informational.data.exptsumm.GEFOS2"></g:message></p>

   <h4>Accessing GEFOS BMD GWAS results</h4>
<p><g:message code="informational.data.accessing.GEFOS21"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.GEFOS22"></g:message></p>


</script>