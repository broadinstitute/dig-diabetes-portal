
<g:if test="${show_exseq}">

    <div class="translational-research-box">

    </div>
    <p></p>
    <p class="standardFont">
        %{--<a class="variantlink" id="linkToVariantsPredictedToTruncate"><span id="bhtLossOfFunctionVariants" class="bhtLossOfFunctionVariants"></span></a> variants are predicted to truncate a protein encoded by <em><%=geneName%></em>.--}%
    %{--Carriers of at least one copy of one of these variants:--}%
    </p>
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
                        %{--<p class="slimDescription">significant difference</p>--}%
                        %{--<p  id="drMetaBurdenForDiabetes" class="slimDescription"><i class=""></i></p>--}%
                    </div>
                </div>
            </td>
        </div>
    </div>

</g:if>
