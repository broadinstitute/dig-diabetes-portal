<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="informational"/>
    <r:layoutResources/>

    <style>

    </style>
</head>


<body>

<div id="main">
<div class="static-content" portal="${g.portalTypeString()}" file="contact_page.html">
    ${g.portalTypeString()}
</div>
    <script>
        mpgSoftware.informational.buttonManager (".buttonHolder .nav li",
                "${createLink(controller:'informational',action:'contactsection')}",
                "#contactContent");
    </script>

</div>

</body>
</html>

