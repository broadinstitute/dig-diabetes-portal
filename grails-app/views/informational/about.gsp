<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>

<body>

<div id="main">
    <div class="container">
        <h1>About The Data</h1>

        <p>
            This portal contains results from the following studies, which were supported by <a
                href="www.niddk.nih.gov">NIDDK</a> and
            <a href="http://www.genome.gov">NHGRI</a> (click any study to learn more):
        </p>

        <p class="leadlink">
            <a href="${createLink(controller:'informational', action:'t2dgenes')}">T2D-GENES:</a>
            exome sequencing results from 10,000 people (half T2D cases, half controls)
            representing five continental ancestry groups (African-American, East Asian, South Asian, European, and Hispanic).
        </p>

        <p class="leadlink">
            <a href="${createLink(controller:'informational', action:'got2d')}">GoT2D:</a>
            four exome sequencing cohorts (~3,000), plus a meta-analysis of exome chip results  from ~35,000 T2D cases and ~51,000 controls, all of European ancestry.
        </p>

        <p class="leadlink">
            <a href="http://diagram-consortium.org/about.html">DIAGRAM:</a>
            GWAS results from 12,171 cases and 56,862 controls, all of European ancestry. DIAGRAM is the largest current GWAS dataset in T2D.
        </p>

        <p class="leadlink">
            <a href="${createLink(controller:'informational', action:'hgat')}">Human Genetics Annotation Table:</a>
            SNP-specific p-values from large GWAS meta-analyses for 25 traits.
        </p>

    </div>
</div>

</body>
</html>
