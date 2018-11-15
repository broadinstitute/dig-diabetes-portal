<%@ page import="org.broadinstitute.mpg.diabetes.util.PortalConstants" %>

<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require module="core"/>
    <r:require module="variantWF"/>
    <r:require module="mustache"/>
    <r:require modules="traitsFilter"/>
    <r:require modules="datatables"/>

    <r:layoutResources/>
</head>

<body>
<style>
.redBorder, .redBorder:focus {
    border-color: red !important;
}

.dk-variant-search-builder-ui, .dk-submit-btn-wrapper {
    padding: 0 0 10px 0 !important;
}


#missense-options.form-control {
    padding-right: 5px;
}

.additionalInputGroup {
    padding: 0;
}

.additionalInputGroup:first-of-type {
    padding-top: 0;
}

#dependent h5, #independent h5 {
    /*padding: 10px 0 25px 0;*/
}
</style>
<script>

    var adjustPullout = function() {
        var pulloutHeight = $(".variant-finder-pullout").height();

        $(".variant-finder-pullout-content").css({"height":pulloutHeight-20 +"px"})
    }

    var openClosePullout = function() {
        console.log($(".variant-finder-pullout").attr("openfilter"));
       if ($(".variant-finder-pullout").attr("openfilter") == "close"){
           $(".variant-finder-pullout").css({"left":"-1px"}).attr("openfilter","open").find(".variant-finder-puller").find("span").attr("class","glyphicon glyphicon-menu-left");
       } else {
           $(".variant-finder-pullout").css({"left":"-350px"}).attr("openfilter","close").find(".variant-finder-puller").find("span").attr("class","glyphicon glyphicon-menu-right");
       }
    }

    $(window).resize(function() {
        adjustPullout();
    })

    $(document).ready(function () {
        // load the phenotypes in the phenotype-dependent tab
        mpgSoftware.variantWF.retrievePhenotypes('${g.portalTypeString()}');
        // load the datasets in the phenotype-independent tab
        mpgSoftware.variantWF.retrievePhenotypeIndependentDatasets('${g.portalTypeString()}');
        $('#geneInput').typeahead({
            source: function (query, process) {
                $.get('<g:createLink controller="gene" action="index"/>', {query: query}, function (data) {
                    process(data);
                })
            }
        });

        // check to see if we have any existing filters--if so, we need to initialize them
        if ('${encodedFilterSets}') {
            var encodedFilters = JSON.parse(decodeURIComponent('${encodedFilterSets}'));
            if(encodedFilters.length > 0) {
                mpgSoftware.variantWF.initializePage(encodedFilters);
            }
        }

//DK- added to open/close other options.

        $(".other-options-opener").click(function() {
            ($(this).text() == "▶ Additional options")? $(this).html("&#x25BC; Additional options"):$(this).html("&#x25B6; Additional options");

            $(".other-options").slideToggle("200", "swing",function() {

            });
        })

        adjustPullout();

        openClosePullout();

    });

</script>

<div id="rowTemplate" type="x-tmpl-mustache" style="display: none;">
    {{ #row }}
        <div class="col-md-12 dk-variant-search-builder-title">
            {{ translatedName }} <span style="font-size:11px; color:#999;">{{ helpText }}</span>
        </div>

        <div class="col-md-12 dk-variant-search-builder-ui">
            <div class="col-md-3 col-sm-3 col-xs-3">
                <select class="form-control" data-selectfor="{{ propName }}" data-category="{{ category }}">
                    <option>&lt;</option>
                    <option>&gt;</option>
                    <option>=</option>
                </select>
            </div>

            <div class="col-md-8 col-sm-8 col-xs-8 col-md-offset-1 col-sm-offset-1 col-xs-offset-1">
                <input type="text" class="form-control" data-type="propertiesInput"
                       data-prop="{{ propName }}" data-translatedname="{{ translatedName }}"
                       data-category="{{ category }}"
                       oninput="mpgSoftware.firstResponders.updateBuildSearchRequestButton('{{category}}');
                       mpgSoftware.firstResponders.validatePropertyInput(this)">
            </div>
        </div>
    {{ /row }}
</div>


<div id="main">

    <div class="container">

        <div class="variantWF-container">
                <div class="col-md-12">
                    <h1 class="dk-page-title"><g:message code="variantSearch.workflow.header.title" default="Variant Finder"/></h1>
                </div>
            <div class="col-md-9">
                <h5 class="dk-under-header"><g:message code="variantSearch.workflow.header.find_variants"/></h5>

                <g:if test="${g.portalTypeString()?.equals('t2d')}"><h5 class="dk-under-header"><g:message code="variantSearch.workflow.header.tutorial"/></h5></g:if>
            </div>
                <div class="col-md-3" style="padding-top:15px;">
                    <g:if test="${g.portalTypeString()?.equals('t2d')}"><div class="dk-t2d-green dk-tutorial-button dk-right-column-buttons"><a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/VariantFinderTutorial.pdf" target="_blank">Variant Finder tutorial</a></div>
                        <div class="dk-t2d-green dk-reference-button dk-right-column-buttons"><a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/Phenotype_reference_guide.pdf" target="_blank">Phenotype Reference Guide</a></div></g:if>
                    <g:elseif test="${g.portalTypeString()?.equals('stroke')}"><div class="dk-stroke-green dk-tutorial-button dk-right-column-buttons"><a href="https://s3.amazonaws.com/broad-portal-resources/stroke/tutorials/Cerebrovascular_VF_Tutorial.pdf" target="_blank">Variant Finder tutorial</a></div></g:elseif>
                    <g:else><div class="dk-stroke-green dk-tutorial-button dk-right-column-buttons"><a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/CVDKP_VF_Tutorial.pdf" target="_blank">Variant Finder tutorial</a></div></g:else>

                </div>
            </div>

            <!-- tabs
            <div class="row" style="padding-top:20px;">
            <div class="col-md-12">
            <ul class="nav nav-tabs" role="tablist">
                <li role="presentation" class="active"><a href="#dependent" aria-controls="dependent" role="tab"
                                                          id="dependentTab"
                                                          data-toggle="tab"><g:message
                            code="variantSearch.workflow.tab.phenotypeDependent.title"/></a></li>
                <li role="presentation"><a href="#independent" aria-controls="independent" role="tab"
                                           id="independentTab"
                                           data-toggle="tab"><g:message
                            code="variantSearch.workflow.tab.phenotypeIndependent.title"/></a></li>
            </ul>
        </div></div> -->
            <!-- content
            <div class="tab-content">
                <div role="tabpanel" class="tab-pane active" id="dependent">
                    <div class="dk-fluid">
                        <div class="dk-variant-search-builder">
                            <div style="padding: 10px 0;">



                            <g:if test="${g.portalTypeString()?.equals('t2d')}">
                                <h5><g:message code="variantSearch.workflow.tab.phenotypeDependent.t2d.text"></g:message></h5></g:if>
                            <g:elseif test="${g.portalTypeString()?.equals('stroke')}">
                                <h5><g:message code="variantSearch.workflow.tab.phenotypeDependent.stroke.text"/></h5></g:elseif>
                                <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                                    <h5><g:message code="variantSearch.workflow.tab.phenotypeDependent.mi.text"/></h5></g:elseif>
                                <g:else>
                                    <h5><g:message code="variantSearch.workflow.tab.phenotypeDependent.generic.text"/></h5></g:else>

                                <div class="row">
                                    <div class="col-md-3 col-sm-3 col-xs-3 dk-variant-search-builder-title">
                                        <g:message code="searchBuilder.traitOrDisease.prompt"
                                                   default="Trait or disease of interest"/>
                                    </div>

                                    <div class="col-md-5 col-sm-5 col-xs-5 dk-variant-search-builder-ui">
                                        <select id="phenotype" class="form-control" disabled
                                                onchange="mpgSoftware.firstResponders.respondToPhenotypeSelection('${g.portalTypeString()}')" onclick="mpgSoftware.firstResponders.respondToPhenotypeSelection('${g.portalTypeString()}')"></select>
                                    </div>

                                    <div class="col-md-4 col-sm-4 col-xs-4 dk-variant-search-builder-description">
                                        <g:message code="variantSearch.wfRequest.phenotype.help.text"
                                                   default="Choose a phenotype to act as the basis of a search"/>
                                    </div>
                                </div>

                                <div id="datasetChooserDependent" class="row">
                                    <div class="col-md-3 col-sm-3 col-xs-3 dk-variant-search-builder-title">
                                        <g:message code="searchBuilder.dataset.prompt" default="Data set"/>
                                    </div>

                                    <div class="col-md-5 col-sm-5 col-xs-5 dk-variant-search-builder-ui">
                                        <select id="datasetDependent" class="form-control" disabled
                                                onchange="mpgSoftware.firstResponders.respondToDataSetSelection('datasetDependent')"></select>
                                    </div>

                                    <div class="col-md-4 col-sm-4 col-xs-4 dk-variant-search-builder-description">
                                        <g:message code="variantSearch.wfRequest.dataSet.help.text"
                                                   default="Choose a data set from which variants may be found"/>
                                    </div>
                                </div>

                                <div id="datasetChooserCohortDependent" class="row" style="display: none;">
                                    <div class="col-md-3 col-sm-3 col-xs-3 dk-variant-search-builder-title">
                                        <g:message code="searchBuilder.dataset.cohortPrompt" default="Data set"/>
                                    </div>

                                    <div class="col-md-5 col-sm-5 col-xs-5 dk-variant-search-builder-ui">
                                        <select id="datasetCohortDependent" class="form-control"
                                                onchange="mpgSoftware.firstResponders.respondToDataSetSelection('datasetCohortDependent')"></select>
                                    </div>

                                    <div class="col-md-4 col-sm-4 col-xs-4 dk-variant-search-builder-description">
                                        <g:message code="variantSearch.wfRequest.dataSetCohort.help.text"
                                                   default="Optional"/>
                                    </div>
                                </div>

                                <div id="dependentRowTarget"></div>

                            </div>

                            <div class="row dk-submit-btn-wrapper">
                                <button id="buildSearchRequestDependent"
                                        class="btn btn-sm btn-primary dk-search-btn-inactive"
                                        onclick="mpgSoftware.variantWF.gatherCurrentQueryAndSave('dependent')" disabled>
                                    <g:message code="variantSearch.spec.actions.build_req"
                                               default="Build search request"/>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div role="tabpanel" class="tab-pane" id="independent">
                    <div style="padding: 10px 0;" class="dk-variant-search-builder">


<g:if test="${g.portalTypeString()?.equals('t2d')}">
                        <h5><g:message code="variantSearch.workflow.tab.phenotypeIndependentT2D.text"/></h5>
</g:if>
<g:if test="${g.portalTypeString()?.equals('stroke')}">
                        <h5><g:message code="variantSearch.workflow.tab.phenotypeIndependentStroke.text"/></h5>
</g:if>
<g:if test="${g.portalTypeString()?.equals('mi')}">
                        <h5><g:message code="variantSearch.workflow.tab.phenotypeIndependentMI.text"/></h5>

</g:if>





                        <div id="datasetChooserIndependent" class="row additionalInputGroup">
                            <div class="col-md-8 col-sm-8 col-xs-8 col-md-offset-2 dk-variant-search-builder-ui">

                                <label><g:message code="searchBuilder.dataset.prompt" default="Data set"/>
                                    <small style="color: #aaa;">(<g:message code="variantSearch.wfRequest.dataSet.help.text"
                                                                            default="Choose a data set from which variants may be found"/>)
                                    </small></label>
                                <select id="datasetIndependent" class="form-control" style="width: 90%"
                                        onchange="mpgSoftware.firstResponders.respondToDataSetSelection('datasetIndependent')"></select>
                            </div>

                            <div id="datasetChooserCohortIndependent" class="row" style="display: none;">
                                <div class="col-md-3 col-sm-3 col-xs-3 dk-variant-search-builder-title">
                                    <g:message code="searchBuilder.dataset.cohortPrompt" default="Data set"/>
                                </div>

                                <div class="col-md-5 col-sm-5 col-xs-5 dk-variant-search-builder-ui">
                                    <select id="datasetCohortIndependent" class="form-control"
                                            onchange="mpgSoftware.firstResponders.respondToDataSetSelection('datasetCohortIndependent')"></select>
                                </div>

                                <div class="col-md-4 col-sm-4 col-xs-4 dk-variant-search-builder-description">
                                    <g:message code="variantSearch.wfRequest.dataSetCohort.help.text"
                                               default="Optional"/>
                                </div>
                            </div>


                            <div id="independentRowTarget"></div>
                        </div>

                        <div class="row additionalInputGroup">
                            <div class="col-md-8 col-sm-8 col-xs-8 col-md-offset-2">
                                <label><g:message code="variantSearch.workflow.tab.phenotypeIndependent.genomicLocation"
                                                  default="Genomic location of variants" />
                                </label>
                                <div id="chromosomeInputHolder" class="form-inline">
                                    <div class="form-inline">
                                        <input id="geneInput" type="text" class="form-control"
                                               style="width:50%;"
                                               placeholder="gene (e.g. SLC30A8, HDAC9)" data-type="advancedFilterInput"
                                               data-prop="gene" data-translatedname="gene"
                                               oninput="mpgSoftware.firstResponders.updateBuildSearchRequestButton('independent');
                                               mpgSoftware.firstResponders.controlGeneAndChromosomeInputs();
                                               ">
                                        <label style="font-size: 20px; font-weight: 100;">&nbsp; &#177 &nbsp;</label>
                                        <input type="number" id="geneRangeInput" class="form-control"
                                               placeholder="flanking sequence (nt)"
                                               style="width:35%;"/>
                                    </div>

                                    <div class="text-center" style="color:#f70; padding: 10px 0 10px 0;">
                                        &#8212; or &#8212;
                                    </div>

                                    <div class="form-inline">
                                        <input id="chromosomeInput" type="text" class="form-control" style="width: 90%"
                                               placeholder="Region chromosome:start-stop (e.g. 9:21940000-22190000)"
                                               data-type="advancedFilterInput"
                                               data-prop="chromosome" data-translatedname="chromosome"
                                               oninput="
                                                   mpgSoftware.firstResponders.updateBuildSearchRequestButton('independent');
                                                   mpgSoftware.firstResponders.validateChromosomeInput();
                                                   mpgSoftware.firstResponders.controlGeneAndChromosomeInputs();
                                               ">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row additionalInputGroup">
                            <div class="col-md-10 col-sm-10 col-xs-10 col-md-offset-2">
                                <label><g:message code="variantSearch.workflow.tab.phenotypeIndependent.proteinEffect"
                                                  default="Predicted effect of the variants on proteins" />
                                </label>

                                <div class="form-inline">
                                    <label class="radio-inline">
                                        <input type="radio" name="predictedEffects" id="allProteinEffects"
                                               value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_ALL_CODE}"
                                               checked
                                               onclick="mpgSoftware.firstResponders.updateProteinEffectSelection(${PortalConstants.PROTEIN_PREDICTION_EFFECT_ALL_CODE})">
                                        <g:message code="variantSearch.proteinEffectRestrictions.allEffects"
                                                   default="all effects"/>
                                    </label>

                                    <label class="radio-inline">
                                        <input type="radio" name="predictedEffects"
                                               value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_PTV_CODE}"
                                               onclick="mpgSoftware.firstResponders.updateProteinEffectSelection(${PortalConstants.PROTEIN_PREDICTION_EFFECT_PTV_CODE})">
                                        <g:message
                                                code="variantSearch.proteinEffectRestrictions.proteinTruncating"
                                                default="protein-truncating"/>
                                    </label>

                                    <label class="radio-inline">
                                        <input type="radio" name="predictedEffects"
                                               value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_MISSENSE_CODE}"
                                               onclick="mpgSoftware.firstResponders.updateProteinEffectSelection(${PortalConstants.PROTEIN_PREDICTION_EFFECT_MISSENSE_CODE})">
                                        <g:message code="variantSearch.proteinEffectRestrictions.missense"
                                                   default="missense"/>
                                    </label>

                                    <label class="radio-inline">
                                        <input type="radio" name="predictedEffects"
                                               value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_SYNONYMOUS_CODE}"
                                               onclick="mpgSoftware.firstResponders.updateProteinEffectSelection(${PortalConstants.PROTEIN_PREDICTION_EFFECT_SYNONYMOUS_CODE})">
                                        <g:message
                                                code="variantSearch.proteinEffectRestrictions.synonymousCoding"
                                                default="synonymous coding"/>
                                    </label>


                                    <label class="radio-inline">
                                        <input type="radio" name="predictedEffects"
                                               value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_NONCODING_CODE}"
                                               onclick="mpgSoftware.firstResponders.updateProteinEffectSelection(${PortalConstants.PROTEIN_PREDICTION_EFFECT_NONCODING_CODE})">
                                        <g:message code="variantSearch.proteinEffectRestrictions.noncoding"
                                                   default="non-coding"/>
                                    </label>

                                </div>
                            </div>

                            <div id="missense-options"
                                 class="form-inline col-md-10 col-sm-10 col-xs-10 col-md-offset-2"
                                 style="display: none">
                                <div class="form-group form-group-sm">
                                    <select id="polyphenSelect"
                                            name="${PortalConstants.JSON_VARIANT_POLYPHEN_PRED_KEY}"
                                            data-translatedname="<g:message code="metadata.PolyPhen_PRED"
                                                                            default="PolyPhen-2 prediction"/>"
                                            data-type="proteinEffectSelection" class="form-control">
                                        <option value="">${PortalConstants.PROTEIN_PREDICTION_POLYPHEN_NONE_NAME}</option>
                                        <option value="${PortalConstants.PROTEIN_PREDICTION_POLYPHEN_PROBABLYDAMAGING_STRING_CODE}"><g:message
                                                code="variantSearch.proteinEffectRestrictions.missense.polyphen.probablyDamaging"
                                                default="probably damaging"/></option>
                                        <option value="${PortalConstants.PROTEIN_PREDICTION_POLYPHEN_POSSIBLYDAMAGING_STRING_CODE}"><g:message
                                                code="variantSearch.proteinEffectRestrictions.missense.polyphen.possiblyDamaging"
                                                default="possibly damaging"/></option>
                                        <option value="${PortalConstants.PROTEIN_PREDICTION_POLYPHEN_BENIGN_STRING_CODE}"><g:message
                                                code="variantSearch.proteinEffectRestrictions.missense.polyphen.benign"
                                                default="benign"/></option>
                                    </select>
                                    <label><g:message
                                            code="variantSearch.proteinEffectRestrictions.missense.polyphen"
                                            default="PolyPhen-2 prediction"/></label>
                                </div>

                                <div class="form-group form-group-sm">
                                    <select id="siftSelect"
                                            name="${PortalConstants.JSON_VARIANT_SIFT_PRED_KEY}"
                                            data-translatedname="<g:message code="metadata.SIFT_PRED"
                                                                            default="SIFT prediction"/>"
                                            data-type="proteinEffectSelection" class="form-control">
                                        <option value="">${PortalConstants.PROTEIN_PREDICTION_SIFT_NONE_NAME}</option>
                                        <option value="${PortalConstants.PROTEIN_PREDICTION_SIFT_DELETERIOUS_STRING_CODE}"><g:message
                                                code="variantSearch.proteinEffectRestrictions.missense.sift.deleterious"
                                                default="deleterious"/></option>
                                        <option value="${PortalConstants.PROTEIN_PREDICTION_SIFT_TOLERATED_STRING_CODE}"><g:message
                                                code="variantSearch.proteinEffectRestrictions.missense.sift.tolerated"
                                                default="tolerated"/></option>
                                    </select>
                                    <label><g:message
                                            code="variantSearch.proteinEffectRestrictions.missense.sift"
                                            default="SIFT prediction"/></label>
                                </div>

                                <div class="form-group form-group-sm">
                                    <select id="condelSelect"
                                            name="${PortalConstants.JSON_VARIANT_CONDEL_PRED_KEY}"
                                            data-translatedname="<g:message code="metadata.Condel_PRED"
                                                                            default="CONDEL prediction"/>"
                                            data-type="proteinEffectSelection" class="form-control">
                                        <option value="">---</option>
                                        <option value="${PortalConstants.PROTEIN_PREDICTION_CONDEL_DELETERIOUS_STRING_CODE}"><g:message
                                                code="variantSearch.proteinEffectRestrictions.missense.condel.deleterious"
                                                default="deleterious"/></option>
                                        <option value="${PortalConstants.PROTEIN_PREDICTION_CONDEL_BENIGN_STRING_CODE}"><g:message
                                                code="variantSearch.proteinEffectRestrictions.missense.condel.benign"
                                                default="benign"/></option>
                                    </select>
                                    <label><g:message
                                            code="variantSearch.proteinEffectRestrictions.missense.condel"
                                            default="CONDEL prediction"/></label>
                                </div>
                            </div>
                        </div>


                        <div class="row additionalInputGroup">
                            <div class="col-md-12 col-sm-12 col-xs-12 text-right">
                                <button id="buildSearchRequestIndependent"
                                        class="btn btn-sm btn-primary dk-search-btn-inactive"
                                        onclick="mpgSoftware.variantWF.gatherCurrentQueryAndSave('independent')"
                                        disabled>
                                    <g:message code="variantSearch.spec.actions.build_req"
                                               default="Build search request"/>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>-->

            <div id="searchDetailsHolder" class="row dk-variant-submit-search"></div>

            <script id="searchDetailsTemplate" type="x-tmpl-mustache">
                %{--<h6><g:message code="variantSearch.actions.submit_search" default="Submit search request"/></h6>--}%
                <div class="col-md-9">
                <table class="table table-striped dk-search-collection">
                    <thead>
                    <tr>
                        <th><g:message code="variantSearch.spec.actions.search_detail" default="Search detail"/></th>
                        <th><g:message code="variantSearch.spec.actions.edit" default="Edit"/></th>
                        <th><g:message code="variantSearch.spec.actions.delete" default="Delete"/></th>
                    </tr>
                    </thead>
                    <tbody>
                    {{ #listOfSavedQueries }}
                    <tr>
                        <td>
                            {{ translatedPhenotype }} {{ #translatedDataset }} [{{{ translatedDataset }}}] {{ /translatedDataset }} {{ translatedName }} {{ comparator }} {{ displayValue }}<br>
                        </td>
                        <td><a onclick="mpgSoftware.variantWF.editQuery({{ index }})"><g:message
                    code="variantSearch.spec.actions.edit" default="Edit"/></a></td>
                        <td><a onclick="mpgSoftware.variantWF.deleteQuery({{ index }})"><g:message
                    code="variantSearch.spec.actions.delete" default="Delete"/></a></td>
                    </tr>
                    {{ /listOfSavedQueries }}
                    </tbody>
                </table>
                </div>

                <div class="col-md-3 dk-submit-btn-wrapper">
                    {{ #shouldSubmitBeEnabled }}
                    <button class="btn btn-lg btn-primary" onclick="mpgSoftware.variantWF.variantFinderGetData(); openClosePullout();">
                        <g:message code="variantSearch.actions.submit_search" default="Submit search request"/>
                    </button>
                    {{ /shouldSubmitBeEnabled }}
                    {{ ^shouldSubmitBeEnabled }}
                    <button class="btn btn-lg btn-primary dk-search-btn-inactive" disabled>
                        <g:message code="variantSearch.actions.submit_search" default="Submit search request"/>
                    </button>
                    {{ /shouldSubmitBeEnabled }}
                </div>
            </script>
        </div>
</div>

<div class="container-fluid" style="padding: 30px;"><div id="searchResultsHolder" class="row">
    <table id="xvariantTableResults" class="table table-striped dk-search-result dk-t2d-table no-footer" style="border-collapse: collapse; width: 100%;" role="grid" aria-describedby="xvariantTableResults_info">
        <thead></thead>
        <tbody></tbody>
    </table>
</div></div>

</div>
<style>
    .variant-finder-pullout {
        width: 350px;
        height:auto;
        min-height: 98%;
        position: absolute;
        top:1%;
        left: -350px;
        background-color: rgba(255,255,255,1);
        z-index: 10000;
        border-top-right-radius: 10px;
        border-bottom-right-radius: 10px;
        box-shadow: 5px 5px 5px rgba(0,0,0, .25);
        -webkit-transition: left 500ms; /* Safari */
        transition: left 500ms;
        padding: 0px 20px;
    }

    .variant-finder-puller {
        display: table;
        position: absolute;
        right: -50px;
        background-color: #eee;
        color: #fff;
        border: solid 1px #eee;
        border-left: none;
        width: 50px;
        height: 100px;
        text-align: left;
        top:150px;
        box-shadow: 5px 5px 5px rgba(0,0,0, .25);
        border-top-right-radius: 50px;
        border-bottom-right-radius: 50px;
    }

    .variant-finder-puller div {
        display: table-cell;
        vertical-align: middle;
        padding-top: 5px;
        padding-left: 7px;
        font-size: 25px;
    }

    .variant-finder-pullout-content {
        margin: 10px 0 0 10px;
        width:328px;
        padding:10px 20px;
    }

    .variant-finder-pullout h4 {
        font-size: 16px;
    }
</style>

<div class="variant-finder-pullout" openfilter="close">
    <div class="variant-finder-puller"><div><a href="javascript:;" onclick="openClosePullout();"><span class="glyphicon glyphicon-menu-right" aria-hidden="true"></span></a></div></div>

    <h3 style="font-size: 18px;">Search Filter</h3>

    <div class="dk-variant-search-builder">

        <!--<h5><g:message code="variantSearch.workflow.tab.phenotypeDependent.text"/></h5>-->

        <div class="dk-variant-search-builder-ui">
            <label><g:message code="searchBuilder.traitOrDisease.prompt" default="Trait or disease of interest"/></label>
            <select id="phenotype" class="form-control selectpicker" data-live-search="true" disabled
                            onchange="mpgSoftware.firstResponders.respondToPhenotypeSelection('${g.portalTypeString()}')" onclick="mpgSoftware.firstResponders.respondToPhenotypeSelection('${g.portalTypeString()}')"></select>
        </div>

        <!-- For the newer version of variant finder dataset list will be gone or optional -->
        <div  id="datasetChooserDependent" class="dk-variant-search-builder-ui">
            <label><g:message code="searchBuilder.dataset.prompt" default="Data set"/></label>
            <select id="datasetDependent" class="form-control" disabled
                            onchange="mpgSoftware.firstResponders.respondToDataSetSelection('datasetDependent')"></select>
        </div>

        <div id="datasetChooserCohortDependent" class="dk-variant-search-builder-ui" style="display: none;">
            <label class="dk-variant-search-builder-title">
                <g:message code="searchBuilder.dataset.cohortPrompt" default="Data set"/>: <g:message code="variantSearch.wfRequest.dataSetCohort.help.text"
                                                                                                          default="Optional"/>
            </label>
            <select id="datasetCohortDependent" class="form-control"
                            onchange="mpgSoftware.firstResponders.respondToDataSetSelection('datasetCohortDependent')"></select>
        </div>

        <div id="dependentRowTarget"></div>


        <div class="dk-submit-btn-wrapper">
            <button id="buildSearchRequestDependent"
                    class="btn btn-sm btn-primary dk-search-btn-inactive"
                    onclick="mpgSoftware.variantWF.gatherCurrentQueryAndSave('dependent')" disabled>
                <g:message code="variantSearch.spec.actions.build_req"
                           default="Build search request"/>
            </button>
        </div>

    </div>

    <div class="well" style="padding:10px;">
    <h4 style="padding: 0; margin:0;"><a href="javascript:;" class="other-options-opener">&#9654; Additional options</a></h4>

    <div style="padding: 10px 0; display: none;" class="dk-variant-search-builder other-options">
        <h5><g:message code="variantSearch.workflow.tab.phenotypeIndependent.text"/></h5>

        <div id="datasetChooserIndependent" class="additionalInputGroup dk-variant-search-builder-ui">
            <div class="dk-variant-search-builder-ui">

                <label><g:message code="searchBuilder.dataset.prompt" default="Data set"/>
                    <small style="color: #aaa;">(<g:message code="variantSearch.wfRequest.dataSet.help.text"
                                                            default="Choose a data set from which variants may be found"/>)
                    </small></label>
                <select id="datasetIndependent" class="form-control"
                        onchange="mpgSoftware.firstResponders.respondToDataSetSelection('datasetIndependent')"></select>
            </div>

            <div id="datasetChooserCohortIndependent" style="display: none;">
                <div class="dk-variant-search-builder-title">
                    <g:message code="searchBuilder.dataset.cohortPrompt" default="Data set"/>
                </div>

                <div class="dk-variant-search-builder-ui">
                    <select id="datasetCohortIndependent" class="form-control"
                            onchange="mpgSoftware.firstResponders.respondToDataSetSelection('datasetCohortIndependent')"></select>
                </div>

                <div class="dk-variant-search-builder-description">
                    <g:message code="variantSearch.wfRequest.dataSetCohort.help.text"
                               default="Optional"/>
                </div>
            </div>


            <div id="independentRowTarget"></div>
        </div>

        <div class="additionalInputGroup dk-variant-search-builder-ui">
                <label><g:message code="variantSearch.workflow.tab.phenotypeIndependent.genomicLocation"
                                  default="Genomic location of variants" />
                </label>
                <div id="chromosomeInputHolder" class="form-inline">
                    <div class="form-inline">
                        <input id="geneInput" type="text" class="form-control"
                               style="width:50%;"
                               placeholder="gene (e.g. SLC30A8, HDAC9)" data-type="advancedFilterInput"
                               data-prop="gene" data-translatedname="gene"
                               oninput="mpgSoftware.firstResponders.updateBuildSearchRequestButton('independent');
                               mpgSoftware.firstResponders.controlGeneAndChromosomeInputs();
                               ">
                        <label style="font-size: 20px; font-weight: 100;">&nbsp; &#177 &nbsp;</label>
                        <input type="number" id="geneRangeInput" class="form-control"
                               placeholder="flanking sequence (nt)"
                               style="width:35%;"/>
                    </div>

                    <div class="text-center" style="color:#f70; padding: 10px 0 10px 0;">
                        &#8212; or &#8212;
                    </div>

                    <div class="form-inline">
                        <input id="chromosomeInput" type="text" class="form-control" style="width: 100%"
                               placeholder="Region chromosome:start-stop (e.g. 9:21940000-22190000)"
                               data-type="advancedFilterInput"
                               data-prop="chromosome" data-translatedname="chromosome"
                               oninput="
                                   mpgSoftware.firstResponders.updateBuildSearchRequestButton('independent');
                                   mpgSoftware.firstResponders.validateChromosomeInput();
                                   mpgSoftware.firstResponders.controlGeneAndChromosomeInputs();
                               ">
                    </div>
                </div>
        </div>

        <div class="additionalInputGroup dk-variant-search-builder-ui">
                <label><g:message code="variantSearch.workflow.tab.phenotypeIndependent.proteinEffect"
                                  default="Predicted effect of the variants on proteins" />
                </label>

                <div class="form-inline">
                    <label class="radio-inline">
                        <input type="radio" name="predictedEffects" id="allProteinEffects"
                               value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_ALL_CODE}"
                               checked
                               onclick="mpgSoftware.firstResponders.updateProteinEffectSelection(${PortalConstants.PROTEIN_PREDICTION_EFFECT_ALL_CODE})">
                        <g:message code="variantSearch.proteinEffectRestrictions.allEffects"
                                   default="all effects"/>
                    </label>
                    <br/>

                    <label class="radio-inline">
                        <input type="radio" name="predictedEffects"
                               value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_PTV_CODE}"
                               onclick="mpgSoftware.firstResponders.updateProteinEffectSelection(${PortalConstants.PROTEIN_PREDICTION_EFFECT_PTV_CODE})">
                        <g:message
                                code="variantSearch.proteinEffectRestrictions.proteinTruncating"
                                default="protein-truncating"/>
                    </label>

                    <label class="radio-inline">
                        <input type="radio" name="predictedEffects"
                               value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_MISSENSE_CODE}"
                               onclick="mpgSoftware.firstResponders.updateProteinEffectSelection(${PortalConstants.PROTEIN_PREDICTION_EFFECT_MISSENSE_CODE})">
                        <g:message code="variantSearch.proteinEffectRestrictions.missense"
                                   default="missense"/>
                    </label>
                    <br/>

                    <label class="radio-inline">
                        <input type="radio" name="predictedEffects"
                               value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_SYNONYMOUS_CODE}"
                               onclick="mpgSoftware.firstResponders.updateProteinEffectSelection(${PortalConstants.PROTEIN_PREDICTION_EFFECT_SYNONYMOUS_CODE})">
                        <g:message
                                code="variantSearch.proteinEffectRestrictions.synonymousCoding"
                                default="synonymous coding"/>
                    </label>


                    <label class="radio-inline">
                        <input type="radio" name="predictedEffects"
                               value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_NONCODING_CODE}"
                               onclick="mpgSoftware.firstResponders.updateProteinEffectSelection(${PortalConstants.PROTEIN_PREDICTION_EFFECT_NONCODING_CODE})">
                        <g:message code="variantSearch.proteinEffectRestrictions.noncoding"
                                   default="non-coding"/>
                    </label>

                </div>


            <div id="missense-options" class="form-inline" style="display: none">
                <div class="form-group form-group-sm">
                    <select id="polyphenSelect"
                            name="${PortalConstants.JSON_VARIANT_POLYPHEN_PRED_KEY}"
                            data-translatedname="<g:message code="metadata.PolyPhen_PRED"
                                                            default="PolyPhen-2 prediction"/>"
                            data-type="proteinEffectSelection" class="form-control">
                        <option value="">${PortalConstants.PROTEIN_PREDICTION_POLYPHEN_NONE_NAME}</option>
                        <option value="${PortalConstants.PROTEIN_PREDICTION_POLYPHEN_PROBABLYDAMAGING_STRING_CODE}"><g:message
                                code="variantSearch.proteinEffectRestrictions.missense.polyphen.probablyDamaging"
                                default="probably damaging"/></option>
                        <option value="${PortalConstants.PROTEIN_PREDICTION_POLYPHEN_POSSIBLYDAMAGING_STRING_CODE}"><g:message
                                code="variantSearch.proteinEffectRestrictions.missense.polyphen.possiblyDamaging"
                                default="possibly damaging"/></option>
                        <option value="${PortalConstants.PROTEIN_PREDICTION_POLYPHEN_BENIGN_STRING_CODE}"><g:message
                                code="variantSearch.proteinEffectRestrictions.missense.polyphen.benign"
                                default="benign"/></option>
                    </select>
                    <label><g:message
                            code="variantSearch.proteinEffectRestrictions.missense.polyphen"
                            default="PolyPhen-2 prediction"/></label>
                </div>

                <div class="form-group form-group-sm">
                    <select id="siftSelect"
                            name="${PortalConstants.JSON_VARIANT_SIFT_PRED_KEY}"
                            data-translatedname="<g:message code="metadata.SIFT_PRED"
                                                            default="SIFT prediction"/>"
                            data-type="proteinEffectSelection" class="form-control">
                        <option value="">${PortalConstants.PROTEIN_PREDICTION_SIFT_NONE_NAME}</option>
                        <option value="${PortalConstants.PROTEIN_PREDICTION_SIFT_DELETERIOUS_STRING_CODE}"><g:message
                                code="variantSearch.proteinEffectRestrictions.missense.sift.deleterious"
                                default="deleterious"/></option>
                        <option value="${PortalConstants.PROTEIN_PREDICTION_SIFT_TOLERATED_STRING_CODE}"><g:message
                                code="variantSearch.proteinEffectRestrictions.missense.sift.tolerated"
                                default="tolerated"/></option>
                    </select>
                    <label><g:message
                            code="variantSearch.proteinEffectRestrictions.missense.sift"
                            default="SIFT prediction"/></label>
                </div>

                <div class="form-group form-group-sm">
                    <select id="condelSelect"
                            name="${PortalConstants.JSON_VARIANT_CONDEL_PRED_KEY}"
                            data-translatedname="<g:message code="metadata.Condel_PRED"
                                                            default="CONDEL prediction"/>"
                            data-type="proteinEffectSelection" class="form-control">
                        <option value="">---</option>
                        <option value="${PortalConstants.PROTEIN_PREDICTION_CONDEL_DELETERIOUS_STRING_CODE}"><g:message
                                code="variantSearch.proteinEffectRestrictions.missense.condel.deleterious"
                                default="deleterious"/></option>
                        <option value="${PortalConstants.PROTEIN_PREDICTION_CONDEL_BENIGN_STRING_CODE}"><g:message
                                code="variantSearch.proteinEffectRestrictions.missense.condel.benign"
                                default="benign"/></option>
                    </select>
                    <label><g:message
                            code="variantSearch.proteinEffectRestrictions.missense.condel"
                            default="CONDEL prediction"/></label>
                </div>
            </div>
        </div>


        <div class="additionalInputGroup dk-submit-btn-wrapper">
                <button id="buildSearchRequestIndependent"
                        class="btn btn-sm btn-primary dk-search-btn-inactive"
                        onclick="mpgSoftware.variantWF.gatherCurrentQueryAndSave('independent'); "
                        disabled>
                    <g:message code="variantSearch.spec.actions.build_req"
                               default="Build search request"/>
                </button>
        </div>
    </div>

    </div>
</div>
</body>
</html>

