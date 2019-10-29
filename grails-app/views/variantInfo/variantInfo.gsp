<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="variantInfo, variantInfoPage"/>
    <r:require modules="tableViewer,traitInfo"/>
    <r:require modules="boxwhisker"/>
    <r:require module="locusZoom"/>
    <r:require modules="traitSample"/>
    <r:require modules="traitsFilter"/>
    <link rel="stylesheet" type="text/css"  href="../../css/lib/locuszoom.css">

    <r:layoutResources/>

    <link type="application/font-woff">
    <link type="application/vnd.ms-fontobject">
    <link type="application/x-font-ttf">
    <link type="font/opentype">


    <!-- Google fonts -->
    <link rel="stylesheet" type="text/css" href='//fonts.googleapis.com/css?family=PT+Sans:400,700'>
    <link rel="stylesheet" type="text/css" href='//fonts.googleapis.com/css?family=Open+Sans'>

    %{--Need to call directly or else the images don't come out right--}%
    <link rel="stylesheet" type="text/css"  src="../../js/lib/locuszoom.css">

</head>

<body>

<g:render template="/templates/variantAssociationStatisticsTemplate"/>

<div id="rSpinner" class="dk-loading-wheel center-block" style="display:none">
    <img src="${resource(dir: 'images', file: 'ajax-loader.gif')}" alt="Loading"/>
</div>


<script>

    var traitsPerVariantTableColumns = {sample:'<g:message code="variantTable.columnHeaders.shared.samples" />',
        sampleHelpHeader:'<g:message code="variantTable.columnHeaders.shared.samples.help.header" />',
        sampleHelpText:'<g:message code="variantTable.columnHeaders.shared.samples.help.text" />'
    }

    // generate the texts here so that the appropriate one can be selected in initializePage
    // the keys (1,2,3,4) map to the assignments for MOST_DEL_SCORE




    // sometimes the headers weren't fully loaded before the initializePage function was called,
    // so don't run it until the DOM is ready
    $(document).ready(function () {

        var variantSummaryText = {
            1: "${g.message(code: "variant.summaryText.proteinTruncating")}",
            2: "${g.message(code: "variant.summaryText.missense")}",
            3: "${g.message(code: "variant.summaryText.synonymous")}",
            4: "${g.message(code: "variant.summaryText.noncoding")}"
        };
        var configDetails = {  'exposeGreenBoxes':'${portalVersionBean.getExposeGreenBoxes()}',
            'exposeForestPlot': '${portalVersionBean.getExposeForestPlot()}',
            'exposePhewasModule':'${portalVersionBean.getExposePhewasModule()}'};
        mpgSoftware.variantInfo.storeVarInfoData(configDetails);
        mpgSoftware.variantInfo.retrieveVariantPhenotypeData(phenotypeDatasetMapping,
                variantId,
                variantAssociationStrings,
                '${createLink(controller:'variantInfo',action: 'variantDescriptiveStatistics')}',
                '${g.defaultPhenotype()}');


        mpgSoftware.associationStatistics.buildDynamicPage(configDetails);






        var loading = $('#spinner').show();

        $.ajax({
            cache: false,
            type: "get",
            url: ('<g:createLink controller="variantInfo" action="variantAjax"/>' + '/${variantToSearch}'),
            async: true
        }).done(function (data) {

                mpgSoftware.variantInfo.initializePage(data,
                    "<%=variantToSearch%>",
                    "<g:createLink controller='trait' action='traitInfo' />",
                    "<%=restServer%>",
                    variantSummaryText,
                        'stroke',"#lz-47","#collapseLZ",'${lzOptions.findAll{it.defaultSelected&&it.dataType=='static'}.first().key}',
                        '${lzOptions.findAll{it.defaultSelected&&it.dataType=='static'}.first().description}',
                        '${lzOptions.findAll{it.defaultSelected&&it.dataType=='static'}.first().propertyName}',
                        '${lzOptions.findAll{it.defaultSelected&&it.dataType=='static'}.first().dataSet}',
                        '${lzOptions.findAll{it.defaultSelected&&it.dataType=='static'}.first().dataSetReadable}',
                        '${createLink(controller:"gene", action:"getLocusZoom")}',
                        '${createLink(controller:"variantInfo", action:"variantInfo")}',
                        '${lzOptions.findAll{it.defaultSelected&&it.dataType=='static'}.first().dataType}',
                        '${createLink(controller:"variantInfo", action:"retrieveFunctionalDataAjax")}',
                        '${createLink(controller:"trait", action:"phewasAjaxCallInLzFormat")}',
                        '${createLink(controller:"trait", action:"phewasForestAjaxCallInLzFormat")}',
                        ${portalVersionBean.getExposePhewasModule()},
                        ${portalVersionBean.getExposeForestPlot()},
                        ${portalVersionBean.getExposeTraitDataSetAssociationView()})

                if ((!data.variant.is_error) && (data.variant.numRecords>0)){
                    mpgSoftware.variantInfo.retrieveFunctionalData(data,mpgSoftware.variantInfo.displayFunctionalData,
                            {retrieveFunctionalDataAjaxUrl:'${createLink(controller:"variantInfo", action:"retrieveFunctionalDataAjax")}'});
                }


        //}).fail(function (jqXHR, textStatus, errorThrown) {
            }).fail(function () {
            loading.hide();
            core.errorReporter("jqXHR", "unidentified problem")
        });
    });


    $(window).resize(function() {
        mpgSoftware.traitSample.filterTraitsTable();
    })
</script>


<div id="main">

    <div class="container-fluid" style="padding: 0 2.5%">

        <div class="variant-info-container">
            <div class="variant-info-view">

                <div id="variant-info-summary-wrapper">
                    <div id="variant-info-summary-header">
                        <div class="variant-name" style="width:25%;">Variant</div>
                        <div class="variant-summary" style="width:75%;">Summary</div>
                    </div>
                    <div id="variant-info-summary-content">
                        <div class="variant-name" id="variantTitle" style="width:25%; font-size: 42px;"></div>
                        <div class="variant-summary" style="width:75%; font-size: 18px; " id="variantSummaryText"><g:message code="variant.summaryText.summary" /></div>
                    </div>
                </div>



                <!--
                <div class="row">
                    <div class="col-md-12">

                        <a class="find-out-more-opener" data-toggle="collapse" data-parent="#accordion2" href="#findOutMoreCompact2">
                            <span class="glyphicon glyphicon-share-alt" aria-hidden="true"></span><br />External<br />resources</a>

                        <div class="find-out-more-content collapse" id="findOutMoreCompact2">
                            <div class="accordion-inner">
                                <g:render template="findOutMoreCompact"/>
                            </div>
                        </div>
                    </div>
                </div>
-->

                <g:render template="variantPageHeader"/>



                <div class="accordion" id="accordionVariant">

                    <div class="accordion-group well well-variant-page">
                        <div class="accordion-heading">
                            <a class="accordion-toggle" data-toggle="collapse"
                               data-parent="#accordionVariant"
                               href="#collapseVariantAssociationStatistics">
                                <h2><strong><g:message code="variant.variantAssociationStatistics.title"
                                                       default="Variant associations at a glance"/></strong></h2>
                            </a>
                        </div>


                        <div id="collapseVariantAssociationStatistics" class="accordion-body collapse in">
                            <div class="accordion-inner">
                                <g:render template="variantAssociationStatistics"/>
                            </div>
                        </div>
                    </div>



                <g:render template="/widgets/associatedStatisticsTraitsPerVariant"
                          model="[variantIdentifier: variantToSearch, locale: locale]"/>




                    <g:render template="functionalAnnotation"/>


                <g:if test="${g.portalTypeString()?.equals('stroke')||
                        g.portalTypeString()?.equals('t2d')||

                        g.portalTypeString()?.equals('mi')}">



                    <g:render template="/templates/burdenTestSharedTemplate" model="['variantIdentifier': variantToSearch, 'accordionHeaderClass': 'accordion-heading']"/>
                    <g:render template="/widgets/burdenTestShared" model="['variantIdentifier': variantToSearch,
                                                                           'accordionHeaderClass': 'accordion-heading',
                                                                           'allowExperimentChoice': 1,
                                                                           'allowPhenotypeChoice' : 1,
                                                                           'allowStratificationChoice': 1,
                                                                           'grsVariantSet':''   ]"/>

                    </g:if>




                    <g:if test="${true}">
                        <g:render template="/widgets/locusZoomPlot"/>



                    </g:if>

                    <div class="accordion-group well well-variant-page">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse"
                               data-parent="#accordionVariant"
                               href="#collapseHowCommonIsVariant">
                                <h2><strong><g:message code="variant.howCommonIsVariant.title"
                                                       default="How common is variant"/></strong></h2>
                            </a>
                        </div>

                        <g:render template="howCommonIsVariant"/>

                    </div>





                    <div style="padding: 7px 0 3px 15px; border-radius: 0px; margin-top: 15px; background-color:#fff; ">

                        <span class="glyphicon glyphicon-link" aria-hidden="true"></span> External resources:&nbsp;
                    <g:render template="findOutMoreCompact"/>

                    </div>

                </div>

            </div>

        </div>
    </div>

</div>

</body>
</html>

