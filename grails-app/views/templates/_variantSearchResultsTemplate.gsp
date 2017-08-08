<script id="variantSearchResultsTemplate"  type="x-tmpl-mustache">
    <table id="{{variantTableResults}}" class="table table-striped dk-search-result" style="border-collapse: collapse; width: 100%;">
        <thead>
        <tr id="{{variantTableHeaderRow}}">
            <th colspan=5 class="datatype-header dk-common"/>
        </tr>
        <tr id="{{variantTableHeaderRow2}}">
            <th colspan=5 class="datatype-header dk-common"><g:message code="variantTable.columnHeaders.commonProperties"/></th>
        </tr>
        <tr id="{{variantTableHeaderRow3}}">
        </tr>
        </thead>
        <tbody id="{{variantTableBody}}" role="alert" aria-live="polite" aria-relevant="all">
        </tbody>
    </table>
</script>
<script id="propertiesInputsTemplate" type="x-tmpl-mustache" style="display: none;">
    <div role="tabpanel" class="tab-pane {{ active }}" id="{{ phenotype }}PropertiesSelection">
        <form class="dk-modal-form">
            <div class="dk-modal-form-input-group">
                <div class="dk-modal-form-input-row">
                    <div class="dk-variant-search-builder-ui">
                        <h5><g:message code="searchBuilder.dataset.prompt" /></h5>
                        {{ #datasets }}
                        <div class="radio" >
                            <label>
                                <input type="radio" name="dataset" value="{{ name }}"
                                       onclick="mpgSoftware.variantSearchResults.displayPropertiesForDataset('{{name}}')"
                                />{{ displayName }}
                            </label>
                        </div>
                        {{ /datasets }}
                    </div>
                    <div class="dk-variant-search-builder-ui">
                        <h5><g:message code="variantSearch.results.modal.props" /></h5>
                        {{ #propertiesGroup }}
                        <div data-dataset="{{ dataset }}" style="display: none;">
                            {{ #properties }}
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox" {{checked}} value="{{ name }}" {{disabled}} data-category="{{ category }}" /> {{ displayName }}
                                </label>
                            </div>
                            {{ /properties }}
                        </div>
                        {{ /propertiesGroup }}
                    </div>
                </div>
            </div>
        </form>
    </div>
</script>
<script id="commonPropertiesInputsTemplate" type="x-tmpl-mustache" style="display: none;">
    <div role="tabpanel" class="tab-pane commonPropertiesSelection">

        <form class="dk-modal-form">
            <h4><g:message code="variantSearch.results.modal.availableCommonProps" /></h4>
            <div class="dk-modal-form-input-group">
                {{ #properties }}
                <div class="checkbox">
                    <label>
                        <input type="checkbox" {{checked}} value="{{ name }}" data-category="{{ category }}" /> {{ displayName }}
                    </label>
                </div>
                {{ /properties }}
            </div>
        </form>
    </div>
</script>
<script id="topOfVariantResultsPageTemplate" type="x-tmpl-mustache" style="display: none;">
    <div style="text-align: right;">
        <a href="https://s3.amazonaws.com/broad-portal-resources/Variant_results_table_guide" target="_blank">
            <g:message code="variantSearch.results.helpText" />
        </a>
    </div>
    <div>
        {{{linkBackToSearchDefinitionPage}}}
            <button class="btn btn-primary btn-xs">
            &laquo; <g:message code="variantTable.searchResults.backToSearchPage" />
            </button></a>
        <g:message code="variantTable.searchResults.editCriteria" />
    </div>
    <div style="margin-top: 5px;">
        <a href="#" onclick="mpgSoftware.variantSearchResults.saveLink(undefined,'{{uniqueRoot}}')">Click here to copy the current search URL to the clipboard</a>
        <input type="text" id="{{linkToSave}}" style="display: none; margin-left: 5px; width: 500px;" />
    </div>
</script>

%{--I do not yet understand why the following template fails, but the following one works.  Very strange.  What's wrong with using a table?--}%
<script id="variantResultsFilterHolderTemplateOldway" type="x-tmpl-mustache" style="display: none;">
    <table class="table table-striped dk-search-collection">
        <tbody>
        {{#translatedFilters}}
            <tr>
                <td>{{name}}</td>
            </tr>
        {{/translatedFilters}}
        </tbody>
    </table>
</script>
<script id="variantResultsFilterHolderTemplate" type="x-tmpl-mustache" style="display: none;">
    <ul style="list-style-type: none;">
        {{ #translatedFilters }}
            <li>{{{name}}}
        {{ /translatedFilters }}
    </ul>
</script>


<script id="variantResultsMainStructuralTemplate" type="x-tmpl-mustache" style="display: none;">

    <div class="container dk-t2d-back-to-search"></div>

    {{#variantResultsTableHeader}}
    <div class="container dk-t2d-content">

        <h1><g:message code="variantTable.searchResults.title" default="Variant search results"/></h1>

        <h3><g:message code="variantTable.searchResults.searchCriteriaHeader" default="Search criteria"/></h3>

        <div class="variantResultsFilterHolder"></div>

        <div class="regionDescr"></div>

        <p><em><g:message code="variantTable.searchResults.oddsRatiosUnreliable" default="odds ratios unreliable" /></em></p>
        <p><g:message code="variantTable.searchResults.guide" default="variant results table guide" /></p>

    </div>


    <div class="container dk-variant-table-header">
        <div class="row">
            <div class="text-right">
                <button class="btn btn-primary btn-xs" style="margin-bottom: 5px;" data-toggle="modal" data-target="#{{dataModal}}">Add / Subtract Data</button>
            </div>
        </div>
    </div>
    <hr />
    {{/variantResultsTableHeader}}
    {{^variantResultsTableHeader}}
        <div class="text-left">
            <button class="btn btn-primary btn-xs" style="margin-bottom: 5px;" data-toggle="modal" data-target="#{{dataModal}}">Add / Subtract Data</button>
        </div>
    {{/variantResultsTableHeader}}


    <div id="{{holderForVariantSearchResults}}" class="container-fluid" ></div>

    <div id="{{dataModalGoesHere}}"></div>

</script>



<script id="dataModalTemplate"  type="x-tmpl-mustache">
    <div class="modal fade" id="{{dataModal}}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><g:message code="variantSearch.results.modal.title" /></h4>
                    <p><g:message code="variantSearch.results.modal.subtitle" /></p>
                </div>
                <div class="modal-body">
                    <ul class="list-unstyled dk-modal-list">
                        {{#chooseAdSubtractPhenotype}}
                        <li><a href="#" data-toggle="modal" data-target="#{{phenotypeModal}}" data-dismiss="modal"><g:message code="variantSearch.results.modal.addSubPheno" /></a></li>
                        {{/chooseAdSubtractPhenotype}}
                        {{#chooseAdSubtractDataSets}}
                        <li><a href="#" data-toggle="modal" data-target="#{{datasetModal}}" data-dismiss="modal"><g:message code="variantSearch.results.modal.addSubDatasets" /></a></li>
                        {{/chooseAdSubtractDataSets}}
                        {{#chooseAdSubtractCommonProperties}}
                        <li><a href="#" data-toggle="modal" data-target="#{{propertiesModal}}" data-dismiss="modal"><g:message code="variantSearch.results.modal.addSubProps" /></a></li>
                        {{/chooseAdSubtractCommonProperties}}
                    </ul>
                </div>
                <div class="modal-footer dk-modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal"><g:message code="variantSearch.results.modal.cancel" /></button>
                </div>
            </div>
        </div>
    </div>

    <!-- Phenotype Modal- -->
    <div class="modal fade" id="{{phenotypeModal}}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><g:message code="variantSearch.results.modal.addSubPheno" /></h4>
                    <p><g:message code="variantSearch.results.modal.addSubPheno.subtitle" /></p>
                </div>
                <div class="modal-body">
                    <div>

                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs" role="tablist">
                            <li role="presentation" class="active"><a href="#{{subtract_phenotype}}" aria-controls="{{subtract_phenotype}}" role="tab" data-toggle="tab"><g:message code="variantSearch.results.modal.subPheno" /></a></li>
                            <li role="presentation"><a href="#{{add_phenotype}}" aria-controls="{{add_phenotype}}" role="tab" data-toggle="tab"><g:message code="variantSearch.results.modal.addPheno" /></a></li>
                        </ul>

                        <!-- Tab panes -->
                        <div class="tab-content">
                            <div role="tabpanel" class="tab-pane active" id="{{subtract_phenotype}}">
                                <form class="dk-modal-form">
                                    <div id="{{subtractPhenotypesCheckboxes}}" class="dk-modal-form-input-group">
                                    </div>
                                    <button type="button" class="btn btn-sm btn-primary" data-dismiss="modal" onclick="mpgSoftware.variantSearchResults.confirmAddingProperties('phenotype',undefined,'{{uniqueRoot}}')"><g:message code="variantSearch.results.modal.confirm" /></button>
                                    <button type="button" class="btn btn-sm btn-warning" data-dismiss="modal"><g:message code="variantSearch.results.modal.cancel" /></button>

                                </form>
                            </div>
                            <div role="tabpanel" class="tab-pane" id="{{add_phenotype}}">
                                <form class="dk-modal-form">
                                    <div class="dk-modal-form-input-group">
                                        <div class="dk-modal-form-input-row">
                                            <div class="dk-variant-search-builder-title">
                                                <g:message code="searchBuilder.traitOrDisease.prompt" />
                                            </div>
                                            <div class="dk-variant-search-builder-ui">
                                                <select id="{{phenotypeAddition}}" class="form-control" onchange="mpgSoftware.variantSearchResults.phenotypeSelected(undefined,'{{uniqueRoot}}')">
                                                </select>
                                            </div>
                                        </div>

                                        <div class="dk-modal-form-input-row">
                                            <div class="dk-variant-search-builder-title">
                                                <g:message code="searchBuilder.dataset.prompt" />
                                            </div>
                                            <div class="dk-variant-search-builder-ui">
                                                <select id="{{phenotypeAdditionDataset}}" class="form-control" onchange="mpgSoftware.variantSearchResults.datasetSelected(undefined,'{{uniqueRoot}}')">
                                                </select>
                                            </div>
                                        </div>

                                        <div id="{{phenotypeCohorts}}" class="dk-modal-form-input-row" style="display: none;">
                                            <div class="dk-variant-search-builder-title">
                                                <g:message code="variantSearch.results.modal.cohortOptional" />
                                            </div>
                                            <div class="dk-variant-search-builder-ui">
                                                <select id="{{phenotypeAdditionCohort}}" class="form-control" style="max-width: 300px;">
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <button type="button" class="btn btn-sm btn-primary" data-dismiss="modal" onclick="mpgSoftware.variantSearchResults.confirmAddingProperties('phenotype',undefined,'{{uniqueRoot}}')"><g:message code="variantSearch.results.modal.confirm" /></button>
                                    <button type="button" class="btn btn-sm btn-warning" data-dismiss="modal"><g:message code="variantSearch.results.modal.cancel" /></button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!--dataset Modal- -->
    <div class="modal fade" id="{{datasetModal}}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><g:message code="variantSearch.results.modal.addSubDatasets" /></h4>
                    <p><g:message code="variantSearch.results.modal.addSubDatasets.subtitle" /></p>
                </div>
                <div class="modal-body">

                    <!-- Nav tabs -->
                    <ul id="{{datasetTabList}}" class="nav nav-tabs" role="tablist">
                    </ul>

                    <!-- Tab panes -->
                    <div id="{{datasetSelections}}" class="tab-content">
                    </div>
                    <div class="modal-footer dk-modal-footer">
                        <button type="button" class="btn btn-sm btn-primary" data-dismiss="modal" onclick="mpgSoftware.variantSearchResults.confirmAddingProperties('datasets',undefined,'{{uniqueRoot}}')"><g:message code="variantSearch.results.modal.confirm" /></button>
                        <button type="button" class="btn btn-sm btn-warning" data-dismiss="modal"><g:message code="variantSearch.results.modal.cancel" /></button>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <!-- properties Modal- -->
    <div class="modal fade" id="{{propertiesModal}}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><g:message code="variantSearch.results.modal.addSubProps" /></h4>
                    <p><g:message code="variantSearch.results.modal.addSubProps.subtitle" /></p>
                </div>
                <div class="modal-body">

                    <!-- Nav tabs -->
                    <ul id="{{propertiesTabList}}" class="nav nav-tabs" role="tablist">
                    </ul>

                    <!-- Tab panes -->
                    <div id="{{propertiesTabPanes}}" class="tab-content">
                    </div>


                </div>
                <!-- modal body ends -->
                <div class="modal-footer dk-modal-footer">
                {{#returnToTheVariantResultsTable}}
                    <button type="button" class="btn btn-sm btn-primary" data-dismiss="modal" onclick="mpgSoftware.variantSearchResults.confirmAddingProperties('properties',undefined,'{{uniqueRoot}}')"><g:message code="variantSearch.results.modal.confirm" /></button>
                {{/returnToTheVariantResultsTable}}
                {{^returnToTheVariantResultsTable}}
                <button type="button" class="btn btn-sm btn-primary confirmPropertyChange" data-dismiss="modal" onclick="mpgSoftware.geneSignalSummaryMethods.updateGenePageTables(undefined,'{{uniqueRoot}}')"><g:message code="variantSearch.results.modal.confirm" /></button>
                {{/returnToTheVariantResultsTable}}
                   <button type="button" class="btn btn-sm btn-warning" data-dismiss="modal"><g:message code="variantSearch.results.modal.cancel" /></button>
                </div>
            </div>
        </div>
    </div>
</script>
<script id="dataRegionTemplate"  type="x-tmpl-mustache">
    {{#supressTitle}}
    {{/supressTitle}}
    {{^supressTitle}}
    <g:message code="variantTable.regionSummary.regionContains" default="This region contains the following genes:"/>
    {{/supressTitle}}
<div class="row clearfix" style="margin:5px 0 5px 0">
    <div class="col-md-6" style="text-align: left; max-height: 200px; overflow-y: auto; padding-left:0">
        <ul id="geneNames">
            {{#namedGeneArray}}
                <li><a class="genelink" href="<g:createLink controller='gene'
                                                            action='geneInfo'/>/{{name}}">{{name}}</a>
                </li>
            {{/namedGeneArray}}
        </ul>
    </div>

    <div class="col-md-6" style="text-align: right; vertical-align: middle; display:none">
        <a class="boldlink pull-right"
           href="<g:createLink controller="trait" action="regionInfo"/>/{{regionSpecification}}">
            <g:message code="variantTable.regionSummary.clickForGwasSummary" default="Click here"/></a>
    </div>
</div>
</script>

