<div class="row">
    <div class="col-sm-12">
      <em>Current list of variants.</em>
    </div>
</div>
<div class="row">
    <div class="col-sm-12">
        <div class="dbtBoundingBox">

            <div class="row">
                <div class="col-sm-12">
                    <table id="btVariantTable" class="table table-striped basictable">
                        <thead>
                        <tr>
                            <th>nearest gene</th>
                            <th>variant</th>
                            <th>rsid</th>
                            <th>protein change</th>
                            <th>effect on protein</th>
                            <th>highest frequency</th>
                            <th>population with highest frequency</th>
                        </tr>
                        </thead>
                        <tbody id="btVariantTableBody">
                        </tbody>
                    </table>
                </div>

            </div>


        </div>
    </div>
</div>
<div id="doSomethingWithExistingList">
    <div class="row">

        <div class="col-sm-6">
            <h2><strong>Modify your existing list:</strong></h2>
        </div>
        <div class="col-sm-6"></div>
    </div>
    <div class="row">
        <div class="col-sm-1"></div>
        <div class="col-sm-11" style="margin-left:20px; padding-left: 40px">
            <g:if test='${(caller==3)}'>
                <div class="row">
                    <div class="accordion" id="accordionVariantListRevisions">
                        <div class="accordion-group">
                            <div class="accordion-heading">
                                <a class="accordion-toggle collapsed" data-toggle="collapse"
                                   data-parent="#accordionVariantListRevisions"
                                   href="#collapseVariantListRevisionOne">
                                    <h4><strong>Add variants to existing list</strong></h4>
                                </a>
                            </div>

                            <div id="collapseVariantListRevisionOne" class="accordion-body collapse in">
                                <div class="accordion-inner">
                                    <g:form action="variantUpload">
                                        <div class="row">
                                            <ul>
                                                <li><a href="#">Specify variant by ID to add to the existing list</a></li>
                                                <li><a href="#">Use a file specifying variants to add to the existing list</a></li>
                                                <li><a href="#">Perform a variant search and add the results to the existing list</a></li>
                                            </ul>
                                        </div>
                                    </g:form>
                                </div>
                            </div>
                        </div>

                        <div class="accordion-group">
                            <div class="accordion-heading">
                                <a class="accordion-toggle collapsed" data-toggle="collapse"
                                   data-parent="#accordionVariantListRevisions"
                                   href="#collapseVariantListRevisionTwo">
                                    <h4><strong>Remove variants from existing list</strong></h4>
                                </a>
                            </div>

                            <div id="collapseVariantListRevisionTwo" class="accordion-body collapse">
                                <div class="accordion-inner">
                                    <g:uploadForm action="variantFileUpload">
                                        <div class="row">
                                            <ul>
                                                <li><a href="#">Specify variant by ID to remove from the existing list</a></li>
                                                <li><a href="#">Use a file specifying variants to remove from the existing list</a></li>
                                                <li><a href="#">Perform a variant search and remove the results to the existing list</a></li>
                                            </ul>
                                        </div>
                                    </g:uploadForm>
                                </div>
                            </div>
                        </div>


                        <div class="accordion-group">
                            <div class="accordion-heading">
                                <a class="accordion-toggle collapsed" data-toggle="collapse"
                                   data-parent="#accordionVariantListRevisions"
                                   href="#collapseVariantListRevisionThree">
                                    <h4><strong>Execute burden test on existing list</strong></h4>
                                </a>
                            </div>

                            <div id="collapseVariantListRevisionThree" class="accordion-body collapse">
                                <div class="accordion-inner">
                                    <a href="#"  onclick="launchDynamicBurdenTest()">Launch burden test now</a>
                                    %{--<button class="btn btn-lg btn-primary" onclick="launchDynamicBurdenTest()">Execute</button>--}%
                                </div>
                            </div>
                        </div>

                    </div>

                </div>
            </g:if>

        </div>
    </div>









</div>
