<script class="panel-body" id="AMPLOAD_10_mdv1_script" type="x-tmpl-mustache">

    <h4><g:message code="informational.shared.headers.publications"></g:message></h4>

    <p><div class="paper">
    <g:message code="informational.shared.publications.Karpe_2017_IntJEpidemiol"></g:message><br>
    <g:message code="informational.shared.publications.Karpe_2017_IntJEpidemiol.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
    <div class="citation"><g:message code="informational.shared.publications.Karpe_2017_IntJEpidemiol.citation"></g:message> </div>
    </div></p>

<p><g:message code="informational.shared.projectpublications.Oxford"></g:message></p>

    <h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
    <p><g:message code="pheno.help.text"></g:message></p>

    <ul>
    <li><g:message code="informational.shared.traits.BMI"></g:message></li>
    <li><g:message code="informational.shared.traits.cholesterol"></g:message></li>
    <li><g:message code="informational.shared.traits.HDL_cholesterol"></g:message></li>
    <li><g:message code="informational.shared.traits.LDL_cholesterol"></g:message></li>
    <li><g:message code="informational.shared.traits.log_tg"></g:message></li>
    </ul>

    <h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>

       <table class="table table-condensed table-responsive table-striped">
        <tr><th>Cases</th><th>Controls</th><th>Cohort</th><th>Ancestry</th></tr>

        <tr><td>0</td><td>7,193</td><td><a onclick="showSection(event)">Oxford BioBank</a>

            <div style="display: none;" class="cohortDetail">
                <table border="1">
                    <tr><th>Control selection criteria</th></tr>
                    <tr>
                        <td valign="top">Healthy Caucasians between the ages of 30 to 50 recruited from the Oxfordshire area.</td></tr>
                </table>
            </div>

            </td><td><g:message code="metadata.European"></g:message></td></tr>
    </table>

    <h4><g:message code="informational.shared.headers.project"></g:message></h4>
    <p><img src="${resource(dir: 'images/organizations', file: 'Oxford_BioBank_logo_Web.png')}" style="width: 100px; margin-right: 15px"
        align="left">
    <p><g:message code="informational.data.project.OxfordBB"></g:message></p>



    <h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
    <p><g:message code="informational.data.exptsumm.OxBB_Axiom"></g:message></p>



    <h4>Accessing Oxford BioBank Axiom GWAS GWAS data</h4>
    <p><g:message code="informational.data.accessing.OxBB_Axiom1"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.OxBB_Axiom2"></g:message></p>



</script>
