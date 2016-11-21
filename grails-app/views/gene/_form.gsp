<%@ page import="org.broadinstitute.mpg.Gene" %>



<div class="fieldcontain ${hasErrors(bean: geneInstance, field: 'name1', 'error')} required">
	<label for="name1">
		<g:message code="gene.name1.label" default="Name1" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name1" required="" value="${geneInstance?.name1}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: geneInstance, field: 'name2', 'error')} required">
	<label for="name2">
		<g:message code="gene.name2.label" default="Name2" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name2" required="" value="${geneInstance?.name2}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: geneInstance, field: 'chromosome', 'error')} required">
	<label for="chromosome">
		<g:message code="gene.chromosome.label" default="Chromosome" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="chromosome" required="" value="${geneInstance?.chromosome}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: geneInstance, field: 'addrEnd', 'error')} required">
	<label for="addrEnd">
		<g:message code="gene.addrEnd.label" default="Addr End" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="addrEnd" type="number" value="${geneInstance.addrEnd}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: geneInstance, field: 'addrStart', 'error')} required">
	<label for="addrStart">
		<g:message code="gene.addrStart.label" default="Addr Start" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="addrStart" type="number" value="${geneInstance.addrStart}" required=""/>

</div>

