<script class="panel-body" id="ExSeq_EOMI_script" type="x-tmpl-mustache">

<div class="panel-body">


    <h4><g:message code="informational.shared.headers.publications"></g:message></h4>


              <p><div class="paper">
<g:message code="informational.shared.publications.Do_2015_Nature"></g:message><br>
<g:message code="informational.shared.publications.Do_2015_Nature.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
<div class="citation"><g:message code="informational.shared.publications.Do_2015_Nature.citation"></g:message> </div>
</div></p>


    <h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
    <ul>
        <li><g:message code="informational.shared.traits.MI"></g:message></li>
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



   %{--<h4><g:message code="informational.shared.headers.project"></g:message></h4>--}%

    %{--<p><g:message code="informational.data.project.MIGen"></g:message></p>--}%

%{--<h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>--}%


<h4>Accessing EOMI exome sequence analysis data</h4>

<p><g:message code="informational.data.accessing.EOMI1"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.EOMI2"></g:message></p>

</div>



</script>
