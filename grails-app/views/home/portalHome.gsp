<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <meta name="wot-verification" content="9fd2c3983c1837397ff8"/>
    <r:require modules="core"/>
    <r:require modules="scroller"/>
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
<div id="main" style="padding-bottom: 0">
    <div class="container">
        <div class="row">
            <div class="col-md-7" style="margin-top: -10px">

                %{--gene, variant or region--}%
                <div class="row">
                    <div class="col-xs-11 col-md-11 col-lg-11 unpaddedSection" style="padding-right: 2px">

                        <h3>
                            <g:message code="primary.text.input.header"/>
                            <g:message code="metadata.ph" default="nothing to see here"/>
                        </h3>

                        <div class="input-group input-group-lg">
                            <input type="text" class="form-control" id="generalized-input"></span>
                            <span class="input-group-btn">
                                %{--<span class="glyphicon glyphicon-zoom-in" aria-hidden="true"></span>--}%
                                <button id="generalized-go" class="btn btn-primary btn-lg" type="button">
                                    <g:message code="mainpage.button.imperative"/>
                                </button>
                            </span>
                        </div>

                        <g:renderT2dGenesSection>
                            <div class="helptext"><g:message code="site.shared.phrases.examples" />:
                        <g:if test="${session?.getAttribute('portalType')?.equals('stroke')}">
                                <a href='<g:createLink controller="gene" action="geneInfo"
                                                       params="[id: 'HDAC9']"/>'>HDAC9</a>
                        </g:if>
                        <g:else>
                            <a href='<g:createLink controller="gene" action="geneInfo"
                                                   params="[id: 'SLC30A8']"/>'>SLC30A8</a>
                        </g:else>
                                <g:helpText title="input.searchTerm.geneExample.help.header" placement="bottom"
                                            body="input.searchTerm.geneExample.help.text"/>,
                                <g:if test="${session?.getAttribute('portalType')?.equals('stroke')}">
                                    <a href='<g:createLink controller="variantInfo" action="variantInfo"
                                                           params="[id: 'rs17346073']"/>'>rs17346073</a>
                                </g:if>
                                <g:else>
                                    <a href='<g:createLink controller="variantInfo" action="variantInfo"
                                                           params="[id: 'rs13266634']"/>'>rs13266634</a>
                                </g:else>
                                <g:helpText title="input.searchTerm.variantExample.help.header" placement="right"
                                            body="input.searchTerm.variantExample.help.text" qplacer="0 0 0 2px"/>,
                                <g:if test="${session?.getAttribute('portalType')?.equals('stroke')}">
                                    <a href='<g:createLink controller="region" action="regionInfo"
                                                           params="[id: 'chr7:18,100,000-18,300,000']"/>'>chr7:18,100,000-18,300,000</a>
                                </g:if>
                                <g:else>
                                    <a href='<g:createLink controller="region" action="regionInfo"
                                                           params="[id: 'chr9:21,940,000-22,190,000']"/>'>chr9:21,940,000-22,190,000</a>
                                </g:else>
                                <g:helpText title="input.searchTerm.rangeExample.help.header"  placement="bottom"
                                            body="input.searchTerm.rangeExample.help.text" qplacer="0 0 0 2px"/>
                            </div>
                        </g:renderT2dGenesSection>

                    </div>

                    <div class="col-xs-1 col-md-1 col-lg-1"></div>
                </div>

                %{--set up search form--}%


                <div class="row sectionBuffer">
                    <div class="col-xs-10 col-md-10 col-lg-10 unpaddedSection" style="padding-top: 10px">
                        <h3>
                            <g:message code="variant.search.header"/>
                        </h3>
                    </div>

                    <div class="col-xs-1 col-md-1 col-lg-1 unpaddedSection" style="margin-top: 20px; padding: 0">
                        <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}"
                           class="btn btn-primary btn-lg"><g:message code="mainpage.button.imperative"/></a>
                    </div>

                    <div class="col-xs-1  col-md-1 col-lg-1">

                    </div>

                </div>

                <div class="row">
                    <div class="col-md-12">
                        <div class="helptext">
                            <g:message code="variant.search.specifics"/>
                        </div>
                    </div>
                </div>

                %{--variants with other traits--}%
                <div class="row sectionBuffer">

                    <div class="col-xs-10 col-md-10 col-lg-10 unpaddedSection">

                        <h3>
                            <g:message code="trait.search.header"/><br/>
                        </h3>

                        <select name="" id="trait-input" class="form-control btn-group btn-input clearfix">

                        </select>

                    </div>

                    <div class="col-xs-1 col-md-1  col-lg-1 unpaddedSection" style="margin-top: 40px; padding: 0">
                        <div id="traitSearchLaunch" class="btn btn-primary btn-lg"><g:message
                                code="mainpage.button.imperative"/></div>
                    </div>

                    <div class="col-xs-1 col-md-1 col-lg-1">

                    </div>

                </div>

            </div>

            <div class="col-md-5">
                <div class="row">
                    <div class="col-md-offset-1 col-md-10 medTextDark">
                        <g:message code="about.the.portal.header"/>
                        %{--<span style="padding-left:25px" class="glyphicon glyphicon-question-sign" aria-hidden="true" data-toggle="popover"--}%
                              %{--title="<g:message code='about.the.portal.header'/>"--}%
                              %{--data-content="<g:message code='about.the.portal.text'/>"--}%
                        %{--></span>--}%
                    </div>

                    <div class="col-md-1"></div>

                </div>

                <div class="row">
                    <div class="col-md-offset-1 col-md-10 smallText">



<g:if test="${session?.getAttribute('portalType')?.equals('stroke')}">
    <g:message code="about.the.stroke.portal.text"/>
</g:if>
<g:else>
    <g:message code="about.the.portal.text"/>
</g:else>
                    </div>

                    <div class="col-md-1"></div>
                </div>

            </div>
        </div>

    </div>
</div>

<div class="row column-center" style="display: flex; align-content: center; align-items: center;margin-top:25px;">
    <div style="width:40vw;padding-left:0;padding-right:0;border-left:0;border-right:0;margin-left:0;margin-right:0;">
        <div class="wide-separator"></div>
    </div>
    <div class="text-center funders-color" style="margin-left:5px;margin-right: 5px;">
        <g:if test="${session?.getAttribute('portalType')?.equals('stroke')}">
            <g:message code='portal.stroke.home.funders'/>:
        </g:if>
        <g:else>
            <g:message code='portal.home.funders'/>:
        </g:else>
    </div>
    <div style="width:40vw;padding-left:0;padding-right:0;border-left:0;border-right:0;margin-left:0;margin-right:0;">
        <div class="wide-separator"></div>
    </div>
</div>

<div>
    <div class="row column-center" style="display: flex; align-content: center; align-items: center;">
        <div style="width:10%"></div>
        <g:if test="${session?.getAttribute('portalType')?.equals('stroke')}">
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/stroke', file: 'novo_nordisk_logo.png')}">
            </div>
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/stroke', file: 'bugher_logo2.gif')}">
            </div>
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/stroke', file: 'wellcome_logo.png')}">
            </div>
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/stroke', file: 'AAN-logo.png')}">
            </div>
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/stroke', file: 'aha_logo2.png')}">
            </div>
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/stroke', file: 'rappaport_logo.png')}">
            </div>
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/stroke', file: 'nsf.png')}">
            </div>
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/stroke', file: 'nih-logo.png')}">
            </div>
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/stroke', file: 'mgh-stroke-site-logo.gif')}">
            </div>
        </g:if>
        <g:else>
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/icons', file: 'NIH_NIDDK.png')}">
            </div>
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/icons', file: 'FNIH.png')}">
            </div>
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/icons', file: 'Janssen-logo.png')}">
            </div>
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/icons', file: 'Lilly-logo.png')}">
            </div>
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/icons', file: 'merck_3282.png')}">
            </div>
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/icons', file: 'pfizer_rgb_pos.png')}">
            </div>
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/icons', file: 'sanofi-logo.png')}">
            </div>
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/icons', file: 'JDRF-logo.png')}">
            </div>
            <div class="col-xs-1">
                <img class="img-responsive" src="${resource(dir: 'images/icons', file: 'american-diabetes-association.png')}">
            </div>
        </g:else>
        <div style="width:10%"></div>
    </div>
</div>



<g:if test="${!session?.getAttribute('portalType')?.equals('stroke')}">
<div class="row column-center" style="display: flex; align-content: center; align-items: center;">
    <div style="width:45vw;padding-left:0;padding-right:0;border-left:0;border-right:0;margin-left:0;margin-right:0;">
        <div class="wide-separator"></div>
    </div>
    <div class="text-center funders-color" style="margin-left:5px;margin-right: 5px;">
        <g:message code='portal.home.addtl_funders'/>:
    </div>
    <div style="width:45vw;padding-left:0;padding-right:0;border-left:0;border-right:0;margin-left:0;margin-right:0;">
        <div class="wide-separator"></div>
    </div>
</div>

<div class="row column-center" style="display: flex; align-content: center; align-items: center;margin-top:10px;margin-bottom: 30px;">
    <div class="col-xs-2">
        <img class="img-responsive" src="${resource(dir: 'images/icons', file: 'logotipo_Fundacion_CarlosSlim.png')}">
    </div>
</div>
</g:if>>

</body>
</html>
