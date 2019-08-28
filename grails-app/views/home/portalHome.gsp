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
            mpgSoftware.homePage.retrievePhenotypes('variant-association-ui','trait-input','traitSearchLaunch');
            mpgSoftware.homePage.retrieveGenePhenotypes('gene-association-ui','gene-trait-input','geneTraitSearchLaunch');
            mpgSoftware.homePage.initializeInputFields ();
        });
    });
</script>
<div class="fluid front-top-banner front-top-banner-${g.portalTypeString()}">

    <div class="container" style="color:#fff;">
        <div class="row" style="padding-top:40px;">
            <div class="col-md-12">
                <!-- Front top banner logo & tagline -->
                <div class="col-md-12">
                    <div class="front-logo-wrapper">
                        <img class="front-logo-img" src="${resource(file:g.message(code: portalVersionBean.frontLogo, default:portalVersionBean.frontLogo)) }" />
                        <span class="front-logo-tagline front-logo-tagline-${g.portalTypeString()}"><g:message code="${portalVersionBean.tagline}" />
                        <!-- Language options only for T2DKP -->
                        <br />
                            <small style="font-size: 16px;">
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
                            </small>
                        </span>
                    </div>
                </div>

                <!-- Logo and tagline part end -->

                <!-- Learn portal button linked to KP website 'new_features' page -->
                <div class="col-md-6 col-md-offset-3" style="text-align: center; padding-top: 30px;">
                    <a href="http://www.kp4cd.org/new_features/${g.portalTypeString()}" target="_blank" class="btn btn-lg btn-default front-banner-btn">Learn about the portal</a>
                </div>
                <!-- Learn portal button end -->

                <!-- New features buttons -->


                <div class="col-md-12">
                    <ul id="new_features">

                    </ul>
                </div>
                <g:if test="${g.portalTypeString()?.equals('t2d')}">
                    <script type="text/javascript">
                        /* Example to add 'new' or 'updated' feature buttons;
                        mpgSoftware.homePage.newFeatures([{"name":"New Resource","link":"javascript:;","class":"resource","type":"new"},{"name":"Update Module","link":"javascript:;","class":"module","type":"updated"},{"name":"New Feature","link":"javascript:;","class":"feature","type":"new"}]);
                     */
                        mpgSoftware.homePage.newFeatures([{"name":"Predicted T2D effector genes","link":"${createLink(controller:'gene',action:'effectorGeneTable')}","class":"feature","type":"new"},
                            {"name":"Tissue enrichments","link":"${createLink(controller:'trait',action:'tissueTable')}","class":"feature","type":"new"},
                            {"name":"Video: predicted T2D effector genes","link":"https://youtu.be/cG6gxFunHt8","class":"resource","type":"new"},
                            {"name":"Webinar video: gene-specific resources in the T2DKP","link":"https://www.youtube.com/watch?v=ylPn6D1hpY4","class":"resource","type":"new"}]);
                    </script>
                </g:if>


            <!-- New features buttons end -->

                <!-- Search UI & drop-down UI in the top banner -->
                <div class="col-md-12">
                <!-- Tabs for search Ui and drop-down UI -->
                    <ul class="nav nav-tabs front-banner-ui-tabs" role="tablist">
                    <g:if test="${portalVersionBean.variantAssociationsExists}">
                        <li role="presentation" class="active">
                            <a href="#search-box" aria-controls="seach-box" role="tab" data-toggle="tab">
                                <g:if test="${!portalVersionBean.regionSpecificVersion}">
                                    <g:message code="primary.text.input.header"/>
                                </g:if>
                                <g:else>
                                    <g:message code="regionSpecificVersion.text.input.header"/>
                                </g:else>
                            </a>
                        </li>
                    </g:if>
                        <li role="presentation">
                            <a href="#drop-down" aria-controls="drop-down" role="tab" data-toggle="tab">
                                <g:message code="trait.search.header" default="View full GWAS results for a phenotype" />
                            </a>
                        </li>
                    </ul>

                <!-- Tabs for search Ui and drop-down UI end -->

                <!-- Tab contents -->
                    <div class="tab-content front-banner-ui-tabs-content">

                <!-- Tab contents for search Ui -->

                        <div role="tabpanel" class="tab-pane active" id="search-box">
                            <div class="dk-front-search-wrapper">
                                <div class="gene-search-wrapper" style="padding-bottom:20px; font-weight: 300;">

                                    <!-- Examples for front top banner search box -->
                                    <div style="font-size: 16px;">
                                    <!-- Examples for all portals -->
                                    <g:if test="${portalVersionBean.variantAssociationsExists}">
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

                                    </g:if>
                                    <!-- Examples for ALS -->

                                    <g:if test="${g.portalTypeString()?.equals('als')}">
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
                                    </g:if>
                                    </div>
                                    <!-- Examples end -->

                                    <!-- Search box in top banner -->

                                    <div class="form-inline" style="padding-top: 10px;">
                                        <input id="generalized-input" type="text" class="form-control input-lg" style="width: 83%; height: 50px; background-color:#fff; border:none; border-radius: 5px; margin:0; font-size: 20px;">
                                        <button id="generalized-go" class="btn btn-primary btn-sm" type="button" style="width:15%; height: 50px; background-color:#fff; color: #7640b1; border:none; border-radius: 5px; margin:0; background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right; font-size: 15px;"><g:message code="mainpage.button.imperative"/>&nbsp;&nbsp;&nbsp;</button>
                                        <div class="errorReporter">${errorText}</div>
                                    </div>

                                    <!-- Search box end -->

                                </div>

                            </div>
            </div>
                <!-- Tab content for 'search' end -->

                <!-- tab content for 'drop-down' UI -->

                <div role="tabpanel" class="tab-pane" id="drop-down">
                <g:if test="${!portalVersionBean.regionSpecificVersion}">
                    <div class="traits-filter-wrapper">

                        <ul class="traits-filter-options">
                        <g:if test="${portalVersionBean.geneLevelDataExists}">

                            <li class="radio-inline">
                                <label><input type="radio" name="radio-gene-association" class="radio" onchange="mpgSoftware.homePage.switchVisibility(['variant-association-ui-wrapper'],['gene-association-ui-wrapper','effector-gene-list-ui-wrapper']);" checked> View variant associations</label>
                            </li>
                            <li class="radio-inline">
                                <label><input type="radio" name="radio-gene-association" class="radio" onchange="mpgSoftware.homePage.switchVisibility(['gene-association-ui-wrapper'], ['variant-association-ui-wrapper','effector-gene-list-ui-wrapper']);" > <span style="float: left;">View gene-level T2D associations </span> </label>
                            </li>
                            <g:if test="${portalVersionBean.getExposeEffectorGeneTableUi()}">
                                <li class="radio-inline">
                                    <label><input type="radio" name="radio-gene-association" class="radio" onchange="mpgSoftware.homePage.switchVisibility(['effector-gene-list-ui-wrapper'], ['variant-association-ui-wrapper', 'gene-association-ui-wrapper']);" > <span style="float: left;">View predicted T2D effector genes</span> <span class='new-dataset-flag' style="display: inline-flex; margin:-3px 0 0 5px; width: 30px; background-size: 30px;">&nbsp;</span></label>
                                </li>
                            </g:if>
                        </g:if>
                        </ul>

                        <g:if test="${portalVersionBean.variantAssociationsExists}">
                            <div class="form-inline variant-association-ui-wrapper">
                                <!--<div class="traits-filter-ui" style="display:none;">
                                <span style="display:block; margin: -20px 0 8px 0; font-size:13px;">(ex: bmi, glycemic; '=phenotype' for exact match)</span>
                                <input id="traits-filter" onfocus="mpgSoftware.traitsFilter.filterOnFocus()" oninput="mpgSoftware.traitsFilter.filterTraitsTable('#traits-list-table')" placeholder="Filter phenotypes" type="text" class="form-control input-sm" style="clear: left; float:left; width: 89%; height: 35px; background-color:#fff; border:none; border-bottom-left-radius: 5px; border-top-left-radius: 5px; border-bottom-right-radius: 0px; border-top-right-radius: 0px; margin:0 0 5px 0; font-size: 16px;">
                                <div style="float: right; font-size: 20px; padding: 5px 0 1px 0; color: #666; background-color: #fff; width: 10%; height: 35px; border-bottom-right-radius: 5px; border-top-right-radius: 5px; text-align: center; margin-right: 1%" onclick="mpgSoftware.traitsFilter.clearTraitsSearch()" onmouseover="mpgSoftware.traitsFilter.setBtnOver(this)" onmouseout="mpgSoftware.traitsFilter.setBtnOut(this)" ><span class="glyphicon glyphicon-refresh" aria-hidden="true"></span></div>
                            </div>-->
                                <div class="traits-select-ui variant-association-ui" style="">
                                    <select name="" id="trait-input" class="form-control input-sm trait-input selectpicker" data-live-search="true" style="width: 83%; height: 50px; background-color:#fff; border:none; border-radius: 5px; margin:0; font-size: 20px;">
                                    </select>

                                    <button id="traitSearchLaunch" class="btn btn-primary btn-sm" type="button" style="width:15%; height: 50px; background-color:#fff; color: #000; border:none; border-radius: 5px; margin:15px 0 0 0; background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right; font-size: 15px;"><g:message code="mainpage.button.imperative"/>&nbsp;&nbsp;&nbsp;</button>
                                </div>
                            </div>
                        </g:if>
                        <g:if test="${portalVersionBean.geneLevelDataExists}">
                            <div class="form-inline gene-association-ui-wrapper" style="display:none;">
                                <!--<div class="gene-association-ui">
                                <select name="" id="gene-trait-input" class="form-control input-sm gene-trait-input selectpicker" data-live-search="true" style="width: 83%; height: 50px; background-color:#fff; border:none; border-radius: 5px; margin:0; font-size: 20px;">
                                </select>
                                <button id="geneTraitSearchLaunch" class="btn btn-primary btn-sm" type="button" style="width:15%; height: 50px; background-color:#fff; color: #000; border:none; border-radius: 5px; margin:0; background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right;"><g:message code="mainpage.button.imperative"/>&nbsp;&nbsp;&nbsp;</button>
                            </div>-->
                                <div class="gene-association-ui">
                                    <div class="btn-group bootstrap-select form-control input-sm gene-trait-input dropup">
                                        <button type="button" class="btn dropdown-toggle btn-default" data-toggle="dropdown" role="button" data-id="gene-trait-input" title="&amp;nbsp;&amp;nbsp;&amp;nbsp;Type 2 diabetes">
                                            <span class="filter-option pull-left">&nbsp;&nbsp;&nbsp;Type 2 diabetes</span>&nbsp;<span class="bs-caret"><span class="caret"></span></span></button>

                                        <div class="dropdown-menu open" role="combobox" style="max-height: 463px; overflow: hidden; min-height: 42px;">
                                            <div class="bs-searchbox">
                                                <input type="text" class="form-control" autocomplete="off" role="textbox" aria-label="Search">
                                            </div>
                                            <ul class="dropdown-menu inner" role="listbox" aria-expanded="false" style="max-height: 409px; overflow-y: auto; min-height: 0px;">
                                                <li class="divider" data-optgroup="0div"></li>
                                                <li data-original-index="0" class="selected active">
                                                    <a tabindex="0" class="" data-tokens="null" role="option" aria-disabled="false" aria-selected="true">
                                                        <span class="text">&nbsp;&nbsp;&nbsp;Type 2 diabetes</span>
                                                        <span class="glyphicon glyphicon-ok check-mark"></span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <a href="${createLink(controller:'trait',action:'genePrioritization')}?trait=T2D&significance=0.0005">
                                        <button class="btn btn-primary btn-sm" type="button" style="width:15%; height: 50px; background-color:#fff; color: #000; border:none; border-radius: 5px; margin:0; background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right; font-size: 14px;" ><g:message code="mainpage.button.imperative"/>&nbsp;&nbsp;&nbsp;</button></a>
                                </div>
                            </div>
                        </g:if>
                        <g:if test="${portalVersionBean.getExposeEffectorGeneTableUi()}">
                            <div class="form-inline effector-gene-list-ui-wrapper" style="display:none;">
                                <div class="gene-association-ui">
                                    <div class="btn-group bootstrap-select form-control input-sm gene-trait-input dropup">
                                        <button type="button" class="btn dropdown-toggle btn-default" data-toggle="dropdown" role="button" data-id="gene-trait-input" title="&amp;nbsp;&amp;nbsp;&amp;nbsp;Type 2 diabetes">
                                            <span class="filter-option pull-left">&nbsp;&nbsp;&nbsp;Type 2 diabetes</span>&nbsp;<span class="bs-caret"><span class="caret"></span></span></button>

                                        <div class="dropdown-menu open" role="combobox" style="max-height: 463px; overflow: hidden; min-height: 42px;">
                                            <div class="bs-searchbox">
                                                <input type="text" class="form-control" autocomplete="off" role="textbox" aria-label="Search">
                                            </div>
                                            <ul class="dropdown-menu inner" role="listbox" aria-expanded="false" style="max-height: 409px; overflow-y: auto; min-height: 0px;">
                                                <li class="divider" data-optgroup="0div"></li>
                                                <li data-original-index="0" class="selected active">
                                                    <a tabindex="0" class="" data-tokens="null" role="option" aria-disabled="false" aria-selected="true">
                                                        <span class="text">&nbsp;&nbsp;&nbsp;Type 2 diabetes</span>
                                                        <span class="glyphicon glyphicon-ok check-mark"></span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <a href="${createLink(controller:'gene', action:'effectorGeneTable')}">
                                        <button class="btn btn-primary btn-sm" type="button" style="width:15%; height: 50px; background-color:#fff; color: #000; border:none; border-radius: 5px; margin:0; background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right; font-size: 14px;" ><g:message code="mainpage.button.imperative"/>&nbsp;&nbsp;&nbsp;</button></a>
                                </div>
                            </div>
                        </g:if>
                    </div>

                </g:if>

                </div>

                <!-- tab content for 'drop-down' UI end -->
            </div>


        </div>
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
                        <h1 style="display:block; font-size:65px; letter-spacing:-0.03em; width:550px; margin-top: 0px;"><span style="color:#F58A1F;font-family: 'Oswald'; ">37 datasets,</span> <span style="color:#80C242;font-family: 'Oswald'; ">69 traits</span></h1>
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
                        <h1 style="display:block; font-size:65px; letter-spacing:-0.03em; width:550px; margin-top: 0px;"><span style="color:#F58A1F;font-family: 'Oswald'; ">28 datasets,</span> <span style="color:#80C242;font-family: 'Oswald'; ">52 traits</span></h1>

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
                    <h1 style="display:block; font-size:65px; letter-spacing:-0.03em; width:550px; margin-top: 0px;"><span style="color:#F58A1F;font-family: 'Oswald'; ">24 datasets,</span> <span style="color:#80C242;font-family: 'Oswald'; ">65 traits</span></h1>

                </g:elseif>
                    <g:elseif test="${g.portalTypeString()?.equals('lung')}">
                        <div class="col-md-12" style="padding-top:40px;">
                            <img src="${resource(dir: 'images', file: 'data_icon3.png')}" style="width: 200px; margin-right: -50px;" align="right" >
                        <h2 style="font-family:'Oswald'; font-size: 40px;font-weight:700; margin-top:5px;"><g:message code="portal.aboutTheData" default="About the data" /></h2>
                        <p><g:message code="portal.lung.about.the.data.text" />
                        %{--<h1 style="display:block; font-size:65px; letter-spacing:-0.03em; width:550px; margin-top: 0px;"><span style="color:#F58A1F;font-family: 'Oswald'; ">22 datasets,</span> <span style="color:#80C242;font-family: 'Oswald'; ">59 traits</span></h1>--}%

                    </g:elseif>

 %{--comment out this section for 52k demo site                   --}%
                <g:else>
                    <div class="col-md-12" style="padding-top:40px;">
                        <img src="${resource(dir: 'images', file: 'data_icon3.png')}" style="width: 200px; margin-right: -50px;" align="right" >
                        <h2 style="font-family:'Oswald'; font-size: 40px;font-weight:700; margin-top:5px;"><g:message code="portal.aboutTheData" default="About the data" /></h2>
                    <p><g:message code="about.the.portal.data.text" />
                    <h1 style="display:block; font-size:65px; letter-spacing:-0.03em; width:550px; margin-top: 0px;"><span style="color:#F58A1F;font-family: 'Oswald'; ">81 datasets,</span> <span style="color:#80C242;font-family: 'Oswald'; ">172 traits</span></h1>

                        <span style="display:block; width: 100%;text-align:left;"><a style=" font-size: 20px; padding:10px 40px 10px 0; margin-right: -30px;background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right; text-decoration:none; color:#333333; " href="${createLink(controller:'informational', action:'data')}"><g:message code="about.the.portal.data.text2"/></a></span>
                    </g:else>
%{--end of text to be commented out for 52k demo site--}%
 %{--alternative text for 52k demo site                  --}%
                    %{--<g:else>--}%
                        %{--<div class="col-md-12" style="padding-top:40px;">--}%
                            %{--<img src="${resource(dir: 'images', file: 'organizations/AMP_T2D-GENES.png')}" style="width: 200px; margin-right: -50px;" align="right" >--}%
                        %{--<h2 style="font-family:'Oswald'; font-size: 40px;font-weight:700; margin-top:5px;"><g:message code="portal.aboutTheData_52kQTs" default="About the data" /></h2>--}%
                        %{--<p><g:message code="about.the.portal.52kQTdata.text" />--}%
                        %{--<h1 style="display:block; font-size:65px; letter-spacing:-0.03em; width:550px; margin-top: 0px;"><span style="color:#F58A1F;font-family: 'Oswald'; ">81 datasets,</span> <span style="color:#80C242;font-family: 'Oswald'; ">187 traits</span></h1>--}%

                        %{--<span style="display:block; width: 100%;text-align:left;"><a style=" font-size: 20px; padding:10px 40px 10px 0; margin-right: -30px;background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right; text-decoration:none; color:#333333; " href="${createLink(controller:'informational', action:'data')}"><g:message code="about.the.portal.data.text2"/></a></span>--}%
                    %{--</g:else>--}%
 %{--end alternative text for 52k demo site                   --}%

                    <div>
                        <div style="min-width: 500px; margin-top:30px;">
                            <h3><a href="http://www.kp4cd.org/" target="_blank"><img src="${resource(dir: 'images', file: 'kpn_logo.svg')}" style="width: 120px;" align="left"><span style="display: inline-block; font-weight:400; font-size:35px; font-family:'Oswald'; margin: 2px 0 0 10px; padding: 0px 5px 2px 5px; border: solid 1px #00b1f0; border-right: none; border-left: none;">Knowledge Portal Network</span></a></h3>
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
                            <div style="margin-top: 15px;">
                                <a href="http://sleepdisordergenetics.org/"><img src="${resource(dir: 'images', file: 'sleep_symbol.svg')}" style="width: 90px; float: left; margin-top:-10px; margin-left:-10px; margin-right: 5px;"></a>
                                <h3 style="font-size:16px; margin:0;"><g:message code="portal.home.link_to_sleep"></g:message></h3>
                                <h3 style="font-size:23px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Sleep Disorder <span style="font-family:'Oswald'; font-weight: 300;">Knowledge Portal</span></h3>
                                <h3 style="font-size:16px; margin:5px 0 0 0; "><a href="http://sleepdisordergenetics.org/">Visit portal</a></h3>
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
                            <div style="margin-top: 15px;">
                                <a href="http://sleepdisordergenetics.org/"><img src="${resource(dir: 'images', file: 'sleep_symbol.svg')}" style="width: 90px; float: left; margin-top:-10px; margin-left:-10px; margin-right: 5px;"></a>
                                <h3 style="font-size:16px; margin:0;"><g:message code="portal.home.link_to_sleep"></g:message></h3>
                                <h3 style="font-size:23px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Sleep Disorder <span style="font-family:'Oswald'; font-weight: 300;">Knowledge Portal</span></h3>
                                <h3 style="font-size:16px; margin:5px 0 0 0; "><a href="http://sleepdisordergenetics.org/">Visit portal</a></h3>
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
                            <div style="margin-top: 15px;">
                                <a href="http://sleepdisordergenetics.org/"><img src="${resource(dir: 'images', file: 'sleep_symbol.svg')}" style="width: 90px; float: left; margin-top:-10px; margin-left:-10px; margin-right: 5px;"></a>
                                <h3 style="font-size:16px; margin:0;"><g:message code="portal.home.link_to_sleep"></g:message></h3>
                                <h3 style="font-size:23px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Sleep Disorder <span style="font-family:'Oswald'; font-weight: 300;">Knowledge Portal</span></h3>
                                <h3 style="font-size:16px; margin:5px 0 0 0; "><a href="http://sleepdisordergenetics.org/">Visit portal</a></h3>
                            </div>

                        </g:elseif>

                        <g:elseif test="${g.portalTypeString()?.equals('sleep')}">
                            <div style="margin-top: 15px;">
                                <a href="javascript:;"><img src="${resource(dir: 'images', file: 'sleep_symbol.svg')}" style="width: 90px; float: left; margin-top:-10px; margin-left:-10px; margin-right: 5px;"></a>
                                <h3 style="font-size:16px; margin:0;"><g:message code="portal.home.link_to_sleep"></g:message></h3>
                                <h3 style="font-size:23px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Sleep Disorder <span style="font-family:'Oswald'; font-weight: 300;">Knowledge Portal</span></h3>
                                <h3 style="font-size:16px; margin:5px 0 0 0; "></h3>
                            </div>
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

                            <div style="margin-top: 15px;">
                                <a href="http://sleepdisordergenetics.org/"><img src="${resource(dir: 'images', file: 'sleep_symbol.svg')}" style="width: 90px; float: left; margin-top:-10px; margin-left:-10px; margin-right: 5px;"></a>
                                <h3 style="font-size:16px; margin:0;"><g:message code="portal.home.link_to_sleep"></g:message></h3>
                                <h3 style="font-size:23px; margin:5px 0 0 0; font-family:'Oswald'; font-weight: 700;">Sleep Disorder <span style="font-family:'Oswald'; font-weight: 300;">Knowledge Portal</span></h3>
                                <h3 style="font-size:16px; margin:5px 0 0 0; "><a href="http://sleepdisordergenetics.org/">Visit portal</a></h3>
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
                    %{--<g:if test="${g.portalTypeString()?.equals('t2d')}">--}%
                        %{--<a href="http://t2d-genetics-portal.blogspot.com/2019/07/t2dkp-webinar-thursday-july-18.html" target="_blank" style="display:block; float:right; margin: 20px 15px -20px 0;"><img src="${resource(dir: 'images', file: 'webinar_jul_18.png')}" style="" ></a>--}%
                    %{--</g:if>--}%
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

                    <g:elseif test="${g.portalTypeString()?.equals('lung')}"> 
                        <p><g:message code="about.the.lung.portal.text1"/></p>
                         </g:elseif>


                    <g:elseif test="${g.portalTypeString()?.equals('sleep')}">
                            <p><g:message code="about.the.sleep.portal.text"/></p>
                            <h3 style="margin-top: 0px;font-weight:700; font-size:30px; font-family:'Oswald'"><g:message code="sleep.portal.faqs.header"/></h3>
                            <p><g:message code="sleep.portal.faqs"/></p>
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