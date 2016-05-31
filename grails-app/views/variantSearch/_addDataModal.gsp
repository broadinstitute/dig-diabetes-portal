<!-- Modal- -->
<div class="modal fade" id="dataModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="dataModalLabel">Add/Subtract</h4>
            </div>
            <div class="modal-body">
                <ul class="list-unstyled dk-modal-list">
                    %{--<li><a href="#" data-toggle="modal" data-target="#phenotypeModal" data-dismiss="modal">Add / Subtract Phenotypes</a></li>--}%
                    <li><a href="#" data-toggle="modal" data-target="#datasetModal" data-dismiss="modal">Add / Subtract Data set</a></li>
                    <li><a href="#" data-toggle="modal" data-target="#propertiesModal" data-dismiss="modal">Add / Subtract Properties</a></li>
                </ul>
            </div>
            <div class="modal-footer dk-modal-footer">
                <button type="button" class="btn btn-warning" data-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>

<!-- Phenotype Modal- -->
%{--<div class="modal fade" id="phenotypeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">--}%
    %{--<div class="modal-dialog" role="document">--}%
        %{--<div class="modal-content">--}%
            %{--<div class="modal-header">--}%
                %{--<h4 class="modal-title" id="dataModalLabel">Add/Subtract Phenotype</h4>--}%
            %{--</div>--}%
            %{--<div class="modal-body">--}%
                %{--<div>--}%

                    %{--<!-- Nav tabs -->--}%
                    %{--<ul class="nav nav-tabs" role="tablist">--}%
                        %{--<li role="presentation" class="active"><a href="#subtract_phenotype" aria-controls="subtract_phenotype" role="tab" data-toggle="tab">Subtract Phenotype</a></li>--}%
                        %{--<li role="presentation"><a href="#add_phenotype" aria-controls="add_phenotype" role="tab" data-toggle="tab">Add Phenotype</a></li>--}%
                    %{--</ul>--}%

                    %{--<!-- Tab panes -->--}%
                    %{--<div class="tab-content">--}%
                        %{--<div role="tabpanel" class="tab-pane active" id="subtract_phenotype">--}%
                            %{--<form class="dk-modal-form">--}%
                                %{--<div id="subtractPhenotypeSelectors" class="dk-modal-form-input-group">--}%
                                %{--</div>--}%
                                %{--<button type="button" class="btn btn-sm btn-primary" data-dismiss="modal">Confirm</button>--}%
                                %{--<button type="button" class="btn btn-sm btn-warning" data-dismiss="modal">Cancel</button>--}%
                            %{--</form>--}%
                        %{--</div>--}%
                        %{--<div role="tabpanel" class="tab-pane" id="add_phenotype">--}%
                            %{--<form class="dk-modal-form">--}%
                                %{--<div class="dk-modal-form-input-group">--}%
                                    %{--<div class="dk-modal-form-input-row">--}%
                                        %{--<div class="dk-variant-search-builder-title">--}%
                                            %{--Trait or disease of interest--}%
                                        %{--</div>--}%
                                        %{--<div class="dk-variant-search-builder-ui">--}%
                                            %{--<select class="form-control">--}%
                                                %{--<option selected hidden>Select a phenotype</option>--}%
                                                %{--<option>type 2 diabetes</option>--}%
                                                %{--<option>HbA1c</option>--}%
                                                %{--<option>fasting glucose</option>--}%
                                                %{--<option>two-hour glucose</option>--}%
                                                %{--<option>HOMA-B</option>--}%
                                            %{--</select>--}%
                                        %{--</div>--}%
                                    %{--</div>--}%

                                    %{--<div class="dk-modal-form-input-row">--}%
                                        %{--<div class="dk-variant-search-builder-title">--}%
                                            %{--Data set--}%
                                        %{--</div>--}%
                                        %{--<div class="dk-variant-search-builder-ui">--}%
                                            %{--<select class="form-control">--}%
                                                %{--<option selected hidden>Select a data set</option>--}%
                                                %{--<option>DIAGRAM GWAS</option>--}%
                                                %{--<option>GWAS GIGMA</option>--}%
                                                %{--<option>82K exome chip analysis</option>--}%
                                            %{--</select>--}%
                                        %{--</div>--}%
                                    %{--</div>--}%

                                    %{--<div class="dk-modal-form-input-row">--}%
                                        %{--<div class="dk-variant-search-builder-title">--}%
                                            %{--P-value--}%
                                        %{--</div>--}%
                                        %{--<div class="dk-variant-search-builder-ui">--}%
                                            %{--<div class="col-md-3 col-sm-3 col-xs-3">--}%
                                                %{--<select class="form-control">--}%
                                                    %{--<option>&lt;</option>--}%
                                                    %{--<option>&gt;</option>--}%
                                                    %{--<option>=</option>--}%
                                                %{--</select>--}%
                                            %{--</div>--}%

                                            %{--<div class="col-md-8 col-sm-8 col-xs-8 col-md-offset-1 col-sm-offset-1 col-xs-offset-1">--}%
                                                %{--<input type="text" class="form-control">--}%
                                            %{--</div>--}%
                                        %{--</div>--}%
                                    %{--</div>--}%

                                    %{--<div class="dk-modal-form-input-row">--}%
                                        %{--<div class="dk-variant-search-builder-title">--}%
                                            %{--Odds ratio--}%
                                        %{--</div>--}%
                                        %{--<div class="dk-variant-search-builder-ui">--}%
                                            %{--<div class="col-md-3 col-sm-3 col-xs-3">--}%
                                                %{--<select class="form-control">--}%
                                                    %{--<option>&lt;</option>--}%
                                                    %{--<option>&gt;</option>--}%
                                                    %{--<option>=</option>--}%
                                                %{--</select>--}%
                                            %{--</div>--}%

                                            %{--<div class="col-md-8 col-sm-8 col-xs-8 col-md-offset-1 col-sm-offset-1 col-xs-offset-1">--}%
                                                %{--<input type="text" class="form-control">--}%
                                            %{--</div>--}%
                                        %{--</div>--}%
                                    %{--</div>--}%
                                %{--</div>--}%
                                %{--<button type="button" class="btn btn-sm btn-primary" data-dismiss="modal">Confirm </button>--}%
                                %{--<button type="button" class="btn btn-sm btn-success" data-toggle="modal" data-target="#datasetModal" data-dismiss="modal">Confirm & add more data set</button>--}%
                                %{--<button type="button" class="btn btn-sm btn-warning" data-dismiss="modal">Cancel</button>--}%
                            %{--</form>--}%
                        %{--</div>--}%
                    %{--</div>--}%

                %{--</div>--}%
            %{--</div>--}%
        %{--</div>--}%
    %{--</div>--}%
%{--</div>--}%

<!--dataset Modal- -->
<div class="modal fade" id="datasetModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="dataModalLabel">Add/Subtract Data sets</h4>
            </div>
            <div class="modal-body">

                <!-- Nav tabs -->
                <ul id="datasetTabList" class="nav nav-tabs" role="tablist">
                </ul>

                <!-- Tab panes -->
                <div id="datasetSelections" class="tab-content">
                </div>
                <div class="modal-footer dk-modal-footer">
                    <button type="button" class="btn btn-sm btn-primary" data-dismiss="modal" onclick="confirmAddingProperties('datasets')">Confirm </button>
                    %{--<button type="button" class="btn btn-sm btn-success" data-toggle="modal" data-target="#propertiesModal" data-dismiss="modal">Confirm & edit properties</button>--}%
                    <button type="button" class="btn btn-sm btn-warning" data-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function displayPropertiesForDataset(dataset) {
        $('div[data-dataset]').hide();
        $('div[data-dataset="' + dataset + '"]').show();
    }
</script>

<!-- properties Modal- -->
<div class="modal fade" id="propertiesModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="dataModalLabel">Add/Subtract Properties</h4>
            </div>
            <div class="modal-body">

                <!-- Nav tabs -->
                <ul id="propertiesTabList" class="nav nav-tabs" role="tablist">
                </ul>

                <!-- Tab panes -->
                <div id="propertiesTabPanes" class="tab-content">
                </div>
                <div id="propertiesInputsTemplate" type="x-tmpl-mustache" style="display: none;">
                    <div role="tabpanel" class="tab-pane {{ active }}" id="{{ phenotype }}PropertiesSelection">
                        <form class="dk-modal-form">
                            <div class="dk-modal-form-input-group">
                                <div class="dk-modal-form-input-row">
                                    <div class="dk-variant-search-builder-ui">
                                        <h5>Data sets</h5>
                                        {{ #datasets }}
                                        <div class="radio" >
                                            <label>
                                                <input type="radio" name="dataset" value="{{ name }}"
                                                       onclick="displayPropertiesForDataset('{{name}}')"
                                                />{{ displayName }}
                                            </label>
                                        </div>
                                        {{ /datasets }}
                                    </div>
                                    <div class="dk-variant-search-builder-ui">
                                        <h5>Properties</h5>
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
                            <h4>Available common properties</h4>
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
            </div>
            <!-- modal body ends -->
            <div class="modal-footer dk-modal-footer">
                <button type="button" class="btn btn-sm btn-primary" data-dismiss="modal" onclick="confirmAddingProperties('properties')">Confirm </button>
                <button type="button" class="btn btn-sm btn-warning" data-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>