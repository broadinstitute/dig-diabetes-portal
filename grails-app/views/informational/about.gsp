<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="informational"/>
    <r:layoutResources/>

    <style>
    #main > div {
        width: 90%;
        margin: auto;
    }
    </style>
</head>


<body>

<div id="main">
    <g:if test="${g.portalTypeString()?.equals('t2d')}">
<g:render template="./about_t2d"/>


    </g:if>

    <g:else>
        <g:render template="./about_stroke"/>

    </g:else>
</div>

</body>
</html>

