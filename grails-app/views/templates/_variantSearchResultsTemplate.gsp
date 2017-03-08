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
<div id="propertiesInputsTemplate" type="x-tmpl-mustache" style="display: none;">
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
</div>
<div id="commonPropertiesInputsTemplate" type="x-tmpl-mustache" style="display: none;">
    <div role="tabpanel" class="tab-pane" id="commonPropertiesSelection">

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
</div>
<script id="dataModalTemplate"  type="x-tmpl-mustache">
<div class="modal fade" id="dataModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><g:message code="variantSearch.results.modal.title" /></h4>
                <p><g:message code="variantSearch.results.modal.subtitle" /></p>
            </div>
            <div class="modal-body">
                <ul class="list-unstyled dk-modal-list">
                    <li><a href="#" data-toggle="modal" data-target="#phenotypeModal" data-dismiss="modal"><g:message code="variantSearch.results.modal.addSubPheno" /></a></li>
                    <li><a href="#" data-toggle="modal" data-target="#datasetModal" data-dismiss="modal"><g:message code="variantSearch.results.modal.addSubDatasets" /></a></li>
                    <li><a href="#" data-toggle="modal" data-target="#propertiesModal" data-dismiss="modal"><g:message code="variantSearch.results.modal.addSubProps" /></a></li>
                </ul>
            </div>
            <div class="modal-footer dk-modal-footer">
                <button type="button" class="btn btn-warning" data-dismiss="modal"><g:message code="variantSearch.results.modal.cancel" /></button>
            </div>
        </div>
    </div>
</div>

<!-- Phenotype Modal- -->
<div class="modal fade" id="phenotypeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
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
                        <li role="presentation" class="active"><a href="#subtract_phenotype" aria-controls="subtract_phenotype" role="tab" data-toggle="tab"><g:message code="variantSearch.results.modal.subPheno" /></a></li>
                        <li role="presentation"><a href="#add_phenotype" aria-controls="add_phenotype" role="tab" data-toggle="tab"><g:message code="variantSearch.results.modal.addPheno" /></a></li>
                    </ul>

                    <!-- Tab panes -->
                    <div class="tab-content">
                        <div role="tabpanel" class="tab-pane active" id="subtract_phenotype">
                            <form class="dk-modal-form">
                                <div id="subtractPhenotypesCheckboxes" class="dk-modal-form-input-group">
                                </div>
                                <button type="button" class="btn btn-sm btn-primary" data-dismiss="modal" onclick="mpgSoftware.variantSearchResults.confirmAddingProperties('phenotype',domSelectors)"><g:message code="variantSearch.results.modal.confirm" /></button>
                                <button type="button" class="btn btn-sm btn-warning" data-dismiss="modal"><g:message code="variantSearch.results.modal.cancel" /></button>

                            </form>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="add_phenotype">
                            <form class="dk-modal-form">
                                <div class="dk-modal-form-input-group">
                                    <div class="dk-modal-form-input-row">
                                        <div class="dk-variant-search-builder-title">
                                            <g:message code="searchBuilder.traitOrDisease.prompt" />
                                        </div>
                                        <div class="dk-variant-search-builder-ui">
                                            <select id="phenotypeAddition" class="form-control" onchange="mpgSoftware.variantSearchResults.phenotypeSelected(domSelectors)">
                                            </select>
                                        </div>
                                    </div>

                                    <div class="dk-modal-form-input-row">
                                        <div class="dk-variant-search-builder-title">
                                            <g:message code="searchBuilder.dataset.prompt" />
                                        </div>
                                        <div class="dk-variant-search-builder-ui">
                                            <select id="phenotypeAdditionDataset" class="form-control" onchange="mpgSoftware.variantSearchResults.datasetSelected(domSelectors)">
                                            </select>
                                        </div>
                                    </div>

                                    <div id="phenotypeCohorts" class="dk-modal-form-input-row" style="display: none;">
                                        <div class="dk-variant-search-builder-title">
                                            <g:message code="variantSearch.results.modal.cohortOptional" />
                                        </div>
                                        <div class="dk-variant-search-builder-ui">
                                            <select id="phenotypeAdditionCohort" class="form-control" style="max-width: 300px;">
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <button type="button" class="btn btn-sm btn-primary" data-dismiss="modal" onclick="mpgSoftware.variantSearchResults.confirmAddingProperties('phenotype',domSelectors)"><g:message code="variantSearch.results.modal.confirm" /></button>
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
<div class="modal fade" id="datasetModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><g:message code="variantSearch.results.modal.addSubDatasets" /></h4>
                <p><g:message code="variantSearch.results.modal.addSubDatasets.subtitle" /></p>
            </div>
            <div class="modal-body">

                <!-- Nav tabs -->
                <ul id="datasetTabList" class="nav nav-tabs" role="tablist">
                </ul>

                <!-- Tab panes -->
                <div id="datasetSelections" class="tab-content">
                </div>
                <div class="modal-footer dk-modal-footer">
                    <button type="button" class="btn btn-sm btn-primary" data-dismiss="modal" onclick="mpgSoftware.variantSearchResults.confirmAddingProperties('datasets',domSelectors)"><g:message code="variantSearch.results.modal.confirm" /></button>
                    <button type="button" class="btn btn-sm btn-warning" data-dismiss="modal"><g:message code="variantSearch.results.modal.cancel" /></button>
                </div>
            </div>
        </div>
    </div>
</div>


<!-- properties Modal- -->
<div class="modal fade" id="propertiesModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><g:message code="variantSearch.results.modal.addSubProps" /></h4>
                <p><g:message code="variantSearch.results.modal.addSubProps.subtitle" /></p>
            </div>
            <div class="modal-body">

                <!-- Nav tabs -->
                <ul id="propertiesTabList" class="nav nav-tabs" role="tablist">
                </ul>

                <!-- Tab panes -->
                <div id="propertiesTabPanes" class="tab-content">
                </div>


            </div>
            <!-- modal body ends -->
            <div class="modal-footer dk-modal-footer">
                <button type="button" class="btn btn-sm btn-primary" data-dismiss="modal" onclick="mpgSoftware.variantSearchResults.confirmAddingProperties('properties',domSelectors)"><g:message code="variantSearch.results.modal.confirm" /></button>
                <button type="button" class="btn btn-sm btn-warning" data-dismiss="modal"><g:message code="variantSearch.results.modal.cancel" /></button>
            </div>
        </div>
    </div>
</div>
</script>
<script id="dataRegionTemplate"  type="x-tmpl-mustache">
    <g:message code="variantTable.regionSummary.regionContains" default="This region contains the following genes:"/>
<div class="row clearfix" style="margin:5px 0 5px 0">
    <div class="col-md-6" style="text-align: left; max-height: 200px; overflow-y: auto">
        <ul id="geneNames">
            {{#geneNamesToDisplay}}
                <li><a class="genelink" href="<g:createLink controller='gene'
                                                            action='geneInfo'/>/{{name}}">{{name}}</a>
                </li>
            {{/geneNamesToDisplay}}
        </ul>
    </div>

    <div class="col-md-6" style="text-align: right; vertical-align: middle">
        <a class="boldlink pull-right"
           href="<g:createLink controller="trait" action="regionInfo"/>/{{regionSpecification}}">
            <g:message code="variantTable.regionSummary.clickForGwasSummary" default="Click here"/></a>
    </div>
</div>
</script>

