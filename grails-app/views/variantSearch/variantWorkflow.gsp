<%@ page import="org.broadinstitute.mpg.diabetes.util.PortalConstants" %>

<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require module="core"/>
    <r:require module="variantWF"/>
    <r:require module="mustache"/>

    <r:layoutResources/>
</head>

<body>
<style>
.redBorder, .redBorder:focus {
    border-color: red !important;
}
</style>
<script>
    $(document).ready(function () {
        // load the phenotypes in the phenotype-dependent tab
        mpgSoftware.variantWF.retrievePhenotypes();
        // load the datasets in the phenotype-independent tab
        mpgSoftware.variantWF.retrievePhenotypeIndependentDatasets();
        $('#geneInput').typeahead({
            source: function (query, process) {
                $.get('<g:createLink controller="gene" action="index"/>', {query: query}, function (data) {
                    process(data);
                })
            }
        });

        // check to see if we have any existing filters--if so, we need to initialize them
        if ('${encodedFilterSets}') {
            mpgSoftware.variantWF.initializePage(JSON.parse(decodeURIComponent('${encodedFilterSets}')));
        }
    });

</script>

<div id="rowTemplate" type="x-tmpl-mustache" style="display: none;">
    {{ #row }}
    <div class="row">
        <div class="col-md-4 col-sm-4 col-xs-4 dk-variant-search-builder-title">
            {{ translatedName }}
        </div>

        <div class="col-md-5 col-sm-5 col-xs-5 dk-variant-search-builder-ui">
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

        <div class="col-md-3 col-sm-3 col-xs-3 dk-variant-search-builder-description">
            {{ helpText }}
        </div>
    </div>
    {{ /row }}
</div>


<div id="main">

    <div class="container">

        <div class="variantWF-container">
            <h1><g:message code="variantSearch.workflow.header.title" default="Variant Finder"/></h1>
            <p><g:message code="variantSearch.workflow.header.find_variants"/></p>

            <!-- tabs -->
            <ul class="nav nav-tabs" role="tablist">
                <li role="presentation" class="active" ><a href="#dependent" aria-controls="dependent" role="tab"
                                                           id="dependentTab"
                                                           data-toggle="tab">Phenotype-dependent</a></li>
                <li role="presentation"><a href="#independent" aria-controls="independent" role="tab"
                                           id="independentTab"
                                           data-toggle="tab">Phenotype-independent</a></li>
            </ul>

            <!-- content -->
            <div class="tab-content">
            <div role="tabpanel" class="tab-pane active" id="dependent">
                <div class="dk-fluid">
                    <div class="dk-variant-search-builder">
                        <div style="padding: 10px 0;">
                            <div class="row">
                                <div class="col-md-4 col-sm-4 col-xs-4 dk-variant-search-builder-title">
                                    <g:message code="searchBuilder.traitOrDisease.prompt"
                                               default="Trait or disease of interest"/>
                                </div>

                                <div class="col-md-5 col-sm-5 col-xs-5 dk-variant-search-builder-ui">
                                    <select id="phenotype" class="form-control" disabled
                                            onchange="mpgSoftware.firstResponders.respondToPhenotypeSelection()"></select>
                                </div>

                                <div class="col-md-3 col-sm-3 col-xs-3 dk-variant-search-builder-description">
                                    <g:message code="variantSearch.wfRequest.phenotype.help.text"
                                               default="Choose a phenotype to act as the basis of a search"/>
                                </div>
                            </div>

                            <div id="datasetChooserDependent" class="row">
                                <div class="col-md-4 col-sm-4 col-xs-4 dk-variant-search-builder-title">
                                    <g:message code="searchBuilder.dataset.prompt" default="Data set"/>
                                </div>

                                <div class="col-md-5 col-sm-5 col-xs-5 dk-variant-search-builder-ui">
                                    <select id="datasetDependent" class="form-control" disabled
                                            onchange="mpgSoftware.firstResponders.respondToDataSetSelection('dependent')"></select>
                                </div>

                                <div class="col-md-3 col-sm-3 col-xs-3 dk-variant-search-builder-description">
                                    <g:message code="variantSearch.wfRequest.dataSet.help.text"
                                               default="Choose a data set from which variants may be found"/>
                                </div>
                            </div>

                            <div id="dependentRowTarget"></div>

                        </div>

                        <div class="row dk-submit-btn-wrapper">
                            <button id="buildSearchRequestDependent" class="btn btn-sm btn-primary dk-search-btn-inactive"
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
                        %{--<div class="">--}%
                            <div id="datasetChooserIndependent" class="row">
                                <div class="col-md-4 col-sm-4 col-xs-4 dk-variant-search-builder-title">
                                    <g:message code="searchBuilder.dataset.prompt" default="Data set"/>
                                </div>

                                <div class="col-md-5 col-sm-5 col-xs-5 dk-variant-search-builder-ui">
                                    <select id="datasetIndependent" class="form-control"
                                            onchange="mpgSoftware.firstResponders.respondToDataSetSelection('independent')"></select>
                                </div>

                                <div class="col-md-3 col-sm-3 col-xs-3 dk-variant-search-builder-description">
                                    <g:message code="variantSearch.wfRequest.dataSet.help.text"
                                               default="Choose a data set from which variants may be found"/>
                                </div>
                            </div>
                            <div id="independentRowTarget"></div>
                        %{--</div>--}%
                        <div class="row">
                            <div id="chromosomeInputHolder" class="col-md-7 col-sm-7 col-xs-7">
                                <label><g:message code="variantSearch.restrictToRegion.gene"/></label>

                                <div class="form-inline">
                                    <input id="geneInput" type="text" class="form-control"
                                           style="width:65%;"
                                           placeholder="gene" data-type="advancedFilterInput"
                                           data-prop="gene" data-translatedname="gene"
                                           oninput="mpgSoftware.firstResponders.updateBuildSearchRequestButton('independent');
                                           mpgSoftware.firstResponders.controlGeneAndChromosomeInputs();
                                           ">
                                    <label style="font-size: 20px; font-weight: 100;">&nbsp; &#177 &nbsp;</label>
                                    <input type="number" id="geneRangeInput" class="form-control"
                                           style="width:20%;"/>
                                </div>

                                <div class="text-center" style="color:#f70; padding: 10px 0 10px 0;">
                                    &#8212; or &#8212;
                                </div>
                                <label><g:message code="variantSearch.restrictToRegion.region"/></label>
                                <input id="chromosomeInput" type="text" class="form-control"
                                       placeholder="chromosome: start - stop"
                                       data-type="advancedFilterInput"
                                       data-prop="chromosome" data-translatedname="chromosome"
                                       oninput="
                                           mpgSoftware.firstResponders.updateBuildSearchRequestButton('independent');
                                           mpgSoftware.firstResponders.validateChromosomeInput();
                                           mpgSoftware.firstResponders.controlGeneAndChromosomeInputs();
                                       ">
                            </div>

                            <div class="col-md-3 col-sm-3 col-xs-3">
                                <div class="radio">
                                    <label>
                                        <input type="radio" name="predictedEffects"
                                               value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_ALL_CODE}"
                                               onclick="mpgSoftware.firstResponders.updateProteinEffectSelection(${PortalConstants.PROTEIN_PREDICTION_EFFECT_ALL_CODE})">
                                        <g:message code="variantSearch.proteinEffectRestrictions.allEffects"
                                                   default="all effects"/>
                                    </label>
                                </div>

                                <div class="radio">
                                    <label>
                                        <input type="radio" name="predictedEffects"
                                               value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_PTV_CODE}"
                                               onclick="mpgSoftware.firstResponders.updateProteinEffectSelection(${PortalConstants.PROTEIN_PREDICTION_EFFECT_PTV_CODE})">
                                        <g:message
                                                code="variantSearch.proteinEffectRestrictions.proteinTruncating"
                                                default="protein-truncating"/>
                                    </label>
                                </div>

                                <div class="radio">
                                    <label>
                                        <input type="radio" name="predictedEffects"
                                               value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_MISSENSE_CODE}"
                                               onclick="mpgSoftware.firstResponders.updateProteinEffectSelection(${PortalConstants.PROTEIN_PREDICTION_EFFECT_MISSENSE_CODE})">
                                        <g:message code="variantSearch.proteinEffectRestrictions.missense"
                                                   default="missense"/>
                                    </label>
                                </div>

                                <div class="radio">
                                    <label>
                                        <input type="radio" name="predictedEffects"
                                               value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_SYNONYMOUS_CODE}"
                                               onclick="mpgSoftware.firstResponders.updateProteinEffectSelection(${PortalConstants.PROTEIN_PREDICTION_EFFECT_SYNONYMOUS_CODE})">
                                        <g:message
                                                code="variantSearch.proteinEffectRestrictions.synonymousCoding"
                                                default="no effect (synonymous coding)"/>
                                    </label>
                                </div>

                                <div class="radio">
                                    <label>
                                        <input type="radio" name="predictedEffects"
                                               value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_NONCODING_CODE}"
                                               onclick="mpgSoftware.firstResponders.updateProteinEffectSelection(${PortalConstants.PROTEIN_PREDICTION_EFFECT_NONCODING_CODE})">
                                        <g:message code="variantSearch.proteinEffectRestrictions.noncoding"
                                                   default="no effect (non-coding)"/>
                                    </label>
                                </div>
                            </div>

                            <div id="missense-options"
                                 class="col-md-2 col-sm-2 col-xs-2 missense-options"
                                 style="display: none">
                                <div class="form-group form-group-sm">
                                    <label><g:message
                                            code="variantSearch.proteinEffectRestrictions.missense.polyphen"
                                            default="PolyPhen-2 prediction"/></label>
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
                                </div>

                                <div class="form-group form-group-sm">
                                    <label><g:message
                                            code="variantSearch.proteinEffectRestrictions.missense.sift"
                                            default="SIFT prediction"/></label>
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
                                </div>

                                <div class="form-group form-group-sm">
                                    <label><g:message
                                            code="variantSearch.proteinEffectRestrictions.missense.condel"
                                            default="CONDEL prediction"/></label>
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

                                </div>
                            </div>
                        </div>


                        <div class="row">
                            <div class="col-md-12 col-sm-12 col-xs-12 text-right">
                                <button class="btn btn-default btn-sm btn-success"
                                        onclick="mpgSoftware.variantWF.resetInputFields()">
                                    <g:message code="variantSearch.spec.actions.reset_adv_filter"
                                               default="Reset"/>
                                </button>
                                <button id="buildSearchRequestIndependent" class="btn btn-sm btn-primary dk-search-btn-inactive"
                                        onclick="mpgSoftware.variantWF.gatherCurrentQueryAndSave('independent')" disabled>
                                    <g:message code="variantSearch.spec.actions.build_req"
                                               default="Build search request"/>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div id="searchDetailsHolder" class="dk-variant-submit-search"></div>

            <script id="searchDetailsTemplate" type="x-tmpl-mustache">
                <h6><g:message code="variantSearch.actions.submit_search" default="Submit search request"/></h6>
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
                            {{ translatedPhenotype }} {{ #translatedDataset }} [{{ translatedDataset }}] {{ /translatedDataset }} {{ translatedName }} {{ comparator }} {{ displayValue }}<br>
                        </td>
                        <td><a onclick="mpgSoftware.variantWF.editQuery({{ index }})"><g:message
                                code="variantSearch.spec.actions.edit" default="Edit"/></a></td>
                        <td><a onclick="mpgSoftware.variantWF.deleteQuery({{ index }})"><g:message
                                code="variantSearch.spec.actions.delete" default="Delete"/></a></td>
                    </tr>
                    {{ /listOfSavedQueries }}
                    </tbody>
                </table>

                <div class="row dk-submit-btn-wrapper">
                    {{ #shouldSubmitBeEnabled }}
                    <button class="btn btn-sm btn-primary" onclick="mpgSoftware.variantWF.launchAVariantSearch()">
                        <g:message code="variantSearch.actions.submit_search" default="Submit search request"/>
                    </button>
                    {{ /shouldSubmitBeEnabled }}
                    {{ ^shouldSubmitBeEnabled }}
                    <button class="btn btn-sm btn-primary dk-search-btn-inactive" disabled>
                        <g:message code="variantSearch.actions.submit_search" default="Submit search request"/>
                    </button>
                    {{ /shouldSubmitBeEnabled }}
                </div>
            </script>
        </div>
    </div>
</div>

</div>
</body>
</html>

