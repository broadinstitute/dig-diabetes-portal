<g:if test="${show_exseq}">



    <a name="populations"></a>

    <p>
        <g:message code="gene.continentalancestry.subtitle" default="click on a number to view variants"/>
    </p>

    <table id="continentalVariation" class="table table-striped  distinctivetable distinctive">
        <thead>
        <tr>
            <th><g:message code="gene.continentalancestry.title.colhdr.1" default="ancestry"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.2" default="data type"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.3" default="participants"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.4" default="total variants"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.5" default="common"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.6" default="low frequency"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.7" default="rare"/></th>
        </tr>
        </thead>
        <tbody id="continentalVariationTableBody">
        </tbody>
        </table>

</g:if>