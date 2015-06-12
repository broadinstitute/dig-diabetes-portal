<%--
  Created by IntelliJ IDEA.
  User: ben
  Date: 8/23/2014
  Time: 5:09 PM
--%>
<%@ page import="temporary.BuildInfo" %>
<%@ page import="dport.RestServerService" %>
%{--Use RestServerService--}%
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:layoutResources/>

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
                            Remember: any changes you make on this page impact the whole server, and will therefore be felt by all the other users
                        </h2>
                    </div>

                </div>

                <div class="separator"></div>

                <g:form action='updateRestServer' method='POST' id='updateRestServer' class='form form-horizontal cssform' autocomplete='off'>
                <h4>Choose your backend REST server (<em>current server = <a href="${currentRestServer}">${currentRestServer}</a></em>)</h4>
                <div class="row clearfix">
                    <div class="col-md-2"></div>
                    <div class="col-md-7">
                        <div id="datatypes-form">
                            <div class="radio">
                                <label>
                                    <input id="testserver" type="radio" name="datatype" value="dev01behindloadbalancer"
                                        <%=restServer.getCurrentServer()==restServer.getDev01BehindLoadBalancer()?" checked ":"" %> />
                                    dev01 behind the load balancer (${restServer.getDev01BehindLoadBalancer()})
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input id="testserver" type="radio" name="datatype" value="dev02behindloadbalancer"
                                        <%=restServer.getCurrentServer()==restServer.getDev02BehindLoadBalancer()?" checked ":"" %> />
                                    dev02 behind the load balancer (${restServer.getDev02BehindLoadBalancer()})
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input id="testserver" type="radio" name="datatype" value="devloadbalancedserver"
                                        <%=restServer.getCurrentServer()==restServer.getDevLoadBalanced()?" checked ":"" %> />
                                    dev load balanced server(s) (${restServer.getDevLoadBalanced()})
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input id="qaserver" type="radio" name="datatype" value="qaloadbalancedserver"
                                        <%=restServer.getCurrentServer()==restServer.getQaLoadBalanced()?" checked ":"" %>  />
                                    qa load balanced server(s) (${restServer.getQaLoadBalanced()})
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input id="prodserver" type="radio" name="datatype" value="prodloadbalancedserver"
                                        <%=restServer.getCurrentServer()==restServer.getProdLoadBalanced()?" checked ":"" %>  />
                                    prod load balanced server(s) (${restServer.getProdLoadBalanced()})
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input id="newdevserver" type="radio" name="datatype" value="newdevserver"
                                        <%=restServer.getCurrentServer()==restServer.getNewdevserver()?" checked ":"" %> />
                                    new dev server (${restServer.getNewdevserver()})
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input id="prodserver" type="radio" name="datatype" value="prodserver"
                                        <%=restServer.getCurrentServer()==restServer.getProdserver()?" checked ":"" %>  />
                                    prod server (${restServer.getProdserver()})
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

                <g:form action='switchSigmaT2d' method='POST' class='form form-horizontal cssform' autocomplete='off'>
                    <h4>Choose your application(<em>current application = <strong>${currentApplicationIsSigma}</strong></em>)</h4>
                    <div class="row clearfix">
                        <div class="col-md-3"></div>
                        <div class="col-md-6">
                            <div id="application-form">


                                <div class="radio">
                                    <label>
                                        <input id="t2dgenes" type="radio" name="datatype" value="t2dgenes"  <%=(currentApplicationIsSigma=='t2dGenes')?'checked':''%> />
                                        T2D Genes
                                    </label>
                                </div>
                                <div class="radio">
                                    <label>
                                        <input id="sigma" type="radio" name="datatype" value="sigma" <%=(currentApplicationIsSigma=='Sigma')?'checked':''%> />
                                        Sigma
                                    </label>
                                </div>
                                <div class="radio">
                                    <label>
                                        <input id="beacon" type="radio" name="datatype" value="beacon"  <%=(currentApplicationIsSigma=='Beacon')?'checked':''%> />
                                        beacon
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
                <h4>Adjust help text presentation(<em>current Setting = <strong>${helpTextLevel}</strong></em>)</h4>
                <div class="row clearfix">
                    <div class="col-md-3"></div>
                    <div class="col-md-6">
                        <div id="help-text-form">


                            <div class="radio">
                                <label>
                                    <input id="noHelpText" type="radio" name="datatype" value="none"  <%=(helpTextLevel==0)?'checked':''%> />
                                    Never display help text
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input id="conditionalHelpText" type="radio" name="datatype" value="conditional" <%=(helpTextLevel==1)?'checked':''%> />
                                    Display help text question marks only if mapped to real text
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input id="allHelpText" type="radio" name="datatype" value="always"  <%=(helpTextLevel==2)?'checked':''%> />
                                    Display help text question marks unconditionally
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


            <g:form action='updateApiLevel' method='POST' class='form form-horizontal cssform' autocomplete='off'>
                <h4>We can use the new API whenever possible, or we can funnel everything through the old API</h4>
                <div class="row clearfix">
                    <div class="col-md-3"></div>
                    <div class="col-md-6">
                        <div id="alternate-api-form">


                            <div class="radio">
                                <label>
                                    <input id="newApi" type="radio" name="datatype" value="newApi"  <%=(newApi==true)?'checked':''%> />
                                    Use the new API whenever possible
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input id="oldApi" type="radio" name="datatype" value="oldApi" <%=(newApi==false)?'checked':''%> />
                                   Use our older API under all circumstances
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
                                <input class="btn btn-primary btn-lg" type='submit' id="submitAlternateApi"
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
                <h4>Which version should we draw the data from?</h4>
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
                <h4>We usually call the metadata once, cache that value, and then rely on</h4>
                <div class="row clearfix">
                    <div class="col-md-3"></div>
                    <div class="col-md-6">
                        <div id="metadata-Override-form">


                            <div class="radio">
                                <label>
                                    <input id="noOverrideIsNecessary" type="radio" name="datatype" value="forceIt"  <%=(forceMetadataCacheOverride==true)?'checked':''%> />
                                    A metadata cache override has been scheduled
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input id="overrideIsNecessary" type="radio" name="datatype" value="doNot" <%=(forceMetadataCacheOverride==false)?'checked':''%> />
                                    No metadata cache override has been scheduled
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
                <h4>Set warning text(<em>current Setting = <strong>${warningText}</strong></em>)</h4>
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
                            Logged with google?
                            <s2o:ifLoggedInWith provider="google">yes</s2o:ifLoggedInWith>
                            <s2o:ifNotLoggedInWith provider="google">no</s2o:ifNotLoggedInWith>
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

