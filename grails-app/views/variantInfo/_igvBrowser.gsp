
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
    Use the browser below to explore all genome-wide and locus-wide
    significant variants within 50kb of this variant. Choose "Tracks" to view
    results relevant to type 2 diabetes
    <g:renderT2dGenesSection>
    (exome sequencing, exome chip, or GWAS)
    </g:renderT2dGenesSection>
     or any of 24 other related traits
    <g:renderT2dGenesSection>
    (GWAS)
    </g:renderT2dGenesSection>
    .
</p>

<br/>

<nav class="navbar" role="navigation">
<div class="container-fluid">
<div class="navbar-header">
    <button type="button" class="navbar-toggle" data-toggle="collapse"
            data-target="#bs-example-navbar-collapse-1"><span class="sr-only">Toggle navigation</span><span
            class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button>
    <a class="navbar-brand">IGV</a></div>


<nav class="navbar navbar-fixed-top" role="navigation">
<div class="container-fluid">
<div class="navbar-header">
    <button type="button" class="navbar-toggle" data-toggle="collapse"
            data-target="#bs-example-navbar-collapse-1"><span class="sr-only">Toggle navigation</span><span
            class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button>
    <a class="navbar-brand" href="#">IGV</a></div>
<div id="bs-example-navbar-collapse-1" class="collapse navbar-collapse">
<ul class="nav navbar-nav navbar-left">
    <li class="dropdown" id="loci-menu-dropdown"><a href="#" class="dropdown-toggle"
                                                    data-toggle="dropdown">Loci<b class="caret"></b></a>
        <ul id="locusList" class="dropdown-menu">
            <li><a onclick="igv.browser.search('brca1')">brca1</a></li>
            <li><a onclick="igv.browser.search('chr22:24,375,948-24,384,434')">chr22:24,375,948-24,384,434</a>
            </li>
            <li><a></a></li>
        </ul>
    </li>
</ul>
<ul class="nav navbar-nav navbar-left">
<li class="dropdown" id="tracks-menu-dropdown">
<a href="#" class="dropdown-toggle" data-toggle="dropdown">Tracks<b class="caret"></b></a>
<ul id="trackList" class="dropdown-menu">
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'FastGlu',
        name: 'fasting glucose',
        description: 'This is the <a href=//www.google.com/webhp?#q=fasting+glucose>fasting glucose</a> track'
    })">fasting glucose</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: '2hrGLU_BMIAdj',
        name: 'two-hour glucose'
    })">two-hour glucose</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: '2hrIns_BMIAdj',
        name: 'two-hour insulin'
    })">two-hour insulin</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'FastIns',
        name: 'fasting insulin'
    })">fasting insulin</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'ProIns',
        name: 'fasting proinsulin'
    })">fasting proinsulin</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'HbA1c',
        name: 'HBA1C'
    })">HBA1C</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'HOMAIR',
        name: 'HOMA-IR'
    })">HOMA_IR</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'HOMAB',
        name: 'HOMA-B'
    })">HOMA_B</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'BMI',
        name: 'BMI'
    })">BMI</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'WAIST_CIRCUMFRENCE',
        name: 'waist circumference'
    })">waist circumference</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'HIP_CIRCUMFRENCE',
        name: 'hip circumference'
    })">hip circumference</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'WHR',
        name: 'waist-hip ratio'
    })">waist-hip ratio</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'Height',
        name: 'height'
    })">height</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'HDL',
        name: 'HDL'
    })">HDL</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'LDL',
        name: 'LDL'
    })">LDL</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'TG',
        name: 'triglycerides'
    })">triglycerides</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'CAD',
        name: 'coronary artery disease'
    })">coronary artery disease</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'CKD',
        name: 'coronary kidney disease'
    })">coronary kidney disease</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'eGFRcrea',
        name: 'eGFR-creat (serum creatinine)'
    })">eGFR-creat (serum creatinine)</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'eGFRcrea',
        name: 'eGFR-creat (serum creatinine)'
    })">eGFR-creat (serum creatinine)</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'eGFRcys',
        name: 'eGFR-cys (serum cystatin C)'
    })">eGFR-cys (serum cystatin C)</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'MA',
        name: 'microalbuminuria'
    })">microalbuminuria</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'UACR',
        name: 'urinary albumin-to-creatinine ratio'
    })">urinary albumin-to-creatinine ratio</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'SCZ',
        name: 'schizophrenia'
    })">schizophrenia</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'MDD',
        name: 'major depressive disorder'
    })">major depressive disorder</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'BIP',
        name: 'bipolar disorder'
    })">bipolar disorder</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'HDL',
        name: 'HDL cholesterol'
    })">HDL cholesterol</a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({
        type: 't2d',
        url: 'http://dig-dev.broadinstitute.org:8888/dev/gs/trait-search',
        trait: 'LDL',
        name: 'LDL cholesterol'
    })">LDL cholesterol</a>
</li>
</ul>
</li>
</ul>

</li>
</ul>
</li>
</ul>
<div class="nav navbar-nav navbar-left">
    <div class="well-sm">
        <input id="goBoxInput" class="form-control" placeholder="Locus Search" type="text"
               onchange="igv.browser.search($('#goBoxInput')[0].value)">
    </div>
</div>
<div class="nav navbar-nav navbar-left">
    <div class="well-sm">
        <button id="goBox" class="btn btn-default"
                onclick="igv.browser.search($('#goBoxInput')[0].value);">
            Search
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



%{--<div id="bs-example-navbar-collapse-1" class="collapse navbar-collapse">--}%
%{--<ul class="nav navbar-nav navbar-left">--}%
%{--<li class="dropdown" id="tracks-menu-dropdown">--}%
%{--<a href="#" class="dropdown-toggle" data-toggle="dropdown">Tracks<b class="caret"></b></a>--}%

%{--<ul id="trackList" class="dropdown-menu">--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'FastGlu',--}%
        %{--label: 'fasting glucose',--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>fasting glucose</strong><br/>'+--}%
                %{--'Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.')--}%
    %{--})">fasting glucose</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: '2hrGLU_BMIAdj',--}%
        %{--label: 'two-hour glucose',--}%
        %{--order: 9981,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>two-hour glucose</strong><br/>'+--}%
                %{--'Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.')--}%
    %{--})">two-hour glucose</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: '2hrIns_BMIAdj',--}%
        %{--label: 'two-hour insulin',--}%
        %{--order: 9981,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>two-hour insulin</strong><br/>'+--}%
                %{--'Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.')--}%
    %{--})">two-hour insulin</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'FastIns',--}%
        %{--label: 'fasting insulin',--}%
        %{--order: 9997,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>fasting insulin</strong><br/>'+--}%
                %{--'Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.')--}%
    %{--})">fasting insulin</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'ProIns',--}%
        %{--label: 'fasting proinsulin',--}%
        %{--order: 9982,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>fasting proinsulin</strong><br/>'+--}%
                %{--'Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.')--}%
    %{--})">fasting proinsulin</a>--}%
%{--</li>                            <li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'HbA1c',--}%
        %{--label: 'HBA1C',--}%
        %{--order: 9996,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>HbA1c</strong><br/>'+--}%
                %{--'Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.')--}%
    %{--})">HBA1C</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'HOMAIR',--}%
        %{--label: 'HOMA-IR',--}%
        %{--order: 9995,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>HOMA-IR</strong><br/>'+--}%
                %{--'Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.')--}%
    %{--})">HOMA_IR</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'HOMAB',--}%
        %{--label: 'HOMA-B',--}%
        %{--order: 9994,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>HOMA-B</strong><br/>'+--}%
                %{--'Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.')--}%
    %{--})">HOMA_B</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'BMI',--}%
        %{--label: 'BMI',--}%
        %{--order: 9993,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>BMI</strong><br/>'+--}%
                %{--'Results in this track are from a GWAS meta-analysis of as many as 123,865 people conducted by the GIANT Consortium.')--}%
    %{--})">BMI</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'WAIST_CIRCUMFRENCE',--}%
        %{--label: 'waist circumference',--}%
        %{--order: 9992,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>waist circumference</strong><br/>'+--}%
                %{--'Results in this track are from a GWAS meta-analysis of people conducted by the GIANT Consortium.')--}%
    %{--})">waist circumference</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'HIP_CIRCUMFRENCE',--}%
        %{--label: 'hip circumference',--}%
        %{--order: 9991,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>hip circumference</strong><br/>'+--}%
                %{--'Results in this track are from a GWAS meta-analysis of people conducted by the GIANT Consortium.')--}%
    %{--})">hip circumference</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'WHR',--}%
        %{--label: 'waist-hip ratio',--}%
        %{--order: 9990,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>waist-hip ratio</strong><br/>'+--}%
                %{--'Results in this track are from a GWAS meta-analysis of as many as 77,167 people conducted by the GIANT Consortium.')--}%
    %{--})">waist-hip ratio</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'Height',--}%
        %{--label: 'height',--}%
        %{--order: 9990,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>height</strong><br/>'+--}%
                %{--'Results in this track are from a GWAS meta-analysis of as many as 183,727 people conducted by the GIANT Consortium.')--}%
    %{--})">height</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'HDL',--}%
        %{--label: 'HDL',--}%
        %{--order: 9989,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>HDL cholesterol</strong><br/>'+--}%
                %{--'Results in this track are from a GWAS meta-analysis of as many as 99,900 people conducted by the Global Lipid Genetics Consortium.')--}%
    %{--})">HDL</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'LDL',--}%
        %{--label: 'LDL',--}%
        %{--order: 9988,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>LDL cholesterol</strong><br/>'+--}%
                %{--'Results in this track are from a GWAS meta-analysis of as many as 95,454 people conducted by the Global Lipid Genetics Consortium.')--}%
    %{--})">LDL</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'TG',--}%
        %{--label: 'triglycerides',--}%
        %{--order: 9987,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>triglycerides</strong><br/>'+--}%
                %{--'Results in this track are from a GWAS meta-analysis of as many as 96,598 people conducted by the Global Lipid Genetics Consortium.')--}%
    %{--})">triglycerides</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'CAD',--}%
        %{--label: 'coronary artery disease',--}%
        %{--order: 9978,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>coronary artery disease</strong><br/>'+--}%
                %{--'Results in this track are from a GWAS meta-analysis of as many as 86,995 people conducted by the CARDIoGRAM Consortium.')--}%
    %{--})">coronary artery disease</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'CKD',--}%
        %{--label: 'chronic kidney disease',--}%
        %{--order: 9977,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>chronic kidney disease</strong><br/>'+--}%
                %{--'Results in this track are from a GWAS meta-analysis of as many as 67,093 people conducted by the CKDGen Consortium.')--}%
    %{--})">chronic kidney disease</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'eGFRcrea',--}%
        %{--label: 'eGFR-creat (serum creatinine)',--}%
        %{--order: 9976,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>eGFR-creat (serum creatinine)</strong><br/>'+--}%
                %{--'Results in this track are from a GWAS meta-analysis of as many as 67,093 people conducted by the CKDGen Consortium.')--}%
    %{--})">eGFR-creat (serum creatinine)</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'eGFRcys',--}%
        %{--label: 'eGFR-cys (serum cystatin C)',--}%
        %{--order: 9975,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>eGFR-cys (serum cystatin C)</strong><br/>'+--}%
                %{--'Results in this track are from a GWAS meta-analysis of as many as 67,093 people conducted by the CKDGen Consortium.')--}%
    %{--})">eGFR-cys (serum cystatin C)</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'MA',--}%
        %{--label: 'microalbuminuria',--}%
        %{--order: 9974,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>microalbuminuria</strong><br/>'+--}%
                %{--'Results in this track are from a GWAS meta-analysis of as many as 67,093 people conducted by the CKDGen Consortium.')--}%
    %{--})">microalbuminuria</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'UACR',--}%
        %{--label: 'urinary albumin-to-creatinine ratio',--}%
        %{--order: 9973,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>urinary albumin-to-creatinine ratio</strong><br/>'+--}%
                %{--'Results in this track are from a GWAS meta-analysis of as many as 67,093 people conducted by the CKDGen Consortium.')--}%
    %{--})">urinary albumin-to-creatinine ratio</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'SCZ',--}%
        %{--label: 'schizophrenia',--}%
        %{--order: 9972,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>schizophrenia</strong><br/>'+--}%
                %{--'Results in this track are from a GWAS Psychiatric Genetics Consortium.')--}%
    %{--})">schizophrenia</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'MDD',--}%
        %{--label: 'major depressive disorder',--}%
        %{--order: 9971,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>major depressive disorder</strong><br/>'+--}%
                %{--'Results in this track are from a GWAS meta-analysis of many as 18,759 people conducted by the Psychiatric Genetics Consortium.')--}%
    %{--})">major depressive disorder</a>--}%
%{--</li>--}%
%{--<li>--}%
    %{--<a onclick="igv.browser.loadTrack({--}%
        %{--type: 't2d',--}%
        %{--url: '${restServer.currentRestServer()}trait-search',--}%
        %{--trait: 'BIP',--}%
        %{--label: 'bipolar disorder',--}%
        %{--order: 9972,--}%
        %{--colorScale:  {--}%
            %{--thresholds: [5e-8, 5e-4, 0.05],--}%
            %{--colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']--}%
        %{--},--}%
        %{--description: ('<strong>bipolar disorder</strong><br/>'+--}%
                %{--'Results in this track are from a GWAS meta-analysis of many as 16,731 people conducted by the Psychiatric Genetics Consortium.')--}%
    %{--})">bipolar disorder</a>--}%
%{--</li>--}%
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
            Search
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
