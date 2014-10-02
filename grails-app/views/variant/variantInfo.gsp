<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:require modules="variantInfo"/>
    <r:layoutResources/>
    <%@ page import="dport.RestServerService" %>
    <%
        RestServerService   restServerService = grailsApplication.classLoader.loadClass('dport.RestServerService').newInstance()
    %>
    <style>
.parentsFont {
    font-family: inherit;
    font-weight: inherit;
    font-size: inherit;
}
    </style>
</head>

<body>

<script>
    var variant;
    var loading = $('#spinner').show();
    $.ajax({
        cache:false,
        type:"get",
        url:"../variantAjax/"+"<%=variantToSearch%>",
        async:true,
        success: function (data) {
            fillTheFields(data,
                    "<%=variantToSearch%>",
                    "<g:createLink controller='trait' action='traitInfo' />") ;
            loading.hide();
        },
        error: function(jqXHR, exception) {
            loading.hide();
            core.errorReporter(jqXHR, exception) ;
        }
    });
</script>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >


                <h1>
                    <strong><span id="variantTitle" class="parentsFont"></span></strong>
                    <a class="page-nav-link" href="#associations">Associations</a>
                    <a class="page-nav-link" href="#populations">Populations</a>
                    <a class="page-nav-link" href="#biology">Biology</a>
                </h1>

                <g:render template="variantPageHeader" />

                <g:render template="variantAssociationStatistics" />

                <g:render template="howCommonIsVariant" />

                <g:render template="carrierStatusImpact" />

                <g:render template="effectOfVariantOnProtein" />

                <g:render template="findOutMore" />

            </div>

        </div>
    </div>

</div>

</body>
</html>

