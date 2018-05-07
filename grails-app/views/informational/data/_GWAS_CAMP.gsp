<script class="panel-body" id="GWAS_CAMP_script" type="x-tmpl-mustache">

<h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
    <ul>
        <li><g:message code="informational.shared.traits.t2d"></g:message></li>
<li><g:message code="informational.shared.traits.fasting_glucose"></g:message></li>
<li><g:message code="informational.shared.traits.fasting_insulin"></g:message></li>
</ul>

    <h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>

    <table class="table table-condensed table-responsive table-striped">
        <tr><th>Cases</th><th>Controls</th><th>Cohort</th><th>Ancestry</th></tr>

        <tr><td>540</td><td>2,913</td><td><a onclick="showSection(event)">Massachusetts General Hospital Cardiology and Metabolic Patient cohort (CAMP MGH)</a>

            <div style="display: none;" class="cohortDetail">
                <table border="1">
                    <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
                    <tr>
                        <td valign="top">Healthcare provider diagnosis of type 2 diabetes</td>
                        <td valign="top">No healthcare provider diagnosis of type 2 diabetes</td></tr>
                </table>
            </div></td><td>Mixed</td></tr>
    </table>
    <h4>Project</h4>

    <p><g:message code="informational.data.project.CAMP"></g:message></p>

<h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
<p><g:message code="informational.data.exptsumm.CAMP"></g:message></p>

<h4><g:message code="informational.shared.headers.overview"></g:message></h4>
<p><g:message code="informational.data.overview.CAMP1"></g:message></p>
<p><g:message code="informational.data.overview.CAMP2"></g:message></p>
<p><g:message code="informational.data.overview.CAMP3"></g:message></p>
<p><g:message code="informational.data.overview.CAMP4"></g:message></p>
<p><g:message code="informational.data.overview.CAMP5"></g:message></p>
<p><g:message code="informational.data.overview.CAMP6"></g:message></p>

<h4><g:message code="informational.shared.headers.reports"></g:message></h4>

<p>AMP-DCC Data Analysis Report (<a href="https://s3.amazonaws.com/broad-portal-resources/AMP-DCC_Data_Analysis_Report_CAMP_Phase1_2017_0207.pdf" target="_blank">download PDF</a>)</p>
<p>Genotype Data Quality Control Report (<a href="https://s3.amazonaws.com/broad-portal-resources/AMP_T2DKP_CAMP_QC_Results.pdf" target="_blank">download PDF</a>)</p>

<h4>Accessing CAMP GWAS data</h4>
<p><g:message code="informational.data.accessing.CAMP"></g:message></p>

</script>
