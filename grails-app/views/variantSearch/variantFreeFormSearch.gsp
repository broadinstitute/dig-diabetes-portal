<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="geneInfo"/>
    <r:layoutResources/>
    <%@ page import="org.broadinstitute.mpg.RestServerService" %>

    <link type="application/font-woff">
    <link type="application/vnd.ms-fontobject">
    <link type="application/x-font-ttf">
    <link type="font/opentype">

    <link href="http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" type="text/css"
          rel="stylesheet">
    <link href="http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" type="text/css"
          rel="stylesheet">

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="//oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="//oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <!-- Bootstrap -->
    <g:javascript src="lib/igv/vendor/inflate.js"/>
    <g:javascript src="lib/igv/vendor/zlib_and_gzip.min.js"/>

    <!-- IGV js  and css code -->
    <link href="http://www.broadinstitute.org/igvdata/t2d/igv.css" type="text/css" rel="stylesheet">
    %{--<g:javascript base="http://iwww.broadinstitute.org/" src="/igvdata/t2d/igv-all.js" />--}%
    <g:javascript base="http://www.broadinstitute.org/" src="/igvdata/t2d/igv-all.min.js"/>
    <g:set var="restServer" bean="restServerService"/>
</head>
<body>



<div id="main">

    <div class="container">

        <div class="row clearfix">
            <div class="col-md-12">
                <g:message code="variantSearch.freeForm.label.getDataPayload"/>:<br/> ${getDataPayload}
                <hr/>
            </div>
        </div>

        <div class="row clearfix">
            <div class="col-md-12">
                <g:message code="variantSearch.freeForm.label.getDataResult"/>:<br/> ${getDataResult}
                <hr/>
            </div>
        </div>

        <div class="row clearfix">
            <div class="col-md-12">
                <strong><g:message code="variantSearch.freeForm.message.properties"/></strong>
                <hr/>
            </div>
        </div>

        <div class="row clearfix">
            <div class="col-md-12">
                <div class="row clearfix">
                    <form method=""post>

                        <div class="col-md-3">
                            <strong><g:message code="variantSearch.freeForm.label.properties.common"/></strong><br/>
                            <g:render template='propertiesOptionList' model="[propertyList: cPropertyList]"/>
                            <input type="submit"/>
                        </div>
                        <div class="col-md-3">
                            <strong><g:message code="variantSearch.freeForm.label.properties.sample"/></strong><br/>
                            <g:render template="propertiesOptionList" model="[propertyList: dPropertyList]"/>
                        </div>
                        <div class="col-md-3">
                            <strong><g:message code="variantSearch.freeForm.label.properties.phenotype"/></strong><br/>
                            <g:render template="propertiesOptionList" model="[propertyList: pPropertyList]"/>
                        </div>
                        <div class="col-md-3">
                            <strong><g:message code="variantSearch.freeForm.label.properties.filter"/></strong><br/>
                            <g:render template="propertiesOptionList" model="[propertyList: filterPropertyList, isFilter: true]"/>
                        </div>
                    </form>

                </div>

            </div>
        </div>
    </div>

</div>


</body>
</html>
