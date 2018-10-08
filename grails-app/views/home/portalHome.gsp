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
            <div class="col-md-6 portal-front-banner" style="color:#fff; font-weight:300;">
                <img src="${resource(file:g.message(code: portalVersionBean.frontLogo, default:portalVersionBean.frontLogo)) }" style="width:500px; margin-top: 30px;" />
                <p style="padding-top:10px;">
                    <g:each in="${portalVersionBean.alternateLanguages}">
                        <g:if test="${it.equals('English')}">
                            <a href='<g:createLink controller="home" action="index" params="[lang:'en']"/>' style="color:#ffffff; text-decoration: none;">
                                <g:message code="portal.language.setting.setEnglish" default="In English" /></a> |
                        </g:if >
                        <g:elseif test="${it.equals('Spanish')}">
                            <a href='<g:createLink controller="home" action="index" params="[lang:'es']"/>' style="color:#ffffff; text-decoration: none;">
                                <g:message code="portal.language.setting.setSpanish" default="En Español" /></a>
                        </g:elseif>
                    </g:each>
                </p>
                <p style="padding-top:10px; font-size:25px; font-weight: 300 !important;">
                    <g:message code="${portalVersionBean.tagline}" /></p>
            </div>
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
                    <h2 style="font-size:20px; font-weight:300;"><g:message code="analysis.module.header"/>  <span class="new-dataset-flag">&nbsp;</span></h2>
                    <p class="dk-footnote" style="width:83%;"><g:message code="analysis.module.specifics"/></p>
                    <a href="${createLink(controller: 'informational', action: 'modules')}">
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

                    <g:if test="${g.portalTypeString()?.equals('stroke')}">

                        <div class="col-md-12" style="padding-top:40px; font-size: 20px;">
                        <h2 style="font-family:'Oswald'; font-size: 40px;font-weight:700"><g:message code="portal.aboutTheData" default="About the data" /></h2>
                        <p><span  style="font-size: 20px;"><g:message code="portal.stroke.about.the.data.text" /></span>
                        <hr />


                        <g:message code="portal.stroke.about.downloads"></g:message>
                        <span style="display:block; width: 100%; text-align: right; margin-top: 0px; padding:10px 40px 10px 0;background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right;"><g:message code="portal.stroke.download.link"></g:message></span>


                        <hr/> <a href="http://institute.heart.org" target="_blank"><img src="${resource(dir: 'images/organizations', file: 'AHA_precision.jpg')}" style="width: 330px; margin-right: 10px;" align="right" ></a>

                        <g:message code="portal.stroke.about.AHA.discovery"></g:message>
                        <span style="display:block; width: 100%; text-align: right; margin-top: 0px; padding:10px 40px 10px 0; background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right;"><g:message code="portal.stroke.AHA_discovery.link"></g:message></span>


                    </g:if>

                    <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                        <div class="col-md-12" style="padding-top:40px;">
                            <img src="${resource(dir: 'images', file: 'data_icon3.png')}" style="width: 200px; margin-right: -50px;" align="right" >
                        <h2 style="font-family:'Oswald'; font-size: 40px;font-weight:700; margin-top:5px;"><g:message code="portal.aboutTheData" default="About the data" /></h2>
                        <p><g:message code="portal.mi.about.the.data.text" />
                        <hr/> <a href="http://institute.heart.org" target="_blank"><img src="${resource(dir: 'images/organizations', file: 'AHA_precision.jpg')}" style="width: 330px; margin-right: 10px;" align="right" ></a>

                        <g:message code="portal.stroke.about.AHA.discovery"></g:message>
                        <span style="display:block; width: 100%; text-align: right; margin-top: 0px; padding:10px 40px 10px 0; background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right;"><g:message code="portal.stroke.AHA_discovery.link"></g:message></span>
                    </g:elseif>
                    <g:elseif test="${g.portalTypeString()?.equals('ibd')}">
                        <div class="col-md-12" style="padding-top:40px;">
                            <img src="${resource(dir: 'images', file: 'data_icon3.png')}" style="width: 200px; margin-right: -50px;" align="right" >
                        <h2 style="font-family:'Oswald'; font-size: 40px;font-weight:700; margin-top:5px;"><g:message code="portal.aboutTheData" default="About the data" /></h2>
                    <p><g:message code="portal.ibd.about.the.data.text" />
                </g:elseif>
                <g:elseif test="${g.portalTypeString()?.equals('epilepsy')}">
                    <div class="col-md-12" style="padding-top:40px;">
                        <img src="${resource(dir: 'images', file: 'data_icon3.png')}" style="width: 200px; margin-right: -50px;" align="right" >
                        <h2 style="font-family:'Oswald'; font-size: 40px;font-weight:700; margin-top:5px;"><g:message code="portal.aboutTheData" default="About the data" /></h2>
                    <p><g:message code="portal.epi.about.the.data.text" />
                </g:elseif>
                <g:elseif test="${g.portalTypeString()?.equals('sleep')}">
                    <div class="col-md-12" style="padding-top:40px;">
                        <img src="${resource(dir: 'images', file: 'data_icon3.png')}" style="width: 200px; margin-right: -50px;" align="right" >
                        <h2 style="font-family:'Oswald'; font-size: 40px;font-weight:700; margin-top:5px;"><g:message code="portal.aboutTheData" default="About the data" /></h2>
                    <p><g:message code="portal.sleep.about.the.data.text" />
                </g:elseif>
                <g:else>
                    <div class="col-md-12" style="padding-top:40px;">
                        <img src="${resource(dir: 'images', file: 'data_icon3.png')}" style="width: 200px; margin-right: -50px;" align="right" >
                        <h2 style="font-family:'Oswald'; font-size: 40px;font-weight:700; margin-top:5px;"><g:message code="portal.aboutTheData" default="About the data" /></h2>
                    <p><g:message code="about.the.portal.data.text" />
                    <h1 style="display:block; font-size:65px; letter-spacing:-0.03em; width:550px; margin-top: 0px;"><span style="color:#F58A1F;font-family: 'Oswald'; ">47 Datasets,</span> <span style="color:#80C242;font-family: 'Oswald'; ">73 traits</span></h1>

                        <span style="display:block; width: 100%;text-align:left;"><a style=" font-size: 20px; padding:10px 40px 10px 0; margin-right: -30px;background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right; text-decoration:none; color:#333333; " href="${createLink(controller:'informational', action:'data')}"><g:message code="about.the.portal.data.text2"/></a></span>
                    </g:else>

                    <div>
                        <div style="min-width: 500px; margin-top:30px;">
                            <h3><img src="${resource(dir: 'images', file: 'kpn_logo.svg')}" style="width: 120px;" align="left"><span style="display: inline-block; font-weight:400; font-size:35px; font-family:'Oswald'; margin: 2px 0 0 10px; padding: 0px 5px 2px 5px; border: solid 1px #00b1f0; border-right: none; border-left: none;">Knowledge Portal Network</span></h3>
                            <p style="font-size: 16px;"><g:message code="portal.home.about.KPN"></g:message></p>
                        </div>

                        <g:if test="${g.portalTypeString()?.equals('stroke')}">
                            <div style="margin-top: 25px;">
                                <img src="${resource(dir: 'images', file: 'stroke_symbol.svg')}" style="width: 70px; margin-top: -10px; float: left; margin-right: 15px;">
                                <h3 style="font-size:16px; margin:0;"><g:message code="portal.home.link_to_CDKP"></g:message></h3>
                                <h3 style="font-size:23px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Cerebrovascular Disease <span style="font-family:'Oswald'; font-weight: 300;">Knowledge Portal</span></h3>
                            </div>

                            <div style="margin-top: 25px;">
                                <a href="http://www.type2diabetesgenetics.org/"><img src="${resource(dir: 'images', file: 't2d_symbol.svg')}" style="width: 76px; float: left; margin-top:-3px; margin-left:-3px; margin-right: 13px;"></a>
                                <h3 style="font-size:16px; margin:0;"><g:message code="portal.home.link_to_T2DKP"></g:message></h3>
                                <h3 style="font-size:23px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Type 2 Diabetes <span style="font-family:'Oswald'; font-weight: 300;">Knowledge Portal</span></h3>
                                <h3 style="font-size:16px; margin:5px 0 0 0; "><a href="http://www.type2diabetesgenetics.org/">Visit portal</a></h3>
                            </div>
                            <div style="margin-top: 15px;">
                                <a href="http://www.broadcvdi.org/"><img src="${resource(dir: 'images', file: 'mi_symbol.svg')}" style="width: 90px; float: left; margin-top:-10px; margin-left:-10px; margin-right: 5px;"></a>
                                <h3 style="font-size:16px; margin:0;"><g:message code="portal.home.link_to_CVDI"></g:message></h3>
                                <h3 style="font-size:23px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Cardiovascular Disease <span style="font-family:'Oswald'; font-weight: 300;">Knowledge Portal</span></h3>
                                <h3 style="font-size:16px; margin:5px 0 0 0; "><a href="http://www.broadcvdi.org/">Visit portal</a></h3>
                            </div>
                            <hr />
                            <div style="margin-top: 15px;">
                                <h3 style="font-size:35px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Other Resources</h3>
                                <h3 style="font-size:16px; margin:5px 0 0 0; "><a href="http://www.med.unc.edu/pgc" target="_blank">Psychiatric Genomics Consortium</a></h3>
                            </div>

                        </g:if>
                        <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                            <div style="margin-top: 15px;">
                                <img src="${resource(dir: 'images', file: 'mi_symbol.svg')}" style="width: 90px; float: left; margin-top:-20px; margin-left:-10px; margin-right: 5px;">
                                <h3 style="font-size:16px; margin:0;"><g:message code="portal.home.link_to_CVDI"></g:message></h3>
                                <h3 style="font-size:23px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Cardiovascular Disease <span style="font-family:'Oswald'; font-weight: 300;">Knowledge Portal</span></h3>
                            </div>

                            <div style="margin-top: 25px;">
                                <a href="http://www.type2diabetesgenetics.org/"><img src="${resource(dir: 'images', file: 't2d_symbol.svg')}" style="width: 76px; float: left; margin-top:-3px; margin-left:-3px; margin-right: 13px;"></a>
                                <h3 style="font-size:16px; margin:0;"><g:message code="portal.home.link_to_T2DKP"></g:message></h3>
                                <h3 style="font-size:23px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Type 2 Diabetes <span style="font-family:'Oswald'; font-weight: 300;">Knowledge Portal</span></h3>
                                <h3 style="font-size:16px; margin:5px 0 0 0; "><a href="http://www.type2diabetesgenetics.org/">Visit portal</a></h3>
                            </div>

                            <div style="margin-top: 15px;">
                                <a href="http://www.cerebrovascularportal.org/"><img src="${resource(dir: 'images', file: 'stroke_symbol.svg')}" style="width: 70px; float: left; margin-right: 15px;"></a>
                                <h3 style="font-size:16px; margin:0;"><g:message code="portal.home.link_to_CDKP"></g:message></h3>
                                <h3 style="font-size:23px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Cerebrovascular Disease <span style="font-family:'Oswald'; font-weight: 300;">Knowledge Portal</span></h3>
                                <h3 style="font-size:16px; margin:5px 0 0 0; "><a href="http://www.cerebrovascularportal.org/">Visit portal</a></h3>
                            </div>
                        </g:elseif>
                        <g:elseif test="${g.portalTypeString()?.equals('epilepsy')}">
                            <div style="margin-top: 25px;">
                                <a href="http://www.type2diabetesgenetics.org/"><img src="${resource(dir: 'images', file: 't2d_symbol.svg')}" style="width: 76px; float: left; margin-top:-3px; margin-left:-3px; margin-right: 13px;"></a>
                                <h3 style="font-size:16px; margin:0;"><g:message code="portal.home.link_to_T2DKP"></g:message></h3>
                                <h3 style="font-size:23px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Type 2 Diabetes <span style="font-family:'Oswald'; font-weight: 300;">Knowledge Portal</span></h3>
                                <h3 style="font-size:16px; margin:5px 0 0 0; "><a href="http://www.type2diabetesgenetics.org/">Visit portal</a></h3>
                            </div>
                            <div style="margin-top: 25px;">
                                <a href="http://www.broadcvdi.org/"><img src="${resource(dir: 'images', file: 'mi_symbol.svg')}" style="width: 90px; float: left; margin-top:-10px; margin-left:-10px; margin-right: 5px;"></a>
                                <h3 style="font-size:16px; margin:0;"><g:message code="portal.home.link_to_CVDI"></g:message></h3>
                                <h3 style="font-size:23px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Cardiovascular Disease <span style="font-family:'Oswald'; font-weight: 300;">Knowledge Portal</span></h3>
                                <h3 style="font-size:16px; margin:5px 0 0 0; "><a href="http://www.broadcvdi.org/">Visit portal</a></h3>
                            </div>

                            <div style="margin-top: 15px;">
                                <a href="http://www.cerebrovascularportal.org/"><img src="${resource(dir: 'images', file: 'stroke_symbol.svg')}" style="width: 70px; float: left; margin-right: 15px;"></a>
                                <h3 style="font-size:16px; margin:0;"><g:message code="portal.home.link_to_CDKP"></g:message></h3>
                                <h3 style="font-size:23px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Cerebrovascular Disease <span style="font-family:'Oswald'; font-weight: 300;">Knowledge Portal</span></h3>
                                <h3 style="font-size:16px; margin:5px 0 0 0; "><a href="http://www.cerebrovascularportal.org/">Visit portal</a></h3>
                            </div>

                        </g:elseif>

                        <g:else>
                            <div style="margin-top: 25px;">
                                <img src="${resource(dir: 'images', file: 't2d_symbol.svg')}" style="width: 76px; float: left; margin-top:-13px; margin-left:-3px; margin-right: 13px;">
                                <h3 style="font-size:16px; margin:0;"><g:message code="portal.home.link_to_T2DKP"></g:message></h3>
                                <h3 style="font-size:23px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Type 2 Diabetes <span style="font-family:'Oswald'; font-weight: 300;">Knowledge Portal</span></h3>
                            </div>
                            <div style="margin-top: 25px;">
                                <a href="http://www.broadcvdi.org/"><img src="${resource(dir: 'images', file: 'mi_symbol.svg')}" style="width: 90px; float: left; margin-top:-10px; margin-left:-10px; margin-right: 5px;"></a>
                                <h3 style="font-size:16px; margin:0;"><g:message code="portal.home.link_to_CVDI"></g:message></h3>
                                <h3 style="font-size:23px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Cardiovascular Disease <span style="font-family:'Oswald'; font-weight: 300;">Knowledge Portal</span></h3>
                                <h3 style="font-size:16px; margin:5px 0 0 0; "><a href="http://www.broadcvdi.org/">Visit portal</a></h3>
                            </div>

                            <div style="margin-top: 15px;">
                                <a href="http://www.cerebrovascularportal.org/"><img src="${resource(dir: 'images', file: 'stroke_symbol.svg')}" style="width: 70px; float: left; margin-right: 15px;"></a>
                                <h3 style="font-size:16px; margin:0;"><g:message code="portal.home.link_to_CDKP"></g:message></h3>
                                <h3 style="font-size:23px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Cerebrovascular Disease <span style="font-family:'Oswald'; font-weight: 300;">Knowledge Portal</span></h3>
                                <h3 style="font-size:16px; margin:5px 0 0 0; "><a href="http://www.cerebrovascularportal.org/">Visit portal</a></h3>
                            </div>

                        </g:else>
                    </div>


                    <div></div>

                </p>
                </div>
                </div>
                    <g:if test="${g.portalTypeString()?.equals('stroke')}">
                        <div class="row" style="font-size:14px; border-top: solid 2px #5FC36A; border-bottom: solid 1px #fff; background-color:#eee; color:#333; font-weight: 100; padding:10px 15px 1px 15px; margin-top:40px;">
                            <div class="col-md-2" style="color:#5FC36A; padding: 0; ">
                    </g:if>
                    <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                        <div class="row" style="font-size:14px; border-top: solid 2px #FAA61A; border-bottom: solid 1px #fff; background-color:#eee; color:#333; font-weight: 100; padding:10px 15px 1px 15px; margin-top:40px;">
                            <div class="col-md-2" style="color:#FAA61A; padding: 0; ">
                    </g:elseif>
                    <g:else>
                        <div class="row" style="font-size:14px; border-top: solid 2px #4eadcd; border-bottom: solid 1px #fff; background-color:#eee; color:#333; font-weight: 100; padding:10px 15px 1px 15px; margin-top:40px;">
                            <div class="col-md-2" style="color:#4eadcd; padding: 0; ">
                    </g:else>

                    <span style="font-family:'Oswald'; font-size: 25px;"><g:message code="portal.use.citation.title" default="Citation" /></span>
                </div>
                    <div class="col-md-10" style="">
                        <p><g:message code="portal.use.citation.request" default="Please use the following citation when referring to data accessed via this portal:"/>
                        <g:if test="${g.portalTypeString()?.equals('stroke')}">
                            <g:message code="portal.stroke.use.citation.itself" />
                        </g:if>
                        <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                            <g:message code="portal.mi.use.citation.itself" />
                        </g:elseif>
                        <g:elseif test="${g.portalTypeString()?.equals('t2d')}">
                            <g:message code="portal.use.citation.itself" />
                        </g:elseif>
                        <g:elseif test="${g.portalTypeString()?.equals('epilepsy')}">
                            <g:message code="portal.epi.use.citation.itself" />
                        </g:elseif>
                        <g:elseif test="${g.portalTypeString()?.equals('sleep')}">
                            <g:message code="portal.sleep.use.citation.itself" />
                        </g:elseif>
                        <g:else></g:else>
                        </p>
                    </div>
                </div>
                </div>

                    <div class="col-md-5 col-md-offset-1" style="margin-top:30px;">
                        <h3 style="font-weight:700; font-size:30px; font-family:'Oswald'; color:#000000; text-align: left; margin-top: 10px;"><g:message code="portal.home.news_headline" default="What's new" />&nbsp;<span style="color:#4eadcd; vertical-align: 5px;" class="glyphicon glyphicon-comment" aria-hidden="true"></span></h3>
                        <ul id="newsFeedHolder" class="dk-news-items gallery-fade"></ul>
                        <g:if test="${g.portalTypeString()?.equals('mi')}">
                            <div style="position:absolute; top: 25px; right:-40px; ">
                                <p style="margin-bottom:3px;">
                                    <a href="mailto:cvdgenetics@gmail.com">
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

                        <g:elseif test="${g.portalTypeString()?.equals('sleep')}">
                            <div style="position:absolute; top: 25px; right:-40px; ">
                                <p style="margin-bottom:3px;">
                                    <a href="mailto:help@sleepdisordergenetics.org">
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
                        <h3 style="margin-top: 0px;font-weight:700; font-size:30px; font-family:'Oswald'"><g:message code="about.the.portal.header"/></h3>
                        <g:if test="${g.portalTypeString()?.equals('stroke')}">
                            <p><g:message code="about.the.stroke.portal.text"/></p>
                            <p><g:message code='portal.stroke.home.funders'/>:</p>
                            <p>
                                <a href="http://www.nih.gov/"><img src="${resource(dir: 'images/organizations', file:'NIH3.png')}" style="width: 70px;"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <a href="http://www.ninds.nih.gov/"><img src="${resource(dir: 'images/organizations', file:'NIND.png')}" style="width: 165px;" ></a>
                            </p>
                            <p><g:message code="portal.stroke.home.amp"/></p>
                            <p>
                                <a href="https://www.nih.gov/research-training/accelerating-medicines-partnership-amp/type-2-diabetes"><img src="${resource(dir: 'images/stroke', file:'AMP_banner_small.png')}" style="width: 350px;" ></a>
                            </p>
                            <!--<h3 style="font-size:20px"><g:message code="portal.home.link_to_T2DKP"></g:message></h3>
                <a href="http://www.type2diabetesgenetics.org"><img src="${resource(dir: 'images', file: 't2dkp_h.png')}" style="width: 350px;"></a>
                -->
                        </g:if>

                        <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                            <p><g:message code="about.the.mi.portal.text"/></p>
                        </g:elseif>

                        <g:elseif test="${g.portalTypeString()?.equals('ibd')}">
                            <p><g:message code="about.the.ibd.portal.text"/></p>
                        </g:elseif>

                        <g:elseif test="${g.portalTypeString()?.equals('epilepsy')}">
                            <p><g:message code="about.the.epi.portal.text"/></p>
                        </g:elseif>

                        <g:elseif test="${g.portalTypeString()?.equals('sleep')}">
                            <p><g:message code="about.the.sleep.portal.text"/></p>
                        </g:elseif>

                        <g:else>
                            <p><g:message code="about.the.portal.text1"/>
                                <a href="${createLink(controller:'informational', action:'dataSubmission')}"><g:message code="portal.home.collaborate"/></a>
                                <g:message code="about.the.portal.text2"/></p>
                            <p><g:message code='portal.home.funders'/>:</p>

                            <a href="http://www.niddk.nih.gov/Pages/default.aspx"><img src="${resource(dir:'images/organizations', file:'nih2.jpg')}" style=""></a>
                            <a href="http://www.fnih.org"><img src="${resource(dir:'images/organizations', file:'FNIH.jpg')}" style="width: 120px"></a>
                            <a href="http://www.janssen.com"><img src="${resource(dir:'images/organizations', file:'janssen2.jpg')}" style=""></a>
                            <a href="https://www.lilly.com/home.aspx"><img src="${resource(dir:'images/organizations', file:'lilly2.jpg')}" style=""></a>
                            <a href="http://www.merck.com/index.html"><img src="${resource(dir:'images/organizations', file:'merck2.jpg')}" style=""></a>
                            <a href="http://www.pfizer.com"><img src="${resource(dir:'images/organizations', file:'pfizer2.jpg')}" style=""></a>
                            <a href="http://en.sanofi.com"><img src="${resource(dir:'images/organizations', file:'sanofi2.jpg')}" style=""></a>
                            <a href="http://jdrf.org"><img src="${resource(dir:'images/organizations', file:'jdrf2.jpg')}" style=""></a>
                            <a href="http://www.diabetes.org"><img src="${resource(dir:'images/organizations', file:'ada2.jpg')}" style=""></a>
                            <div>
                                <g:message code='portal.home.addtl_funders'/>:
                                <p><a href="http://www.fundacioncarlosslim.org/en/"><img src="${resource(dir:'images/organizations', file:'slim.png')}" style="margin-left: 80px;"></a></p>
                            </div>

                        </g:else>
                    <!--
            <div>
                        <div style="min-width: 380px; margin-top: 30px;">
                        <h3><img src="${resource(dir: 'images', file: 'kpn_logo.svg')}" style="width: 90px;" align="left"><span style="display: inline-block; font-weight:400; font-size:25px; font-family:'Oswald'; margin: 2px 0 0 10px; padding: 0px 5px 2px 5px; border: solid 1px #00b1f0; border-right: none; border-left: none;">Knowledge Portal Network</span></h3>
                        <p style="font-size: 14px;"><g:message code="portal.home.about.KNP"></g:message></p>
                    </div>
                <g:if test="${g.portalTypeString()?.equals('stroke')}">
                        <div style="margin-top: 15px;">
                            <a href="http://www.type2diabetesgenetics.org/"><img src="${resource(dir: 'images', file: 't2d_symbol.svg')}" style="width: 50px; float: left; margin-top:-2px; margin-right: 7px;"></a>
                        <h3 style="font-size:14px; margin:0;"><g:message code="portal.home.link_to_T2DKP"></g:message></h3>
                        <h3 style="font-size:18px; margin:5px 0 0 0;"><a href="http://www.type2diabetesgenetics.org/"><span style="font-family:'Oswald'; font-weight: 700; color: #333;">Type 2 Diabetes</span> <span style="font-family:'Oswald'; font-weight: 300; color: #333;">Knowledge Portal</span><span class="glyphicon glyphicon-menu-right" aria-hidden="true"></span></a></h3>
                    </div>
                    <div style="margin-top: 15px;">
                        <a href="http://www.broadcvdi.org/"><img src="${resource(dir: 'images', file: 'mi_symbol.svg')}" style="width: 60px; float: left; margin-top:-10px; margin-left:-7px; margin-right: 4px;"></a>
                        <h3 style="font-size:14px; margin:0;"><g:message code="portal.home.link_to_CVDI"></g:message></h3>
                        <h3 style="font-size:18px; margin:5px 0 0 0;"><a href="http://www.broadcvdi.org/"><span style="font-family:'Oswald'; font-weight: 700; color: #333;">Cardiovascular Disease</span> <span style="font-family:'Oswald'; font-weight: 300; color: #333;">Knowledge Portal</span><span class="glyphicon glyphicon-menu-right" aria-hidden="true"></span></a></h3>
                    </div>
                    <div style="margin-top: 15px;">
                        <a href="http://www.cerebrovascularportal.org/"><img src="${resource(dir: 'images', file: 'stroke_symbol.svg')}" style="width: 46px; float: left; margin-top:-3px; margin-right: 10px;"></a>
                        <h3 style="font-size:14px; margin:0;"><g:message code="portal.home.link_to_CDKP"></g:message></h3>
                        <h3 style="font-size:18px; margin:5px 0 0 0;"><a href="http://www.cerebrovascularportal.org/"><span style="font-family:'Oswald'; font-weight: 700; color: #333;">Cerebrovascular Disease</span> <span style="font-family:'Oswald'; font-weight: 300; color: #333;">Knowledge Portal</span><span class="glyphicon glyphicon-menu-right" aria-hidden="true"></span></a></h3>
                    </div>
                    </g:if>
                    <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                        <div style="margin-top: 15px;">
                            <a href="http://www.type2diabetesgenetics.org/"><img src="${resource(dir: 'images', file: 't2d_symbol.svg')}" style="width: 50px; float: left; margin-top:-2px; margin-right: 7px;"></a>
                        <h3 style="font-size:14px; margin:0;"><g:message code="portal.home.link_to_T2DKP"></g:message></h3>
                        <h3 style="font-size:18px; margin:5px 0 0 0;"><a href="http://www.type2diabetesgenetics.org/"><span style="font-family:'Oswald'; font-weight: 700; color: #333;">Type 2 Diabetes</span> <span style="font-family:'Oswald'; font-weight: 300; color: #333;">Knowledge Portal</span><span class="glyphicon glyphicon-menu-right" aria-hidden="true"></span></a></h3>
                    </div>
                    <div style="margin-top: 15px;">
                        <a href="http://www.broadcvdi.org/"><img src="${resource(dir: 'images', file: 'mi_symbol.svg')}" style="width: 60px; float: left; margin-top:-10px; margin-left:-7px; margin-right: 4px;"></a>
                        <h3 style="font-size:14px; margin:0;"><g:message code="portal.home.link_to_CVDI"></g:message></h3>
                        <h3 style="font-size:18px; margin:5px 0 0 0;"><a href="http://www.broadcvdi.org/"><span style="font-family:'Oswald'; font-weight: 700; color: #333;">Cardiovascular Disease</span> <span style="font-family:'Oswald'; font-weight: 300; color: #333;">Knowledge Portal</span><span class="glyphicon glyphicon-menu-right" aria-hidden="true"></span></a></h3>
                    </div>
                    <div style="margin-top: 15px;">
                        <a href="http://www.cerebrovascularportal.org/"><img src="${resource(dir: 'images', file: 'stroke_symbol.svg')}" style="width: 46px; float: left; margin-top:-3px; margin-right: 10px;"></a>
                        <h3 style="font-size:14px; margin:0;"><g:message code="portal.home.link_to_CDKP"></g:message></h3>
                        <h3 style="font-size:18px; margin:5px 0 0 0;"><a href="http://www.cerebrovascularportal.org/"><span style="font-family:'Oswald'; font-weight: 700; color: #333;">Cerebrovascular Disease</span> <span style="font-family:'Oswald'; font-weight: 300; color: #333;">Knowledge Portal</span><span class="glyphicon glyphicon-menu-right" aria-hidden="true"></span></a></h3>
                    </div>
                    </g:elseif>
                    <g:else>
                        <div style="margin-top: 15px;">
                           <a href="http://www.type2diabetesgenetics.org/"><img src="${resource(dir: 'images', file: 't2d_symbol.svg')}" style="width: 50px; float: left; margin-top:-2px; margin-right: 7px;"></a>
                        <h3 style="font-size:14px; margin:0;"><g:message code="portal.home.link_to_T2DKP"></g:message></h3>
                        <h3 style="font-size:18px; margin:5px 0 0 0;"><a href="http://www.type2diabetesgenetics.org/"><span style="font-family:'Oswald'; font-weight: 700; color: #333;">Type 2 Diabetes</span> <span style="font-family:'Oswald'; font-weight: 300; color: #333;">Knowledge Portal</span><span class="glyphicon glyphicon-menu-right" aria-hidden="true"></span></a></h3>
                    </div>
                    <div style="margin-top: 15px;">
                        <a href="http://www.broadcvdi.org/"><img src="${resource(dir: 'images', file: 'mi_symbol.svg')}" style="width: 60px; float: left; margin-top:-10px; margin-left:-7px; margin-right: 4px;"></a>
                        <h3 style="font-size:14px; margin:0;"><g:message code="portal.home.link_to_CVDI"></g:message></h3>
                        <h3 style="font-size:18px; margin:5px 0 0 0;"><a href="http://www.broadcvdi.org/"><span style="font-family:'Oswald'; font-weight: 700; color: #333;">Cardiovascular Disease</span> <span style="font-family:'Oswald'; font-weight: 300; color: #333;">Knowledge Portal</span><span class="glyphicon glyphicon-menu-right" aria-hidden="true"></span></a></h3>
                    </div>
                    <div style="margin-top: 15px;">
                        <a href="http://www.cerebrovascularportal.org/"><img src="${resource(dir: 'images', file: 'stroke_symbol.svg')}" style="width: 46px; float: left; margin-top:-3px; margin-right: 10px;"></a>
                        <h3 style="font-size:14px; margin:0;"><g:message code="portal.home.link_to_CDKP"></g:message></h3>
                        <h3 style="font-size:18px; margin:5px 0 0 0;"><a href="http://www.cerebrovascularportal.org/"><span style="font-family:'Oswald'; font-weight: 700; color: #333;">Cerebrovascular Disease</span> <span style="font-family:'Oswald'; font-weight: 300; color: #333;">Knowledge Portal</span><span class="glyphicon glyphicon-menu-right" aria-hidden="true"></span></a></h3>
                    </div>
                    </g:else>
                    -->
                    </div>
                </div>
                </div>
                </div>

</body>
</html>