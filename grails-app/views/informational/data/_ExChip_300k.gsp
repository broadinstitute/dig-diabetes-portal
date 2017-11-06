<script class="panel-body" id="ExChip_300k_script" type="x-tmpl-mustache">
   <div class="panel-body">

 <h4><g:message code="informational.shared.headers.publications"></g:message></h4>

<p><div class="paper">
<g:message code="informational.shared.publications.Liu_2017_NatGenet"></g:message><br>
<g:message code="informational.shared.publications.Liu_2017_NatGenet.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
<div class="citation"><g:message code="informational.shared.publications.Liu_2017_NatGenet.citation"></g:message> </div>
</div></p>


   <h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
<ul>
<li><g:message code="informational.shared.traits.cholesterol"></g:message></li>
<li><g:message code="informational.shared.traits.HDL_cholesterol"></g:message></li>
<li><g:message code="informational.shared.traits.LDL_cholesterol"></g:message></li>
<li><g:message code="informational.shared.traits.triglycerides"></g:message></li>
</ul>


    %{--<h4>Dataset subjects</h4>--}%

    %{--<table class="table table-condensed table-responsive table-striped">--}%
        %{--<tr><th>Cases</th><th>Controls</th><th>Cohort <small>(Click to view selection criteria for cases and controls)</small></th><th>Ethnicity</th></tr>--}%

        %{--<tr><td>n,nnn</td><td>n,nnn</td><td><a onclick="showSection(event)">Cohort name</a>--}%

            %{--<div style="display: none;" class="cohortDetail">--}%
                %{--<table border="1">--}%
                    %{--<tr><th>Case selection criteria</th><th>Control selection criteria</th></tr>--}%
                    %{--<tr>--}%
                        %{--<td valign="top">criteria</td>--}%
                        %{--<td valign="top">criteria</td></tr>--}%
                %{--</table>--}%
            %{--</div></td><td>Ancestry</td></tr>--}%
    %{--</table>--}%

    %{--<h4>Project</h4>--}%

    %{--<p><g:message code="informational.data.project.project"></g:message></p>--}%


%{--<h4>Experiment summary</h4>--}%
%{--<p><g:message code="informational.data.exptsumm.project"></g:message></p>--}%


<h4>Accessing 300K exome chip analysis data</h4>

<p><g:message code="informational.data.accessing.300K1"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.300K2"></g:message></p>


</div>


</script>