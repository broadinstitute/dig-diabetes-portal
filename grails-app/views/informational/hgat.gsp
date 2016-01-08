<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>

<body>

<div id="main">
    <div class="container">
        <h1><g:message code='gene.variantassociations.table.rowhdr.gwas'/> <g:message code='gene.variantassociations.table.rowhdr.meta_analyses'/></h1>
        <p><g:message code='informational.hgat.lead'/>:
        </p>
        <p><g:message code='informational.shared.traits.t2d'/>: <a class="boldlink" href="http://diagram-consortium.org/downloads.html"><g:message code='informational.shared.institution.DIAGRAM'/></a>, &nbsp;2012 <a href="http://www.ncbi.nlm.nih.gov/pubmed/22885922">(ref)</a></p>
        <p><g:message code='informational.shared.traits.fasting_glucose'/>: <a class="boldlink" href="http://www.magicinvestigators.org/downloads/"><g:message code='informational.shared.institution.MAGIC'/></a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20081858">(ref)</a></p>
        <p><g:message code='informational.shared.traits.fasting_insulin'/>: <a class="boldlink" href="http://www.magicinvestigators.org/downloads/"><g:message code='informational.shared.institution.MAGIC'/></a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20081858">(ref)</a></p>
        <p><g:message code='informational.shared.traits.two_hour_glucose'/>: <a class="boldlink" href="http://www.magicinvestigators.org/downloads/"><g:message code='informational.shared.institution.MAGIC'/></a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20081857">(ref)</a></p>
        <p><g:message code='informational.shared.traits.two_hour_insulin'/>: <a class="boldlink" href="http://www.magicinvestigators.org/downloads/"><g:message code='informational.shared.institution.MAGIC'/></a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20081857">(ref)</a></p>
        <p><g:message code='informational.shared.traits.fasting_proinsulin'/>: <a class="boldlink" href="http://www.magicinvestigators.org/downloads/"><g:message code='informational.shared.institution.MAGIC'/></a>, &nbsp;2011 <a href="http://www.ncbi.nlm.nih.gov/pubmed/21873549">(ref)</a></p>
        <p><g:message code='informational.shared.traits.HOMA-IR'/>: <a class="boldlink" href="http://www.magicinvestigators.org/downloads/"><g:message code='informational.shared.institution.MAGIC'/></a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20081858">(ref)</a></p>
        <p><g:message code='informational.shared.traits.HOMA-B'/>: <a class="boldlink" href="http://www.magicinvestigators.org/downloads/"><g:message code='informational.shared.institution.MAGIC'/></a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20081858">(ref)</a></p>
        <p><g:message code='informational.shared.traits.HbA1c'/>: <a class="boldlink" href="http://www.magicinvestigators.org/downloads/"><g:message code='informational.shared.institution.MAGIC'/></a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20858683">(ref)</a></p>
        <p><g:message code='informational.shared.traits.BMI'/>: <a class="boldlink" href="http://www.broadinstitute.org/collaboration/giant/index.php/GIANT_consortium_data_files#GIANT_Consortium_2010_GWAS_Metadata_is_Available_Here_for_Download"><g:message code='informational.shared.institution.GIANT'/></a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20935630">(ref)</a></p>
        <p><g:message code='informational.shared.traits.waist_hip_ratio'/>: <a class="boldlink" href="http://www.broadinstitute.org/collaboration/giant/index.php/GIANT_consortium_data_files#GIANT_Consortium_2010_GWAS_Metadata_is_Available_Here_for_Download"><g:message code='informational.shared.institution.GIANT'/></a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20935629">(ref)</a></p>
        <p><g:message code='informational.shared.traits.height'/>: <a class="boldlink" href="http://www.broadinstitute.org/collaboration/giant/index.php/GIANT_consortium_data_files#GIANT_Consortium_2010_GWAS_Metadata_is_Available_Here_for_Download"><g:message code='informational.shared.institution.GIANT'/></a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20881960">(ref)</a></p>
        <p><g:message code='informational.shared.traits.total_cholesterol'/>: <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20686565"><g:message code='informational.shared.institution.GLGC'/></a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20686565">(ref)</a></p>
        <p><g:message code='informational.shared.traits.HDL_cholesterol'/>: <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20686565"><g:message code='informational.shared.institution.GLGC'/></a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20686565">(ref)</a></p>
        <p><g:message code='informational.shared.traits.LDL_cholesterol'/>: <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20686565"><g:message code='informational.shared.institution.GLGC'/></a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20686565">(ref)</a></p>
        <p><g:message code='informational.shared.traits.triglycerides'/>: <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20686565"><g:message code='informational.shared.institution.GLGC'/></a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20686565">(ref)</a></p>
        <p><g:message code='informational.shared.traits.coronary_artery_disease'/>: <a class="boldlink" href="http://www.cardiogramplusc4d.org/downloads/"><g:message code='informational.shared.institution.CARDIoGRAM'/></a>, &nbsp;2011 <a href="http://www.ncbi.nlm.nih.gov/pubmed/21378990">(ref)</a></p>
        <p><g:message code='informational.shared.traits.chronic_kidney_disease'/>: <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20383146"><g:message code='informational.shared.institution.CKDGen'/></a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20383146">(ref)</a></p>
        <p><g:message code='informational.shared.traits.eGFR-creat'/>: <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20383146"><g:message code='informational.shared.institution.CKDGen'/></a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20383146">(ref)</a></p>
        <p><g:message code='informational.shared.traits.eGFR-cys'/>: <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20383146"><g:message code='informational.shared.institution.CKDGen'/>/a>, &nbsp;2011 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20383146">(ref)</a></p>
        <p><g:message code='informational.shared.traits.urinary_atc_ratio'/>: <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20383146"><g:message code='informational.shared.institution.CKDGen'/></a>, &nbsp;2011 <a href="http://www.ncbi.nlm.nih.gov/pubmed/21355061">(ref)</a></p>
        <p><g:message code='informational.shared.traits.microalbuminuria'/>: <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20383146"><g:message code='informational.shared.institution.CKDGen'/></a>, &nbsp;2011 <a href="http://www.ncbi.nlm.nih.gov/pubmed/21355061">(ref)</a></p>
        <p><g:message code='informational.shared.traits.schizophrenia'/>: <a class="boldlink" href="https://www.nimhgenetics.org/available_data/data_biosamples/pgc_public.php"><g:message code='informational.shared.institution.PGC'/></a>, &nbsp;2011 <a href="http://www.ncbi.nlm.nih.gov/pubmed/21355061">(ref)</a></p>
        <p><g:message code='informational.shared.traits.bipolar'/>: <a class="boldlink" href="https://www.nimhgenetics.org/available_data/data_biosamples/pgc_public.php"><g:message code='informational.shared.institution.PGC'/></a>, &nbsp;2011 <a href="http://www.ncbi.nlm.nih.gov/pubmed/21926972">(ref)</a></p>
        <p><g:message code='informational.shared.traits.depression'/>: <a class="boldlink" href="https://www.nimhgenetics.org/available_data/data_biosamples/pgc_public.php"><g:message code='informational.shared.institution.PGC'/></a>, &nbsp;2013 <a href="http://www.ncbi.nlm.nih.gov/pubmed/22472876">(ref)</a></p>
    </div>
</div>

</body>
</html>
