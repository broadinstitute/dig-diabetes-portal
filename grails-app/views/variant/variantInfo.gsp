<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:require modules="variantInfo"/>
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
            fillTheFields(data,
                    "<%=variantToSearch%>",
                    "<g:createLink controller='trait' action='traitInfo' />");
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
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordionVariant"
                               href="#collapseVariantAssociationStatistics">
                                <h2><strong>Is <b><span id="variantTitleInAssociationStatistics"></span>
                                </b> associated with T2D or related traits?</strong></h2>
                            </a>
                        </div>

                        <div id="collapseVariantAssociationStatistics" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="variantAssociationStatistics"/>
                            </div>
                        </div>
                    </div>

                <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordionVariant"
                           href="#collapseDiseaseRisk">
                            <h2><strong>How does carrier status effect disease risk?</strong></h2>
                        </a>
                    </div>

                    <div id="collapseDiseaseRisk" class="accordion-body collapse">
                        <div class="accordion-inner">
                            <g:render template="diseaseRisk"/>
                        </div>
                    </div>
                </div>


                <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordionVariant"
                               href="#collapseHowCommonIsVariant">
                                <h2><strong>How common is <span id="populationsHowCommonIs" class="parentsFont"></span>?
                                </strong></h2>
                            </a>
                        </div>

                        <div id="collapseHowCommonIsVariant" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="howCommonIsVariant"/>
                            </div>
                        </div>
                    </div>


                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordionVariant"
                               href="#collapseCarrierStatusImpact">
                                <h2><strong>How many carriers are observed in the data set?</strong></h2>
                            </a>
                        </div>

                        <div id="collapseCarrierStatusImpact" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="carrierStatusImpact"/>
                            </div>
                        </div>
                    </div>


                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordionVariant"
                               href="#collapseAffectOfVariantOnProtein">
                                <div id="effectOfVariantOnProteinTitle"></div>
                            </a>
                        </div>

                        <div id="collapseAffectOfVariantOnProtein" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="effectOfVariantOnProtein"/>
                            </div>
                        </div>
                    </div>


                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordionVariant"
                               href="#collapseFindOutMore">
                                <h2><strong>Find out more</strong></h2>
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
    $('#accordionVariant').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseIgv") {

        }
        console.log('collapseIgv shown')
    });
    $('#accordionVariant').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseDiseaseRisk") {
            if ((typeof delayedBurdenTestPresentation !== 'undefined') &&
                    (typeof delayedBurdenTestPresentation.launch !== 'undefined')) {
                delayedBurdenTestPresentation.launch();
            }
        }
    });
    $('#accordionVariant').on('hide.bs.collapse', function (e) {
        if (e.target.id === "collapseDiseaseRisk") {
            if ((typeof delayedBurdenTestPresentation !== 'undefined') &&
                    (typeof delayedBurdenTestPresentation.launch !== 'undefined')) {
                delayedBurdenTestPresentation.removeBarchart();
            }
        }
    });
    $('#collapseOne').collapse({hide: true})
</script>

</body>
</html>

