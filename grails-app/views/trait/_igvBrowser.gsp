
%{--Why I am forced to include style directives explicitly in this page and no other I do not know. There must be--}%
%{--something funny about IGV's use of CSS that is different than everything else in the application.  //TODO -- fix this--}%
<g:set var="restServer" bean="restServerService"/>
<style>
.btn-primary {
    background: #052090;
    border-color: #052090; }

h1, h2, h3, h4, label {
    font-weight: 300; }

label, .radio label, .checkbox label {
    font-weight: 300; }

.input-group-lg > .form-control, .input-group-lg > .input-group-addon, .input-group-lg > .input-group-btn > .btn {
    border-radius: initial; }

.btn, .btn-lg, .btn-group-lg > .btn {
    border-radius: initial; }

.form-control {
    border-radius: initial; }

* {
    font-family: 'Lato';
    font-weight: 300; }

body {
    font-size: 16px; }

a {
    color: #052090; }

a.variantlink {
    font-weight: bold; }
a.genelink {
    font-weight: bold;
    font-style: italic;
}

h1 {
    font-size: 44px;
    font-weight: 300;
    margin-top: 0.4em;
    margin-bottom: 0.2em; }
h1 small {
    font-size: 16px;
    color: #939393;
    font-weight: 300;
    vertical-align: middle; }

h2 small {
    font-weight: 300; }

h4 {
    font-size: 22px; }

div.lead {
    font-size: 28px; }

div#branding {
    font-size: 44px;
    text-transform: uppercase;
    font-weight: 300;
    margin: 24px 0 18px; }
div#branding small {
    text-transform: none;
    font-size: 24px;
    color: #C7C4C4; }

a.page-nav-link {
    color: white;
    background: #052090;
    padding: 8px 12px;
    margin-right: 10px;
    font-size: 16px;
    margin: 5px 5px;
    vertical-align: middle;
    text-transform: lowercase; }
div.adminform {
    padding: 8px 12px;
}
.adminform2  {
    padding: 8px 12px;
}
div.separator {
    height: 1px;
    border-top: 1px solid #aaa;
    margin: 20px 0; }

div.linkout {
    padding: 10px 0; }
div.linkout a {
    color: white;
    background: #052090;
    padding: 8px 12px;
    margin-right: 10px; }

table.basictable {
    width: 100%; }
table.basictable th, table.basictable td {
    text-align: center; }
table.basictable th.datatype-header {
    border-left: 1px solid black; }
table.basictable thead th {
    padding: 9px;
    background: #052090;
    color: white;
    font-size: 14px; }
table.basictable thead th.sorting_desc:before {
    content: "▴ "; }
table.basictable thead th.sorting_asc:before {
    content: "▾ "; }

.variants-container::-webkit-scrollbar {
    -webkit-appearance: none; }

.variants-container::-webkit-scrollbar:horizontal {
    height: 11px; }

.variants-container::-webkit-scrollbar-thumb {
    border-radius: 8px;
    border: 1px solid white;
    /* should match background, can't be transparent */
    background-color: rgba(0, 0, 0, 0.5); }

.variants-container::-webkit-scrollbar-track {
    background-color: #fff;
    border-radius: 8px; }

.dataTables_length {
    display: none; }

.big-button-container {
    text-align: center;
    padding: 20px; }

.translational-research-box {
    padding: 20px;
    margin: 20px 0;
    background: whitesmoke;
    border: 1px solid #aaa; }

.login-header {
    padding: 40px 0;
    text-align: center; }
.login-header h1 {
    font-size: 50px; }

.section-header {
    font-size: 24px; }

.variant-search-form h4 {
    margin: 20px 0 12px;
    font-size: 24px; }

.main-searchbox .typeahead {
    font-size: 20px; }

.tabbed-about-page {
    min-width: 960px;
    margin: 30px 0; }
.tabbed-about-page .sidebar {
    width: 20%;
    box-sizing: border-box;
    float: left;
    padding-top: 20px; }
.tabbed-about-page .sidebar .tab {
    padding: 10px 24px; }
.tabbed-about-page .sidebar .tab.active {
    color: white;
    background: #052090; }
.tabbed-about-page .sidebar .tab:hover {
    background: rgba(13, 64, 136, 0.2);
    cursor: pointer; }
.tabbed-about-page .sidebar .tab.active:hover {
    background: #052090; }
.tabbed-about-page .sidebar .sep {
    width: 60%;
    margin: 10px auto;
    border-top: 1px solid #999; }
.tabbed-about-page .section {
    width: 80%;
    box-sizing: border-box;
    float: left;
    padding: 20px;
    min-height: 200px; }
.tabbed-about-page .section-blue {
    background: #052090;
    color: white; }
.tabbed-about-page .paper {
    padding: 6px 0; }
.tabbed-about-page .paper a {
    font-weight: bold;
    cursor: pointer;
    text-decoration: underline;
    color: #588fd3;
    margin-bottom: 10px;
    font-size: 20px; }
.tabbed-about-page .paper .citation {
    font-size: 12px;
    padding-top: 6px; }

a.boldlink {
    font-weight: bold;
    cursor: pointer;
    text-decoration: underline;
    color: #588fd3; }
a.mgr {
    color: #003300;
    font-weight: bolder
}
a.boldItlink {
    font-weight: bold;
    cursor: pointer;
    text-decoration: underline;
    color: #588fd3;
    font-style: italic}

.transcript-annotation {
    padding-left: 30px;
    border-left: 4px solid #052090; }

.about-people {
    font-size: 12px; }
.about-people .institution {
    padding: 8px 0; }
.about-people .name {
    text-decoration: underline; }
.about-people a.pi {
    color: yellow; }

p.leadlink {
    font-size: 18px;
    color: #888;
    padding: 5px 0; }
p.leadlink a {
    font-weight: bold;
    cursor: pointer;
    text-decoration: underline;
    color: #588fd3; }

div.cohort {
    border-top: 1px solid #ddd;
    margin: 12px 0;
    padding: 12px 0; }
div.cohort a {
    font-weight: bold;
    cursor: pointer;
    text-decoration: underline;
    color: #588fd3; }
div.cohort .name {
    font-size: 24px;
    padding-bottom: 8px; }
div.cohort .name span {
    font-weight: bold; }
div.cohort .detail {
    font-size: 18px; }
div.cohort .detail span {
    font-weight: bold; }
div.cohort .bullets .title {
    font-size: 18px;
    font-weight: bold; }

.term-description {
    font-size: 12px;
    color: #909090;
    line-height: 1.2em;
}
.term-description-expansion {
//   border: 1px solid black;
    line-height: 1.2em;
}
.gwas-table-container {
    margin-top: 30px; }

.variants-container {
    overflow-x: scroll; }

.vis-container {
    text-align: center; }
.vis-container .text-highlight {
    font-weight: bold; }
.vis-container #tooltip {
    position: absolute;
    width: 200px;
    height: auto;
    padding: 10px;
    background-color: white;
    -webkit-border-radius: 10px;
    -moz-border-radius: 10px;
    border-radius: 10px;
    -webkit-box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);
    -moz-box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);
    box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);
    pointer-events: none; }
.vis-container #tooltip.hidden {
    display: none; }
.vis-container #tooltip p {
    margin: 0;
    font-family: sans-serif;
    font-size: 12px;
    line-height: 20px; }
.vis-container #tooltip .header {
    font-weight: bold;
    text-align: center;
    border-bottom: 1px solid #eaebec;
    margin-bottom: 2px; }

span.dotlabel {
    padding-top: 8px; }

.assoc-up {
    fill: #6fb7f7;
    color: #6fb7f7; }

.assoc-down {
    fill: red;
    color: red; }

.assoc-none {
    fill: white; }

.variantlabel {
    font-weight: bold;
    cursor: pointer;
    text-decoration: underline;
    color: #588fd3;
    fill: #588fd3; }

.gene-summary {
    margin: 20px 0;
    border: 1px solid #e0e0e0;
    padding: 20px; }
.gene-summary .bottom {
    border-top: 1px solid #e0e0e0;
    padding-top: 12px; }
.gene-summary .title {
    font-weight: bold;
    font-size: 20px;
    text-transform: uppercase;
    padding-bottom: 5px; }
.gene-summary a {
    font-weight: bold;
    cursor: pointer;
    text-decoration: underline;
    color: #588fd3; }

.form-callout {
    margin-top: 40px;
    margin-bottom: 40px; }

.rightlinks {
    float: right; }

#language {
    float: right;
    margin-top: 10px; }

img.currentlanguage {
    box-shadow: 0px 0px 16px #ddd; }

.greyedout {
    color: #aaa; }

.section-content a {
    font-weight: bold;
    cursor: pointer;
    text-decoration: underline;
    color: #588fd3; }

.sigma-institution {
    font-size: 14px;
    padding-bottom: 8px; }
.sigma-institution .program {
    font-weight: bold; }

#header {
    color: white;
    text-transform: uppercase; }
#header a, #header a:visited {
    color: white;
    padding: 0 6px; }

#header-top {
    background: #052090; }

#header-bottom {
    background: rgba(43, 117, 207, 0.68);
    padding: 10px 0; }

body {
    background: white; }

#main {
    padding: 40px 0 80px; }

#footer {
    padding: 20px 0 40px;
    font-size: 1.5em; }

#belowfooter {
    height: 150px; }
</style>
<script>
        function  igvSearch(searchString) {
                igv.browser.search(searchString);
                return true;
            }
</script>

<div id="myDiv">
<p>
    Use the browser below to explore all genome-wide and locus-wide
    significant variants within 100kb of this gene. Choose "Tracks" to view
    results relevant to type 2 diabetes
    <g:renderNotSigmaSection>
        (exome sequencing, exome chip, or GWAS)
    </g:renderNotSigmaSection>
    or any of 24 other related traits
    <g:renderNotSigmaSection>
        (GWAS)
    </g:renderNotSigmaSection>
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
            <div id="bs-example-navbar-collapse-1" class="collapse navbar-collapse">
                <ul class="nav navbar-nav navbar-left">
                    <li class="dropdown" id="tracks-menu-dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Tracks<b class="caret"></b></a>
                        <ul id="trackList" class="dropdown-menu">
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '${restServer.currentRestServer()}trait-search',
                                    trait: 'FastGlu',
                                    label: 'fasting glucose',
                                    colorScale:  {
                                        thresholds: [5e-8, 5e-4, 0.05],
                                        colors: ['rgb(0,102,51)', 'rgb(122,179,23)', 'rgb(158,213,76)', 'rgb(227,238,249)']
                                    },
                                    description: ('<strong>fasting glucose</strong><br/>'+
                                            'Results in this track are from a study of 79,854 people conducted by the GoT2D consortium.')
                                })">fasting glucose</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">two-hour glucose</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">two-hour insulin</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">fasting insulin</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">fasting proinsulin</a>
                            </li>                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">HBA1C</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">HOMA_IR</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">HOMA_B</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">BMI</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">waist circumference</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">hip circumference</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">waist-hip ratio</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">height</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">HDL</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">LDL</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">triglycerides</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">coronary artery disease</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">chronic kidney disease</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">eGFR-creat (serum creatinine)</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">eGFR-cys (serum cystatin C)</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">microalbuminuria</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">urinary albumin-to-creatinine ratio</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">schizophrenia</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">major depressive disorder</a>
                            </li>
                                <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
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
                                })">bipolar disorder</a>
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
