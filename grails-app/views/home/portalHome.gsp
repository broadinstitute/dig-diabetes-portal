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
                        UTILS.fillPhenotypeCompoundDropdown(data.datasets,'#trait-input');
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

<div class="fluid" style="background-image:url(${resource(dir: 'images', file: 'banner_bg3.png')});background-size:100% auto; background-position: center; padding-bottom: 10px; padding-top:30px;">
    <div class="container">
        <div class="row" style="text-align:center;padding-bottom:15px;">
            <g:if test="${g.portalTypeString()?.equals('stroke')}">
                <img src="${resource(dir: 'images/stroke', file: g.message(code: "files.strokeFrontHeader", default: "R24_front_header.png"))}" style="width:75%;" />
            </g:if>
            <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                <img src="${resource(dir: 'images/mi', file:g.message(code:"files.miFrontHeader", default:"mi_front_header.png"))}" />
            </g:elseif>
            <g:else>
                <img src="${resource(dir: 'images', file: g.message(code: "files.t2dFrontHeader", default: "t2d_front_header6.png"))}" style="width:75%;" />
            </g:else>
        </div>
    </div>
</div>

%{--Main search page for application--}%
<div class="container dk-2td-content">
    <div class="row">
        <div class="col-md-8">
            <div>
                <h2 class="dk-search-title-homepage"><g:message code="primary.text.input.header"/></h2>

                <div class="form-inline" style="padding-top: 10px;">
                    <input id="generalized-input" type="text" class="form-control input-sm" style="width: 70%;">
                    <button id="generalized-go" class="btn btn-primary btn-sm" type="button" style="width:15%; float:right; margin-right: 5%;"><g:message code="mainpage.button.imperative"/> ></button>
                </div>
                <div>
                    <strong><g:message code="site.shared.phrases.examples" />:</strong>
                    <g:if test="${g.portalTypeString()?.equals('stroke')}">
                        <a href='<g:createLink controller="gene" action="geneInfo"
                                               params="[id: 'HDAC9']"/>'>HDAC9</a>
                    </g:if>
                    <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                        <a href='<g:createLink controller="gene" action="geneInfo"
                                               params="[id: 'LPA']"/>'>LPA</a>
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
                    <g:else>
                        <a href='<g:createLink controller="region" action="regionInfo"
                                               params="[id: 'chr9:21,940,000-22,190,000']"/>'>chr9:21,940,000-22,190,000</a>
                    </g:else>
                    <g:helpText title="input.searchTerm.rangeExample.help.header" placement="bottom"
                                body="input.searchTerm.rangeExample.help.text"/>

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
                <h2 class="dk-search-title-homepage"><g:message code="trait.search.header" default="View full GWAS results for a phenotype" /></h2>
<g:if test="${g.portalTypeString()?.equals('t2d')}"><p class="dk-footnote"><g:message code="trait.search.specifics"/>
                <g:helpText title="pheno.help.header" placement="right" body="pheno.help.text"/></p></g:if>
                <div class="form-inline" style="padding-top: 10px;">
                    <select name="" id="trait-input" class="form-control input-sm" style="width: 70%;">
                    </select>
                    <button id="traitSearchLaunch" class="btn btn-primary btn-sm" type="button" style="width:15%; float:right; margin-right: 5%;"><g:message code="mainpage.button.imperative"/> ></button>
                </div>
            </div>
            <hr />
%{--<g:if test="${!g.portalTypeString()?.equals('stroke')}">--}%
            <img src="${resource(dir: 'images/icons', file: 'data_icon.png')}" style="width: 110px; margin-right: 10px;" align="left" >
    %{--</g:if>--}%
            <h2><g:message code="portal.aboutTheData" default="About the data" /></h2>
            <p>
                <g:if test="${g.portalTypeString()?.equals('stroke')}">
                    <g:message code="portal.stroke.about.the.data.text" />
                    %{--<p><g:message code="portal.stroke.about.AHA.discovery"></g:message></p>--}%
                </g:if>
                <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                    <g:message code="portal.mi.about.the.data.text" />
                </g:elseif>
                <g:else>
                    <g:message code="about.the.portal.data.text" />
                </g:else>
            </p>

            <h2><g:message code="portal.use.citation.title" default="Citation" /></h2>
            <p><g:message code="portal.use.citation.request" default="Please use the following citation when referring to data accessed via this portal:"/><br />
                <g:if test="${g.portalTypeString()?.equals('stroke')}">
                    <g:message code="portal.stroke.use.citation.itself" />
                </g:if>
                <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                    <g:message code="portal.mi.use.citation.itself" />
                </g:elseif>
                <g:else>
                    <g:message code="portal.use.citation.itself" />
                </g:else>
            </p>

        </div>

        <div class="col-md-4">
            <h3><g:message code="portal.home.news_headline" default="What's new" /></h3>
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
            <g:if test="${g.portalTypeString()?.equals('stroke')}">
                <a class="btn btn-default" style="width:100%; margin-right: 2%; margin-bottom: 10px;"
                   href="https://goo.gl/forms/EcXR6Kv2P4Ifdmtl1"
                   target="_blank">
                    <g:message code="portal.home.mailsignup" default="Get email updates"/>
                </a>
            </g:if>
            <g:else>
                <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                    <a class="btn btn-default" style="width:65%; margin-right: 2%; margin-bottom: 0px;"
                       href="https://docs.google.com/a/broadinstitute.org/forms/d/1bncgNMw89nmqukMPc7xIourH-Wu7Vpc4xJ6Uh4RSECI/viewform"
                       target="_blank">
                        <g:message code="portal.home.mailsignup" default="Get email updates"/>
                    </a>
                    <a class="btn btn-default" style="width:12%; margin-bottom: 0px; background-color:#55bcdf; border:solid 1px #1da1f2;" href="https://twitter.com/T2DKP" target="_blank"><img src="${resource(dir:'images/icons', file:'twitter.png')}" /></a>
                    <a class="btn btn-default" style="width:12%; margin-bottom: 0px; background-color:#00A0DC; border:solid 1px #1da1f2;" href="https://www.linkedin.com/groups/8505761" target="_blank"><img src="${resource(dir:'images/icons', file:'linkedin.png')}" /></a>
                </div>
            </g:else>
            <h3 style="margin-top: 0px;"><g:message code="about.the.portal.header"/></h3>
            <g:if test="${g.portalTypeString()?.equals('stroke')}">
                <p><g:message code="about.the.stroke.portal.text"/></p>
                <p><g:message code='portal.stroke.home.funders'/>:</p>
                <p>
                    <a href="http://www.nih.gov/"><img src="${resource(dir: 'images/organizations', file:'NIH3.png')}" style="width: 70px;"></a>&nbsp;&nbsp;&nbsp;
                    <a href="http://www.ninds.nih.gov/"><img src="${resource(dir: 'images/organizations', file:'NIND.png')}" style="width: 165px;"></a>
                </p>
            </g:if>

            <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                <p><g:message code="about.the.mi.portal.text"/></p>
                </g:elseif>

            <g:else>
                <p><g:message code="about.the.portal.text1"/>
                    <a href="${createLink(controller:'informational', action:'dataSubmission')}"><g:message code="portal.home.collaborate"/></a>
                <g:message code="about.the.portal.text2"/></p>
                <p><g:message code='portal.home.funders'/>:</p>
                <table>
                    <tr>
                        <td>
                            <a href="http://www.niddk.nih.gov/Pages/default.aspx"><img src="${resource(dir:'images/organizations', file:'NIH_NIDDK.png')}" style="width: 132px;"></a>
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
            </g:else>
        </div>
    </div>
</div>

</body>
</html>
