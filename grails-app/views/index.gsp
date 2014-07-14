<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title>Welcome to Grails</title>



        %{--the part I added starts below--}%
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${vars.titleString}</title>

        %{--<link rel='stylesheet' type='text/css' href='{% static "css/bootstrap.min.css" %}' />--}%
        %{--<link rel='stylesheet' type='text/css' href='{% static "css/jquery.dataTables.css" %}' />--}%
        %{--<link rel='stylesheet' type='text/css' href='{% static "css/style.css" %}' />--}%

        %{--<!-- Javascript templates -->--}%
        %{--<script type="text/javascript" src="{% static "js/utils.js" %}"></script>--}%
        %{--<script type="text/javascript">--}%
        %{--var CONSTANTS = {{ constants_json|safe }};--}%
        %{--var SITE_VERSION = "{{ SITE_VERSION }}";--}%
    %{--</script>--}%
        %{--<script type="text/template" id="tpl-gene-info">{% include "js_templates/gene_info.html" %}</script>--}%
        %{--<script type="text/template" id="tpl-gene-variants">{% include "js_templates/gene_variants.html" %}</script>--}%
        %{--<script type="text/template" id="tpl-variant-info">{% include "js_templates/variant_info.html" %}</script>--}%
        %{--<script type="text/template" id="tpl-variant-gwas">{% include "js_templates/variant_gwas.html" %}</script>--}%
        %{--<script type="text/template" id="tpl-variant-table">{% include "js_templates/variant_table.html" %}</script>--}%
        %{--<script type="text/template" id="tpl-variant-search">{% include "js_templates/variant_search.html" %}</script>--}%
        %{--<script type="text/template" id="tpl-variant-search-results">{% include "js_templates/variant_search_results.html" %}</script>--}%
        %{--<script type="text/template" id="tpl-trait-search-results">{% include "js_templates/trait_search_results.html" %}</script>--}%
        %{--<script type="text/template" id="tpl-region-gwas">{% include "js_templates/region_gwas.html" %}</script>--}%

        %{--<script type='text/javascript' src='{% static "js/jquery-1.11.0.min.js" %}'></script>--}%
        %{--<script type='text/javascript' src='{% static "js/bootstrap.min.js" %}'></script>--}%
        %{--<script type='text/javascript' src='{% static "js/bootstrap3-typeahead.min.js" %}'></script>--}%
        %{--<script type="text/javascript" src='{% static "js/jquery.dataTables.min.js" %}'></script>--}%
        %{--<script type='text/javascript' src='{% static "js/underscore-min.js" %}'></script>--}%
        %{--<script type='text/javascript' src='{% static "js/backbone-min.js" %}'></script>--}%
        %{--<script type='text/javascript' src='{% static "js/shared.js" %}'></script>--}%
        %{--<script src="http://d3js.org/d3.v3.js"></script>--}%

        %{--<link href='http://fonts.googleapis.com/css?family=Lato:300,400,700,900,300italic,400italic,700italic,900italic' rel='stylesheet' type='text/css'>--}%

        %{--<script type="text/javascript">--}%
            %{--window.analytics=window.analytics||[],window.analytics.methods=["identify","group","track","page","pageview","alias","ready","on","once","off","trackLink","trackForm","trackClick","trackSubmit"],window.analytics.factory=function(t){return function(){var a=Array.prototype.slice.call(arguments);return a.unshift(t),window.analytics.push(a),window.analytics}};for(var i=0;i<window.analytics.methods.length;i++){var key=window.analytics.methods[i];window.analytics[key]=window.analytics.factory(key)}window.analytics.load=function(t){if(!document.getElementById("analytics-js")){var a=document.createElement("script");a.type="text/javascript",a.id="analytics-js",a.async=!0,a.src=("https:"===document.location.protocol?"https://":"http://")+"cdn.segment.io/analytics.js/v1/"+t+"/analytics.min.js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(a,n)}},window.analytics.SNIPPET_VERSION="2.0.9",--}%
                    %{--window.analytics.load("x5tkud1kd0");--}%
            %{--window.analytics.page();--}%
        %{--</script>--}%








        %{--<style type="text/css" media="screen">--}%
			%{--#status {--}%
				%{--background-color: #eee;--}%
				%{--border: .2em solid #fff;--}%
				%{--margin: 2em 2em 1em;--}%
				%{--padding: 1em;--}%
				%{--width: 12em;--}%
				%{--float: left;--}%
				%{---moz-box-shadow: 0px 0px 1.25em #ccc;--}%
				%{---webkit-box-shadow: 0px 0px 1.25em #ccc;--}%
				%{--box-shadow: 0px 0px 1.25em #ccc;--}%
				%{---moz-border-radius: 0.6em;--}%
				%{---webkit-border-radius: 0.6em;--}%
				%{--border-radius: 0.6em;--}%
			%{--}--}%

			%{--.ie6 #status {--}%
				%{--display: inline; /* float double margin fix http://www.positioniseverything.net/explorer/doubled-margin.html */--}%
			%{--}--}%

			%{--#status ul {--}%
				%{--font-size: 0.9em;--}%
				%{--list-style-type: none;--}%
				%{--margin-bottom: 0.6em;--}%
				%{--padding: 0;--}%
			%{--}--}%

			%{--#status li {--}%
				%{--line-height: 1.3;--}%
			%{--}--}%

			%{--#status h1 {--}%
				%{--text-transform: uppercase;--}%
				%{--font-size: 1.1em;--}%
				%{--margin: 0 0 0.3em;--}%
			%{--}--}%

			%{--#page-body {--}%
				%{--margin: 2em 1em 1.25em 18em;--}%
			%{--}--}%

			%{--h2 {--}%
				%{--margin-top: 1em;--}%
				%{--margin-bottom: 0.3em;--}%
				%{--font-size: 1em;--}%
			%{--}--}%

			%{--p {--}%
				%{--line-height: 1.5;--}%
				%{--margin: 0.25em 0;--}%
			%{--}--}%

			%{--#controller-list ul {--}%
				%{--list-style-position: inside;--}%
			%{--}--}%

			%{--#controller-list li {--}%
				%{--line-height: 1.3;--}%
				%{--list-style-position: inside;--}%
				%{--margin: 0.25em 0;--}%
			%{--}--}%

			%{--@media screen and (max-width: 480px) {--}%
				%{--#status {--}%
					%{--display: none;--}%
				%{--}--}%

				%{--#page-body {--}%
					%{--margin: 0 1em 1em;--}%
				%{--}--}%

				%{--#page-body h1 {--}%
					%{--margin-top: 0;--}%
				%{--}--}%
			%{--}--}%
		%{--</style>--}%
	</head>
	<body>
    <h1>{$vars.titleString}</h1>
		%{--<a href="#page-body" class="skip"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>--}%
		%{--<div id="status" role="complementary">--}%
			%{--<h1>Application Status</h1>--}%
			%{--<ul>--}%
				%{--<li>App version: <g:meta name="app.version"/></li>--}%
				%{--<li>Grails version: <g:meta name="app.grails.version"/></li>--}%
				%{--<li>Groovy version: ${GroovySystem.getVersion()}</li>--}%
				%{--<li>JVM version: ${System.getProperty('java.version')}</li>--}%
				%{--<li>Reloading active: ${grails.util.Environment.reloadingAgentEnabled}</li>--}%
				%{--<li>Controllers: ${grailsApplication.controllerClasses.size()}</li>--}%
				%{--<li>Domains: ${grailsApplication.domainClasses.size()}</li>--}%
				%{--<li>Services: ${grailsApplication.serviceClasses.size()}</li>--}%
				%{--<li>Tag Libraries: ${grailsApplication.tagLibClasses.size()}</li>--}%
			%{--</ul>--}%
			%{--<h1>Installed Plugins</h1>--}%
			%{--<ul>--}%
				%{--<g:each var="plugin" in="${applicationContext.getBean('pluginManager').allPlugins}">--}%
					%{--<li>${plugin.name} - ${plugin.version}</li>--}%
				%{--</g:each>--}%
			%{--</ul>--}%
		%{--</div>--}%
		%{--<div id="page-body" role="main">--}%
			%{--<h1>Welcome to Grails</h1>--}%
			%{--<p>Congratulations, you have successfully started your first Grails application! At the moment--}%
			   %{--this is the default page, feel free to modify it to either redirect to a controller or display whatever--}%
			   %{--content you may choose. Below is a list of controllers that are currently deployed in this application,--}%
			   %{--click on each to execute its default action:</p>--}%

			%{--<div id="controller-list" role="navigation">--}%
				%{--<h2>Available Controllers:</h2>--}%
				%{--<ul>--}%
					%{--<g:each var="c" in="${grailsApplication.controllerClasses.sort { it.fullName } }">--}%
						%{--<li class="controller"><g:link controller="${c.logicalPropertyName}">${c.fullName}</g:link></li>--}%
					%{--</g:each>--}%
				%{--</ul>--}%
			%{--</div>--}%
		%{--</div>--}%
	</body>
</html>
