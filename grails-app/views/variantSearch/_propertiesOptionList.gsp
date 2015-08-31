<g:each var="property" in="${propertyList}">
    <g:if test="${isFilter}">
        <input type="checkbox" name="filterProperty" value="${property.id}">(${property.name}) - ${property.parent?.name}<br/>
    </g:if>
    <g:else>
        <input type="checkbox" name="queryProperty" value="${property.id}">(${property.name}) ${(property?.parent?.parent ? "- " + property.parent?.name : "")} <br/>
    </g:else>
</g:each>
