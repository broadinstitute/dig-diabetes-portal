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
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'FASTING_GLUCOSE',
                                    label: 'fasting glucose'
                                })">fasting glucose</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'FASTING_INSULIN',
                                    label: 'fasting insulin'
                                })">fasting insulin</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'HbA1c',
                                    label: 'HBA1C'
                                })">HBA1C</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'HOMA_IR',
                                    label: 'HOMA-IR'
                                })">HOMA_IR</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'HOMA_B',
                                    label: 'HOMA-B'
                                })">HOMA_B</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'BMI',
                                    label: 'BMI'
                                })">BMI</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'WAIST_CIRCUMFRENCE',
                                    label: 'waist circumference'
                                })">waist circumference</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'HIP_CIRCUMFRENCE',
                                    label: 'hip circumference'
                                })">hip circumference</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'WAIST_HIP_RATIO',
                                    label: 'waist-hip ratio'
                                })">waist-hip ratio</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'HDL',
                                    label: 'HDL'
                                })">HDL</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'LDL',
                                    label: 'LDL'
                                })">LDL</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'TRIGLYCERIDES',
                                    label: 'triglycerides'
                                })">triglycerides</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'TOTAL_CHOLESTEROL',
                                    label: 'total cholesterol'
                                })">total cholesterol</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'SYSTOLIC_BLOOD_PRESSURE',
                                    label: 'systolic blood pressure'
                                })">systolic blood pressure</a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    type: 't2d',
                                    url: '//www.broadinstitute.org/igvdata/t2d/postJson.php',
                                    trait: 'DIASTOLIC_BLOOD_PRESSURE',
                                    label: 'diastolic blood pressure'
                                })">diastolic blood pressure</a>
                            </li>

                            <li>
                                <a onclick="igv.browser.loadTrack({
                                    url: 'http://www.broadinstitute.org/igvdata/BodyMap/hg19/IlluminaHiSeq2000_BodySites/brain_merged/accepted_hits.bam',
                                    label: 'BodyMap Brain'
                                })">Body
                                map brain</a>
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
                        <button id="goBox" class="btn btn-default" onclick="igv.browser.search($('#goBox')[0].value);">
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
            fastaURL: "//igvdata.broadinstitute.org/genomes/seq/hg19/hg19.fasta",
            cytobandURL: "//igvdata.broadinstitute.org/genomes/seq/hg19/cytoBand.txt",
            tracks: [
                new igv.T2dTrack({
                    url: "//www.broadinstitute.org/igvdata/t2d/postJson.php",
                    trait: "T2D",
                    label: "Type II Diabetes"
                }),
                new igv.SequenceTrack(),
                new igv.GeneTrack({
                    url: "//igvdata.broadinstitute.org/annotations/hg19/genes/gencode.v18.collapsed.bed",
                    label: "Genes"
                })
           ]
        };
        browser = igv.createBrowser(options);
        div.appendChild(browser.div);
        browser.startup();
    });

</script>


