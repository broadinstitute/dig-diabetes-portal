var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.geneInfo = (function () {

        var delayedDataPresentation = {},

        prepVAndADisplay = function (dialogSelector,openerSelector){
            $(dialogSelector).dialog({
                autoOpen: false,
                show: {
                    effect: "fade",
                    duration: 500
                },
                hide: {
                    effect: "fade",
                    duration: 500
                },
                width: 560,
                modal: true
            });
            $(".ui-dialog-titlebar").hide();

            // open the v and a adjuster widget
            var popUpVAndAExtender = function () {
                $("#dialog").dialog("open");
            };
            $("#opener").click(popUpVAndAExtender);

        },


        // initialize the main phenotype drop-down
        fillPhenotypeDropDown = function (phenotypeTableChooser,defaultPhenotype,retrievePhenotypesUrl,callbackFn){
            $.ajax({
                cache: false,
                type: "post",
                url: retrievePhenotypesUrl,
                data: {},
                async: true,
                success: function (data) {
                    if (( data !== null ) &&
                        ( typeof data !== 'undefined') &&
                        ( typeof data.datasets !== 'undefined' ) &&
                        (  data.datasets !== null )) {

                        UTILS.fillPhenotypeCompoundDropdown(data.datasets, phenotypeTableChooser, true);
                        // Can we set the default option on the phenotype list?
                        //$(phenotypeTableChooser).val(defaultPhenotype);
                        // Can we set the default option on the phenotype list?  If not simply pick the first phenotype
                        var availPhenotypes = [];
                        _.forEach( $(phenotypeTableChooser+" option"), function(a){
                            availPhenotypes.push($(a).val());
                        });
                        if (availPhenotypes.indexOf(defaultPhenotype)>-1){
                            $(phenotypeTableChooser).val(defaultPhenotype);
                        } else if (availPhenotypes.length>0){
                            if ((availPhenotypes[0]==='default')||(availPhenotypes.length>1)){
                                $(phenotypeTableChooser).val(availPhenotypes[1]);
                            } else {
                                $(phenotypeTableChooser).val(availPhenotypes[0]);
                            }
                        }

                        callbackFn({'value': defaultPhenotype});
                    }
                },
                error: function (jqXHR, exception) {
                    core.errorReporter(jqXHR, exception);
                }
            });


        },




        /***
         *    geneInfoJsonMap:  Access the interior of the JSON records  symbolically
         */
        geneInfoJsonMap = (function () {
            var geneInfoRec = {
                    ID: 1,
                    CHROM: 2,
                    BEG: 3,
                    END: 4,
                    Function_description: 5,
                    _13k_T2D_VAR_TOTAL: 6,
                    _13k_T2D_ORIGIN_VAR_TOTALS: 7,
                    HS: 8,
                    AA: 9,
                    EU: 10,
                    EA: 11,
                    SA: 12,
                    SING: 13,
                    RARE: 14,
                    LOW_FREQUENCY: 15,
                    COMMON: 16,
                    TOTAL: 17,
                    NS: 18,
                    _17k_T2D_lof_NVAR: 19,
                    _17k_T2D_lof_MINA_MINU_RET: 20,
                    _17k_T2D_lof_P_METABURDEN: 21,
                    _13k_T2D_GWS_TOTAL: 22,
                    _13k_T2D_NOM_TOTAL: 23,
                    EXCHP_T2D_VAR_TOTALS: 24,
                    EXCHP_T2D_GWS_TOTAL: 25,
                    EXCHP_T2D_NOM_TOTAL: 26,
                    GWS_TRAITS: 27,
                    GWAS_T2D_GWS_TOTAL: 28,
                    GWAS_T2D_NOM_TOTAL: 29,
                    GWAS_T2D_VAR_TOTAL: 30,
                    EXCHP_T2D_VAR_TOTALS_EU_TOTAL: 31,
                    SIGMA_T2D_VAR_TOTAL: 32,
                    SIGMA_T2D_GWS_TOTAL: 33,
                    SIGMA_T2D_NOM_TOTAL: 34,
                    _17k_T2D_lof_OBSA: 35,
                    _17k_T2D_lof_OBSU: 36,
                    GWAS_T2D_LWS_TOTAL: 37,
                    EXCHP_T2D_LWS_TOTAL: 38,
                    _13k_T2D_LWS_TOTAL: 39,
                    SIGMA_T2D_lof_OBSA: 40,
                    SIGMA_T2D_lof_OBSU: 41,
                    SIGMA_T2D_lof_NVAR: 42,
                    SIGMA_T2D_lof_MINA: 43,
                    SIGMA_T2D_lof_MINU: 44,
                    SIGMA_T2D_lof_P: 45
                },
                revG = function (d) {
                    var v;
                    switch (d) {
                        case 1:
                            v = "ID";
                            break;
                        case 2:
                            v = "CHROM";
                            break;
                        case 3:
                            v = "BEG";
                            break;
                        case 4:
                            v = "END";
                            break;
                        case 5:
                            v = "Function_description";
                            break;
                        case 6:
                            v = "_13k_T2D_VAR_TOTAL";
                            break;
                        case 7:
                            v = "_13k_T2D_ORIGIN_VAR_TOTALS";
                            break;
                        case 8:
                            v = "HS";
                            break;
                        case 9:
                            v = "AA";
                            break;
                        case 10:
                            v = "EU";
                            break;
                        case 11:
                            v = "EA";
                            break;
                        case  12:
                            v = "SA";
                            break;
                        case  13:
                            v = "SING";
                            break;
                        case  14:
                            v = "RARE";
                            break;
                        case  15:
                            v = "LOW_FREQUENCY";
                            break;
                        case  16:
                            v = "COMMON";
                            break;
                        case  17:
                            v = "TOTAL";
                            break;
                        case  18:
                            v = "NS";
                            break;
                        case  19:
                            v = "_17k_T2D_lof_NVAR";
                            break;
                        case  20:
                            v = "_17k_T2D_lof_MINA_MINU_RET";
                            break;
                        case  21:
                            v = "_17k_T2D_lof_P_METABURDEN";
                            break;
                        case  22:
                            v = "_13k_T2D_GWS_TOTAL";
                            break;
                        case  23:
                            v = "_13k_T2D_NOM_TOTAL";
                            break;
                        case  24:
                            v = "EXCHP_T2D_VAR_TOTALS";
                            break;
                        case  25:
                            v = "EXCHP_T2D_GWS_TOTAL";
                            break;
                        case  26:
                            v = "EXCHP_T2D_NOM_TOTAL";
                            break;
                        case  27:
                            v = "GWS_TRAITS";
                            break;
                        case  28:
                            v = "GWAS_T2D_GWS_TOTAL";
                            break;
                        case  29:
                            v = "GWAS_T2D_NOM_TOTAL";
                            break;
                        case  30:
                            v = "GWAS_T2D_VAR_TOTAL";
                            break;
                        case  31:
                            v = "EXCHP_T2D_VAR_TOTALS.EU.TOTAL";
                            break;
                        case  32:
                            v = "SIGMA_T2D_VAR_TOTAL";
                            break;
                        case  33:
                            v = "SIGMA_T2D_GWS_TOTAL";
                            break;
                        case  34:
                            v = "SIGMA_T2D_NOM_TOTAL";
                            break;
                        case  35:
                            v = "_17k_T2D_lof_OBSA";
                            break;
                        case  36:
                            v = "_17k_T2D_lof_OBSU";
                            break;
                        case  37:
                            v = "GWAS_T2D_LWS_TOTAL";
                            break;
                        case  38:
                            v = "EXCHP_T2D_LWS_TOTAL";
                            break;
                        case  40:
                            v = "SIGMA_T2D_lof_OBSA";
                            break;
                        case  41:
                            v = "SIGMA_T2D_lof_OBSU";
                            break;
                        case  42:
                            v = "SIGMA_T2D_lof_NVAR";
                            break;
                        case  43:
                            v = "SIGMA_T2D_lof_MINA";
                            break;
                        case  44:
                            v = "SIGMA_T2D_lof_MINU";
                            break;
                        case  45:
                            v = "SIGMA_T2D_lof_P";
                            break;
                        default:
                            v = "";
                    }
                    return v;
                },
                fieldName = function (fieldId) {
                    return revG(fieldId);
                },
                fieldSymbol = function () {
                    return  geneInfoRec;
                };
            return {
                fieldName: fieldName,
                fieldSymbol: fieldSymbol
            }
        }()),


        /***
         * Pushback  the region of a search from a gene
         * @param geneExtentBeginning
         * @returns {number}
         */
        expandRegionBegin = function (geneExtentBeginning) {
            if (geneExtentBeginning) {
                return Math.max(geneExtentBeginning - 500000, 0);
            } else {
                return 0;
            }
        },


        /***
         *
         * @param geneExtentEnding
         * @returns {*}
         */
        expandRegionEnd = function (geneExtentEnding) {
            if (geneExtentEnding) {
                return geneExtentEnding + 500000;
            } else {
                return 0;
            }
        },


        /***
         *  Fill out some DOM structures conditionally. Used in the  variant and associations table on the gene info page
         * @param rawGeneInfo
         * @param show_gwas
         * @param show_exchp
         * @param show_exseq
         * @param rootRegionUrl
         * @param rootTraitUrl
         * @param rootVariantUrl
         * @param significanceStrings
         */
        fillVarianceAndAssociations = function (rawGeneInfo, show_gwas, show_exchp, show_exseq, rootRegionUrl, rootTraitUrl, rootVariantUrl, significanceStrings) {
            // show traits
            if (show_gwas) {
                var signficanceStatement = document.createElement('strong');
                if (rawGeneInfo["GWS_TRAITS"]) {
                    var traitArray = rawGeneInfo["GWS_TRAITS"];
                    if (traitArray.length > 0) {
                        $(significanceStatement).append("<p>" + significanceStrings.significantAssociations + "</p>");

                        var listOfGenes = document.createElement('ul');
                        for (var i = 0; i < traitArray.length; i++) {
                            var traitRepresentation = "";
                            if ((typeof phenotype !== "undefined" ) &&
                                (phenotype.phenotypeMap) &&
                                (phenotype.phenotypeMap [traitArray[i]])) {

                                traitRepresentation = phenotype.phenotypeMap [traitArray[i]];

                            } else {
                                traitRepresentation = traitArray[i];
                            }
                            if (!(traitRepresentation.indexOf('diabetes') > -1)) {  // special case: don't include diabetes, since it is above in table
                                var listElement = document.createElement('li');
                                var geneLink = document.createElement('a');
                                $(geneLink).attr({
                                    href: rootTraitUrl + "?trait=" + traitArray[i] + "&significance=5e-8'>" + traitRepresentation
                                });
                                $(listElement).append(geneLink);
                                $(listOfGenes).append(listElement);
                            }
                        }
                    }
                } else {
                    $(signficanceStatement).append("<p>" + significanceStrings.noSignificantAssociationsExist + "</p>");
                }
                $('#gwasTraits').append(signficanceStatement);
            }
        },

        /***
         * convenience method to build an anchor with all the right fields
         * @param displayableContents
         * @param geneName
         * @param filter
         * @param rootVariantUrl
         * @returns {string}
         */
        buildAnchorForVariantSearches = function (displayableContents, geneName, filter, rootVariantUrl) {
            var returnValue = document.createElement('a');
            $(returnValue).attr({
                class: 'boldlink',
                href: rootVariantUrl + "/" + geneName + "?filter=" + filter
            });
            $(returnValue).append(displayableContents);
            return  returnValue;
        },
        anchorVariantSearches = function (displayableContents, geneName, rowElement, colElement, rootVariantUrl,parmType) {
            var returnValue = document.createElement('a');
            $(returnValue).attr({
                class: 'boldlink',
                href: rootVariantUrl + '/' + geneName + '?dataset=' + rowElement.dataset + '&parmType=' + parmType + '&parmVal=' + colElement.code + '~' + rowElement.technology
            });
            $(returnValue).append(displayableContents);
            return returnValue;
        };


        var fillVariationAcrossEthnicityTable = function ( rootVariantUrl,
                                                           continentalAncestryText,
                                                           rowSequence,
                                                           colSequence,
                                                           parmType,
                                                           geneId) {
            //  directly executed code begins below this line
            $('#continentalVariationTableBody tr').remove() // start by removing any existing records (since we launched every time the accordion opens)
            if (rowSequence) {
                for ( var i = 0 ; i < rowSequence.length ; i++ ) {
                    var singleRow = document.createElement('tr');
                    var rowTitle = document.createElement('td');
                    $(rowTitle).attr({class: 'vandaRowTd', style: 'text-align: left'});
                    var rowTitleTextDiv = document.createElement('div');
                    $(rowTitleTextDiv).attr({class: 'vandaRowHdr',
                                          id: 'mafTableRow' + i,
                                          datasetname: rowSequence[i].dataset,
                                          translatedName: rowSequence[i].datasetDisplayName});

                    $(rowTitle).append(rowTitleTextDiv);
                    $(singleRow).append(rowTitle);
                    $(singleRow).append('<td id="mafTechnology'+i+'">' + rowSequence[i].technology + '</td>');
                    for ( var j = 0 ; j < rowSequence[i].values.length ; j++ ){
                        if (j===0){// sample count has no link
                            $(singleRow).append('<td>' +rowSequence[i].values[j] + '</td>');
                        } else {
                            var td = document.createElement('td');
                            $(td).append(anchorVariantSearches(rowSequence[i].values[j], geneId, rowSequence[i],colSequence[j], rootVariantUrl, parmType));
                            $(singleRow).append(td);
                        }
                    }
                    $('#continentalVariationTableBody').append(singleRow);
                }

            }

        };

        var buildAnchorForRegionVariantSearches = function (displayableContents, geneName, significanceFilter, dataset, regionSpecification, rootVariantUrl, phenotype) {
            var returnValue = document.createElement('a');
            $(returnValue).attr({
                class: 'boldlink',
                href: rootVariantUrl + "/" + geneName + "?sig=" + significanceFilter + "&dataset=" + dataset + "&region=" + regionSpecification + "&phenotype=" + phenotype
            });
            $(returnValue).append(displayableContents);
            return returnValue;
        };
        var buildAnchorForGeneVariantSearches = function (displayableContents, geneName, significanceFilter, dataset, junk, rootVariantUrl, phenotype) {
            var returnValue = document.createElement('a');
            $(returnValue).attr({
                class: 'boldlink',
                href: rootVariantUrl + "/" + geneName + "?sig=" + significanceFilter + "&dataset=" + dataset + "&phenotype=" + phenotype
            });
            $(returnValue).append(displayableContents);
            return returnValue;
        };
        var fillVariantsAndAssociationLine = function (geneName,// our gene record
                                                       dataset,// dataset id
                                                       translatedName,// the human-friendly version
                                                       sampleSize, // listed sample size for this data set
                                                       rowTechnology, // Which technology describes this data set
                                                       genomicRegion, // region specified as in this example: chr1:209348715-210349783
                                                       valueArray, // data for this row
                                                       columnMap, // since we are doing a whole row we need to know about all columns
                                                       anchorBuildingFunction,  // which anchor building function should we use
                                                       rootVariantUrl, // root URL is the basis for callbacks
                                                       rowHelpText,
                                                       phenotype,
                                                       rowNumber) { // help text for each row
            if (geneName) {
                var tableRow = document.createElement('tr');
                var tableRowTitle = document.createElement('td');
                $(tableRowTitle).attr({
                    class: 'vandaRowTd',
                    style: 'text-align: left'
                });
                var tableRowTitleText = document.createElement('div');
                $(tableRowTitleText).attr({
                    class: 'vandaRowHdr',
                    id: 'vandaRow' + rowNumber,
                    datasetname: dataset,
                    translatedName: translatedName
                });
                $(tableRowTitle).append(tableRowTitleText);
                $(tableRowTitle).append('<p>' + translatedName + '</p>');
                $(tableRow).append(tableRowTitle);
                $(tableRow).append('<td>' + rowTechnology + '</td>');
                $(tableRow).append('<td>' + sampleSize + '</td>');

                for ( var i = 0 ; i < columnMap.length ; i++ ) {
                    var anchorTd = document.createElement('td');
                    $(anchorTd).append(
                        anchorBuildingFunction(valueArray[i], geneName, columnMap[i].value, dataset, genomicRegion, rootVariantUrl, phenotype)
                    );
                    $(tableRow).append(anchorTd);
                }

                $('#variantsAndAssociationsTableBody').append(tableRow);
            }
        };
        var fillVariantsAndAssociationsTable = function (pValuesUrl,
                                                         rootVariantUrl,
                                                         headerText,
                                                         rowHelpText,
                                                         chromosomeNumber,
                                                         extentBegin,
                                                         extentEnd,
                                                         datasets,
                                                         columnInformation,
                                                         geneName,
                                                         phenotype) {

            var regionSpecifier =  chromosomeNumber + ":" +
                extentBegin + "-" +
                extentEnd;

            var headerRow = "<tr>" +
                "<th>" + headerText.hdr1 + "</th>" +
                "<th>" + headerText.hdr4 + "</th>"+
                "<th>" + headerText.hdr2 + "</th>";
            for ( var i = 0 ; i < columnInformation.length ; i++ ) {
                var significanceString =  columnInformation[i].value;
                var significance =  parseFloat(significanceString);

                headerRow += "<th>" + columnInformation[i].name;
                if (significance===0.00000005){
                    headerRow += headerText.gwasSig;
                } else if (significance===0.00005){
                    headerRow += headerText.locusSig;
                } else if (significance===0.05){
                    headerRow += headerText.nominalSig;
                } else if ((significance > 0)  && (significance < 1)){
                    headerRow +=  "<br/><span class='headersubtext'>p&nbsp;&lt;&nbsp;"+significance.toPrecision(2)+"</span>";
                }
                headerRow += "</th>";
            }
            headerRow += "</tr>";
            $('#variantsAndAssociationsHead').append(headerRow);
            
            var allRowPromises = [];
            _.forEach(datasets, function(dataset, index) {
                allRowPromises.push($.ajax({
                    cache: false,
                    type: 'post',
                    url: pValuesUrl,
                    data: {
                        geneName: geneName,
                        dataset: dataset,
                        colNames: _.map(columnInformation, 'value'),
                        phenotype: phenotype
                    },
                    async: true
                }).then(function(data) {
                    var rowProcessorFunction;
                    // we either search by region or by gene name.  We need to decide which reference to build
                    if ((typeof data.dataset !== 'undefined') &&
                        ((data.technology == 'GWAS') || (data.technology =='WGS'))){
                        rowProcessorFunction = buildAnchorForRegionVariantSearches;
                    } else {
                        rowProcessorFunction = buildAnchorForGeneVariantSearches;
                    }

                    var pValues = _.chain(data.values).orderBy(['level'], ['desc']).map('count').value();

                    fillVariantsAndAssociationLine(geneName,
                        data.dataset,
                        data.translatedName,
                        data.subjectsNumber,
                        data.technology,
                        regionSpecifier,
                        pValues,
                        columnInformation,
                        rowProcessorFunction,
                        rootVariantUrl,
                        rowHelpText,
                        phenotype,
                        index
                    );
                }));
            });

            return allRowPromises;
        };




        var fillUpBarChart = function (peopleWithDiseaseNumeratorString, peopleWithDiseaseDenominatorString, peopleWithoutDiseaseNumeratorString, peopleWithoutDiseaseDenominatorString, traitString) {
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
                    calculatedPercentWithDisease = (100 * (peopleWithDiseaseNumerator / peopleWithDiseaseDenominator));
                    calculatedPercentWithoutDisease = (100 * (peopleWithoutDiseaseNumerator / peopleWithoutDiseaseDenominator));
                    proportionWithDiseaseDescriptiveString = "(" + peopleWithDiseaseNumerator + " out of " + peopleWithDiseaseDenominator + ")";
                    proportionWithoutDiseaseDescriptiveString = "(" + peopleWithoutDiseaseNumerator + " out of " + peopleWithoutDiseaseDenominator + ")";
                    var dataForBarChart = [
                            { value: calculatedPercentWithDisease,
                                barname: 'have ' + traitString,
                                barsubname: '(cases)',
                                barsubnamelink: '',
                                inbar: '',
                                descriptor: proportionWithDiseaseDescriptiveString},
                            {value: calculatedPercentWithoutDisease,
                                barname: 'do not have ' + traitString,
                                barsubname: '(controls)',
                                barsubnamelink: '',
                                inbar: '',
                                descriptor: proportionWithoutDiseaseDescriptiveString}
                        ],
                        roomForLabels = 120,
                        maximumPossibleValue = (Math.max(calculatedPercentWithDisease, Math.min(100, calculatedPercentWithoutDisease) * 1.5)),
                        labelSpacer = 10;

                    var margin = {top: 0, right: 20, bottom: 0, left: 50},
                        width = 800 - margin.left - margin.right,
                        height = 150 - margin.top - margin.bottom;


                    // use trait string as name as well
                    var barChart = baget.barChart(traitString)
                        .width(width)
                        .height(height)
                        .margin(margin)
                        .roomForLabels(roomForLabels)
                        .maximumPossibleValue(maximumPossibleValue)
                        .labelSpacer(labelSpacer)
                        .dataHanger("#chart", dataForBarChart);

                    d3.select("#chart").call(barChart.render);
                    return barChart;
                }

            }

        };



        var fillUniprotSummary = function (geneInfo) {
            var funcDescrLine = "";
            if ((geneInfo) && (geneInfo["Function_description"])) {
                funcDescrLine += ("<strong>Uniprot Summary:</strong> " + geneInfo['Function_description']);
            } else {
                funcDescrLine += "No uniprot summary available for this gene"
            }

            $('#uniprotSummaryGoesHere').append(funcDescrLine);
        };
        var retrieveDelayedBiologicalHypothesisOneDataPresenter = function () {
            return delayedDataPresentation;
        };

        var retrieveGeneInfoRec = function () {
            return geneInfoJsonMap.fieldSymbol();
        };

        var fillTheGeneFields = function ( data ) {
            var rawGeneInfo = data['geneInfo'];
            fillUniprotSummary(rawGeneInfo);
        };


        return {
            // private routines MADE PUBLIC FOR UNIT TESTING ONLY (find a way to do this in test mode only)
            expandRegionBegin: expandRegionBegin,
            expandRegionEnd: expandRegionEnd,
            fillVarianceAndAssociations: fillVarianceAndAssociations,
            retrieveGeneInfoRec: retrieveGeneInfoRec,
            buildAnchorForVariantSearches: buildAnchorForVariantSearches,
            fillVariantsAndAssociationLine:fillVariantsAndAssociationLine,


            // public routines
            fillTheGeneFields: fillTheGeneFields,
            prepVAndADisplay:prepVAndADisplay,
            fillPhenotypeDropDown:fillPhenotypeDropDown,
            fillVariationAcrossEthnicityTable:fillVariationAcrossEthnicityTable,
            retrieveDelayedBiologicalHypothesisOneDataPresenter: retrieveDelayedBiologicalHypothesisOneDataPresenter,
            fillVariantsAndAssociationsTable: fillVariantsAndAssociationsTable,
            fillUpBarChart: fillUpBarChart
        }


    }());

})();
