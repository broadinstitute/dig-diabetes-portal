<div class="panel panel-default">
    <div class="panel-body">
        <div class="row clearfix">
            <div class="col-sm-12" style="text-align: left" style = "margin: 0 0 10px 0">
                <span id="filterInstructions" class="filterInstructions">Choose a phenotype to begin:</span>
            </div>
         </div>


        <div class="row clearfix">

           <div class="primarySectionSeparator">
                <div class="col-sm-offset-1 col-md-2" style="text-align: right">
                        Phenotype:
                </div>
               <div class="col-md-6">
                        <select name="" id="phenotype-input" class="form-control btn-group btn-input clearfix"
                                onchange="makeDataSetsAppear()">
                            <g:renderPhenotypeOptions/>
                        </select>

                </div>
                <div class="col-md-3">

                </div>

            </div>
        </div>

        <div class="row clearfix">

                <div class="primarySectionSeparator" id="dataSetChooser" style="display:none">
                    <div class="col-sm-offset-1 col-md-2" style="text-align: right">
                        Sample:
                    </div>
                    <div class="col-md-6">
                        <select name="" id="dataset-input" class="form-control btn-group btn-input clearfix"
                                onchange="makeVariantFilterAppear()">
                        </select>

                    </span>

                    </div>
                    <div class="col-md-3">

                    </div>


            </div>
        </div>

        <div class="row clearfix">

                <div class="primarySectionSeparator" id="variantFilter" style="display:none">

                    <div class="col-sm-offset-1 col-md-2" style="text-align: right; vertical-align: middle">
                        Filters:
                    </div>
                    <div class="col-md-6">
                        <div  style="margin-top: 20px" class="well well-sm">
                            <div class="row clearfix">
                                <div class="col-md-5 col-md-offset-1">p Value</div>

                                <div class="col-md-6"><input type="text" class="form-control" id="pValue-input"></div>


                            </div>

                            <div class="row clearfix" style="margin-top: 10px">
                                <div class="col-md-5 col-md-offset-1">OR Value</div>

                                <div class="col-md-6"><input type="text" class="form-control" id="orValue-input"></div>


                            </div>
                        </div>

                    </span>

                    </div>
                    <div class="col-md-3">

                    </div>



                    <div>
                    </div>
                </div>

        </div>



        <button class="btn btn-lg btn-primary pull-right variant-filter-button" onclick="gatherFieldsAndPostResults()">Go</button>
    </div>
</div>