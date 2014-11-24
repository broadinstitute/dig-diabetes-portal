<%--
  Created by IntelliJ IDEA.
  User: ben
  Date: 8/23/2014
  Time: 5:09 PM
--%>
<%@ page import="temporary.BuildInfo" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>

<body>

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
                    <div class="col-md-3"></div>
                    <div class="col-md-6">
                        <div id="datatypes-form">


                                <div class="radio">
                                    <label>
                                        <input id="mySqlRestServer" type="radio" name="datatype" value="mysql" />
                                        my SQL Server
                                    </label>
                                </div>
                                %{--<div class="radio">--}%
                                    %{--<label>--}%
                                        %{--<input id="bigQueryRestServer" type="radio" name="datatype" value="bigquery" />--}%
                                        %{--New REST server (http://69.173.71.178:8080/dev/rest/server/)--}%
                                    %{--</label>--}%
                                %{--</div>--}%
                            <div class="radio">
                                <label>
                                    <input id="devserver" type="radio" name="datatype" value="devserver" />
                                    dev server (http://69.173.71.178:8080/dev/rest/server)
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input id="testserver" type="radio" name="datatype" value="testserver" />
                                    test server (http://69.173.70.52:8080/test/rest/server)
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input id="qaserver" type="radio" name="datatype" value="qaserver" />
                                    dev server (http://69.173.70.198:8080/qa/rest/server)
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input id="prodserver" type="radio" name="datatype" value="prodserver" />
                                    test server (http://69.173.71.179:8080/prod/rest/server)
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
                    <h4>Choose your application(<em>current application = <a href="${currentApplicationIsSigma}">${currentApplicationIsSigma}</a></em>)</h4>
                    <div class="row clearfix">
                        <div class="col-md-3"></div>
                        <div class="col-md-6">
                            <div id="application-form">


                                <div class="radio">
                                    <label>
                                        <input id="sigma" type="radio" name="datatype" value="sigma" />
                                        present Sigma
                                    </label>
                                </div>
                                <div class="radio">
                                    <label>
                                        <input id="t2dgenes" type="radio" name="datatype" value="t2dgenes" />
                                        present T2D Genes
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

                <div class="row clearfix" style="margin-top:20px; padding: 10px">

                    <div class="col-md-4">
                            <div style="border: 2px solid darkblue; padding: 10px">
                                <span style="font-decoration:underline"><em>Build information</em><br /></span>
                                Environment: ${grails.util.Environment.current.name}.<br />
                                Built by ${BuildInfo.buildWho}@${BuildInfo.buildHost}<br />
                                at ${BuildInfo.buildTime}.
                            </div>
                    </div>
                    <div class="col-md-8"></div>

                </div>



            </div>




        </div>
    </div>

</div>

</body>
</html>

