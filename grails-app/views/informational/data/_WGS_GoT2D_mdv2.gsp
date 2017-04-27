<script class="panel-body" id = "WGS_GoT2D_mdv25_script" type="x-tmpl-mustache">
    <h4>Publication</h4>


    <p><div class="paper">
        <g:message code="informational.shared.publications.Fuchsberger_2016_Nature"></g:message><br>
        <g:message code="informational.shared.publications.Fuchsberger_2016_Nature.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
        <div class="citation"><g:message code="informational.shared.publications.Fuchsberger_2016_Nature.citation"></g:message> </div>
    </div></p>

    <h4>Dataset phenotypes</h4>
    <ul>
        <li><g:message code="informational.shared.traits.t2d"></g:message></li>
    </ul>
    <h4>Dataset subjects</h4>
    <table class="table table-condensed table-responsive table-striped">

        <tr><th>Cases</th><th>Controls</th><th>Cohort</th><th>Ancestry</th></tr>

        <tr><td>493</td><td>486</td><td><a onclick="showSection(event)">Finland-United States Investigation of NIDDM Genetics (FUSION) Study</a>
            <div style="display: none;" class="cohortDetail">
                <table border=“1”>
                    <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
                    <tr>
                        <td valign="top">
                            <ul>
                                <li>Unrelated cases selected from FUSION families and stage 2 replication</li>
                                <li>Samples met 1999 World Health Organization (WHO) criteria of fasting plasma glucose &ge;7.0 mmol/l or postload glucose during an OGTT &ge;11.1 mmol/l, by report of diabetes medication use, or based on medical record review</li>
                                <li>Prioritized FUSION families with &ge;2 first-degree relatives with T2D; BMI &ge;18.5kg/m2; case with GWAS data or earliest age at onset, if no GWAS data available</li>
                                <li>Prioritized FUSION stage 2 replication set with Metabochip data; BMI &ge;18.5kg/m2; earliest age of onset; age of onset &ge;35</li>
                                <li>When possible, we prioritized cases with age of diagnosis between 35 and 60, without history of insulin-dependent diabetes among first degree relatives, with at least one full sibling diagnosed with T2D, and with at least one parent who was apparently nondiabetic.</li>
                            </ul>
                        </td>
                        <td valign="top">
                            <li>Unrelated controls with normal glucose tolerance (NGT) based on WHO (1999) definitions: fasting plasma glucose <6.1 mM and 2 hour postload glucose during an OGTT <7.8 mM</li>
                            <li>Frequency matched to cases by birth province; BMI &ge;18.5kg/m2; age &le;80</li>
                            <li>Within each birth province, prioritized samples from stage 2 replication with highest values for age + 2*BMI</li>
                        </td></tr>
                </table>

            </div></td><td>European</td></tr>

        <tr><td>101</td><td>104</td><td><a onclick="showSection(event)">Kooperative Gesundheitsforschung in der Region Augsburg (KORA)</a>
            <div style="display: none;" class="cohortDetail">
                <table border=“1”>
                    <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
                    <tr>
                        <td valign="top">
                            <ul>
                                <li>Samples drawn from KORA F3 and F4</li>
                                <li>Diabetic status validated by doctor or by medication use</li>
                                <li>Prioritized cases with &ge;1 first-degree relative with T2D (self-reported)</li>
                                <li>Cases have &ge;1 first degree relative with type 2 diabetes (self-reported)</li>
                                <li>Cases have either BMI &le;30 and age of onset <65, or BMI &le;33 and age of onset &le;60</li>
                            </ul>
                        </td>
                        <td valign="top">
                            <li>Controls selected from KORA F4</li>
                            <li>All controls are normal glucose tolerant: fasting glucose level <6.1 mmol/l and two hour glucose level after oral glucose tolerance test <7.8 mmol/l</li>
                            <li>Controls are either >60 years of age with BMI >32 or over 65 years of age with BMI >31</li>
                        </td></tr>
                </table>
            </div></td><td>European</td></tr>

        <tr><td>322</td><td>322</td><td><a onclick="showSection(event)">UK Type 2 Diabetes Genetics Consortium (UKT2D)</a>

            <div style="display: none;" class="cohortDetail">
                <table border=“1”>
                    <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
                    <tr>
                        <td valign="top">
                            <ul>
                                <li>Cases drawn from the Wellcome Trust Case Control Consortium (WTCCC)</li>
                                <li>Female samples with age of diagnosis &ge;66 years or BMI &ge;32kg/m2 excluded; male samples with age of diagnosis &ge;62 years or BMI &ge;31kg/m2 excluded</li>
                                <li>Remaining samples were ranked by age and BMI, and the two ranks multiplied</li>
                                <li>Cases having a first degree relative with type 1 diabetes; testing positive for GAD antibodies; or known to have other forms of diabetes, such as MODY, excluded</li>
                            </ul>
                        </td>
                        <td valign="top">
                            <li>Unrelated samples selected as controls from the Twins UK study</li>
                            <li>A twin pair was considered for selection if there was no recorded family history of diabetes, neither twin was ever recorded as impaired glucose tolerant (defined as fasting glucose >6.1mmol/L in any reading), there were available quantitative trait and genetic (GWAs) data, and no evidence of admixture in MDS analysis of GWAs data</li>
                            <li>From set of qualifying twin pairs, the best control twin was selected from each pair with the lowest ratio of fasting glucose level to BMI across all readings, and further prioritization of the qualifying unrelated samples involved selecting samples that had the lowest fasting glucose to (BMI * age) ratios</li>
                            <li>Top two principal components were used to perform pairwise sample matching between cases and possible controls, and the best control for each case was selected</li>
                            <li>Controls having a first degree relative with type 1 diabetes excluded</li>
                        </td></tr>
                </table>
            </div></td><td>European</td></tr>

        <tr><td>410</td><td>419</td><td><a onclick="showSection(event)">Malmo-Botnia Study</a>

            <div style="display: none;" class="cohortDetail">
                <table border=“1”>
                    <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
                    <tr>
                        <td valign="top">
                            <ul>
                                <li>A liability score was generated (Guey LT et al. 2011) which measures risk to T2D in the context of three known risk factors (age at onset, BMI, and gender) in 27,500 individuals drawn from three prospective cohorts: the Malm&ouml; Preventive Project, the Scania Diabetes Registry, and the Botnia Study; only BMI and gender used to construct scores for Scania and Botnia studies</li>
                                <li>Early-onset cases with low BMI and older controls with high BMI were prioritized</li>
                                <li>Diabetic individuals with age of onset <35 years excluded</li>
                            </ul>
                        </td>
                        <td valign="top">
                            <li>Controls selected from the extreme of a liability score distribution, based upon gender, age and BMI at last follow-up visit; only BMI and gender used to construct scores for Malm&ouml; study</li>
                            <li>To match for ethnicity, equal numbers of controls were selected from the Botnia and Malm&ouml; studies</li>
                        </td></tr>
                </table>
            </div></td><td>European</td></tr>

        <tr><td>Total: 1326</td><td>Total: 1331</td><td></td><td></td></tr>
    </table>
    
    
    <h4>Project</h4>
    <h4>Genetics of Type 2 Diabetes (GoT2D) <small><a href="http://www.type2diabetesgenetics.org/projects/got2d" target="_blank">Learn more ></a>
    </small></h4>

    <p>The GoT2D consortium aims to understand the allelic architecture of type 2 diabetes through whole-genome sequencing, high-density SNP genotyping, and imputation. The reference panel based on this work is intended as a comprehensive inventory of low-frequency variants in Europeans, including SNPs, small insertions and deletions, and structural variants.</p>

<h4>Accessing GoT2D WGS data in the T2D Knowledge Portal</h4>
<p><g:message code="informational.data.accessing.GoT2DWGS"></g:message></p>


</script>
