<%@ page import="org.broadinstitute.mpg.diabetes.util.PortalConstants" %>

<!DOCTYPE html>
<html>
<head>
    <script>
        var drivingVariables = {
            phenotypeName: '<%=phenotypeKey%>',
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

        $( document ).ready(function() {

            var userLogIn = ($(".login-btn").text().trim().toLowerCase() != "google log in")? true : false;

            if (userLogIn) {
                mpgSoftware.moduleLaunch.fillPhenotypesDropdown('T2D');
            } else {

                var loginModal = '<div class="modal fade" id="mode3Modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">\n' +
                    '  <div class="modal-dialog" role="document">\n' +
                    '    <div class="modal-content">\n' +
                    '      <div class="modal-body">\n' +
                    '        <h3>Login required!</h3>To use the analysis modules login is required. You can still learn about the modules. To continue to view the page, please close this modal.\n' +
                    '      </div>\n' +
                    '      <div class="modal-footer">\n' +
                    '<a href=${createLink(controller:"home",action:"portalHome")}><button type="button" class="btn btn-info">Go back to home page</button></a>\n' +
                    '<oauth:connect provider="google" id="google-connect-link"><button type="button" class="btn btn-primary">Login with Google</button></oauth:connect>\n' +
                    '<button type="button" class="btn btn-secondary" data-dismiss="modal" aria-label="Close">Close modal</button>\n' +
                    '      </div>\n' +
                    '    </div>\n' +
                    '  </div>\n' +
                    '</div>';
                $("body").append(loginModal);

                $('#mode3Modal').modal();
            }
        });
    </script>

    <r:require modules="manhattan"/>
    <r:require modules="mode3"/>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="traitsFilter"/>
    <r:layoutResources/>

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
                    <tr>
                        <td><h4><g:message code="informational.modules.LDClumping.title"></g:message></h4></td>
                        <td>
                            <img  src="${resource(dir: 'images', file: 'LD_clumping.jpg')}" align="left" style="width: 200px; border: solid 1px #ddd; margin-right: 15px;">
                            <p><g:message code="informational.modules.LDClumping.description1"></g:message></p>
                            <p><g:message code="informational.modules.LDClumping.description2"></g:message></td></p>

                    </td>
                        <td>

                            <label>Select phenotype</label>
                            <select class="phenotypeDropdown form-control selectpicker" data-live-search="true" id="phenotypeDropdown" name="phenotypeDropdown">
                            </select>
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
                            <td class=""><span class='new-dataset-flag' style="margin-top:-10px; margin-left: 10px;">&nbsp;</span><h4><g:message code="informational.modules.GRS.title"></g:message></h4></td>
                            <td><img  src="${resource(dir: 'images', file: 'GRS.png')}" align="left" style="width: 200px; border: solid 1px #ddd; margin-right: 15px;"><g:message code="informational.modules.GRS.description"></g:message></td>
                            <td><div class="btn dk-t2d-blue dk-tutorial-button dk-right-column-buttons-compact"><a href="${createLink(controller:'grs', action:'grsInfo')}">Launch GRS</a></div></td>
                        </tr>
                    </g:if>

                    </tbody>
                </table>
            </div>
        </div>
    </div>

</body>
</html>