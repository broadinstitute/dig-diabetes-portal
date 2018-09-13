var mpgSoftware = mpgSoftware || {};




    mpgSoftware.associationStatistics = (function () {

        var associationStatisticsVariables = {
            tableNotLoaded: true,
            maximumDataSetsPerCall: 40,
            sortingColumn: 0
            //var dbSnpId;
        };

        var setAssociationStatisticsVariables = function(incomingAssociationStatisticsVariabless){
            associationStatisticsVariables = incomingAssociationStatisticsVariabless;
            associationStatisticsVariables["tableNotLoaded"] = true;
            associationStatisticsVariables["maximumDataSetsPerCall"] = 40;
            associationStatisticsVariables["sortingColumn"] = 0;
        };

        var getAssociationStatisticsVariables = function(){
            return associationStatisticsVariables;
        };

        var initializePage = function(config){
            console.log("in mpgSoftware.associationStatistics.initializePage.");
            $(".collapse").on('show.bs.collapse', function (a, b) {
                console.log('The collapsible content is about to show.');
            });
            $("#collapseVariantTraitAssociation").on("show.bs.collapse", function () {
                console.log("a mpgSoftware.associationStatistics.initializePage.");
                if (getAssociationStatisticsVariables().tableNotLoaded) {
                    loadAssociationTable();
                    getAssociationStatisticsVariables().tableNotLoaded = false;
                }
            });
            $("#collapseVariantAssociationStatistics").on("shown.bs.collapse", function () {
                console.log("b mpgSoftware.associationStatistics.initializePage.");
                if (typeof config !== 'undefined'){
                    if (config.exposePhewasModule){
                        mpgSoftware.locusZoom.rescaleSVG('#plot');
                    }
                    if (config.exposeForestPlot){
                        mpgSoftware.locusZoom.rescaleSVG('#forestPlot');
                    }
                }

            });
            $('#traitsPerVariantTable').on('order.dt', UTILS.labelIndenter('traitsPerVariantTable'));
            console.log("out mpgSoftware.associationStatistics.initializePage.");
        };


        var allowExpansionByCohort = function () {
            getAssociationStatisticsVariables().sortingColumn = 0;
            $('.jstree-ocl').show();
            $('div.glyphicon').hide();
        };
        var allowExpansionByTrait = function () {
            getAssociationStatisticsVariables().sortingColumn = 1;
            $('.jstree-ocl').show();
            $('div.glyphicon').hideshow();
        };
        var respondToPlusSignClick = function (drivingDom) {
            var jqueryElement = $(drivingDom);
            if (jqueryElement.find("span").hasClass('glyphicon-resize-full')) {
                jqueryElement.find("span").removeClass('glyphicon-resize-full');
                jqueryElement.find("span").addClass('glyphicon-resize-small');
                jqueryElement.attr('title', "Click to remove additional associations for GIANT GWAS across other data sets");
            } else if (jqueryElement.find("span").hasClass('glyphicon-resize-small')) {
                jqueryElement.find("span").addClass('glyphicon-resize-full');
                jqueryElement.find("span").removeClass('glyphicon-resize-small');
                jqueryElement.attr('title', "Click to open additional associations for GIANT GWAS across other data sets");
            }
        };


        var loadAssociationTable = function () {
            var variant;
            var loading = $('#spinner').show();
            var deferreds = [];
            $.ajax({
                cache: false,
                type: "get",
                url: getAssociationStatisticsVariables().ajaxAssociatedStatisticsTraitPerVariantUrl,
                data: {
                    variantIdentifier: getAssociationStatisticsVariables().variantIdentifier,
                    technology: ''
                },
                async: true,
                success: function (data) {
                    mpgSoftware.trait.fillTheTraitsPerVariantFields(data,
                        [],
                        '#traitsPerVariantTableBody',
                        '#traitsPerVariantTable',
                        getAssociationStatisticsVariables().traitSearchUrl,
                        getAssociationStatisticsVariables().locale,
                        getAssociationStatisticsVariables().copyText,
                        getAssociationStatisticsVariables().printText);
                    var sgLinks = $('.sgIdentifierInTraitTable');

                    var defCount = [];
                    for (var i = 0; i < sgLinks.length; i++) {
                        var jqueryObj = $(sgLinks[i]);
                        // TODO: remove this work around
                        // prog note: there must be a way to to this with proper promises.  I'm not sure that
                        //  my hack below is any worse, but I'd rather use the standard technique.
                        var fwd = function (i, ewdArray) {
                            ewdArray.push('done' + i);
                            if (ewdArray.length >= sgLinks.length) {
                                // $('#reviser').click(); // click button to refresh all rows
                            }

                        };
                        deferreds.push(UTILS.jsTreeDataRetrieverPhenoSpec('#' + jqueryObj.attr('id'), '#traitsPerVariantTable',
                            jqueryObj.attr('phenotypename'),
                            jqueryObj.attr('datasetname'),
                            getAssociationStatisticsVariables().retrieveJSTreeAjaxUrl, fwd, i, defCount));
                    }

                    $.when.apply($, deferreds).then(function () {
                        mpgSoftware.traitSample.massageTraitsTable();
                    });
                    getAssociationStatisticsVariables().tableNotLoaded = false;
                    // mpgSoftware.traitSample.massageTraitsTable();
                    loading.hide();
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });

        };


        // private function
        var traitTable = function (variantIdentifier, datasetmaps, arrayOfOpenPhenotypes) {

            var addMoreValues = function (data, howManyGroups) {
                if (howManyGroups == 0) {
                    mpgSoftware.trait.fillTheTraitsPerVariantFields(data,
                        data.traitInfo.results[0].openPhenotypes,
                        '#traitsPerVariantTableBody',
                        '#traitsPerVariantTable',
                        getAssociationStatisticsVariables().traitSearchUrl,
                        getAssociationStatisticsVariables().locale,
                        getAssociationStatisticsVariables().copyText,
                        getAssociationStatisticsVariables().printText);
                } else {
                    mpgSoftware.trait.addMoreTraitsPerVariantFields(data,
                        data.traitInfo.results[0].openPhenotypes,
                        '#traitsPerVariantTableBody',
                        '#traitsPerVariantTable',
                        getAssociationStatisticsVariables().traitSearchUrl,
                        getAssociationStatisticsVariables().locale,
                        getAssociationStatisticsVariables().copyText,
                        getAssociationStatisticsVariables().printText,
                        howManyGroups * getAssociationStatisticsVariables().maximumDataSetsPerCall);
                }
                var sgLinks = $('.sgIdentifierInTraitTable');

                for (var i = 0; i < sgLinks.length; i++) {
                    var jqueryObj = $(sgLinks[i]);
                    UTILS.jsTreeDataRetrieverPhenoSpec('#' + jqueryObj.attr('id'), '#traitsPerVariantTable',
                        jqueryObj.attr('phenotypename'),
                        jqueryObj.attr('datasetname'),
                        getAssociationStatisticsVariables().retrieveJSTreeAjaxUrl);
                }
            };


            var loading = $('#spinner').show();
            var jsonString = "";
            // workaround necessary because we can't have too many joins in a single request.  The goal is to
            //  fix this problem on the backend, but between now and then here is a trick we can use
            var numberOfTopLevelLoops = Math.floor(datasetmaps.length / getAssociationStatisticsVariables().maximumDataSetsPerCall);
            var arrayOfDataCollectionCalls = [];
            for (var dataSetGroupCount = 0; dataSetGroupCount < numberOfTopLevelLoops + 1; dataSetGroupCount++) {
                var dataSetCount = 0;
                var rowMap = [];
                var rowValues = [];
                while ((dataSetCount < getAssociationStatisticsVariables().maximumDataSetsPerCall) &&
                (((getAssociationStatisticsVariables().maximumDataSetsPerCall * dataSetGroupCount) + dataSetCount) < datasetmaps.length)) {
                    rowMap.push(datasetmaps[(getAssociationStatisticsVariables().maximumDataSetsPerCall * dataSetGroupCount) + dataSetCount]);
                    dataSetCount++;
                }
                if ((typeof rowMap !== 'undefined') &&
                    (rowMap)) {
                    rowMap.map(function (d) {
                        rowValues.push("{\"ds\":\"" + d.name + "\",\"prop\":\"" + d.pvalue + "\",\"phenotype\":\"" + d.phenotype + "\"}");
                    });
                    // var suppArrayOfOpenPhenotypes = arrayOfOpenPhenotypes.map(function (d) {return ('"'+d+'"')});
                    jsonString = "{\"vals\":[\n" + rowValues.join(",\n") + "\n],\n" +
                        "\"phenos\":[\n" + arrayOfOpenPhenotypes.join(",\n") + "\n]}";

                }
                arrayOfDataCollectionCalls .push(
                    $.ajax({
                        cache: false,
                        type: "get",
                        url: getAssociationStatisticsVariables().ajaxAssociatedStatisticsTraitPerVariantUrl,
                        data: {
                            variantIdentifier: variantIdentifier,
                            technology: '',
                            chosendataData: jsonString
                        },
                        // datasetmaps:datasetmaps },
                        async: false,
                        success: function (data) {
                            var firstTime = (dataSetGroupCount == 0);
                            if (firstTime) {
                                if ($.fn.DataTable.isDataTable('#traitsPerVariantTable')) {
                                    $('#traitsPerVariantTable').dataTable({"retrieve": true}).fnDestroy();
                                }

                                $('#traitsPerVariantTable').empty();
                                $('#traitsPerVariantTable').append('<thead>' +
                                    '<tr>' +
                                    '<th>'+getAssociationStatisticsVariables().dataSet+'</th>' +
                                    '<th>'+getAssociationStatisticsVariables().trait+'</th>' +
                                    '<th>'+getAssociationStatisticsVariables().pValue+'</th>' +
                                    '<th>'+getAssociationStatisticsVariables().direction+'</th>' +
                                    '<th>'+getAssociationStatisticsVariables().oddsRatio+'</th>' +
                                    '<th>'+getAssociationStatisticsVariables().maf+'</th>' +
                                    '<th>'+getAssociationStatisticsVariables().effect+'</th>' +
                                    '</tr>' +
                                    '</thead>');
                                $('#traitsPerVariantTable').append('<tbody id="traitsPerVariantTableBody">' +
                                    '</tbody>');

                            }
                            addMoreValues(data, dataSetGroupCount);
                            loading.hide();

                            mpgSoftware.traitSample.massageTraitsTable();
                        },
                        error: function (jqXHR, exception) {
                            loading.hide();
                            core.errorReporter(jqXHR, exception);
                        }
                    })
                );

            }
            // get the indenting for now...
            console.log("array of calls to about to begin execution");
            $.when.apply($, arrayOfDataCollectionCalls).then(function() {
                console.log("array of calls to finish association tableis complete");
            });
            UTILS.labelIndenter('traitsPerVariantTable');
        };


        function reviseTraitsTableRows() {
            // get the boxes for which the cohorts have been requested
            var clickedBoxes = $('#traitsPerVariantTable .jstree-clicked');

            var dataSetNames = [];
            var dataSetMaps = [];
            for (var i = 0; i < clickedBoxes.length; i++) {
                var comboName = $(clickedBoxes[i]).attr('id');
                var partsOfCombo = comboName.replace("--", "-").split("-");
                var dataSetWithoutAnchor = partsOfCombo[0];
                dataSetNames.push(dataSetWithoutAnchor);
                var dataSetMap = {
                    "name": dataSetWithoutAnchor,
                    "value": dataSetWithoutAnchor,
                    "pvalue": partsOfCombo[1],
                    "phenotype": partsOfCombo[3].substring(0, partsOfCombo[3].length - 7)
                };
                dataSetMaps.push(dataSetMap);
            }
            // remember which phenotypes have been opened with a +
            var openPhenotypes = $('.glyphicon-minus-sign');
            var arrayOfOpenPhenotypes = [];
            for (var i = 0; i < openPhenotypes.length; i++) {
                arrayOfOpenPhenotypes.push('"' + $(openPhenotypes[i]).closest('tr').children('.vandaRowTd').children('.vandaRowHdr').attr('phenotypename') + '"');
            }
            traitTable( getAssociationStatisticsVariables().variantIdentifier, dataSetMaps, arrayOfOpenPhenotypes );
        };

        var buildDynamicPage = function(){
            var drivingVariables = {};
            var pheWASGraphics = Mustache.render($('#phenotypePerVariantTemplate')[0].innerHTML, drivingVariables);
            $('#pheWASGraphicsGoHere').append(pheWASGraphics);
        };

    return {
        initializePage:initializePage,
        setAssociationStatisticsVariables:setAssociationStatisticsVariables,
        allowExpansionByCohort:allowExpansionByCohort,
        allowExpansionByTrait:allowExpansionByTrait,
        respondToPlusSignClick:respondToPlusSignClick,
        loadAssociationTable:loadAssociationTable,
        buildDynamicPage:buildDynamicPage
    }

}());


