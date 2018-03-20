<script class="panel-body" id="GWAS_VHIR_script" type="x-tmpl-mustache">





<h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
<ul>

<li><g:message code="informational.shared.traits.ischemic_stroke"></g:message></li>
<li><g:message code="informational.shared.traits.toast_Cardio-aortic_embolism"></g:message></li>
<li><g:message code="informational.shared.traits.toast_Large_artery_atherosclerosis"></g:message></li>
<li><g:message code="informational.shared.traits.toast_Other_Undetermined"></g:message></li>
</ul>

<h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>

<table class="table table-condensed table-responsive table-striped">
<tr><th>Cohort</th><th>Cases</th><th>Controls</th><th>Ancestry</th></tr>

<tr><td>VHIR-FMT-Barcelona</td><td>515</td><td>316</td><td>European</td></tr>

 </table>

<h4><g:message code="informational.shared.headers.project"></g:message></h4>
<p><g:message code="informational.data.project.VHIR"></g:message></p>


<h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
<p><g:message code="informational.data.exptsumm.VHIR"></g:message></p>

<h4>Accessing VHIR FMT 2018 data</h4>
<p><g:message code="informational.data.accessing.VHIR"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.VHIR2"></g:message></p>


</script>