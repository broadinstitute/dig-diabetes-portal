<script class="panel-body" id="GWAS_FUSIONonlyMetaboChip_script" type="x-tmpl-mustache">
    <h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>

    <ul>
        <li><g:message code="informational.shared.traits.t2d"></g:message></li>
        <li><g:message code="informational.shared.traits.t2dadjbmi"></g:message></li>
<li><g:message code="informational.shared.traits.fasting_glucose"></g:message></li>
<li><g:message code="informational.shared.traits.fasting_glucose_BMI"></g:message></li>
<li><g:message code="informational.shared.traits.fasting_insulin"></g:message></li>
<li><g:message code="informational.shared.traits.fasting_insulin_BMI"></g:message></li>
</ul>


    <h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>

    <table class="table table-condensed table-responsive table-striped">
        <tr><th>Cases</th><th>Controls</th><th>Cohort</th><th>Ancestry</th></tr>

        <tr><td>943</td><td>1,220</td><td>Finland-United States Investigation of NIDDM Genetics Study (FUSION)</td><td>European</td></tr>
    </table>

    <h4><g:message code="informational.shared.headers.project"></g:message></h4>

    <p><g:message code="informational.data.project.FUSION"></g:message></p>



<h4><g:message code="informational.shared.headers.ack"></g:message></h4>
<p><g:message code="informational.data.funding.FUSION"></g:message>

<h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
<p><g:message code="informational.data.exptsumm.FUSION1"></g:message></p>
<p><g:message code="informational.data.exptsumm.FUSION2"></g:message></p>
<p><g:message code="informational.data.exptsumm.FUSION3"></g:message></p>


<h4><g:message code="informational.shared.headers.overview"></g:message></h4>
<p><g:message code="informational.data.overview.FUSION_Metabochip1"></g:message></p>
<p><g:message code="informational.data.overview.FUSION_Metabochip2"></g:message></p>
<p><g:message code="informational.data.overview.FUSION_Metabochip3"></g:message></p>

<h4><g:message code="informational.shared.headers.reports"></g:message></h4>

<p>Genotype Data Quality Control Report (<a href="https://s3.amazonaws.com/broad-portal-resources/AMP-DCC_Quality_Control_Report_FUSION.pdf" target="_blank">download PDF</a>)</p>

<p>AMP-DCC Data Analysis Report (<a href="https://s3.amazonaws.com/broad-portal-resources/AMP_DCC_Data_Analysis_Report_FUSION_Phase1.pdf" target="_blank">download PDF</a>)</p>


<h4>Accessing FUSION Metabochip GWAS data</h4>
<p><g:message code="informational.data.accessing.FUSION1"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.FUSION2"></g:message></p>


</script>