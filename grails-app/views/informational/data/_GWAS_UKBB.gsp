<script class="panel-body" id="GWAS_UKBB_script" type="x-tmpl-mustache">





<h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
<ul>

<li></li>
<li></li>
<li></li>
</ul>

<h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>

<table class="table table-condensed table-responsive table-striped">
<tr><th>Cohort</th><th>Cases</th><th>Controls</th><th>Ancestry</th></tr>



 </table>

<h4><g:message code="informational.shared.headers.project"></g:message></h4>
<p><g:message code="informational.data.project.sleep"></g:message></p>


<h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
<p><g:message code="informational.data.exptsumm.sleep"></g:message></p>

<h4>Accessing UK Biobank Sleep Traits GWAS data</h4>
<p><g:message code="informational.data.accessing.sleep"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.VHIR2"></g:message></p>


</script>