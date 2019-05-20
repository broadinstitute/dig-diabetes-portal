<script class="panel-body" id="GWAS_SIGMA1_script" type="x-tmpl-mustache">

<h4><g:message code="informational.shared.headers.dataset"></g:message></h4>
<p><g:message code="informational.data.download.sigma"></g:message>

<h4><g:message code="informational.shared.headers.publications"></g:message></h4>

                      <p><div class="paper">
<g:message code="informational.shared.publications.SIGMA_2014_Nature"></g:message><br>
<g:message code="informational.shared.publications.SIGMA_2014_Nature.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
<div class="citation"><g:message code="informational.shared.publications.SIGMA_2014_Nature.citation"></g:message> </div>
</div></p>

<p><div class="paper">
    <g:message code="informational.shared.publications.SIGMA_2014_JAMA"></g:message><br>
    <g:message code="informational.shared.publications.SIGMA_2014_JAMA.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
    <div class="citation"><g:message code="informational.shared.publications.SIGMA_2014_JAMA.citation"></g:message> </div>
</div></p>

<p><div class="paper">
    <g:message code="informational.shared.publications.Majithia_2014_PNAS"></g:message><br>
    <g:message code="informational.shared.publications.Majithia_2014_PNAS.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
    <div class="citation"><g:message code="informational.shared.publications.Majithia_2014_PNAS.citation"></g:message> </div>
</div></p>


<h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
<ul>
<li><g:message code="informational.shared.traits.t2d"></g:message></li>
</ul>

<h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>

<table class="table table-condensed table-responsive table-striped">
<tr><th>Cases</th><th>Controls</th><th>Cohort</th><th>Ancestry</th></tr>

    <tr><td>815</td><td>1138</td><td><a onclick="showSection(event)">UNAM/INCMNSZ Diabetes Study (UIDS)</a>
    <div style="display: none;" class="cohortDetail">
    <table border="1">
                <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
<tr>
<td valign="top">
<ul>
<li>ADA criteria: fasting plasma glucose values &ge;126 mg/dL, current treatment with a hypoglycemic agent, or casual glucose values &ge;200 mg/dL</li>
</ul>
</td>
<td valign="top">
<ul>
<li>Age &ge;45 years</li>
<li>fasting plasma glucose concentration < 100 mg/dl</li>
<li>no previous history of hyperglycemia, gestational diabetes or use of metformin</li>
</ul>
</td></tr>

            </table>
    </div></td><td>Latino</td></tr>

<tr><td>690</td><td>472</td><td><a onclick="showSection(event)">Diabetes in Mexico Study (DMS)</a>
<div style="display: none;" class="cohortDetail">
<table border="1">
                <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
<tr>
<td valign="top">
<ul>
<li>Age &ge;18 years</li>
<li>previous T2D diagnosis or fasting glucose levels above 125 mg/dL</li>
<li>excluded individuals with fasting glycemia between 100-125 mg/dL</li>
</ul>
</td>
<td valign="top">
<ul>
<li>Age &ge;45 years</li>
<li>fasting glucose levels below 100 mg/dL</li>
</ul>
</td></tr>
            </table>
</div></td><td>Latino</td></tr>

<tr><td>287</td><td>613</td><td><a onclick="showSection(event)">Mexico City Diabetes Study (MCDS)</a>
<div style="display: none;" class="cohortDetail">
<table border="1">
                <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
<tr>
<td valign="top">
<ul>
<li>age 35-64 years</li>
<li>non-pregnant females</li>
<li>T2D diagnosis and medication OR ADA criteria: Fasting glucose 126 mg/dL or more or 2 hr post 75 gr of glucose load 200 or more</li>
</ul>
</td>
<td valign="top">
<ul>
<li>age 35-64 years</li>
<li>non-pregnant females</li></ul>
</td></tr>

            </table>

</div></td><td>Latino</td></tr>

<tr><td>2056</td><td>2143</td><td><a onclick="showSection(event)">Multiethnic Cohort (MEC)</a>
<div style="display: none;" class="cohortDetail">
<table border="1">
                <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
<tr>
<td valign="top">
<ul>
<li>self-report of T2D diagnosis or medication</li>
<li>absence of T1D diagnosis</li>
</ul>
</td>
<td valign="top">
<ul>
<li>no self-report of T2D diagnosis or medication</li>
<li>no T1D or T2D diagnosis from the OSHPD, HMSA or KPH registries</li>
<ul>
</td></tr>

            </table>

</div></td><td>Latino</td></tr>

<tr><td>Total: 3,848</td><td>Total: 4,366</td><td></td><td></td></tr>
</table>

    <h4>Project</h4>
    <h5>Slim Initiative in Genomic Medicine for the Americas (SIGMA) <small><a href="${createLink(controller:"projects", action:"sigma")}" target="_blank">Learn more ></a>
    </small></h5>

    <p><g:message code="informational.data.project.SIGMA"></g:message></p>

   <h4>Accessing GWAS SIGMA data</h4>
<p><g:message code="informational.data.accessing.SIGMA"></g:message></p>
</script>

