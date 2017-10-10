<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <meta name="wot-verification" content="9fd2c3983c1837397ff8"/>
    <r:require modules="core"/>
    <r:require modules="portalHome"/>
    <r:layoutResources/>

</head>

<body>

<script>

    $(function () {
        "use strict";

        <g:applyCodec encodeAs="none">
            var newsItems = ${newsItems};
        </g:applyCodec>
        mpgSoftware.homePage.loadNewsFeed(newsItems.posts);
        mpgSoftware.homePage.setSlideWindows();

        function goToSelectedItem(item) {
            window.location.href = "${createLink(controller:'gene',action:'findTheRightDataPage')}/" + item;
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

        /***
         *  Launch find variants associated with other traits
         */
        $('#traitSearchLaunch').on('click', function () {
            var trait_val = $('#trait-input option:selected').val();
            var significance = 0.0005;
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

                        UTILS.fillPhenotypeCompoundDropdown(data.datasets,'#trait-input',undefined,undefined,'${g.portalTypeString()}');
                        var availPhenotypes = [];
                        _.forEach( $("select#trait-input option"), function(a){
                            availPhenotypes.push($(a).val());
                        });
                        if (availPhenotypes.indexOf('${g.defaultPhenotype()}')>-1){
                            $('#trait-input').val('${g.defaultPhenotype()}');
                        } else if (availPhenotypes.length>0){
                            $('#trait-input').val(availPhenotypes[0]);
                        }
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


        $('#chooseDistributedKB').change(function(e){
            var loading = $('#spinner').show();
            var target = $(e.target);
            $('#distributedKBString').text(target.val());
            $.ajax({
                type: "GET",
                url: "${createLink(controller:'home', action:'pickDistributedKb')}?distributedKB="+target.val(),
                success:function(data){
                    retrievePhenotypes();
                    loading.hide();
                }
            });
        });


    });

</script>
<g:if test="${g.portalTypeString()?.equals('stroke')}">
    <div class="fluid" style="font-size:16px; background-image:url(${resource(dir: 'images/stroke', file: 'front_bg_2017_stroke.png')});background-size:100% 100%; background-position: center; padding-bottom: 70px; padding-top:0px;">
</g:if>
<g:elseif test="${g.portalTypeString()?.equals('mi')}">
    <div class="fluid" style="font-size:16px; background-size:100% 100%; background-image: url(${resource(dir: 'images/mi', file: 'front_bg_2017_mi5.png')}); background-position: center; padding-bottom: 70px; padding-top:0px;">
</g:elseif>
<g:else>
    <div class="fluid" style="font-size:16px; background-image:url(${resource(dir: 'images', file: 'front_bg_2017-02.png')});background-size:100% 100%; background-position: center; padding-bottom: 70px; padding-top:0px;">
</g:else>
    <div class="container" style="color:#fff;">
        <div class="row" style="padding-top:40px;">
            <div class="col-md-6 portal-front-banner" style="color:#fff; font-weight:300;">
                <g:if test="${g.portalTypeString()?.equals('stroke')}">
                    <img src="${resource(dir: 'images/stroke', file: g.message(code: "files.stroke.front.logo", default: "front_logo_stroke.svg"))}" style="width:500px; margin-top: 30px;" />
                    <p style="padding-top:10px; padding-bottom:30px; font-size:25px; font-weight: 300 !important;"><g:message code="portal.stroke.header.tagline" /></p>
                </g:if>
                <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                    <img src="${resource(dir: 'images/mi', file:g.message(code:"files.miFrontHeader", default:"mi_front_header1.svg"))}" style="width:450px; margin-top: -30px; margin-left: -48px;" />
                    <p style="padding-top:10px; font-size:25px; font-weight: 300 !important;"><g:message code="portal.mi.header.tagline" /></p>
                </g:elseif>
                <g:elseif test="${g.portalTypeString()?.equals('ibd')}">
                    <img src="${resource(dir: 'images/ibd', file:g.message(code:"files.ibdFrontHeader4", default:"ibdFrontHeader4.png"))}" style="width:700px; margin-top: 50px; margin-left: -100px;" />
                    <p style="padding-top:10px; font-size:25px; font-weight: 300 !important;"><g:message code="portal.ibd.header.tagline" /></p>
                </g:elseif>
                <g:else>
                    <img src="${resource(dir: 'images', file: g.message(code: "files.t2dFrontHeader", default: "t2d_front_logo.svg"))}" style="margin-top:20px; width:500px;" />
                    <p style="padding-top:10px;">
                        <a href='<g:createLink controller="home" action="index" params="[lang:'es']"/>' style="color:#ffffff; text-decoration: none;">


                            <g:message code="portal.language.setting.setSpanish" default="En Español" /></a> |
                        <a href='<g:createLink controller="home" action="index" params="[lang:'en']"/>' style="color:#ffffff; text-decoration: none;">

                            <g:message code="portal.language.setting.setEnglish" default="In English" /></a>

                    </p>
                    <p style="padding-top:10px; font-size:25px; font-weight: 300 !important;"><g:message code="portal.header.tagline" /></p>
                </g:else>
            </div>
            <div class="col-md-5 col-md-offset-1 dk-front-search-wrapper">
                <div style="padding-bottom:20px; font-weight: 300;">
                    <h2 style="font-size:20px; font-weight:300;"><g:message code="primary.text.input.header"/></h2>
                    <div style="font-size: 14px;">
                        <span><g:message code="site.shared.phrases.examples" />: </span>
                        <g:if test="${g.portalTypeString()?.equals('stroke')}">
                            <a href='<g:createLink controller="gene" action="geneInfo"
                                                   params="[id: 'HDAC9']"/>'>HDAC9</a>
                        </g:if>
                        <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                            <a href='<g:createLink controller="gene" action="geneInfo"
                                                   params="[id: 'LPA']"/>'>LPA</a>
                        </g:elseif>
                        <g:elseif test="${g.portalTypeString()?.equals('ibd')}">
                            <a href='<g:createLink controller="gene" action="geneInfo"
                                                   params="[id: 'IL23R']"/>'>IL23R</a>
                        </g:elseif>
                        <g:else>
                            <a href='<g:createLink controller="gene" action="geneInfo"
                                                   params="[id: 'SLC30A8']"/>'>SLC30A8</a>
                        </g:else>
                        <g:helpText title="input.searchTerm.geneExample.help.header" placement="bottom"
                                    body="input.searchTerm.geneExample.help.text"/>,
                        <g:if test="${g.portalTypeString()?.equals('stroke')}">
                            <a href='<g:createLink controller="variantInfo" action="variantInfo" params="[id: 'rs2984613']"/>'>rs2984613</a>,
                            <a href='<g:createLink controller="variantInfo" action="variantInfo" params="[id: 'APOE-e2']"/>'>APOE-e2</a>
                        </g:if>
                        <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                            <a href='<g:createLink controller="variantInfo" action="variantInfo" params="[id: 'rs10965215']"/>'>rs10965215</a>,
                        </g:elseif>
                        <g:elseif test="${g.portalTypeString()?.equals('ibd')}">
                            <a href='<g:createLink controller="variantInfo" action="variantInfo" params="[id: 'rs11209026']"/>'>rs11209026</a>,
                        </g:elseif>
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
                        <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                            <a href='<g:createLink controller="region" action="regionInfo"
                                                   params="[id: 'chr9:20,940,000-21,800,000']"/>'>chr9:20,940,000-21,800,000</a>
                        </g:elseif>
                        <g:elseif test="${g.portalTypeString()?.equals('ibd')}">
                            <a href='<g:createLink controller="region" action="regionInfo"
                                                   params="[id: 'chr9:20,940,000-21,800,000']"/>'>chr9:20,940,000-21,800,000</a>
                        </g:elseif>
                        <g:else>
                            <a href='<g:createLink controller="region" action="regionInfo"
                                                   params="[id: 'chr9:21,940,000-22,190,000']"/>'>chr9:21,940,000-22,190,000</a>
                        </g:else>
                        <g:helpText title="input.searchTerm.rangeExample.help.header" placement="bottom"
                                    body="input.searchTerm.rangeExample.help.text"/>

                    </div>
                    <div class="form-inline" style="padding-top: 10px;">
                        <input id="generalized-input" type="text" class="form-control input-sm" style="width: 83%; height: 35px; background-color:#d8e3ec; border:none; border-radius: 5px; margin:0; font-size: 16px;">
                        <button id="generalized-go" class="btn btn-primary btn-sm" type="button" style="width:15%; height: 35px; background-color:#d8e3ec; color: #000; border:none; border-radius: 5px; margin:0; background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right;"><g:message code="mainpage.button.imperative"/>&nbsp;&nbsp;&nbsp;</button>
                    </div>

                </div>
                <div style="padding-bottom:10px;">
                    <h2 style="font-size:20px; font-weight:300;"><g:message code="variant.search.header"/></h2>
                    <p class="dk-footnote" style="width:83%;"><g:message code="variant.search.specifics"/></p>
                    <a href="${createLink(controller: 'variantSearch', action: 'variantSearchWF')}">
                        <button class="btn btn-primary btn-sm" type="button" style="width:15%; height: 35px; background-color:#d8e3ec; color: #000; border:none; border-radius: 5px;  margin:0; background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right; margin-right:1%; margin-top: -45px; float:right;"><g:message code="mainpage.button.imperative"/>&nbsp;&nbsp;&nbsp;</button>
                    </a>
                </div>
                <div>
                    <h2 style="font-size:20px; font-weight:300;"><g:message code="trait.search.header" default="View full GWAS results for a phenotype" /></h2>
                    <g:if test="${g.portalTypeString()?.equals('t2d')}"><p class="dk-footnote"><g:message code="trait.search.specifics"/>
                        <g:helpText title="pheno.help.header" placement="right" body="pheno.help.text"/></p></g:if>
                    <g:elseif test="${g.portalTypeString()?.equals('stroke')}"><p class="dk-footnote"><g:message code="trait.search.specifics"/>
                        <g:helpText title="pheno.help.header" placement="right" body="stroke.pheno.help.text"/></p></g:elseif>
                    <div class="form-inline" style="padding-top: 10px;">
                        <select name="" id="trait-input" class="form-control input-sm" style="width: 83%; height: 35px; background-color:#d8e3ec; border:none; border-radius: 0; border-top-left-radius: 3px; border-bottom-left-radius: 3px; margin:0; font-size: 16px;">
                        </select>
                        <button id="traitSearchLaunch" class="btn btn-primary btn-sm" type="button" style="width:15%; height: 35px; background-color:#d8e3ec; color: #000; border:none; border-radius: 5px; margin:0; background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right;"><g:message code="mainpage.button.imperative"/>&nbsp;&nbsp;&nbsp;</button>
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

            <g:if test="${!g.portalTypeString()?.equals('stroke')}">
            </g:if>
            <g:if test="${g.portalTypeString()?.equals('stroke')}">

                <div class="col-md-12" style="padding-top:40px; font-size: 20px;">
                <h2 style="font-family:'Oswald'; font-size: 40px;font-weight:700"><g:message code="portal.aboutTheData" default="About the data" /></h2>
                <p><span  style="font-size: 20px;"><g:message code="portal.stroke.about.the.data.text" /></span>
                    <hr />


                        <g:message code="portal.stroke.about.downloads"></g:message>
                        <span style="display:block; width: 275px;margin-top: 10px; padding:10px 0 10px 0;background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right;"><g:message code="portal.stroke.download.link"></g:message></span>


                <hr/> <a href="http://institute.heart.org" target="_blank"><img src="${resource(dir: 'images/organizations', file: 'AHA_precision.jpg')}" style="width: 330px; margin-right: 10px;" align="right" ></a>

                <g:message code="portal.stroke.about.AHA.discovery"></g:message>
                <span style="display:block; width: 350px;margin-top: 10px; padding:10px 0 10px 0;background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right;"><g:message code="portal.stroke.AHA_discovery.link"></g:message></span>


            </g:if>

                <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                    <div class="col-md-12" style="padding-top:40px;">
                        <img src="${resource(dir: 'images', file: 'data_icon3.png')}" style="width: 200px; margin-right: -50px;" align="right" >
                    <h2 style="font-family:'Oswald'; font-size: 40px;font-weight:700; margin-top:5px;"><g:message code="portal.aboutTheData" default="About the data" /></h2>
                    <p><g:message code="portal.mi.about.the.data.text" />
                </g:elseif>
                <g:elseif test="${g.portalTypeString()?.equals('ibd')}">
                    <div class="col-md-12" style="padding-top:40px;">
                        <img src="${resource(dir: 'images', file: 'data_icon3.png')}" style="width: 200px; margin-right: -50px;" align="right" >
                        <h2 style="font-family:'Oswald'; font-size: 40px;font-weight:700; margin-top:5px;"><g:message code="portal.aboutTheData" default="About the data" /></h2>
                    <p><g:message code="portal.ibd.about.the.data.text" />
                </g:elseif>
                <g:else>
                    <div class="col-md-12" style="padding-top:40px;">
                        <img src="${resource(dir: 'images', file: 'data_icon3.png')}" style="width: 200px; margin-right: -50px;" align="right" >
                        <h2 style="font-family:'Oswald'; font-size: 40px;font-weight:700; margin-top:5px;"><g:message code="portal.aboutTheData" default="About the data" /></h2>
                    <p><g:message code="about.the.portal.data.text" />
                    <h1 style="display:block; font-size:65px; letter-spacing:-0.03em; width:550px; margin-top: 0px;"><span style="color:#F58A1F;font-family: 'Oswald'; ">22 Datasets,</span> <span style="color:#80C242;font-family: 'Oswald'; ">47 traits</span></h1>

                    <span><a style="text-align:left; font-size: 20px; padding:10px 40px 10px 0; margin-right: -30px;background-image:url(${resource(dir: 'images', file: 'button_arrow.svg')}); background-repeat: no-repeat; background-position: center right; text-decoration:none; color:#333333; " href="${createLink(controller:'informational', action:'data')}"><g:message code="about.the.portal.data.text2"/></a></span>

                    <h3 style="font-size:20px"><g:message code="portal.home.link_to_CDKP"></g:message></h3>
                    <a href="http://cerebrovascularportal.org/"><img src="${resource(dir: 'images', file: 'to_stroke_portal.svg')}" style="width: 350px;"></a>
                    <div></div>
                </g:else>
            </p>
            </div>
            </div>
            <div class="row" style="font-size:14px; border-top: solid 2px #4eadcd; border-bottom: solid 1px #fff; background-color:#eee; color:#333; font-weight: 100; padding:10px 15px 1px 15px; margin-top:40px;">
                <div class="col-md-2" style="color:#4eadcd; padding: 0; ">
                    <span style="font-family:'Oswald'; font-size: 25px;"><g:message code="portal.use.citation.title" default="Citation" /></span>
                </div>
                <div class="col-md-10" style="">
                    <p><g:message code="portal.use.citation.request" default="Please use the following citation when referring to data accessed via this portal:"/><br />
                        <g:if test="${g.portalTypeString()?.equals('stroke')}">
                            <g:message code="portal.stroke.use.citation.itself" />
                        </g:if>
                        <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                            <g:message code="portal.mi.use.citation.itself" />
                        </g:elseif>
                        <g:elseif test="${g.portalTypeString()?.equals('t2d')}">
                            <g:message code="portal.use.citation.itself" />
                        </g:elseif>
                        <g:else></g:else>
                    </p>
                </div>
            </div>
        </div>

        <div class="col-md-5 col-md-offset-1" style="margin-top:30px;">
            <h3 style="font-weight:700; font-size:30px; font-family:'Oswald'; color:#000000; text-align: left; margin-top: 10px;"><g:message code="portal.home.news_headline" default="What's new" />&nbsp;<span style="color:#4eadcd; vertical-align: 5px;" class="glyphicon glyphicon-comment" aria-hidden="true"></span></h3>
            <ul id="newsFeedHolder" class="dk-news-items gallery-fade"></ul>
            <div style="margin: 0 10px 10px 10px; display: none">
                <label style="display: inline; padding-right: 15px"> View data at
                </label>
                <select name="chooseDistributedKB" id="chooseDistributedKB" class="form-control input-sm"
                        style="display: inline; width:100px">
                    <option value="Broad DCC" <%= (g.distributedKBString()=='Broad')? 'selected':'' %> >Broad DCC</option>
                    <option value="EBI" <%= (g.distributedKBString()=='EBI')? 'selected':'' %> >EBI</option>
                </select>
            </div>
            <g:if test="${g.portalTypeString()?.equals('mi')}">
                <div style="text-align:right;">
                    <a href="mailto:help@cvdgenetics.org">
                        <img style="width:30px; height:30px;" src="${resource(dir:'images/icons', file:'email_update.svg')}" />
                    </a>



                </div>

            </g:if>

            <g:elseif test="${g.portalTypeString()?.equals('stroke')}">
                <div style="text-align:right;">
                    <a class="btn btn-success btn-sm" style="margin-right: 2%; margin-bottom: 10px;" href="https://goo.gl/forms/EcXR6Kv2P4Ifdmtl1" target="_blank">
                        Get email updates
                    </a>
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
            </g:if>

            <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                <p><g:message code="about.the.mi.portal.text"/></p>
            </g:elseif>

            <g:elseif test="${g.portalTypeString()?.equals('ibd')}">
                <p><g:message code="about.the.ibd.portal.text"/></p>
            </g:elseif>

            <g:else>
                <p><g:message code="about.the.portal.text1"/>
                    <a href="${createLink(controller:'informational', action:'dataSubmission')}"><g:message code="portal.home.collaborate"/></a>
                <g:message code="about.the.portal.text2"/></p>
                <p><g:message code='portal.home.funders'/>:</p>

                            <a href="http://www.niddk.nih.gov/Pages/default.aspx"><img src="${resource(dir:'images/organizations', file:'nih2.jpg')}" style=""></a>
                            <a href="http://www.fnih.org"><img src="${resource(dir:'images/organizations', file:'fnih2.jpg')}" style=""></a>
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
        </div>
    </div>
</div>

</body>
</html>
