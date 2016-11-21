
<%@ page import="org.broadinstitute.mpg.Gene" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'gene.label', default: 'Gene')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-gene" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-gene" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list gene">
			
				<g:if test="${geneInstance?.name1}">
				<li class="fieldcontain">
					<span id="name1-label" class="property-label"><g:message code="gene.name1.label" default="Name1" /></span>
					
						<span class="property-value" aria-labelledby="name1-label"><g:fieldValue bean="${geneInstance}" field="name1"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${geneInstance?.name2}">
				<li class="fieldcontain">
					<span id="name2-label" class="property-label"><g:message code="gene.name2.label" default="Name2" /></span>
					
						<span class="property-value" aria-labelledby="name2-label"><g:fieldValue bean="${geneInstance}" field="name2"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${geneInstance?.chromosome}">
				<li class="fieldcontain">
					<span id="chromosome-label" class="property-label"><g:message code="gene.chromosome.label" default="Chromosome" /></span>
					
						<span class="property-value" aria-labelledby="chromosome-label"><g:fieldValue bean="${geneInstance}" field="chromosome"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${geneInstance?.addrEnd}">
				<li class="fieldcontain">
					<span id="addrEnd-label" class="property-label"><g:message code="gene.addrEnd.label" default="Addr End" /></span>
					
						<span class="property-value" aria-labelledby="addrEnd-label"><g:fieldValue bean="${geneInstance}" field="addrEnd"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${geneInstance?.addrStart}">
				<li class="fieldcontain">
					<span id="addrStart-label" class="property-label"><g:message code="gene.addrStart.label" default="Addr Start" /></span>
					
						<span class="property-value" aria-labelledby="addrStart-label"><g:fieldValue bean="${geneInstance}" field="addrStart"/></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form url="[resource:geneInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${geneInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
