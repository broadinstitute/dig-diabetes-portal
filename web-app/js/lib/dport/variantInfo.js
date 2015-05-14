var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.variantInfo = (function () {


        var delayedHowCommonIsPresentation = {},
            delayedCarrierStatusDiseaseRiskPresentation = {},
            delayedBurdenTestPresentation = {},
            delayedIgvLaunch = {},
            externalCalculateDiseaseBurden;

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
        };

        /***
         * We need to encapsulate a bunch of methods in order to retain control of everything that's going on.
         * Therefore define a function and surface only those methods that absolutely need to be public.
         *
         * @type {{showPercentageAcrossEthnicities: showPercentageAcrossEthnicities,
     * fillHowCommonIsUpBarChart: fillHowCommonIsUpBarChart,
     * fillCarrierStatusDiseaseRisk: fillCarrierStatusDiseaseRisk,
     * showEthnicityPercentageWithBarChart: showEthnicityPercentageWithBarChart,
     * showCarrierStatusDiseaseRisk: showCarrierStatusDiseaseRisk,
     * variantGenerateProteinsChooserTitle: variantGenerateProteinsChooserTitle,
     * variantGenerateProteinsChooser: variantGenerateProteinsChooser,
     * fillUpBarChart: fillUpBarChart,
     * fillDiseaseRiskBurdenTest: fillDiseaseRiskBurdenTest}}
         */
        var privateMethods = (function () {
            var calculateSearchRegion = function (variant) {
                    var searchBand = 50000;// 50 kb
                    var returnValue = "";
                    if (variant) {
                        if ((typeof variant["CHROM"] !== 'undefined') &&
                            (typeof variant["POS"] !== 'undefined')) { // an't do anything without chromosome number and sequence position
                            var chromosomeIdentifier = variant["CHROM"];  // String
                            var position = variant["POS"];// number
                            var beginPosition = Math.max(0, position - searchBand);
                            var endPosition = position + searchBand;
                            returnValue = "chr" + chromosomeIdentifier + ":" + beginPosition + "-" + endPosition;
                        }
                    }
                    return returnValue;
                },

                fillHowCommonIsUpBarChart = function (africanAmericanFrequency, hispanicFrequency, eastAsianFrequency, southAsianFrequency, europeanSequenceFrequency, europeanChipFrequency, alleleFrequencyStrings) {
                    if ((typeof africanAmericanFrequency !== 'undefined')) {
                        var dataForBarChart = [
                                { value: africanAmericanFrequency,
                                    position: 2,
                                    barname: alleleFrequencyStrings.africanAmerican,
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: ''},
                                {value: hispanicFrequency,
                                    position: 4,
                                    barname: alleleFrequencyStrings.hispanic,
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: ''},
                                { value: eastAsianFrequency,
                                    position: 6,
                                    barname: alleleFrequencyStrings.eastAsian,
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: ''},
                                {  value: southAsianFrequency,
                                    position: 8,
                                    barname: alleleFrequencyStrings.southAsian,
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: ''},
                                { value: europeanSequenceFrequency,
                                    position: 10,
                                    barname: alleleFrequencyStrings.european,
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: alleleFrequencyStrings.exomeSequence},
                                { value: europeanChipFrequency,
                                    position: 11,
                                    barname: ' ',
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: ((typeof europeanChipFrequency !== 'undefined' )?alleleFrequencyStrings.exomeChip:'')}
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
                            .dataHanger("#howCommonIsChart", dataForBarChart);
                        d3.select("#howCommonIsChart").call(commonBarChart.render);
                        return commonBarChart;
                    }

                },
                fillCarrierStatusDiseaseRisk = function (homozygCase, heterozygCase, nonCarrierCase, homozygControl, heterozygControl, nonCarrierControl, carrierStatusImpact) {
                    if ((typeof homozygCase !== 'undefined')) {
                        var data3 = [
                                { value: 1,
                                    position: 1,
                                    barname: carrierStatusImpact.casesTitle,
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: '(' + carrierStatusImpact.designationTotal + ' ' + (+nonCarrierCase) + ')',
                                    inset: 1 },
                                { value: homozygCase,
                                    position: 2,
                                    barname: ' ',
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: '',
                                    legendText: carrierStatusImpact.legendTextHomozygous},
                                {value: heterozygCase,
                                    position: 3,
                                    barname: '  ',
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: '',
                                    legendText: carrierStatusImpact.legendTextHeterozygous},
                                { value: nonCarrierCase - (homozygCase + heterozygCase),
                                    position: 4,
                                    barname: '   ',
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: '',
                                    legendText: carrierStatusImpact.legendTextNoncarrier},
                                {  value: 1,
                                    position: 6,
                                    barname: carrierStatusImpact.controlsTitle,
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: '(' + carrierStatusImpact.designationTotal + ' ' + (nonCarrierControl) + ')',
                                    inset: 1 },
                                {  value: homozygControl,
                                    position: 7,
                                    barname: '    ',
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: ''},
                                { value: heterozygControl,
                                    position: 8,
                                    barname: '     ',
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: ''},
                                { value: nonCarrierControl - (homozygControl + heterozygControl),
                                    position: 9,
                                    barname: '      ',
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: ''}

                            ],
                            roomForLabels = 20,
                            maximumPossibleValue = (Math.max(homozygCase, heterozygCase, nonCarrierCase, homozygControl, heterozygControl, nonCarrierControl) * 1.5),
                            labelSpacer = 10;

                        var margin = {top: 140, right: 20, bottom: 0, left: 0},
                            width = 800 - margin.left - margin.right,
                            height = 520 - margin.top - margin.bottom;

                        var barChart = baget.barChart('carrierStatusDiseaseRiskChart')
                            .selectionIdentifier("#carrierStatusDiseaseRiskChart")
                            .width(width)
                            .height(height)
                            .margin(margin)
                            .roomForLabels(roomForLabels)
                            .maximumPossibleValue(10000)
                            .labelSpacer(labelSpacer)
                            .assignData(data3)
                            .integerValues(1)
                            .logXScale(1)
                            .customBarColoring(1)
                            .customLegend(1)
                            .dataHanger("#carrierStatusDiseaseRiskChart", data3);
                        d3.select("#carrierStatusDiseaseRiskChart").call(barChart.render);
                        return barChart;
                    }

                },

                showEthnicityPercentageWithBarChart = function (variant, alleleFrequencyStrings) {
                    var retVal = "";
                    var ethnicAbbreviation = ['AA', 'EA', 'SA', 'EU', 'HS'];
                    var ethnicityPercentages = [];
                    var retainBarchartPtr;
                    for (var i = 0; i < ethnicAbbreviation.length; i++) {
                        var stringProportion = variant['_13k_T2D_' + ethnicAbbreviation[i] + '_MAF'];
                        ethnicityPercentages.push(parseFloat(stringProportion) * 100);
                    }
                    // with a special case:  the chip data may be null, but we still want to show the rest of the plot.
                    // Replace the value with 'undefined' and the bar chart machinery knows to not display a bar
                    var euroValue;
                    if (variant["EXCHP_T2D_MAF"] !==  null ){
                        euroValue = parseFloat(variant["EXCHP_T2D_MAF"]);
                        if (variant["EXCHP_T2D_P_value"]) {
                            euroValue = parseFloat(euroValue) * 100;
                        }
                    }
                    ethnicityPercentages.push(euroValue);
//                    var euroValue = parseFloat(variant["EXCHP_T2D_MAF"]);
//                    if (variant["EXCHP_T2D_P_value"]) {
//                        ethnicityPercentages.push(parseFloat(euroValue) * 100);
//                    }
                    // We have everything we need to build the bar chart.  Store the functional reference in an object
                    // that we can call whenever we want
                    delayedHowCommonIsPresentation = {
                        barchartPtr: retainBarchartPtr,
                        launch: function () {
                            retainBarchartPtr = fillHowCommonIsUpBarChart(ethnicityPercentages[0],
                                ethnicityPercentages[4],
                                ethnicityPercentages[1],
                                ethnicityPercentages[2],
                                ethnicityPercentages[3],
                                ethnicityPercentages[5],
                                alleleFrequencyStrings
                            );
                            return retainBarchartPtr;
                        },
                        removeBarchart: function () {
                            if ((typeof retainBarchartPtr !== 'undefined') &&
                                (typeof retainBarchartPtr.clear !== 'undefined')) {
                                retainBarchartPtr.clear('howCommonIsChart');
                            }
                        }

                    }
                },

                showCarrierStatusDiseaseRisk = function (variant, show_gwas, show_exchp, show_exseq, show_sigma, carrierStatusImpact) {
                    var heta = 1, hetu = 1, totalCases = 1,
                        homa = 1, homu = 1, totalControls = 1,
                        retainBarchartPtr;
                    try {
                        if (show_exseq) {
                            heta = parseFloat(variant["_13k_T2D_HETA"]);
                            hetu = parseFloat(variant["_13k_T2D_HETU"]);
                            homa = parseFloat(variant["_13k_T2D_HOMA"]);
                            homu = parseFloat(variant["_13k_T2D_HOMU"]);
                            totalCases = parseFloat(variant["_13k_T2D_OBSA"]);
                            totalControls = parseFloat(variant["_13k_T2D_OBSU"]);
                        } else if (show_sigma) {
                            heta = parseFloat(variant["SIGMA_T2D_HETA"]);
                            hetu = parseFloat(variant["SIGMA_T2D_HETU"]);
                            homa = parseFloat(variant["SIGMA_T2D_HOMA"]);
                            homu = parseFloat(variant["SIGMA_T2D_HOMU"]);
                            totalCases = parseFloat(variant["SIGMA_T2D_OBSA"]);
                            totalControls = parseFloat(variant["SIGMA_T2D_OBSU"]);
                        }


                    } catch (e) {
                    }

                    delayedCarrierStatusDiseaseRiskPresentation = {
                        barchartPtr: retainBarchartPtr,
                        launch: function () {
                            retainBarchartPtr = fillCarrierStatusDiseaseRisk(homa,
                                heta,
                                totalCases,
                                homu,
                                hetu,
                                totalControls,
                                carrierStatusImpact);
                            return retainBarchartPtr;
                        },
                        removeBarchart: function () {
                            if ((typeof retainBarchartPtr !== 'undefined') &&
                                (typeof retainBarchartPtr.clear !== 'undefined')) {
                                retainBarchartPtr.clear('carrierStatusDiseaseRiskChart');
                            }
                        }

                    }

                },
                variantGenerateProteinsChooserTitle = function (variant, title, impactOnProtein) {
                    var retVal = "";
                    retVal += "<h2><strong>" + impactOnProtein.subtitle1 + " " + title + " " + impactOnProtein.subtitle2 + "</strong></h2>";
                    return retVal;
                },
                variantGenerateProteinsChooser = function (variant, title, impactOnProtein) {
                    var retVal = "";
                    if (variant.MOST_DEL_SCORE && variant.MOST_DEL_SCORE < 4) {
                        retVal += "<p>" + impactOnProtein.chooseOneTranscript + "</p>";
                        var allKeys = Object.keys(variant._13k_T2D_TRANSCRIPT_ANNOT);
                        for (var i = 0; i < allKeys.length; i++) {
                            var checked = (i == 0) ? ' checked ' : '';
                            var annotation = variant._13k_T2D_TRANSCRIPT_ANNOT[allKeys[i]];
                            retVal += ("<div class=\"radio-inline\">\n" +
                                "<label>\n" +
                                "<input " + checked + " class='transcript-radio' type='radio' name='transcript_check' id='transcript-" + allKeys[i] +
                                "' value='" + allKeys[i] + "' onclick='UTILS.variantInfoRadioChange(" +
                                "\"" + annotation['PolyPhen_SCORE'] + "\"," +
                                "\"" + annotation['SIFT_SCORE'] + "\"," +
                                "\"" + annotation['Condel_SCORE'] + "\"," +
                                "\"" + annotation['MOST_DEL_SCORE'] + "\"," +
                                "\"" + annotation['_13k_ANNOT_29_mammals_omega'] + "\"," +
                                "\"" + annotation['Protein_position'] + "\"," +
                                "\"" + annotation['Codons'] + "\"," +
                                "\"" + annotation['Protein_change'] + "\"," +
                                "\"" + annotation['PolyPhen_PRED'] + "\"," +
                                "\"" + annotation['Consequence'] + "\"," +
                                "\"" + annotation['Condel_PRED'] + "\"," +
                                "\"" + annotation['SIFT_PRED'] + "\"" +
                                ")' >\n" +
                                allKeys[i] + "\n" +
                                "</label>\n" +
                                "</div>\n");
                        }
                        if (allKeys.length > 0) {
                            var annotation = variant._13k_T2D_TRANSCRIPT_ANNOT[allKeys[0]];
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
                                annotation['SIFT_PRED']);

                        }


                    }
                    return retVal;
                },
                fillUpBarChart = function (peopleWithDiseaseNumeratorString, peopleWithDiseaseDenominatorString, peopleWithoutDiseaseNumeratorString, peopleWithoutDiseaseDenominatorString, diseaseBurdenStrings) {
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
                            calculatedPercentWithDisease = (100 * (peopleWithDiseaseNumerator / (2 * peopleWithDiseaseDenominator)));
                            calculatedPercentWithoutDisease = (100 * (peopleWithoutDiseaseNumerator / (2 * peopleWithoutDiseaseDenominator)));
                            proportionWithDiseaseDescriptiveString = "(" + peopleWithDiseaseNumerator + " out of " + peopleWithDiseaseDenominator + ")";
                            proportionWithoutDiseaseDescriptiveString = "(" + peopleWithoutDiseaseNumerator + " out of " + peopleWithoutDiseaseDenominator + ")";
                            var dataForBarChart = [
                                    { value: calculatedPercentWithDisease,
                                        barname:  diseaseBurdenStrings.controlBarName,
                                        barsubname:  diseaseBurdenStrings.controlBarSubName,
                                        barsubnamelink: '',
                                        inbar: '',
                                        descriptor: proportionWithDiseaseDescriptiveString},
                                    {value: calculatedPercentWithoutDisease,
                                        barname: diseaseBurdenStrings.caseBarName,
                                        barsubname: diseaseBurdenStrings.caseBarSubName,
                                        barsubnamelink: '',
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
                                .dataHanger("#diseaseRiskChart", dataForBarChart);
                            d3.select("#diseaseRiskChart").call(barChart.render);
                            return barChart;
                        }
                    }
                },

                fillDiseaseRiskBurdenTest = function (OBSU, OBSA, HOMA, HETA, HOMU, HETU, PVALUE,ORVALUE,
                                                      show_gwas, show_exchp, show_exseq, show_sigma, rootVariantUrl, diseaseBurdenStrings) {
                    var hetu = 0,
                        heta = 0,
                        homa = 0,
                        homu = 0,
                        totalUnaffected = 0,
                        totalAffected = 0,
                        pValue = 0,
                        retainBarchartPtr,
                        oddsRatio;
                    if (show_exseq) {
                        heta = HETA;
                        hetu = HETU;
                        homa = HOMA;
                        homu = HOMU;
                        totalUnaffected = OBSU;
                        totalAffected = OBSA;
                        pValue = PVALUE;
                        oddsRatio = ORVALUE;
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
                        denominatorUnaffected = totalUnaffected;
                        denominatorAffected = totalAffected;
                        delayedBurdenTestPresentation = {
                            functionToRun: fillUpBarChart,
                            barchartPtr: retainBarchartPtr,
                            launch: function () {
                                retainBarchartPtr = fillUpBarChart(numeratorUnaffected, denominatorUnaffected, numeratorAffected, denominatorAffected, diseaseBurdenStrings);
                                return retainBarchartPtr;
                            },
                            removeBarchart: function () {
                                if ((typeof retainBarchartPtr !== 'undefined') &&
                                    (typeof retainBarchartPtr.clear !== 'undefined')) {
                                    retainBarchartPtr.clear('diseaseRiskChart');
                                }
                            }
                        };
                    }
                    if (pValue > 0) {
                        var degreeOfSignificance = '';
                        /*
                         if (pValue < 5e-8)  {
                         degreeOfSignificance = 'significant difference';
                         } else if (pValue < 5e-2)  {
                         degreeOfSignificance = 'nominal difference';
                         } ;
                         */
                        $('#describePValueInDiseaseRisk').append("<p class='slimDescription'>" + degreeOfSignificance + "</p>\n" +
                            "<p  id='bhtMetaBurdenForDiabetes' class='slimAndTallDescription'>p=" + (pValue.toPrecision(3)) +
                            diseaseBurdenStrings.diseaseBurdenPValueQ + "</p>");
                        if (typeof oddsRatio !== 'undefined') {
                            $('#describePValueInDiseaseRisk').append("<p  id='bhtOddsRatioForDiabetes' class='slimAndTallDescription'>OR=" +
                                UTILS.realNumberFormatter(oddsRatio) +diseaseBurdenStrings.diseaseBurdenOddsRatioQ + "</p>");
                        }
                    }

                },
                describeAssociationsStatistics = function (variant, vMap, availableData, pValue, orValue, strongCutOff, mediumCutOff, weakCutOff,
                                                           variantTitle, datatype, includeCaseControlComparison, takeExpOfOr, variantAssociationStrings) {
                    var retVal = "";
                    var significanceDescriptor = "";
                    var orValueNumerical;
                    var orValueNumericalAdjusted;
                    var orValueText = "";
                    var iMap = UTILS.invertMap(vMap);
                    var pNumericalValue = variant[iMap[pValue]];
                    var pTextValue = "";
                    if (variant[iMap[availableData]]) {
                        retVal += "<div class='boxyDisplay ";
                        // may or may not be bold
                        if (pNumericalValue <= strongCutOff) {
                            retVal += "genomeWideSignificant'>";
                            significanceDescriptor = variantAssociationStrings.genomeSignificance;
                        } else if ((pNumericalValue > strongCutOff) &&
                            (pNumericalValue <= mediumCutOff )) {
                            retVal += "locusWideSignificant'>";
                            significanceDescriptor = variantAssociationStrings.locusSignificance;
                        } else if ((pNumericalValue > mediumCutOff) &&
                            (pNumericalValue <= weakCutOff )) {
                            retVal += "nominallySignificant'>";
                            significanceDescriptor = variantAssociationStrings.nominalSignificance;
                        } else {
                            retVal += "notSignificant'>";
                            significanceDescriptor = "not significant";
                        }
                        // always needs descr
                        pTextValue = pNumericalValue.toPrecision(3);
                        retVal += ("<h2>" + datatype + "</h2>");
                        retVal += ("<div class='veryImportantText'>p = " + pTextValue +
                            variantAssociationStrings.associationPValueQ +"</div>");
                        retVal += ("<div class='notVeryImportantText'>" + significanceDescriptor + "</div>");
                        orValueNumerical = variant[iMap[orValue]];
                        if ((orValueNumerical) &&
                            (orValueNumerical !== 'null')) {
                            orValueNumericalAdjusted = (takeExpOfOr === true) ? Math.exp(orValueNumerical) : orValueNumerical;
                            orValueText = orValueNumericalAdjusted.toPrecision(3);
                            retVal += ("<div class='veryImportantText'>OR = " + orValueText +
                                variantAssociationStrings.associationOddsRatioQ + "</div>");
                        }
                        if (includeCaseControlComparison) {
                            ;
                        }
                    } else {
                        retVal += '';
                    }
                    return retVal;
                },
                fillAssociationStatisticsLinkToTraitTable = function (variant, vMap, weHaveData, dbsnp, variantId, rootTraitUrl, variantAssociationStrings) {
                    var retVal = "";
                    var iMap = UTILS.invertMap(vMap);
                    if (variant[iMap[weHaveData]]) {
                        retVal += ("<a class=\"boldlink\" href=\"" + rootTraitUrl + "/" +
                            ((variant[iMap[weHaveData]]) ? (variant[iMap[dbsnp]]) : (variant[iMap[variantId]])) +
                            "\">" + variantAssociationStrings.variantPValues);
                    }
                    return  retVal;
                };


            return {
                // note that that the following methods are never accessed directly and can thus remain private
                //showPercentageAcrossEthnicities: showPercentageAcrossEthnicities,
                //fillHowCommonIsUpBarChart: fillHowCommonIsUpBarChart,
                //fillCarrierStatusDiseaseRisk: fillCarrierStatusDiseaseRisk,
                // fillUpBarChart: fillUpBarChart,

                // public routines
                calculateSearchRegion: calculateSearchRegion,
                showEthnicityPercentageWithBarChart: showEthnicityPercentageWithBarChart,
                showCarrierStatusDiseaseRisk: showCarrierStatusDiseaseRisk,
                variantGenerateProteinsChooserTitle: variantGenerateProteinsChooserTitle,
                variantGenerateProteinsChooser: variantGenerateProteinsChooser,
                fillDiseaseRiskBurdenTest: fillDiseaseRiskBurdenTest,
                describeAssociationsStatistics: describeAssociationsStatistics,
                fillAssociationStatisticsLinkToTraitTable: fillAssociationStatisticsLinkToTraitTable
            }


        }());  // end of private methods


        /***
         * Here is the main publicly available method in this module, which ends up driving, directly or indirectly, most
         * of the rest of the JavaScript code in this file. This method gets executed after the Ajax calls returns with the data.
         *
         *
         * @param data
         * @param variantToSearch
         * @param traitsStudiedUrlRoot
         * @param restServerRoot
         * @param showGwas
         * @param showExchp
         * @param showExseq
         * @param showSigma
         */
        function fillTheFields(data, variantToSearch, traitsStudiedUrlRoot, restServerRoot, showGwas, showExchp, showExseq, showSigma, textStringObject) {
            var variantObj = data['variant'],
                variant = variantObj['variant-info'],
                variantTitle = UTILS.get_variant_title(variant, variantToSearch),
                setTitlesAndTheLikeFromData = function (variantTitle, variant) {
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
                },
                prepareDelayedIgvLaunch = function (variant, showSigma, restServerRoot) {
                    /***
                     * store everything we need to launch IGV
                     */
                    var regionforIgv = privateMethods.calculateSearchRegion(variant);
                    return {
                        rememberRegion: regionforIgv,
                        launch: function () {
                            if (showSigma) {
                                igvLauncher.launch("#myVariantDiv", regionforIgv, restServerRoot, [1, 0, 0, 1]);
                            } else {
                                igvLauncher.launch("#myVariantDiv", regionforIgv, restServerRoot, [1, 1, 1, 0]);
                            }
                        }
                    };
                },
                variantAssociations = function (variant, showSigma, variantTitle, traitsStudiedUrlRoot, variantAssociationStrings) {
                    var weHaveVariantsAndAssociations;
                    if (showSigma) {
                        weHaveVariantsAndAssociations = ((variant["IN_GWAS"]) || (variant["GWAS_T2D_PVALUE"]) || (variant["GWAS_T2D_OR"]) ||
                            (variant["SIGMA_T2D_P"]) || (variant["SIGMA_T2D_OR"])  );
                    } else {
                        weHaveVariantsAndAssociations = ((variant["IN_GWAS"]) || (variant["GWAS_T2D_PVALUE"]) || (variant["GWAS_T2D_OR"]) ||
                            (variant["EXCHP_T2D_P_value"]) || (variant["EXCHP_T2D_BETA"]) ||
                            (variant["_13k_T2D_P_EMMAX_FE_IV"]) || (variant["_13k_T2D_OR_WALD_DOS_FE_IV"]) );
                    }

                    UTILS.verifyThatDisplayIsWarranted(weHaveVariantsAndAssociations, $('#VariantsAndAssociationsExist'), $('#VariantsAndAssociationsNoExist'));
                    if (weHaveVariantsAndAssociations) {
                        if (showGwas) {
                            $('#gwasAssociationStatisticsBox').append(privateMethods.describeAssociationsStatistics(variant,
                                cariantRec,
                                cariantRec.IN_GWAS,
                                cariantRec.GWAS_T2D_PVALUE,
                                cariantRec.GWAS_T2D_OR,
                                5e-8,
                                5e-4,
                                5e-2,
                                variantTitle,
                                textStringObject.variantAssociationStrings.sourceDiagram+
                                    textStringObject.variantAssociationStrings.sourceDiagramQ,
                                false,
                                false,
                                variantAssociationStrings));
                        }
                        if (showSigma) {
                            $('#gwasSigmaAssociationStatisticsBox').append(privateMethods.describeAssociationsStatistics(variant,
                                cariantRec,
                                cariantRec.IN_GWAS,
                                cariantRec.GWAS_T2D_PVALUE,
                                cariantRec.GWAS_T2D_OR,
                                5e-8,
                                5e-4,
                                5e-2,
                                variantTitle,
                                textStringObject.variantAssociationStrings.sourceDiagram+
                                    textStringObject.variantAssociationStrings.sourceDiagramQ,
                                false,
                                false,
                                variantAssociationStrings));
                        }
                        if (showExchp) {
                            $('#exomeChipAssociationStatisticsBox').append(privateMethods.describeAssociationsStatistics(variant,
                                cariantRec,
                                cariantRec.EXCHP_T2D_P_value,
                                cariantRec.EXCHP_T2D_P_value,
                                cariantRec.EXCHP_T2D_BETA,
                                5e-8,
                                5e-4,
                                5e-2,
                                variantTitle,
                                textStringObject.variantAssociationStrings.sourceExomeChip+
                                    textStringObject.variantAssociationStrings.sourceExomeChipQ,
                                false,
                                true,
                                variantAssociationStrings));
                        }
                        if (showExseq) {
                            $('#exomeSequenceAssociationStatisticsBox').append(privateMethods.describeAssociationsStatistics(variant,
                                cariantRec,
                                cariantRec._13k_T2D_P_EMMAX_FE_IV,
                                cariantRec._13k_T2D_P_EMMAX_FE_IV,
                                cariantRec._13k_T2D_OR_WALD_DOS_FE_IV,
                                5e-8,
                                5e-4,
                                5e-2,
                                variantTitle,
                                textStringObject.variantAssociationStrings.sourceExomeSequence+
                                    textStringObject.variantAssociationStrings.sourceExomeSequenceQ,
                                false,
                                false,
                                variantAssociationStrings));
                        }
                        if (showSigma) {
                            $('#sigmaAssociationStatisticsBox').append(privateMethods.describeAssociationsStatistics(variant,
                                cariantRec,
                                cariantRec.SIGMA_T2D_P,
                                cariantRec.SIGMA_T2D_P,
                                cariantRec.SIGMA_T2D_OR,
                                5e-8,
                                5e-4,
                                5e-2,
                                variantTitle,
                                textStringObject.variantAssociationStrings.sourceSigma+
                                    textStringObject.variantAssociationStrings.sourceSigmaQ,
                                false,
                                false,
                                variantAssociationStrings));
                        }
                    }
                    $('#variantInfoAssociationStatisticsLinkToTraitTable').append(privateMethods.fillAssociationStatisticsLinkToTraitTable(variant,
                        cariantRec,
                        cariantRec.IN_GWAS,
                        cariantRec.DBSNP_ID,
                        cariantRec.ID,
                        traitsStudiedUrlRoot,
                        variantAssociationStrings));

                },

                calculateDiseaseBurden = function (OBSU, OBSA, HOMA, HETA, HOMU, HETU, PVALUE,ORVALUE,
                    variantTitle, showSigma, showGwas, showExchp, showExseq, diseaseBurdenStrings) {// disease burden
                    var weHaveEnoughDataForRiskBurdenTest;
                    if (showSigma) {
                        weHaveEnoughDataForRiskBurdenTest =  (!UTILS.nullSafetyTest([OBSU, OBSA, HOMA, HETA, HOMU, HOMU  ]));
                    } else {
                        weHaveEnoughDataForRiskBurdenTest =  (!UTILS.nullSafetyTest ([OBSU, OBSA, HOMA, HETA, HOMU, HOMU ]));
                    }
                    UTILS.verifyThatDisplayIsWarranted(weHaveEnoughDataForRiskBurdenTest, $('#diseaseRiskExists'), $('#diseaseRiskNoExists'));
                    if (weHaveEnoughDataForRiskBurdenTest) {
                        privateMethods.fillDiseaseRiskBurdenTest(OBSU, OBSA, HOMA, HETA, HOMU, HETU, PVALUE,ORVALUE, showGwas, showExchp, showExseq, showSigma, null, diseaseBurdenStrings);
                    }
                    $('#sigmaVariantCharacterization').append(UTILS.sigmaVariantCharacterization(variant, variantTitle));
                };
            // externalize!
            // externalize!
            externalCalculateDiseaseBurden = calculateDiseaseBurden;
                var howCommonIsThisVariantAcrossEthnicities = function (variant, alleleFrequencyStrings) {// how common is this allele across different ethnicities
                    var weHaveEnoughDataToDescribeMinorAlleleFrequencies = (!UTILS.nullsExist (variant,["_13k_T2D_AA_MAF"]));
                    UTILS.verifyThatDisplayIsWarranted(weHaveEnoughDataToDescribeMinorAlleleFrequencies, $('#howCommonIsExists'), $('#howCommonIsNoExists'));
                    if (weHaveEnoughDataToDescribeMinorAlleleFrequencies) {
                        privateMethods.showEthnicityPercentageWithBarChart(variant, alleleFrequencyStrings);
                    }
                },
                showHowCarriersAreDistributed = function (variant, showGwas, showExchp, showExseq, showSigma, carrierStatusImpact) {// case control data set characterization
                    var weHaveEnoughDataToCharacterizeCaseControls;
                    if (showSigma) {
                        weHaveEnoughDataToCharacterizeCaseControls = (!UTILS.nullsExist (variant,["SIGMA_T2D_HETA","SIGMA_T2D_HETU", "SIGMA_T2D_HOMA", "SIGMA_T2D_HOMU", "SIGMA_T2D_OBSU", "SIGMA_T2D_OBSA"  ]));
                    } else {
                        weHaveEnoughDataToCharacterizeCaseControls = (!UTILS.nullsExist (variant,["_13k_T2D_HETA","_13k_T2D_HETU", "_13k_T2D_HOMA", "_13k_T2D_HOMU", "_13k_T2D_OBSU", "_13k_T2D_OBSA"  ]));
                    }
                    UTILS.verifyThatDisplayIsWarranted(weHaveEnoughDataToCharacterizeCaseControls, $('#carrierStatusExist'), $('#carrierStatusNoExist'));
                    if (weHaveEnoughDataToCharacterizeCaseControls) {
                        privateMethods.showCarrierStatusDiseaseRisk(variant, showGwas, showExchp, showExseq, showSigma, carrierStatusImpact);
                    }
                },
                describeImpactOfVariantOnProtein = function (variant, variantTitle, impactOnProtein) {
                    $('#effectOfVariantOnProteinTitle').append(privateMethods.variantGenerateProteinsChooserTitle(variant, variantTitle, impactOnProtein));
                    $('#effectOfVariantOnProtein').append(privateMethods.variantGenerateProteinsChooser(variant, variantTitle, impactOnProtein));
                    UTILS.verifyThatDisplayIsWarranted(variant["_13k_T2D_TRANSCRIPT_ANNOT"], $('#variationInfoEncodedProtein'), $('#puntOnNoncodingVariant'));
                };


            /***
             * the following top-level routines do all the work in fillTheFields
             */
            setTitlesAndTheLikeFromData(variantTitle, variant);
            delayedIgvLaunch = prepareDelayedIgvLaunch(variant, showSigma, restServerRoot);
            variantAssociations(variant, showSigma, variantTitle, traitsStudiedUrlRoot, textStringObject.variantAssociationStrings);

            calculateDiseaseBurden(parseFloat(variant["_13k_T2D_HETA"]),parseFloat(variant["_13k_T2D_HETU"]),parseFloat(variant["_13k_T2D_HOMA"]),parseFloat(variant["_13k_T2D_HOMU"]),
                parseFloat(variant["_13k_T2D_OBSU"]),parseFloat(variant["_13k_T2D_OBSA"]),parseFloat(variant["_13k_T2D_P_EMMAX_FE_IV"]),parseFloat(variant["_13k_T2D_OR_WALD_DOS_FE_IV"]),
                variantTitle, showSigma, showGwas, showExchp, showExseq, textStringObject.diseaseBurdenStrings);
            howCommonIsThisVariantAcrossEthnicities(variant, textStringObject.alleleFrequencyStrings);
            showHowCarriersAreDistributed(variant, showGwas, showExchp, showExseq, showSigma, textStringObject.carrierStatusImpact);
            describeImpactOfVariantOnProtein(variant, variantTitle, textStringObject.impactOnProtein);
        };

        var retrieveDelayedHowCommonIsPresentation = function () {
                return delayedHowCommonIsPresentation;
            },
            retrieveDelayedCarrierStatusDiseaseRiskPresentation = function () {
                return delayedCarrierStatusDiseaseRiskPresentation;
            },
            retrieveDelayedBurdenTestPresentation = function () {
                return delayedBurdenTestPresentation;
            },
            retrieveCalculateDiseaseBurden = function () {
                return externalCalculateDiseaseBurden;
            },

            retrieveDelayedIgvLaunch = function () {
                return delayedIgvLaunch;
            };

        return {
            // private routines MADE PUBLIC FOR UNIT TESTING ONLY (find a way to do this in test mode only)

            // public routines
            retrieveCalculateDiseaseBurden:retrieveCalculateDiseaseBurden,
            fillTheFields: fillTheFields,
            retrieveDelayedHowCommonIsPresentation: retrieveDelayedHowCommonIsPresentation,
            retrieveDelayedCarrierStatusDiseaseRiskPresentation: retrieveDelayedCarrierStatusDiseaseRiskPresentation,
            retrieveDelayedBurdenTestPresentation: retrieveDelayedBurdenTestPresentation,
            retrieveDelayedIgvLaunch: retrieveDelayedIgvLaunch
        }


    }());


})();

