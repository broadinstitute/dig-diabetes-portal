

    <div id="collapseDiseaseRisk" class="accordion-body collapse">
        <div class="accordion-inner">

<g:if test="${show_exseq}">




    <script>
        var mpgSoftware = mpgSoftware || {};

        mpgSoftware.diseaseRisk  = (function() {
            var loadDiseaseRisk = function () {
                $.ajax({
                    cache: false,
                    type: "get",
                    url: "${createLink(controller:'variantInfo',action: 'variantDiseaseRisk')}",
                    data: {variantId: '<%=variantToSearch%>'},
                    async: true,
                    success: function (data) {
                        var diseaseBurdenStrings = {
                            caseBarName: '<g:message code="variant.diseaseBurden.case.barname" default="have T2D" />',
                            caseBarSubName: '<g:message code="variant.diseaseBurden.case.barsubname" default="cases" />',
                            controlBarName: '<g:message code="variant.diseaseBurden.control.barname" default="do not have T2D" />',
                            controlBarSubName: '<g:message code="variant.diseaseBurden.control.barsubname" default="controls" />',
                            diseaseBurdenPValueQ: '<g:helpText title="variant.diseaseBurden.control.pValue.help.header"  qplacer="2px 0 0 6px" placement="left" body="variant.variantAssociations.pValue.help.text"/>',
                            diseaseBurdenOddsRatioQ: '<g:helpText title="variant.diseaseBurden.control.oddsRatio.help.header"  qplacer="2px 0 0 6px" placement="left" body="variant.variantAssociations.oddsRatio.help.text"/>'
                        };
                        var collector = {}
                        for (var i = 0; i < data.variantInfo.results.length; i++) {
                            var d = [];
                            for (var j = 0; j < data.variantInfo.results[i].pVals.length; j++) {
                                var contents = {};
                                contents["level"] = data.variantInfo.results[i].pVals[j].level;
                                contents["count"] = data.variantInfo.results[i].pVals[j].count;
                                d.push(contents);
                            }
                            collector["d" + i] = d;
                        }
                        var calculateDiseaseBurden = mpgSoftware.variantInfo.retrieveCalculateDiseaseBurden();
                        var rv = calculateDiseaseBurden(parseInt(collector["d0"][6].count[0]),
                                parseInt(collector["d0"][7].count[0]),
                                parseInt(collector["d0"][2].count[0]),
                                parseInt(collector["d0"][3].count[0]),
                                parseInt(collector["d0"][4].count[0]),
                                parseInt(collector["d0"][0].count[0]),
                                parseInt(collector["d0"][5].count[0]),
                                parseInt(collector["d0"][1].count[0]),
                                parseFloat(collector["d0"][8].count[0]),
                                parseFloat(collector["d0"][9].count[0]),
                                "<%=variantToSearch%>", ${show_gwas}, ${show_exchp}, ${show_exseq}, diseaseBurdenStrings);

                        if ((typeof mpgSoftware.variantInfo.retrieveDelayedBurdenTestPresentation() !== 'undefined') &&
                                (typeof mpgSoftware.variantInfo.retrieveDelayedBurdenTestPresentation().launch !== 'undefined')) {
                            mpgSoftware.variantInfo.retrieveDelayedBurdenTestPresentation().launch();
                        }
                    },
                    error: function (jqXHR, exception) {
                        loading.hide();
                        core.errorReporter(jqXHR, exception);
                    }
                });

            };
            return {loadDiseaseRisk:loadDiseaseRisk}
        }());


        $("#collapseDiseaseRisk").on("show.bs.collapse", function() {
                mpgSoftware.diseaseRisk.loadDiseaseRisk();
        });
        $('#collapseDiseaseRisk').on('hide.bs.collapse', function (e) {
                if ((typeof mpgSoftware.variantInfo.retrieveDelayedBurdenTestPresentation() !== 'undefined') &&
                        (typeof mpgSoftware.variantInfo.retrieveDelayedBurdenTestPresentation().launch !== 'undefined')) {
                    mpgSoftware.variantInfo.retrieveDelayedBurdenTestPresentation().removeBarchart();
                }
            });
    </script>














    <p></p>
    <p class="standardFont">
        %{--<a class="variantlink" id="linkToVariantsPredictedToTruncate"><span id="bhtLossOfFunctionVariants" class="bhtLossOfFunctionVariants"></span></a> variants are predicted to truncate a protein encoded by <em><%=geneName%></em>.--}%
    %{--Carriers of at least one copy of one of these variants:--}%
    </p>
    <div id="diseaseRiskExists" style="display: block">
        <div class="row clearfix">
            <div class="col-md-10">
                <div class="barchartFormatter">
                    <div id="diseaseRiskChart">

                    </div>
                </div>
            </div>
            <div  class="col-md-2">
                <td class="significanceDescriptorFormatter">
                    <div class="significantDifference">
                        <div  id="describePValueInDiseaseRisk" class="significantDifferenceText">
                        </div>
                    </div>
                </td>
            </div>
        </div>
    </div>

    <div id="diseaseRiskNoExists" style="display: none">
        <div class="row clearfix">
            <div class="col-md-12">
                <h4><g:message code="variant.insufficientdata" default="Insufficient data to draw conclusion"/> <g:helpText title="insufficient.variant.data.help.header" placement="bottom"
                                                                                                                            body="insufficient.variant.data.help.text"/></h4>
             </div>
        </div>
    </div>










</g:if>

        </div>
    </div>

