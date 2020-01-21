<!DOCTYPE html>
<html>
<head>
  <meta name="layout" content="t2dGenesCore"/>
  <r:require module="variantTable"/>


  <r:layoutResources/>
  <%@ page import="org.broadinstitute.mpg.RestServerService" %>

  <g:set var="restServer" bean="restServerService"/>
  <script>
  $( document ).ready(function() {
    mpgSoftware.variantTableInitializer.variantTableConfiguration();

  });
  </script>

</head>

<body>
<div id="mainVariantDivHolder">

</div>
<g:render template="/templates/dynamicUi/varFocus/VARIANT_TABLE" />
<g:render template="/templates/dynamicUi/varFocus/variantTable" />

</body>
</html>

