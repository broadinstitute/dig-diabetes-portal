<style>
.dbtBoundingBox {
    border: solid 1px black;
    width : 96%;
    height: 300px;
    margin-top: 30px;
    overflow-y: auto;
    overflow-x: hidden;
}
.dbtBoundingBoxSubrow {
    margin: 20px;
}
.subsectionHolder {
    padding:10px 0px 10px 25px;
    font-weight: 400;
    font-size: 12pt;
}
</style>
<div class="row">
    <div class="col-sm-11">
        <div class="dbtBoundingBox">

            <div class="row">
                    <div class="col-sm-6">
                        <div class="subsectionHolder">
                        <div class="row">
                           <div class="col-sm-3"></div>
                           <div class="col-sm-6"><strong>choose a variant</strong></div>
                           <div class="col-sm-3"></div>
                        </div>
                        <div class="row dbtBoundingBoxSubrow">
                            <ul class="list-group">
                                <li class="list-group-item">
                                    <g:textField name="explicitVariants" value="${0}" />
                                </li>
                                <li class="list-group-item">
                                    <g:uploadForm action="variantUpload">
                                        <input type="file"  class="btn btn-default btn-sm" name="myVariantFile" />
                                        <input type="submit"   class="btn btn-default btn-sm" />
                                    </g:uploadForm>
                                </li>
                            </ul>
                        </div>

                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="subsectionHolder">
                            <div class="row">
                                <div class="col-sm-3"></div>
                                <div class="col-sm-6"><strong>annotation options</strong></div>
                                <div class="col-sm-3"></div>
                            </div>
                            <div class="row dbtBoundingBoxSubrow">

                                <div class="accordion" id="accordionVariantAnnotations">
                                    <div class="accordion-group">
                                        <div class="accordion-heading">
                                            <a  class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordionVariantAnnotations"
                                                href="#collapseVariantAnnotationOne">
                                                <h5><strong>annotation category number one</strong></h5>
                                            </a>
                                        </div>
                                        <div id="collapseVariantAnnotationOne" class="accordion-body collapse in">
                                            <div class="accordion-inner">
                                                This is an annotation category
                                            </div>
                                        </div>
                                    </div>
                                    <div class="accordion-group">
                                        <div class="accordion-heading">
                                            <a  class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordionVariantAnnotations"
                                                href="#collapseVariantAnnotationTwo">
                                                <h5><strong>annotation category number two</strong></h5>
                                            </a>
                                        </div>
                                        <div id="collapseVariantAnnotationTwo" class="accordion-body collapse">
                                            <div class="accordion-inner">
                                                <g:render template="../variantSearch/variantSearchEffectsOnProteins" />
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
    <div class="col-sm-1"></div>
</div>
