<%--
  Created by IntelliJ IDEA.
  User: ben
  Date: 8/23/2014
  Time: 5:09 PM
--%>
<%@ page import="temporary.BuildInfo" %>
<%@ page import="org.broadinstitute.mpg.RestServerService" %>
<r:require module="mustache"/>
%{--Use RestServerService--}%
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:layoutResources/>
    <script>
    var refreshGenesForChromosome = function ()  {
        $.ajax({
            cache: false,
            type: "post",
            url: "${createLink(action:"refreshGeneCache")}",
            data: {chromosome: '1'},
            async: true,
            success: function (data) {
                console.log('done')
            },
            error: function (jqXHR, exception) {
                // core.errorReporter(jqXHR, exception);
            }
        });are
    } ;
    var refreshVariantsForChromosome = function ()  {
        $.ajax({
            cache: false,
            type: "post",
            url: "${createLink(action:"refreshVariantsForChromosome")}",
            data: {chromosome: '1'},
            async: true,
            success: function (data) {
                console.log('done')
            },
            error: function (jqXHR, exception) {
                // core.errorReporter(jqXHR, exception);
            }
        });
    } ;
    $(document).ready(function () {
        $.ajax({
            cache: false,
            type: "get",
            url: "${createLink(controller:"system", action:"getPortalVersionList")}",
            async: true,
            success: function (data) {
                $("#versionAdjusterGoesHere").empty().append(Mustache.render( $('#versionTemplate')[0].innerHTML,data));
                console.log('done with getPortalVersionList')
            },
            error: function (jqXHR, exception) {
                 core.errorReporter(jqXHR, exception);
            }
        });

    });
</script>
<style>
    span.headerForVersionTable {
        font-size: 16px;
        font-weight: bold;
        text-decoration: underline;
    }
    span.elementForVersionTable {
        font-size: 14px;
        font-weight: bold;
    }
</style>
</head>

<body>
<g:set var="restServer" bean="restServerService"/>

<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >
                <div class="row clearfix">

                    <div class="col-md-12">
                        <h2>
                            <g:message code="system.messages.rest_server.prod" />
                        </h2>
                    </div>

                </div>


                <g:form action='updateBackEndRestServer' method='POST' id='updateBackEndRestServer' class='form form-horizontal cssform' autocomplete='off'>
                    <h4><g:message code="system.header.rest_server.prod" /> (<em><g:message code="system.shared.messages.current_server" /> = <a href="${currentRestServer.url}">${currentRestServer.name}</a></em>)</h4>

                    <div>
                            <div id="datatypes-formid">
                                <g:each var="server" in="${restServerList}">
                                        <div class="radio" >
                                            <label style="display: inline-flex">
                                                    <input id="RestServer" type="radio" name="datatype" value="${server?.name}"
                                                        <%=currentRestServer==server?" checked ":"" %> />
                                                    ${server?.name} (${server.url})
                                                    <ul> <li class="btn btn-warning"><a href="${server.url}reloadCache"> Reset</a> </li></ul>
                                            </label>
                                        </div>
                                </g:each>
                            </div>

                    </div>
                    <div class="row clearfix">
                        <div class="col-md-6"></div>
                        <div class="col-md-6">
                            <div >
                                <div style="text-align:center; padding-top: 20px;">
                                    <input class="btn btn-primary btn-lg" type='submit' id="submitRestServer"
                                           value='Commit'/>
                                </div>

                            </div>
                        </div>

                    </div>
                    <div class="row clearfix">
                        <div class="col-md-2"></div>
                        <div class="col-md-8">
                            <div >
                                <g:if test='${flash.message}'>
                                    <div class="alert alert-danger">${flash.message}</div>
                                </g:if>
                            </div>
                        </div>
                        <div class="col-md-2"></div>

                    </div>
                </g:form>

            <g:form action='updateBurdenRestServer' method='POST' id='updateBurdenRestServer' class='form form-horizontal cssform' autocomplete='off'>
                <h4><g:message code="system.header.rest_server.burden_test" /> (<em><g:message code="system.shared.messages.current_server" /> = <a href="${burdenCurrentRestServer?.url}">${burdenCurrentRestServer?.name}</a></em>)</h4>
                <div class="row clearfix">
                    <div class="col-md-2"></div>
                    <div class="col-md-7">
                        <div id="datatypes-forma">
                            <g:each var="server" in="${burdenRestServerList}">
                                <div class="radio">
                                    <label>
                                        <input id="burdenRestServer" type="radio" name="datatype" value="${server?.name}"
                                            <%=burdenCurrentRestServer==server?" checked ":"" %> />
                                        ${server?.name} (${server.url})
                                    </label>
                                </div>
                            </g:each>
                        </div>
                    </div>
                    <div class="col-md-3"></div>
                </div>
                <div class="row clearfix">
                    <div class="col-md-6"></div>
                    <div class="col-md-6">
                        <div >
                            <div style="text-align:center; padding-top: 20px;">
                                <input class="btn btn-primary btn-lg" type='submit' id="submitBurden"
                                       value='Commit'/>
                            </div>

                        </div>
                    </div>

                </div>
                <div class="row clearfix">
                    <div class="col-md-2"></div>
                    <div class="col-md-8">
                        <div >
                            <g:if test='${flash.message}'>
                                <div class="alert alert-danger">${flash.message}</div>
                            </g:if>
                        </div>
                    </div>
                    <div class="col-md-2"></div>

                </div>
            </g:form>



            <div class="separator"></div>

            <g:form url="[action:'updateBetaFeaturesDisplayed', controller:'system']" method='POST' id='updateBetaFeatures' class='form form-horizontal cssform' autocomplete='off'>
                <h4><g:message code="system.beta.feature.display.header" /> (<em><g:message code="system.beta.feature.display.header" /> = ${(betaFeaturesDisplayed)?"true":"false"}</em>)</h4>
                <div class="row clearfix">
                    <div class="col-md-2"></div>
                    <div class="col-md-7">
                        <div id="datatypes-betafeatures">
                            <div id="betaFeaturesDisplayed-form">
                                <div class="radio">
                                    <label>
                                        <input id="testserver" type="radio" name="betaFeaturesDisplayed" value="1"
                                            <%=(betaFeaturesDisplayed)?" checked ":"" %> />
                                        <g:message code="system.beta.feature.display.radio1" />
                                    </label>
                                </div>

                                <div class="radio">
                                    <label>
                                        <input id="prodserver" type="radio" name="betaFeaturesDisplayed" value="0"
                                            <%=(!betaFeaturesDisplayed)?" checked ":"" %>  />
                                        <g:message code="system.beta.feature.display.radio2" />
                                    </label>
                                </div>

                            </div>

                        </div>
                    </div>
                    <div class="col-md-3"></div>
                </div>
                <div class="row clearfix">
                    <div class="col-md-6"></div>
                    <div class="col-md-6">
                        <div >
                            <div style="text-align:center; padding-top: 20px;">
                                <input class="btn btn-primary btn-lg" type='submit' id="betaFeaturesDisplayed"
                                       value='Commit'/>
                            </div>

                        </div>
                    </div>

                </div>
                <div class="row clearfix">
                    <div class="col-md-2"></div>
                    <div class="col-md-8">
                        <div >
                            <g:if test='${flash.message}'>
                                <div class="alert alert-danger">${flash.message}</div>
                            </g:if>
                        </div>
                    </div>
                    <div class="col-md-2"></div>

                </div>
            </g:form>






            <div class="separator"></div>

            <g:form action='updateLocusZoomRestServer' method='POST' id='updateLocusZoomRestServer' class='form form-horizontal cssform' autocomplete='off'>
                <h4><g:message code="system.header.rest_server.locuszoom" /> (<em><g:message code="system.shared.messages.current_server" /> = ${currentLocusZoomEndpoint}</em>)</h4>
                <div class="row clearfix">
                    <div class="col-md-2"></div>
                    <div class="col-md-7">
                        <div id="datatypes-formlz">
                            <g:each var="lZServer" in="${locusZoomEndpointSelectionList}">
                                <div class="radio">
                                    <label>
                                        <input id="locusZoomRestServer" type="radio" name="locusZoomRestServer" value="${lZServer}"
                                            <%=lZServer==currentLocusZoomEndpoint?" checked ":"" %> />
                                        ${lZServer}
                                    </label>
                                </div>
                            </g:each>
                        </div>
                    </div>
                    <div class="col-md-3"></div>
                </div>
                <div class="row clearfix">
                    <div class="col-md-6"></div>
                    <div class="col-md-6">
                        <div >
                            <div style="text-align:center; padding-top: 20px;">
                                <input class="btn btn-primary btn-lg" type='submit' id="submitLocusZoom"
                                       value='Commit'/>
                            </div>

                        </div>
                    </div>

                </div>
                <div class="row clearfix">
                    <div class="col-md-2"></div>
                    <div class="col-md-8">
                        <div >
                            <g:if test='${flash.message}'>
                                <div class="alert alert-danger">${flash.message}</div>
                            </g:if>
                        </div>
                    </div>
                    <div class="col-md-2"></div>

                </div>
            </g:form>

            <div class="separator"></div>

            <g:form action='changeRecognizedStringsOnly' method='POST' class='form form-horizontal cssform' autocomplete='off'>
                <h4><g:message code="system.header.rest_server.recognize_strings" /></h4>
                <input type="text" name="datatype" Value="${recognizedStringsOnly}"><br>
                <div class="row clearfix">
                    <div class="col-md-6"></div>
                    <div class="col-md-6">
                        <div >
                            <div style="text-align:center; padding-top: 20px;">
                                <input class="btn btn-primary btn-lg" type='submit' id="submitRecognizedStringsText"
                                       value='Commit'/>
                            </div>

                        </div>
                    </div>

                </div>
                <div class="row clearfix">
                    <div class="col-md-2"></div>
                    <div class="col-md-8">
                        <div >
                            <g:if test='${flash.message}'>
                                <div class="alert alert-danger">${flash.message}</div>
                            </g:if>
                        </div>
                    </div>
                    <div class="col-md-2"></div>

                </div>
            </g:form>


            <div class="separator"></div>


                 <div class="row clearfix">
                     <div class="col-md-2"></div>
                     <div class="col-md-3"> <div><a class='btn btn-primary btn-lg' onclick="refreshGenesForChromosome()" href="#"><g:message code="system.action.refresh_cache" args="${['gene']}" /></a></div>
                             <g:if test="${(currentGeneChromosome=='1')}">
                                  <h5><g:message code="system.messages.cache.not_refreshed" args="${['Genes']}" /></h5>
                             </g:if>
                             <g:elseif test="${((currentGeneChromosome!='1') && (currentGeneChromosome?.length()>0))}">
                                 <g:message code="system.messages.cache.refreshing" args="${['genes']}" /> ${currentGeneChromosome}
                             </g:elseif>
                             <g:elseif test="${(currentGeneChromosome?.length()==0)}">
                                 <g:message code="system.messages.cache.refreshed" args="${['gene']}" />
                             </g:elseif>
                             <div class="text-center" style="font-weight: bold">
                                 <g:message code="system.messages.cache.cached" args="${['genes']}" />: <g:formatNumber number="${totalNumberOfGenes}" format="###,###,###"/>
                             </div>
                     </div>
                     <div class="col-md-2"></div>
                     <div class="col-md-3"> <div><a class='btn btn-primary btn-lg' onclick="refreshVariantsForChromosome()">Refresh variant cache</a> </div>
                         <g:if test="${(currentVariantChromosome=='1')}">
                             <h5><g:message code="system.messages.cache.not_refreshed" args="${['Variants']}" /></h5>
                         </g:if>
                         <g:elseif test="${((currentVariantChromosome!='1') && (currentVariantChromosome?.length()>0))}">
                             <g:message code="system.messages.cache.refreshing" args="${['variants']}" /> ${currentVariantChromosome}
                         </g:elseif>
                         <g:elseif test="${(currentVariantChromosome?.length()==0)}">
                             <g:message code="system.messages.cache.refreshed" args="${['variant']}" />
                         </g:elseif>
                         <div class="text-center" style="font-weight: bold">
                             <g:message code="system.messages.cache.cached" args="${['variants']}" />: <g:formatNumber number="${totalNumberOfVariants}" format="###,###,###"/>
                         </div>
                     </div>
                     <div class="col-md-2"></div>
                </div>



            <div class="separator"></div>


            <div class="row clearfix">
                <div class="col-md-4" style="text-align: right">Change text and/or translations</div>
                <div class="col-md-4">
                    <a class='btn btn-primary btn-lg' href="<g:createLink controller='localization' action='list' />?format=">
                        Interactive text manipulation tool
                    </a>
                </div>
                <div class="col-md-4"></div>
            </div>

            <div class="row clearfix" style="margin-top:15px">
                <div class="col-md-4" style="text-align: right">Change gene definitions</div>
                <div class="col-md-4">
                    <a class='btn btn-primary btn-lg' href="<g:createLink controller='gene' action='list' />?format=">
                        Interactive gene manipulation tool
                    </a>
                </div>
                <div class="col-md-4"></div>
            </div>


            <div class="separator"></div>

                <g:form action='switchSigmaT2d' method='POST' class='form form-horizontal cssform' autocomplete='off'>
                    <h4><g:message code="system.header.application" />(<em><g:message code="system.shared.messages.current_app" /> = <strong>${currentApplicationIsSigma}</strong></em>)</h4>
                    <div class="row clearfix">
                        <div class="col-md-3"></div>
                        <div class="col-md-6">
                            <div id="application-form">


                                <div class="radio">
                                    <label>
                                        <input id="t2dgenes" type="radio" name="datatype" value="t2dgenes"  <%=(currentApplicationIsSigma=='t2dGenes')?'checked':''%> />
                                        <g:message code="informational.shared.cohort.t2dgenes" />
                                    </label>
                                </div>
                                <div class="radio">
                                    <label>
                                        <input id="beacon" type="radio" name="datatype" value="beacon"  <%=(currentApplicationIsSigma=='Beacon')?'checked':''%> />
                                        <g:message code="site.shared.phrases.beacon" />
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3"></div>
                    </div>
                    <div class="row clearfix">
                        <div class="col-md-6"></div>
                        <div class="col-md-6">
                            <div >
                                <div style="text-align:center; padding-top: 20px;">
                                    <input class="btn btn-primary btn-lg" type='submit' id="submitApplication"
                                           value='Commit'/>
                                </div>

                            </div>
                        </div>

                    </div>
                    <div class="row clearfix">
                        <div class="col-md-2"></div>
                        <div class="col-md-8">
                            <div >
                                <g:if test='${flash.message}'>
                                    <div class="alert alert-danger">${flash.message}</div>
                                </g:if>
                            </div>
                        </div>
                        <div class="col-md-2"></div>

                    </div>
                </g:form>

                <div class="separator"></div>


            <g:form action='updateHelpTextLevel' method='POST' class='form form-horizontal cssform' autocomplete='off'>
                <h4><g:message code="system.header.help_text" />(<em><g:message code="system.shared.messages.current_setting" /> = <strong>${helpTextLevel}</strong></em>)</h4>
                <div class="row clearfix">
                    <div class="col-md-3"></div>
                    <div class="col-md-6">
                        <div id="help-text-form">


                            <div class="radio">
                                <label>
                                    <input id="noHelpText" type="radio" name="datatype" value="none"  <%=(helpTextLevel==0)?'checked':''%> />
                                    <g:message code="system.radio.help_text.never_display" />
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input id="conditionalHelpText" type="radio" name="datatype" value="conditional" <%=(helpTextLevel==1)?'checked':''%> />
                                    <g:message code="system.radio.help_text.sometimes_display" />
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input id="allHelpText" type="radio" name="datatype" value="always"  <%=(helpTextLevel==2)?'checked':''%> />
                                    <g:message code="system.radio.help_text.always_display" />
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3"></div>
                </div>
                <div class="row clearfix">
                    <div class="col-md-6"></div>
                    <div class="col-md-6">
                        <div >
                            <div style="text-align:center; padding-top: 20px;">
                                <input class="btn btn-primary btn-lg" type='submit' id="submitHelpTextApplication"
                                       value='Commit'/>
                            </div>

                        </div>
                    </div>

                </div>
                <div class="row clearfix">
                    <div class="col-md-2"></div>
                    <div class="col-md-8">
                        <div >
                            <g:if test='${flash.message}'>
                                <div class="alert alert-danger">${flash.message}</div>
                            </g:if>
                        </div>
                    </div>
                    <div class="col-md-2"></div>

                </div>
            </g:form>



            <div class="separator"></div>

            <g:render template="../templates/systemTemplate"/>
            <div id="versionAdjusterGoesHere"></div>
            %{--<g:form action='changeDataVersion' method='POST' class='form form-horizontal cssform' autocomplete='off'>--}%
                %{--<h4><g:message code="system.header.data_version" /></h4>--}%
                %{--<input type="text" name="datatype" Value="${dataVersion}"><br>--}%
                %{--<div class="row clearfix">--}%
                    %{--<div class="col-md-6"></div>--}%
                    %{--<div class="col-md-6">--}%
                        %{--<div >--}%
                            %{--<div style="text-align:center; padding-top: 20px;">--}%
                                %{--<input class="btn btn-primary btn-lg" type='submit' id="submitDataVersionText"--}%
                                       %{--value='Commit'/>--}%
                            %{--</div>--}%

                        %{--</div>--}%
                    %{--</div>--}%

                %{--</div>--}%
                %{--<div class="row clearfix">--}%
                    %{--<div class="col-md-2"></div>--}%
                    %{--<div class="col-md-8">--}%
                        %{--<div >--}%
                            %{--<g:if test='${flash.message}'>--}%
                                %{--<div class="alert alert-danger">${flash.message}</div>--}%
                            %{--</g:if>--}%
                        %{--</div>--}%
                    %{--</div>--}%
                    %{--<div class="col-md-2"></div>--}%

                %{--</div>--}%
          %{--</g:form>--}%






            <div class="separator"></div>


            <g:form action='forceMetadataCacheUpdate' method='POST' class='form form-horizontal cssform' autocomplete='off'>
                <h4><g:message code="system.header.metadata_cache" /></h4>
                <div class="row clearfix">
                    <div class="col-md-3"></div>
                    <div class="col-md-6">
                        <div id="metadata-Override-form">


                            <div class="radio">
                                <label>
                                    <input id="noOverrideIsNecessary" type="radio" name="datatype" value="forceIt"  <%=(forceMetadataCacheOverride==true)?'checked':''%> />
                                    <g:message code="system.radio.metadata_cache.override" />
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input id="overrideIsNecessary" type="radio" name="datatype" value="doNot" <%=(forceMetadataCacheOverride==false)?'checked':''%> />
                                    <g:message code="system.radio.metadata_cache.no_override" />
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3"></div>
                </div>
                <div class="row clearfix">
                    <div class="col-md-6"></div>
                    <div class="col-md-6">
                        <div >
                            <div style="text-align:center; padding-top: 20px;">
                                <input class="btn btn-primary btn-lg" type='submit' id="submitForceMetadataCacheUpdate"
                                       value='Commit'/>
                            </div>

                        </div>
                    </div>

                </div>
                <div class="row clearfix">
                    <div class="col-md-2"></div>
                    <div class="col-md-8">
                        <div >
                            <g:if test='${flash.message}'>
                                <div class="alert alert-danger">${flash.message}</div>
                            </g:if>
                        </div>
                    </div>
                    <div class="col-md-2"></div>

                </div>
            </g:form>












            <div class="separator"></div>

            <g:form action='updateWarningText' method='POST' class='form form-horizontal cssform' autocomplete='off'>
                <h4><g:message code="system.header.warning_text" />(<em><g:message code="system.shared.messages.current_setting" /> = <strong>${warningText}</strong></em>)</h4>
                <input type="text" name="warningText" Value="${warningText}"><br>
                <div class="row clearfix">
                    <div class="col-md-6"></div>
                    <div class="col-md-6">
                        <div >
                            <div style="text-align:center; padding-top: 20px;">
                                <input class="btn btn-primary btn-lg" type='submit' id="submitWarningText"
                                       value='Commit'/>
                            </div>

                        </div>
                    </div>

                </div>
                <div class="row clearfix">
                    <div class="col-md-2"></div>
                    <div class="col-md-8">
                        <div >
                            <g:if test='${flash.message}'>
                                <div class="alert alert-danger">${flash.message}</div>
                            </g:if>
                        </div>
                    </div>
                    <div class="col-md-2"></div>

                </div>
            </g:form>


            <div class="separator"></div>


            <div class="row clearfix">
                    <div class="col-md-12">
                        <strong>
                            <g:message code="system.header.google_log" />
                            <s2o:ifLoggedInWith provider="google"><g:message code="default.confirmation.yes" /></s2o:ifLoggedInWith>
                            <s2o:ifNotLoggedInWith provider="google"><g:message code="default.confirmation.no" /></s2o:ifNotLoggedInWith>
                        </strong>
                    </div>
                </div>

                <g:render template="buildDescrBig"/>

                %{--<div class="row clearfix" style="margin-top:20px; padding: 10px">--}%

                    %{--<div class="col-md-4">--}%
                            %{--<div style="border: 2px solid darkblue; padding: 10px">--}%
                                %{--<span style="font-decoration:underline"><em>Build information</em><br /></span>--}%
                                %{--Environment: ${grails.util.Environment.current.name}.<br />--}%
                                %{--Built by ${BuildInfo.buildWho}@${BuildInfo.buildHost}<br />--}%
                                %{--at ${BuildInfo.buildTime}.--}%
                            %{--</div>--}%
                    %{--</div>--}%
                    %{--<div class="col-md-8"></div>--}%

                %{--</div>--}%



            </div>




        </div>
    </div>

</div>

</body>
</html>

