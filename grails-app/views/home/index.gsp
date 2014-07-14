<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Welcome to Grails</title>



    %{--the part I added starts below--}%
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${vars.titleString}</title>

    <link media="all" rel="stylesheet" href="css/lib/bootstrap.min.css">
    <link media="all" rel="stylesheet" href="css/lib/jquery.dataTables.css">
    <link media="all" rel="stylesheet" href="css/lib/style.css">


    <script src="js/lib/utils.js"></script>
    <script src="js/lib/jquery-1.11.0.min.js"></script>
    <script src="js/lib/bootstrap.min.js"></script>
    <script src="js/lib/bootstrap3-typeahead.min.js"></script>
    <script src="js/lib/jquery.dataTables.min.js"></script>
    <script src="js/lib/underscore-min.js"></script>
    <script src="js/lib/backbone-min.js"></script>
    <script src="js/lib/shared.js"></script>


    %{--<script type="text/template" id="tpl-gene-info">{% include "js_templates/gene_info.html" %}</script>--}%
    %{--<script type="text/template" id="tpl-gene-variants">{% include "js_templates/gene_variants.html" %}</script>--}%
    %{--<script type="text/template" id="tpl-variant-info">{% include "js_templates/variant_info.html" %}</script>--}%
    %{--<script type="text/template" id="tpl-variant-gwas">{% include "js_templates/variant_gwas.html" %}</script>--}%
    %{--<script type="text/template" id="tpl-variant-table">{% include "js_templates/variant_table.html" %}</script>--}%
    %{--<script type="text/template" id="tpl-variant-search">{% include "js_templates/variant_search.html" %}</script>--}%
    %{--<script type="text/template" id="tpl-variant-search-results">{% include "js_templates/variant_search_results.html" %}</script>--}%
    %{--<script type="text/template" id="tpl-trait-search-results">{% include "js_templates/trait_search_results.html" %}</script>--}%
    %{--<script type="text/template" id="tpl-region-gwas">{% include "js_templates/region_gwas.html" %}</script>--}%

    <script src="http://d3js.org/d3.v3.js"></script>

    <link href='http://fonts.googleapis.com/css?family=Lato:300,400,700,900,300italic,400italic,700italic,900italic' rel='stylesheet' type='text/css'>

</head>
<body>
<h1>${vars.titleString}</h1>
<div id="header">
    <div id="header-top">
        <div class="container">
            <g:if test="${vars.siteVersion == 'sigma'}">

            <div id="language">
                <form id="language-es" action="/i18n/setlang/" method="post">
                    %{--{% csrf_token %}--}%
                    <input type="hidden" name="language" value="es" />
                </form>
                <form id="language-en-us" action="/i18n/setlang/" method="post">
                    %{--{% csrf_token %}--}%
                    <input type="hidden" name="language" value="en" />
                </form>
                <a href="#" onclick="document.getElementById('language-es').submit();">
                    <img class="{% if LANGUAGE_CODE == 'es' %}currentlanguage{% endif %}"
                         src="{% static "images/Mexico.png" %}" alt="Mexico" />
                </a>
                <a href="#" onclick="document.getElementById('language-en-us').submit();">
                    <img class="{% if LANGUAGE_CODE == 'en' %}currentlanguage{% endif %}"
                         src="{% static "images/United-States.png" %}" alt="USA" />
                </a>
            </div>
            <div id="branding">
                SIGMA <strong>T2D</strong> <small>
                %{--{% trans "a resource on the genetics of type 2 diabetes in Mexico" %}--}%
            </small>
            </div>
            </g:if>
            <g:elseif test="${vars.siteVersion == 't2dgenes'}">
            <div id="branding">
                Type 2 Diabetes <strong>Genetics</strong> <small>Beta</small>
            </div>
            </g:elseif>
        </div>
    </div>
    <div id="header-bottom">
        <div class="container">
            %{--{% if user.is_authenticated %}--}%
            <div class="rightlinks">
                %{--{{ user.profile }} --}%  myname &middot;
                <a href="/logout">{% trans "Log Out" %}</a>
            </div>
            %{--{% endif %}--}%
             <g:if test="${vars.siteVersion == 't2dgenes'}">
            <a href="/">Home</a> &middot;
            <a href="/about">About The Data</a> &middot;
            <a href="/contact">Contact</a>
            </g:if>
            <g:elseif test="${vars.siteVersion == 'sigma'}">
            <a href="/query">{% trans "Query" %}</a> &middot;
            <a href="/">{% trans "About" %}</a> &middot;
            <a href="/contact">{% trans "Contact" %}</a>
            </g:elseif>
        </div>
    </div>
</div>
<div id="main">
    %{--{% block content %}{% endblock %}--}%
    here is where the content goes
</div>
<div id="footer">
    <div class="container">
        <div class="separator"></div>
        <div id="helpus"><a href="/contact">{% trans "Send feedback" %}</a></div>
    </div>
</div>
<div id="belowfooter"></div>

</body>
</html>
