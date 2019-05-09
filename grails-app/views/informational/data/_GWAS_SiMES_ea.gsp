<script class="panel-body" id="GWAS_SiMES_ea_script" type="x-tmpl-mustache">

               <h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>

<ul>
<li><g:message code="metadata.T2D"></g:message></li>
</ul>


<h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>
    <table class="table table-condensed table-responsive table-striped">

<tr><th>Samples</th><th>Cohort</th><th>Ancestry</th></tr>
<tr><td>2,542</td><td>Singapore Malay Eye Study</td><td>East Asian, Malay</td></tr>

    </table>


<h4><g:message code="informational.shared.headers.project"></g:message></h4>
<p><img src="${resource(dir: 'images/organizations', file: 'SEED_logo.png')}" style="width: 120px; margin-right: 15px"
        align="left">
</p>

<h4>Singapore Epidemiology of Eye Disease (SEED) <small><a href="https://www.snec.com.sg/research-innovation/key-programme-singapore-epidemiology-of-eye-diseases" target="_blank">Learn more ></a></small></h4>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><br><br>

    <h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
<p><g:message code="informational.data.exptsumm.SiMES"></g:message></p>

   <h4>Accessing Singapore Indian Eye Study GWAS results</h4>
<p><g:message code="informational.data.accessing.SiMES1"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.SiMES2"></g:message></p>


</script>