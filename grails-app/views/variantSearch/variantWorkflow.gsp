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
.panel.inputGoesHere {
    border: 2px solid #052090;
    -moz-border-radius: 10px;
    -webkit-border-radius: 10px;
    -khtml-border-radius: 10px;
    border-radius: 10px;
    box-shadow: 8px 8px 5px #888888;
}

.bluebox.inputGoesHere {
    border: 3px solid #052090;
    -moz-border-radius: 10px;
    -webkit-border-radius: 10px;
    -khtml-border-radius: 10px;
    border-radius: 10px;

}

.cusEquiv {
    min-width: 60px;
}
</style>
<script>
    $(document).ready(function () {
        mpgSoftware.variantWF.retrievePhenotypes();
        $('#region_gene_input').typeahead({
            source: function (query, process) {
                $.get('<g:createLink controller="gene" action="index"/>', {query: query}, function (data) {
                    process(data);
                })
            }
        });
        document.getElementById("a_filter_btn").addEventListener('click', function() {
            $("#advanced_filter").toggle(function(event) {
            });
        });

    });

    applyDatasetsFilter = function (columns) {
        console.log(columns);
    };

    showDatasetModal = function () {
        var modal = '#columnChooserModal';
        $(modal).modal('show');
        angular.element(modal).scope().loadMetadata();
    };
</script>


<div id="main">

    <div class="container">

        <div class="variantWF-container">

            <h4><g:message code="variantSearch.workflow.header.find_variants"/></h4>

            <div>
                <span id="buildSearch">Build search</span>

                <div class="dk-fluid">
                    <span id="target"></span>

                    <h3>Request searches</h3>

                    <div class="dk-variant-search-builder">
                        <h6>Build search</h6>

                        <form>
                            <div class="row">
                                <div class="col-md-4 col-sm-4 col-xs-4 dk-variant-search-builder-title">
                                    Trait or disease of interest
                                </div>

                                <div class="col-md-5 col-sm-5 col-xs-5 dk-variant-search-builder-ui">
                                    <select id="phenotype" class="form-control"
                                            onclick="mpgSoftware.firstResponders.respondToPhenotypeSelection()"
                                            onchange="mpgSoftware.firstResponders.respondToPhenotypeSelection()"
                                    ></select>
                                </div>

                                <div class="col-md-3 col-sm-3 col-xs-3 dk-variant-search-builder-description">
                                    Choose a phenotype to act as the basis of a search
                                </div>
                            </div>

                            <div id="dataSetChooser" class="row">
                                <div class="col-md-4 col-sm-4 col-xs-4 dk-variant-search-builder-title">
                                    Data set
                                </div>

                                <div class="col-md-5 col-sm-5 col-xs-5 dk-variant-search-builder-ui">
                                    <select id="dataSet" class="form-control"
                                            onclick="mpgSoftware.firstResponders.respondToDataSetSelection()"
                                            onchange="mpgSoftware.firstResponders.respondToDataSetSelection()"
                                    ></select>
                                </div>

                                <div class="col-md-3 col-sm-3 col-xs-3 dk-variant-search-builder-description">
                                    Choose a data set from which
                                    variants may be found
                                </div>
                            </div>
                            <div id="rowTarget"></div>
                            <script id="rowTemplate" type="x-tmpl-mustache">
                                {{ #row }}
                                    <div class="row">
                                        <div class="col-md-4 col-sm-4 col-xs-4 dk-variant-search-builder-title">
                                            {{ . }}
                                        </div>

                                        <div class="col-md-5 col-sm-5 col-xs-5 dk-variant-search-builder-ui">
                                            <div class="col-md-3 col-sm-3 col-xs-3">
                                                <select class="form-control">
                                                    <option>&lt;</option>
                                                    <option>&gt;</option>
                                                    <option>=</option>
                                                </select>
                                            </div>

                                            <div class="col-md-8 col-sm-8 col-xs-8 col-md-offset-1 col-sm-offset-1 col-xs-offset-1">
                                                <input type="text" class="form-control">
                                            </div>
                                        </div>

                                        <div class="col-md-3 col-sm-3 col-xs-3 dk-variant-search-builder-description">

                                        </div>
                                    </div>
                                {{ /row }}
                            </script>

                            <h5 class="dk-advanced-filter-toggle"><a id="a_filter_btn">Advanced filtering open</a><hr>
                            </h5>

                            <div id="advanced_filter" class="container dk-t2d-advanced-filter">
                                <div class="row">
                                    <div class="col-md-7 col-sm-7 col-xs-7">
                                        <label>Gene <small style="color: #aaa;">(e.g. SLC30A8)</small></label>

                                        <div class="form-inline">
                                            <input type="text" class="form-control" style="width:65%;"
                                                   placeholder="gene">
                                            <label style="font-size: 20px; font-weight: 100;">&nbsp; &#177 &nbsp;</label>
                                            <select class="form-control" style="width:20%;">
                                                <option val="1000">1000</option>
                                                <option val="2000">2000</option>
                                                <option val="3000">3000</option>
                                            </select>
                                        </div>

                                        <div class="text-center" style="color:#f70; padding: 10px 0 10px 0;">
                                            &#8212; or &#8212;
                                        </div>
                                        <label>Region <small
                                                style="color: #aaa;">(e.g. chr9:21,940,000-22,190,000)</small>
                                        </label>
                                        <input type="text" class="form-control"
                                               placeholder="chromosome: start - stop">
                                    </div>

                                    <div class="col-md-5 col-sm-5 col-xs-5">
                                        <div class="radio">
                                            <label>
                                                <input type="radio" name="effects">
                                                protain-truncating
                                            </label>
                                        </div>

                                        <div class="radio">
                                            <label>
                                                <input type="radio" name="effects">
                                                missense
                                            </label>
                                        </div>

                                        <div class="radio">
                                            <label>
                                                <input type="radio" name="effects">
                                                no effect (synonymous coding)
                                            </label>
                                        </div>

                                        <div class="radio">
                                            <label>
                                                <input type="radio" name="effects">
                                                no effect (non-coding)
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-12 col-sm-12 col-xs-12 text-center">
                                        <button class="btn btn-default btn-sm btn-success">Reset</button>
                                    </div>
                                </div>
                            </div>

                            <div class="row dk-submit-btn-wrapper">
                                <button class="btn btn-sm btn-primary dk-search-btn-inactive" disabled>
                                    Build Search Request
                                </button>

                                <button class="btn btn-sm btn-primary">
                                    Build Search Request
                                </button>
                            </div>

                        </form>
                    </div>

                    <div class="dk-variant-submit-search">
                        <h6>Submit search</h6>
                        <table class="table table-striped dk-search-collection">
                            <thead>
                            <tr>
                                <th>search detail</th><th>edit</th><th>delete</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>Type 2 diabetes[DIAGRAM GWAS]Odds ratio<3<br>
                                    Type 2 diabetes[DIAGRAM GWAS]P-value<3</td><td><a href="#">edit</a>
                            </td><td><a href="#">delete</a></td>
                            </tr>
                            <tr>
                                <td>Type 2 diabetes[DIAGRAM GWAS]Odds ratio<3<br>
                                    Type 2 diabetes[DIAGRAM GWAS]P-value<3</td><td><a href="#">edit</a>
                            </td><td><a href="#">delete</a></td>
                            </tr>
                            </tbody>
                        </table>

                        <div class="row dk-submit-btn-wrapper">
                            <button class="btn btn-sm btn-primary dk-search-btn-inactive" disabled>
                                Submit Search Request
                            </button>
                            <button class="btn btn-sm btn-primary">
                                Submit Search Request
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
</body>
</html>

