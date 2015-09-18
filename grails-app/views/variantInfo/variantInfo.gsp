<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="variantInfo"/>
    <r:require modules="tableViewer,traitInfo"/>
    <r:layoutResources/>
    <%@ page import="dport.RestServerService" %>
    <%
        RestServerService restServerService = grailsApplication.classLoader.loadClass('dport.RestServerService').newInstance()
    %>
    <style>
    .parentsFont {
        font-family: inherit;
        font-weight: inherit;
        font-size: inherit;
    }
    </style>


    <link type="application/font-woff">
    <link type="application/vnd.ms-fontobject">
    <link type="application/x-font-ttf">
    <link type="font/opentype">

    <link href="http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" type="text/css"
          rel="stylesheet">

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="//oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="//oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <!-- Bootstrap -->
    <g:javascript src="lib/igv/vendor/inflate.js"/>
    <g:javascript src="lib/igv/vendor/zlib_and_gzip.min.js"/>

    <!-- IGV js  and css code -->
    <link href="http://www.broadinstitute.org/igvdata/t2d/igv.css" type="text/css" rel="stylesheet">
    <g:javascript base="http://www.broadinstitute.org/" src="/igvdata/t2d/igv-all.min.js"/>
    <g:set var="restServer" bean="restServerService"/>





</head>

<body>

<script>
    var variant;
    var loading = $('#spinner').show();
    $.ajax({
        cache: false,
        type: "get",
        url: "../variantAjax/" + "<%=variantToSearch%>",
        async: true,
        success: function (data) {
            if ( typeof data !== 'undefined')  {
                mpgSoftware.variantInfo.fillTheFields(data,
                        "<%=variantToSearch%>",
                        "<g:createLink controller='trait' action='traitInfo' />",
                        "${restServer.currentRestServer()}");
            }
            $(".pop-top").popover({placement : 'top'});
            $(".pop-right").popover({placement : 'right'});
            $(".pop-bottom").popover({placement : 'bottom'});
            $(".pop-left").popover({ placement : 'left'});
            $(".pop-auto").popover({ placement : 'auto'});
            loading.hide();
        },
        error: function (jqXHR, exception) {
            loading.hide();
            core.errorReporter(jqXHR, exception);
        }
    });
</script>


<div id="main">

    <div class="container">

        <div class="variant-info-container">
            <div class="variant-info-view">

                <h1>
                    <strong><span id="variantTitle" class="parentsFont"></span></strong>
                </h1>

                <g:render template="variantPageHeader"/>

                <div class="accordion" id="accordionVariant">
                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse"
                               data-parent="#accordionVariant"
                               href="#collapseVariantAssociationStatistics">
                                <h2><strong><g:message code="variant.variantAssociationStatistics.title" default="Is variant associated with T2D"/></strong></h2>
                            </a>
                        </div>

                        <div id="collapseVariantAssociationStatistics" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="variantAssociationStatistics"/>
                            </div>
                        </div>
                    </div>

                <div class="separator"></div>
                <g:render template="/widgets/associatedStatisticsTraitsPerVariant" model="['variantIdentifier': variantToSearch]"/>

<g:if test="${show_exseq}">

    <div class="separator"></div>

    <div class="accordion-group">
        <div class="accordion-heading">
            <a class="accordion-toggle  collapsed" data-toggle="collapse"
               data-parent="#accordionVariant"
               href="#collapseDiseaseRisk">
                <h2><strong><g:message code="variant.diseaseRisk.title" default="How does carrier status impact risk"/></strong></h2>
            </a>
        </div>

        <g:render template="diseaseRisk"/>

    </div>

</g:if>

<g:if test="${show_exseq}">

      <div class="separator"></div>

    <div class="accordion-group">
        <div class="accordion-heading">
            <a class="accordion-toggle  collapsed" data-toggle="collapse"
               data-parent="#accordionVariant"
               href="#collapseHowCommonIsVariant">
                <h2><strong><g:message code="variant.howCommonIsVariant.title" default="How common is variant"/></strong></h2>
            </a>
        </div>

        <g:render template="howCommonIsVariant"/>

    </div>

</g:if>
<g:if test="${show_exseq}">

    <div class="separator"></div>

    <div class="accordion-group">
        <div class="accordion-heading">
            <a class="accordion-toggle  collapsed" data-toggle="collapse"
               data-parent="#accordionVariant"
               href="#collapseCarrierStatusImpact">
                <h2><strong><g:message code="variant.carrierStatusImpact.title" default="How many carriers in the data set"/></strong></h2>
            </a>
        </div>

        <g:render template="carrierStatusImpact"/>

    </div>

</g:if>
                    <div class="separator"></div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse"
                               data-parent="#accordionVariant"
                               href="#collapseAffectOfVariantOnProtein">
                                <h2><strong><g:message code="variant.effectOfVariantOnProtein.title" default="What is the effect of this variant on the associated protein"/></strong></h2>
                            </a>
                        </div>

                        <div id="collapseAffectOfVariantOnProtein" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="effectOfVariantOnProtein"/>
                            </div>
                        </div>

                    </div>


                    <div class="separator"></div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordionVariant"
                               href="#collapseIgv">
                                <h2><strong><g:message code="variant.igvBrowser.title" default="Explorer with IGV"/></strong></h2>
                            </a>
                        </div>

                        <div id="collapseIgv" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="igvBrowser"/>
                            </div>
                        </div>
                    </div>

                <div class="separator"></div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse"
                               data-parent="#accordionVariant"
                               href="#collapseFindOutMore">
                                <h2><strong><g:message code="variant.findOutMore.title" default="find out more"/></strong></h2>
                            </a>
                        </div>

                        <div id="collapseFindOutMore" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="findOutMore"/>
                            </div>
                        </div>
                    </div>

                </div>

            </div>

        </div>
    </div>

</div>
<script>
    $('#accordionVariant').on('shown.bs.collapse', function (e) {
        if (e.target.id === "collapseIgv") {
            mpgSoftware.variantInfo.retrieveDelayedIgvLaunch().launch();
        }

    });
    $('#accordionVariant').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseIgv") {

        }
    });

    $('#collapseVariantAssociationStatistics').collapse({hide: false})
</script>

</body>
</html>

