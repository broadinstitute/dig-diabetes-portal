<%--
  Created by IntelliJ IDEA.
  User: balexand
  Date: 7/12/2017
  Time: 2:33 PM
--%>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core,mustache"/>
    <r:layoutResources/>

    <link type="application/font-woff">
    <link type="application/vnd.ms-fontobject">
    <link type="application/x-font-ttf">
    <link type="font/opentype">

    <style>
        .regionParams {
            font-size: 16px;
        }
    </style>

</head>

<body>
<div id="rSpinner" class="dk-loading-wheel center-block" style="display: none">
    <img src="${resource(dir: 'images', file: 'ajax-loader.gif')}" alt="Loading"/>
</div>

<div id="main">

    <div class="container">
        <g:render template="regionHdr" />
    </div>
</div>

</div>
</body>
</html>
