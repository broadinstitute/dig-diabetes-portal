<div style="">
    <ul  id="myTab" class="nav nav-tabs">
        <li class="active"><a href="#developingQuery" data-toggle="tab">Developing query</a></li>
        <li><a href="#variantList" data-toggle="tab">Variant List</a></li>
        <li><a href="#variantTable" data-toggle="tab">Variant Table</a></li>
        <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">List summaries <b class="caret"></b></a>
            <ul class="dropdown-menu">
                <li><a href="#listSummary1" data-toggle="tab">Histogram</a></li>
                <li><a href="#listSummary2" data-toggle="tab">Summary statistics</a></li>
            </ul>
        </li>

    </ul>


    <div id="myTabContent" class="tab-content variantWFdescriptionBox">
        <div class="tab-pane fade in active" id="developingQuery">
            <g:renderEncodedFilters filterSet='${encodedFilterSets}'/>
            <div style="border: 1px solid gray;
                        margin: 20px;
                        padding: 0;
                        margin-bottom: 25px;">
                <div style="height: 25px; background-color: #ffffff">
                    <span class="text-left developingQueryComponentsFilterTitle">Filter number one</span>
                    <span class="pull-right developingQueryComponentsFilterIcons" style="margin: 4px 10px 0 auto;">
                        <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                        <span class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>
                        <span class="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>
                    </span>
                </div>
                <div class="variantWFsingleFilter">
                    <div class="row clearfix">
                        <div class="col-md-10">
                            <div class="row clearfix developingQueryComponents">
                                <div class="col-md-3 text-right">Phenotype:</div>

                                <div class="col-md-9">BMI</div>
                            </div>

                            <div class="row clearfix developingQueryComponents">
                                <div class="col-md-3 text-right">Data set:</div>

                                <div class="col-md-9">ExSeq_t2d_es_es</div>
                            </div>

                            <div class="row clearfix developingQueryComponents">
                                <div class="col-md-3 text-right">Filters:</div>

                                <div class="col-md-6">
                                    <div class="developingQueryComponentsFilters">
                                        <div class="row clearfix">
                                            <div class="col-md-6 text-right">odds ratio</div>

                                            <div class="col-md-6">&gt;&nbsp;&nbsp; 2</div>
                                        </div>

                                        <div class="row clearfix">
                                            <div class="col-md-6 text-right">p-value</div>

                                            <div class="col-md-6">&lt&nbsp;&nbsp; .0005</div>
                                        </div>
                                    </div>

                                    <div class="col-md-3"></div>

                                </div>
                            </div>
                        </div>

                        <div class="col-md-2">

                        </div>
                    </div>

                </div>
        </div>
        </div>

        <div class="tab-pane fade" id="variantList">
            <p>RS123</p>

            <p>This is the variant you seek</p>
            <hr>

            <p>RS123</p>

            <p>This is the variant you seek</p>
            <hr>
        </div>

        <div class="tab-pane fade" id="variantTable">
            <p></p>
        </div>

        <div class="tab-pane fade" id="listSummary1">
            <h2>I am a histogram</h2>
        </div>

        <div class="tab-pane fade" id="listSummary2">
            <h2>I contain important statistics</h2>
        </div>
    </div>
</div>
</div>
<script type="text/javascript">
    $('#myTab a').click(function (e) {
        if ($(this).parent('li').hasClass('active')) {
            $($(this).attr('href')).hide();
        }
        else {
            e.preventDefault();
            $(this).tab('show');
        }
    });
</script>