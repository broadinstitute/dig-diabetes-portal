<script class="panel-body" id="GWAS_BBJ_ea_script" type="x-tmpl-mustache">

                <h4><g:message code="informational.shared.headers.dataset"></g:message></h4>

<p><g:message code="informational.data.download.BBJ"></g:message></p>

            <h4><g:message code="informational.shared.headers.publications"></g:message></h4>

        <p><div class="paper">
<g:message code="informational.shared.publications.Kanai_2018_NatGenet"></g:message><br>
<g:message code="informational.shared.publications.Kanai_2018_NatGenet.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
<div class="citation"><g:message code="informational.shared.publications.Kanai_2018_NatGenet.citation"></g:message> </div>
</div></p>

<h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
<ul>
<li><g:message code="metadata.eBMD"></g:message></li>
<li><g:message code="metadata.Fracture"></g:message></li>
</ul>

metadata.ALT=Alanine transaminase
metadata.ALP=Alkaline phosphatase
metadata.AST=Aspartate aminotransferase
metadata.AF=Atrial fibrillation
metadata.BILIRUBIN=Bilirubin
metadata.BUN=Blood urea nitrogen
metadata.BMI=BMI
metadata.Ca=Calcium
metadata.Cl=Chloride
metadata.CHOL=Cholesterol
metadata.CK=Creatine kinase
metadata.Creatinine=Creatinine
metadata.DBP=Diastolic blood pressure
metadata.eGFRcrea=eGFR-creat (serum creatinine)
metadata.Fbg=Fibrinogen
metadata.GGT=Gamma-glutamyl transferase
metadata.HBA1C=HbA1c
metadata.Hb=Hemoglobin
metadata.HDL=HDL cholesterol
metadata.LDH=Lactate dehydrogenase
metadata.LDL=LDL cholesterol
metadata.MAP=Mean arterial pressure
metadata.Men=Menarche
metadata.MP=Menopause
metadata.POAG=Open-angle glaucoma
metadata.P=Phosphorus
metadata.CRP=Plasma C-reactive protein
metadata.K=Potassium
metadata.PulsePress=Pulse pressure
metadata.BS=Random glucose
metadata.Alb=Serum albumin
metadata.Na=Sodium
metadata.SBP=Systolic blood pressure
metadata.TG=Triglycerides
metadata.T2D=Type 2 diabetes
metadata.UA=Uric acid







<h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>
    <table class="table table-condensed table-responsive table-striped">

<tr><th>Samples</th><th>Cohort</th><th>Ancestry</th></tr>
<tr><td>426,824</td><td>UK Biobank</td><td><European</td></tr>



    </table>

<h4><g:message code="informational.shared.headers.project"></g:message></h4>
<p><img src="${resource(dir: 'images/organizations', file: 'GEFOS_logo.png')}" style="width: 120px; margin-right: 15px"
        align="left">
</p>

<h4>Genetic Factors for Osteoporosis (GEFOS) Consortium <small><a href="http://www.gefos.org/" target="_blank">Learn more ></a></small></h4>
<p>&nbsp;</p>


    <h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
<p><g:message code="informational.data.exptsumm.GEFOS"></g:message></p>

   <h4>Accessing Genetic Factors for Osteoporosis Consortium GWAS results</h4>
<p><g:message code="informational.data.accessing.GEFOS1"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.GEFOS2"></g:message></p>


</script>