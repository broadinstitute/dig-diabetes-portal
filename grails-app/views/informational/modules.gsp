<%@ page import="org.broadinstitute.mpg.diabetes.util.PortalConstants" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="traitsFilter"/>
    <r:layoutResources/>

    <style>
    .modules-table td { vertical-align: middle !important; }

    .inactive { background-color: rgba(0,0,0,.15) !important;}
    </style>
</head>


<body>
<div id="main">
    <div class="container dk-static-content">
        <div class="row">
            <div class="col-md-12">
                <h1 class="dk-page-title"><g:message code="informational.modules.title"></g:message></h1>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <h5 class="dk-under-header"><g:message code="informational.modules.bellowtitle"></g:message></h5>
            </div>
        </div>
        <!--
        <div class="row" style="padding-bottom: 30px;">
            <div class="col-md-12">
                <h3>Select a trait and a dataset to view available analysis. </h3>
                    <div class="col-md-4">
                        <select id="phenotype" class="form-control selectpicker" data-live-search="true" style="width: 200px;">
                            <option>Traits</option>
                            <option>Type 2 diabetes</option>
                            <option>BMI</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <select id="dataset" class="form-control  selectpicker" style="width: 200px;">
                            <option>Datasets</option>
                            <option>dataset 1</option>
                            <option>dataset 2</option>
                        </select>
                    </div>

            </div>
        </div>-->

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
                            <td><h4><g:message code="informational.modules.LDClumping.title"></g:message></h4></td>
                            <td>
                                <img  src="${resource(dir: 'images', file: 'LD_clumping.jpg')}" align="left" style="width: 200px; border: solid 1px #ddd; margin-right: 15px;">
                                <p><g:message code="informational.modules.LDClumping.description1"></g:message></p>
                            <p><g:message code="informational.modules.LDClumping.description2"></g:message></td></p>

                            </td>
                            <td><div class="btn dk-t2d-blue dk-tutorial-button dk-right-column-buttons-compact"><a href="${createLink(controller:'trait', action:'traitSearch')}?trait=<%=phenotypeName%>&significance=0.0005">Launch LD Clumping</a></div></td>
                        </tr>
                        <tr>
                            <td><h4><g:message code="informational.modules.VariantFinder.title"></g:message></h4></td>
                            <td><img  src="${resource(dir: 'images', file: 'variant_finder.png')}" align="left" style="width: 200px; border: solid 1px #ddd; margin-right: 15px;">
                                <g:message code="informational.modules.VariantFinder.description"></g:message>
                                <div class="dk-t2d-green dk-tutorial-button dk-right-column-buttons-compact" style="float: left; margin-right: 15px;"><a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/VariantFinderTutorial.pdf" target="_blank">Variant Finder tutorial</a></div>
                                <div class="dk-t2d-green dk-reference-button dk-right-column-buttons-compact" style="float: left;"><a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/Phenotype_reference_guide.pdf" target="_blank">Phenotype Reference Guide</a></div></td>
                            <td><div class="btn dk-t2d-blue dk-tutorial-button dk-right-column-buttons-compact"><a href="${createLink(controller:'variantSearch', action:'variantSearchWF')}">Launch Variant Finder</a></div></td>
                        </tr>
                        <!--<tr>
                            <td><h4><g:message code="informational.modules.GAIT.title"></g:message></h4></td>
                            <td><g:message code="informational.modules.GAIT.description"></g:message></td>
                            <td><div class="btn dk-t2d-blue dk-tutorial-button dk-right-column-buttons-compact"><a href="javascript:;">Launch GAIT</a></div></td>
                        </tr>-->
                        <tr>
                            <td class=""><h4><g:message code="informational.modules.GRS.title"></g:message></h4></td>
                            <td><img  src="${resource(dir: 'images', file: 'GRS.png')}" align="left" style="width: 200px; border: solid 1px #ddd; margin-right: 15px;"><g:message code="informational.modules.GRS.description"></g:message></td>
                            <td><div class="btn dk-t2d-blue dk-tutorial-button dk-right-column-buttons-compact"><a href="${createLink(controller:'grs', action:'grsInfo')}">Launch GRS</a></div></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
</div>

</body>
</html>