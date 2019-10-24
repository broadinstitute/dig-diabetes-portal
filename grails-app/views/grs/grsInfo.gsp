<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="datatables"/>
    <r:require modules="geneInfo"/>
    <r:require modules="grsInfo"/>
    <r:require modules="burdenTest"/>
    <r:layoutResources/>


    <link type="application/font-woff">
    <link type="application/vnd.ms-fontobject">
    <link type="application/x-font-ttf">
    <link type="font/opentype">

 </head>

<body>

<div id="rSpinner" class="dk-loading-wheel center-block" style="display:none">
    <img src="${resource(dir: 'images', file: 'ajax-loader.gif')}" alt="Loading"/>
</div>
<script>

    $( document ).ready(function() {
        "use strict";

        var drivingVariables = {
        };

        mpgSoftware.grsInfo.setGrsInfoData(drivingVariables);
        mpgSoftware.grsInfo.buildGrsDisplay();


        var pageTitle = $(".accordion-toggle").find("h2").text();
        var textUnderTitle = $(".accordion-inner").find("h5").text();
        $(".accordion-toggle").remove();
        $(".accordion-inner").find("h5").remove();

        var PageTitleDiv = '<div class="row">\n'+
            '<div class="col-md-12">\n'+
            '<h1 class="dk-page-title">' + pageTitle + '</h1>\n'+
            '<div class="col-md-12">\n'+
            '<h5 class="dk-under-header">' + textUnderTitle + '</h5>\n'+
            '</div></div>';

        $(PageTitleDiv).insertBefore(".gene-info-container");
        $(".user-interaction").addClass("col-md-12");


        /* end of DK's script */

    });



</script>

<style>
ul.nav-tabs > li > a { background: none !important; }
ul.nav-tabs > li.active > a { background-color: #fff !important; }
#modeledPhenotypeTabs li.active > a { background-color: #9fd3df !important; }
</style>

<div id="main">

    <div class="container">

        <div class="gene-info-container row">

            <g:render template="/templates/burdenTestSharedTemplate" />
            <g:render template="/widgets/burdenTestShared" model="['variantIdentifier': '',
                                                                   'accordionHeaderClass': 'accordion-heading',
                                                                   'modifiedTitle': 'Genetic risk score module',
                                                                   'modifiedGaitSummary': message(code:'grsTesting.label.introduction.p1'),
                                                                   'allowExperimentChoice': 1,
                                                                   'allowPhenotypeChoice' : 1,
                                                                   'allowStratificationChoice': 1,
                                                                   'grsVariantSet':'anuba_T2D',
                                                                   'modifiedInitialInstruction':message(code:'grsTesting.label.initial.user.instruction')]"/>

        </div>
    </div>

</div>

</body>
</html>

