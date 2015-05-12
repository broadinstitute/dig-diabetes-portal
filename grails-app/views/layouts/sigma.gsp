<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <link href='http://fonts.googleapis.com/css?family=Lato:100,300,400' rel='stylesheet' type='text/css'>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <r:require modules="core"/>
    <r:require modules="sigma"/>
    <r:layoutResources/>
    <title>Sigma T2D</title>
    <g:layoutHead/>
</head>

<body>
    <div class="container-fluid" style="padding:0;">
        <div>
            <g:render template="sigma-notices"/>
        </div>
        <div><g:render template="sigma-header"/></div>
        <g:layoutBody/>
    </div>
</body>
</html>