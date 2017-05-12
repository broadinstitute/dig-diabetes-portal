<%--
  Created by IntelliJ IDEA.
  User: ben
  Date: 8/23/2014
  Time: 5:09 PM
--%>
<%@ page import="temporary.BuildInfo" %>
<%@ page import="org.broadinstitute.mpg.RestServerService" %>
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
        });
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
    </script>
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

                <div class="separator"></div>

                <g:form action='updateRestServer' method='POST' id='updateRestServer' class='form form-horizontal cssform' autocomplete='off'>
                <h4><g:message code="system.header.rest_server.prod" /> (<em><g:message code="system.shared.messages.current_server" /> = <a href="${currentRestServer}">${currentRestServer}</a></em>)</h4>
                <div class="row clearfix">
                    <div class="col-md-2"></div>
                    <div class="col-md-7">
                        <div id="datatypes-form">

                            <div class="radio">
                                <span>
                                    <label>
                                        <input id="testserver" type="radio" name="datatype" value="aws01restserver"
                                            <%=restServer.getCurrentServer()==restServer.getAws01RestServer()?" checked ":"" %> />
                                        <g:message code="system.radio.rest_server.AWS01" /> (${restServer.getAws01RestServer()})
                                    </label>

                                </span>
                            </div>

                            <div class="radio">
                                <label>
                                    <input id="testserver" type="radio" name="datatype" value="aws01newcoderestserver"
                                        <%=restServer.getCurrentServer()==restServer.getAws01NewCodeRestServer()?" checked ":"" %> />
                                    <g:message code="system.radio.rest_server.AWS01NewCode" /> (${restServer.getAws01NewCodeRestServer()})
                                </label>
                            </div>

                            <div class="radio">
                                <label>
                                    <input id="testserver" type="radio" name="datatype" value="aws02restserver"
                                        <%=restServer.getCurrentServer()==restServer.getAws02RestServer()?" checked ":"" %> />
                                    <g:message code="system.radio.rest_server.AWS02" /> (${restServer.getAws02RestServer()})
                                </label>
                            </div>

                            <div class="radio">
                                <label>
                                    <input id="testserver" type="radio" name="datatype" value="aws02newcoderestserver"
                                        <%=restServer.getCurrentServer()==restServer.getAws02NewCodeRestServer()?" checked ":"" %> />
                                    <g:message code="system.radio.rest_server.AWS02NewCode" /> (${restServer.getAws02NewCodeRestServer()})
                                </label>
                            </div>

                            <div class="radio">
                                <label>
                                    <input id="testserver" type="radio" name="datatype" value="dev01server"
                                        <%=restServer.getCurrentServer()==restServer.getDev01()?" checked ":"" %> />
                                    <g:message code="system.radio.rest_server.dev01" /> (${restServer.getDev01()})
                                </label>

                            </div>

                            <div class="radio">
                                <label>
                                    <input id="testserver" type="radio" name="datatype" value="dev02server"
                                        <%=restServer.getCurrentServer()==restServer.getDev02()?" checked ":"" %> />
                                    <g:message code="system.radio.rest_server.dev02" /> (${restServer.getDev02()})
                                </label>

                            </div>

                            <div class="radio">
                                <label>
                                    <input id="testserver" type="radio" name="datatype" value="devloadbalancedserver"
                                        <%=restServer.getCurrentServer()==restServer.getDevLoadBalanced()?" checked ":"" %> />
                                    <g:message code="system.radio.rest_server.dev" /> (${restServer.getDevLoadBalanced()})
                                </label>

                            </div>

                            <div class="radio">
                                <label>
                                    <input id="qaserver" type="radio" name="datatype" value="qaloadbalancedserver"
                                        <%=restServer.getCurrentServer()==restServer.getQaLoadBalanced()?" checked ":"" %>  />
                                    <g:message code="system.radio.rest_server.qa" /> (${restServer.getQaLoadBalanced()})
                                </label>

                            </div>
                            <div class="radio">
                                <label>
                                    <input id="prod01server" type="radio" name="datatype" value="prod01server"
                                        <%=restServer.getCurrentServer()==restServer.getProd01()?" checked ":"" %>  />
                                    <g:message code="system.radio.rest_server.prod01" /> (${restServer.getProd01()})
                                </label>

                            </div>
                            <div class="radio">
                                <label>
                                    <input id="prod02server" type="radio" name="datatype" value="prod02server"
                                        <%=restServer.getCurrentServer()==restServer.getProd02()?" checked ":"" %>  />
                                    <g:message code="system.radio.rest_server.prod02" /> (${restServer.getProd02()})
                                </label>

                            </div>

                            <div class="radio">
                                <label>
                                    <input id="prodserver" type="radio" name="datatype" value="prodloadbalancedserver"
                                        <%=restServer.getCurrentServer()==restServer.getProdLoadBalanced()?" checked ":"" %>  />
                                    <g:message code="system.radio.rest_server.prod" /> (${restServer.getProdLoadBalanced()})
                                </label>

                            </div>

                            <div class="radio">
                                <label>
                                    <input id="prodserverbroad" type="radio" name="datatype" value="prodserverbroad"
                                        <%=restServer.getCurrentServer()==restServer.getProdLoadBalancedBroad()?" checked ":"" %>  />
                                    <g:message code="system.radio.rest_server.prod_broad" /> (${restServer.getProdLoadBalancedBroad()})
                                </label>

                            </div>

                            <div class="radio">
                                <label>
                                    <input id="localserver" type="radio" name="datatype" value="localserver"
                                        <%=restServer.getCurrentServer()==restServer.getLocal()?" checked ":"" %>  />
                                    <g:message code="system.radio.rest_server.local" /> (${restServer.getLocal()})
                                </label>

                            </div>


                            <div class="radio">
                                <label>
                                    <input id="toddServer" type="radio" name="datatype" value="toddServer"
                                        <%=restServer.getCurrentServer()==restServer.getToddServer()?" checked ":"" %>  />
                                    <g:message code="system.radio.rest_server.todd" /> (${restServer.getToddServer()})
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
                                <input class="btn btn-primary btn-lg" type='submit' id="submit"
                                       value='Commit'/>
                            </div>

                        </div>
                    </div>

                </div>
                    <div class="row clearfix" style="margin: 10px; border: 1px solid grey; padding: 10px">
                        <div class="col-md-2">Immediate cache reset</div>
                        <div class="col-md-10">
                            <ul>
                                <li style="padding: 10px"><a href="http://dig-dev-01.broadinstitute.org:8888/dev/gs/reloadCache" class="btn btn-warning">reset http://dig-dev-01.broadinstitute.org:8888/dev/gs cache</a></li>
                                <li style="padding: 10px"><a href="http://dig-dev-02.broadinstitute.org:8888/dev/gs/reloadCache" class="btn btn-warning">reset http://dig-dev-02.broadinstitute.org:8888/dev/gs cache</a></li>
                                <li style="padding: 10px"><a href="${restServer.getAws01RestServer()}reloadCache" class="btn btn-warning">reset ${restServer.getAws01RestServer()} cache</a></li>
                                <li style="padding: 10px"><a href="${restServer.getAws02RestServer()}reloadCache" class="btn btn-warning">reset ${restServer.getAws02RestServer()} cache</a></li>
                                <li style="padding: 10px"><a href="${restServer.getDevLoadBalanced()}reloadCache" class="btn btn-warning">reset ${restServer.getDevLoadBalanced()} cache</a></li>
                                <li style="padding: 10px"><a href="${restServer.getQaLoadBalanced()}reloadCache" class="btn btn-warning">reset ${restServer.getQaLoadBalanced()} cache</a></li>
                                <li style="padding: 10px"><a href="${restServer.getProdLoadBalanced()}reloadCache" class="btn btn-warning">reset ${restServer.getProdLoadBalanced()} cache</a></li>
                                <li style="padding: 10px"><a href="http://dig-prod-01.broadinstitute.org:8888/prod/gs/reloadCache" class="btn btn-warning">reset http://dig-prod-01.broadinstitute.org:8888/prod/gs cache</a></li>
                                <li style="padding: 10px"><a href="http://dig-prod-02.broadinstitute.org:8888/prod/gs/reloadCache" class="btn btn-warning">reset http://dig-prod-02.broadinstitute.org:8888/prod/gs cache</a></li>
                                <li style="padding: 10px"><a href="${restServer.getToddServer()}reloadCache" class="btn btn-warning">reset ${restServer.getToddServer()} cache</a></li>
                            </ul>
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

                <g:form action='updateBackEndRestServer' method='POST' id='updateBackEndRestServer' class='form form-horizontal cssform' autocomplete='off'>
                    <h4><g:message code="system.header.rest_server.prod" /> (<em><g:message code="system.shared.messages.current_server" /> = <a href="${currentRestServer}">${currentRestServer}</a></em>)</h4>
                    <div> Hello I am the new one</div>
                    <div class="row clearfix">
                        <div class="col-md-2"></div>
                        <div class="col-md-7">
                            <div id="datatypes-formid">
                                <g:each var="server" in="${restServerList}">
                                    <div class="radio">
                                        <label>
                                            <input id="RestServer" type="radio" name="datatype" value="${server?.name}"
                                                <%=currentRestServer==server?" checked ":"" %> />
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


            <g:form action='changeDataVersion' method='POST' class='form form-horizontal cssform' autocomplete='off'>
                <h4><g:message code="system.header.data_version" /></h4>
                <input type="text" name="datatype" Value="${dataVersion}"><br>
                <div class="row clearfix">
                    <div class="col-md-6"></div>
                    <div class="col-md-6">
                        <div >
                            <div style="text-align:center; padding-top: 20px;">
                                <input class="btn btn-primary btn-lg" type='submit' id="submitDataVersionText"
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

