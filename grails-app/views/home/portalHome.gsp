<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <meta name="wot-verification" content="9fd2c3983c1837397ff8"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>
<style>
.unpaddedSection {
    padding-left: 0;
    padding-right: 0;
}
</style>

<body>

<script>

    $(function () {
        "use strict";

        /***
         * type ahead recognizing genes
         */
        $('#generalized-input').typeahead({
            source: function (query, process) {
                $.get('<g:createLink controller="gene" action="index"/>', {query: query}, function (data) {
                    process(data);
                })
            }
        });

        /***
         * respond to end-of-search-line button
         */
        $('#generalized-go').on('click', function () {
            var somethingSymbol = $('#generalized-input').val();
            if (somethingSymbol) {
                window.location.href = "${createLink(controller:'gene',action:'findTheRightDataPage')}/" + somethingSymbol;
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

        /***
         *  Launch find variants associated with other traits
         */
        $('#traitSearchLaunch').on('click', function () {
            var trait_val = $('#trait-input option:selected').val();
            var significance = 5e-4;
            if (trait_val == "" || significance == 0) {
                alert('Please choose a trait and enter a valid significance!')
            } else {
                window.location.href = "${createLink(controller:'trait',action:'traitSearch')}" + "?trait=" + trait_val + "&significance=" + significance;
            }
        });

        var retrievePhenotypes = function () {
            var loading = $('#spinner').show();
            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller:'VariantSearch', action:'retrieveGwasSpecificPhenotypesAjax')}",
                data: {},
                async: true,
                success: function (data) {
                    if (( data !==  null ) &&
                            ( typeof data !== 'undefined') &&
                            ( typeof data.datasets !== 'undefined' ) &&
                            (  data.datasets !==  null ) ) {
                        UTILS.fillPhenotypeCompoundDropdown(data.datasets,'#trait-input');
                        $("select#trait-input").val("${g.defaultPhenotype()}");
                    }
                    loading.hide();
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });
        };
        retrievePhenotypes();





    });

</script>

%{--Main search page for application--}%
<div class="container dk-2td-content">
    <div class="row">
        <div class="col-md-8">
            <div>
                <h2 class="dk-search-title-homepage"><g:message code="primary.text.input.header"/></h2>

                <div class="form-inline" style="padding-top: 10px;">
                    <input type="text" class="form-control input-sm" style="width: 70%;">
                    <button class="btn btn-primary btn-sm" type="button" style="width:15%; float:right; margin-right: 5%;"><g:message code="mainpage.button.imperative"/> ></button>
                </div>
                <div>
                    <strong><g:message code="site.shared.phrases.examples" />:</strong> <g:if test="${g.portalTypeString()?.equals('stroke')}">
                    <a href='<g:createLink controller="gene" action="geneInfo"
                                           params="[id: 'HDAC9']"/>'>HDAC9</a>
                </g:if>
                    <g:else>
                        <a href='<g:createLink controller="gene" action="geneInfo"
                                               params="[id: 'SLC30A8']"/>'>SLC30A8</a>
                    </g:else>
                    <g:helpText title="input.searchTerm.geneExample.help.header" placement="bottom"
                                body="input.searchTerm.geneExample.help.text"/>,
                    <g:if test="${g.portalTypeString()?.equals('stroke')}">
                        <a href='<g:createLink controller="variantInfo" action="variantInfo"
                                               params="[id: 'rs11179580']"/>'>rs11179580</a>
                    </g:if>
                    <g:else>
                        <a href='<g:createLink controller="variantInfo" action="variantInfo"
                                               params="[id: 'rs13266634']"/>'>rs13266634</a>
                    </g:else>
                    <g:helpText title="input.searchTerm.variantExample.help.header" placement="right"
                                body="input.searchTerm.variantExample.help.text" qplacer="0 0 0 2px"/>,
                    <g:if test="${g.portalTypeString()?.equals('stroke')}">
                        <a href='<g:createLink controller="region" action="regionInfo"
                                               params="[id: 'chr7:18,100,000-18,300,000']"/>'>chr7:18,100,000-18,300,000</a>
                    </g:if>
                    <g:else>
                        <a href='<g:createLink controller="region" action="regionInfo"
                                               params="[id: 'chr9:21,940,000-22,190,000']"/>'>chr9:21,940,000-22,190,000</a>
                    </g:else>
                </div>
            </div>
            <hr />
            <div>
                <h2 class="dk-search-title-homepage"><g:message code="variant.search.header"/></h2>
                <p class="dk-footnote"><g:message code="variant.search.specifics"/></p>
                <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">
                    <button class="btn btn-primary btn-sm" type="button" style="width:15%; float:right; margin-right: 5%; margin-top: -40px;"><g:message code="mainpage.button.imperative"/> ></button>
                </a>
            </div>
            <hr />
            <div>
                <h2 class="dk-search-title-homepage">View full GWAS results for a phenotype</h2>
                <div class="form-inline" style="padding-top: 10px;">
                    <select name="" id="trait-input" class="form-control input-sm" style="width: 70%;">
                    </select>
                    <button class="btn btn-primary btn-sm" type="button" style="width:15%; float:right; margin-right: 5%;"><g:message code="mainpage.button.imperative"/> ></button>
                </div>
            </div>
            <hr />
            <img src="${resource(dir: 'images/icons', file: 'data_icon.png')}" style="width: 110px; margin-right: 10px;" align="left" >
            <h2><g:message code="aboutTheData.title" default="About the data" /></h2>
            <p>The T2D Knowledge Portal enables browsing, searching, and analysis of human genetic information linked to type 2 diabetes and related traits, while protecting the integrity and confidentiality of the underlying data.
            </p>

            <h2>Citation</h2>
            <p>Please use the following citation when referring to data from this portal: <br />
                AMP T2D-GENES Program, SIGMA; Year Month Date of Access; URL of page you are citing.
            </p>

        </div>

        <div class="col-md-4">
            <h3>What's new</h3>
            <ul class="dk-news-items gallery-fade">
                <li>News item 1, Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ...<a href="javascript:;">Read more</a></li>
                <li>News item 2, Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ...<a href="javascript:;">Read more</a></li>
                <li>News item 3, Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ...<a href="javascript:;">Read more</a></li>
                <li>News item 4, Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ...<a href="javascript:;">Read more</a></li>
            </ul>
            <a class="btn btn-default" style="width:80%; margin-top: -50px; margin-right: 2%; margin-bottom: 0px;" href="javascript:;">Get email updates</a>
            <a class="btn btn-default" style="width:15%; margin-top: -50px; margin-bottom: 0px; background-color:#55bcdf; border:solid 1px #1da1f2;" href="https://twitter.com/T2DKP"><img src="${resource(dir:'images/icons', file:'twitter.png')}" /></a>
            <h3 style="margin-top: 0px;"><g:message code="about.the.portal.header"/></h3>
            <g:if test="${g.portalTypeString()?.equals('stroke')}">
                <g:message code="about.the.stroke.portal.text"/>
            </g:if>
            <g:else>
                <g:message code="about.the.portal.text"/>
            </g:else>

            <g:if test="${g.portalTypeString()?.equals('stroke')}">
                <g:message code='portal.stroke.home.funders'/>:
            </g:if>
            <g:else>
                <g:message code='portal.home.funders'/>:
            </g:else>
            <table>
                <tr>
                    <td>
                        <a href="http://www.niddk.nih.gov/Pages/default.aspx"><img src="${resource(dir:'images/organizations', file:'NIH.jpg')}" style="width: 110px;"></a>
                    </td>
                    <td>
                        <a href="http://www.fnih.org"><img src="${resource(dir:'images/organizations', file:'FNIH.jpg')}" style="width: 110px;"></a>
                    </td>
                    <td>
                        <a href="http://www.janssen.com"><img src="${resource(dir:'images/organizations', file:'janssen.jpg')}" style="width: 110px;"></a>
                    </td>
                </tr>
                <tr>
                    <td>
                        <a href="https://www.lilly.com/home.aspx"><img src="${resource(dir:'images/organizations', file:'lilly.jpg')}" style="width: 110px;"></a>
                    </td>
                    <td>
                        <a href="http://www.merck.com/index.html"><img src="${resource(dir:'images/organizations', file:'merck.jpg')}" style="width: 110px;"></a>
                    </td>
                    <td>
                        <a href="http://www.pfizer.com"><img src="${resource(dir:'images/organizations', file:'pfizer.jpg')}" style="width: 110px;"></a>
                    </td>
                </tr>
                <tr>
                    <td>
                        <a href="http://en.sanofi.com"><img src="${resource(dir:'images/organizations', file:'sanofi.jpg')}" style="width: 110px;"></a>
                    </td>
                    <td>
                        <a href="http://jdrf.org"><img src="${resource(dir:'images/organizations', file:'jdrf.jpg')}" style="width: 110px;"></a>
                    </td>
                    <td>
                        <a href="http://www.diabetes.org"><img src="${resource(dir:'images/organizations', file:'ADA.jpg')}" style="width: 110px;"></a>
                    </td>
                </tr>
            </table>
            <g:message code='portal.home.addtl_funders'/>:
            <p><a href="http://www.fundacioncarlosslim.org/en/"><img src="${resource(dir:'images/organizations', file:'slim.png')}" style="margin-left: 80px;"></a></p>
        </div>
    </div>
</div>

</body>
</html>
