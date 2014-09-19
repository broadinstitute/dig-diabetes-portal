
<g:if test="${show_exseq}">


    <a name="biology"></a>

    <h2><strong>Biological hypothesis testing</strong></h2>

    <p>We are piloting queries inspired by translational research questions. For example:</p>

    <div class="translational-research-box">
        <p>
            <span id="bhtLossOfFunctionVariants"></span> variants are predicted to truncate a protein encoded by <em><%=geneName%></em>.
        | <a class="variantlink" id="linkToVariantsPredictedToTruncate">view</a>
        </p>

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
    <table style="width:900px">
        <tr>
            <td class="barchartFormatter"><div id="chart"></div></td>
            <td class="significanceDescriptorFormatter">
                <div class="significantDifference">
                    <div class="significantDifferenceText">
                        <p>significant difference</p>
                        <p>p=0.126</p>
                        <p>OR=1.4</p>
                    </div>
                </div>
            </td>
        </tr>
    </table>

    <script type="text/javascript">
//        var data = [
//                    { value: 12,
//                        barname: 'Have T2D',
//                        barsubname: '(cases)',
//                        barsubnamelink:'http://www.google.com',
//                        inbar: '',
//                        descriptor: '(8 out of 6469)'},
//                    {value: 33,
//                        barname: 'Do not have T2D',
//                        barsubname: '(controls)',
//                        barsubnamelink:'http://www.google.com',
//                        inbar: '',
//                        descriptor: '(21 out of 6364)'}
//                ],
//                roomForLabels = 120,
//                maximumPossibleValue = 100,
//                labelSpacer = 10;
//
//        var margin = {top: 30, right: 20, bottom: 50, left: 70},
//                width = 800 - margin.left - margin.right,
//                height = 250 - margin.top - margin.bottom;
//
//
//            var barChart = baget.barChart()
//                    .selectionIdentifier("#chart")
//                    .width(width)
//                    .height(height)
//                    .margin(margin)
//                    .roomForLabels (roomForLabels)
//                    .maximumPossibleValue (maximumPossibleValue)
//                    .labelSpacer (labelSpacer)
//                    .assignData(data);
//            barChart.render();
//
//
    </script>


</g:if>
