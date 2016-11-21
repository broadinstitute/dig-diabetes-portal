
<%@ page import="org.broadinstitute.mpg.Gene" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'gene.label', default: 'Gene')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-gene" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
        <g:form action="list" method="GET">
            Search: <input name="query" size="48" value="${params.query}"/>
            <g:submitButton name="search" class="btn btn-small" value="Search"/>
            <g:if test="${params.query}">
                <g:link class="btn btn-small" action="list">Reset</g:link>
            </g:if>
        </g:form>
		<div id="list-gene" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<g:sortableColumn property="name1" title="${message(code: 'gene.name1.label', default: 'Name1')}" />
					
						<g:sortableColumn property="name2" title="${message(code: 'gene.name2.label', default: 'Name2')}" />
					
						<g:sortableColumn property="chromosome" title="${message(code: 'gene.chromosome.label', default: 'Chromosome')}" />
					
						<g:sortableColumn property="addrEnd" title="${message(code: 'gene.addrEnd.label', default: 'Addr End')}" />
					
						<g:sortableColumn property="addrStart" title="${message(code: 'gene.addrStart.label', default: 'Addr Start')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${geneInstanceList}" status="i" var="geneInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${geneInstance.id}">${fieldValue(bean: geneInstance, field: "name1")}</g:link></td>
					
						<td>${fieldValue(bean: geneInstance, field: "name2")}</td>
					
						<td>${fieldValue(bean: geneInstance, field: "chromosome")}</td>
					
						<td>${fieldValue(bean: geneInstance, field: "addrEnd")}</td>
					
						<td>${fieldValue(bean: geneInstance, field: "addrStart")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${geneInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
