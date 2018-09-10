<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="informational"/>
    <r:layoutResources/>

    <style>
    #main > div {
        margin: auto;
    }

    .modules-table td { vertical-align: middle !important; }
    </style>
</head>


<body>
<div id="main">
    <div class="container dk-static-content">
        <div class="row">
            <div class="col-md-12">
                <h1 class="dk-page-title">Analysis Modules</h1>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <h5 class="dk-under-header">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</h5>
            </div>
        </div>



        <div class="row">
            <div class="col-md-12">
                <table class="table modules-table">
                    <thead>
                        <tr>
                            <th style="width:20%;">Module</th><th style="width:60%;">Description</th><th style="width:20%;">Launch</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><h4>LD Clumping</h4></td>
                            <td><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
                            Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
                            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
                            Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
                                <p>View full genetic association results for a phenotype <br>(ex: bmi, glycemic; '=phenotype' for exact match)</p></td>
                            <td><div class="btn dk-t2d-blue dk-tutorial-button dk-right-column-buttons-compact"><a href="javascript:;">Launch LD Clumping</a></div></td>
                        </tr>
                        <tr>
                            <td><h4>Variant Finder</h4></td>
                            <td>
                                <p>This versatile tool lets you specify multiple search criteria to find genetic variants meeting those criteria.
                                You can choose search criteria on either or both of the tabs below. Add multiple criteria until you have specified all your criteria of interest,
                                then submit the search request. The variants that meet <b>all</b> of your criteria will be returned.</p>
                                <div style="float: left; margin-top: 5px;" class="dk-t2d-green dk-tutorial-button dk-right-column-buttons-compact"><a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/VariantFinderTutorial.pdf" target="_blank">Variant Finder tutorial</a></div>
                                <div style="float: left; margin-top: 5px; margin-left: 5px;" class="dk-t2d-green dk-reference-button dk-right-column-buttons-compact"><a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/Phenotype_reference_guide.pdf" target="_blank">Phenotype Reference Guide</a></div>
                            </td>
                            <td><div class="btn dk-t2d-blue dk-tutorial-button dk-right-column-buttons-compact"><a href="javascript:;">Launch Variant Finder</a></div></td>
                        </tr>
                        <tr>
                            <td><h4>GAIT</h4></td>
                            <td>
                                <p>The Genetic Association Interactive Tool allows you to compute custom association statistics by specifying the phenotype to test for association,
                            a subset of samples to analyze based on specific phenotypic criteria, and a set of covariates to control for in the analysis.
                                In order to protect patient privacy, GAIT will only allow visualization or analysis of data from more than 100 individuals.</p>
                                <div style="float: left; margin-top: 5px;" class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact ">
                                    <a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/KP_GAIT_guide.pdf" target="_blank">GAIT guide</a>
                                </div></td>
                            <td><div class="btn dk-t2d-blue dk-tutorial-button dk-right-column-buttons-compact"><a href="javascript:;">Launch GAIT</a></div></td>
                        </tr>
                        <tr>
                            <td><h4>LocusZoom</h4></td>
                            <td>View full genetic association results for a phenotype <br><small>(ex: bmi, glycemic; '=phenotype' for exact match)</small></td>
                            <td><div class="btn dk-t2d-blue dk-tutorial-button dk-right-column-buttons-compact"><a href="javascript:;">Launch LocusZoom</a></div></td>
                        </tr>
                        <tr>
                            <td><h4>LD Score</h4></td>
                            <td>View full genetic association results for a phenotype <br><small>(ex: bmi, glycemic; '=phenotype' for exact match)</small></td>
                            <td><div class="btn dk-t2d-blue dk-tutorial-button dk-right-column-buttons-compact"><a href="javascript:;">Launch LD Score</a></div></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <h3>/* Make this section available to users when Search UIs functional. */</h3>
                <ul class="nav nav-tabs">
                    <li class="active"><a data-toggle="tab" href="#ldClumping">LD Clumping</a></li>
                    <li><a data-toggle="tab" href="#variantFinder">Variant Finder</a></li>
                    <li><a data-toggle="tab" href="#GAIT">GAIT</a></li>
                    <li><a data-toggle="tab" href="#locusZoom">LocusZoom</a></li>
                    <li><a data-toggle="tab" href="#ldScore">LD Score</a></li>
                </ul>

                <div class="tab-content">
                    <div id="ldClumping" class="tab-pane fade in active">
                        <h3>View full genetic association results for a phenotype</h3>
                        <p style="font-size: 16px;">
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
                        Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
                        Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
                        Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                        </p>

                        <div class="traits-filter-wrapper">
                                <div class="form-inline" style="margin: auto;">
                                    <div class="traits-filter-ui" style="width: 600px; margin: auto;">
                                        <span style="display:block; margin:0px 0 8px 0; font-size:13px;">(ex: bmi, glycemic; '=phenotype' for exact match)</span>
                                        <input id="traits-filter" placeholder="Filter phenotypes" type="text" class="form-control input-sm" style="clear: left; float:left; width: 89%; height: 35px; background-color:#fff; border:solid 1px #ddd; border-bottom-left-radius: 5px; border-top-left-radius: 5px; border-bottom-right-radius: 0px; border-top-right-radius: 0px; margin:0 0 5px 0; font-size: 16px;">
                                        <div style="float: right; font-size: 20px; padding: 5px 0 1px 0; color: #fff; background-color: #62B4C5; width: 10%; height: 35px; border:solid 1px #999; border-bottom-right-radius: 5px; border-top-right-radius: 5px; text-align: center; margin-right: 1%"><span class="glyphicon glyphicon-refresh" aria-hidden="true"></span></div>
                                    </div>
                                </div>
                        </div>

                    </div>


                    <div id="variantFinder" class="tab-pane fade">
                        <h3>filter by p-value, odds ratio, predicted effect on protein, and more</h3>
                        <p style="font-size: 16px;">This versatile tool lets you specify multiple search criteria to find genetic variants meeting those criteria.
                        You can choose search criteria on either or both of the tabs below. Add multiple criteria until you have specified all your criteria of interest,
                        then submit the search request. The variants that meet <b>all</b> of your criteria will be returned.</p>
                        <p style="font-size: 16px;">For more information on how to use the Variant Finder, see our <a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/VariantFinderTutorial.pdf" target="_blank">tutorial</a>. For definitions of phenotypes, see our <a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/Phenotype_reference_guide.pdf" target="_blank">phenotype reference guide</a>.</p>

                        <div class="traits-filter-wrapper">
                            <div class="form-inline" style="margin: auto;">
                                <div class="traits-filter-ui" style="width: 600px; margin: auto;">
                                    <h1>Variant finder UI comes here.</h1>
                                </div>
                            </div>
                        </div>
                    </div>


                    <div id="GAIT" class="tab-pane fade">
                        <h3>View full genetic association results for a phenotype</h3>
                        <p style="font-size: 16px;">
                            The Genetic Association Interactive Tool allows you to compute custom association statistics by specifying the phenotype to test for association,
                            a subset of samples to analyze based on specific phenotypic criteria, and a set of covariates to control for in the analysis.
                            In order to protect patient privacy, GAIT will only allow visualization or analysis of data from more than 100 individuals.
                        </p>

                        <div class="traits-filter-wrapper">
                            <div class="form-inline" style="margin: auto;">
                                <div class="traits-filter-ui" style="width: 600px; margin: auto;">
                                    <span style="display:block; margin:0px 0 8px 0; font-size:13px;">(ex: bmi, glycemic; '=phenotype' for exact match)</span>
                                    <input id="traits-filter" placeholder="Filter phenotypes" type="text" class="form-control input-sm" style="clear: left; float:left; width: 89%; height: 35px; background-color:#fff; border:solid 1px #ddd; border-bottom-left-radius: 5px; border-top-left-radius: 5px; border-bottom-right-radius: 0px; border-top-right-radius: 0px; margin:0 0 5px 0; font-size: 16px;">
                                    <div style="float: right; font-size: 20px; padding: 5px 0 1px 0; color: #fff; background-color: #62B4C5; width: 10%; height: 35px; border:solid 1px #999; border-bottom-right-radius: 5px; border-top-right-radius: 5px; text-align: center; margin-right: 1%"><span class="glyphicon glyphicon-refresh" aria-hidden="true"></span></div>
                                </div>
                            </div>
                        </div>
                    </div>


                    <div id="locusZoom" class="tab-pane fade">

                        <h5 class="dk-under-header">This versatile tool lets you specify multiple search criteria to find genetic variants meeting those criteria. You can choose search criteria on either or both of the tabs below. Add multiple criteria until you have specified all your criteria of interest, then submit the search request. The variants that meet <b>all</b> of your criteria will be returned.</h5>
                        <h5 class="dk-under-header">For more information on how to use the Variant Finder, see our <a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/VariantFinderTutorial.pdf" target="_blank">tutorial</a>. For definitions of phenotypes, see our <a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/Phenotype_reference_guide.pdf" target="_blank">phenotype reference guide</a>.</h5>

                        <div class="traits-filter-wrapper">
                            <div class="form-inline" style="margin: auto;">
                                <div class="traits-filter-ui" style="width: 600px; margin: auto;">
                                    <span style="display:block; margin:0px 0 8px 0; font-size:13px;">(ex: bmi, glycemic; '=phenotype' for exact match)</span>
                                    <input id="traits-filter" placeholder="Filter phenotypes" type="text" class="form-control input-sm" style="clear: left; float:left; width: 89%; height: 35px; background-color:#fff; border:solid 1px #ddd; border-bottom-left-radius: 5px; border-top-left-radius: 5px; border-bottom-right-radius: 0px; border-top-right-radius: 0px; margin:0 0 5px 0; font-size: 16px;">
                                    <div style="float: right; font-size: 20px; padding: 5px 0 1px 0; color: #fff; background-color: #62B4C5; width: 10%; height: 35px; border:solid 1px #999; border-bottom-right-radius: 5px; border-top-right-radius: 5px; text-align: center; margin-right: 1%"><span class="glyphicon glyphicon-refresh" aria-hidden="true"></span></div>
                                </div>
                            </div>
                        </div>
                    </div>


                    <div id="ldScore" class="tab-pane fade">
                        <h3>View full genetic association results for a phenotype</h3>
                        <p style="font-size: 16px;">
                            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
                            Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
                            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
                            Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                        </p>

                        <div class="traits-filter-wrapper">
                            <div class="form-inline" style="margin: auto;">
                                <div class="traits-filter-ui" style="width: 600px; margin: auto;">
                                    <span style="display:block; margin:0px 0 8px 0; font-size:13px;">(ex: bmi, glycemic; '=phenotype' for exact match)</span>
                                    <input id="traits-filter" placeholder="Filter phenotypes" type="text" class="form-control input-sm" style="clear: left; float:left; width: 89%; height: 35px; background-color:#fff; border:solid 1px #ddd; border-bottom-left-radius: 5px; border-top-left-radius: 5px; border-bottom-right-radius: 0px; border-top-right-radius: 0px; margin:0 0 5px 0; font-size: 16px;">
                                    <div style="float: right; font-size: 20px; padding: 5px 0 1px 0; color: #fff; background-color: #62B4C5; width: 10%; height: 35px; border:solid 1px #999; border-bottom-right-radius: 5px; border-top-right-radius: 5px; text-align: center; margin-right: 1%"><span class="glyphicon glyphicon-refresh" aria-hidden="true"></span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>