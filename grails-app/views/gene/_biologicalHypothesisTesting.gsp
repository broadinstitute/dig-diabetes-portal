
<g:if test="${show_exseq}">


    <a name="biology"></a>

    <h2><strong>Biological hypothesis testing</strong></h2>

    <p>We are piloting queries inspired by translational research questions. For example:</p>

    <div class="translational-research-box">
        %{--<p>--}%
            %{--<span id="bhtLossOfFunctionVariants"></span> variants are predicted to truncate a protein encoded by <em><%=geneName%></em>.--}%
        %{--| <a class="variantlink" id="linkToVariantsPredictedToTruncate">view</a>--}%
        %{--</p>--}%

        <p>Among people who carry one copy of at least one of these variants (data drawn from exome sequencing):</p>
        <ul>
            <li>
                <span id="bhtPeopleWithVariantWhoHaveDiabetes"></span> out of
                <span id="bhtPeopleWithVariant"></span>
                have type 2 diabetes.
                <span id="bhtPercentOfPeopleWithVariantWhoHaveDisease"></span>
            </li>
            <li>
                <span id="bhtPeopleWithVariantWithoutDiabetes"></span> out of
                <span id="bhtPeopleWithoutVariant"></span>
                do not have type 2 diabetes.
                <span id="bhtPercentOfPeopleWithVariantWithoutDisease"></span>
            </li>
        </ul>
        <span id="bhtMetaBurdenForDiabetes"></span>
           <p class="term-description">
            Variants in this module are predicted to be protein-truncating by three annotation programs (VEP, CHAOS, and SNPEff). Variants in the table are annotated only by VEP. A small fraction of the time, this may result in inconsistencies.
        </p>
    </div>
    <p class="standardFont">
    <a class="variantlink" id="linkToVariantsPredictedToTruncate"><span id="bhtLossOfFunctionVariants"></span></a> variants are predicted to truncate a protein encoded by <em><%=geneName%></em></p>

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
                            <p>significant difference</p>
                            <p>p=0.126</p>
                            <p>OR=1.4</p>
                        </div>
                    </div>
                </td>
         </div>
    </div>
    %{--<table style="width:900px">--}%
        %{--<tr>--}%
            %{--<td class="barchartFormatter"><div id="chart"></div></td>--}%
            %{--<td class="significanceDescriptorFormatter">--}%
                %{--<div class="significantDifference">--}%
                    %{--<div class="significantDifferenceText">--}%
                        %{--<p>significant difference</p>--}%
                        %{--<p>p=0.126</p>--}%
                        %{--<p>OR=1.4</p>--}%
                    %{--</div>--}%
                %{--</div>--}%
            %{--</td>--}%
        %{--</tr>--}%
    %{--</table>--}%

</g:if>
