
<g:if test="${show_exseq || show_sigma}">

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
                <h4>Insufficient data exists regarding this variant.</h4>
             </div>
        </div>
    </div>

</g:if>
