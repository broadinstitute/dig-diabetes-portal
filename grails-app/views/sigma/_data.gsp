<div class="sigma-detail">
    <h4>
        <g:message code="sigmasite.data.intro"></g:message>
    </h4>

    <div class="sectionBuffer" style="padding: 0 25px 10px 25px">
        <div>
            <h2><a  class="standardLinks" href="${createLink(controller:'home',action:'provideTutorial')}"><g:message code="portal.introTutorial.title"/></a></h2>
        </div>

    </div>

    <h4 class="sigma-data-detail-section-header">
        <g:message code="sigmasite.data.cohorts.header"></g:message>
    </h4>

    <h4>
        <g:message code="sigmasite.data.cohorts"></g:message>
    </h4>

    <h4 class="sigma-data-detail-section-header">
        <g:message code="sigmasite.data.exomes.cohort.breakdown"></g:message>
    </h4>

    <img src="${resource(dir: 'images', file: 'SIGMA exomes table.png')}" alt="SIGMA exomes summary table" style="width:100%;"/>

    <h4 class="sigma-data-detail-section-header">
        <g:message code="sigmasite.data.gwas.cohort.breakdown"></g:message>
    </h4>

    <img src="${resource(dir: 'images', file: 'SIGMA GWAS table.png')}" alt="SIGMA gwas summary table" style="width:100%;"/>
</div>