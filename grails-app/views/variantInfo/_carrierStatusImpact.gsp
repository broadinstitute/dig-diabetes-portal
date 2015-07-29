
    <div id="collapseCarrierStatusImpact" class="accordion-body collapse">
        <div class="accordion-inner">

            <g:if test="${show_exseq}">



    <script>
        var mpgSoftware = mpgSoftware || {};


        mpgSoftware.carrierStatusImpact  = (function() {
        var loadDiseaseRisk  = function(){
            var variant;
            $.ajax({
                cache: false,
                type: "get",
                url: "${createLink(controller:'variantInfo',action: 'variantDiseaseRisk')}",
                data: {variantId: '<%=variantToSearch%>'},
                async: true,
                success: function (data) {
                    var carrierStatusImpact = {
                        casesTitle:'<g:message code="variant.carrierStatusImpact.casesTitle" default="casesTitle" />',
                        controlsTitle:'<g:message code="variant.carrierStatusImpact.controlsTitle" default="controlsTitle" />',
                        legendTextHomozygous:'<g:message code="variant.carrierStatusImpact.legendText.homozygous" default="legendTextHomozygous" />',
                        legendTextHeterozygous:'<g:message code="variant.carrierStatusImpact.legendText.heterozygous" default="legendTextHeterozygous" />',
                        legendTextNoncarrier:'<g:message code="variant.carrierStatusImpact.legendText.nonCarrier" default="legendTextNoncarrier" />',
                        designationTotal:'<g:message code="variant.carrierStatusImpact.designation.total" default="designationTotal" />'
                    };
                    var collector = {}
                    for (var i = 0 ; i < data.variantInfo.results.length ; i++) {
                        var d = [];
                        for (var j = 0 ; j < data.variantInfo.results[i].pVals.length ; j++ ){
                            var contents={};
                            contents["level"] = data.variantInfo.results[i].pVals[j].level;
                            contents["count"] = data.variantInfo.results[i].pVals[j].count;
                            d.push(contents);
                        }
                        collector["d"+i] = d;
                    }
                    var carrierStatusDiseaseRisk = mpgSoftware.variantInfo.retrieveCarrierStatusDiseaseRisk();
                    carrierStatusDiseaseRisk(parseInt(collector["d0"][4].count[0]),
                            parseInt(collector["d0"][5].count[0]),
                            parseInt(collector["d0"][2].count[0]),
                            parseInt(collector["d0"][0].count[0]),
                            parseInt(collector["d0"][3].count[0]),
                            parseInt(collector["d0"][1].count[0]),
                            ${show_gwas},${show_exchp},${show_exseq}, carrierStatusImpact);

                    if ((typeof mpgSoftware.variantInfo.retrieveDelayedCarrierStatusDiseaseRiskPresentation() !== 'undefined') &&
                            (typeof mpgSoftware.variantInfo.retrieveDelayedCarrierStatusDiseaseRiskPresentation().launch !== 'undefined')) {
                        mpgSoftware.variantInfo.retrieveDelayedCarrierStatusDiseaseRiskPresentation().launch();
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
        %{--if (${newApi}) {--}%
            %{--loadDiseaseRisk();--}%
        %{--}--}%

        $('#collapseCarrierStatusImpact').on('show.bs.collapse', function (e) {
                mpgSoftware.carrierStatusImpact.loadDiseaseRisk();
        });
        $('#collapseCarrierStatusImpact').on('hide.bs.collapse', function (e) {
                if ((typeof mpgSoftware.variantInfo.retrieveDelayedCarrierStatusDiseaseRiskPresentation()  !== 'undefined') &&
                        (typeof mpgSoftware.variantInfo.retrieveDelayedCarrierStatusDiseaseRiskPresentation().launch !== 'undefined')) {
                    mpgSoftware.variantInfo.retrieveDelayedCarrierStatusDiseaseRiskPresentation().removeBarchart();
                }
        });


    </script>





                <div id="carrierStatusExist" style="display: block">


                    <p>
                    <div id="carrierStatusDiseaseRiskChart"></div>
                </p>

                </div>

                <div id="carrierStatusNoExist" style="display: none">

                <h4><g:message code="variant.insufficientdata" default="Insufficient data to draw conclusion"/> <g:helpText title="insufficient.variant.data.help.header" placement="bottom"
                                                                                                            body="insufficient.variant.data.help.text"/></h4>
                </div>


</g:if>

        </div>
    </div>




