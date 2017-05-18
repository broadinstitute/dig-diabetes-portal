
%{--_t2dData.gsp defines the core structure of the data page.--}%
%{--It is dependent on _datasetsPageTenplate.gsp (dig-diabetes-portal/grails-app/views/widgets/_datasetsPageTemplate.gsp)--}%
%{--and datasets.css (dig-diabetes-portal/web-app/css/dport/datasets.css) and _t2DData.gsp (dig-diabetes-portal/grails-app/views/informational/data/_t2dData.gsp).--}%
%{--Portal resources are defined in portalResources.groovy--}%


<g:render template="../widgets/datasetsPageTemplate"/>

<script>
    $(document).ready(function(){
        var filterDatatype = "Show all";
        mpgSoftware.datasetsPage.displaySelectedTechnology(filterDatatype,undefined,"${createLink(controller:'informational',action: 'aboutTheDataAjax')}");
    });
</script>


