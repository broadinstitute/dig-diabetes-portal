<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require module="tissueTable"/>
    

    <r:layoutResources/>
    <%@ page import="org.broadinstitute.mpg.RestServerService" %>

    <g:set var="restServer" bean="restServerService"/>


</head>

<body>


<g:render template="tissueTable" />

</body>
</html>
