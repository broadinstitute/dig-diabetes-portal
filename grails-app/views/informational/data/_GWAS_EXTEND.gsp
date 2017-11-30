<script class="panel-body" id="GWAS_EXTEND_script" type="x-tmpl-mustache">

    %{--<h4><g:message code="informational.shared.headers.publications"></g:message></h4>--}%

    %{--<p><div class="paper">--}%
    %{--<g:message code="informational.shared.publications.author_year_journal"></g:message><br>--}%
    %{--<g:message code="informational.shared.publications.author_year_journal.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>--}%
    %{--<div class="citation"><g:message code="informational.shared.publications.author_year_journal.citation"></g:message> </div>--}%
    %{--</div></p>--}%


    <h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
    <p><g:message code="pheno.help.text"></g:message></p>

    <ul>
    <li><g:message code="informational.shared.traits.t2d"></g:message></li>
    <li><g:message code="informational.shared.traits.alt"></g:message></li>
    <li><g:message code="informational.shared.traits.alk-phos"></g:message></li>
    <li><g:message code="informational.shared.traits.bilirubin"></g:message></li>
    <li><g:message code="informational.shared.traits.diastolicBP"></g:message></li>
    <li><g:message code="informational.shared.traits.fat_percent"></g:message></li>
    <li><g:message code="informational.shared.traits.HbA1c"></g:message></li>
    <li><g:message code="informational.shared.traits.potassium"></g:message></li>
    <li><g:message code="informational.shared.traits.sodium"></g:message></li>
    <li><g:message code="informational.shared.traits.systolicBP"></g:message></li>
    <li><g:message code="informational.shared.traits.urea"></g:message></li>
    <li><g:message code="informational.shared.traits.waist_hip_ratio"></g:message></li>
    <li><g:message code="informational.shared.traits.weight"></g:message></li>
    </ul>

    <h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>

    <table class="table table-condensed table-responsive table-striped">
    <tr><th>Cases</th><th>Controls</th><th>Cohort</th><th>Ancestry</th></tr>

    <tr><td>1,395</td><td>5,764</td><td>EXTEND</td><td>European</td></tr>
    </table>


    <h4><g:message code="informational.shared.headers.project"></g:message></h4>
<p><img src="${resource(dir: 'images/organizations', file: 'EXTEND_LOGO.png')}" style="width: 200px; margin-right: 15px"
        align="left">
</p>
    <p><g:message code="informational.data.project.EXTEND"></g:message></p>

    <h4><g:message code="informational.shared.headers.ack"></g:message></h4>
   <p><g:message code="informational.data.funding.EXTEND"></g:message></p>

<h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
<p><g:message code="informational.data.exptsumm.EXTEND"></g:message></p>

    <h4>Accessing EXTEND GWAS data</h4>
    <p><g:message code="informational.data.accessing.EXTEND1"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.EXTEND2"></g:message></p>



</script>