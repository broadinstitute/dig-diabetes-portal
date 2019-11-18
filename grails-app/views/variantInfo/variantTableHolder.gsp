<!DOCTYPE html>
<html>
<head>
  <meta name="layout" content="t2dGenesCore"/>
  <r:require module="variantTable"/>


  <r:layoutResources/>
  <%@ page import="org.broadinstitute.mpg.RestServerService" %>

  <g:set var="restServer" bean="restServerService"/>


</head>

<body>


<g:render template="variantTable" />

</body>
</html>