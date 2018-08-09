<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="media"/>
    %{--<r:require modules="portalHome"/>--}%
    <r:layoutResources/>
    <style>
    a.media {
        display: block;
    }

    div.media {
        font-size: small;
        margin: 25px;
        margin: auto
    }

    div.media div {
        font-style: italic;
        color: #888;
    }

    ul.tutorial {
        padding: 0;
        margin-left: -10px;
    }

    ul.tutorial li {
        display: inline;
        font-size: 1.5em;
        padding-right: 15px;
        margin-left: 10px;
        border-right: 1px solid #ccc;
    }

    ul.tutorial li:last-child {
        border-right: 0px;
    }

    ul.tutorial li a, ul.tutorial li a:hover {
        text-decoration: none;
    }
    </style>
</head>

<body>

<div class="static-content" portal="${g.portalTypeString()}" file="resource_page.html">
    ${g.portalTypeString()}
</div>

</body>
</html>
