var mpgSoftware = mpgSoftware || {};

(function () {
    "use strict";

    mpgSoftware.variantInfo = (function () {

        // this defines the maximum places to show after the decimal place the box data
        var precision = 3;
        // the upper breakpoints for p-value significance
        var significanceBoundaries = {
            genomeWide: 5e-8,
            locusWide: 5e-4,
            nominal: 5e-2
        };
        // provide the color assignments for the phenotypes
        // if a phenotype is undefined, a random one is generated
        var colorCodeArray = {
            'GLYCEMIC': '#fdb32b',
            'PSYCHIATRIC': '#32fd2f',
            'RENAL': '#28e4fd',
            'ANTHROPOMETRIC': '#5025fb',
            'LIPIDS': '#fc1680',
            'ISCHEMIC STROKE' : '#0099cc',
            'INTRACEREBRAL HEMORRHAGE': '#663300',
            'BLOOD PRESSURE': '#660066'
        };

        var setVariantTitleAndSummary = function (varId, dbsnpId, chrom, pos, gene, closestGene, refAllele, effectAllele) {
            // load all the headers
            // variantTitle defaults to dbsnpId, or if that's undefined, then varId
            var variantTitle = dbsnpId || varId;
            $('#variantTitle').append(variantTitle);
            $("[data-textfield='variantName']").append(variantTitle);
            $('#effectOnCommonProteinsTitle').append(variantTitle);
            $('#exomeDataExistsTheMinorAlleleFrequency').append(variantTitle);
            $('#populationsHowCommonIs').append(variantTitle);
            $('#exploreSurroundingSequenceTitle').append(variantTitle);

            // load the summary text
            $("#chromosomeNumber").append(chrom);
            $("#positionNumber").append(pos);
            if(gene && gene != 'Outside') {
                $('#closestToGeneInfo').hide();
                $('#geneNumber').append('<a href=../../gene/geneInfo/'+gene+'>' + gene + '</a>.');
            } else if (closestGene) {
                $('#inGeneInfo').hide();
                $('#geneNumber').append('<a href=../../gene/geneInfo/'+closestGene+'>' + closestGene + '</a>.');
            } else {
                // we don't have any gene info, so remove those spans
                $('#inGeneInfo').hide();
                $('#closestToGeneInfo').hide();
            }
            $("#referenceNucleotide").append(refAllele);
            $("#variantNucleotide").append(effectAllele);
            // we're punting this for now, but we don't want to forget it
            if(new Date() > Date(2016, 8, 1)) {
                console.error('The genome build number hardcoding needs to be fixed');
            }
            $("#genomeBuildNumber").append('hg19');
        };

        var displayTranscriptSummaries = function(transcripts, variantSummaryText) {
            // in the event we have no transcripts, don't try to show the table
            if(transcripts == null || transcripts.length == 0) {
                $('#transcriptHeader').hide();
                return;
            }

            var transcriptTemplate = document.getElementById('transcriptTableTemplate').innerHTML;
            Mustache.parse(transcriptTemplate);
            // build up the arrays for each field. because the table is horizontal (i.e. the
            // different variants are named going left to right, not top to bottom) we can't
            // really use the objects the variants came in. so long as the arrays aren't changed
            // wrt order, then things should display fine
            var transcriptName = [];
            var proteinChange = [];
            var polyphen = [];
            var sift = [];
            var consequence = [];

            _.each(transcripts, function(transcriptData, transcriptKey) {
                transcriptName.push(transcriptKey);
                proteinChange.push(transcriptData.Protein_change);
                polyphen.push(transcriptData.PolyPhen_PRED);
                sift.push(transcriptData.SIFT_PRED);
                consequence.push(transcriptData.Consequence);
            });

            var renderData = {
                transcriptName: transcriptName,
                transcriptNameText: function() {
                    // todo: figure out how to link to Ensembl
                    return this;
                },
                proteinChange: proteinChange,
                polyphen: polyphen,
                sift: sift,
                consequence: consequence
            };

            var transcriptTableHtml = Mustache.render(transcriptTemplate, renderData);
            $('#transcriptHeader').append(transcriptTableHtml);
        };
        var retrieveFunctionalData = function(callingData,callback,additionalData){
            var loading = $('#spinner');
            var args = _.flatten([{}, callingData.variant.variants[0]]);
            var variantObject = _.merge.apply(_, args);
            $.ajax({
                cache: false,
                type: "post",
                url: additionalData.retrieveFunctionalDataAjaxUrl,
                data: {
                    chromosome: variantObject.CHROM,
                    startPos: ""+variantObject.POS,
                    endPos: ""+variantObject.POS,
                    lzFormat:0
                },
                async: true
            }).done(function (data, textStatus, jqXHR) {

                callback(data,additionalData);


            }).fail(function (jqXHR, textStatus, errorThrown) {
                loading.hide();
                core.errorReporter(jqXHR, errorThrown)
            });
        };
        var initializePage = function(data, variantToSearch, traitInfoUrl, restServer, variantSummaryText,portalType,
                                      lzDomHolder,collapseDomHolder,phenotypeName,phenotypeDescription,propertyName,locusZoomDataset,
                                      geneLocusZoomUrl,
                                      variantInfoUrl,makeDynamic,retrieveFunctionalDataAjaxUrl) {
            var loading = $('#spinner').show();
            // this call loads the data for the disease burden, 'how common is this variant', and IGV
            // viewer components
            if ( typeof data !== 'undefined')  {
                fillTheFields(data, variantToSearch, traitInfoUrl, restServer);
            }

            var args = _.flatten([{}, data.variant.variants[0]]);
            var variantObject = _.merge.apply(_, args);

            setVariantTitleAndSummary(variantObject.VAR_ID,
                                        variantObject.DBSNP_ID,
                                        variantObject.CHROM,
                                        variantObject.POS,
                                        variantObject.GENE,
                                        variantObject.CLOSEST_GENE,
                                        variantObject.Reference_Allele,
                                        variantObject.Effect_Allele);

            displayTranscriptSummaries(variantObject.TRANSCRIPT_ANNOT, variantSummaryText);

            // pretty much arbitrary
            var locusZoomRange = 80000;
            var positioningInformation = {
                chromosome: variantObject.CHROM,
                startPosition: variantObject.POS - locusZoomRange,
                endPosition: variantObject.POS + locusZoomRange
            };

            mpgSoftware.locusZoom.initializeLZPage('variantInfo', variantObject.VAR_ID, positioningInformation,
                lzDomHolder,collapseDomHolder,phenotypeName,phenotypeDescription,propertyName,locusZoomDataset,'junk',
                geneLocusZoomUrl,
                variantInfoUrl,makeDynamic,retrieveFunctionalDataAjaxUrl,true);


            $('[data-toggle="popover"]').popover();

            $(".pop-top").popover({placement : 'top'});
            $(".pop-right").popover({placement : 'right'});
            $(".pop-bottom").popover({placement : 'bottom'});
            $(".pop-left").popover({ placement : 'left'});
            $(".pop-auto").popover({ placement : 'auto'});

            loading.hide();
        };

        /**
         * Fills in all of the associations at a glance boxes. Retrieves all of the data, then decides which
         * phenotype is the primary based on the portal type (as specified by the defaultPhenotype argument).
         * @param phenotypeDatasetMap   map of phenotypes and associated datasets
         * @param variantId
         * @param variantAssociationStrings     strings used for variant summary text
         * @param dataUrl
         * @param defaultPhenotype
         */
        var retrieveVariantPhenotypeData = function(phenotypeDatasetMap, variantId, variantAssociationStrings, dataUrl, defaultPhenotype) {
            // use this array to track all the promises from the AJAX calls so we only
            // execute once all are finished
            var arrayOfPromises = [];

            // store all the retrieved data across the calls so we can process on it later
            var phenotypeData = [];
            // make the ajax call to get the data for each phenotype
            _.forEach(phenotypeDatasetMap, function(datasets, phenotype) {
                var thisRequest = $.ajax({
                    cache: false,
                    type: 'get',
                    url: dataUrl,
                    data: {
                        variantId: variantId,
                        phenotype: phenotype,
                        datasets: JSON.stringify(_.values(datasets))
                    },
                    async: true
                });
                arrayOfPromises.push(
                    thisRequest.done(function(data, textStatus, jqXHR) {
                        // this is the translated phenotype
                        var displayName = data.displayName;
                        // groupedByDataset has as keys dataset names, mapping to arrays
                        // that contain all of the data--need to go through each array, and pull
                        // each property into a new object
                        // omit any data items where count is null or undefined
                        var groupedByDataset = _.chain(data.pVals).filter('count').groupBy('dataset').omit('common').value();
                        var processedDatasets = [];
                        _.each(groupedByDataset, function(arrayOfValues) {
                            var thisDataset = {};
                            _.each(arrayOfValues, function(property) {
                                thisDataset.dataset = property.dataset;     // this is the same for every property
                                thisDataset[property.meaning] = property.count;
                                if(property.datasetCode) {
                                    // this exists to support getting the count property
                                    thisDataset.datasetCode = property.datasetCode;
                                }
                            });

                            // tack on count from the previously-loaded data
                            thisDataset.count = parseInt(datasets[thisDataset.datasetCode].count);
                            thisDataset.phenotypeGroup = datasets[thisDataset.datasetCode].phenotypeGroup;
                            processedDatasets.push(thisDataset);
                        });
                        // remove datasets that don't have p_values defined--occasionally we'll have datasets
                        // that have counts or other info, but no p-values, which would result in a box with
                        // "NaN" showing
                        processedDatasets = _.chain(processedDatasets).filter('p_value').sortBy('p_value').value();
                        // check to see if any dataset has at least a nominal signficance
                        // reject those that don't. If none do, then don't display anything
                        // for this phenotype
                        var areThereAnySignificantDatasets = _.some(processedDatasets, function(dataset) {
                            // in the event that we're on the T2D portal, we want to include the T2D
                            // association regardless of if there's any significant associations
                            if(defaultPhenotype == 'T2D' && phenotype == 'T2D') {
                                return true;
                            }
                            return dataset.p_value <= significanceBoundaries.nominal;
                        });
                        if( ! areThereAnySignificantDatasets ) {
                            // no dataset has a p-value that is at least nominally significant,
                            // so don't display anything for this phenotype
                            return;
                        }

                        // all of the dataset objects are now processed and ordered correctly
                        // save the data for later
                        phenotypeData.push({
                            displayName: displayName,
                            // this field exists so we know which phenotype has the smallest p-value
                            // since processedDatasets is sorted by p-value, the first element has the smallest p-value
                            bestPVal: processedDatasets[0].p_value,
                            datasets: processedDatasets,
                            // need this so we can track the T2D phenotype even when the portal
                            // is not being displayed in English
                            phenotype: phenotype
                        });
                        
                    }).fail(function(jqXHR, textStatus, errorThrown) {
                        core.errorReporter(jqXHR, errorThrown);
                    })
                );
            });

            // when every AJAX call has returned, then sort the results and add them to the
            // document--this way, everything gets shown in the correct order consistently
            $.when.apply($, arrayOfPromises).then(function() {
                // in case of data problems, abandon ship
                if(phenotypeData.length == 0) {
                    return;
                }
                if(defaultPhenotype == 'T2D') {
                    // pull out t2d object and display that for primary
                    var t2dData = _.find(phenotypeData, {phenotype: 'T2D'});
                    fillPrimaryPhenotypeBoxes(t2dData, variantAssociationStrings);
                    // everything else is other
                    var everythingElse = _.chain(phenotypeData).reject({phenotype: 'T2D'}).sortBy('bestPVal').value();
                    fillOtherPhenotypeBoxes(everythingElse, variantAssociationStrings);
                } else {
                    // otherwise, the primary phenotype is the one with the smallest p-value
                    var sortedPhenotypeData = _.sortBy(phenotypeData, 'bestPVal');
                    fillPrimaryPhenotypeBoxes(_.head(sortedPhenotypeData), variantAssociationStrings);
                    fillOtherPhenotypeBoxes(_.tail(sortedPhenotypeData), variantAssociationStrings);
                }
            });

        };

        /**
         * This function fills in the association boxes for the primary phenotype
         */
        var fillPrimaryPhenotypeBoxes = function(data, variantAssociationStrings) {
            var displayName = data.displayName;
            var processedDatasets = _.chain(data.datasets).sortBy('count').reverse().value();
            var generatedHTML = renderAPhenotype(displayName, processedDatasets, 'primary', variantAssociationStrings);
            var rowId = generatedHTML.rowId;
            var phenotypeRow = generatedHTML.renderedRow;
            var associations = generatedHTML.associationsArray;
            // it's apparently easiest to attach the row HTML followed by attaching the boxes to the row,
            // than it is to make a new object from the row HTML, attach the boxes to that, and then attach
            // the object to the document
            $('#primaryPhenotype').append(phenotypeRow);
            _.forEach(associations, function(association) {
                $('#' + rowId + '> ul').append(association);
            });
        };

        var fillOtherPhenotypeBoxes = function(dataArray, variantAssociationStrings) {
            // check for the case where there are no other significant phenotypes
            if(dataArray.length == 0) {
                // change out the text, and hide the button
                $('#otherTraits').hide();
                $('#noOtherTraits').show();
                $('#toggleButton').hide();
                // abandon ship
                return;
            }
            var arrayOfHTMLObjectsToDisplay = [];
            _.each(dataArray, function(phenotypeObject) {
                var displayName = phenotypeObject.displayName;
                var datasets = _.chain(phenotypeObject.datasets).sortBy('count').reverse().value();
                var generatedHTML = renderAPhenotype(displayName, datasets, 'secondary', variantAssociationStrings);
                arrayOfHTMLObjectsToDisplay.push(generatedHTML);
            });

            _.each(arrayOfHTMLObjectsToDisplay, function(generatedHTML) {
                var rowId = generatedHTML.rowId;
                var phenotypeRow = generatedHTML.renderedRow;
                var associations = generatedHTML.associationsArray;
                // it's apparently easiest to attach the row HTML followed by attaching the boxes to the row,
                // than it is to make a new object from the row HTML, attach the boxes to that, and then attach
                // the object to the document
                $('#otherTraitsSection').append(phenotypeRow);
                _.forEach(associations, function(association) {
                    $('#' + rowId + '> ul').append(association);
                });
            });
        };

        /**
         * data should have the following keys:
         * { dataset, pValue, maf, beta } -- maf and beta are optional
         * boxSize must be "primary" or "secondary"
         */
        var createABox = function(data, boxSize, variantAssociationStrings) {
            // compute text colors and text and attach to data object
            //      note: if maf/beta are undefined, need to add an empty string or nbsp
            // parse template
            // fill template
            // return resulting html
            var boxTemplate = document.getElementById('boxTemplate').innerHTML;
            Mustache.parse(boxTemplate);

            // this is all the string processing needed to come up with the right
            // display text and colors
            var templateData = {
                backgroundColor: function() {
                    var thisPval = this.p_value;
                    if( thisPval <= significanceBoundaries.genomeWide ) {
                        return '#006633';
                    } else if ( thisPval > significanceBoundaries.genomeWide && thisPval <= significanceBoundaries.locusWide ) {
                        return '#7AB317'
                    } else if ( thisPval <= significanceBoundaries.nominal ) {
                        return '#9ED54C';
                    } else {
                        // this is &nbsp;
                        return 'white';
                    }
                },
                boxClass: function() {
                    // start this as an array so we can use .join(' ') later,
                    // instead of having to worry about parsing spaces correctly
                    var classStringArray = [];
                    switch(boxSize) {
                        case 'primary':
                            classStringArray.push('info-box', 'normal-info-box');
                            break;
                        case 'secondary':
                            classStringArray.push('info-box', 'small-info-box');
                            break;
                    }

                    if(this.p_value > significanceBoundaries.nominal) {
                        classStringArray.push('not-significant-box');
                    }

                    return classStringArray.join(' ');
                },
                datasetAndPValueTextColor: function() {
                    // changes based on the background color
                    var thisPval = this.p_value;
                    if ( thisPval <= significanceBoundaries.locusWide ) {
                        return 'white'
                    } else {
                        return 'black';
                    }
                },
                pValueText: function() {
                    return 'p = ' + UTILS.parseANumber(this.p_value, precision);
                },
                pValueSignificance: function() {
                    var thisPval = this.p_value;
                    if( thisPval <= significanceBoundaries.genomeWide ) {
                        return variantAssociationStrings.genomeSignificance;
                    } else if ( thisPval > significanceBoundaries.genomeWide && thisPval <= significanceBoundaries.locusWide ) {
                        return variantAssociationStrings.locusSignificance;
                    } else if ( thisPval <= significanceBoundaries.nominal ) {
                        return variantAssociationStrings.nominalSignificance;
                    } else {
                        // this is &nbsp;
                        return '\u00a0';
                    }
                },
                oddsRatioOrEffectTextBackgroundColor: function() {
                    // use this so that we can have one return statement
                    var effectIsUp;
                    if(this.beta_value) {
                        effectIsUp = this.beta_value >= 0;
                    } else if(this.or_value) {
                        effectIsUp = this.or_value >= 1;
                    }
                    if(!_.isUndefined(effectIsUp)) {
                        return effectIsUp ? '#3333cc' : '#9900ff';
                    }
                    return 'transparent';
                },
                effectArrow: function() {
                    // use this so that we can have one return statement
                    var effectIsUp;
                    if(this.beta_value) {
                        effectIsUp = this.beta_value >= 0;
                    } else if(this.or_value) {
                        effectIsUp = this.or_value >= 1;
                    }
                    if(!_.isUndefined(effectIsUp)) {
                        return effectIsUp ? '↑' : '↓';
                    }
                    return '\u00a0';
                },
                oddsRatioOrEffectText: function() {
                    if( this.or_value ) {
                        return 'OR = ' + UTILS.parseANumber(this.or_value, precision);
                    } else if (this.beta_value ) {
                        return 'effect = ' + UTILS.parseANumber(this.beta_value, precision);
                    }
                    // this is &nbsp;
                    return '\u00a0';
                },
                freqInCases: function() {
                    if(this.MAF) {
                        return (this.MAF * 100).toFixed(1) + '%';
                    }
                    return 'n/a';
                },
                countInCases: function() {
                    if(this.MAC) {
                        return this.MAC;
                    } else if (this.MINA && this.MINU) {
                        return this.MINA + this.MINU;
                    } else if (this.OBS) {
                        return (2 * this.OBS * this.MAF).toFixed(0);
                    } else if (this.OBSA && this.MAFA && this.OBSU && this.MAFU) {
                        return (2 * this.OBSA * this.MAFA + 2 * this.OBSU * this.MAFU).toFixed(0);
                    } else if (this.count && this.MAF) {
                        return (2 * this.count * this.MAF).toFixed(0);
                    } else {
                        return 'n/a';
                    }
                }
            };

            var dataToPassIn = {};
            _.assign(dataToPassIn, data, templateData);
            var renderedBox = Mustache.render(boxTemplate, dataToPassIn);
            return renderedBox;
        };

        /**
         * phenotype is a string with the display name of the phenotype
         * dataArray is an array of the objects that will be passed to createABox
         * displayType must be "primary" or "secondary"
         */
        var renderAPhenotype = function(phenotype, dataArray, displaySize, variantAssociationStrings) {
            // generate all the boxes with calls to createABox
            // parse template
            // fill template with phenotype name and color
            // attach boxes to resulting html
            // add to document

            var associationsArray = [];
            // if the phenotype has an odd number of datasets, add a special object to
            // create an empty, invisible box for padding purposes
            if(dataArray.length % 2 == 1) {
                dataArray.push({ emptyBlock: true });
            }
            _.each(dataArray, function(dataset) {
                associationsArray.push(createABox(dataset, displaySize, variantAssociationStrings));
            });

            // the phenotype is the display name, which may have spaces and/or parens,
            // so convert it to something that can work as an HTML id
            var rowId = phenotype.replace(/[\s()]/g, '') + 'Row';

            // generate a random color in case we don't have one defined for this phenotype
            // 4095 = 0xfff, so this just gets a random value between 000 and fff
            var randomColor = '#' + Math.floor((Math.random()*4095)).toString(16);

            var phenotypeRowTemplate = document.getElementById('phenotypeTemplate').innerHTML;
            Mustache.parse(phenotypeRowTemplate);
            var data = {
                phenotypeName: phenotype,
                phenotypeColor: function() {
                    // if there's color defined for this phenotype group, return that
                    // otherwise, return a random 3-character hex value to use as the color
                    if(colorCodeArray[dataArray[0].phenotypeGroup]) {
                        return colorCodeArray[dataArray[0].phenotypeGroup];
                    }
                    // }
                    return randomColor;
                },
                rowClass: function() {
                    switch(displaySize) {
                        case 'primary':
                            return 'normal-info-box-holder';
                        case 'secondary':
                            return 'small-info-box-holder';
                    }
                    return '';
                },
                rowId: rowId
            };
            var renderedRow = Mustache.render(phenotypeRowTemplate, data);

            return {
                rowId: rowId,
                renderedRow: renderedRow,
                associationsArray: associationsArray
            };
        };

        // --------------------------------

        var delayedHowCommonIsPresentation = {},
            delayedCarrierStatusDiseaseRiskPresentation = {},
            delayedBurdenTestPresentation = {},
            delayedIgvLaunch = {},
            externalCalculateDiseaseBurden,
            externalizeCarrierStatusDiseaseRisk,
            externalVariantAssociationStatistics,
            externalizeShowHowCommonIsThisVariantAcrossEthnicities;

        /**
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
            var calculateSearchRegion = function (data) {
                    var searchBand = 50000;// 50 kb
                    var returnValue = "";
                    if (data) {
                        var variant = {};
                        var i;
                        for (i = 0; i < data.length; i++) {
                            if (typeof data[i]["CHROM"] !== 'undefined') {
                                variant["CHROM"] = data[i]["CHROM"];
                            }
                            if (typeof data[i]["POS"] !== 'undefined') {
                                variant["POS"] = data[i]["POS"];
                            }
                        }
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
                
                fillHowCommonIsUpBarChart = function (freqInformation) {
                    if ((typeof freqInformation !== 'undefined') &&
                        (freqInformation.length > 0)) {
                        var dataForBarChart = [];
                        var summaryChart = (freqInformation.length < 10);
                        var extraSmallChart = (freqInformation.length < 4);
                        var chartHeight = (summaryChart) ? 250 : 550;
                        var chartHeight = (extraSmallChart) ? 80 : chartHeight;
                        var useSmallText = (summaryChart) ? 0 : 1;
                        for (var i = 0; i < freqInformation.length; i++) {
                            var cohort = freqInformation[i];
                            var cohortInfo = cohort.level;
                            var cohortFields = cohortInfo.split("^");
                            var displayableCohortName = "unknown ancestry";
                            var translatedCohortName = "unknown ancestry";
                            if (cohortFields.length > 5) {
                                translatedCohortName = cohortFields [5];
                                displayableCohortName = cohortFields [4];
                            }
                            dataForBarChart.push({
                                value: cohort.count * 100,
                                position: i,
                                barname: displayableCohortName,
                                barsubname: '',
                                barsubnamelink: '',
                                inbar: '',
                                descriptor: ('(' + translatedCohortName + ')')
                            })
                        }
                        var sortedDataForBarChart = dataForBarChart.sort(function (a, b) {
                            if (a.barname > b.barname) {
                                return 1;
                            }
                            if (a.barname < b.barname) {
                                return -1;
                            }
                            if (a.value > b.value) {
                                return 1;
                            }
                            if (a.value < b.value) {
                                return -1;
                            }

                            return 0;
                        });
                        for (var i = 0; i < sortedDataForBarChart.length; i++) {
                            sortedDataForBarChart[i].position = i;
                        }
                        var allAlleleValues = freqInformation.map(function (obj) {
                            return obj.count;
                        });

                        var roomForLabels = 120;
                        var maximumPossibleValue = (_.max(allAlleleValues ) * 150);

                        var labelSpacer = 10;

                        var margin = {top: 20, right: 20, bottom: 0, left: 40},
                            width = 800 - margin.left - margin.right,
                            height = chartHeight - margin.top - margin.bottom;

                        var commonBarChart = baget.barChart('howCommonIsChart')
                            .width(width)
                            .height(height)
                            .margin(margin)
                            .roomForLabels(roomForLabels)
                            .maximumPossibleValue(maximumPossibleValue)
                            .labelSpacer(labelSpacer)
                            .smallDescriptorText(useSmallText)
                            .customBarColoring(0)
                            .dataHanger("#howCommonIsChart", sortedDataForBarChart);
                        d3.select("#howCommonIsChart").call(commonBarChart.render);
                        return commonBarChart;
                    }

                },
                
                fillCarrierStatusDiseaseRisk = function (homozygCase, heterozygCase, nonCarrierCase, homozygControl, heterozygControl, nonCarrierControl, carrierStatusImpact) {
                    if ((typeof homozygCase !== 'undefined')) {
                        var data3 = [
                                {
                                    value: 1,
                                    position: 1,
                                    barname: carrierStatusImpact.casesTitle,
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: '(' + carrierStatusImpact.designationTotal + ' ' + (+nonCarrierCase) + ')',
                                    inset: 1
                                },
                                {
                                    value: homozygCase,
                                    position: 2,
                                    barname: ' ',
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: '',
                                    legendText: carrierStatusImpact.legendTextHomozygous
                                },
                                {
                                    value: heterozygCase,
                                    position: 3,
                                    barname: '  ',
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: '',
                                    legendText: carrierStatusImpact.legendTextHeterozygous
                                },
                                {
                                    value: nonCarrierCase - (homozygCase + heterozygCase),
                                    position: 4,
                                    barname: '   ',
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: '',
                                    legendText: carrierStatusImpact.legendTextNoncarrier
                                },
                                {
                                    value: 1,
                                    position: 6,
                                    barname: carrierStatusImpact.controlsTitle,
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: '(' + carrierStatusImpact.designationTotal + ' ' + (nonCarrierControl) + ')',
                                    inset: 1
                                },
                                {
                                    value: homozygControl,
                                    position: 7,
                                    barname: '    ',
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: ''
                                },
                                {
                                    value: heterozygControl,
                                    position: 8,
                                    barname: '     ',
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: ''
                                },
                                {
                                    value: nonCarrierControl - (homozygControl + heterozygControl),
                                    position: 9,
                                    barname: '      ',
                                    barsubname: '',
                                    barsubnamelink: '',
                                    inbar: '',
                                    descriptor: ''
                                }

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

                showEthnicityPercentageWithBarChart = function (ethnicityPercentages) {
                    var retainBarchartPtr;

                    // We have everything we need to build the bar chart.  Store the functional reference in an object
                    // that we can call whenever we want
                    delayedHowCommonIsPresentation = {
                        barchartPtr: retainBarchartPtr,
                        launch: function () {

                            retainBarchartPtr = fillHowCommonIsUpBarChart(ethnicityPercentages);

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

                showCarrierStatusDiseaseRisk = function (OBSU, OBSA, HOMA, HETA, HOMU, HETU, carrierStatusImpact) {
                    var heta = 1, hetu = 1, totalCases = 1,
                        homa = 1, homu = 1, totalControls = 1,
                        retainBarchartPtr;

                    heta = HETA;
                    hetu = HETU;
                    homa = HOMA;
                    homu = HOMU;
                    totalCases = OBSA;
                    totalControls = OBSU;


                    delayedCarrierStatusDiseaseRiskPresentation = {
                        barchartPtr: retainBarchartPtr,
                        launch: function () {
                            d3.select('#carrierStatusDiseaseRiskChart').select('svg').remove();
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
                                    {
                                        value: calculatedPercentWithDisease,
                                        barname: diseaseBurdenStrings.controlBarName,
                                        barsubname: diseaseBurdenStrings.controlBarSubName,
                                        barsubnamelink: '',
                                        inbar: '',
                                        descriptor: proportionWithDiseaseDescriptiveString
                                    },
                                    {
                                        value: calculatedPercentWithoutDisease,
                                        barname: diseaseBurdenStrings.caseBarName,
                                        barsubname: diseaseBurdenStrings.caseBarSubName,
                                        barsubnamelink: '',
                                        inbar: '',
                                        descriptor: proportionWithoutDiseaseDescriptiveString
                                    }
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

                fillDiseaseRiskBurdenTest = function (OBSU, OBSA, MINA, MINU, PVALUE, ORVALUE, rootVariantUrl, diseaseBurdenStrings) {
                    var mina = 0,
                        minu = 0,
                        totalUnaffected = 0,
                        totalAffected = 0,
                        pValue = 0,
                        retainBarchartPtr,
                        oddsRatio;

                    mina = MINA;
                    minu = MINU;
                    totalUnaffected = OBSU;
                    totalAffected = OBSA;
                    pValue = PVALUE;
                    oddsRatio = ORVALUE;

                    // variables for bar chart
                    var numeratorUnaffected,
                        denominatorUnaffected,
                        numeratorAffected,
                        denominatorAffected;
                    if ((totalUnaffected) && (totalAffected)) {
                        numeratorUnaffected = minu;
                        numeratorAffected = mina;
                        denominatorUnaffected = totalUnaffected;
                        denominatorAffected = totalAffected;
                        delayedBurdenTestPresentation = {
                            functionToRun: fillUpBarChart,
                            barchartPtr: retainBarchartPtr,
                            launch: function () {
                                retainBarchartPtr = fillUpBarChart(numeratorUnaffected, denominatorUnaffected, numeratorAffected, denominatorAffected, diseaseBurdenStrings);
                                if (pValue > 0) {
                                    var degreeOfSignificance = '';
                                    // TODO the p's below are piling up.  clean them out
                                    $('#describePValueInDiseaseRisk').append("<p class='slimDescription'>" + degreeOfSignificance + "</p>\n" +
                                        "<p  id='bhtMetaBurdenForDiabetes' class='slimAndTallDescription'>p=" + (pValue.toPrecision(3)) +
                                        diseaseBurdenStrings.diseaseBurdenPValueQ + "</p>");
                                    if (typeof oddsRatio !== 'undefined') {
                                        $('#describePValueInDiseaseRisk').append("<p  id='bhtOddsRatioForDiabetes' class='slimAndTallDescription'>OR=" +
                                            UTILS.realNumberFormatter(oddsRatio) + diseaseBurdenStrings.diseaseBurdenOddsRatioQ + "</p>");
                                    }
                                }
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
                };


            return {
                // public routines
                calculateSearchRegion: calculateSearchRegion,
                showEthnicityPercentageWithBarChart: showEthnicityPercentageWithBarChart,
                showCarrierStatusDiseaseRisk: showCarrierStatusDiseaseRisk,
                variantGenerateProteinsChooser: variantGenerateProteinsChooser,
                fillDiseaseRiskBurdenTest: fillDiseaseRiskBurdenTest
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
         */
        var variantPosition;

        function fillTheFields(data, variantToSearch, traitsStudiedUrlRoot, restServerRoot) {
            var variantObj = data['variant'];
            var variant = variantObj['variants'][0];
            var prepareDelayedIgvLaunch = function (variant, restServerRoot) {
                /***
                 * store everything we need to launch IGV
                 */
                var regionforIgv = privateMethods.calculateSearchRegion(variant);
                return {
                    rememberRegion: regionforIgv,
                    launch: function () {
                        igvLauncher.launch("#myVariantDiv", regionforIgv, restServerRoot, [1, 1, 1, 0]);
                    }
                };
            };
            var prepareIgvLaunch = function (variant, restServerRoot) {
                return {
                    locus: privateMethods.calculateSearchRegion(variant),
                    server: restServerRoot
                };
            };
            var calculateDiseaseBurden = function (OBSU, OBSA, MINA, MINU, HOMA, HETA, HOMU, HETU, PVALUE, ORVALUE, variantTitle, diseaseBurdenStrings) {// disease burden
                var weHaveEnoughDataForRiskBurdenTest;
                weHaveEnoughDataForRiskBurdenTest = (!UTILS.nullSafetyTest([OBSU, OBSA, MINA, MINU]));
                UTILS.verifyThatDisplayIsWarranted(weHaveEnoughDataForRiskBurdenTest, $('#diseaseRiskExists'), $('#diseaseRiskNoExists'));
                if (weHaveEnoughDataForRiskBurdenTest) {
                    privateMethods.fillDiseaseRiskBurdenTest(OBSU, OBSA, MINA, MINU, PVALUE, ORVALUE, null, diseaseBurdenStrings);
                }
            };
            // externalize!
            // externalize!
            externalCalculateDiseaseBurden = calculateDiseaseBurden;
            var howCommonIsThisVariantAcrossEthnicities = function (ethnicityPercentages) {// how common is this allele across different ethnicities
                var weHaveEnoughDataToDescribeMinorAlleleFrequencies = ((typeof ethnicityPercentages !== 'undefined') && (typeof ethnicityPercentages[0] !== 'undefined'));
                if (weHaveEnoughDataToDescribeMinorAlleleFrequencies) {
                    weHaveEnoughDataToDescribeMinorAlleleFrequencies = (!UTILS.nullSafetyTest([ethnicityPercentages[0].count]));
                }
                UTILS.verifyThatDisplayIsWarranted(weHaveEnoughDataToDescribeMinorAlleleFrequencies, $('#howCommonIsExists'), $('#howCommonIsNoExists'));
                if (weHaveEnoughDataToDescribeMinorAlleleFrequencies) {
                    privateMethods.showEthnicityPercentageWithBarChart(ethnicityPercentages);
                }
            };
            externalizeShowHowCommonIsThisVariantAcrossEthnicities = howCommonIsThisVariantAcrossEthnicities;
            var showHowCarriersAreDistributed = function (OBSU, OBSA, HOMA, HETA, HOMU, HETU, carrierStatusImpact) {// case control data set characterization
                var weHaveEnoughDataToCharacterizeCaseControls;
                weHaveEnoughDataToCharacterizeCaseControls = (!UTILS.nullSafetyTest([OBSU, OBSA, HOMA, HETA, HOMU, HETU]));
                UTILS.verifyThatDisplayIsWarranted(weHaveEnoughDataToCharacterizeCaseControls, $('#carrierStatusExist'), $('#carrierStatusNoExist'));
                if (weHaveEnoughDataToCharacterizeCaseControls) {
                    privateMethods.showCarrierStatusDiseaseRisk(OBSU, OBSA, HOMA, HETA, HOMU, HETU, carrierStatusImpact);
                }
            };
            externalizeCarrierStatusDiseaseRisk = showHowCarriersAreDistributed;
            var oldDescribeImpactOfVariantOnProtein = function (variant, variantTitle, impactOnProtein) {
                $('#effectOfVariantOnProteinTitle').append(privateMethods.variantGenerateProteinsChooserTitle(variant, variantTitle, impactOnProtein));
                $('#effectOfVariantOnProtein').append(privateMethods.variantGenerateProteinsChooser(variant, variantTitle, impactOnProtein));
                UTILS.verifyThatDisplayIsWarranted(variant["_13k_T2D_TRANSCRIPT_ANNOT"], $('#variationInfoEncodedProtein'), $('#puntOnNoncodingVariant'));
            };


            /***
             * the following top-level routines do all the work in fillTheFields
             */
            delayedIgvLaunch = prepareDelayedIgvLaunch(variant, restServerRoot);
            variantPosition = prepareIgvLaunch(variant, restServerRoot);

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
            retrieveCarrierStatusDiseaseRisk = function () {
                return externalizeCarrierStatusDiseaseRisk;
            },
            retrieveVariantAssociationStatistics = function () {
                return externalVariantAssociationStatistics;
            },
            retrieveHowCommonIsThisVariantAcrossEthnicities = function () {
                return externalizeShowHowCommonIsThisVariantAcrossEthnicities;
            },
            retrieveDelayedIgvLaunch = function () {
                return delayedIgvLaunch;
            },
            retrieveVariantPosition = function () {
                return variantPosition;
            };

        var tableInitialization = function() {
            $.fn.DataTable.ext.search.push(
                function (settings, data, dataIndex) {
                    var filterName1;
                    var column1ToConsider;
                    var filterName2;
                    var column2ToConsider;
                    if (settings.sInstance === "functionalDataTableGoesHere") {
                        filterName1 = 'div.elementFilter';
                        column1ToConsider = 0;
                        filterName2 = 'div.tissueFilter';
                        column2ToConsider = 1;

                    }
                    var elementFilter = $('select.elementFilter').val();
                    var tissueFilter = $('select.tissueFilter').val();
                    if ((typeof elementFilter === 'undefined') ||
                        (typeof tissueFilter === 'undefined')){
                        return true;
                    } else {
                        var passesElementFilter = false;
                        var passesTissueFilter = false;
                        if ((elementFilter==='ALL')||(data[column1ToConsider] === elementFilter)){
                            passesElementFilter = true;
                        }
                        if ((tissueFilter==='ALL')||(data[column2ToConsider] === tissueFilter)){
                            passesTissueFilter = true;
                        }
                        return passesElementFilter&&passesTissueFilter;
                    }

                }
            );
        };
        var displayFunctionalData = function(data,additionalData){
            if ((typeof data !== 'undefined') &&
                (typeof data.variants !== 'undefined') &&
                (!data.variants.is_error)){
                var rawSortedData = _.sortBy(data.variants.variants,[function(item) {
                    return parseInt(item.element.split('_')[0], 10);
                }, function(item) {
                    return item.source;
                }]);
                var sortedData = [];
                _.forEach(rawSortedData,function(o){
                    sortedData.push({'CHROM':o.CHROM,
                        'START':o.START,
                        'STOP':o.STOP,
                        'source':o.source_trans,
                        'element':o.element_trans
                    })
                })
                var uniqueElements = _.uniqBy(sortedData,function(item) {
                    return item.element;
                });
                var uniqueTissues = _.uniqBy(sortedData,function(item) {
                    return item.source;
                });
                var dataMatrix = [];
                for (var i = 0 ; i < uniqueTissues.length ; i++ ) {
                    var currentRow = [];
                    for (var j = 0 ; j < uniqueElements.length ; j++){

                        if (_.find(sortedData, {source:uniqueTissues[i].source,element:uniqueElements[j].element})){
                            currentRow.push(1);
                        } else {
                            currentRow.push(0);
                        }
                    }
                    dataMatrix.push(currentRow);
                }
                var arrayOfArraysGroupedByTissue = [];
                for (var j = 0 ; j < uniqueTissues.length ; j++){

                    var arrayGroupedByTissue = _.filter(sortedData, {source:uniqueTissues[j].source});
                    arrayOfArraysGroupedByTissue.push(arrayGroupedByTissue);
                }
                var allUniqueElementNames = _.map(uniqueElements,'element');
                var allUniqueTissueNames = _.map(uniqueTissues,'source');
                uniqueElements.push({element:'ALL'});
                uniqueTissues.push({source:'ALL'});

                var renderData = {  'recordsExist': (sortedData.length>1),
                    'indivRecords':sortedData,
                    'uniqueElements':uniqueElements,
                    'uniqueTissues':uniqueTissues};

                buildAnnotationTable('#functionalDataTableGoesHere','urlToFillIn',renderData,{});
                buildAnnotationMatrix (allUniqueElementNames,
                    allUniqueTissueNames,
                    dataMatrix);
                buildMultiTrackDisplay(allUniqueElementNames,
                    allUniqueTissueNames,
                    arrayOfArraysGroupedByTissue,
                    {regionStart:data.variants.region_start,regionEnd:data.variants.region_end,stateColorBy:allUniqueElementNames,mappingInformation:dataMatrix});
                $('select.uniqueElements').val('ALL');
                $('select.uniqueTissues').val('ALL');
            }
        };

        var displayChosenElements = function (){
            $('table.functionDescrTable tr').hide();
            var chosenElement = $('select.uniqueElements').val();
            var chosenTissue = $('select.uniqueTissues').val();
            var specificCombinationIdentifier = 'table.functionDescrTable tr.'+chosenElement+"__"+chosenTissue;
            if (($(specificCombinationIdentifier).length>0)||
                (chosenElement==='ALL')||
                (chosenTissue==='ALL')){
                $('table.functionDescrTable tr.headers').show();
            }
            if ((chosenElement==='ALL')&&(chosenTissue==='ALL')){
                $('table.functionDescrTable tr').show();
            }
            else if (chosenElement==='ALL'){
                $('table.functionDescrTable tr.'+chosenTissue).show();
            }
            else if (chosenTissue==='ALL'){
                $('table.functionDescrTable tr.'+chosenElement).show();
            } else {
                $('table.functionDescrTable tr.'+chosenElement+"__"+chosenTissue).show();
            }

        };

        var firstResponders = {
        };


        var buildAnnotationMatrix  = function(  allUniqueElementNames,
                                                allUniqueTissueNames,
                                                dataMatrix ){
            var correlationMatrix = dataMatrix;
            var xlabels = allUniqueElementNames;
            var ylabels = allUniqueTissueNames;
            var margin = {top: 50, right: 50, bottom: 190, left: 250},
                width = 440 - margin.left - margin.right,
                height = 890 - margin.top - margin.bottom;
            var matrix = baget.matrix()
                .height(height)
                .width(width)
                .margin(margin)
                .renderLegend(0)
                .renderCellText(0)
                .xlabelsData(xlabels)
                .ylabelsData(ylabels)
                .xAxisLabel('chromatin state')
                .yAxisLabel('well shit, howdy!')
                .startColor('#ffffff')
                .endColor('#3498db')
                .dataHanger("#chart1", correlationMatrix);
            d3.select("#chart1").call(matrix.render);
        };
        var buildMultiTrackDisplay  = function(     allUniqueElementNames,
                                                    allUniqueTissueNames,
                                                    dataMatrix,
                                                    additionalParams ){
            var correlationMatrix = dataMatrix;
            var xlabels = additionalParams.stateColorBy;
            var ylabels = allUniqueTissueNames;
            var margin = {top: 50, right: 50, bottom: 100, left: 250},
                width = 750 - margin.left - margin.right,
                height = 800 - margin.top - margin.bottom;
            var multiTrack = baget.multiTrack()
                .height(height)
                .width(width)
                .margin(margin)
                .renderCellText(0)
                .xlabelsData(xlabels)
                .ylabelsData(ylabels)
                .startColor('#ffffff')
                .endColor('#3498db')
                .endRegion(additionalParams.regionEnd)
                .startRegion(additionalParams.regionStart)
                .xAxisLabel('genomic position')
                .mappingInfo(additionalParams.mappingInformation)
                .dataHanger("#chart2", correlationMatrix);
            d3.select("#chart2").call(multiTrack.render);
        }

        var buildAnnotationTable = function(selectionToFill,
                                        variantInfoUrl,
                                        renderData, parameters){
            tableInitialization();
            var rowsToDisplay = renderData.indivRecords;
            var requestedProperties = _.map(renderData.propertiesToInclude, function(o){
                var propertyNamePieces = o.substring("common-common-".length);
                if (propertyNamePieces.length > 0){
                    return propertyNamePieces;
                } else {
                    return "prop";
                }
            });
            var counter = 0;
            var commonTable  = $(selectionToFill).dataTable({
                    "bDestroy": true,
                    "className": "compact",
                    "bAutoWidth" : false,
                    "order": [[ 1, "asc" ]],
                    "columnDefs":                   [
                        { "name": "Element",   "targets": [0],  "title":"Chromatin state"
                            , "sWidth": "30%", "class":"elementHdr"
                        },
                        { "name": "Tissue",   "targets": [1], "title":"Tissue"
                           ,"sWidth": "30%", "class":"tissueHdr"
                        },
                        { "name": "startpos",   "targets": [2], "title":"Start position"
                          , "sWidth": "20%"
                        },
                        { "name": "endpos",   "targets": [3], "title":"End position"
                           ,"sWidth": "20%"
                        }
                    ],
                    "scrollY":        "300px",
                    "scrollX": "100%",
                    "scrollCollapse": true,
                    "paging":         false,
                    "bFilter": true,
                    "bLengthChange" : true,
                    "bInfo":false,
                    "bProcessing": true,
                    // "fnRowCallback": function( nRow, aData, iDisplayIndex ) {
                    //     nRow.className = $(aData[0]).attr('custag');
                    //     return nRow;
                    // },
                dom: 'lBtip',
                    buttons: [
                        { extend: "copy", text: "Copy" },
                        { extend: 'csv', filename: "commonVariants" },
                        { extend: 'pdf', orientation: 'landscape'}
                    ]
                }
            );

            var distinctElements =  _.chain(rowsToDisplay).uniqBy('element').map('element').value();
            var distinctTissues =  _.chain(rowsToDisplay).uniqBy('source').map('source').value();
            _.forEach(rowsToDisplay,function(variantRec){
               var arrayOfRows = [];

                arrayOfRows.push('<span class="elementSpec">'+variantRec.element+'</span>');
              //  arrayOfRows.push(variantRec.element);
               arrayOfRows.push(variantRec.source);
               arrayOfRows.push(variantRec.START);
               arrayOfRows.push(variantRec.STOP);

               commonTable.dataTable().fnAddData( arrayOfRows );
            });

            // $('#commonVariantsLocationHolder_filter').css('display','none');
            $('div.dataTables_scrollHeadInner table.dataTable thead tr').addClass('niceHeaders');
            $('tr.niceHeaders th.elementHdr').append('<select class="hdrFilter elementFilter" type="button" data-toggle="dropdown" aria-haspopup="true" '+
                'aria-expanded="false"></select>');
            $('tr.niceHeaders th.tissueHdr').append('<select class="hdrFilter tissueFilter" type="button" data-toggle="dropdown" aria-haspopup="true" '+
                'aria-expanded="false"></select>');
            $('select.elementFilter').on("click", UTILS.disableClickPropagation);
            $('select.tissueFilter').on("click", UTILS.disableClickPropagation);
            $('select.elementFilter').append("<option value='ALL'>All</option>");
            $('select.tissueFilter').append("<option value='ALL'>All</option>");
            _.forEach(distinctElements.sort(),function (o){
                $('select.elementFilter').append("<option value='"+o+"'>"+o+"</option>");
            });
            _.forEach(distinctTissues.sort(),function (o){
                $('select.tissueFilter').append("<option value='"+o+"'>"+o+"</option>");
            });
            $('select.elementFilter').val('ALL');
            $('select.tissueFilter').val('ALL');
            $('select.elementFilter').change(function(h){
                // $('div.elementFilter').attr('elementFilter',$(this).val());
                commonTable.DataTable().columns(1).search('').draw();
            });
            $('select.tissueFilter').change(function(h){
                commonTable.DataTable().columns(1).search('').draw();
            });

            //commonTable.dataTable().fnDraw();

        };


        return {
            // private routines MADE PUBLIC FOR UNIT TESTING ONLY (find a way to do this in test mode only)

            // public routines
            retrieveCalculateDiseaseBurden: retrieveCalculateDiseaseBurden,
            retrieveCarrierStatusDiseaseRisk: retrieveCarrierStatusDiseaseRisk,
            retrieveVariantAssociationStatistics: retrieveVariantAssociationStatistics,
            retrieveDelayedHowCommonIsPresentation: retrieveDelayedHowCommonIsPresentation,
            retrieveDelayedCarrierStatusDiseaseRiskPresentation: retrieveDelayedCarrierStatusDiseaseRiskPresentation,
            retrieveDelayedBurdenTestPresentation: retrieveDelayedBurdenTestPresentation,
            retrieveHowCommonIsThisVariantAcrossEthnicities: retrieveHowCommonIsThisVariantAcrossEthnicities,
            retrieveDelayedIgvLaunch: retrieveDelayedIgvLaunch,
            retrieveVariantPosition: retrieveVariantPosition,
            // ---------------------------------------
            firstReponders: firstResponders,
            retrieveVariantPhenotypeData: retrieveVariantPhenotypeData,
            initializePage: initializePage,
            retrieveFunctionalData:retrieveFunctionalData,
            displayFunctionalData:displayFunctionalData,
            displayChosenElements:displayChosenElements,
            buildAnnotationTable:buildAnnotationTable
        }


    }());


})();

