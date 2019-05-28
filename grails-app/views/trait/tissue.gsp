<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require module="tissueTable"/>
    %{--<r:require modules="higlass"/>--}%

    %{--Need to call directly or else the images don't come out right--}%
    <link rel="stylesheet" type="text/css"  href="../../css/lib/locuszoom.css">
    %{--<script type="text/javascript" src="../../js/lib/gnomadt2d.js"></script>--}%
    <r:layoutResources/>
    <%@ page import="org.broadinstitute.mpg.RestServerService" %>

    <g:set var="restServer" bean="restServerService"/>


</head>

<body>


<g:render template="tissueTable" />

</body>
</html>
