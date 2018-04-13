<script class="panel-body" id="GWAS_Oxford_GoDARTS_script" type="x-tmpl-mustache">

    <h4><g:message code="informational.shared.headers.publications"></g:message></h4>

    <p><div class="paper">
    <g:message code="informational.shared.publications.Hébert_2017_IntJEpidemiol"></g:message><br>
    <g:message code="informational.shared.publications.Hébert_2017_IntJEpidemiol.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
    <div class="citation"><g:message code="informational.shared.publications.Hébert_2017_IntJEpidemiol.citation"></g:message> </div>
    </div></p>


    <h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
    <p><g:message code="pheno.help.text"></g:message></p>

    <ul>
    <li><g:message code="informational.shared.traits.BMI"></g:message></li>
    <li><g:message code="informational.shared.traits.cholesterol"></g:message></li>
    <li><g:message code="informational.shared.traits.HDL_cholesterol"></g:message></li>
    <li><g:message code="informational.shared.traits.LDL_cholesterol"></g:message></li>
    <li><g:message code="informational.shared.traits.log_tg"></g:message></li>
    </ul>

    %{--<h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>--}%

    %{--<table class="table table-condensed table-responsive table-striped">--}%
    %{--<tr><th>Cases</th><th>Controls</th><th>Cohort <small>(Click to view selection criteria for cases and controls)</small></th><th>Ancestry</th></tr>--}%

    %{--<tr><td>nnn</td><td>nnn</td><td><a onclick="showSection(event)">cohort</a>--}%

    %{--<div style="display: none;" class="cohortDetail">--}%
    %{--<table border="1">--}%
    %{--<tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>--}%
    %{--<tr>--}%
    %{--<td valign="top">criteria</td>--}%
    %{--<td valign="top">criteria</td></tr>--}%
    %{--</table>--}%
    %{--</div></td><td>Mixed</td></tr>--}%
    %{--</table>--}%


    <h4><g:message code="informational.shared.headers.project"></g:message></h4>

<p><img src="${resource(dir: 'images/organizations', file: 'GoDARTS_logo-300x35.png')}" style="width: 200px; margin-right: 15px"
        align="left">
</p>
    <p><g:message code="informational.data.project.GoDARTS"></g:message></p>

<h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
<p><g:message code="informational.data.exptsumm.GoDARTS"></g:message></p>

    <h4>Accessing GoDARTS Affymetrix GWAS data</h4>
    <p><g:message code="informational.data.accessing.GoDARTS1"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.GoDARTS2"></g:message></p>



</script>