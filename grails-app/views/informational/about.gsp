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
        <div class="static-content" portal="${g.portalTypeString()}" file="about_page.html">
            ${g.portalTypeString()}
        </div>
    </div>
</body>
</html>

