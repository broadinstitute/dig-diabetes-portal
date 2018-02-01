<script class="panel-body" id="GWAS_DCSP2_script" type="x-tmpl-mustache">

    <h4><g:message code="informational.shared.headers.publications"></g:message></h4>

    <p><div class="paper">
    <g:message code="informational.shared.publications.Sim_2011_PLoSGenet"></g:message><br>
    <g:message code="informational.shared.publications.Sim_2011_PLoSGenet.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
    <div class="citation"><g:message code="informational.shared.publications.Sim_2011_PLoSGenet.citation"></g:message> </div>
    </div></p>


    <h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
    <p><g:message code="pheno.help.text"></g:message></p>

    <ul>
        <li><g:message code="informational.shared.traits.t2d"></g:message></li>
    </ul>

    <h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>

    <table class="table table-condensed table-responsive table-striped">

    <tr><th>Cases</th><th>Controls</th><th>Cohort<small>(Click to view selection criteria for cases and controls)</small></th><th>Ancestry</th></tr>

    <tr><td>2,007</td><td>0</td><td><a onclick="showSection(event)">Diabetic Cohort (DC)</a>

    <div style="display: none;" class="cohortDetail">
    <table border="1">
    <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
    <tr>
    <td valign="top">Physician diagnosis of T2D</td>
    <td valign="top">n/a</td></tr>
    </table>
    </div></td><td>East Asian</td></tr>

    <tr><td>0</td><td>1,944</td><td><a onclick="showSection(event)">Singapore Prospective Study Program (SP2)</a>

    <div style="display: none;" class="cohortDetail">
    <table border="1">
    <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
    <tr>
    <td valign="top">n/a</td>
    <td valign="top">No prior history of diabetes, fasting glucose level &le; 6.0 mmol/L</td></tr>
    </table>
    </div></td><td>East Asian</td></tr>


    </table>


    <h4><g:message code="informational.shared.headers.project"></g:message></h4>

    <p><g:message code="informational.data.project.DC_SP2"></g:message></p>

<h4><g:message code="informational.shared.headers.ack"></g:message></h4>
<p><g:message code="informational.data.ack.DC_SP2"></g:message></p>

    <h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
    <p><g:message code="informational.data.exptsumm.DC_SP2-1"></g:message></p>
    <p><g:message code="informational.data.exptsumm.DC_SP2-2"></g:message></p>
    <p><g:message code="informational.data.exptsumm.DC_SP2-3"></g:message></p>


    <h4>Accessing Diabetic Cohort-Singapore Prospective Study Program GWAS data</h4>
    <p><g:message code="informational.data.accessing.DC_SP2-1"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.DC_SP2-2"></g:message></p>


</script>
