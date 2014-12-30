var delayedHowCommonIsPresentation = {},
    delayedCarrierStatusDiseaseRiskPresentation = {},
    delayedBurdenTestPresentation = {},
    delayedIgvLaunch = {};
function fillTheFields(data,
                       variantToSearch,
                       traitsStudiedUrlRoot,
                       restServerRoot,
                       showGwas,
                       showExchp,
                       showExseq,
                       showSigma) {
    var cariantRec = {
        _13k_T2D_HET_CARRIERS: 1,
        _13k_T2D_HOM_CARRIERS: 2,
        IN_EXSEQ: 3,
        _13k_T2D_SA_MAF: 4,
        MOST_DEL_SCORE: 5,
        CLOSEST_GENE: 6,
        CHROM: 7,
        Consequence: 8,
        ID: 9,
        _13k_T2D_MINA: 10,
        _13k_T2D_HS_MAF: 11,
        DBSNP_ID: 12,
        _13k_T2D_EA_MAF: 13,
        _13k_T2D_AA_MAF: 14,
        POS: 15,
        _13k_T2D_TRANSCRIPT_ANNOT: 16,
        IN_GWAS: 17,
        GWAS_T2D_PVALUE: 18,
        EXCHP_T2D_P_value: 19,
        _13k_T2D_P_EMMAX_FE_IV: 20,
        GWAS_T2D_OR: 21,
        EXCHP_T2D_BETA: 22,
        _13k_T2D_OR_WALD_DOS_FE_IV: 23,
        SIGMA_T2D_P: 24,
        SIGMA_T2D_OR: 25
        },
    variantObj = data['variant'],
    variant =  variantObj['variant-info'],
    variantTitle = UTILS.get_variant_title(variant, variantToSearch);

    /***
     * Within the object privateMethods are all the subroutines that we need to call
     * @type {{showPercentageAcrossEthnicities: showPercentageAcrossEthnicities, fillHowCommonIsUpBarChart: fillHowCommonIsUpBarChart, fillCarrierStatusDiseaseRisk: fillCarrierStatusDiseaseRisk, showEthnicityPercentageWithBarChart: showEthnicityPercentageWithBarChart, showCarrierStatusDiseaseRisk: showCarrierStatusDiseaseRisk, variantGenerateProteinsChooserTitle: variantGenerateProteinsChooserTitle, variantGenerateProteinsChooser: variantGenerateProteinsChooser, fillUpBarChart: fillUpBarChart, fillDiseaseRiskBurdenTest: fillDiseaseRiskBurdenTest}}
     */
    privateMethods = {
        calculateSearchRegion: function(variant) {
            var searchBand = 50000;// 50 kb
            var returnValue = "";
            if (variant){
                if ((typeof variant["CHROM"] !== 'undefined') &&
                    (typeof variant["POS"] !== 'undefined')){ // an't do anything without chromosome number and sequence position
                    var chromosomeIdentifier = variant["CHROM"];  // String
                    var position = variant["POS"];// number
                    var beginPosition = Math.max(0,position-searchBand);
                    var endPosition = position+searchBand;
                    returnValue = "chr"+chromosomeIdentifier + ":"+beginPosition + "-"+endPosition;
                }
            }
            return returnValue;
        },
        showPercentageAcrossEthnicities: function (variant) {
            var retVal = "";
            var ethnicAbbreviation = ['AA', 'EA', 'SA', 'EU', 'HS'];
            var ethnicityFullName = ["African-Americans", "East Asians", "South Asians", "Europeans", "Hispanics"];
            for (var i = 0; i < ethnicAbbreviation.length; i++) {
                var stringProportion = variant['_13k_T2D_' + ethnicAbbreviation[i] + '_MAF'];
                var proportion = parseFloat(stringProportion);
                retVal += "<li>";

                retVal += ((proportion * 100).toPrecision(3) + " percent of " + ethnicityFullName [i]);
                retVal += " (";
                retVal += UTILS.frequencyCharacterization(proportion, [0, 0.005, 0.05]);
                retVal += (")" +
                    "</li>");
            }
            return  retVal;
        },
        fillHowCommonIsUpBarChart: function (africanAmericanFrequency, hispanicFrequency, eastAsianFrequency, southAsianFrequency, europeanSequenceFrequency, europeanChipFrequency) {
            if ((typeof africanAmericanFrequency !== 'undefined')) {
                var dataForBarChart = [
                        { value: africanAmericanFrequency,
                            position: 2,
                            barname: 'African-American',
                            barsubname: '',
                            barsubnamelink: 'http://www.google.com',
                            inbar: '',
                            descriptor: ''},
                        {value: hispanicFrequency,
                            position: 4,
                            barname: 'Hispanic',
                            barsubname: '',
                            barsubnamelink: 'http://www.google.com',
                            inbar: '',
                            descriptor: ''},
                        { value: eastAsianFrequency,
                            position: 6,
                            barname: 'East Asian',
                            barsubname: '',
                            barsubnamelink: 'http://www.google.com',
                            inbar: '',
                            descriptor: ''},
                        {  value: southAsianFrequency,
                            position: 8,
                            barname: 'South Asian',
                            barsubname: '',
                            barsubnamelink: 'http://www.google.com',
                            inbar: '',
                            descriptor: ''},
                        { value: europeanSequenceFrequency,
                            position: 10,
                            barname: 'European',
                            barsubname: '',
                            barsubnamelink: 'http://www.google.com',
                            inbar: '',
                            descriptor: '(exome sequence)'},
                        { value: europeanChipFrequency,
                            position: 11,
                            barname: ' ',
                            barsubname: '',
                            barsubnamelink: 'http://www.google.com',
                            inbar: '',
                            descriptor: '(exome chip)'}
                    ],
                    roomForLabels = 120,
                    maximumPossibleValue = (Math.max(africanAmericanFrequency, hispanicFrequency, eastAsianFrequency, southAsianFrequency, europeanSequenceFrequency, europeanChipFrequency) * 1.5),
                    labelSpacer = 10;

                var margin = {top: 20, right: 20, bottom: 0, left: 70},
                    width = 800 - margin.left - margin.right,
                    height = 300 - margin.top - margin.bottom;

                var commonBarChart = baget.barChart('howCommonIsChart')
                    .width(width)
                    .height(height)
                    .margin(margin)
                    .roomForLabels(roomForLabels)
                    .maximumPossibleValue(maximumPossibleValue)
                    .labelSpacer(labelSpacer)
                    .dataHanger("#howCommonIsChart",dataForBarChart);
                d3.select("#howCommonIsChart").call(commonBarChart.render);
                return commonBarChart;
            }

        },
        fillCarrierStatusDiseaseRisk: function (homozygCase, heterozygCase, nonCarrierCase,
                                                homozygControl, heterozygControl, nonCarrierControl) {
            if ((typeof homozygCase !== 'undefined')) {
                var data3 = [
                        { value: 1,
                            position: 1,
                            barname: 'Cases',
                            barsubname: '',
                            barsubnamelink:'http://www.google.com',
                            inbar: '',
                            descriptor: '(total '+(+nonCarrierCase)+')',
                            inset: 1 },
                        { value:  homozygCase,
                            position: 2,
                            barname: ' ',
                            barsubname: '',
                            barsubnamelink:'http://www.google.com',
                            inbar: '',
                            descriptor: '',
                            legendText: '2 copies (homozygous)'},
                        {value: heterozygCase,
                            position: 3,
                            barname: '  ',
                            barsubname: '',
                            barsubnamelink:'http://www.google.com',
                            inbar: '',
                            descriptor: '',
                            legendText: '1 copy (heterozygous)'},
                        { value: nonCarrierCase-(homozygCase+heterozygCase),
                            position: 4,
                            barname: '   ',
                            barsubname: '',
                            barsubnamelink:'http://www.google.com',
                            inbar: '',
                            descriptor: '',
                            legendText: '0 copies'},
                        {  value: 1,
                            position:  6,
                            barname: 'Controls',
                            barsubname: '',
                            barsubnamelink:'http://www.google.com',
                            inbar: '',
                            descriptor: '(total '+(nonCarrierControl)+')',
                            inset: 1 },
                        {  value: homozygControl,
                            position:  7,
                            barname: '    ',
                            barsubname: '',
                            barsubnamelink:'http://www.google.com',
                            inbar: '',
                            descriptor: ''},
                        { value: heterozygControl,
                            position: 8,
                            barname: '     ',
                            barsubname: '',
                            barsubnamelink:'http://www.google.com',
                            inbar: '',
                            descriptor: ''},
                        { value: nonCarrierControl-(homozygControl+heterozygControl),
                            position: 9,
                            barname: '      ',
                            barsubname: '',
                            barsubnamelink:'http://www.google.com',
                            inbar: '',
                            descriptor: ''}

                    ],
                    roomForLabels = 20,
                    maximumPossibleValue = (Math.max(homozygCase, heterozygCase, nonCarrierCase,homozygControl, heterozygControl, nonCarrierControl) * 1.5),
                    labelSpacer = 10;

                var margin = {top: 140, right: 20, bottom: 0, left: 0},
                    width = 800 - margin.left - margin.right,
                    height = 520 - margin.top - margin.bottom;

                var barChart = baget.barChart('carrierStatusDiseaseRiskChart')
                    .selectionIdentifier("#carrierStatusDiseaseRiskChart")
                    .width(width)
                    .height(height)
                    .margin(margin)
                    .roomForLabels (roomForLabels)
                    .maximumPossibleValue (7000)
                    .labelSpacer (labelSpacer)
                    .assignData(data3)
                    .integerValues(1)
                    .logXScale(1)
                    .customBarColoring(1)
                    .customLegend(1)
                    .dataHanger("#carrierStatusDiseaseRiskChart",data3);
                d3.select("#carrierStatusDiseaseRiskChart").call(barChart.render);
                return barChart;
            }

        },

        showEthnicityPercentageWithBarChart: function (variant) {
            var retVal = "";
            var ethnicAbbreviation = ['AA', 'EA', 'SA', 'EU', 'HS'];
            var ethnicityPercentages = [];
            for (var i = 0; i < ethnicAbbreviation.length; i++) {
                var stringProportion = variant['_13k_T2D_' + ethnicAbbreviation[i] + '_MAF'];
                ethnicityPercentages.push(parseFloat(stringProportion)*100);
            }
            var euroValue  = parseFloat(variant["EXCHP_T2D_MAF"]) ;
            if (variant["EXCHP_T2D_P_value"]) {
                ethnicityPercentages.push(parseFloat(euroValue)*100);
            }
            // We have everything we need to build the bar chart.  Store the functional reference in an object
            // that we can call whenever we want
            delayedHowCommonIsPresentation = {
                barchartPtr:{},
                launch:function(){
                    barchartPtr =  privateMethods.fillHowCommonIsUpBarChart(ethnicityPercentages[0],
                        ethnicityPercentages[4],
                        ethnicityPercentages[1],
                        ethnicityPercentages[2],
                        ethnicityPercentages[3],
                        ethnicityPercentages[5]
                    );
                    return barchartPtr;
                },
                removeBarchart:function(){
                    if ((typeof barchartPtr !== 'undefined') &&
                        (typeof barchartPtr.clear !== 'undefined')){
                        barchartPtr.clear('howCommonIsChart');
                    }
                }

            }
        },

        showCarrierStatusDiseaseRisk: function (variant,show_gwas,show_exchp,show_exseq,show_sigma) {
            var heta=1,hetu=1,totalCases=1,
                homa=1,homu=1,totalControls=1;
            try {
                if (show_exseq){
                    heta = parseFloat(variant["_13k_T2D_HETA"]);
                    hetu = parseFloat(variant["_13k_T2D_HETU"]);
                    homa = parseFloat(variant["_13k_T2D_HOMA"]);
                    homu = parseFloat(variant["_13k_T2D_HOMU"]);
                    totalCases = parseFloat(variant["_13k_T2D_OBSA"]);
                    totalControls = parseFloat(variant["_13k_T2D_OBSU"]);
                } else if (show_sigma){
                    heta = parseFloat(variant["SIGMA_T2D_HETA"]);
                    hetu = parseFloat(variant["SIGMA_T2D_HETU"]);
                    homa = parseFloat(variant["SIGMA_T2D_HOMA"]);
                    homu = parseFloat(variant["SIGMA_T2D_HOMU"]);
                    totalCases = parseFloat(variant["SIGMA_T2D_OBSA"]);
                    totalControls = parseFloat(variant["SIGMA_T2D_OBSU"]);
                }





            }catch(e){}

            delayedCarrierStatusDiseaseRiskPresentation = {
                barchartPtr:{},
                launch:function(){
                    barchartPtr =  privateMethods.fillCarrierStatusDiseaseRisk(homa,
                        heta,
                        totalCases,
                        homu,
                        hetu,
                        totalControls);
                    return barchartPtr;
                },
                removeBarchart:function(){
                    if ((typeof barchartPtr !== 'undefined') &&
                        (typeof barchartPtr.clear !== 'undefined')){
                        barchartPtr.clear('carrierStatusDiseaseRiskChart');
                    }
                }

            }

           // return privateMethods.fillCarrierStatusDiseaseRisk(homa,heta,totalCases,homu,hetu,totalControls);
        },
        variantGenerateProteinsChooserTitle:  function (variant, title) {
            var retVal = "";
            retVal += "<h2><strong>What effect does " +title+ " have on the encoded protein?</strong></h2>";
            return retVal;
        },
        variantGenerateProteinsChooser:  function (variant, title) {
            var retVal = "";
            if (variant.MOST_DEL_SCORE && variant.MOST_DEL_SCORE < 4) {
                retVal += "<p>Choose one transcript below to see the predicted effect on the protein:</p>";
                var allKeys = Object.keys(variant._13k_T2D_TRANSCRIPT_ANNOT);
                for ( var  i=0 ; i<allKeys.length ; i++ ) {
                    var checked = (i==0) ? ' checked ' : '';
                    var annotation =variant._13k_T2D_TRANSCRIPT_ANNOT[allKeys[i]];
                    retVal += ("<div class=\"radio-inline\">\n" +
                        "<label>\n"+
                        "<input "+checked+" class='transcript-radio' type='radio' name='transcript_check' id='transcript-" +allKeys[i] +
                        "' value='" +allKeys[i]+ "' onclick='UTILS.variantInfoRadioChange(" +
                        "\""+annotation['PolyPhen_SCORE']+ "\"," +
                        "\""+annotation['SIFT_SCORE']+ "\"," +
                        "\""+annotation['Condel_SCORE']+ "\"," +
                        "\""+annotation['MOST_DEL_SCORE']+ "\"," +
                        "\""+annotation['_13k_ANNOT_29_mammals_omega']+ "\"," +
                        "\""+annotation['Protein_position']+ "\"," +
                        "\""+annotation['Codons']+ "\"," +
                        "\""+annotation['Protein_change']+ "\"," +
                        "\""+annotation['PolyPhen_PRED']+ "\"," +
                        "\""+annotation['Consequence']+ "\"," +
                        "\""+annotation['Condel_PRED']+ "\"," +
                        "\""+annotation['SIFT_PRED']+ "\"" +
                        ")' >\n"+
                        allKeys[i]+"\n"+
                        "</label>\n"+
                        "</div>\n");
                }
                if (allKeys.length > 0){
                    var annotation =variant._13k_T2D_TRANSCRIPT_ANNOT[allKeys[0]];
                    UTILS.variantInfoRadioChange(annotation['PolyPhen_SCORE'],
                        annotation['SIFT_SCORE'],
                        annotation['Condel_SCORE'],
                        annotation['MOST_DEL_SCORE'],
                        annotation['_13k_ANNOT_29_mammals_omega'],
                        annotation['Protein_position'],
                        annotation['Codons'],
                        annotation['Protein_change'],
                        annotation['PolyPhen_PRED'],
                        annotation['Consequence'],
                        annotation['Condel_PRED'],
                        annotation['SIFT_PRED'] );

                }


            }
            return retVal;
        },
        fillUpBarChart: function  (peopleWithDiseaseNumeratorString,peopleWithDiseaseDenominatorString,peopleWithoutDiseaseNumeratorString,peopleWithoutDiseaseDenominatorString) {
        var peopleWithDiseaseDenominator,
            peopleWithoutDiseaseDenominator,
            peopleWithDiseaseNumerator,
            peopleWithoutDiseaseNumerator,
            calculatedPercentWithDisease,
            calculatedPercentWithoutDisease,
            proportionWithDiseaseDescriptiveString,
            proportionWithoutDiseaseDescriptiveString;
        if ((typeof peopleWithDiseaseDenominatorString !== 'undefined') &&
            (typeof peopleWithoutDiseaseDenominatorString !== 'undefined')) {
            peopleWithDiseaseDenominator = parseInt(peopleWithDiseaseDenominatorString);
            peopleWithoutDiseaseDenominator = parseInt(peopleWithoutDiseaseDenominatorString);
            peopleWithDiseaseNumerator = parseInt(peopleWithDiseaseNumeratorString);
            peopleWithoutDiseaseNumerator = parseInt(peopleWithoutDiseaseNumeratorString);
            if (( peopleWithDiseaseDenominator !== 0 ) &&
                ( peopleWithoutDiseaseDenominator !== 0 )) {
                calculatedPercentWithDisease = (100 * (peopleWithDiseaseNumerator / (2*peopleWithDiseaseDenominator)));
                calculatedPercentWithoutDisease = (100 * (peopleWithoutDiseaseNumerator / (2*peopleWithoutDiseaseDenominator)));
                proportionWithDiseaseDescriptiveString = "(" + peopleWithDiseaseNumerator + " out of " + peopleWithDiseaseDenominator + ")";
                proportionWithoutDiseaseDescriptiveString = "(" + peopleWithoutDiseaseNumerator + " out of " + peopleWithoutDiseaseDenominator + ")";
                var dataForBarChart = [
                        { value: calculatedPercentWithDisease,
                            barname: 'have T2D',
                            barsubname: '(cases)',
                            barsubnamelink: 'http://www.google.com',
                            inbar: '',
                            descriptor: proportionWithDiseaseDescriptiveString},
                        {value: calculatedPercentWithoutDisease,
                            barname: 'do not have T2D',
                            barsubname: '(controls)',
                            barsubnamelink: 'http://www.google.com',
                            inbar: '',
                            descriptor: proportionWithoutDiseaseDescriptiveString}
                    ],
                    roomForLabels = 120,
                    maximumPossibleValue = (Math.max(calculatedPercentWithDisease, calculatedPercentWithoutDisease) * 1.5),
                    labelSpacer = 10;

                var margin = {top: 0, right: 20, bottom: 0, left: 70},
                    width = 800 - margin.left - margin.right,
                    height = 150 - margin.top - margin.bottom;


                var barChart = baget.barChart('diseaseRiskChart')
                    .selectionIdentifier("#diseaseRiskChart")
                    .width(width)
                    .height(height)
                    .margin(margin)
                    .roomForLabels(roomForLabels)
                    .maximumPossibleValue(maximumPossibleValue)
                    .labelSpacer(labelSpacer)
                    .assignData(dataForBarChart)
                    .dataHanger("#diseaseRiskChart",dataForBarChart);
                d3.select("#diseaseRiskChart").call(barChart.render);
                return barChart;
            }
        }
        },

        fillDiseaseRiskBurdenTest: function  (variant,show_gwas,show_exchp,show_exseq,show_sigma,rootVariantUrl) {
            var hetu = 0,
                heta = 0,
                homa = 0,
                homu = 0,
                totalUnaffected = 0,
                totalAffected = 0,
                pValue = 0;
            if (show_exseq){
                heta = parseFloat(variant["_13k_T2D_HETA"]);
                hetu = parseFloat(variant["_13k_T2D_HETU"]);
                homa = parseFloat(variant["_13k_T2D_HOMA"]);
                homu = parseFloat(variant["_13k_T2D_HOMU"]);
                totalUnaffected = parseFloat(variant["_13k_T2D_OBSU"]);
                totalAffected = parseFloat(variant["_13k_T2D_OBSA"]);
                pValue  = parseFloat(variant["_13k_T2D_P_EMMAX_FE_IV"]);
            } else if (show_sigma){
                heta = parseFloat(variant["SIGMA_T2D_HETA"]);
                hetu = parseFloat(variant["SIGMA_T2D_HETU"]);
                homa = parseFloat(variant["SIGMA_T2D_HOMA"]);
                homu = parseFloat(variant["SIGMA_T2D_HOMU"]);
                totalUnaffected = parseFloat(variant["SIGMA_T2D_OBSU"]);
                totalAffected = parseFloat(variant["SIGMA_T2D_OBSA"]);
                pValue  = parseFloat(variant["SIGMA_T2D_P"]);
            }

           // $('#bhtLossOfFunctionVariants').append(numberOfVariants);

            // variables for bar chart
            var numeratorUnaffected,
                denominatorUnaffected,
                numeratorAffected,
                denominatorAffected;
            if ((totalUnaffected) && (totalAffected)) {
                numeratorUnaffected = hetu + (2 * homu);
                numeratorAffected = heta + (2 * homa);
                denominatorUnaffected =  totalUnaffected;
                denominatorAffected =  totalAffected;
                delayedBurdenTestPresentation = {functionToRun: privateMethods.fillUpBarChart,
                    barchartPtr: {},
                    launch: function () {
                        barchartPtr = privateMethods.fillUpBarChart(numeratorUnaffected, denominatorUnaffected, numeratorAffected, denominatorAffected);
                        return barchartPtr;
                    },
                    removeBarchart: function () {
                        if ((typeof barchartPtr !== 'undefined') &&
                            (typeof barchartPtr.clear !== 'undefined')) {
                            barchartPtr.clear('diseaseRiskChart');
                        }
                    }
                };
            }
            if (pValue  > 0)  {
                var degreeOfSignificance = '';
//                if (pValue < 5e-8)  {
//                    degreeOfSignificance = 'significant difference';
//                } else if (pValue < 5e-2)  {
//                    degreeOfSignificance = 'nominal difference';
//                } ;
                $('#describePValueInDiseaseRisk').append("<p class='slimDescription'>"+degreeOfSignificance+"</p>\n"+
                    "<p  id='bhtMetaBurdenForDiabetes' class='slimDescription'>p="+(pValue.toPrecision(3)) +"</p>");
            }

        }


    }

    /***
     * Now come all the methods we call when the page loads
     */
    $('#variantTitleInAssociationStatistics').append(variantTitle);
    $('#variantCharacterization').append(UTILS.getSimpleVariantsEffect(variant.MOST_DEL_SCORE));
    $('#describingVariantAssociation').append(UTILS.variantInfoHeaderSentence(variant));
    var pVal = UTILS.get_lowest_p_value(variant);
    $('#variantPValue').append((parseFloat(pVal[0])).toPrecision(4));
    $('#variantInfoGeneratingDataSet').append(pVal[1]);
    $('#variantTitle').append(variantTitle);
    $('#exomeDataExistsTheMinorAlleleFrequency').append(variantTitle);
    $('#populationsHowCommonIs').append(variantTitle);
    $('#exploreSurroundingSequenceTitle').append(variantTitle);


    /***
     * store everything we need to launch IGV
     */
    var regionforIgv = privateMethods.calculateSearchRegion(variant);
    delayedIgvLaunch = {
        rememberRegion: regionforIgv,
        launch:function(){
            if (showSigma){
                igvLauncher.launch("#myVariantDiv", regionforIgv,restServerRoot,[1,0,0,1]);
            } else {
                igvLauncher.launch("#myVariantDiv", regionforIgv,restServerRoot,[1,1,1,0]);
            }
        }

    }


    var weHaveVariantsAndAssociations;
    if (showSigma){
        weHaveVariantsAndAssociations = ((variant["IN_GWAS"]) || (variant["GWAS_T2D_PVALUE"]) || (variant["GWAS_T2D_OR"]) ||
            (variant["SIGMA_T2D_P"]) || (variant["SIGMA_T2D_OR"])  );
    } else {
        weHaveVariantsAndAssociations = ((variant["IN_GWAS"]) || (variant["GWAS_T2D_PVALUE"]) || (variant["GWAS_T2D_OR"]) ||
            (variant["EXCHP_T2D_P_value"]) || (variant["EXCHP_T2D_BETA"]) ||
            (variant["_13k_T2D_P_EMMAX_FE_IV"]) || (variant["_13k_T2D_OR_WALD_DOS_FE_IV"]) );
    }

    UTILS.verifyThatDisplayIsWarranted(weHaveVariantsAndAssociations, $('#VariantsAndAssociationsExist'), $('#VariantsAndAssociationsNoExist'));
    if (weHaveVariantsAndAssociations){
        if (showGwas){
            $('#gwasAssociationStatisticsBox').append(UTILS.describeAssociationsStatistics(variant,
                cariantRec,
                cariantRec.IN_GWAS,
                cariantRec.GWAS_T2D_PVALUE,
                cariantRec.GWAS_T2D_OR,
                5e-8,
                5e-4,
                5e-2,
                variantTitle,
                "DIAGRAM GWAS",
                false));
        }
        if ( showSigma){
            $('#gwasSigmaAssociationStatisticsBox').append(UTILS.describeAssociationsStatistics(variant,
                cariantRec,
                cariantRec.IN_GWAS,
                cariantRec.GWAS_T2D_PVALUE,
                cariantRec.GWAS_T2D_OR,
                5e-8,
                5e-4,
                5e-2,
                variantTitle,
                "DIAGRAM GWAS",
                false));
        }
        if (showExchp) {
            $('#exomeChipAssociationStatisticsBox').append(UTILS.describeAssociationsStatistics(variant,
                cariantRec,
                cariantRec.EXCHP_T2D_P_value,
                cariantRec.EXCHP_T2D_P_value,
                cariantRec.EXCHP_T2D_BETA,
                5e-8,
                5e-4,
                5e-2,
                variantTitle,
                "exome chip",
                false,
                true));
        }
        if (showExseq) {
            $('#exomeSequenceAssociationStatisticsBox').append(UTILS.describeAssociationsStatistics(variant,
                cariantRec,
                cariantRec._13k_T2D_P_EMMAX_FE_IV,
                cariantRec._13k_T2D_P_EMMAX_FE_IV,
                cariantRec._13k_T2D_OR_WALD_DOS_FE_IV,
                5e-8,
                5e-4,
                5e-2,
                variantTitle,
                "exome sequence",
                false));
        }
        if (showSigma){
            $('#sigmaAssociationStatisticsBox').append(UTILS.describeAssociationsStatistics(variant,
                cariantRec,
                cariantRec.SIGMA_T2D_P,
                cariantRec.SIGMA_T2D_P,
                cariantRec.SIGMA_T2D_OR,
                5e-8,
                5e-4,
                5e-2,
                variantTitle,
                "Sigma",
                false));
        }
    }



    $('#variantInfoAssociationStatisticsLinkToTraitTable').append(UTILS.fillAssociationStatisticsLinkToTraitTable(variant,
        cariantRec,
        cariantRec.IN_GWAS,
        cariantRec.DBSNP_ID,
        cariantRec.ID,
        traitsStudiedUrlRoot));

    // disease burden
    var weHaveEnoughDataForRiskBurdenTest;
    if (showSigma){
        weHaveEnoughDataForRiskBurdenTest = ((variant["SIGMA_T2D_HETA"]) && (variant["SIGMA_T2D_HETU"]) && (variant["SIGMA_T2D_HOMA"]) &&
            (variant["SIGMA_T2D_HOMU"]) && (variant["SIGMA_T2D_OBSU"]) && (variant["SIGMA_T2D_OBSA"]));
    }else {
        weHaveEnoughDataForRiskBurdenTest = ((variant["_13k_T2D_HETA"]) && (variant["_13k_T2D_HETU"]) && (variant["_13k_T2D_HOMA"]) &&
            (variant["_13k_T2D_HOMU"]) && (variant["_13k_T2D_OBSU"]) && (variant["_13k_T2D_OBSA"]));
    }
    UTILS.verifyThatDisplayIsWarranted(weHaveEnoughDataForRiskBurdenTest, $('#diseaseRiskExists'), $('#diseaseRiskNoExists'));
    if (weHaveEnoughDataForRiskBurdenTest){
        privateMethods.fillDiseaseRiskBurdenTest(variant,showGwas,showExchp,showExseq,showSigma);
    }
    $('#sigmaVariantCharacterization').append(UTILS.sigmaVariantCharacterization(variant, variantTitle));

    // how common is this allele across different ethnicities
    var weHaveEnoughDataToDescribeMinorAlleleFrequencies = ((variant["EXCHP_T2D_MAF"]) && (variant["_13k_T2D_AA_MAF"]) && (variant["_13k_T2D_AA_MAF"]));
    UTILS.verifyThatDisplayIsWarranted(weHaveEnoughDataToDescribeMinorAlleleFrequencies, $('#howCommonIsExists'), $('#howCommonIsNoExists'));
    if (weHaveEnoughDataToDescribeMinorAlleleFrequencies){
        privateMethods.showEthnicityPercentageWithBarChart(variant);
    }

    // case control data set characterization
    var weHaveEnoughDataToCharacterizeCaseControls;
    if (showSigma){
        weHaveEnoughDataToCharacterizeCaseControls  = ((variant["SIGMA_T2D_HETA"]) && (variant["SIGMA_T2D_HETU"]) && (variant["SIGMA_T2D_HOMA"]) &&
            (variant["SIGMA_T2D_HOMU"]) && (variant["SIGMA_T2D_OBSU"]) && (variant["SIGMA_T2D_OBSA"]));
    }else {
        weHaveEnoughDataToCharacterizeCaseControls  = ((variant["_13k_T2D_HETA"]) && (variant["_13k_T2D_HETU"]) && (variant["_13k_T2D_HOMA"]) &&
            (variant["_13k_T2D_HOMU"]) && (variant["_13k_T2D_OBSU"]) && (variant["_13k_T2D_OBSA"]));
    }
    UTILS.verifyThatDisplayIsWarranted(weHaveEnoughDataToCharacterizeCaseControls, $('#carrierStatusExist'), $('#carrierStatusNoExist'));
    if (weHaveEnoughDataToCharacterizeCaseControls){
        privateMethods.showCarrierStatusDiseaseRisk(variant,showGwas,showExchp,showExseq,showSigma);
    }

    $('#effectOfVariantOnProteinTitle').append(privateMethods.variantGenerateProteinsChooserTitle(variant, variantTitle));
    $('#effectOfVariantOnProtein').append(privateMethods.variantGenerateProteinsChooser(variant, variantTitle));
    UTILS.verifyThatDisplayIsWarranted(variant["_13k_T2D_TRANSCRIPT_ANNOT"], $('#variationInfoEncodedProtein'), $('#puntOnNoncodingVariant'));

}
