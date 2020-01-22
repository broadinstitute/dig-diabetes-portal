<%--
  Created by IntelliJ IDEA.
  User: balexand
  Date: 1/22/2020
  Time: 9:36 AM
--%>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require module="genomeBrowser"/>

    <r:layoutResources/>


</head>

<body>

<div id="mainVariantDivHolder">
</div>

<div id="igv-div">

</div>
<g:render template="/genomeBrowser/igv" />

</body>
</html>