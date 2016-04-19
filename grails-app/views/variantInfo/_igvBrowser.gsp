
%{--Why I am forced to include style directives explicitly in this page and no other I do not know. There must be--}%
%{--something funny about IGV's use of CSS that is different than everything else in the application.  //TODO -- fix this--}%
<g:set var="restServer" bean="restServerService"/>
<script>
    function  igvSearch(searchString) {
        igv.browser.search(searchString);
        return true;
    }
</script>

<div id="myVariantDiv">
<p>
    <g:message code="variant.messages.igv.section_1" />
    <g:renderT2dGenesSection>
    (<g:message code="variant.variantAssociations.source.exomeSequenceQ.help.header" />, <g:message code="variant.variantAssociations.source.exomeChip" />, <g:message code="site.shared.phrases.or" /> <g:message code='gene.variantassociations.table.rowhdr.gwas'/>)
    </g:renderT2dGenesSection>
     <g:message code="variant.messages.igv.section_2" />
    <g:renderT2dGenesSection>
    (<g:message code='gene.variantassociations.table.rowhdr.gwas'/>)
    </g:renderT2dGenesSection>
    .
</p>

<br/>

<nav class="navbar" role="navigation">
<div class="container-fluid">
<div class="navbar-header">
    <button type="button" class="navbar-toggle" data-toggle="collapse"
            data-target="#bs-example-navbar-collapse-1"><span class="sr-only"><g:message code="controls.shared.igv.toggle_nav" /></span><span
            class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button>
    <a class="navbar-brand">IGV</a></div>
<div id="bs-example-navbar-collapse-1" class="collapse navbar-collapse">
<ul class="nav navbar-nav navbar-left">
<li class="dropdown" id="tracks-menu-dropdown">
<a href="#" class="dropdown-toggle" data-toggle="dropdown"><g:message code="controls.shared.igv.tracks" /><b class="caret"></b></a>
<ul id="trackList" class="dropdown-menu">
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'FastGlu',
        label: 'fasting glucose',
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>fasting glucose</strong><br/>'+
                'Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.')
    })"><g:message code="informational.shared.traits.fasting_glucose" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: '2hrGLU_BMIAdj',
        label: 'two-hour glucose',
        order: 9981,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>two-hour glucose</strong><br/>'+
                'Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.')
    })"><g:message code="informational.shared.traits.two_hour_glucose" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: '2hrIns_BMIAdj',
        label: 'two-hour insulin',
        order: 9981,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>two-hour insulin</strong><br/>'+
                'Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.')
    })"><g:message code="informational.shared.traits.two_hour_insulin" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'FastIns',
        label: 'fasting insulin',
        order: 9997,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>fasting insulin</strong><br/>'+
                'Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.')
    })"><g:message code="informational.shared.traits.fasting_insulin" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'ProIns',
        label: 'fasting proinsulin',
        order: 9982,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>fasting proinsulin</strong><br/>'+
                'Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.')
    })"><g:message code="informational.shared.traits.fasting_proinsulin" /></a>
</li>                            <li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'HbA1c',
        label: 'HBA1C',
        order: 9996,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>HbA1c</strong><br/>'+
                'Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.')
    })"><g:message code="informational.shared.traits.HBA1C" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'HOMAIR',
        label: 'HOMA-IR',
        order: 9995,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>HOMA-IR</strong><br/>'+
                'Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.')
    })"><g:message code="informational.shared.traits.HOMA_IR" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'HOMAB',
        label: 'HOMA-B',
        order: 9994,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>HOMA-B</strong><br/>'+
                'Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.')
    })"><g:message code="informational.shared.traits.HOMA_B" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'BMI',
        label: 'BMI',
        order: 9993,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>BMI</strong><br/>'+
                'Results in this track are from a GWAS meta-analysis of as many as 123,865 people conducted by the GIANT Consortium.')
    })"><g:message code="informational.shared.traits.BMI" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'WAIST_CIRCUMFRENCE',
        label: 'waist circumference',
        order: 9992,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>waist circumference</strong><br/>'+
                'Results in this track are from a GWAS meta-analysis of people conducted by the GIANT Consortium.')
    })"><g:message code="informational.shared.traits.waist_circumference" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'HIP_CIRCUMFRENCE',
        label: 'hip circumference',
        order: 9991,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>hip circumference</strong><br/>'+
                'Results in this track are from a GWAS meta-analysis of people conducted by the GIANT Consortium.')
    })"><g:message code="informational.shared.traits.hip_circumference" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'WHR',
        label: 'waist-hip ratio',
        order: 9990,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>waist-hip ratio</strong><br/>'+
                'Results in this track are from a GWAS meta-analysis of as many as 77,167 people conducted by the GIANT Consortium.')
    })"><g:message code="informational.shared.traits.waist_hip_ratio" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'Height',
        label: 'height',
        order: 9990,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>height</strong><br/>'+
                'Results in this track are from a GWAS meta-analysis of as many as 183,727 people conducted by the GIANT Consortium.')
    })"><g:message code="informational.shared.traits.height" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'HDL',
        label: 'HDL',
        order: 9989,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>HDL cholesterol</strong><br/>'+
                'Results in this track are from a GWAS meta-analysis of as many as 99,900 people conducted by the Global Lipid Genetics Consortium.')
    })"><g:message code="informational.shared.traits.HDL_cholesterol" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'LDL',
        label: 'LDL',
        order: 9988,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>LDL cholesterol</strong><br/>'+
                'Results in this track are from a GWAS meta-analysis of as many as 95,454 people conducted by the Global Lipid Genetics Consortium.')
    })"><g:message code="informational.shared.traits.LDL_cholesterol" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'TG',
        label: 'triglycerides',
        order: 9987,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>triglycerides</strong><br/>'+
                'Results in this track are from a GWAS meta-analysis of as many as 96,598 people conducted by the Global Lipid Genetics Consortium.')
    })"><g:message code="informational.shared.traits.triglycerides" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'CAD',
        label: 'coronary artery disease',
        order: 9978,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>coronary artery disease</strong><br/>'+
                'Results in this track are from a GWAS meta-analysis of as many as 86,995 people conducted by the CARDIoGRAM Consortium.')
    })"><g:message code="informational.shared.traits.coronary_artery_disease" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'CKD',
        label: 'chronic kidney disease',
        order: 9977,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>chronic kidney disease</strong><br/>'+
                'Results in this track are from a GWAS meta-analysis of as many as 67,093 people conducted by the CKDGen Consortium.')
    })"><g:message code="informational.shared.traits.chronic_kidney_disease" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'eGFRcrea',
        label: 'eGFR-creat (serum creatinine)',
        order: 9976,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>eGFR-creat (serum creatinine)</strong><br/>'+
                'Results in this track are from a GWAS meta-analysis of as many as 67,093 people conducted by the CKDGen Consortium.')
    })"><g:message code="informational.shared.traits.eGFR-creat" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'eGFRcys',
        label: 'eGFR-cys (serum cystatin C)',
        order: 9975,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>eGFR-cys (serum cystatin C)</strong><br/>'+
                'Results in this track are from a GWAS meta-analysis of as many as 67,093 people conducted by the CKDGen Consortium.')
    })"><g:message code="informational.shared.traits.eGFR-cys" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'MA',
        label: 'microalbuminuria',
        order: 9974,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>microalbuminuria</strong><br/>'+
                'Results in this track are from a GWAS meta-analysis of as many as 67,093 people conducted by the CKDGen Consortium.')
    })"><g:message code="informational.shared.traits.microalbuminuria" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'UACR',
        label: 'urinary albumin-to-creatinine ratio',
        order: 9973,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>urinary albumin-to-creatinine ratio</strong><br/>'+
                'Results in this track are from a GWAS meta-analysis of as many as 67,093 people conducted by the CKDGen Consortium.')
    })"><g:message code="informational.shared.traits.urinary_atc_ratio" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'SCZ',
        label: 'schizophrenia',
        order: 9972,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>schizophrenia</strong><br/>'+
                'Results in this track are from a GWAS Psychiatric Genetics Consortium.')
    })"><g:message code="informational.shared.traits.schizophrenia" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'MDD',
        label: 'major depressive disorder',
        order: 9971,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>major depressive disorder</strong><br/>'+
                'Results in this track are from a GWAS meta-analysis of many as 18,759 people conducted by the Psychiatric Genetics Consortium.')
    })"><g:message code="informational.shared.traits.depression" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 'gwas',
        url: '${restServer.currentRestServer()}trait-search',
        trait: 'BIP',
        label: 'bipolar disorder',
        order: 9972,
        colorScale:  {
            thresholds: [5e-8, 5e-4, 0.05],
            colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
        },
        description: ('<strong>bipolar disorder</strong><br/>'+
                'Results in this track are from a GWAS meta-analysis of many as 16,731 people conducted by the Psychiatric Genetics Consortium.')
    })"><g:message code="informational.shared.traits.bipolar" /></a>
</li>
</ul>
</li>
</ul>
<div class="nav navbar-nav navbar-left">
    <div class="well-sm">
        <input id="goBoxInput" class="form-control" placeholder="Locus Search" type="text"
               onchange="igvSearch($('#goBoxInput')[0].value)">
    </div>
</div>
<div class="nav navbar-nav navbar-left">
    <div class="well-sm">
        <button id="goBox" class="btn btn-default" onclick="igvSearch($('#goBoxInput')[0].value)">
            <g:message code="controls.shared.igv.search" />
        </button>
    </div>
</div>
<div class="nav navbar-nav navbar-right">
    <div class="well-sm">
        <div class="btn-group-sm"></div>
        <button id="zoomOut" type="button" class="btn btn-default btn-sm"
                onclick="igv.browser.zoomOut()">
            <span class="glyphicon glyphicon-minus"></span></button>
        <button id="zoomIn" type="button" class="btn btn-default btn-sm" onclick="igv.browser.zoomIn()">
            <span class="glyphicon glyphicon-plus"></span></button>
    </div>
</div>
</div>
</div>
</nav>

</div>
