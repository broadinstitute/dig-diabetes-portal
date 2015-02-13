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
        <h1>GWAS meta-analyses</h1>
        <p>This dataset includes results from GWAS meta-analyses of 25 traits, and covers a total of 3.1 million SNPs
        (all those included in <a href="http://www.nature.com/nature/journal/v449/n7164/full/nature06258.html">HapMap2</a>).
        Available information for the SNPs includes p-values, direction of effect, and effect size.
        The meta-analyses for each trait are:
        </p>
        <p>type 2 diabetes: <a class="boldlink" href="http://diagram-consortium.org/downloads.html">DIAGRAM</a>, &nbsp;2012 <a href="http://www.ncbi.nlm.nih.gov/pubmed/22885922">(ref)</a></p>
        <p>fasting glucose: <a class="boldlink" href="http://www.magicinvestigators.org/downloads/">MAGIC</a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20081858">(ref)</a></p>
        <p>fasting insulin: <a class="boldlink" href="http://www.magicinvestigators.org/downloads/">MAGIC</a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20081858">(ref)</a></p>
        <p>two-hour glucose: <a class="boldlink" href="http://www.magicinvestigators.org/downloads/">MAGIC</a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20081857">(ref)</a></p>
        <p>two-hour insulin: <a class="boldlink" href="http://www.magicinvestigators.org/downloads/">MAGIC</a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20081857">(ref)</a></p>
        <p>fasting proinsulin: <a class="boldlink" href="http://www.magicinvestigators.org/downloads/">MAGIC</a>, &nbsp;2011 <a href="http://www.ncbi.nlm.nih.gov/pubmed/21873549">(ref)</a></p>
        <p>HOMA-IR: <a class="boldlink" href="http://www.magicinvestigators.org/downloads/">MAGIC</a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20081858">(ref)</a></p>
        <p>HOMA-B: <a class="boldlink" href="http://www.magicinvestigators.org/downloads/">MAGIC</a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20081858">(ref)</a></p>
        <p>HbA1c: <a class="boldlink" href="http://www.magicinvestigators.org/downloads/">MAGIC</a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20858683">(ref)</a></p>
        <p>BMI: <a class="boldlink" href="http://www.broadinstitute.org/collaboration/giant/index.php/GIANT_consortium_data_files#GIANT_Consortium_2010_GWAS_Metadata_is_Available_Here_for_Download">GIANT</a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20935630">(ref)</a></p>
        <p>waist-hip ratio: <a class="boldlink" href="http://www.broadinstitute.org/collaboration/giant/index.php/GIANT_consortium_data_files#GIANT_Consortium_2010_GWAS_Metadata_is_Available_Here_for_Download">GIANT</a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20935629">(ref)</a></p>
        <p>height: <a class="boldlink" href="http://www.broadinstitute.org/collaboration/giant/index.php/GIANT_consortium_data_files#GIANT_Consortium_2010_GWAS_Metadata_is_Available_Here_for_Download">GIANT</a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20881960">(ref)</a></p>
        <p>total cholesterol: <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20686565">Global Lipid Genetics Consortium (GLGC)</a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20686565">(ref)</a></p>
        <p>HDL cholesterol: <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20686565">Global Lipid Genetics Consortium (GLGC)</a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20686565">(ref)</a></p>
        <p>LDL cholesterol: <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20686565">Global Lipid Genetics Consortium (GLGC)</a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20686565">(ref)</a></p>
        <p>triglycerides: <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20686565">Global Lipid Genetics Consortium (GLGC)</a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20686565">(ref)</a></p>
        <p>coronary artery disease: <a class="boldlink" href="http://www.cardiogramplusc4d.org/downloads/">CARDIoGRAM</a>, &nbsp;2011 <a href="http://www.ncbi.nlm.nih.gov/pubmed/21378990">(ref)</a></p>
        <p>chronic kidney disease: <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20383146">CKDGen Consortium</a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20383146">(ref)</a></p>
        <p>eGFR-creat (serum creatinine): <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20383146">CKDGen Consortium</a>, &nbsp;2010 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20383146">(ref)</a></p>
        <p>eGFR-cys (serum cystatin C): <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20383146">CKDGen Consortium</a>, &nbsp;2011 <a href="http://www.ncbi.nlm.nih.gov/pubmed/20383146">(ref)</a></p>
        <p>urinary albumin-to-creatinine ratio: <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20383146">CKDGen Consortium</a>, &nbsp;2011 <a href="http://www.ncbi.nlm.nih.gov/pubmed/21355061">(ref)</a></p>
        <p>microalbuminuria: <a class="boldlink" href="http://www.ncbi.nlm.nih.gov/pubmed/20383146">CKDGen Consortium</a>, &nbsp;2011 <a href="http://www.ncbi.nlm.nih.gov/pubmed/21355061">(ref)</a></p>
        <p>schizophrenia: <a class="boldlink" href="https://www.nimhgenetics.org/available_data/data_biosamples/pgc_public.php">Psychiatric Genetics Consortium</a>, &nbsp;2011 <a href="http://www.ncbi.nlm.nih.gov/pubmed/21355061">(ref)</a></p>
        <p>bipolar disorder: <a class="boldlink" href="https://www.nimhgenetics.org/available_data/data_biosamples/pgc_public.php">Psychiatric Genetics Consortium</a>, &nbsp;2011 <a href="http://www.ncbi.nlm.nih.gov/pubmed/21926972">(ref)</a></p>
        <p>major depressive disorder: <a class="boldlink" href="https://www.nimhgenetics.org/available_data/data_biosamples/pgc_public.php">Psychiatric Genetics Consortium</a>, &nbsp;2013 <a href="http://www.ncbi.nlm.nih.gov/pubmed/22472876">(ref)</a></p>
    </div>
</div>

</body>
</html>
