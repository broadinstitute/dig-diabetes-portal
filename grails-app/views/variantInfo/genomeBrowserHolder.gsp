<%--
  Created by IntelliJ IDEA.
  User: balexand
  Date: 1/22/2020
  Time: 9:36 AM
--%>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require module="genomeBrowser"/>

    <r:layoutResources/>


</head>

<body>
<div class="text-center">
    <h2>Genome browser</h2>
</div>



%{--try example start--}%


%{--<nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">--}%

    <div class="row">
        <div class="col-md-6">
            <div class="nav-item dropdown">
                <a id="igv-example-api-dropdown" href="#" class="dropdown-toggle" data-toggle="dropdown"
                   aria-haspopup="true" aria-expanded="false" style="font-size: 24px; text-decoration: underline">Tracks</a>
                <ul class="dropdown-menu">

                    <li>
                        <a href="#"
                           onclick="igv.browser.loadTrack({
                               url: 'https://data.broadinstitute.org/igvdata/test/igv-web/segmented_data_080520.seg.gz',
                               indexed: false,
                               isLog: true,
                               name: 'GBM Copy # (TCGA Broad GDAC)'});">GBM Copy # (TCGA Broad GDAC))</a>
                    </li>

                    <li>
                        <a href="#"
                           onclick="igv.browser.loadTrack({
                               type: 'annotation',
                               format: 'bed',
                               url: 'https://data.broadinstitute.org/igvdata/annotations/hg19/dbSnp/snp137.hg19.bed.gz',
                               indexURL: 'https://data.broadinstitute.org/igvdata/annotations/hg19/dbSnp/snp137.hg19.bed.gz.tbi',
                               visibilityWindow: 200000,
                               name: 'dbSNP 137'})">dbSNP 137 (bed tabix)
                        </a>
                    </li>

                    <li>
                        <a href="#"
                           onclick="igv.browser.loadTrack(
                               {
                                   type: 'wig',
                                   format: 'bigwig',
                                   url: 'https://s3.amazonaws.com/igv.broadinstitute.org/data/hg19/encode/wgEncodeBroadHistoneGm12878H3k4me3StdSig.bigWig',
                                   name: 'Gm12878H3k4me3'
                               })">Encode bigwig
                        </a>
                    </li>

                    <li>
                        <a href="#"
                           onclick="igv.browser.loadTrack(
                               {
                                   type: 'alignment',
                                   format: 'bam',
                                   url:'https://1000genomes.s3.amazonaws.com/phase3/data/HG02450/alignment/HG02450.mapped.ILLUMINA.bwa.ACB.low_coverage.20120522.bam',
                                   name: 'HG02450'
                               })">1KG Bam (HG02450)
                        </a>
                    </li>

                </ul>
            </div>

        </div>
        <div class="col-md-6">
            <div>Click on the Refseq track to add genes:</div>
            <div id="geneList" width="100%" style="background-color: #d5d5d5">

            </div>
        </div>
    </div>
%{--</nav>--}%


%{--try example end--}%








<div id="mainVariantDivHolder">
</div>

<div id="igv-div">

</div>
<g:render template="/genomeBrowser/igv" />

</body>
</html>