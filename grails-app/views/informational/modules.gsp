<%@ page import="org.broadinstitute.mpg.diabetes.util.PortalConstants" %>

<!DOCTYPE html>
<html>
<head>

    <r:require modules="manhattan"/>
    <r:require modules="mode3"/>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="traitsFilter"/>
    <r:layoutResources/>

    <script>

    mpgSoftware.homePage.setHomePageVariables(
        {
            "defaultPhenotype":"${g.defaultPhenotype()}",
            "generalizedVariantInput":"#generalized-input",
            "generalizedVariantGo":"#generalized-go",
            "generalizedGeneInput":"#generalized-gene-input",
            "generalizedGeneGo":"#generalized-gene-go",
            "traitSearchLaunch":"#traitSearchLaunch",
            "traitInput":"#trait-input",
            "geneTraitSearchLaunch":"#geneTraitSearchLaunch",
            "geneTraitInput":"#gene-trait-input",
            "geneIndexUrl":"${createLink(controller:'gene', action:'index')}",
            "traitSearchUrl":"${createLink(controller:'trait',action:'traitSearch')}",
            "genePrioritizationUrl":"${createLink(controller:'trait',action:'genePrioritization')}",
            "findTheRightDataPageUrl": "${createLink(controller:'gene',action:'findTheRightDataPage')}",
            "findTheRightGenePageUrl": "${createLink(controller:'variantSearch',action:'findTheRightGenePage')}",
            "retrieveGwasSpecificPhenotypesAjaxUrl":"${createLink(controller:'VariantSearch', action:'retrieveGwasSpecificPhenotypesAjax')}",
            "getGeneLevelResultsUrl":"${createLink(controller:'home', action:'getGeneLevelResults')}",
            "findEveryVariantForAGeneUrl": "${createLink(controller:'variantSearch', action:'findEveryVariantForAGene')}"
        }
    );

        var drivingVariables = {
            phenotypeName: '${g.defaultPhenotype()}',
            traitSearchUrl: "${createLink(controller: 'trait', action: 'traitSearch')}",
            ajaxClumpDataUrl: '${createLink(controller: "trait", action: "ajaxClumpData")}',
            retrievePhenotypesAjaxUrl: '<g:createLink controller="variantSearch" action="retrievePhenotypesAjax" />',
            ajaxSampleGroupsPerTraitUrl: '${createLink(controller: "trait", action: "ajaxSampleGroupsPerTrait")}',
            phenotypeAjaxUrl: '${createLink(controller: "trait", action: "phenotypeAjax")}',
            variantInfoUrl: '${createLink(controller: "variantInfo", action: "variantInfo")}',
            requestedSignificance: '<%=requestedSignificance%>',
            local: "${locale}",
            copyMsg: '<g:message code="table.buttons.copyText" default="Copy" />',
            printMsg: '<g:message code="table.buttons.printText" default="Print me!" />'
        }

        mpgSoftware.moduleLaunch.setMySavedVariables(drivingVariables);

        $(function () {
            "use strict";

            function goToSelectedItem(item) {
                var loading = $('#spinner').show();
                window.location.href = "${createLink(controller:'gait', action:'gaitInfo')}" +"/" + item;
            }

            /***
             * type ahead recognizing genes
             */
            $('#generalized-input').typeahead({
                source: function (query, process) {
                    $.get('<g:createLink controller="gene" action="index"/>', {query: query}, function (data) {
                        process(data);
                    })
                },
                afterSelect: function(selection) {
                    goToSelectedItem(selection);
                }
            });

            /***
             * respond to end-of-search-line button
             */
            $('#generalized-go').on('click', function () {
                var somethingSymbol = $('#generalized-input').val();
                somethingSymbol = somethingSymbol.replace(/\//g,"_"); // forward slash crashes app (even though it is the LZ standard variant format
                if (somethingSymbol) {
                    goToSelectedItem(somethingSymbol)
                }
            });

            /***
             * capture enter key, make it equivalent to clicking on end-of-search-line button
             */
            $("input").keypress(function (e) { // capture enter keypress
                var k = e.keyCode || e.which;
                if (k == 13) {
                    $('#generalized-go').click();
                }
            });
        });


        $( document ).ready(function() {


            var userLogIn = ($("#usernameDisplay").length)? true : false;


            if (userLogIn) {
                    mpgSoftware.moduleLaunch.fillPhenotypesDropdown(drivingVariables.phenotypeName,'phenotypeDropdownWrapper','phenotypeDropdown');

            } else {

                var loginModal = '<div class="modal fade" id="mode3Modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">\n' +
                    '  <div class="modal-dialog" role="document">\n' +
                    '    <div class="modal-content">\n' +
                    '      <div class="modal-body">\n' +
                    '        <h3>Please log in to view the analysis modules.</h3>\n' +
                    '      </div>\n' +
                    '      <div class="modal-footer">\n' +
                    '<oauth:connect provider="google" id="google-connect-link"><button type="button" class="btn btn-primary">Login with Google</button></oauth:connect>\n' +
                    '<a href=${createLink(controller:"home",action:"portalHome")}><button type="button" class="btn btn-info">Go back to home page</button></a>\n' +
                    '      </div>\n' +
                    '    </div>\n' +
                    '  </div>\n' +
                    '</div>';
                $("body").append(loginModal);

                $('#mode3Modal').modal();
            }
        });


    </script>

    <style>
    .modules-table td { vertical-align: middle !important; }
    .inactive { background-color: rgba(0,0,0,.15) !important;}
    </style>
</head>

<h1 class="dk-page-title" xmlns="http://www.w3.org/1999/html"><%=phenotypeName%></h1>
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
        <div class="row">
            <div class="col-md-12">

                <table class="table modules-table">
                    <thead>
                    <tr>
                        <th style="width:20%;">Module</th><th style="width:60%;">Description</th><th style="width:20%;">Launch</th>
                    </tr>
                    </thead>
                    <tbody>

                    <g:if test="${g.portalTypeString()?.equals('t2d')}">
                        <tr>
                            <td><h4><g:message code="informational.modules.GAIT.title"></g:message></h4></td>
                            <td><img  src="${resource(dir: 'images', file: 'gait.png')}" align="left" style="width: 200px; border: solid 1px #ddd; margin-right: 15px;"><g:message code="informational.modules.GAIT.description"></g:message>
                                <div style="float: left; margin-top: 5px; margin-left: 215px;" class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact "><a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/KP_GAIT_guide.pdf" target="_blank">Custom association analysis guide</a></div>
                                <div class="errorReporter">${errorText}</div>
                            </td>
                            %{--<td><div class="btn dk-t2d-blue dk-tutorial-button dk-right-column-buttons-compact"><a href="${createLink(controller:'gait', action:'gaitInfo')}">Launch Gait</a></div></td>--}%
                            <td style="position: relative;">
                            <label>Enter a gene name or variant rsID to start.<br>
                                Select a name or ID from the list of suggestions to launch Custom Association Analysis.</label>

                            <div class="form-inline">
                                <input id="generalized-input" value="" type="text" class="form-control input-default" style="width: 100%;">
                            </div>
                            </td>
                        </tr>
                    </g:if>


                    <tr>
                        <td><h4><g:message code="informational.modules.LDClumping.title"></g:message></h4></td>
                        <td>
                            <img  src="${resource(dir: 'images', file: 'LD_clumping.jpg')}" align="left" style="width: 200px; border: solid 1px #ddd; margin-right: 15px;">
                            <p><g:message code="informational.modules.LDClumping.description1"></g:message></p>
                            <p><g:message code="informational.modules.LDClumping.description2"></g:message></td></p>

                        </td>
                        <td>
                            <label>Select phenotype</label>
                            <div id="phenotypeDropdownWrapper">

                            </div>

                            <div class="btn dk-t2d-blue dk-tutorial-button dk-right-column-buttons-compact" style="margin-top: 10px;" ><a id="launchLDClumping" href="javascript:;" onclick="mpgSoftware.moduleLaunch.launchLDClumping()">Launch Interactive Manhattan plot</a></div>

                        </td>
                    </tr>

                    <tr>
                        <td><h4><g:message code="informational.modules.VariantFinder.title"></g:message></h4></td>
                        <td><img  src="${resource(dir: 'images', file: 'variant_finder.png')}" align="left" style="width: 200px; border: solid 1px #ddd; margin-right: 15px;">
                            <g:message code="informational.modules.VariantFinder.description"></g:message>
                            <div class="dk-t2d-green dk-tutorial-button dk-right-column-buttons-compact" style="float: left; margin-right: 15px;"><a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/VariantFinderTutorial.pdf" target="_blank">Variant Finder tutorial</a></div>
                            </td>
                        <td><div class="btn dk-t2d-blue dk-tutorial-button dk-right-column-buttons-compact"><a href="${createLink(controller:'variantSearch', action:'variantSearchWF')}">Launch Variant Finder</a></div></td>
                    </tr>
                    <g:if test="${g.portalTypeString()?.equals('t2d')}">
                        <tr>
                            <td class=""><h4><g:message code="informational.modules.GRS.title"></g:message></h4></td>
                            <td><img  src="${resource(dir: 'images', file: 'GRS.png')}" align="left" style="width: 200px; border: solid 1px #ddd; margin-right: 15px;"><g:message code="informational.modules.GRS.description"></g:message></td>
                            <td><div class="btn dk-t2d-blue dk-tutorial-button dk-right-column-buttons-compact"><a href="${createLink(controller:'grs', action:'grsInfo')}">Launch GRS</a></div></td>
                        </tr>
                    </g:if>




                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>