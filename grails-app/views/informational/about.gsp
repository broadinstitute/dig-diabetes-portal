<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="informational"/>
    <r:layoutResources/>

    <style>
    #main > div {
        margin: auto;
    }
    </style>
</head>


<body>

<div id="main">
    <g:if test="${g.portalTypeString()?.equals('t2d')}">
        <g:render template="./about_t2d"/>
    </g:if>
    <g:elseif test="${g.portalTypeString()?.equals('mi')}">
        <g:render template="./about_mi"/>
    </g:elseif>
    <g:elseif test="${g.portalTypeString()?.equals('epilepsy')}">
        <g:render template="./about_epilepsy"/>
    </g:elseif>
    <g:elseif test="${g.portalTypeString()?.equals('sleep')}">
        <g:render template="./about_sleep"/>
    </g:elseif>
    <g:elseif test="${g.portalTypeString()?.equals('als')}">
        <g:render template="./about_ALS"/>
    </g:elseif>
    <g:else>
        <g:render template="./about_stroke"/>
    </g:else>
</div>

</body>
</html>

