<script class="panel-body" id="GWAS_DIAMANTE-UKBB_eu_dv2_script" type="x-tmpl-mustache">


    <h4><g:message code="informational.shared.headers.publications"></g:message></h4>

    <p><div class="paper">
<g:message code="informational.shared.publications.Mahajan_2018b_NatGenet"></g:message><br>
<g:message code="informational.shared.publications.Mahajan_2018_NatGenet.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
<div class="citation"><g:message code="informational.shared.publications.Mahajan_2018b_NatGenet.citation"></g:message> </div>
</div></p>

<h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
<ul>
<li><g:message code="informational.shared.traits.t2d"></g:message></li>
</ul>

<h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>
    <table class="table table-condensed table-responsive table-striped">

<tr><th>Cases</th><th>Controls</th><th>Cohort</th><th>Ancestry</th></tr>




<tr><td>19,119</td><td>423,698</td><td><a onclick="showSection(event)">UK BioBank</a>

            <div style="display: none;" class="cohortDetail">
                <table border="1">
                    <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
                    <tr>
                        <td valign="top">
                            <ul>
                                <li>Prevalent T2D status was defined using self-reported medical history and medication in UK Biobank participants</li>
                            </ul>
                        </td>
                        <td valign="top">
                             <ul>
                                 <li>Control subjects were defined as those free of diabetes</li>
                            </ul>
                        </td></tr>
                </table>
            </div></td><td>White European</td></tr>



    </table>

    <h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
<p><g:message code="informational.data.exptsumm.DIAMANTE_ukbb1"></g:message></p>
<p><g:message code="informational.data.exptsumm.DIAMANTE2"></g:message></p>

   <h4>Accessing DIAMANTE GWAS data</h4>
<p><g:message code="informational.data.accessing.DIAMANTE1"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.DIAMANTE2"></g:message></p>



</script>