<script class="panel-body" id="GWAS_ISGC_eu_dv1_script" type="x-tmpl-mustache">

                <h4><g:message code="informational.shared.headers.dataset"></g:message></h4>

<p><g:message code="informational.data.download.WMHV"></g:message></p>
            <h4><g:message code="informational.shared.headers.publications"></g:message></h4>

        <p><div class="paper">
<g:message code="informational.shared.publications.Traylor_2019_Neurology"></g:message><br>
<g:message code="informational.shared.publications.Traylor_2019_Neurology.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
<div class="citation"><g:message code="informational.shared.publications.Traylor_2019_Neurology.citation"></g:message> </div>
</div></p>

<h4><g:message code="informational.shared.headers.dataset_pheno"></g:message></h4>
<ul>
<li><g:message code="informational.shared.traits.WMHV"></g:message></li>
</ul>

<h4><g:message code="informational.shared.headers.dataset_subjects"></g:message></h4>
    <table class="table table-condensed table-responsive table-striped">

<tr><th>Samples</th><th>Cohort</th><th>Ancestry</th></tr>

<tr><td>8,429</td><td><a onclick="showSection(event)">UK Biobank</a>
<div style="display: none;" class="cohortDetail">
            <table border="1">
                <tr><th>Inclusion criteria</th><th>Exclusion criteria</th></tr>
                <tr>
                    <td valign="top">
                        <ul>
                            <li>participants underwent brain MRI</li>
                            <li>participants had usable T2 fluid- attenuated inversion recovery (FLAIR) or diffusion tensor imaging images</li>
                        </ul>
                    </td>
                    <td valign="top">
                        <ul>
                            <li>participants with a diagnosis of stroke (ICD-9/ICD-10 or self-report or health record linkage) were excluded</li>
                            <li>participants with a diagnosis of multiple sclerosis, Parkinson disease, dementia, or any other neurodegenerative disease at baseline were excluded</li>
                            <li>participants with no genetic data were excluded</li>
                            <ul>
                    </td></tr>
    </table></td><td>European</td></tr>

<tr><td>2,797</td><td><a onclick="showSection(event)">WMH in Stroke Study</a>
<div style="display: none;" class="cohortDetail">
<table border="1">
                <tr><th>Inclusion criteria</th><th>Exclusion criteria</th></tr>
                <tr>
                    <td valign="top">
                        <ul>
                            <li>participants had a diagnosis of ischemic stroke</li>
                        </ul>
                    </td>
                    <td valign="top">
                        <ul>
                            <li>patients with cerebral autosomal dominant arteriopathy with subcortical infarcts and leukoencephalopathy (CADASIL) or any other suspected monogenic cause of stroke, vasculitis, or any other nonischemic cause of WMH such as demyelinating and mitochondrial disorders, were excluded</li>
                            <ul>
                    </td></tr>
    </table></td><td>European</td></tr>
    </table>


    <h4><g:message code="informational.shared.headers.exptsumm"></g:message></h4>
<p><g:message code="informational.data.exptsumm.WMH_GWAS"></g:message></p>


   <h4>Accessing Cerebral WMHV GWAS 2019 results</h4>
<p><g:message code="informational.data.accessing.WMH_GWAS1"></g:message> <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">Variant Finder</a> <g:message code="informational.data.accessing.WMH_GWAS2"></g:message></p>



</script>