<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core,sunburst"/>
    <r:require modules="informational"/>
    <r:layoutResources/>

</head>

<body>
    <div id="main">
        <div class="container static-content" portal="${g.portalTypeString()}" file="download_page.html">
            ${g.portalTypeString()}
        </div>
    </div>
</body>
</html>