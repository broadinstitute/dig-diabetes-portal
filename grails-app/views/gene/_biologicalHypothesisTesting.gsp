
<g:if test="${show_exseq}">


    <a name="biology"></a>

    <h2><strong>Biological hypothesis testing</strong></h2>

    We are piloting queries inspired by translational research questions. For instance:
    <p></p>
    <div class="translational-research-box">
        <p>Question 1: Does truncating the encoded protein affect disease risk?</p>
    </div>
    <p></p>
    <p class="standardFont">
    <a class="variantlink" id="linkToVariantsPredictedToTruncate"><span id="bhtLossOfFunctionVariants" class="bhtLossOfFunctionVariants"></span></a> variants are predicted to truncate a protein encoded by <em><%=geneName%></em></p>

    <p class="standardEmphasisFont">
    Carriers of at least one copy of one of these variants</p>
    <div class="row clearfix">
         <div class="col-md-10">
            <div class="barchartFormatter">
                <div id="chart">

                </div>
            </div>
         </div>
         <div  class="col-md-2">
                <td class="significanceDescriptorFormatter">
                    <div class="significantDifference">
                        <div class="significantDifferenceText">
                            <p class="slimDescription">significant difference</p>
                            <p  id="bhtMetaBurdenForDiabetes" class="slimDescription"></p>
                            %{--TODO: uncomment the following line when we have some real data--}%
                            %{--<p class="slimDescription">OR=1.4</p>--}%
                        </div>
                    </div>
                </td>
         </div>
    </div>

</g:if>
