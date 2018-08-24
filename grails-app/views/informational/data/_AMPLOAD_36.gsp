<script class="panel-body" id="AMPLOAD_36_script" type="x-tmpl-mustache">

    <h4><g:message code="informational.shared.headers.publications"></g:message></h4>

    <p><div class="paper">
    <g:message code="informational.shared.publications.vanderHeijden_2017_BMJOpen"></g:message><br>
    <g:message code="informational.shared.publications.vanderHeijden_2017_BMJOpen.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
    <div class="citation"><g:message code="informational.shared.publications.vanderHeijden_2017_BMJOpen.citation"></g:message> </div>
    </div></p>


    <h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
    <p><g:message code="pheno.help.text"></g:message></p>

    <ul>
    <li><g:message code="informational.shared.traits.albumin"></g:message></li>
    <li><g:message code="informational.shared.traits.BMI"></g:message></li>
    <li><g:message code="informational.shared.traits.cholesterol"></g:message></li>
    <li><g:message code="informational.shared.traits.creatinine"></g:message></li>
    <li><g:message code="informational.shared.traits.diastolicBP"></g:message></li>
    <li><g:message code="informational.shared.traits.eGFR-creat"></g:message></li>
    <li><g:message code="informational.shared.traits.HDL_cholesterol"></g:message></li>
    <li><g:message code="informational.shared.traits.LDL_cholesterol"></g:message></li>
    <li><g:message code="informational.shared.traits.systolicBP"></g:message></li>
    <li><g:message code="informational.shared.traits.triglycerides"></g:message></li>
    <li><g:message code="informational.shared.traits.urinary_atc_ratio"></g:message></li>
    <li><g:message code="informational.shared.traits.urinary_creat"></g:message></li>
    </ul>


    <h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>

    <table class="table table-condensed table-responsive table-striped">
    <tr><th>Cases</th><th>Controls</th><th>Cohort <small>(Click to view selection criteria for cases and controls)</small></th><th>Ancestry</th></tr>

    <tr><td>3,414</td><td>0</td><td><a onclick="showSection(event)">Hoorn Diabetes Care System cohort</a>

    <div style="display: none;" class="cohortDetail">--}%
         <table border="1">
         <tr>
         <th>Case selection criteria</th>
         <th>Control selection criteria</th>
         </tr>
         <tr>
         <td valign="top">
             <ul>
             <li>Patients exhibited  one or more classic symptoms, including excessive thirst, polyuria, weight loss, hunger or pruritus, all in combination with elevated plasma glucose concentrations, either fasting plasma glucose &ge; 7.0 mmol/L or random plasma glucose &ge;11.1 mmol/L</li>
             <li>In the absence of symptoms, patients exhibited at least two elevated plasma glucose concentrations on two different occasions</li>
             <li> People with diabetes at the age of 40 years or younger who needed insulin within 4 weeks after the diagnosis of diabetes were excluded</li>
             </td>
         <td valign="top">N/A</td>
         </tr>
         </table>
    </div></td><td>European</td></tr>
    </table>


    <h4><g:message code="informational.shared.headers.project"></g:message></h4>
    <p><g:message code="informational.data.project.Hoornstudies"></g:message></p>

<h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
<p><g:message code="informational.data.exptsumm.Hoornstudies"></g:message></p>

    <h4>Accessing Hoorn DCS data</h4>
    <p><g:message code="informational.data.accessing.Hoornstudies1"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.Hoornstudies2"></g:message></p>

</script>
