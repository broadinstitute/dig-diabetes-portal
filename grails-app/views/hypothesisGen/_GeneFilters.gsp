<div class="row">
    <div class="col-sm-11">
        <div class="dbtBoundingBox" id="variantSelectingBox">
        <div class="dbtInnerBoundingBox" id="innerVariantSelectingBox">
            <div class="row">
                <div class="col-sm-12">
                    <h3><g:message code='hypothesisGen.geneFilters.intro'/>:</h3>
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
                                        <h3><strong><g:message code='hypothesisGen.geneFilters.by_hand.title'/></strong></h3>
                                    </a>
                                </div>

                                <div id="collapseVariantAnnotationOne" class="accordion-body collapse in">
                                    <div class="accordion-inner">
                                        <g:form action="variantUpload">
                                            <div class="row">
                                                <div class="col-sm-5"><g:message code='hypothesisGen.geneFilters.by_hand.desc'/></div>

                                                <div class="col-sm-5">
                                                    <g:textField name="explicitVariants" size="45"
                                                                 placeholder="each variant in quotes, separated by commas"/>
                                                </div>

                                                <div class="col-sm-2"><input type="submit"
                                                                             class="btn btn-default btn-sm"/></div>
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
                                        <h3><strong><g:message code='hypothesisGen.geneFilters.file.title'/></strong></h3>
                                    </a>
                                </div>

                                <div id="collapseVariantAnnotationTwo" class="accordion-body collapse">
                                    <div class="accordion-inner">
                                        <g:uploadForm action="variantFileUpload">
                                            <div class="row">
                                                <div class="col-sm-5"><g:message code='hypothesisGen.geneFilters.file.desc'/></div>

                                                <div class="col-sm-5"><input type="file" class="btn btn-default btn-sm"
                                                                             name="myVariantFile" size="45"/></div>

                                                <div class="col-sm-2"><input type="submit"
                                                                             class="btn btn-default btn-sm"/></div>
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
                                        <h3><strong><g:message code='hypothesisGen.geneFilters.database.title'/></strong></h3>
                                    </a>
                                </div>

                                <div id="collapseVariantAnnotationThree" class="accordion-body collapse">
                                    <div class="accordion-inner">
                                        <g:render template="variantSearchRestrictToRegion"/>
                                        <g:render template="variantSearchRestrictToEthnicity"/>
                                        <g:render template="variantSearchEffectsOnProteins"/>
                                        <div class="big-button-container">
                                            <button class="btn btn-lg btn-primary"
                                                    onclick="gatherFieldsAndPostResults()">Go</button>
                                            %{--<form id="dummy-form" action="/variantsearch/results" method="get">--}%
                                            %{--<a id="variant-search-go" class="btn btn-lg btn-primary">Go</a>--}%
                                            %{--</form>--}%
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
    </div>

</div>
