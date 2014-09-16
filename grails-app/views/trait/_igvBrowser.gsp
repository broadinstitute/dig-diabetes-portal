

%{--Why I am forced to include style directives explicitly in this page and no other I do not know. There must be--}%
%{--something funny about IGV's use of CSS that is different than everything else in the application.  //TODO -- fix this--}%
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
%{--@import url(typeahead.js-bootstrap.css);--}%
%{--h1, h2, h3, h4, label {--}%
    %{--font-weight: 300; }--}%

%{--label, .radio label, .checkbox label {--}%
    %{--font-weight: 300; }--}%

%{--.input-group-lg > .form-control, .input-group-lg > .input-group-addon, .input-group-lg > .input-group-btn > .btn {--}%
    %{--border-radius: initial; }--}%

%{--.btn, .btn-lg, .btn-group-lg > .btn {--}%
    %{--border-radius: initial; }--}%

%{--.form-control {--}%
    %{--border-radius: initial; }--}%

%{--* {--}%
    %{--font-family: 'Lato';--}%
    %{--font-weight: 300; }--}%

%{--body {--}%
    %{--font-size: 16px; }--}%

%{--a {--}%
    %{--color: #052090; }--}%

%{--a.variantlink {--}%
    %{--font-weight: bold; }--}%
%{--a.genelink {--}%
    %{--font-weight: bold;--}%
    %{--font-style: italic;--}%
%{--}--}%

%{--h1 {--}%
    %{--font-size: 44px;--}%
    %{--font-weight: 300;--}%
    %{--margin-top: 0.4em;--}%
    %{--margin-bottom: 0.2em; }--}%
%{--h1 small {--}%
    %{--font-size: 16px;--}%
    %{--color: #939393;--}%
    %{--font-weight: 300;--}%
    %{--vertical-align: middle; }--}%

%{--h2 small {--}%
    %{--font-weight: 300; }--}%

%{--h4 {--}%
    %{--font-size: 22px; }--}%

%{--div.lead {--}%
    %{--font-size: 28px; }--}%

%{--div#branding {--}%
    %{--font-size: 44px;--}%
    %{--text-transform: uppercase;--}%
    %{--font-weight: 300;--}%
    %{--margin: 24px 0 18px; }--}%
%{--div#branding small {--}%
    %{--text-transform: none;--}%
    %{--font-size: 24px;--}%
    %{--color: #C7C4C4; }--}%

%{--a.page-nav-link {--}%
    %{--color: white;--}%
    %{--background: #052090;--}%
    %{--padding: 8px 12px;--}%
    %{--margin-right: 10px;--}%
    %{--font-size: 16px;--}%
    %{--margin: 5px 5px;--}%
    %{--vertical-align: middle;--}%
    %{--text-transform: lowercase; }--}%
%{--div.adminform {--}%
    %{--padding: 8px 12px;--}%
%{--}--}%
%{--.adminform2  {--}%
    %{--padding: 8px 12px;--}%
%{--}--}%
%{--div.separator {--}%
    %{--height: 1px;--}%
    %{--border-top: 1px solid #aaa;--}%
    %{--margin: 20px 0; }--}%

%{--div.linkout {--}%
    %{--padding: 10px 0; }--}%
%{--div.linkout a {--}%
    %{--color: white;--}%
    %{--background: #052090;--}%
    %{--padding: 8px 12px;--}%
    %{--margin-right: 10px; }--}%

%{--table.basictable {--}%
    %{--width: 100%; }--}%
%{--table.basictable th, table.basictable td {--}%
    %{--text-align: center; }--}%
%{--table.basictable th.datatype-header {--}%
    %{--border-left: 1px solid black; }--}%
%{--table.basictable thead th {--}%
    %{--padding: 9px;--}%
    %{--background: #052090;--}%
    %{--color: white;--}%
    %{--font-size: 14px; }--}%
%{--table.basictable thead th.sorting_desc:before {--}%
    %{--content: "▴ "; }--}%
%{--table.basictable thead th.sorting_asc:before {--}%
    %{--content: "▾ "; }--}%
%{--.login-header h1 {--}%
    %{--font-size: 50px; }--}%

%{--.section-header {--}%
    %{--font-size: 24px; }--}%

%{--.variant-search-form h4 {--}%
    %{--margin: 20px 0 12px;--}%
    %{--font-size: 24px; }--}%

%{--.main-searchbox .typeahead {--}%
    %{--font-size: 20px; }--}%

%{--.tabbed-about-page {--}%
    %{--min-width: 960px;--}%
    %{--margin: 30px 0; }--}%
%{--.tabbed-about-page .sidebar {--}%
    %{--width: 20%;--}%
    %{--box-sizing: border-box;--}%
    %{--float: left;--}%
    %{--padding-top: 20px; }--}%
%{--.tabbed-about-page .sidebar .tab {--}%
    %{--padding: 10px 24px; }--}%
%{--.tabbed-about-page .sidebar .tab.active {--}%
    %{--color: white;--}%
    %{--background: #052090; }--}%
%{--.tabbed-about-page .sidebar .tab:hover {--}%
    %{--background: rgba(13, 64, 136, 0.2);--}%
    %{--cursor: pointer; }--}%
%{--.tabbed-about-page .sidebar .tab.active:hover {--}%
    %{--background: #052090; }--}%
%{--.tabbed-about-page .sidebar .sep {--}%
    %{--width: 60%;--}%
    %{--margin: 10px auto;--}%
    %{--border-top: 1px solid #999; }--}%
%{--.tabbed-about-page .section {--}%
    %{--width: 80%;--}%
    %{--box-sizing: border-box;--}%
    %{--float: left;--}%
    %{--padding: 20px;--}%
    %{--min-height: 200px; }--}%
%{--.tabbed-about-page .section-blue {--}%
    %{--background: #052090;--}%
    %{--color: white; }--}%
%{--.tabbed-about-page .paper {--}%
    %{--padding: 6px 0; }--}%
%{--.tabbed-about-page .paper a {--}%
    %{--font-weight: bold;--}%
    %{--cursor: pointer;--}%
    %{--text-decoration: underline;--}%
    %{--color: #588fd3;--}%
    %{--margin-bottom: 10px;--}%
    %{--font-size: 20px; }--}%
%{--.tabbed-about-page .paper .citation {--}%
    %{--font-size: 12px;--}%
    %{--padding-top: 6px; }--}%
%{--.about-people .institution {--}%
    %{--padding: 8px 0; }--}%
%{--.about-people .name {--}%
    %{--text-decoration: underline; }--}%
%{--.about-people a.pi {--}%
    %{--color: yellow; }--}%

%{--p.leadlink {--}%
    %{--font-size: 18px;--}%
    %{--color: #888;--}%
    %{--padding: 5px 0; }--}%
%{--p.leadlink a {--}%
    %{--font-weight: bold;--}%
    %{--cursor: pointer;--}%
    %{--text-decoration: underline;--}%
    %{--color: #588fd3; }--}%

%{--div.cohort {--}%
    %{--border-top: 1px solid #ddd;--}%
    %{--margin: 12px 0;--}%
    %{--padding: 12px 0; }--}%
%{--div.cohort a {--}%
    %{--font-weight: bold;--}%
    %{--cursor: pointer;--}%
    %{--text-decoration: underline;--}%
    %{--color: #588fd3; }--}%
%{--div.cohort .name {--}%
    %{--font-size: 24px;--}%
    %{--padding-bottom: 8px; }--}%
%{--div.cohort .name span {--}%
    %{--font-weight: bold; }--}%
%{--div.cohort .detail {--}%
    %{--font-size: 18px; }--}%
%{--div.cohort .detail span {--}%
    %{--font-weight: bold; }--}%
%{--div.cohort .bullets .title {--}%
    %{--font-size: 18px;--}%
    %{--font-weight: bold; }--}%

%{--.vis-container .text-highlight {--}%
    %{--font-weight: bold; }--}%
%{--.vis-container #tooltip {--}%
    %{--position: absolute;--}%
    %{--width: 200px;--}%
    %{--height: auto;--}%
    %{--padding: 10px;--}%
    %{--background-color: white;--}%
    %{---webkit-border-radius: 10px;--}%
    %{---moz-border-radius: 10px;--}%
    %{--border-radius: 10px;--}%
    %{---webkit-box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);--}%
    %{---moz-box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);--}%
    %{--box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);--}%
    %{--pointer-events: none; }--}%
%{--.vis-container #tooltip.hidden {--}%
    %{--display: none; }--}%
%{--.vis-container #tooltip p {--}%
    %{--margin: 0;--}%
    %{--font-family: sans-serif;--}%
    %{--font-size: 12px;--}%
    %{--line-height: 20px; }--}%
%{--.vis-container #tooltip .header {--}%
    %{--font-weight: bold;--}%
    %{--text-align: center;--}%
    %{--border-bottom: 1px solid #eaebec;--}%
    %{--margin-bottom: 2px; }--}%

%{--span.dotlabel {--}%
    %{--padding-top: 8px; }--}%

%{--.gene-summary .bottom {--}%
    %{--border-top: 1px solid #e0e0e0;--}%
    %{--padding-top: 12px; }--}%
%{--.gene-summary .title {--}%
    %{--font-weight: bold;--}%
    %{--font-size: 20px;--}%
    %{--text-transform: uppercase;--}%
    %{--padding-bottom: 5px; }--}%
%{--.gene-summary a {--}%
    %{--font-weight: bold;--}%
    %{--cursor: pointer;--}%
    %{--text-decoration: underline;--}%
    %{--color: #588fd3; }--}%


%{--.section-content a {--}%
    %{--font-weight: bold;--}%
    %{--cursor: pointer;--}%
    %{--text-decoration: underline;--}%
    %{--color: #588fd3; }--}%

%{--.sigma-institution {--}%
    %{--font-size: 14px;--}%
    %{--padding-bottom: 8px; }--}%
%{--.sigma-institution .program {--}%
    %{--font-weight: bold; }--}%

%{--#header a, #header a:visited {--}%
    %{--color: white;--}%
    %{--padding: 0 6px; }--}%

%{--body {--}%
    %{--background: white; }--}%

%{--</style>--}%

<div id="myDiv">

    <nav class="navbar" role="navigation">
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
                            <li><a onclick="igvSearch('slc30a8')">SLC30A8</a></li>
                            <li><a onclick="igvSearch('chr22:24,375,948-24,384,434')">chr22:24,375,948-24,384,434</a>
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
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'FastGlu',
                                    label: 'fasting glucose',
                                    order: 9998
                                })">fasting glucose</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: '2hrGLU_BMIAdj',
                                    label: 'two-hour glucose',
                                    order: 9981
                                })">two-hour glucose</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: '2hrIns_BMIAdj',
                                    label: 'two-hour insulin',
                                    order: 9981
                                })">two-hour insulin</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'FastIns',
                                    label: 'fasting insulin',
                                    order: 9997
                                })">fasting insulin</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'ProIns',
                                    label: 'fasting proinsulin',
                                    order: 9982
                                })">fasting proinsulin</a>
                            </li>                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'HbA1c',
                                    label: 'HBA1C',
                                    order: 9996
                                })">HBA1C</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'HOMAIR',
                                    label: 'HOMA-IR',
                                    order: 9995
                                })">HOMA_IR</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'HOMAB',
                                    label: 'HOMA-B',
                                    order: 9994
                                })">HOMA_B</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'BMI',
                                    label: 'BMI',
                                    order: 9993
                                })">BMI</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'WAIST_CIRCUMFRENCE',
                                    label: 'waist circumference',
                                    order: 9992
                                })">waist circumference</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'HIP_CIRCUMFRENCE',
                                    label: 'hip circumference',
                                    order: 9991
                                })">hip circumference</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'WHR',
                                    label: 'waist-hip ratio',
                                    order: 9990
                                })">waist-hip ratio</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'Height',
                                    label: 'height',
                                    order: 9990
                                })">height</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'HDL',
                                    label: 'HDL',
                                    order: 9989
                                })">HDL</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'LDL',
                                    label: 'LDL',
                                    order: 9988
                                })">LDL</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'TG',
                                    label: 'triglycerides',
                                    order: 9987
                                })">triglycerides</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'CAD',
                                    label: 'coronary artery disease',
                                    order: 9978
                                })">coronary artery disease</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'CKD',
                                    label: 'coronary kidney disease',
                                    order: 9977
                                })">coronary kidney disease</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'eGFRcrea',
                                    label: 'eGFR-creat (serum creatinine)',
                                    order: 9976
                                })">eGFR-creat (serum creatinine)</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'eGFRcrea',
                                    label: 'eGFR-creat (serum creatinine)',
                                    order: 9976
                                })">eGFR-creat (serum creatinine)</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'eGFRcys',
                                    label: 'eGFR-cys (serum cystatin C)',
                                    order: 9975
                                })">eGFR-cys (serum cystatin C)</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'MA',
                                    label: 'microalbuminuria',
                                    order: 9974
                                })">microalbuminuria</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'UACR',
                                    label: 'urinary albumin-to-creatinine ratio',
                                    order: 9973
                                })">urinary albumin-to-creatinine ratio</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'SCZ',
                                    label: 'schizophrenia',
                                    order: 9972
                                })">schizophrenia</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'MDD',
                                    label: 'major depressive disorder',
                                    order: 9971
                                })">major depressive disorder</a>
                            </li>
                                <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'BIP',
                                    label: 'bipolar disorder',
                                    order: 9972
                                })">bipolar disorder</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'HDL',
                                    label: 'HDL cholesterol',
                                    order: 9980
                                })">HDL cholesterol</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'LDL',
                                    label: 'LDL cholesterol',
                                    order: 9979
                                })">LDL cholesterol</a>
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

<script type="text/javascript">

    $(document).ready(function () {

        var div, options, browser;

        div = $("#myDiv")[0];
        options = {
            showKaryo: false,
            locus:'${geneName}',
            fastaURL: "//igvdata.broadinstitute.org/genomes/seq/hg19/hg19.fasta",
            cytobandURL: "//igvdata.broadinstitute.org/genomes/seq/hg19/cytoBand.txt",
            tracks: [
                new igv.T2dTrack({
                    url: "//www.broadinstitute.org/igvdata/t2d/postJson.php",
                    trait: "T2D",
                    label: "Type II Diabetes"
                }),
                new igv.WIGTrack({
                    url: "//www.broadinstitute.org/igvdata/t2d/recomb_decode.bedgraph",
                    label: "Recombination rate",
                    order: 9998
                }),
                new igv.SequenceTrack({order:9999}),
                new igv.GeneTrack({
                    url: "//igvdata.broadinstitute.org/annotations/hg19/genes/gencode.v18.collapsed.bed",
                    label: "Genes",
                    order: 9998

                })
           ]
        };
        browser = igv.createBrowser(options);
        div.appendChild(browser.div);
        browser.startup();
        //igvSearch('${geneName}')
    });

</script>


