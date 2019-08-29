<script class="panel-body" id="GWAS_METSIM_eu_script" type="x-tmpl-mustache">

 <h4><g:message code="informational.shared.headers.dataset"></g:message></h4>

<p><g:message code="informational.data.overlaps.GoT2D_WGS"></g:message></p>

<h4><g:message code="informational.shared.headers.publications"></g:message></h4>

<p><div class="paper">
<g:message code="informational.shared.publications.Laakso_2017_JLipidRes"></g:message><br>
<g:message code="informational.shared.publications.Laakso_2017_JLipidRes.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
<div class="citation"><g:message code="informational.shared.publications.Laakso_2017_JLipidRes.citation"></g:message> </div>
</div></p>



    <h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
    <h5><g:message code="informational.shared.headers.phase1"></g:message></h5>

    <ul>
        <li><g:message code="informational.shared.traits.t2d"></g:message></li>
        <li><g:message code="informational.shared.traits.t2dadjbmi"></g:message></li>
        <li><g:message code="informational.shared.traits.fasting_glucose"></g:message></li>
        <li><g:message code="informational.shared.traits.fasting_glucose_BMI"></g:message></li>
        <li><g:message code="informational.shared.traits.fasting_insulin"></g:message></li>
        <li><g:message code="informational.shared.traits.fasting_insulin_BMI"></g:message></li>
        <li><g:message code="informational.shared.traits.HbA1c"></g:message></li>
        <li><g:message code="informational.shared.traits.HbA1c_BMI"></g:message></li>
</ul>
<h5><g:message code="informational.shared.headers.phase2"></g:message></h5>

<ul>
        <li><g:message code="informational.shared.traits.serum_creatinine"></g:message></li>
        <li><g:message code="informational.shared.traits.systolicBP"></g:message></li>
        <li><g:message code="informational.shared.traits.HDL_cholesterol"></g:message></li>
        <li><g:message code="informational.shared.traits.eGFR-creat"></g:message></li>
        <li><g:message code="informational.shared.traits.diastolicBP"></g:message></li>
        <li><g:message code="informational.shared.traits.LDL_cholesterol"></g:message></li>
        <li><g:message code="informational.shared.traits.BMI"></g:message></li>
</ul>



    <h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>

    <table class="table table-condensed table-responsive table-striped">
        <tr><th>Cases</th><th>Controls</th><th>Cohort <small>(Click to view selection criteria for cases and controls)</small></th><th>Ancestry</th></tr>

        <tr><td>1,185</td><td>7,357</td><td><a onclick="showSection(event)">METSIM (METabolic Syndrome In Men)</a>

            <div style="display: none;" class="cohortDetail">
                <table border="1">
                    <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
                    <tr>
                        <td valign="top">
                        <ul>
                        <li>Males, age 45-73</li>
                        <li>Type 2 diabetic</li>
                        </ul>
                        </td>
                        <td valign="top">
                        <ul>
                        <li>Males, age 45-73</li>
                        <li>Non-diabetic</li>
                        <li>Control group includes 5,832 individuals with normal glucose tolerance (NGT)</li>
                        </ul>
                        </td>
                    </tr>
                </table>
            </div></td><td>European</td></tr>
    </table>
    <h4><g:message code="informational.shared.headers.project"></g:message></h4>

    <p><g:message code="informational.data.project.METSIM"></g:message></p>


<h4><g:message code="informational.shared.headers.ack"></g:message></h4>
<p><g:message code="informational.data.funding.METSIM"></g:message>

<h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>

<p><g:message code="informational.data.exptsumm.METSIM1"></g:message></p>
<p><g:message code="informational.data.exptsumm.METSIM2"></g:message></p>


<h4><g:message code="informational.shared.headers.overview"></g:message></h4>
<p><g:message code="informational.data.overview.METSIM0"></g:message></p>
<p><g:message code="informational.data.overview.METSIM1"></g:message></p>
<p><g:message code="informational.data.overview.METSIM2"></g:message>
<p><g:message code="informational.data.overview.METSIM2a"></g:message>
<p><g:message code="informational.data.overview.METSIM3"></g:message>
<p><g:message code="informational.data.overview.METSIM4"></g:message>
<p><g:message code="informational.data.overview.METSIM5"></g:message>
<p><g:message code="informational.data.overview.METSIM6"></g:message>
<p><g:message code="informational.data.overview.METSIM7"></g:message>
<p><g:message code="informational.data.overview.METSIM8"></g:message>
<p><g:message code="informational.data.overview.METSIM9"></g:message>
<p><g:message code="informational.data.overview.METSIM10"></g:message>


<h4><g:message code="informational.shared.headers.reports"></g:message></h4>

<p><g:message code="informational.data.reports.QCR_METSIM"></g:message></p>
<p><g:message code="informational.data.reports.DAR1_METSIM"></g:message></p>
<p><g:message code="informational.data.reports.DAR2_METSIM"></g:message></p>

<h4>Accessing METSIM GWAS results</h4>
<p><g:message code="informational.data.accessing.METSIM_GWAS1"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.METSIM_GWAS2"></g:message></p>





</script>
