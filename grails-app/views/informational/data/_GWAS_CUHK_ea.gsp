<script class="panel-body" id="GWAS_CUHK_ea_script" type="x-tmpl-mustache">

               <h4><g:message code="informational.shared.headers.publications"></g:message></h4>

        %{--<p><div class="paper">--}%
%{--<g:message code="informational.shared.publications.Morris_2019_NatGenet"></g:message><br>--}%
%{--<g:message code="informational.shared.publications.Morris_2019_NatGenet.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>--}%
%{--<div class="citation"><g:message code="informational.shared.publications.Morris_2019_NatGenet.citation"></g:message> </div>--}%
%{--</div></p>--}%

<h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
<ul>
<li><g:message code="metadata.BMI"></g:message></li>
<li><g:message code="metadata.INS_FAST"></g:message></li>
<li><g:message code="metadata.HDL"></g:message></li>
<li><g:message code="metadata.HEIGHT"></g:message></li>
<li><g:message code="metadata.HOMAB"></g:message></li>
<li><g:message code="metadata.IGI"></g:message></li>
<li><g:message code="metadata.LDL"></g:message></li>
<li><g:message code="metadata.CHOL"></g:message></li>
<li><g:message code="metadata.TG"></g:message></li>
<li><g:message code="metadata.WAIST"></g:message></li>


</ul>

<h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>
    %{--<table class="table table-condensed table-responsive table-striped">--}%

%{--<tr><th>Samples</th><th>Cohort</th><th>Ancestry</th></tr>--}%
%{--<tr><td>nnn</td><td>aaa</td><td>East Asian</td></tr>--}%



    %{--</table>--}%

%{--<h4><g:message code="informational.shared.headers.project"></g:message></h4>--}%
%{--<p><img src="${resource(dir: 'images/organizations', file: 'GEFOS_logo.png')}" style="width: 120px; margin-right: 15px"--}%
        %{--align="left">--}%
%{--</p>--}%

%{--<h4>Genetic Factors for Osteoporosis (GEFOS) Consortium <small><a href="http://www.gefos.org/" target="_blank">Learn more ></a></small></h4>--}%
%{--<p>&nbsp;</p>--}%


    <h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
<p><g:message code="informational.data.exptsumm.CUHK"></g:message></p>

   <h4>Accessing Hong Kong Diabetes Registry GWAS results</h4>
<p><g:message code="informational.data.accessing.CUHK1"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.CUHK2"></g:message></p>




</script>