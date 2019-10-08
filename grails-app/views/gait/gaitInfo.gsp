<%--
  Created by IntelliJ IDEA.
  User: psingh
  Date: 5/21/19
  Time: 1:44 AM
--%>

<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="datatables"/>
    <r:require modules="gaitInfo"/>
    <r:require modules="geneInfo"/>
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
            geneName: "${geneName}",
            variantIdentifier: "${variantIdentifier}",
            allowExperimentChoice:"${allowExperimentChoice}",
            allowPhenotypeChoice:"${allowPhenotypeChoice}",
            allowStratificationChoice:"${allowStratificationChoice}"

        };

        mpgSoftware.gaitInfo.setGaitInfoData(drivingVariables);
        mpgSoftware.gaitInfo.buildGaitDisplay();


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

            <h3><em style="font-weight: 900;"><%=geneName%></em></h3>


            <h3><em style="font-weight: 900;"><%=variantIdentifier%></em></h3>


            <g:render template="/templates/burdenTestSharedTemplate" model="['variantIdentifier': variantIdentifier, 'accordionHeaderClass': 'accordion-heading']" />



            %{--If its gene Gait page then allowExperimentChoice = 0 and 'geneName':'geneName'--}%
            <g:render template="/widgets/burdenTestShared" model="['variantIdentifier': '',
                                                                   'accordionHeaderClass': 'accordion-heading',
                                                                   'modifiedTitle': 'Custom Association Analysis',
                                                                   'modifiedGaitSummary': 'This interface allows you to perform single-variant association analysis or a gene-level burden test using custom parameters. Results for the T2D phenotype are powered by the AMP T2D-GENES exome sequence analysis dataset; results for other traits are powered by the 19k exome sequence analysis subset. In order to protect patient privacy, visualization or analysis of data from fewer than 100 individuals is not supported.',
                                                                   'allowExperimentChoice': allowExperimentChoice,
                                                                   'allowPhenotypeChoice': allowPhenotypeChoice,
                                                                   'allowStratificationChoice': allowStratificationChoice,
                                                                   'grsVariantSet':'',
                                                                   'geneName':geneName,
                                                                    'standAloneTool':true]"/>







        </div>
    </div>

</div>

</body>
</html>

