
<div class="panel panel-default">
  <div class="panel-body">
    <div class="row clearfix">
        <div class="col-md-12">
            <div class="primarySectionSeparator">
                <select name="" id="phenotype-input" class="form-control btn-group btn-input clearfix">
                    <g:renderPhenotypeOptions/>
                </select>

            </div>


        </div>
    </div>

    <div class="row clearfix">
        <div class="col-md-12">
            <div class="primarySectionSeparator">
                <select name="" id="dataset-input" class="form-control btn-group btn-input clearfix">
                    <g:renderDatasetOptions/>
                </select>

            </div>

        </div>
    </div>

    <div class="row clearfix">
        <div class="col-md-12">

           <div>
               <div class="well well-sm">
                   <div class="row clearfix">
                       <div class="col-md-3 col-md-offset-1">p Value</div>
                       <div class="col-md-3"><input type="text" class="form-control" id="pValue-input"></div>
                       <div class="col-md-5"></div>
                   </div>
                   <div class="row clearfix" style="margin-top: 10px">
                       <div class="col-md-3 col-md-offset-1">OR Value</div>
                       <div class="col-md-3"><input type="text" class="form-control" id="orValue-input"></div>
                       <div class="col-md-5"></div>
                   </div>
               </div>
           </div>

        </div>
    </div>



    <button class="btn btn-lg btn-primary pull-right" onclick="gatherFieldsAndPostResults()">Go</button>
  </div>
</div>