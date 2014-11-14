
<g:if test="${show_exseq || show_sigma}">


    <a name="biology"></a>

    <div class="translational-research-box">
        <p style="font-weight: 600">Question 1: Does truncating the encoded protein affect disease risk?</p>
    </div>
    <p></p>
    <p class="standardFont"  id="possibleCarrierVariantsLink">
        %{--<a class="variantlink" id="linkToVariantsPredictedToTruncate">--}%
            %{--<span id="bhtLossOfFunctionVariants" class="bhtLossOfFunctionVariants"></span>--}%
        %{--</a> variants are predicted to truncate a protein encoded by <em><%=geneName%></em>.--}%
        %{--Carriers of at least one copy of one of these variants:--}%
    </p>
    <div class="row clearfix">
         <div class="col-md-10">
            <div class="barchartFormatter">
                <div id="chart">

                </div>
            </div>
         </div>
         <div  class="col-md-2">
                <div class="significanceDescriptorFormatter" id="significanceDescriptorFormatter">

                </div>
         </div>
    </div>

</g:if>
