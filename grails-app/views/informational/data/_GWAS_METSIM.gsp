<script class="panel-body" id="GWAS_METSIM_script" type="x-tmpl-mustache">

<h4><g:message code="informational.shared.headers.publications"></g:message></h4>

<p><div class="paper">
<g:message code="informational.shared.publications.Laakso_2017_JLipidRes"></g:message><br>
<g:message code="informational.shared.publications.Laakso_2017_JLipidRes.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
<div class="citation"><g:message code="informational.shared.publications.Laakso_2017_JLipidRes.citation"></g:message> </div>
</div></p>



    <h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
    <p><g:message code="pheno.help.text"></g:message></p>

    <ul>
        <li><g:message code="informational.shared.traits.t2d"></g:message></li>
        <li><g:message code="informational.shared.traits.t2dadjbmi"></g:message></li>
        <li><g:message code="informational.shared.traits.fasting_glucose"></g:message></li>
        <li><g:message code="informational.shared.traits.fasting_glucose_BMI"></g:message></li>
        <li><g:message code="informational.shared.traits.fasting_insulin"></g:message></li>
        <li><g:message code="informational.shared.traits.fasting_insulin_BMI"></g:message></li>
        </ul>


    <h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>

    <table class="table table-condensed table-responsive table-striped">
        <tr><th>Cases</th><th>Controls</th><th>Cohort <small>(Click to view selection criteria for cases and controls)</small></th><th>Ancestry</th></tr>

        <tr><td>nnn</td><td>nnn</td><td><a onclick="showSection(event)">METSIM (METabolic Syndrome In Men)</a>

            <div style="display: none;" class="cohortDetail">
                <table border="1">
                    <tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>
                    <tr>
                        <td valign="top">
                        <ul>
                        <li>Males, age 45-73</li>
                        <li>Type 2 diabetic</li>
                        </ul>
                        </td>
                        <td valign="top">
                        <ul>
                        <li>Males, age 45-73</li>
                        <li>Non-diabetic</li>
                        <li>Control group includes 5,832 individuals with normal glucose tolerance (NGT)</li>
                        </ul>
                        </td>
                    </tr>
                </table>
            </div></td><td>European</td></tr>
    </table>
    %{--<h4><g:message code="informational.shared.headers.project"></g:message></h4>--}%

    %{--<p><g:message code="informational.data.project.BioMe1"></g:message></p>--}%
%{--<p><g:message code="informational.data.project.BioMe2"></g:message></p>--}%

%{--<h4><g:message code="informational.shared.headers.ack"></g:message></h4>--}%
%{--<p><g:message code="informational.data.funding.BioMe"></g:message>--}%

%{--<h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>--}%
%{--<p><g:message code="informational.data.exptsumm.BioMe1"></g:message></p>--}%
%{--<p><g:message code="informational.data.exptsumm.BioMe2"></g:message></p>--}%
%{--<p><g:message code="informational.data.exptsumm.BioMe2b"></g:message></p>--}%
%{--<p><g:message code="informational.data.exptsumm.BioMe3"></g:message></p>--}%
%{--<p><g:message code="informational.data.exptsumm.BioMe4"></g:message></p>--}%
%{--<p><g:message code="informational.data.exptsumm.BioMe5"></g:message></p>--}%

%{--<h4><g:message code="informational.shared.headers.overview"></g:message></h4>--}%
%{--<p><g:message code="informational.data.overview.BioMe1a"></g:message></p>--}%
%{--<p><g:message code="informational.data.overview.BioMe1b"></g:message>--}%
    %{--(<g:message code="informational.shared.publications.Morris_2012_NatGenet.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>--}%
%{--<g:message code="informational.shared.publications.Morris_2012_NatGenet"></g:message>)--}%
%{--</p>--}%
%{--<p><g:message code="informational.data.overview.BioMe2"></g:message>--}%
%{--(<g:message code="informational.shared.publications.Dupuis_2010_NatGenet.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>--}%
%{--<g:message code="informational.shared.publications.Dupuis_2010_NatGenet"></g:message>;--}%

%{--<g:message code="informational.shared.publications.Scott_2012_NatGenet.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>--}%
%{--<g:message code="informational.shared.publications.Scott_2012_NatGenet"></g:message>).--}%

%{--<p><g:message code="informational.data.overview.BioMe3"></g:message><g:message code="informational.shared.publications.Soranzo_2010_Diabetes.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>--}%
%{--<g:message code="informational.shared.publications.Soranzo_2010_Diabetes"></g:message><g:message code="informational.data.overview.BioMe4"></g:message></p>--}%

%{--<p><g:message code="informational.data.overview.BioMe5"></g:message></p>--}%
%{--<p><g:message code="informational.data.overview.BioMe6a"></g:message><g:message code="informational.shared.publications.ICBP_2011_Nature.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>,--}%
%{--&nbsp;<g:message code="informational.shared.publications.ICBP_2011_Nature"></g:message><g:message code="informational.data.overview.BioMe6b"></g:message></p>--}%


%{--<p><g:message code="informational.data.overview.BioMe7a"></g:message><g:message code="informational.shared.publications.Willer_2013_NatGenet.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>,--}%
%{--<g:message code="informational.shared.publications.Willer_2013_NatGenet"></g:message><g:message code="informational.data.overview.BioMe7b"></g:message></p>--}%

%{--<p><g:message code="informational.data.overview.BioMe8"></g:message></p>--}%
%{--<p><g:message code="informational.data.overview.BioMe9"></g:message></p>--}%

%{--<h4><g:message code="informational.shared.headers.reports"></g:message></h4>--}%

%{--<p>Genotype Data Quality Control Report (<a href="https://s3.amazonaws.com/broad-portal-resources/AMP-DCC+Quality+Control+Report+BioMe_2016_1102.pdf" target="_blank">download PDF</a>)</p>--}%

%{--<h5><g:message code="informational.shared.headers.phase1"></g:message></h5>--}%


%{--<p>BioMe Phase 1 AMP-DCC Data Analysis Report (<a href="https://s3.amazonaws.com/broad-portal-resources/AMP-DCC_Data_Analysis_Report_BIOME_Phase1_2017_0101.pdf" target="_blank">download PDF</a>)</p>--}%


%{--<h5><g:message code="informational.shared.headers.phase2"></g:message></h5>--}%

%{--<p>BioMe Phase 2 AMP-DCC Data Analysis Report (<a href="https://s3.amazonaws.com/broad-portal-resources/AMP-DCC_Data_Analysis_Report_BIOME_Phase2.pdf" target="_blank">download PDF</a>)</p>--}%

%{--<h4>Accessing BioMe AMP T2D GWAS data</h4>--}%
%{--<p><g:message code="informational.data.accessing.BioMe"></g:message></p>--}%


%{--<h4>External Links to BioMe AMP T2D GWAS data</h4>--}%
%{--<p><g:message code="informational.data.external.BioMe"></g:message></p>--}%

</script>
