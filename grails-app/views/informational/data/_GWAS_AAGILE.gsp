<script class="panel-body" id="GWAS_AAGILE_script" type="x-tmpl-mustache">

    <h4><g:message code="informational.shared.headers.dataset"></g:message></h4>
<p><g:message code="informational.data.overlaps.AAGILE"></g:message></p>
<p><g:message code="informational.data.download.AAGILE"></g:message></p>
            <h4><g:message code="informational.shared.headers.publications"></g:message></h4>

        <p><div class="paper">
<g:message code="informational.shared.publications.Liu_2016_AMJHumGenet"></g:message><br>
<g:message code="informational.shared.publications.Liu_2016_AMJHumGenet.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
<div class="citation"><g:message code="informational.shared.publications.Liu_2016_AMJHumGenet.citation"></g:message> </div>
</div></p>

<h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
<ul>
<li><g:message code="informational.shared.traits.fasting_glucose"></g:message></li>
<li><g:message code="informational.shared.traits.fasting_insulin_BMI"></g:message></li>
</ul>

<h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>
    <table class="table table-condensed table-responsive table-striped">
<tr><th colspan="3">Samples in African American ancestry discovery cohorts</th></tr>
<tr><th>Samples</th><th>Cohort</th><th>Ancestry</th></tr>
 <tr><td>810</td><td>Health ABC</td><td>African American</td></tr>
<tr><td>1,024</td><td>HANDLS</td><td>African American</td></tr>
<tr><td>1,314</td><td>HUFS</td><td>African American</td></tr>
<tr><td>992</td><td>HyperGEN</td><td>African American</td></tr>
<tr><td>1,707</td><td>Jackson Heart Study</td><td>African American</td></tr>
<tr><td>1,341</td><td>MESA</td><td>African American</td></tr>
<tr><td>914</td><td>MESA Family</td><td>African American</td></tr>
<tr><td>1,114</td><td>SIGNET</td><td>African American</td></tr>
<tr><td>6,579</td><td>WHI</td><td>African American</td></tr>
    </table>

<h4><g:message code="informational.shared.headers.project"></g:message></h4>
<p><img src="${resource(dir: 'images/organizations', file: 'AAGILE_logo.png')}" style="width: 200px; margin-right: 15px"
        align="left">
</p>
<p><g:message code="informational.data.project.AAGILE"></g:message></p><br /><br />
    <h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
<p><g:message code="informational.data.exptsumm.AAGILE"></g:message></p>
<p><div class="paper">  <g:message code="informational.shared.publications.Manning_2012_NatGenet"></g:message><br>
    <g:message code="informational.shared.publications.Manning_2012_NatGenet.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
    <div class="citation"><g:message code="informational.shared.publications.Manning_2012_NatGenet.citation"></g:message></div>  
</div></p>

   <h4>Accessing AAGILE GWAS data</h4>
<p><g:message code="informational.data.accessing.AAGILE1"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.AAGILE2"></g:message></p>


</script>