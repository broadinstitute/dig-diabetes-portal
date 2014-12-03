<div class="row">
    <div class="col-sm-11">
        <div class="dbtBoundingBox">

            <div class="row">
                <div class="col-sm-12">
                             <h3>There are three ways to create a list of variants:</h3>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12">

                        <div style="padding-left: 15px">

                            <div class="accordion" id="accordionVariantAnnotations">
                                <div class="accordion-group">
                                    <div class="accordion-heading">
                                        <a class="accordion-toggle collapsed" data-toggle="collapse"
                                           data-parent="#accordionVariantAnnotations"
                                           href="#collapseVariantAnnotationOne">
                                            <h3><strong>Enter the list by hand</strong></h3>
                                        </a>
                                    </div>

                                    <div id="collapseVariantAnnotationOne" class="accordion-body collapse in">
                                        <div class="accordion-inner">
                                            <g:form action="variantUpload">
                                                <div class="row">
                                                    <div class="col-sm-5"> Type (or else copy and paste) a variant list. Each variant should be
                                                    in quotes and separated by commas</div>
                                                    <div class="col-sm-5">
                                                        <g:textField name="explicitVariants" size="45" placeholder="each variant in quotes, separated by commas"/>
                                                    </div>
                                                    <div class="col-sm-2"><input type="submit"   class="btn btn-default btn-sm" /></div>
                                                </div>
                                            </g:form>
                                        </div>
                                    </div>
                                </div>

                                <div class="accordion-group">
                                    <div class="accordion-heading">
                                        <a class="accordion-toggle collapsed" data-toggle="collapse"
                                           data-parent="#accordionVariantAnnotations"
                                           href="#collapseVariantAnnotationTwo">
                                            <h3><strong>Reference an existing list in a file</strong></h3>
                                        </a>
                                    </div>

                                    <div id="collapseVariantAnnotationTwo" class="accordion-body collapse">
                                        <div class="accordion-inner">
                                            <g:uploadForm action="variantFileUpload">
                                                <div class="row">
                                                    <div class="col-sm-5"> Choose a file containing variant. The file must contain
                                                    only one variant on each line</div>
                                                    <div class="col-sm-5"><input type="file"  class="btn btn-default btn-sm" name="myVariantFile"  size="45" /></div>
                                                    <div class="col-sm-2"><input type="submit"   class="btn btn-default btn-sm" /></div>
                                                </div>
                                            </g:uploadForm>
                                        </div>
                                    </div>
                                </div>


                                <div class="accordion-group">
                                    <div class="accordion-heading">
                                        <a class="accordion-toggle collapsed" data-toggle="collapse"
                                           data-parent="#accordionVariantAnnotations"
                                           href="#collapseVariantAnnotationThree">
                                            <h3><strong>Search for variants in the database using annotations</strong></h3>
                                        </a>
                                    </div>

                                    <div id="collapseVariantAnnotationThree" class="accordion-body collapse">
                                        <div class="accordion-inner">
                                            <h3>Still TBD</h3>
                                        </div>
                                    </div>
                                </div>




                            </div>

                        </div>


                </div>

            </div>


        </div>
    </div>

</div>
