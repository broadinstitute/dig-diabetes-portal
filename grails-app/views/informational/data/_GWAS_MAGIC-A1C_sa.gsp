<script class="panel-body" id="GWAS_MAGIC-A1C_sa_script" type="x-tmpl-mustache">

           <h4><g:message code="informational.shared.headers.dataset"></g:message></h4>


<p>Download URL: <a href="https://www.magicinvestigators.org/downloads/" target="_blank">https://www.magicinvestigators.org/downloads/</a></p>

<h4><g:message code="informational.shared.headers.publications"></g:message></h4>

<p><div class="paper">  <g:message code="informational.shared.publications.Wheeler_2017_PLoSMed"></g:message><br>
<g:message code="informational.shared.publications.Wheeler_2017_PLoSMed.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
<div class="citation"><g:message code="informational.shared.publications.Wheeler_2017_PLoSMed.citation"></g:message></div>  
</div></p>


<h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
<ul>
    <li><g:message code="informational.shared.traits.HbA1c"></g:message></li>
</ul>

<h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>

<table class="table table-condensed table-responsive table-striped">

    <tr><th>Samples</th><th>Cohort<small> (Click to view exclusion criteria)</small></th><th>Ancestry</th></tr>

    <tr><td>1,687</td><td><a onclick="showSection(event)">LOLIPOP_IA317</a>

    <div style="display: none;" class="cohortDetail">
    <table border="1">

    <tr><th>Exclusion criteria</th></tr>
    <tr>
    <td valign="top">
<ul>
<li>diabetes</li>
<li>fasting glucose &ge; 7 mmol/l</li>
</ul>
</td>
        </table>
    </div></td><td>South Asian</td></tr>


    <tr><td>1,146</td><td><a onclick="showSection(event)">LOLIPOP_IA610_cases</a>

    <div style="display: none;" class="cohortDetail">
    <table border="1">

    <tr><th>Exclusion criteria</th></tr>
    <tr>
    <td valign="top">
<ul>
<li>diabetes</li>
<li>fasting glucose &ge; 7 mmol/l</li>
</ul>
</td>
        </table>
    </div></td><td>South Asian</td></tr>

   <tr><td>2,753</td><td><a onclick="showSection(event)">LOLIPOP_IA610_controls</a>

    <div style="display: none;" class="cohortDetail">
    <table border="1">

    <tr><th>Exclusion criteria</th></tr>
    <tr>
    <td valign="top">
<ul>
<li>diabetes</li>
<li>fasting glucose &ge; 7 mmol/l</li>
</ul>
</td>
        </table>
    </div></td><td>South Asian</td></tr>

  <tr><td>482</td><td><a onclick="showSection(event)">LOLIPOP_IA_P</a>

    <div style="display: none;" class="cohortDetail">
    <table border="1">

    <tr><th>Exclusion criteria</th></tr>
    <tr>
    <td valign="top">
<ul>
<li>diabetes</li>
<li>fasting glucose &ge; 7 mmol/l</li>
</ul>
</td>
        </table>
    </div></td><td>South Asian</td></tr>

  <tr><td>1,726</td><td><a onclick="showSection(event)">Singapore SINDI</a>

    <div style="display: none;" class="cohortDetail">
    <table border="1">

    <tr><th>Exclusion criteria</th></tr>
    <tr>
    <td valign="top">
<ul>
<li>diabetes history and diabetes medication</li>
<li>HbA1c &ge; 6.5%</li>
</ul>
</td>
        </table>
    </div></td><td>South Asian</td></tr>

  <tr><td>1,302</td><td><a onclick="showSection(event)">The Pakistan Risk Of Myocardial Infarction Study (PROMIS)</a>

    <div style="display: none;" class="cohortDetail">
    <table border="1">

    <tr><th>Exclusion criteria</th></tr>
    <tr>
    <td valign="top">
<ul>
<li>diabetes</li>
<li>hospitalization in the previous 2-3 months prior to blood sampling</li>
</ul>
</td>
        </table>
    </div></td><td>South Asian</td></tr>

</table>

<h4><g:message code="informational.shared.headers.project"></g:message></h4>


<p><img src="${resource(dir: 'images/organizations', file: 'MAGIC_logo.png')}" style="width: 130px; margin-right: 15px"
        align="left">
</p>

<p><g:message code="informational.project.descr.MAGIC"></g:message></p>
<br />
<br />
<br />



<h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>

<p><g:message code="informational.data.MAGIC_HbA1c.exptsumm"></g:message></p>



<h4>Accessing MAGIC HbA1c GWAS results</h4>


   <p><g:message code="informational.data.accessing.MAGIC_HbA1c1"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.MAGIC_HbA1c2"></g:message></p>



</script>