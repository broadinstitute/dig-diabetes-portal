

<script class="panel-body" id="GWAS_70kForT2D_script" type="x-tmpl-mustache">


<h4><g:message code="informational.shared.headers.dataset"></g:message></h4>
<p><g:message code="informational.data.download.70KforT2D"></g:message></p>
<p><g:message code="informational.data.overlaps.70KforT2D"></g:message></p>

<h4><g:message code="informational.shared.headers.publications"></g:message></h4>

<p><div class="paper">
<g:message code="informational.shared.publications.Bonas-Guarch_2017_NatCommun"></g:message><br>
<g:message code="informational.shared.publications.Bonas-Guarch_2017_NatCommun.author"></g:message>
<g:message code="informational.shared.publications.etal"></g:message>
<div class="citation"><g:message code="informational.shared.publications.Bonas-Guarch_2017_NatCommun.citation"></g:message> </div>
</div></p>

<h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
<ul>
    <li><g:message code="informational.shared.traits.t2d"></g:message></li>
</ul>

<h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>

<table class="table table-condensed table-responsive table-striped">
    <tr><th>Cases</th><th>Controls</th><th>Cohort <small>(Click to view selection criteria for cases and controls)</small></th><th>Ancestry</th></tr>

    <tr><td>556</td><td>614</td><td><a onclick="showSection(event)">Northwestern NUGENE</a>

        <div style="display: none;" class="cohortDetail">
            <table border="1">
                <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
                <tr>
                    <td valign="top"><ul>
                        <li>Identification of patients who already have a T2D diagnosis:</li>
                        <ul>
                            <li>Include patients with Type 2 Diabetes diagnosis based on ICD9 code (excluding those with ketoacidosis codes).</li>
                            <li>Exclude patients (currently) treated only with insulin AND have never been on a type 2 diabetes medication, and: diagnosed with T1D, or even if not diagnosed with T1D, diagnosed with T2D on &lt; 2 dates in an encounter or problem list.</li>
                        </ul>
                        <li>Identification of patients who do not yet have a T2D diagnosis:</li>
                        <ul>
                            <li>Include patients with haemoglobin A1C lab value &ge; 6.5%, fasting glucose &gt; 125 mg/dl or random glucose &gt; 200 mg/dl AND prescribed one of the medications (or combinations thereof) sulfonylureas, meglitinides, biguanides, thiazoldinediones, alpha-glycosidase inhibitors, DPPIV inhibitor and injectable.</li>
                        </ul>
                        <li>Exclude patients with T1D diagnosis codes (ICD-9 250.x1 or 250.x3)</li>
                    </ul></td>
                    <td valign="top"><ul>
                        <li>Have had at least 2 clinic visits (face-to-face outpatient clinic encounters).</li>
                        <li>Have not been assigned an ICD9 code for diabetes (type 1 or type 2) or any diabetes-related condition.</li>
                        <li>Have not been prescribed insulin or Pramlintide, or any medications for diabetes treatment, or diabetic supplies such as those for medication administration or glucose monitoring.</li>
                        <li>Do not have a reported (random or fasting) blood glucose &ge; 110mg/dl and have had at least 1 glucose measurement.</li>
                        <li>Do not have a reported haemoglobin A1c &ge; 6.0%.</li>
                        <li>Do not have a reported family history of diabetes (type 1 or type 2).</li>
                        <li>Exclude patients with T1D diagnosis codes (ICD-9 250.x1 or 250.x3)</li>
                    </ul></td></tr>
            </table>
        </div></td><td>European</td></tr>

    <tr><td>919</td><td>787</td><td><a onclick="showSection(event)">Finland-United States Investigation of NIDDM Genetics (FUSION)</a>

        <div style="display: none;" class="cohortDetail">
            <table border="1">
                <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
                <tr>
                    <td valign="top"><ul>
                        <li>644 FUSION and 275 Finrisk 2002 T2D cases as defined by WHO 1999 criteria of fasting plasma glucose &ge; 7.0 mmol/l or 2-h plasma glucose &ge; 11.1 mmol/l, by report of diabetes medication use, or based on medical record review.</li>
                        <li>The 644 FUSION cases reported at least one T2D sibling.</li>
                        <li>The Finrisk cases came from a Finnish population-based risk factor survey.
                        </li>
                    </ul>
                    </td>
                    <td valign="top"><ul>
                        <li>331 FUSION and 456 Finrisk 2002 NGT controls as defined by WHO 1999 criteria of fasting glucose &lt; 6.1 mmol/l and 2-h glucose &lt; 7.8 mmol/l.</li>
                        <li>FUSION controls include 119 subjects from Vantaa, Finland, who were NGT at ages 65 and 70 years, and 212 NGT spouses of FUSION subjects. The controls were approximately frequency matched to the cases by age, sex, and birth province.</li>
                    </ul></td></tr>
            </table>
        </div></td><td>European</td></tr>

    <tr><td>1,894</td><td>2,917</td><td><a onclick="showSection(event)">Wellcome Trust Case Control Consortium (WTCCC)</a>

        <div style="display: none;" class="cohortDetail">
            <table border="1">
                <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
                <tr>
                    <td valign="top">The T2D cases were selected from UK Caucasian subjects who form part of the Diabetes UK Warren 2 repository. In each case, the diagnosis of diabetes was based on either current prescribed treatment with sulphonylureas, biguanides, other oral agents and/or insulin or, in the case of individuals treated with diet alone, historical or contemporary laboratory evidence of hyperglycaemia (as defined by the World Health Organization). Other forms of diabetes (for example, maturity-onset diabetes of the young, mitochondrial diabetes, and T1D) were excluded by standard clinical criteria based on personal and family history. Criteria for excluding autoimmune diabetes included absence of first-degree relatives with T1D, an interval of &ge; 1 years between diagnosis and institution of regular insulin therapy and negative testing for antibodies to glutamic acid decarboxylase (anti-GAD). Cases were limited to those who reported that all four grandparents had exclusively British and/or Irish origin, by both self-reported ethnicity and place of birth. All were diagnosed between age 25 and 75. Approximately 30% were explicitly recruited as part of multiplex sibships and &sim;25% were offspring in parent-offspring 'trios' or 'duos' (that is, families comprising only one parent complemented by additional sibs). The remainder were recruited as isolated cases but these cases were (compared to population-based cases) of relatively early onset and had a high proportion of T2D parents and/or siblings. Cases were ascertained across the UK but were centralized on the main collection centres (Exeter, London, Newcastle, Norwich, Oxford). Selection of the samples typed in WTCCC from the larger collections was based primarily on DNA availability and success in passing Diabetes and Inflammation Laboratory (DIL)/Wellcome Trust Sanger Institute (WTSI) DNA quality control.</td>
                    <td valign="top"><ul>
                        <li>The 1958 Birth Cohort (also known as the National Child Development Study) includes all births in England, Wales and Scotland, during one week in 1958. From an original sample of over 17,000 births, survivors were followed up at ages 7, 11, 16, 23, 33 and 42 years (http://www.cls.ioe.ac.uk/studies.asp?section=000100020003). In a biomedical examination at 44-45 years (http://www.b58cgene.sgul.ac.uk/followup.php), 9,377 cohort members were visited at home providing 7,692 blood samples with consent for future Epstein-Barr virus (EBV)-transformed cell lines. DNA samples extracted from 1,500 cell lines of self-reported white ethnicity and representative of gender and each geographical region were selected for use as controls.</li>
                        <li>The second set of common controls was made up of 1,500 individuals selected from a sample of blood donors recruited as part of the current project. WTCCC in collaboration with the UK Blood Services (NHSBT in England, SNBTS in Scotland and WBS in Wales) set up a UK national repository of de-identified samples of DNA and viable mononuclear cells from 3,622 consenting blood donors, age range 18-69 years (ethical approval 05/Q0106/74). A set of 1,564 samples was selected from the 3622 samples recruited based on sex and geographical region (to reproduce the distribution of the samples of the 1958 Birth Cohort) for use as common controls in the WTCCC study. DNA was extracted as described elsewhere with a yield of 3054 &plusmn; 1207 &#956;g (mean &plusmn; 1 s.d.).</li>
                    </ul></td></tr>
            </table>
        </div></td><td>European</td></tr>

    <tr><td>2,614</td><td>3,061</td><td><a onclick="showSection(event)">GENEVA Genes and Environment Initiatives in Type 2 Diabetes (Nurses' Health Study/Health Professionals Follow-up Study) GENEVA NHS/HPFS</a>

        <div style="display: none;" class="cohortDetail">
            <table border="1">
                <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
                <tr>
                    <td valign="top"><p>Through 1996 follow-up, criteria for confirmed T2D included one of the following:
                        <ul>
                            <li>One or more classic symptoms (excessive thirst, polyuria, weight loss, hunger, pruritus, or coma) plus fasting plasma glucose &ge; 140 mg/dl (7.8 mmol/L) and/or random plasma glucose &ge; 200 mg/dl (11.1 mmol/L) and/or plasma glucose 2 hours after an oral glucose tolerance test &ge; 200 mg/dl; or</li>
                            <li>At least two elevated plasma glucose levels (as described above) on different occasions in the absence of symptoms; or</li>
                            <li>Treatment with hypoglycaemic medication (insulin or oral hypoglycaemic agent).</li>
                        </ul></p>
                        <p>In response to the current ADA diagnostic criteria (fasting plasma glucose cut point &ge; 126 mg/dl [7.0 mmol/L]), Supplementary Diabetes Questionnaire for participants reporting a new diagnosis of diabetes on the 1998 or later questionnaires were revised. This revised supplementary questionnaire ascertains the level of elevation in fasting plasma glucose and facilitates determining which participants had fasting plasma glucose &ge; 140 mg/dl (the earlier diagnostic cut point) and which had a fasting plasma glucose &ge; 126 (the current diagnostic cut point). The criteria for confirmed T2D during the 1998–2000 follow-up cycle and later cycles remain the same, except for the elevated fasting plasma glucose criterion for which the cut point was changed from 140 mg/dl to 126 mg/dl. The revised supplementary questionnaire was used to classify cases in categories of glucose elevation and determine the proportion diagnosed in each category (e.g. fasting plasma glucose 126–139 versus &ge; 140 mg/dl) allowing conducting sensitivity analyses with exclusion of participants that meet the ADA criteria and not the NDDG criteria.</p></td>
                    <td valign="top">No diabetes mellitus.</td></tr>
            </table>
        </div></td><td>European</td></tr>

    <tr><td>6,995</td><td>49,845</td><td><a onclick="showSection(event)">Resource for Genetic Epidemiology Research on Adult Health and Aging (GERA)</a>

        <div style="display: none;" class="cohortDetail">
            <table border="1">
                <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
                <tr>
                    <td valign="top">Each participant was coded as a patient for T2D if he/she had at least two diagnoses within this disease category that had to be recorded on separate days. Diagnoses were obtained from patient encounters at Kaiser Permanente Northern California facilities from January 1, 1995 to March 15, 2013. The March 2013 ICD9-CM diagnoses used for the Type 2 Diabetes category were:
                        <ul>
                            <li>250.00 Diabetes mellitus without mention of complication, type II or unspecified type, not stated as uncontrolled.</li>
                            <li>250.02 Diabetes mellitus without mention of complication, type II or unspecified type, uncontrolled.</li>
                            <li>250.10 Diabetes with ketoacidosis, type II or unspecified type, not stated as uncontrolled.</li>
                            <li>250.12 Diabetes with ketoacidosis, type II or unspecified type, uncontrolled.</li>
                            <li>250.20 Diabetes with hyperosmolarity, type II or unspecified type, not stated as uncontrolled.</li>
                            <li>250.22 Diabetes with hyperosmolarity, type II or unspecified type, uncontrolled.</li>
                            <li>250.30 Diabetes with other coma, type II or unspecified type, not stated as uncontrolled.</li>
                            <li>250.32 Diabetes with other coma, type II or unspecified type, uncontrolled.</li>
                            <li>250.40 Diabetes with renal manifestations, type II or unspecified type, not stated as uncontrolled.</li>
                            <li>250.42 Diabetes with renal manifestations, type II or unspecified type, uncontrolled.</li>
                            <li>250.50 Diabetes with ophthalmic manifestations, type II or unspecified type, not stated as uncontrolled.</li>
                            <li>250.52 Diabetes with ophthalmic manifestations, type II or unspecified type, uncontrolled.</li>
                            <li>250.60 Diabetes with neurological manifestations, type II or unspecified type, not stated as uncontrolled.</li>
                            <li>250.62 Diabetes with neurological manifestations, type II or unspecified type, uncontrolled.</li>
                            <li>250.70 Diabetes with peripheral circulatory disorders, type II or unspecified type, not stated as uncontrolled.</li>
                            <li>250.72 Diabetes with peripheral circulatory disorders, type II or unspecified type, uncontrolled.</li>
                            <li>250.80 Diabetes with other specified manifestations, type II or unspecified type, not stated as uncontrolled.</li>
                            <li>250.82 Diabetes with other specified manifestations, type II or unspecified type, uncontrolled.</li>
                            <li>250.90 Diabetes with unspecified complication, type II or unspecified type, not stated as uncontrolled.</li>
                            <li>250.92 Diabetes with unspecified complication, type II or unspecified type, uncontrolled.</li>
                        </ul></td>
                    <td valign="top">The rest of subjects not coded as T2D patients were considered as controls.</td></tr>
            </table>
        </div></td><td>European</td></tr>
</table>

<h4><g:message code="informational.shared.headers.project"></g:message></h4>
<p><img src="${resource(dir: 'images/organizations', file: 'Logo_70K_mayus_forT2D_lines-3.png')}" style="width: 200px; margin-right: 15px"
        align="left">
</p>

<p><g:message code="informational.data.project.70KforT2D"></g:message></p>

<h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
<p><g:message code="informational.data.exptsumm.70KforT2D"></g:message></p>


<h4>Accessing 70KforT2D GWAS data</h4>

<p><g:message code="informational.data.accessing.70KforT2D"></g:message></p>


<h4>External Links to 70KforT2D GWAS data</h4>
<p><g:message code="informational.data.download.70KforT2D"></g:message></p>
<p><g:message code="informational.data.external.70KforT2D1"></g:message></p>
<p><g:message code="informational.data.external.70KforT2D2"></g:message></p>
</script>
