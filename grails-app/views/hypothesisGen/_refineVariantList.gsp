<div class="row">
    <div class="col-sm-12">
      <em><g:message code="variantTable.header.current_list"/>.</em>
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
                            <th><g:message code="variantTable.columnHeaders.shared.nearestGene"/></th>
                            <th><g:message code="variantTable.columnHeaders.shared.variant"/></th>
                            <th><g:message code="variantTable.columnHeaders.shared.rsid"/></th>
                            <th><g:message code="variantTable.columnHeaders.shared.proteinChange"/></th>
                            <th><g:message code="variantTable.columnHeaders.shared.effectOnProtein"/></th>
                            <th><g:message code="variantTable.columnHeaders.exomeSequencing.highestFrequency"/></th>
                            <th><g:message code="variantTable.columnHeaders.exomeSequencing.popWithHighestFrequency"/></th>
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
    <div class="innerDoSomethingWithExistingList">
    <div class="row">

        <div class="col-sm-6">
            <h2><strong><g:message code="variantTable.header.modify_list"/>:</strong></h2>
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
                                    <h4><strong><g:message code="variantTable.label.add_variants_to_list.title"/></strong></h4>
                                </a>
                            </div>

                            <div id="collapseVariantListRevisionOne" class="accordion-body collapse in">
                                <div class="accordion-inner">
                                    <g:form action="variantUpload">
                                        <div class="row">
                                            <ul>
                                                <li><a href="#"><g:message code="variantTable.label.add_variants_to_list.step1"/></a></li>
                                                <li><a href="#"><g:message code="variantTable.label.add_variants_to_list.step2"/></a></li>
                                                <li><a href="#"><g:message code="variantTable.label.add_variants_to_list.step3"/></a></li>
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
                                    <h4><strong><g:message code="variantTable.label.remove_variants_from_list.title"/></strong></h4>
                                </a>
                            </div>

                            <div id="collapseVariantListRevisionTwo" class="accordion-body collapse">
                                <div class="accordion-inner">
                                    <g:uploadForm action="variantFileUpload">
                                        <div class="row">
                                            <ul>
                                                <li><a href="#"><g:message code="variantTable.label.remove_variants_from_list.step1"/></a></li>
                                                <li><a href="#"><g:message code="variantTable.label.remove_variants_from_list.step2"/></a></li>
                                                <li><a href="#"><g:message code="variantTable.label.remove_variants_from_list.step3"/></a></li>
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
                                    <h4><strong><g:message code="variantTable.label.execute_burden_test"/></strong></h4>
                                </a>
                            </div>

                            <div id="collapseVariantListRevisionThree" class="accordion-body collapse">
                                <div class="accordion-inner">
                                    <a href="#"  onclick="launchDynamicBurdenTest()"><g:message code="variantTable.label.launch_burden_test"/></a>
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
</div>
