<%@ page import="org.broadinstitute.mpg.diabetes.util.PortalConstants" %>
<r:require module="mustache"/>

<div>
    <span id="buildSearch">Build search</span>
    <div class="dk-fluid">
        <span id="target"></span>
        <script id="template" type="x-tmpl-mustache">
            Hello {{ name }}!
        </script>
        <h3>Request searches</h3>
        <div class="dk-variant-search-builder">
            <h6>Build search</h6>
            <form>
                <div class="row">
                    <div class="col-md-4 col-sm-4 col-xs-4 dk-variant-search-builder-title">
                        Trait or disease of interest
                    </div>
                    <div class="col-md-5 col-sm-5 col-xs-5 dk-variant-search-builder-ui">
                        <select class="form-control">
                            <option selected hidden>Select a phenotype</option>
                            <option>type 2 diabetes</option>
                            <option>HbA1c</option>
                            <option>fasting glucose</option>
                            <option>two-hour glucose</option>
                            <option>HOMA-B</option>
                        </select>
                    </div>
                    <div class="col-md-3 col-sm-3 col-xs-3 dk-variant-search-builder-description">
                        Choose a phenotype to act as the basis of a search
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4 col-sm-4 col-xs-4 dk-variant-search-builder-title">
                        Data set
                    </div>
                    <div class="col-md-5 col-sm-5 col-xs-5 dk-variant-search-builder-ui">
                        <select class="form-control">
                            <option selected hidden>Select a data set</option>
                            <option>DIAGRAM GWAS</option>
                            <option>GWAS GIGMA</option>
                            <option>82K exome chip analysis</option>
                        </select>
                    </div>
                    <div class="col-md-3 col-sm-3 col-xs-3 dk-variant-search-builder-description">
                        Choose a data set from which
                        variants may be found
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4 col-sm-4 col-xs-4 dk-variant-search-builder-title">
                        P-value
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

                <div class="row">
                    <div class="col-md-4 col-sm-4 col-xs-4 dk-variant-search-builder-title">
                        Odds ratio
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
                <h5 class="dk-advanced-filter-toggle"><a href="#" id="a_filter_btn">Advanced filtering open</a><hr></h5>
                <div id="advanced_filter" class="container dk-t2d-advanced-filter">
                    <div class="row">
                        <div class="col-md-7 col-sm-7 col-xs-7">
                            <label>Gene <small style="color: #aaa;">(e.g. SLC30A8)</small></label>
                            <div class="form-inline">
                                <input type="text" class="form-control" style="width:65%;" placeholder="gene">
                                <label style="font-size: 20px; font-weight: 100;"> &nbsp; &#177 &nbsp; </label>
                                <select class="form-control" style="width:20%;">
                                    <option>1000</option>
                                    <option>2000</option>
                                    <option>3000</option>
                                </select>
                            </div>
                            <div class="text-center" style="color:#f70; padding: 10px 0 10px 0;">
                                &#8212; or &#8212;
                            </div>
                            <label>Region <small style="color: #aaa;">(e.g. chr9:21,940,000-22,190,000)</small></label>
                            <input type="text" class="form-control" placeholder="chromosome: start - stop">
                        </div>

                        <div class="col-md-5 col-sm-5 col-xs-5">
                            <div class="radio" >
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
                            <button class="btn btn-default btn-sm btn-success"> Reset</button>
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
                        Type 2 diabetes[DIAGRAM GWAS]P-value<3</td><td><a href="#">edit</a></td><td><a href="#">delete</a></td>
                </tr>
                <tr>
                    <td>Type 2 diabetes[DIAGRAM GWAS]Odds ratio<3<br>
                        Type 2 diabetes[DIAGRAM GWAS]P-value<3</td><td><a href="#">edit</a></td><td><a href="#">delete</a></td>
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

<script>
    var t = function () {
        var template = $('#template').html();
        Mustache.parse(template);   // optional, speeds up future uses
        var rendered = Mustache.render(template, {name: "Luke"});
        $('#target').html(rendered);
    };

    t();
</script>