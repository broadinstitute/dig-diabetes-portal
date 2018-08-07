<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <meta name="wot-verification" content="9fd2c3983c1837397ff8"/>
    <r:require modules="core"/>
    <r:require modules="portalHome"/>
    <r:require modules="traitsFilter"/>
    <r:require module="mustache"/>
    <r:layoutResources/>


</head>

<body>
<div id="home_spinner" class="dk-loading-wheel center-block" style="color:#fff;">
    <img src="${resource(dir: 'images', file: 'ajax-loader.gif')}" alt="Loading"/>
</div>
<script>
    $(function () {
        "use strict";
        <g:applyCodec encodeAs="none">
        var newsItems = ${newsItems};
        </g:applyCodec>
        //alert(warningMessage);
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

        mpgSoftware.traitsFilter.setHomePageVariables(
            {
                "traitSearchUrl":"${createLink(controller:'trait',action:'traitSearch')}"
            }
        );

        $(document).ready(function(){
            mpgSoftware.homePage.loadNewsFeed(newsItems.posts);
            mpgSoftware.homePage.setSlideWindows();
            mpgSoftware.homePage.retrievePhenotypes();
            mpgSoftware.homePage.retrieveGenePhenotypes();
            mpgSoftware.homePage.initializeInputFields ();
        });
    });
</script>
<div class="fluid" style="font-size:16px; background-image:url(${resource(file: g.message(code: portalVersionBean.backgroundGraphic, default:portalVersionBean.backgroundGraphic))});background-position: left top; padding-bottom: 70px; padding-top:0px;">

    <div class="container" style="color:#fff;">
        <div class="row" style="padding-top:40px;">
            <div class="col-md-6 portal-front-banner static-content" portal="${g.portalTypeString()}" file="portal_front_banner.html" style="color:#fff; font-weight:300;"></div>

            <g:if test="${!portalVersionBean.regionSpecificVersion}">
                <div class="col-md-5 col-md-offset-1 dk-front-search-wrapper">
            </g:if>
            <g:else>
                <div class="col-md-5 col-md-offset-1 dk-front-search-wrapper" style="margin-top:100px">
            </g:else>


            <g:if test="${portalVersionBean.variantAssociationsExists}">
            %{--only useful if we have variant associations--}%
                <div class="gene-search-wrapper" style="padding-bottom:20px; font-weight: 300;">
                    <g:if test="${!portalVersionBean.regionSpecificVersion}">
                        <h2 style="font-size:20px; font-weight:300;"><g:message code="primary.text.input.header"/></h2>
                    </g:if>
                    <g:else>
                        <h2 style="font-size:20px; font-weight:300;"><g:message code="regionSpecificVersion.text.input.header"/></h2>
                    </g:else>
                    <div style="font-size: 14px;">
                        <span><g:message code="site.shared.phrases.examples" />: </span>
                        <g:each in="${portalVersionBean.geneExamples}">
                            <a class="front-search-example" href='<g:createLink controller="gene" action="geneInfo"
                                                                                params="[id:it]"/>'>${it}</a>
                            <g:helpText title="input.searchTerm.geneExample.help.header" placement="bottom"
                                        body="input.searchTerm.geneExample.help.text"/>,
                        </g:each>
                        <g:each in="${portalVersionBean.variantExamples}">
                            <a class="front-search-example" href='<g:createLink controller="gene" action="findTheRightDataPage" params="[id:it]"/>'>${it}</a>,
                            <g:helpText title="input.searchTerm.variantExample.help.header" placement="right"
                                        body="input.searchTerm.variantExample.help.text" qplacer="0 0 0 2px"/>,
                        </g:each>
                        <g:each in="${portalVersionBean.rangeExamples}">
                            <g:if test="${!portalVersionBean.regionSpecificVersion}">
                                <a class="front-search-example" href='<g:createLink controller="gene" action="findTheRightDataPage"
                                                                                    params="[id:it]"/>'>${it}</a>
                            </g:if>
                            <g:else>
                                <a class="front-search-example" href='<g:createLink controller="gene" action="findTheRightDataPage"
                                                                                    params="[id:it]"/>'>${it}</a>
                            </g:else>

                            <g:helpText title="input.searchTerm.rangeExample.help.header" placement="bottom"
                                        body="input.searchTerm.rangeExample.help.text"/>
                        </g:each>



                    </div>


                    <div class="form-inline" style="padding-top: 10px;">
                        <input id="generalized-input" type="text" class="form-control input-sm" style="width: 83%; height: 35px; background-color:#fff; border:none; border-radius: 5px; margin:0; font-size: 16px;">
                        <button id="generalized-go" class="btn btn-primary btn-sm" type="button" style="width:15%; height: 35px; background-color:#fff; color: #000; border:none; border-radius: 5px; margin:0; background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right;"><g:message code="mainpage.button.imperative"/>&nbsp;&nbsp;&nbsp;</button>
                        <div class="errorReporter">${errorText}</div>
                    </div>

                </div>
            </g:if>


            <g:if test="${portalVersionBean.geneLevelDataExists}">
            %{--only useful if we have gene-level associations--}%
                <div class="gene-search-wrapper" style="padding-bottom:20px; font-weight: 300;">
                    <h2 style="font-size:20px; font-weight:300;"><g:message code="primary.text.input.header"/></h2>
                    <div style="font-size: 14px;">
                        <span><g:message code="site.shared.phrases.examples" />: </span>
                        <g:each in="${portalVersionBean.geneExamples}">
                            <a class="front-search-example" href='<g:createLink controller="variantSearch" action="findEveryVariantForAGene"
                                                                                params="[gene:it]"/>'>${it}</a>
                            <g:helpText title="input.searchTerm.geneExample.help.header" placement="bottom"
                                        body="input.searchTerm.geneExample.help.text"/>,
                        </g:each>
                        <g:each in="${portalVersionBean.variantExamples}">
                            <a class="front-search-example" href='<g:createLink controller="variantInfo" action="variantInfo" params="[id:it]"/>'>${it}</a>,
                            <g:helpText title="input.searchTerm.variantExample.help.header" placement="right"
                                        body="input.searchTerm.variantExample.help.text" qplacer="0 0 0 2px"/>,
                        </g:each>
                        <g:each in="${portalVersionBean.rangeExamples}">
                            <a class="front-search-example" href='<g:createLink controller="variantSearch" action="findEveryVariantForARange"
                                                                                params="[region:it]"/>'>${it}</a>
                            <g:helpText title="input.searchTerm.rangeExample.help.header" placement="bottom"
                                        body="input.searchTerm.rangeExample.help.text"/>
                        </g:each>



                    </div>


                    <div class="form-inline" style="padding-top: 10px;">
                        <input id="generalized-gene-input" type="text" class="form-control input-sm" style="width: 83%; height: 35px; background-color:#fff; border:none; border-radius: 5px; margin:0; font-size: 16px;">
                        <button id="generalized-gene-go" class="btn btn-primary btn-sm" type="button" style="width:15%; height: 35px; background-color:#fff; color: #000; border:none; border-radius: 5px; margin:0; background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right;"><g:message code="mainpage.button.imperative"/>&nbsp;&nbsp;&nbsp;</button>
                        <div class="errorReporter">${errorText}</div>
                    </div>

                </div>
            </g:if>
            <g:if test="${!portalVersionBean.regionSpecificVersion}">
                <div style="padding-bottom:10px;" class="variant-finder-wrapper">
                    <h2 style="font-size:20px; font-weight:300;"><g:message code="variant.search.header"/></h2>
                    <p class="dk-footnote" style="width:83%;"><g:message code="variant.search.specifics"/></p>
                    <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">
                        <button class="btn btn-primary btn-sm" type="button" style="width:15%; height: 35px; background-color:#fff; color: #000; border:none; border-radius: 5px;  margin:0; background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right; margin-right:1%; margin-top: -45px; float:right;"><g:message code="mainpage.button.imperative"/>&nbsp;&nbsp;&nbsp;</button>
                    </a>
                </div>
                <div class="traits-filter-wrapper">
                    <g:if test="${portalVersionBean.variantAssociationsExists}">
                        <h2 style="font-size:20px; font-weight:300;"><g:message code="trait.search.header" default="View full GWAS results for a phenotype" /></h2>
                        <div class="form-inline" style="padding-top: 10px;">
                            <div class="traits-filter-ui">
                                <span style="display:block; margin: -20px 0 8px 0; font-size:13px;">(ex: bmi, glycemic; '=phenotype' for exact match)</span>
                                <input id="traits-filter" onfocus="mpgSoftware.traitsFilter.filterOnFocus()" oninput="mpgSoftware.traitsFilter.filterTraitsTable('#traits-list-table')" placeholder="Filter phenotypes" type="text" class="form-control input-sm" style="clear: left; float:left; width: 89%; height: 35px; background-color:#fff; border:none; border-bottom-left-radius: 5px; border-top-left-radius: 5px; border-bottom-right-radius: 0px; border-top-right-radius: 0px; margin:0 0 5px 0; font-size: 16px;">
                                <div style="float: right; font-size: 20px; padding: 5px 0 1px 0; color: #666; background-color: #fff; width: 10%; height: 35px; border-bottom-right-radius: 5px; border-top-right-radius: 5px; text-align: center; margin-right: 1%" onclick="mpgSoftware.traitsFilter.clearTraitsSearch()" onmouseover="mpgSoftware.traitsFilter.setBtnOver(this)" onmouseout="mpgSoftware.traitsFilter.setBtnOut(this)" ><span class="glyphicon glyphicon-refresh" aria-hidden="true"></span></div>
                            </div>
                            <div class="traits-select-ui" style="display:none;">
                                <select name="" id="trait-input" class="form-control input-sm" style="width: 83%; height: 35px; background-color:#fff; border:none; border-radius: 0; border-top-left-radius: 3px; border-bottom-left-radius: 3px; margin:0; font-size: 16px;">
                                </select>
                                <button id="traitSearchLaunch" class="btn btn-primary btn-sm" type="button" style="width:15%; height: 35px; background-color:#fff; color: #000; border:none; border-radius: 5px; margin:0; background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right;"><g:message code="mainpage.button.imperative"/>&nbsp;&nbsp;&nbsp;</button>
                            </div>
                        </div>
                    </g:if>
                    <g:if test="${portalVersionBean.geneLevelDataExists}">
                        <h2 style="font-size:20px; font-weight:300;"><g:message code="gene.search.header" default="View full GWAS results for a phenotype" /></h2>
                        <div class="form-inline" style="padding-top: 10px;">
                            <select name="" id="gene-trait-input" class="form-control input-sm" style="width: 83%; height: 35px; background-color:#fff; border:none; border-radius: 0; border-top-left-radius: 3px; border-bottom-left-radius: 3px; margin:0; font-size: 16px;">
                            </select>
                            <button id="geneTraitSearchLaunch" class="btn btn-primary btn-sm" type="button" style="width:15%; height: 35px; background-color:#fff; color: #000; border:none; border-radius: 5px; margin:0; background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right;"><g:message code="mainpage.button.imperative"/>&nbsp;&nbsp;&nbsp;</button>
                        </div>
                    </g:if>
                </div>
            </g:if>
        </div>
        </div>
        </div>
    </div>

    %{--Main search page for application--}%
    <div class="container dk-2td-content"  style="font-size:16px; padding-bottom:50px;">
        <div class="row">
            <div class="col-md-6" style="font-size:25px; font-weight:300;">

                <div class="row">
                    <div class="static-content" portal="${g.portalTypeString()}" file="about_portal.html">
                    </div>
                </div>

                    <div class="static-content" portal="${g.portalTypeString()}" file="citation.html">
                    </div>

                </div>


                    <div class="col-md-5 col-md-offset-1" style="margin-top:30px;">
                        <h3 style="font-weight:700; font-size:30px; font-family:'Oswald'; color:#000000; text-align: left; margin-top: 10px;"><g:message code="portal.home.news_headline" default="What's new" />&nbsp;<span style="color:#4eadcd; vertical-align: 5px;" class="glyphicon glyphicon-comment" aria-hidden="true"></span></h3>
                        <ul id="newsFeedHolder" class="dk-news-items gallery-fade"></ul>
                        <g:if test="${g.portalTypeString()?.equals('mi')}">
                            <div style="position:absolute; top: 25px; right:-40px; ">
                                <p style="margin-bottom:3px;">
                                    <a href="mailto:help@cvdgenetics.org">
                                        <img style="width:30px; height:30px;" src="${resource(dir:'images/icons', file:'email_update.svg')}" />
                                    </a>
                                </p>
                            </div>

                        </g:if>

                        <g:elseif test="${g.portalTypeString()?.equals('stroke')}">
                            <div style="position:absolute; top: 25px; right:-40px; ">
                                <p style="margin-bottom:3px;">
                                    <a href="https://goo.gl/forms/EcXR6Kv2P4Ifdmtl1" target="_blank">
                                        <img style="width:30px; height:30px;" src="${resource(dir:'images/icons', file:'email_update.svg')}" />
                                    </a>
                                </p>
                            </div>

                        </g:elseif>

                        <g:else>
                            <div style="position:absolute; top: 25px; right:-40px; ">
                                <p style="margin-bottom:3px;">
                                    <a href="https://docs.google.com/a/broadinstitute.org/forms/d/1bncgNMw89nmqukMPc7xIourH-Wu7Vpc4xJ6Uh4RSECI/viewform" target="_blank">
                                        <img style="width:30px; height:30px;" src="${resource(dir:'images/icons', file:'email_update.svg')}" />
                                    </a>
                                </p>
                                <p style="margin-bottom:3px;"><a href="https://twitter.com/T2DKP" target="_blank"><img style="width:30px; height:30px;" src="${resource(dir:'images/icons', file:'twitter_icn.svg')}" /></a></p>
                                <p><a href="https://www.linkedin.com/groups/8505761" target="_blank"><img style="width:30px; height:30px;" src="${resource(dir:'images/icons', file:'linkedin_icn.svg')}" /></a></p>
                            </div>
                        </g:else>

                        <div class="static-content" portal="${g.portalTypeString()}" file="about_project.html">${g.portalTypeString()}</div>

                    </div>
                </div>
                </div>
                </div>

</body>
</html>