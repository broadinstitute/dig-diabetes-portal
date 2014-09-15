

<script>
    function  igvSearch(searchString) {
        igv.browser.search(searchString);
        return true;
    }
</script>


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
            locus:'SLC30A8',
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


