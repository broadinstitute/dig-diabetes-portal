var mpgSoftware = mpgSoftware || {};




mpgSoftware.geneSignalSummaryMethods = (function () {
    var loading = $('#rSpinner');
    var commonTable;
    var minimumMafForCommonTab = 0;
    var signalSummarySectionVariables;

    var setSignalSummarySectionVariables = function(incomingSignalSummarySectionVariables){
        signalSummarySectionVariables = incomingSignalSummarySectionVariables;
    };

    var getSignalSummarySectionVariables = function(){
        return signalSummarySectionVariables;
    };

    var tableInitialization = function(){
        $.fn.DataTable.ext.search.push(
            function( settings, data, dataIndex ) {
                var filterName;
                var columnToConsider;
                if (settings.sInstance==="highImpactTemplateHolder"){
                    filterName = 'div.dsFilterHighImpact';
                } else if (settings.sInstance==="commonVariantsLocationHolder") {
                    filterName = 'div.dsFilterCommon';
                } else if (settings.sInstance==="allVariantsTemplateHolder") {
                    filterName = 'div.dsFilterAllVariants';
                }
                var filter = $(filterName).attr('dsfilter');
                if ((typeof filter === 'undefined')||
                      (filter==='ALL')||
                      (filter.length===0)){
                      return true;
                } else {
                  var dsname=$(data[0]).attr('dsname');
                  if (dsname===filter){
                      return true;
                  } else {
                      return false;
                  }
                }
            }
        );

    };



 var stolenConfigTest =   {
     editable: true,
     zoomFixed: false,
     trackSourceServers: [
         "//higlass.io/api/v1"
     ],
     exportViewUrl: "/api/v1/viewconfs",
     views: [
         {
             uid: "aa",
             initialXDomain: [
                 1848402743.1816628,
                 2477898350.3577456
             ],
             autocompleteSource: "/api/v1/suggest/?d=OHJakQICQD6gTD7skx4EWA&",
             genomePositionSearchBox: {
                 autocompleteServer: "//higlass.io/api/v1",
                 autocompleteId: "OHJakQICQD6gTD7skx4EWA",
                 chromInfoServer: "//higlass.io/api/v1",
                 chromInfoId: "hg19",
                 visible: true
             },
             chromInfoPath: "//s3.amazonaws.com/pkerp/data/hg19/chromSizes.tsv",
             tracks: {
                 top: [
                     {
                         type: "horizontal-gene-annotations",
                         height: 60,
                         tilesetUid: "OHJakQICQD6gTD7skx4EWA",
                         server: "//higlass.io/api/v1",
                         position: "top",
                         uid: "OHJakQICQD6gTD7skx4EWA",
                         name: "Gene Annotations (hg19)",
                         options: {
                             name: "Gene Annotations (hg19)",
                             labelColor: "black",
                             labelPosition: "hidden",
                             plusStrandColor: "blue",
                             minusStrandColor: "red",
                             trackBorderWidth: 0,
                             trackBorderColor: "black",
                             showMousePosition: false,
                             mousePositionColor: "#999999"
                         },
                         header: ""
                     },
                     {
                         chromInfoPath: "//s3.amazonaws.com/pkerp/data/hg19/chromSizes.tsv",
                         type: "horizontal-chromosome-labels",
                         position: "top",
                         name: "Chromosome Labels (hg19)",
                         height: 30,
                         uid: "X4e_1DKiQHmyghDa6lLMVA",
                         options: {
                             showMousePosition: false,
                             mousePositionColor: "#999999"
                         }
                     }
                 ],
                 left: [
                     {
                         type: "vertical-gene-annotations",
                         width: 60,
                         tilesetUid: "OHJakQICQD6gTD7skx4EWA",
                         server: "//higlass.io/api/v1",
                         position: "left",
                         name: "Gene Annotations (hg19)",
                         options: {
                             labelPosition: "bottomRight",
                             name: "Gene Annotations (hg19)",
                             labelColor: "black",
                             plusStrandColor: "blue",
                             minusStrandColor: "red",
                             trackBorderWidth: 0,
                             trackBorderColor: "black",
                             showMousePosition: false,
                             mousePositionColor: "#999999"
                         },
                         uid: "dqBTMH78Rn6DeSyDBoAEXw",
                         header: ""
                     },
                     {
                         chromInfoPath: "//s3.amazonaws.com/pkerp/data/hg19/chromSizes.tsv",
                         type: "vertical-chromosome-labels",
                         position: "left",
                         name: "Chromosome Labels (hg19)",
                         width: 30,
                         uid: "RHdQK4IRQ7yJeDmKWb7Pcg",
                         options: {
                             showMousePosition: false,
                             mousePositionColor: "#999999"
                         }
                     }
                 ],
                 center: [
                     {
                         uid: "c1",
                         type: "combined",
                         height: 200,
                         contents: [
                             {
                                 //server: "//higlass.io/api/v1",
                                 //tilesetUid: "CQMd6V_cRw6iCI_-Unl3PQ",
                                  server: "//34.237.63.26:8888/api/v1",
                                  tilesetUid: "pancreas-demo-3",
                                 type: "heatmap",
                                 //type: "2d-rectangle-domains",
                                 // type: "horizontal-2d-rectangle-domains",
                                 position: "center",
                                 options: {
                                     maxZoom: null,
                                     labelPosition: "bottomRight",
                                     name: "Gaulton et al., Pancreatic islet",
                                     backgroundColor: "#eeeeee",
                                     colorRange: [
                                         "white",
                                         "rgba(245,166,35,1.0)",
                                         "rgba(208,2,27,1.0)",
                                         "black"
                                     ],
                                     colorbarPosition: "topRight",
                                     trackBorderWidth: 0,
                                     trackBorderColor: "black",
                                     heatmapValueScaling: "log",
                                     showMousePosition: false,
                                     mousePositionColor: "#999999",
                                     showTooltip: false,
                                     scaleStartPercent: "0.00000",
                                     scaleEndPercent: "1.00000"
                                 },
                                 uid: "GjuZed1ySGW1IzZZqFB9BA",
                                 name: "Gaulton et al., Pancreatic islet, 5kb",
                                 transforms: [
                                     {
                                         name: "ICE",
                                         value: "weight"
                                     }
                                 ]
                             }
                         ],
                         position: "center",
                         options: { }
                     }
                 ],
                 right: [ ],
                 bottom: [ ],
                 whole: [ ],
                 gallery: [ ]
             },
             layout: {
                 w: 12,
                 h: 12,
                 x: 0,
                 y: 0,
                 i: "aa",
                 moved: false,
                 static: false
             },
             initialYDomain: [
                 1192488771.5601773,
                 1531564907.792705
             ]
         }
     ],
     zoomLocks: {
         locksByViewUid: { },
         locksDict: { }
     },
     locationLocks: {
         locksByViewUid: { },
         locksDict: { }
     },
     valueScaleLocks: {
         locksByViewUid: { },
         locksDict: { }
     }
 };



    var hiGlassExperiment = function (d){
        var hgv = hglib.createHgComponent(
        ($('#fooyoo')[0]),
            stolenConfigTest,
            { bounded: true,
              onViewConfLoaded: zoomTo }
        );

        function zoomTo() {
            var drivingVars = mpgSoftware.geneSignalSummaryMethods.getSignalSummarySectionVariables();
            var chrom=drivingVars.geneChromosome.substr(3);
            hgv.zoomTo(chrom, drivingVars.geneExtentBegin, drivingVars.geneExtentEnd,drivingVars.geneExtentBegin,drivingVars.geneExtentEnd, 1000);
          //  hgv.zoomTo("aa", 1000000,2000000,1000000,2000000, 1000);
        }




        // const baseUrl = 'http://higlass.io/api/v1/viewconfs/';
        // //const baseUrl = 'http://34.237.63.26:8888/api/v1/viewconfs/';
        // var hgv = hglib.createHgComponent(
        //     ($('#fooyoo')[0]),
        //     baseUrl + '?d=KeXl4zLsTP6IKZGpFckuNA',
        //     //baseUrl + '?d=hitile-demo',
        //     {
        //         bounded: true,
        //         onViewConfLoaded: zoomTo
        //     }
        // );
        //
        // function zoomTo() {
        //     hgv.zoomTo("aa", 1000000,2000000,1000000,2000000, 1000);
        // }
    }


    var commonTableRedraw = function (){
        commonTable.draw();
    }
    var commonTableDsFilter = function (dataset){
        if (dataset === 'ALL'){
            $('.commonVariantVRTLink').css('display','none');
        } else {
            $('.commonVariantVRTLink').css('display','block');
        }
        $('#commonVariantsLocationHolder.compact.row-border.dataTable.no-footer').DataTable().columns(1).search('').draw();
    }


    var highImpactTableDsFilter = function (dataset){
        if (dataset === 'ALL'){
            $('.highImpactVariantVRTLink').css('display','none');
        } else {
            $('.highImpactVariantVRTLink').css('display','block');
        }
        $('#highImpactTemplateHolder.compact.row-border.dataTable.no-footer').DataTable().columns(1).search('').draw();
    }

    var allVariantsTableDsFilter = function (dataset){
        if (dataset === 'ALL'){
            $('.allVariantsVRTLink').css('display','none');
        } else {
            $('.allVariantsVRTLink').css('display','block');
        }
        $('#allVariantsTemplateHolder.compact.row-border.dataTable.no-footer').DataTable().columns(1).search('').draw();
    }


    var disableClickPropagation = function(event){
        event.stopPropagation();
    };


    var startVRT = function(callbackData,callbackDataStf){
        var ds = $(_.last(_.last(callbackData.data.tablePtr.DataTable().rows( { filter : 'applied'} ).data()))).attr('class');
        var pv = $(_.last(callbackData.data.tablePtr.DataTable().rows( { filter : 'applied'} ).data())[0]).attr('pval');
        window.location.href = callbackData.data.vrtUrl+'/'+callbackData.data.gene+'?sig='+pv+'&dataset='+ds+'&phenotype='+callbackData.data.phenotype+'&ignoreMdsFilter=1';
    };

    var buildARowOfTheDatatable = function(columns,variantInfoUrl,distinctDataSets,variantRec){
        var arrayOfRows = [];
        _.each(columns,function(columnName){
            switch(columnName){
                case 'VAR_ID':
                    arrayOfRows.push('<a href="'+variantInfoUrl+'/'+variantRec.VAR_ID+'" target="_blank" class="boldItlink" dsname="'+variantRec.dsr+'" pval="'+variantRec['P_VALUE']+'" custag="'+variantRec.CAT+'">'+variantRec.VAR_ID+'</a>');
                    break;
                case 'DBSNP_ID':
                    arrayOfRows.push((variantRec.DBSNP_ID)?variantRec.DBSNP_ID:'');
                    break;
                case 'dataset':
                    arrayOfRows.push('<span class="'+variantRec.dataset+'">'+variantRec.dsr+'</span>');
                    if (_.find(distinctDataSets,function(o){return variantRec.dsr===o})===undefined){
                        distinctDataSets.push(variantRec.dsr);
                    }
                    break;
                case 'PVALUE':
                    arrayOfRows.push(variantRec['P_VALUE']);
                    break;
                case 'EFFECT':
                    arrayOfRows.push(variantRec['BETA']);
                    break;
                case 'AF':
                    arrayOfRows.push(UTILS.realNumberFormatter(parseFloat(variantRec['AF']),2));
                    break;
                default:
                    if ( typeof variantRec[columnName] === 'undefined'){
                        arrayOfRows.push(" ");
                    } else {
                        arrayOfRows.push(variantRec[columnName]);
                    }

                    break;
            }
        });
        return arrayOfRows;
    }

    var buildAHeaderForTheDatatable = function (colName,target,dataSetColmnClassName){
        var obj = {};
        switch(colName){
            case 'VAR_ID':
                obj = { "name": colName, "class":"codeName_"+colName,  "targets": [target], "type":"allAnchor", "title": "Variant ID" };
                break;
            case 'dataset':
                obj = { "name": colName,  class:dataSetColmnClassName+" codeName_"+colName,  "targets": [target], "title": "Data set" };
                break;
            case 'EFFECT':
                obj = { "name": colName,  "class":"codeName_"+colName, "targets": [target], "title": "Effect" };
                break;
            case 'MOST_DEL_SCORE':
                obj = { "name": colName,  "class":"codeName_"+colName, "targets": [target], "title": "Deleteriousness<br/>category" };
                break;
            case 'DBSNP_ID':
                obj = { "name": colName, "class":"codeName_"+colName,  "targets": [target], "title": "dbSNP ID" };
                break;
            case 'Protein_change':
                obj = { "name": colName,  "class":"codeName_"+colName, "targets": [target], "title": "Protein change" };
                break;
            case 'PVALUE':
                obj = { "name": colName,  "class":"codeName_"+colName, "targets": [target], "title": "p-Value" };
                break;
            case 'GENE':
                obj = { "name": colName,  "class":"codeName_"+colName, "targets": [target], "title": "Gene" };
                break;
            case 'Consequence':
                obj = { "name": colName,  "class":"codeName_"+colName, "targets": [target], "title": "Predicted<br/>impact" };
                break;
            case 'AF':
                obj = { "name": colName,  "class":"codeName_"+colName, "targets": [target], "title": "MAF" };
                break;
            case 'Reference_allele':
                obj = { "name": colName,  "class":"codeName_"+colName, "targets": [target], "title": "Major<br/>allele" };
                break;
            case 'Effect_allele':
                obj = { "name": colName,  "class":"codeName_"+colName, "targets": [target], "title": "Minor<br/>allele" };
                break;
            default:
                obj = { "name": colName,  "class":"codeName_"+colName, "targets": [target],  "title": colName };
                break;
        }
        return obj;
    }



    var buildCommonTable = function(selectionToFill,
                                    variantInfoUrl,
                                    renderData, parameters){
        var cvar = renderData.cvar;
        var requestedProperties = _.map(renderData.propertiesToInclude, function(o){
            var propertyNamePieces = o.substring("common-common-".length);
            if (propertyNamePieces.length > 0){
                return propertyNamePieces;
            } else {
                return "prop";
            }
        });
        if (requestedProperties.length===0){
            requestedProperties.push("VAR_ID");
            requestedProperties.push("DBSNP_ID");
            requestedProperties.push("Reference_allele");
            requestedProperties.push("Effect_allele");
            requestedProperties.push("Consequence");
            requestedProperties.push("PVALUE");
            requestedProperties.push("EFFECT");
            requestedProperties.push("AF");
            requestedProperties.push("dataset");
        }
        var counter = 0;
        var columnDefsForDatatable = _.map(requestedProperties, function(o){
                return buildAHeaderForTheDatatable(o,counter++,'commonDataSet');
            }
        );
        pValueIndex = _.findIndex(requestedProperties,function (o){return o=="PVALUE"});
        if (pValueIndex === -1) {pValueIndex = 0;};
        commonTable  = $(selectionToFill).dataTable({
                "bDestroy": true,
                "className": "compact",
                "bAutoWidth" : false,
                "columnDefs":columnDefsForDatatable,
                "order": [[ pValueIndex, "asc" ]],
                "scrollY":        "300px",
                "scrollX": "100%",
                "scrollCollapse": true,
                "paging":         false,
                "bFilter": true,
                "bLengthChange" : true,
                "bInfo":false,
                "bProcessing": true,
                "fnRowCallback": function( nRow, aData, iDisplayIndex ) {
                   nRow.className = $(aData[0]).attr('custag');
                   return nRow;
                 },
                dom: 'lBtip',
                buttons: [
                    { extend: "copy", text: "Copy" },
                    { extend: 'csv', filename: "commonVariants" },
                    { extend: 'pdf', orientation: 'landscape'}
                ]
            }
        );
        var distinctDataSets = [];
        _.forEach(cvar,function(variantRec){
            commonTable.dataTable().fnAddData( buildARowOfTheDatatable(requestedProperties,variantInfoUrl,distinctDataSets,variantRec) );
        });

        $('#commonVariantsLocationHolder_filter').css('display','none');
        $('div.dataTables_scrollHeadInner table.dataTable thead tr').addClass('niceHeaders');
        $('tr.niceHeaders th.commonDataSet').append('<select class="dsFilter common" type="button" id="dropdownCommonVariantDsButton" data-toggle="dropdown" aria-haspopup="true" '+
        'aria-expanded="false">Dataset filter</select>');
        $('#dropdownCommonVariantDsButton').on("click", mpgSoftware.geneSignalSummaryMethods.disableClickPropagation);
        $('select.dsFilter.common').append("<option value='ALL'>All</option>");
        _.forEach(distinctDataSets.sort(),function (o){
            $('select.dsFilter.common').append("<option value='"+o+"'>"+o+"</option>");
        });
        $('#dropdownCommonVariantDsButton').after('<div class="boldlink commonVariantVRTLink pull-right" style="display:none">Explore</div>');
        $('.commonVariantVRTLink').on("click", null, {  gene:parameters.geneName,
                                                        phenotype:parameters.phenotype,
                                                        vrtUrl:parameters.vrtUrl,
                                                        tablePtr:commonTable,
                                                        pValueIndex:2},
            mpgSoftware.geneSignalSummaryMethods.startVRT);
        $('div.dsFilterCommon').attr('dsfilter','ALL');
        $('#dropdownCommonVariantDsButton').change(function(h){
            $('div.dsFilterCommon').attr('dsfilter',$(this).val());
            mpgSoftware.geneSignalSummaryMethods.commonTableDsFilter($(this).val());
        });

    };



    var buildHighImpactTable = function(selectionToFill,
                                    variantInfoUrl,
                                    renderData,
                                    parameters){
        var rvar = renderData.rvar;
        var requestedProperties = _.map(renderData.propertiesToInclude, function(o){
            var propertyNamePieces = o.substring("common-common-".length);
            if (propertyNamePieces.length > 0){
                return propertyNamePieces;
            } else {
                return "prop";
            }
        });
        if (requestedProperties.length===0){
            requestedProperties.push("VAR_ID");
            requestedProperties.push("DBSNP_ID");
            requestedProperties.push("Reference_allele");
            requestedProperties.push("Effect_allele");
            requestedProperties.push("Consequence");
            requestedProperties.push("Protein_change");
            requestedProperties.push("PVALUE");
            requestedProperties.push("EFFECT");
            requestedProperties.push("AF");
            requestedProperties.push("GENE");
            requestedProperties.push("dataset");
        }
        var counter = 0;
        var columnDefsForDatatable = _.map(requestedProperties, function(o){
                return buildAHeaderForTheDatatable(o,counter++,'highImpactDataSet');
            }
        );
        pValueIndex = _.findIndex(requestedProperties,function (o){return o==="PVALUE"});
        if (pValueIndex === -1) {pValueIndex = 0;};
        var highImpactTable  = $(selectionToFill).dataTable({
                "bDestroy": true,
                "className": "compact",
                "bAutoWidth" : false,
                "columnDefs": columnDefsForDatatable,
                "order": [[ pValueIndex, "asc" ]],
                "scrollY":        "300px",
                "scrollCollapse": true,
                "paging":         false,
                "bLengthChange" : true,
                "bInfo":false,
                "bProcessing": true,
                "fnRowCallback": function( nRow, aData, iDisplayIndex ) {
                    nRow.className = $(aData[0]).attr('custag');
                    return nRow;
                },
                dom: 'lBtip',
                buttons: [
                    { extend: "copy", text: "Copy" },
                    { extend: 'csv', filename: "highImpactVariants" },
                    { extend: 'pdf', orientation: 'landscape'}
                ]
            }
        );
        var distinctDataSets = [];
        _.forEach(rvar,function(variantRec){
            highImpactTable.dataTable().fnAddData( buildARowOfTheDatatable(requestedProperties,variantInfoUrl,distinctDataSets,variantRec) );
        });
        $('div.dataTables_scrollHeadInner table.dataTable thead tr').addClass('niceHeaders');
        $('#highImpactTemplateHolder_filter').css('display','none');
        $('tr.niceHeaders th.highImpactDataSet').append('<select class="dsFilter highImpact" type="button" id="dropdownHighImpactVariantMenuButton" data-toggle="dropdown" aria-haspopup="true" '+
            'aria-expanded="false">Dataset filter</button>');
        $('#dropdownHighImpactVariantMenuButton').on("click", mpgSoftware.geneSignalSummaryMethods.disableClickPropagation);
        $('select.dsFilter.highImpact').append("<option value='ALL'>All</option>");
        _.forEach(distinctDataSets.sort(),function (o){
            $('select.dsFilter.highImpact').append("<option value='"+o+"'>"+o+"</option>");
        });
        $('#dropdownHighImpactVariantMenuButton').after('<div class="boldlink highImpactVariantVRTLink pull-right" style="display:none">Explore</div>');
        $('.highImpactVariantVRTLink').on("click", null, {  gene:parameters.geneName,
                phenotype:parameters.phenotype,
                vrtUrl:parameters.vrtUrl,
                tablePtr:highImpactTable,
                pValueIndex:3},
            mpgSoftware.geneSignalSummaryMethods.startVRT);
        $('div.dsFilterHighImpact').attr('dsfilter','ALL');
        $('#dropdownHighImpactVariantMenuButton').change(function(h){
            $('div.dsFilterHighImpact').attr('dsfilter',$(this).val());
            mpgSoftware.geneSignalSummaryMethods.highImpactTableDsFilter('div.dsFilterHighImpact');
        });


    };




    var buildAllVariantsTable = function(selectionToFill,
                                    variantInfoUrl,
                                    renderData, parameters){
        var avar = renderData.avar;
        var requestedProperties = _.map(renderData.propertiesToInclude, function(o){
            var propertyNamePieces = o.substring("common-common-".length);
            if (propertyNamePieces.length > 0){
                return propertyNamePieces;
            } else {
                return "prop";
            }
        });
        if (requestedProperties.length===0){
            requestedProperties.push("VAR_ID");
     //       requestedProperties.push("DBSNP_ID");
    //        requestedProperties.push("Reference_allele");
    //        requestedProperties.push("Effect_allele");
            requestedProperties.push("Consequence");
            requestedProperties.push("PVALUE");
    //        requestedProperties.push("EFFECT");
    //        requestedProperties.push("AF");
            requestedProperties.push("dataset");
        }
        var counter = 0;
        var columnDefsForDatatable = _.map(requestedProperties, function(o){
                return buildAHeaderForTheDatatable(o,counter++,'allVariantDataSet');
            }
        );
        pValueIndex = _.findIndex(requestedProperties,function (o){return o==="PVALUE"});
        if (pValueIndex === -1) {pValueIndex = 0;};
        allVariantTable  = $(selectionToFill).dataTable({
                "bDestroy": true,
                "className": "compact",
                "bAutoWidth" : false,
                "columnDefs":columnDefsForDatatable,
                "order": [[ pValueIndex, "asc" ]],
                "scrollY":        "300px",
                "scrollX": "100%",
                "scrollCollapse": true,
                "paging":         false,
                "bFilter": true,
                "bLengthChange" : true,
                "bInfo":false,
                "bProcessing": true,
                "fnRowCallback": function( nRow, aData, iDisplayIndex ) {
                    nRow.className = $(aData[0]).attr('custag');
                    return nRow;
                },
                dom: 'lBtip',
                buttons: [
                    { extend: "copy", text: "Copy" },
                    { extend: 'csv', filename: "allVariant" },
                    { extend: 'pdf', orientation: 'landscape'}
                ]
            }
        );
        var distinctDataSets = [];
        _.forEach(avar,function(variantRec){
            allVariantTable.dataTable().fnAddData( buildARowOfTheDatatable(requestedProperties,variantInfoUrl,distinctDataSets,variantRec) );
        });

        $('#allVariantsLocationHolder_filter').css('display','none');
        $('div.dataTables_scrollHeadInner table.dataTable thead tr').addClass('niceHeaders');
        $('tr.niceHeaders th.allVariantDataSet').append('<select class="dsFilter allVariant" type="button" id="dropdownAllVariantsDsButton" data-toggle="dropdown" aria-haspopup="true" '+
            'aria-expanded="false">Dataset filter</select>');
        $('#dropdownAllVariantstDsButton').on("click", mpgSoftware.geneSignalSummaryMethods.disableClickPropagation);
        $('select.dsFilter.allVariant').append("<option value='ALL'>All</option>");
        _.forEach(distinctDataSets.sort(),function (o){
            $('select.dsFilter.allVariant').append("<option value='"+o+"'>"+o+"</option>");
        });
        $('#dropdownAllVariantsDsButton').after('<div class="boldlink allVariantsVRTLink pull-right" style="display:none">Explore</div>');
        $('.allVariantsVRTLink').on("click", null, {  gene:parameters.geneName,
                phenotype:parameters.phenotype,
                vrtUrl:parameters.vrtUrl,
                tablePtr:allVariantTable,
                pValueIndex:2},
            mpgSoftware.geneSignalSummaryMethods.startVRT);
        $('div.dsFilterAllVariants').attr('dsfilter','ALL');
        $('#dropdownAllVariantsDsButton').change(function(h){
            $('div.dsFilterAllVariants').attr('dsfilter',$(this).val());
            mpgSoftware.geneSignalSummaryMethods.allVariantsTableDsFilter('div.dsFilterAllVariants');
        });

    };





    var phenotypeNameForSampleData  = function (untranslatedPhenotype,portalTypeString) {
        var convertedName = '';
        //  We may have different phenotypes string translations depending on which sort of portal we are operating within
        if (portalTypeString === 'mi'){
            if (untranslatedPhenotype === 'MI') {
                convertedName = 'eomi';
            }
        } else {
            if (untranslatedPhenotype === 'T2D') {
                convertedName = 't2d';
            } else if (untranslatedPhenotype === 'FG') {
                convertedName = 'FAST_GLU_ANAL';
            } else if (untranslatedPhenotype === 'FI') {
                convertedName = 'FAST_INS_ANAL';
            } else if (untranslatedPhenotype === 'BMI') {
                convertedName = 'BMI';
            } else if (untranslatedPhenotype === 'CHOL') {
                convertedName = 'CHOL_ANAL';
            } else if (untranslatedPhenotype === 'TG') {
                convertedName = 'TG_ANAL';
            } else if (untranslatedPhenotype === 'HDL') {
                convertedName = 'HDL_ANAL';
            } else if (untranslatedPhenotype === 'LDL') {
                convertedName = 'LDL_ANAL';
            } else if (untranslatedPhenotype === 'SBP') {
                convertedName = 'SBP_ANAL';
            } else if (untranslatedPhenotype === 'DBP') {
                convertedName = 'DBP_ANAL';
            }
        }
        return convertedName;
    };
    var phenotypeNameForHailData  = function (untranslatedPhenotype) {
        var convertedName;
        if (untranslatedPhenotype === 'T2D') {
            convertedName = {key: "T2D", description: "Type 2 Diabetes"};
        } else if (untranslatedPhenotype === 'BMI') {
            convertedName = {key: "BMI_adj_withincohort_invn", name: "BMI", description: "Body Mass Index"};
        } else if (untranslatedPhenotype === 'LDL') {
            convertedName = {key: "LDL_lipidmeds_divide.7_adjT2D_invn", name: "LDL", description: "LDL Cholesterol"};
        } else if (untranslatedPhenotype === 'HDL') {
            convertedName = {key: "HDL_adjT2D_invn", name: "HDL", description: "HDL Cholesterol"};
        } else if (untranslatedPhenotype === 'FI') {
            convertedName = {key: "logfastingInsulin_adj_invn", name: "FI", description: "Fasting Insulin"};
        } else if (untranslatedPhenotype === 'FG') {
            convertedName = {key: "fastingGlucose_adj_invn", name: "FG", description: "Fasting Glucose"};
        } else if (untranslatedPhenotype === 'HIPC') {
            convertedName = {key: "HIP_adjT2D_invn", name: "HIP", description: "Hip Circumference"};
        } else if (untranslatedPhenotype === 'WAIST') {
            convertedName = {key: "WC_adjT2D_invn", name: "WC", description: "Waist Circumference"};
        } else if (untranslatedPhenotype === 'WHR') {
            convertedName = {key: "WHR_adjT2D_invn", name: "WHR", description: "Waist Hip Ratio"};
        } else if (untranslatedPhenotype === 'SBP') {
            convertedName = {key: "TC_adjT2D_invn", name: "TC", description: "Total Cholesterol"};
        } else if (untranslatedPhenotype === 'DBP') {
            convertedName = {key: "TG_adjT2D_invn", name: "TG", description: "Triglycerides"};
        }
        return convertedName;
    };
    var processAggregatedData = function (v) {
        var obj = {};
        var procAggregatedData = function (val, key) {
              if (key === 'phenotype') {
                obj['pheno'] = (val) ? val : '';
            } else if (key === 'datasetname') {
                obj['datasetname'] = (val) ? val : '';
            }  else if ((key === 'P_FIRTH_FE_IV') ||
                (key === 'P_VALUE') ||
                (key === 'P_FE_INV') ||
                (key === 'P_FIRTH')
            ) {
                obj['property'] = key;
                obj['P_VALUE'] = UTILS.realNumberFormatter((val) ? val : 0);
                obj['P_VALUEV'] = (val) ? val : 0;
            } else if (key === 'BETA') {
                obj['BETA'] = (val)?UTILS.realNumberFormatter(val):'';
                  obj['BETAV'] = ((val) ? val : 0);
                 // obj['BETA'] = UTILS.realNumberFormatter(Math.exp((val) ? val : 0));
                 // obj['BETAV'] = Math.exp((val) ? val : 0);
            }
            else {
                obj[key] = (val) ? val : '';
            }
            return obj;
        }
        _.forEach(v, procAggregatedData);
        return obj;
    };
    var processNonAggregatedData = function (v) {
        var obj = {};
        var procAggregatedData = function (val, key) {
            if (key === 'phenotype') {
                obj['pheno'] = (val) ? val : '';
            } else if (key === 'datasetname') {
                obj['datasetname'] = (val) ? val : '';
            }  else if ((key === 'P_FIRTH_FE_IV') ||
                (key === 'P_VALUE') ||
                (key === 'P_FE_INV') ||
                (key === 'POSTERIOR_PROBABILITY') ||
                (key === 'P_FIRTH')
            ) {
                obj['property'] = key;
                var valToProcess;
                _.forEach( val, function(o){_.forEach(o,function(oo){valToProcess=oo;})});
                obj['P_VALUE'] = UTILS.realNumberFormatter((valToProcess) ? valToProcess : 1);
                obj['P_VALUEV'] = (valToProcess) ? valToProcess : 1;
            } else if (key === 'BETA') {
                obj['BETA'] = UTILS.realNumberFormatter(Math.exp((val) ? val : 1));
                obj['BETAV'] = Math.exp((val) ? val : 1);
            }
            else {
                obj[key] = (val) ? val : '';
            }
            return obj;
        }
        _.forEach(v, procAggregatedData);
        return obj;
    };
    var refineRenderData = function (renderData, significanceLevel) {
        renderData.rvar = [];
        renderData.cvar = [];
        renderData.avar = [];
        var pValueCutoffHighImpact = 0;
        var pValueCutoffCommon = 0;
        var maxNumberOfVariants = 100;
        switch (significanceLevel) {
            case 3:
                pValueCutoffHighImpact = 0.00000005;
                pValueCutoffCommon = 0.000005;
                break;
            case 2:
                pValueCutoffHighImpact = 0.0001;
                pValueCutoffCommon = 0.0001;
                break;
            case 1:
                pValueCutoffHighImpact = 1;
                pValueCutoffCommon = 1;
                break;
            default:
                break;
        }
        var rvart = [];
        var cvart = [];
        var avart = [];
        _.forEach(renderData.variants, function (v) {
            var mafValue = v['AF']
            var mdsValue = v['MOST_DEL_SCORE'];
            var pValue = v['P_VALUEV'];
            if ((typeof mdsValue !== 'undefined') && (mdsValue !== '') && (mdsValue < 3) &&
                (typeof pValue !== 'undefined') && (pValue <= pValueCutoffHighImpact)) {
                if (rvart.length < maxNumberOfVariants) {
                    if (pValue < 0.000005) {
                        v['CAT'] = 'greenline'
                    }
                    else if (pValue < 0.0005) {
                        v['CAT'] = 'yellowline'
                    }
                    else {
                        v['CAT'] = 'redline'
                    }
                    rvart.push(v);
                }
            }
            if ((typeof mafValue !== 'undefined') && (mafValue !== '') && (mafValue > minimumMafForCommonTab) &&
                (typeof pValue !== 'undefined') && (pValue <= pValueCutoffCommon)) {
                if (cvart.length < maxNumberOfVariants) {
                    if (pValue < 0.00000005) {
                        v['CAT'] = 'greenline'
                    }
                    else if (pValue < 0.0005) {
                        if (v['CAT']!='greenline'){
                            v['CAT'] = 'yellowline'
                        }
                    }
                    else {
                        if ((v['CAT']!=='greenline')&&
                            (v['CAT']!=='yellowline')) {
                            v['CAT'] = 'redline'
                        }
                    }
                    cvart.push(v);
                }
            }
            avart.push(v);
        });
        // sort by P value for the high-impact variants
        var tempRVar = _.sortBy(rvart, function (o) {
            return o.P_VALUEV
        });
        // Only the first P value with each name gets in.  Since these are sorted we get all the variants with the lowest P values
        _.forEach(tempRVar,function(o){
            if (_.findIndex(renderData.rvar,function (p){return (p['VAR_ID']==o['VAR_ID'])})<0){
                renderData.rvar.push(o);
            }
        });
        // repeat the sorting and filtering for the common variants
        var tempCVar = _.sortBy(cvart, function (o) {
            return o.P_VALUEV
        });
        _.forEach(tempCVar,function(o){
            if (_.findIndex(renderData.cvar,function (p){return (p['VAR_ID']==o['VAR_ID'])})<0){
                renderData.cvar.push(o);
            }
        });
        // sort, but don't filter for the all variants column
        renderData.avar = _.sortBy(avart, function (o) {
            return o.P_VALUEV
        });
        return renderData;
    };

    var buildRenderData = function (data, mafCutoff,additionalData) {
        var renderData = {variants: [],
            rvar: [],
            cvar: [],
            tissues: [],
            static:[],
            dynamic:[]};
        if ((typeof data !== 'undefined') &&
            (typeof data.variants !== 'undefined') &&
            (typeof data.variants.variants !== 'undefined') &&
            (data.variants.variants.length > 0)) {
            _.forEach(data.variants.variants, function (v, index, y) {
                renderData.variants.push(mpgSoftware.geneSignalSummaryMethods.processAggregatedData(v));
            });
        }
        renderData['assayIdList'] = additionalData.assayIdList;
        renderData.tissues = _.filter(data.lzOptions, function(o){return o.dataType==='tissue'});
        renderData['tissueDataExists'] = (renderData.tissues.length > 0) ? [1] : [];
        renderData.static = _.filter(data.lzOptions, function(o){return o.dataType==='static'});
        renderData['staticDataExists'] = (renderData.static.length > 0) ? [1] : [];
        renderData.dynamic = _.filter(data.lzOptions, function(o){return o.dataType==='dynamic'});
        renderData['dynamicDataExists'] = (renderData.dynamic.length > 0) ? [1] : [];

        return renderData;
    };

    var buildRenderDataFromNonAggregatedData = function (data, mafCutoff, additionalData) {
        var renderData = {variants: [],
            rvar: [],
            cvar: [],
            tissues: [],
            static:[],
            dynamic:[],
            credibleSet:[]};
        if ((typeof data !== 'undefined') &&
            (typeof data.variants !== 'undefined') ) {
            _.forEach(data.variants, function (v, index, y) {
                renderData.variants.push(processNonAggregatedData(v[0]));
            });
        }
        renderData['assayIdList'] = additionalData.assayIdList;
        renderData.tissues = _.filter(data.lzOptions, function(o){return o.dataType==='tissue'});
        renderData['tissueDataExists'] = (renderData.tissues.length > 0) ? [1] : [];
        renderData.static = _.filter(data.lzOptions, function(o){return o.dataType==='static'});
        renderData['staticDataExists'] = (renderData.static.length > 0) ? [1] : [];
        renderData.dynamic = _.filter(data.lzOptions, function(o){return o.dataType==='dynamic'});
        renderData['dynamicDataExists'] = (renderData.dynamic.length > 0) ? [1] : [];

        return renderData;
    };


    var updateAggregateVariantsDisplay = function (data, locToUpdate) {
        var updateHere = $(locToUpdate);
        updateHere.empty();
        if ((data) &&
            (data.stats)) {
            updateHere.append("<ul class='aggregateVariantsDescr list-group'>" +
                "<li class='list-group-item'>" + UTILS.realNumberFormatter(data.stats.pValue) + "</li>" +
                "<li class='list-group-item'>" + UTILS.realNumberFormatter(data.stats.beta) + "</li>" +
                "<li class='list-group-item'>" + UTILS.realNumberFormatter(data.stats.ciLower) + " : " + UTILS.realNumberFormatter(data.stats.ciUpper) + "</li>" +
                "</ul>");
            if (data.stats.pValue < 0.000001) {
                updateDisplayBasedOnStoredSignificanceLevel(3);//green light
            } else if (data.stats.pValue < 0.01) {
                updateDisplayBasedOnStoredSignificanceLevel(2);//yellow light
            }
            $("[data-toggle=popover]").popover();
        }
    };


    var commonSectionComesFirst = function (renderData) { // returns true or false
        var returnValue;
        var sortedVariants = _.sortBy(renderData.variants, function (o) {
            return o.P_VALUEV
        });
        for (var i = 0; (i < sortedVariants.length) && (typeof returnValue === 'undefined'); i++) {
            var oneVariant = sortedVariants[i];
            if ((typeof oneVariant.AF !== 'undefined') && (oneVariant.AF !== "")) {
                if (oneVariant.AF < 0.05) {
                    returnValue = false;
                } else {
                    returnValue = true;
                }
            }
            if (typeof oneVariant.MOST_DEL_SCORE !== 'undefined') {
                if ((oneVariant.MOST_DEL_SCORE < 3)&&
                    ((typeof returnValue !== 'undefined')&&(returnValue !== true))) {
                    returnValue = false;
                }
            }
        }
        return returnValue;
    }


    var buildListOfInterestingPhenotypes = function (renderData,unacceptableDatasets) {
        var listOfInterestingPhenotypes = [];
        unacceptableDatasets = [];
        _.forEach(renderData.variants, function (v) {
            var vvv=_.findIndex(unacceptableDatasets,function(o){return o===v['dataset']});
            if (vvv===-1){
                var newSignalCategory = assessOneSignalsSignificance(v);
                if (newSignalCategory > 0) {
                    var existingRecIndex = _.findIndex(listOfInterestingPhenotypes, {'phenotype': v['pheno']});
                    if (existingRecIndex > -1) {
                        var existingRec = listOfInterestingPhenotypes[existingRecIndex];
                        if (existingRec['signalStrength'] < newSignalCategory) {
                            existingRec['signalStrength'] = newSignalCategory;
                        }
                        if (existingRec['pValue'] > v['P_VALUEV']) {
                            existingRec['pValue'] = v['P_VALUEV'];
                            existingRec['ds'] = v['dataset'];
                            existingRec['pname'] = v['pname'];
                            existingRec['dsr'] = v['dsr'];
                        }
                    } else {
                        listOfInterestingPhenotypes.push({  'phenotype': v['pheno'],
                            'ds': v['dataset'],
                            'pname': v['pname'],
                            'signalStrength': newSignalCategory,
                            'pValue': v['P_VALUEV'],
                            'dsr': v['dsr']})
                    }
                }

            }
        });
        return _.orderBy(listOfInterestingPhenotypes,['signalStrength','pValue'],['desc','asc']);
    };

    function toggleOtherPhenoBtns(){
        var otherBtns = $('.nav>li.redPhenotype');
        if ((typeof otherBtns !== 'undefined')&&
            (otherBtns.length>0)){
            if ($(otherBtns[0]).css('display')==='none') {
                $(otherBtns).css('display','block');
                $('a.morePhenos').css('display','none');
                $('a.noMorePhenos').css('display','block');
            } else {
                $(otherBtns).css('display','none');
                $('a.morePhenos').css('display','block');
                $('a.noMorePhenos').css('display','none');
            }
        }
    };
    var launchUpdateSignalSummaryBasedOnPhenotype = function (phenocode,ds,phenoName,dsr) {
        $('.phenotypeStrength').removeClass('chosenPhenotype');
        $('#'+phenocode).addClass('chosenPhenotype');
        var coreVariables = getSignalSummarySectionVariables();
        coreVariables['updateLZ'] = true;
        coreVariables['phenotype'] = phenocode;
        coreVariables['pname'] = phenoName;
        coreVariables['ds'] = ds;
        coreVariables['dsr'] = dsr;
        $('#rSpinner').show();
        refreshTopVariantsDirectlyByPhenotype(phenocode,
        updateSignificantVariantDisplay,coreVariables);
    };
    var updateSignalSummaryBasedOnPhenotype = function () {
        var phenocode = $(this).attr('id');
        var ds = $(this).attr('ds');
        var dsr = $(this).attr('dsr');
        var phenoName = $(this).text();
        launchUpdateSignalSummaryBasedOnPhenotype(phenocode,ds,phenoName,dsr);
    };

    var updateSignalSummaryBasedOnPhenotype2 = function (PHENOTYPEDATA) {
        var phenocode = PHENOTYPEDATA[0];
        var ds = PHENOTYPEDATA[1];
        var dsr = PHENOTYPEDATA[2];
        var phenoName = PHENOTYPEDATA[3];

        launchUpdateSignalSummaryBasedOnPhenotype(phenocode,ds,phenoName,dsr);
    };

    var refreshSignalSummaryBasedOnPhenotype = function () {
        var phenocode = $('.phenotypeStrength.chosenPhenotype').attr('id');
        var ds = $('.phenotypeStrength.chosenPhenotype').attr('ds');
        var phenoName = $('.phenotypeStrength.chosenPhenotype').text();
        launchUpdateSignalSummaryBasedOnPhenotype(phenocode,ds,phenoName);
    };

    var displayInterestingPhenotypes = function (data,params) {
        var drivingVariables = mpgSoftware.geneSignalSummaryMethods.getSignalSummarySectionVariables();
        var renderData = buildRenderData(data, 0.05, params);
        var signalLevel = assessSignalSignificance(renderData);
        var acceptableDatasetObjs =_.filter(data.datasetToChoose,function(o){return o.suitableForDefaultDisplay==='false'});
        var acceptableDatasets = _.uniq(acceptableDatasetObjs.map(function(t){return t.dataset}));
        var unacceptableDatasets = data.sampleGroupsWithCredibleSetNames;
        updateDisplayBasedOnSignificanceLevel(signalLevel,params);
        var listOfInterestingPhenotypes = buildListOfInterestingPhenotypes(renderData,unacceptableDatasets);
        var overrideClickIndex = -1;
        var favoredPhenotype = params.favoredPhenotype;
        if (listOfInterestingPhenotypes.length > 0) {
            $('.interestingPhenotypesHolder').css('display','block');
            var phenotypeDescriptions = '<ul class="nav nav-pills">';
            _.forEach(listOfInterestingPhenotypes, function (o,curIndex) {
                if (o['signalStrength'] == 1) {
                    phenotypeDescriptions += ('<li id="'+o['phenotype']+'" ds="'+o['ds']+'" dsr="'+o['dsr']+'" class="nav-item redPhenotype phenotypeStrength">' + o['pname'] + '</li>');
                } else if (o['signalStrength'] == 2) {
                    phenotypeDescriptions += ('<li id="'+o['phenotype']+'" ds="'+o['ds']+'" dsr="'+o['dsr']+'" class="nav-item yellowPhenotype phenotypeStrength">' + o['pname'] + '</li>');
                } else if (o['signalStrength'] == 3) {
                    phenotypeDescriptions += ('<li id="'+o['phenotype']+'" ds="'+o['ds']+'" dsr="'+o['dsr']+'" class="nav-item greenPhenotype phenotypeStrength">' + o['pname'] + '</li>');
                    if ((typeof favoredPhenotype !== 'undefined')&&
                        (favoredPhenotype === o['phenotype'])) {
                        overrideClickIndex = curIndex;
                    }                }
            });
            phenotypeDescriptions += ('<li><a href="javascript:;" class="morePhenos"  onclick="mpgSoftware.geneSignalSummaryMethods.toggleOtherPhenoBtns()">Additional phenotypes...</a></li>');
            phenotypeDescriptions += ('<li><a href="javascript:;" class="noMorePhenos" style="display:none" onclick="mpgSoftware.geneSignalSummaryMethods.toggleOtherPhenoBtns()">Collapse phenotypes without signals</a></li>');
            phenotypeDescriptions += '</ul>';
            $('#interestingPhenotypes').append(phenotypeDescriptions);

            /* v2f only: adding phenotypes pulldown menu to gene page header */

            var phenotypesList = [];

            $.each(listOfInterestingPhenotypes, function (phenotypeIndex, phenotype) {
                //console.log(phenotype);
                var tempObject = {};
                tempObject["name"] = phenotype.pname;
                tempObject["data"] = phenotype.phenotype+'::'+phenotype.ds+'::'+phenotype.dsr+'::'+phenotype.pname;
                tempObject["signal"] = phenotype.signalStrength;
                phenotypesList.push(tempObject);
            });

            phenotypesList = sortJSON(phenotypesList,'name','asc');

            //console.log(phenotypesList);

            var phenotypePullDown = '';

            $.each(phenotypesList, function (phenotypeIndex, phenotype) {
                //console.log(phenotype);
                phenotypePullDown += '<option data="'+phenotype.data+'" class="strength-'+phenotype.signal+'">'+phenotype.name+'</option>';
            });

            $("#phenotypeInput").html("").append(phenotypePullDown).selectpicker('refresh');

            $('#phenotypeInput.selectpicker').on('change', function(){
                var selected = $('.selectpicker option:selected').attr("data").split("::");
                //console.log(selected);
                updateSignalSummaryBasedOnPhenotype2(selected);



                showHideElement('#phenotypeSearchHolder');
            });

        }

        $('.phenotypeStrength').on("click",updateSignalSummaryBasedOnPhenotype);
        if (overrideClickIndex !== -1){
            $($('.phenotypeStrength')[overrideClickIndex]).addClass('chosenPhenotype');
        } else {
            $('.phenotypeStrength').first().addClass('chosenPhenotype');
        }

    };

    var sortJSON = function (data, key, way) {
        return data.sort(function(a, b) {

            var x = a[key].toLowerCase(); var y = b[key].toLowerCase();

            if (way === 'asc' ) { return ((x < y) ? -1 : ((x > y) ? 1 : 0)); }
            if (way === 'desc') { return ((x > y) ? -1 : ((x < y) ? 1 : 0)); }
        });
    }



    var getSingleBestPhenotypeAndLaunchInterface = function (data,params) {
        if ((typeof data !== 'undefined') &&
            (typeof data.variants !== 'undefined') &&
            (!data.variants.is_error ) &&
            (typeof data.variants.variants !== 'undefined')){
            if (data.variants.variants.length > 0) { // we have at least one variant to compare for the default phenotype
                var renderData = buildRenderData(data, 0.05, params);
                if ((renderData)&&
                    (renderData.variants.length>0)&&
                    (assessOneSignalsSignificance(renderData.variants[0])===3)){
                    var variant = data.variants.variants[0];
                    var phenocode = variant.phenotype;
                    //var ds = variant.dataset;
                    var ds = undefined;// signal that we need to look this up later when we get the full results
                    var dsr = variant.dsr;
                    var phenoName = variant.pname;
                    var favoredPhenotype = params.favoredPhenotype;
                    launchUpdateSignalSummaryBasedOnPhenotype(phenocode, ds, phenoName, dsr); // the default phenotype is sufficiently interesting to be our initial pick
                } else {
                    // the default phenotype is not sufficiently interesting -- let's take another card from the deck
                    mpgSoftware.geneSignalSummaryMethods.refreshTopVariants(mpgSoftware.geneSignalSummaryMethods.getSingleBestNonFavoredPhenotypeAndLaunchInterface,
                        {favoredPhenotype:params.favoredPhenotype,limit:1,useMinimalCall: true});
                }
            } else {
                // there were no variants for the default phenotype at all in this gene. Let's look across all phenotypes
                mpgSoftware.geneSignalSummaryMethods.refreshTopVariants(mpgSoftware.geneSignalSummaryMethods.getSingleBestNonFavoredPhenotypeAndLaunchInterface,
                    {favoredPhenotype:params.favoredPhenotype,limit:1,useMinimalCall: true});
            }
        }
     };
    var getSingleBestNonFavoredPhenotypeAndLaunchInterface = function (data,params) {
        if ((typeof data !== 'undefined') &&
            (typeof data.variants !== 'undefined') &&
            (!data.variants.is_error ) &&
            (typeof data.variants.variants !== 'undefined') &&
            (data.variants.variants.length > 0)) {
            var variant = data.variants.variants[0];
            var phenocode = variant.phenotype;
            var ds = variant.dataset;
            var dsr = variant.dsr;
            var phenoName = variant.pname;
            var favoredPhenotype = params.favoredPhenotype;
            launchUpdateSignalSummaryBasedOnPhenotype(phenocode, ds, phenoName, dsr);
        }
    }

    var assessOneSignalsSignificance = function (v,signalCategory) {
        var signalCategory = 1;
        var mdsValue = parseInt(v['MOST_DEL_SCORE']);
        var pValue = parseFloat(v['P_VALUEV']);
        if (((pValue < 0.00000005)) ||
            ( (pValue < 0.000005) &&
                (mdsValue < 3) )) {
            signalCategory = 3;
        } else if (pValue < 0.0005) {
            signalCategory = 2;
        }
        return signalCategory;
    };
    var assessSignalSignificance = function (renderData){
        var signalCategory = 1; // 1 == red (no signal), 3 == green (signal)
        _.forEach(renderData.variants,function(v){
            var newSignalCategory = assessOneSignalsSignificance(v);
            if (newSignalCategory>signalCategory){
                signalCategory = newSignalCategory;
            }
        });
        return signalCategory;
    };
    var updateDisplayBasedOnSignificanceLevel = function (significanceLevel,params) {


        var significanceLevelDoms = $('.trafficExplanations');

        significanceLevelDoms.removeClass('emphasize');
        significanceLevelDoms.addClass('unemphasize');


        //$('#trafficLightHolder').empty();
        var significanceLevelDom = $('.trafficExplanation'+significanceLevel);
        significanceLevelDom.removeClass('unemphasize');
        significanceLevelDom.addClass('emphasize');
        /*if (significanceLevel == 1){
            $('#trafficLightHolder').append(params.redLightImage);
        } else if (significanceLevel == 2){
            $('#trafficLightHolder').append(params.yellowLightImage);
        } else if (significanceLevel == 3){
            $('#trafficLightHolder').append(params.greenLightImage);
        }*/

        if (significanceLevel == 1){
            //$('#trafficLightHolder').append("<div class='red-signal'>&nbsp;</div>");
        } else if (significanceLevel == 2){
            //$('#trafficLightHolder').append("<div class='yellow-signal'>&nbsp;</div>");
            $('#trafficLightHolder').find(".signal-level-2").addClass("signal-on");
        } else if (significanceLevel == 3){
            //$('#trafficLightHolder').append("<div class='green-signal'>&nbsp;</div>");
            $('#trafficLightHolder').find(".signal-level-2").addClass("signal-on");
            $('#trafficLightHolder').find(".signal-level-3").addClass("signal-on");
        }

        $('#signalLevelHolder').text(significanceLevel);
    };

    var refreshTopVariants = function ( callBack, params ) {
        loading.show();
        var rememberCallBack = callBack;
        var rememberParams = params;
        var propertiesToIncludeQuoted = [];
        var propertiesToRemoveQuoted = [];
        _.each(params.propertiesToInclude, function(o){propertiesToIncludeQuoted.push(o)});
        _.each(params.propertiesToRemove, function(o){propertiesToRemoveQuoted.push(o)});
        var signalSummarySectionVariables = getSignalSummarySectionVariables();
        rememberParams['redLightImage']= signalSummarySectionVariables.redLightImage;
        rememberParams['yellowLightImage']= signalSummarySectionVariables.yellowLightImage;
        rememberParams['greenLightImage']= signalSummarySectionVariables.greenLightImage;
        rememberParams['retrieveTopVariantsAcrossSgsUrl']= signalSummarySectionVariables.retrieveTopVariantsAcrossSgsUrl;
        var callingObj = {
            geneToSummarize:signalSummarySectionVariables.geneName,
            propertiesToInclude: propertiesToIncludeQuoted.join(","),
            propertiesToRemove: propertiesToRemoveQuoted.join(",")
        };
        if (typeof params.currentPhenotype !== 'undefined') {
            callingObj["phenotype"] = params.currentPhenotype;
        };
        if (typeof params.limit !== 'undefined') {
            callingObj["limit"] = params.limit;
        };
        callingObj ["geneChromosome"] = params.geneChromosome;
        callingObj ["geneExtentBegin"] =params.geneExtentBegin;
        callingObj ["geneExtentEnd"] = params.geneExtentEnd;
        var callingUrl = signalSummarySectionVariables.retrieveTopVariantsAcrossSgsUrl;
        if (params.useMinimalCall){
            callingUrl = signalSummarySectionVariables.retrieveTopVariantsAcrossSgsMinUrl;
        }

        $.ajax({
            cache: false,
            type: "post",
            url: callingUrl,
            data: callingObj,
            async: true,
            success: function (data) {
                rememberCallBack(data,rememberParams);
            },
            error: function (jqXHR, exception) {
                core.errorReporter(jqXHR, exception);
            }
        });

    };



    var selfContainedGeneRanking = function(){
        var drivingVariables = mpgSoftware.geneSignalSummaryMethods.getSignalSummarySectionVariables();
        var ldsrWeigth = $('input.ldsrParameter').val();
        var phenotypeWeigth = $('input.phenotypeParameter').val();
        var phenotypeRestriction = $('input.phenotypeLimitationParameter').val();
        var startPosition = $('input.startPosition').val();
        var endPosition = $('input.endPosition').val();
        var adjustedStartingPosition = (startPosition) ? startPosition : drivingVariables.geneExtentBegin;
        var adjustedEndingPosition = (endPosition) ? endPosition : drivingVariables.geneExtentEnd;
        var phenotypeCoefficientsHolder = $('input.genePrioritizationPhenotype.coefficient');
        var phenotypeCoefficientMap = [];
        _.forEach(phenotypeCoefficientsHolder,function (phenotypeCoefficientHolder){
            var phenotypeCoefficientDomObject = $(phenotypeCoefficientHolder);
            var phenotypeName = phenotypeCoefficientDomObject.attr('phenotype');
            var phenotypeCoefficient = phenotypeCoefficientDomObject.val();
            if (phenotypeName){
                phenotypeCoefficientMap.push({'phenotypeName':phenotypeName,'phenotypeCoefficient':phenotypeCoefficient});
            }
        });
        var tissueCheckboxs = [];
        var tissueCheckboxHolder = $('input.genePrioritizationTissue:checked');
        _.forEach(tissueCheckboxHolder,function (tissueCheckbox){
            tissueCheckboxs.push($(tissueCheckbox).val());
        });
      //  var defaultPhenotypeWeightingScheme = $("input[name='defaultPhenotypeWeighting']:checked").val();


        mpgSoftware.geneSignalSummaryMethods.processGeneRankingInfo(mpgSoftware.geneSignalSummaryMethods.processGeneRankingData,
            {calculateGeneRankingUrl:drivingVariables.calculateGeneRankingUrl,
                geneExtentBegin:adjustedStartingPosition,
                geneExtentEnd:adjustedEndingPosition,
                geneChromosome:(drivingVariables.geneChromosome.indexOf('chr')>=0)?drivingVariables.geneChromosome.substring(3):drivingVariables.geneChromosome,
                maximumAssociation:phenotypeWeigth,
                minimumWeight:ldsrWeigth,
                phenotype: phenotypeRestriction,
                phenotypeCoefficients:phenotypeCoefficientMap,
                tissueToInclude:tissueCheckboxs});
    }



    var processGeneRankingData = function (data,params) {
        data.geneInformation = _.map(data.geneInformation.sort(function(a,b){return b.combinedWeight-a.combinedWeight}),function(o){o.combinedWeight=UTILS.realNumberFormatter(o.combinedWeight);return o;})
        _.forEach(data.geneInformation,function(oneGene){
            oneGene.phenoRecs=oneGene.phenoRecs.sort(function(a,b){return b.phenotypeValue-a.phenotypeValue});
            _.forEach(oneGene.phenoRecs,function(onePheno){
                onePheno['phenotypeValue'] = UTILS.realNumberFormatter(onePheno.phenotypeValue);
            });
        });
        $("#rankedGeneTableGoesHere").empty().append(Mustache.render($('#rankedGeneTable')[0].innerHTML, data));
        $('button.resetPhenotypeCoefficientsBySignificant').data('significanceLevel',data.phenotypePValueMap);
        $("button.dropdown-toggle").dropdown();
        $('a.genePrioritizationPhenotype').tooltip({ overflow: 'auto' });
    };



    var processGeneRankingDataAndResetPhenoCoefficients = function (data,params) {
        processGeneRankingData(data,params);
        resetPhenotypeCoefficientsBySignificance($('button.resetPhenotypeCoefficientsBySignificant'));

    };





    var resetPhenotypeCoefficientsBySignificance = function (myThis) {
        var significanceLevel = $(myThis).data('significanceLevel');
        var coefficientValues = $('input.genePrioritizationPhenotype.coefficient');
        _.forEach(coefficientValues, function (coefficientValueInput){
            var coefficientValueDom = $(coefficientValueInput);
            var phenotypeName = coefficientValueDom.attr('phenotype');
            var snpAssociation = significanceLevel[phenotypeName];
            if ((snpAssociation)&&(typeof snpAssociation !== 'undefined') ){
                if (snpAssociation>0){
                    var negativeLog = 0-Math.log10(snpAssociation);
                    coefficientValueDom.val(""+UTILS.realNumberFormatter(negativeLog,3));
                } else {
                    coefficientValueDom.val(""+UTILS.realNumberFormatter(47,3));
                }

            }
        });
    };

    var resetPhenotypeCoefficientsByOne = function (myThis) {
        var coefficientValues = $('input.genePrioritizationPhenotype.coefficient');
        _.forEach(coefficientValues, function (coefficientValueInput){
            var coefficientValueDom = $(coefficientValueInput);
            coefficientValueDom.val(""+UTILS.realNumberFormatter(1.0,3));
        });
    };

    var resetPhenotypeCoefficientsByZero = function (myThis) {
        var coefficientValues = $('input.genePrioritizationPhenotype.coefficient');
        _.forEach(coefficientValues, function (coefficientValueInput){
            var coefficientValueDom = $(coefficientValueInput);
            coefficientValueDom.val(""+UTILS.realNumberFormatter(0.0,3));
        });
    };
    var setAllTissueChoicesChecked = function (myThis) {
        var tissueCheckboxes = $('input.genePrioritizationTissue')
        _.forEach(tissueCheckboxes, function (tissueCheckbox){
            var tissueCheckboxDom = $(tissueCheckbox);
            tissueCheckboxDom.prop('checked',true);
        });
    };
    var setAllTissueChoicesUnchecked = function (myThis) {
        var tissueCheckboxes = $('input.genePrioritizationTissue')
        _.forEach(tissueCheckboxes, function (tissueCheckbox){
            var tissueCheckboxDom = $(tissueCheckbox);
            tissueCheckboxDom.prop('checked',false);
        });
    };


    var processGeneRankingInfo = function ( callBack, params ) {


        var rememberCallBack = callBack;
        var rememberParams = params;

        var callingObj = {
            geneToSummarize:signalSummarySectionVariables.geneName
        };
        callingObj ["chromosome"] = params.geneChromosome;
        callingObj ["start"] =params.geneExtentBegin;
        callingObj ["end"] = params.geneExtentEnd;
        callingObj ["maximumAssociation"] = (params.maximumAssociation)?params.maximumAssociation:".0001";
        callingObj ["minimumWeight"] = (params.minimumWeight)?params.minimumWeight:"1";
        //callingObj ["phenotypeCoefficients"] = JSON.stringify([{phenotypeName:'T2D',phenotypeCoefficient:'1.0'},{phenotypeName:'FG',phenotypeCoefficient:'1.2'}]);
        callingObj ["phenotypeCoefficients"] = JSON.stringify(params.phenotypeCoefficients);
        callingObj ["phenotype"] = params.phenotype;
        callingObj ["tissueToInclude"] = JSON.stringify(params.tissueToInclude);
       // callingObj ["defaultPhenotypeWeightingScheme"] = params.defaultPhenotypeWeightingScheme;

        $.ajax({
            cache: false,
            type: "post",
            url: params.calculateGeneRankingUrl,
            data: callingObj,
            async: true,
            success: function (data) {
                rememberCallBack(data,rememberParams);
            },
            error: function (jqXHR, exception) {
                core.errorReporter(jqXHR, exception);
            }
        });

    };





    var updateCommonTable = function (data,additionalParameters) {
        var renderData = mpgSoftware.geneSignalSummaryMethods.buildRenderData (data,0.05, additionalParameters);
        renderData = mpgSoftware.geneSignalSummaryMethods.refineRenderData(renderData,1);
        renderData["propertiesToInclude"] = (data.propertiesToInclude==="[]")?[]:data.propertiesToInclude;
        renderData["propertiesToRemove"] = (data.propertiesToRemove==="[]")?[]:data.propertiesToRemove;
        $("#commonVariantsLocation").empty().append(Mustache.render($('#commonVariantTemplate')[0].innerHTML, renderData));
        mpgSoftware.geneSignalSummaryMethods.buildCommonTable("#commonVariantsLocationHolder",
            additionalParameters.variantInfoUrl,
            renderData, additionalParameters);
    };

    var updateHighImpactTable = function (data,additionalParameters) {
        var renderData = mpgSoftware.geneSignalSummaryMethods.buildRenderData (data,0.05, additionalParameters);
        renderData = mpgSoftware.geneSignalSummaryMethods.refineRenderData(renderData,1);
        renderData["propertiesToInclude"] = (data.propertiesToInclude==="[]")?[]:data.propertiesToInclude;
        renderData["propertiesToRemove"] = (data.propertiesToRemove==="[]")?[]:data.propertiesToRemove;
        $("#highImpactVariantsLocation").empty().append(Mustache.render( $('#highImpactTemplate')[0].innerHTML,renderData));
        mpgSoftware.geneSignalSummaryMethods.buildHighImpactTable("#highImpactTemplateHolder",
            additionalParameters.variantInfoUrl,
            renderData,additionalParameters);
    };


    var updateAllVariantsTable = function (data,additionalParameters) {
        var renderData = mpgSoftware.geneSignalSummaryMethods.buildRenderData (data,0.05, additionalParameters);
        renderData = mpgSoftware.geneSignalSummaryMethods.refineRenderData(renderData,1);
        renderData["propertiesToInclude"] = (data.propertiesToInclude==="[]")?[]:data.propertiesToInclude;
        renderData["propertiesToRemove"] = (data.propertiesToRemove==="[]")?[]:data.propertiesToRemove;
        $("#allVariantsLocation").empty().append(Mustache.render( $('#allVariantsTemplate')[0].innerHTML,renderData));
        mpgSoftware.geneSignalSummaryMethods.buildAllVariantsTable("#allVariantsTemplateHolder",
            additionalParameters.variantInfoUrl,
            renderData,additionalParameters);
    };

    var updateCredibleSetTable = function (data,additionalParameters) {
        var renderData = mpgSoftware.geneSignalSummaryMethods.buildRenderDataFromNonAggregatedData (data,0.05, additionalParameters);
        renderData = mpgSoftware.geneSignalSummaryMethods.refineRenderData(renderData,1);
        renderData["propertiesToInclude"] = (data.propertiesToInclude==="[]")?[]:data.propertiesToInclude;
        renderData["propertiesToRemove"] = (data.propertiesToRemove==="[]")?[]:data.propertiesToRemove;
        $("#allVariantsLocation").empty().append(Mustache.render( $('#allVariantsTemplate')[0].innerHTML,renderData));
        mpgSoftware.geneSignalSummaryMethods.buildAllVariantsTable("#allVariantsTemplateHolder",
            additionalParameters.variantInfoUrl,
            renderData,additionalParameters);
    };

    var updateGenePageTables = function (domSelectors) {
        var matchingSelectedInputs = $('input[data-category="properties"]:checked:not(:disabled)').get();
        var matchingUnselectedInputs = $('input[data-category="properties"]:not(:checked,:disabled)').get();
        var valuesToInclude = _.map(matchingSelectedInputs, function (input) {
            return $(input).val();
        });
        var valuesToRemove = _.map(matchingUnselectedInputs, function (input) {
            return $(input).val();
        });
        var currentPhenotype = $('.chosenPhenotype').attr('id');
        var commonVars = getSignalSummarySectionVariables();
        commonVars['propertiesToInclude'] = valuesToInclude;
        commonVars['propertiesToRemove'] = valuesToRemove;
        if (domSelectors == 'common'){
            refreshTopVariantsDirectlyByPhenotype(currentPhenotype,mpgSoftware.geneSignalSummaryMethods.updateCommonTable,commonVars);
        } else if (domSelectors == 'highImpact'){
            refreshTopVariantsDirectlyByPhenotype(currentPhenotype,mpgSoftware.geneSignalSummaryMethods.updateHighImpactTable,commonVars);
        } else if (domSelectors == 'allVariants') {
            refreshTopVariantsDirectlyByPhenotype(currentPhenotype,mpgSoftware.geneSignalSummaryMethods.updateAllVariantsTable,commonVars);
        }

    };
    var setCheckBoxes = function(tableId){
        var hdrMap = {};
        // Get the names of the columns from the table headers and store them in a map
        var hdrs = $(tableId).DataTable().columns().header();
        _.forEach(hdrs,function(o){
            var hdrDom = $(o);
            var classList = hdrDom.attr('class').split(/\s+/);
            var nameWeWant = _.find(classList,function(o){return o.startsWith('codeName_')});
            var codeName = nameWeWant.substr("codeName_".length);
            var displayName = hdrDom.html();
            if (displayName.indexOf('<')>-1){
                displayName = displayName.substr(0,displayName.indexOf('<'));
            }
            hdrMap[codeName] = displayName;
        });
        // now get the elements from the modal box
        var props = $('.dk-modal-form-input-group>div.checkbox>label>input');
        _.forEach(props,function(o){
            var fullPropertyName = $(o).attr('value');
            var propertyName = fullPropertyName.substr('common-common-'.length)
            if (hdrMap[propertyName]){
                $(o).prop('checked',true);
            } else {
                $(o).prop('checked',false);
            }
        });

    };
    var adjustProperties  = function(origDom){
        var whichTable = $(origDom).attr('tableSpec');
        var checkBoxes = $('.dk-modal-form-input-group>div.checkbox>label>input')
        if (whichTable=='common'){
            setCheckBoxes('#commonVariantsLocationHolder');
            $('.confirmPropertyChange').attr('onclick',"mpgSoftware.geneSignalSummaryMethods.updateGenePageTables('common')");
        } else if (whichTable=='highImpact'){
            setCheckBoxes('#highImpactTemplateHolder');
            $('.confirmPropertyChange').attr('onclick',"mpgSoftware.geneSignalSummaryMethods.updateGenePageTables('highImpact')");
        } else if (whichTable=='allVariants'){
            setCheckBoxes('#allVariantsTemplateHolder');
            $('.confirmPropertyChange').attr('onclick',"mpgSoftware.geneSignalSummaryMethods.updateGenePageTables('allVariants')");
        }
    };

    var updateDisplayBasedOnStoredSignificanceLevel = function (newSignificanceLevel) {
        var currentSignificanceLevel = $('#signalLevelHolder').text();
        if (newSignificanceLevel>=currentSignificanceLevel){
            return;
        }
        updateDisplayBasedOnSignificanceLevel(newSignificanceLevel,getSignalSummarySectionVariables());
    };




    var refreshVariantAggregates = function (phenotypeName, filterNum, sampleDataSet, dataSet,mafOption, mafValue, geneName, callBack,callBackParameter) {
        var rememberCallBack = callBack;
        var rememberCallBackParameter = callBackParameter;
        var coreVariables = getSignalSummarySectionVariables();
        var thisRequest = $.ajax({
            cache: false,
            type: "post",
            url: coreVariables.burdenTestAjaxUrl,
            data: {
                geneName: geneName,
                dataSet: dataSet,
                sampleDataSet: sampleDataSet,
                filterNum: filterNum,
                burdenTraitFilterSelectedOption: phenotypeName,
                mafOption: mafOption,
                mafValue: mafValue
            },
            async: true
        });
        return thisRequest.done( function (data) {
                rememberCallBack(data,rememberCallBackParameter);
        }).fail(function(jqXHR, textStatus, errorThrown) {
            core.errorReporter(jqXHR, errorThrown);
        });

    };


    var buildNewCredibleSetPresentation = function (){

        var signalSummarySectionVariables = getSignalSummarySectionVariables();
        var additionalData = signalSummarySectionVariables;
        var sampleGroupsWithCredibleSetNames = mpgSoftware.regionInfo.getSampleGroupsWithCredibleSetNames();
        if ((sampleGroupsWithCredibleSetNames)&&(sampleGroupsWithCredibleSetNames.length>0)){
            var credibleSetDataSet = sampleGroupsWithCredibleSetNames[0];
            var setToRecall = {chromosome: signalSummarySectionVariables.geneChromosome,
                start: signalSummarySectionVariables.geneExtentBegin,
                end: signalSummarySectionVariables.geneExtentEnd,
                phenotype: additionalData.phenotype,
                propertyName: 'POSTERIOR_PROBABILITY',
                dataSet: credibleSetDataSet,
                fillCredibleSetTableUrl:signalSummarySectionVariables.fillCredibleSetTableUrl,
                sampleGroupsWithCredibleSetNames:sampleGroupsWithCredibleSetNames,
                fillGeneComparisonTableUrl:signalSummarySectionVariables.fillGeneComparisonTableUrl,
                geneTable: true
            };
            additionalData.assayIdList = mpgSoftware.regionInfo.getSelectorAssayIds();
            mpgSoftware.regionInfo.fillRegionInfoTable(setToRecall,additionalData);
            var identifiedGenes = signalSummarySectionVariables.identifiedGenes;
            var drivingVariables = {};
            drivingVariables["allGenes"] = identifiedGenes.replace("[","").replace(" ","").replace("]","").split(',');
            drivingVariables["namedGeneArray"] = [];
            drivingVariables["supressTitle"] = [1];
            if ((drivingVariables["allGenes"].length>0)&&
                (drivingVariables["allGenes"][0].length>0)) {
                drivingVariables["namedGeneArray"] = _.map(drivingVariables["allGenes"], function (o) {
                    return {'name': o.trim()}
                });
            }
            $(".matchedGenesGoHere").empty().append(
                Mustache.render( $('#dataRegionTemplate')[0].innerHTML,drivingVariables)
            );

        }
        loading.hide();
    };



    var buildOutSetPresentation = function (data,additionalData,createGeneTable, propertyToRequest){
        var signalSummarySectionVariables = getSignalSummarySectionVariables();
        var sampleGroupsWithCredibleSetNames = ['data.sampleGroupsWithCredibleSetNames'];
        var dataSet = additionalData.ds;
        if ((data.sampleGroupsWithCredibleSetNames)&&(data.sampleGroupsWithCredibleSetNames.length>0)){ // use cred sets if avail
            sampleGroupsWithCredibleSetNames = data.sampleGroupsWithCredibleSetNames;
            dataSet = sampleGroupsWithCredibleSetNames[0];
                mpgSoftware.regionInfo.setSampleGroupsWithCredibleSetNames(sampleGroupsWithCredibleSetNames);
        }
            var setToRecall = {chromosome: signalSummarySectionVariables.geneChromosome,
                start: signalSummarySectionVariables.geneExtentBegin,
                end: signalSummarySectionVariables.geneExtentEnd,
                phenotype: additionalData.phenotype,
                propertyName: propertyToRequest,
                dataSet: dataSet,
                fillCredibleSetTableUrl:signalSummarySectionVariables.fillCredibleSetTableUrl,
                fillGeneComparisonTableUrl:signalSummarySectionVariables.fillGeneComparisonTableUrl,
                sampleGroupsWithCredibleSetNames:sampleGroupsWithCredibleSetNames,
                geneTable: createGeneTable
            };
            mpgSoftware.regionInfo.fillRegionInfoTable(setToRecall,additionalData);
            var identifiedGenes = signalSummarySectionVariables.identifiedGenes;
            var drivingVariables = {};
            drivingVariables["allGenes"] = identifiedGenes.replace("[","").replace(" ","").replace("]","").split(',');
            drivingVariables["namedGeneArray"] = [];
            drivingVariables["supressTitle"] = [1];
            if ((drivingVariables["allGenes"].length>0)&&
                (drivingVariables["allGenes"][0].length>0)) {
                drivingVariables["namedGeneArray"] = _.map(drivingVariables["allGenes"], function (o) {
                    return {'name': o}
                });
            }
            $(".matchedGenesGoHere").empty().append(
                Mustache.render( $('#dataRegionTemplate')[0].innerHTML,drivingVariables)
            );

        //}
    };









    var buildOutCredibleSetPresentation = function (data,additionalData){

        var signalSummarySectionVariables = getSignalSummarySectionVariables();
        if ((data.sampleGroupsWithCredibleSetNames)&&(data.sampleGroupsWithCredibleSetNames.length>0)){
            mpgSoftware.regionInfo.setSampleGroupsWithCredibleSetNames(data.sampleGroupsWithCredibleSetNames);  // save, in case we need this information later
            var credibleSetDataSet = data.sampleGroupsWithCredibleSetNames[0];
            var setToRecall = {chromosome: signalSummarySectionVariables.geneChromosome,
                start: signalSummarySectionVariables.geneExtentBegin,
                end: signalSummarySectionVariables.geneExtentEnd,
                phenotype: additionalData.phenotype,
                propertyName: 'POSTERIOR_PROBABILITY',
                dataSet: credibleSetDataSet,
                fillCredibleSetTableUrl:signalSummarySectionVariables.fillCredibleSetTableUrl,
                fillGeneComparisonTableUrl:signalSummarySectionVariables.fillGeneComparisonTableUrl,
                sampleGroupsWithCredibleSetNames:data.sampleGroupsWithCredibleSetNames,
                geneTable: true
            };
            mpgSoftware.regionInfo.fillRegionInfoTable(setToRecall,additionalData);
            var identifiedGenes = signalSummarySectionVariables.identifiedGenes;
            var drivingVariables = {};
            drivingVariables["allGenes"] = identifiedGenes.replace("[","").replace(" ","").replace("]","").split(',');
            drivingVariables["namedGeneArray"] = [];
            drivingVariables["supressTitle"] = [1];
            if ((drivingVariables["allGenes"].length>0)&&
                (drivingVariables["allGenes"][0].length>0)) {
                drivingVariables["namedGeneArray"] = _.map(drivingVariables["allGenes"], function (o) {
                    return {'name': o}
                });
            }
            $(".matchedGenesGoHere").empty().append(
                Mustache.render( $('#dataRegionTemplate')[0].innerHTML,drivingVariables)
            );

        }
        loading.hide();
    };


    var buildOutIncredibleSetPresentation = function (data,additionalData){

        var signalSummarySectionVariables = getSignalSummarySectionVariables();
        // if ((data.sampleGroupsWithCredibleSetNames)&&(data.sampleGroupsWithCredibleSetNames.length>0)){
        //     mpgSoftware.regionInfo.setSampleGroupsWithCredibleSetNames(data.sampleGroupsWithCredibleSetNames);  // save, in case we need this information later
        //     var credibleSetDataSet = data.sampleGroupsWithCredibleSetNames[0];
        var fakeCredibleSetNames = [];
        fakeCredibleSetNames.push('data.sampleGroupsWithCredibleSetNames');
            var setToRecall = {chromosome: signalSummarySectionVariables.geneChromosome,
                start: signalSummarySectionVariables.geneExtentBegin,
                end: signalSummarySectionVariables.geneExtentEnd,
                phenotype: additionalData.phenotype,
                propertyName: 'POSTERIOR_PROBABILITY',
                dataSet: '',
                fillCredibleSetTableUrl:signalSummarySectionVariables.fillCredibleSetTableUrl,
                fillGeneComparisonTableUrl:signalSummarySectionVariables.fillGeneComparisonTableUrl,
                sampleGroupsWithCredibleSetNames:fakeCredibleSetNames,
                geneTable: false
            };
            mpgSoftware.regionInfo.fillRegionInfoTable(setToRecall,additionalData);
            var identifiedGenes = signalSummarySectionVariables.identifiedGenes;
            var drivingVariables = {};
            drivingVariables["allGenes"] = identifiedGenes.replace("[","").replace(" ","").replace("]","").split(',');
            drivingVariables["namedGeneArray"] = [];
            drivingVariables["supressTitle"] = [1];
            if ((drivingVariables["allGenes"].length>0)&&
                (drivingVariables["allGenes"][0].length>0)) {
                drivingVariables["namedGeneArray"] = _.map(drivingVariables["allGenes"], function (o) {
                    return {'name': o}
                });
            }
            $(".matchedGenesGoHere").empty().append(
                Mustache.render( $('#dataRegionTemplate')[0].innerHTML,drivingVariables)
            );

       // }
        loading.hide();
    };

    var refreshTopVariantsDirectlyByPhenotype = function (phenotypeName, callBack, parameter) {
        loading.show();

        var rememberCallBack = callBack;
        var rememberParameter = parameter;
        var rememberPhenotype = phenotypeName;
        var coreVariables = getSignalSummarySectionVariables();
        var propertiesToIncludeQuoted = [];
        var propertiesToRemoveQuoted = [];
        _.each(parameter.propertiesToInclude, function(o){propertiesToIncludeQuoted.push(o)});
        _.each(parameter.propertiesToRemove, function(o){propertiesToRemoveQuoted.push(o)});
        var callingObj = {
            phenotype: phenotypeName,
            geneToSummarize:coreVariables.geneName,
            propertiesToInclude: propertiesToIncludeQuoted.join(","),
            propertiesToRemove: propertiesToRemoveQuoted.join(",")
        };
        if (typeof parameter.limit !== 'undefined') {
            callingObj["limit"] = parameter.limit;
        };
        var callingUrl = coreVariables.retrieveTopVariantsAcrossSgsUrl;
        if (parameter.useMinimalCall){
            callingUrl = coreVariables.retrieveTopVariantsAcrossSgsMinUrl;
        }

        if ($("#gene-info-summary-content").find(".pname").text() == "") {
            console.log("only called 1st time");
            if(phenotypeName != "") {
                $.ajax({
                    cache: false,
                    type: "post",
                    url: callingUrl,
                    data: callingObj,
                    async: true,
                    success: function (data) {
                        if (typeof data.experimentAssays !== 'undefined'){
                            var signalSummarySectionVariables = getSignalSummarySectionVariables();
                            signalSummarySectionVariables["experimentAssays"] = data.experimentAssays;
                        }
                        rememberCallBack(data, rememberParameter);

                    },
                    error: function (jqXHR, exception) {
                        core.errorReporter(jqXHR, exception);
                    }
                });

            } else {
                var ajaxURL = $('#main').attr("geneinfoajaxurl");

                $.ajax({
                   // url:mpgSoftware.variantTableInitializer.variantTableConfiguration(phenotypeName,ajaxURL),
                    success:function(){

                        setTimeout(function(){
                            $.ajax({
                                cache: false,
                                type: "post",
                                url: callingUrl,
                                data: callingObj,
                                async: true,
                                success: function (data) {
                                    if (typeof data.experimentAssays !== 'undefined'){
                                        var signalSummarySectionVariables = getSignalSummarySectionVariables();
                                        signalSummarySectionVariables["experimentAssays"] = data.experimentAssays;
                                    }
                                    rememberCallBack(data, rememberParameter);

                                },
                                error: function (jqXHR, exception) {
                                    core.errorReporter(jqXHR, exception);
                                }
                            });
                        },0);

                    }});
                mpgSoftware.variantTableInitializer.variantTableConfiguration({chromosome:coreVariables.geneChromosomeMinusChr(),
                    startPosition:coreVariables.geneExtentBegin,
                    endPosition:coreVariables.geneExtentEnd,
                    phenotype:rememberPhenotype,
                    includeIndependentRangeDisplay: false
                });
            }

        } else {
            console.log("called 2nd time");
            //update variant FOCUS table
            var ajaxURL = $('#main').attr("geneinfoajaxurl");

            $.ajax({
                url:mpgSoftware.variantTable.refreshVariantFocusForPhenotype(phenotypeName,ajaxURL),
                success:function(){

                    setTimeout(function(){
                        $.ajax({
                            cache: false,
                            type: "post",
                            url: callingUrl,
                            data: callingObj,
                            async: true,
                            success: function (data) {
                                if (typeof data.experimentAssays !== 'undefined'){
                                    var signalSummarySectionVariables = getSignalSummarySectionVariables();
                                    signalSummarySectionVariables["experimentAssays"] = data.experimentAssays;
                                }
                                rememberCallBack(data, rememberParameter);

                            },
                            error: function (jqXHR, exception) {
                                core.errorReporter(jqXHR, exception);
                            }
                        });
                    },5000);

                }});


        }
    };
    var initialPageSetUp = function (drivingVariables) {
        // let us also initialized the region info metadata at this point
        mpgSoftware.regionInfo.initializeRegionInfoModule (drivingVariables);
        $("#tableHeaderHolder").empty().append(
            Mustache.render($('#genePageHeaderTemplate')[0].innerHTML, drivingVariables));
        var displayCommonTab = [1];
        var displayHighImpactTab=[1];
        if (drivingVariables.regionSpecificVersion===1){
            displayHighImpactTab = [];
        }
        var pName='notused';
        var credibleSetTab = [1];
        var incredibleSetTab = [1];
        var pageConfigurationVariable = buildPageConfigurationVariable(drivingVariables,displayCommonTab,displayHighImpactTab,pName,credibleSetTab,incredibleSetTab);
        $("#collapseExample div.wellPlace").empty().append(Mustache.render($('#organizeSignalSummaryOutline')[0].innerHTML,
            pageConfigurationVariable));
        var geneFocusTablevariable = buildGeneFocusTable(drivingVariables);
        $("#exposeDynamicUiTabHolder").empty().append(Mustache.render($('#geneFocusTable')[0].innerHTML,
            geneFocusTablevariable));
    };

    var refreshTopVariantsByPhenotype = function (sel, callBack) {
        var phenotypeName = sel.value;
        var dataSetName = sel.attr('dsr');
        refreshTopVariantsDirectlyByPhenotype(phenotypeName,callBack);
    };


    var lzOnCredSetTab = function (additionalParameters,credSetSpecific){

        var lzParmCred = {
            assayIdList:additionalParameters.assayIdList,
            portalTypeString:additionalParameters.portalTypeString,
            page:'geneInfo',
            variantId:null,
            positionInfo:credSetSpecific.positioningInformation,
            domId1:'#lz-'+additionalParameters.lzCredSet,
            collapsingDom:"#collapseExample",
            phenoTypeName:credSetSpecific.phenotypeName,
            phenoTypeDescription:credSetSpecific.pName,
            phenoPropertyName:credSetSpecific.phenoPropertyName,//'POSTERIOR_PROBABILITY',
            locusZoomDataset:credSetSpecific.datasetName,
            pageInitialization:!mpgSoftware.locusZoom.plotAlreadyExists(),
            functionalTrack:{},
            defaultTissues:undefined,
            defaultTissuesDescriptions:credSetSpecific.defaultTissuesDescriptions,
            datasetReadableName:credSetSpecific.datasetReadableName,
            experimentAssays:additionalParameters.experimentAssays,
            colorBy:credSetSpecific.positionBy,// 2,
            positionBy:credSetSpecific.positionBy,// 2,
            excludeLdIndexVariantReset: true,
            suppressAlternatePhenotypeChooser: true,
            getLocusZoomFilledPlotUrl:additionalParameters.getLocusZoomFilledPlotUrl,
            geneGetLZ:additionalParameters.getLocusZoomUrl,
            variantInfoUrl:additionalParameters.variantInfoUrl,
            makeDynamic:additionalParameters.firstStaticPropertyName,
            retrieveFunctionalDataAjaxUrl:additionalParameters.retrieveFunctionalDataAjaxUrl,
            sampleGroupsWithCredibleSetNames:credSetSpecific.sampleGroupsWithCredibleSetNames,
            maximumNumberOfResults:credSetSpecific.maximumNumberOfResults,
            credSetToVariants:credSetSpecific.credSetToVariants
        };

        if ((credSetSpecific.sampleGroupsWithCredibleSetNames)&&(credSetSpecific.sampleGroupsWithCredibleSetNames.length>0)) {
            mpgSoftware.locusZoom.initializeLZPage(lzParmCred);
        }
    }


    var getParkerData = function(incomingArray,defaultSelected){
        var returnValues =  [
            {value:"1_Active_TSS",name:"Active transcription start site"},
            {value:"2_Weak_TSS",name:"Weak transcription start site"},
            {value:"3_Flanking_TSS",name:"Flanking transcription start site"},
            {value:"5_Strong_transcription",name:"Strong transcription"},
            {value:"6_Weak_transcription",name:"Weak transcription"},
            {value:"8_Genic_enhancer",name:"Genic enhancer"},
            {value:"9_Active_enhancer_1",name:"Active enhancer 1"},
            {value:"10_Active_enhancer_2",name:"Active enhancer 2"},
            {value:"11_Weak_enhancer",name:"Weak enhancer"},
            {value:"14_Bivalent/poised_TSS",name:"Bivalent/poised transcription start site"},
            {value:"16_Repressed_polycomb",name:"Repressed polycomb"},
            {value:"17_Weak_repressed_polycomb",name:"Weak repressed polycomb"},
            {value:"18_Quiescent/low_signal",name:"Quiescent/low signal"}
        ];
        _.forEach(returnValues,function(o){
            o["selected"] = (defaultSelected.findIndex(function(w){return w===o.value})>-1)?"selected":"";
        });
        return _.concat(incomingArray,returnValues);
    };

    var getIbdData = function(incomingArray,defaultSelected){
        var returnValues =  [
            {value:"DNase",name:"DNase"},
            {value:"H3K27ac",name:"H3K27ac"}
        ];
        _.forEach(returnValues,function(o){
            o["selected"] = (defaultSelected.findIndex(function(w){return w===o.value})>-1)?"selected":"";
        });
        return _.concat(incomingArray,returnValues);
    };


    var getMoreEpiData = function(incomingArray,defaultSelected){
        var returnValues =  [
            {value:"DNase",name:"DNase"},
            {value:"H3K27ac",name:"H3K27ac"},
            {value:"UCSD",name:"TF binding footprint"}
        ];
        _.forEach(returnValues,function(o){
            o["selected"] = (defaultSelected.findIndex(function(w){return w===o.value})>-1)?"selected":"";
        });
        return _.concat(incomingArray,returnValues);
    };

    var gnomadDisplay = function(gene){
        var props = {
            gene: gene,
            exonPadding: 100,
            width: 1200,
            trackHeight: 20,
            showGtex: true,
        }

        var transcriptViewer = React.createElement(GnomadT2d.TranscriptViewer, props);
       // var transcriptViewer = React.createElement(GnomadT2d.StructureViewer, props);

        /**
         * Render the component
         */
        var root = document.getElementsByClassName('geneWindowDescriptionHolder')[0];
        ReactDOM.render(transcriptViewer, root);

    };


    var buildGeneFocusTable = function (additionalParameters) {
        var exposeDynamicUiIndicator = [];
        if (additionalParameters.exposeDynamicUi === "1"){
            var phenotype = additionalParameters.defaultPhenotype;
            var chromosome =  (additionalParameters.geneChromosome.substr(0,3)==='chr')?
                additionalParameters.geneChromosome.substr(3):
                additionalParameters.geneChromosome;
            if ( typeof additionalParameters.currentPhenotype !== 'undefined'){
                phenotype =  additionalParameters.currentPhenotype;
            }
            var suppressionOfRange = "display: none";
            if (additionalParameters.exposeRegionAdjustmentOnGenePage === "1"){
                suppressionOfRange = "";
            }
            var suppressionOfGeneTable = "display: none";
            if (additionalParameters.exposeGeneTableOnDynamicUi === "1"){
                suppressionOfGeneTable = "";
            }
            var suppressionOfVariantTable = "display: none";
            if (additionalParameters.exposeVariantTableOfDynamicUi === "1"){
                suppressionOfVariantTable = "";
            }
            var suppressionOfAllDynamicUiTabs = "";
            if ((additionalParameters.exposeGeneTableOnDynamicUi === "0") && (additionalParameters.exposeVariantTableOfDynamicUi === "0")){
                suppressionOfAllDynamicUiTabs = "display: none";
            }
            exposeDynamicUiIndicator.push({
                suppressionOfRange:suppressionOfRange,
                suppressionOfGeneTable:suppressionOfGeneTable,
                suppressionOfVariantTable:suppressionOfVariantTable,
                suppressionOfAllDynamicUiTabs:suppressionOfAllDynamicUiTabs,
                generalizedInputId:additionalParameters.generalizedInputId,
                generalizedGoButtonId:additionalParameters.generalizedGoButtonId,
                geneExtentBegin:additionalParameters.geneExtentBegin,
                geneExtentEnd:additionalParameters.geneExtentEnd,
                chromosome:chromosome,
                pname: phenotype
            });
        }

            return {dynamicUiTab:exposeDynamicUiIndicator}
    }


    /***
     * Build the data structure which we will then pass to Mustache
     *
     * @param additionalParameters
     * @param displayHighImpactTab
     * @param pName
     * @param credibleSetTab
     * @param incredibleSetTab
     * @returns {{commonTab: *, highImpactTab: *, pName: *, credibleSetTab: *, incredibleSetTab: *, genePrioritizationTab: Array, chromatinConformationTab: Array, exposeGeneComparisonSubTab: Array, exposeVariantComparisonSubTab: Array, dynamicUiTab: Array}}
     */
    var buildPageConfigurationVariable = function (additionalParameters,displayCommonTab,displayHighImpactTab,pName,credibleSetTab,incredibleSetTab){
        var weNeedToPutTablesInTabs = [];
        var genePrioritizationIndicator = [];
        var chromatinConformationIndicator = [];
        var exposeGeneComparisonIndicator = [];
        var exposeVariantComparisonIndicator = [];
        var exposeDynamicUiIndicator = [];
        var exposeGenesInRegionTab = [];

        if (additionalParameters.exposePredictedGeneAssociations === "1"){
            genePrioritizationIndicator.push(1);
        }
        if (additionalParameters.exposeHiCData === "1"){
            chromatinConformationIndicator.push(1);
        }
        if (additionalParameters.exposeDynamicUi === "1"){
            var phenotype = additionalParameters.defaultPhenotype;
            var chromosome =  (additionalParameters.geneChromosome.substr(0,3)==='chr')?
                additionalParameters.geneChromosome.substr(3):
                additionalParameters.geneChromosome;
            if ( typeof additionalParameters.currentPhenotype !== 'undefined'){
                phenotype =  additionalParameters.currentPhenotype;
            }
            var suppressionOfRange = "display: none";
            if (additionalParameters.exposeRegionAdjustmentOnGenePage === "1"){
                suppressionOfRange = "";
            }
            var suppressionOfGeneTable = "display: none";
            if (additionalParameters.exposeGeneTableOnDynamicUi === "1"){
                suppressionOfGeneTable = "";
            }
            var suppressionOfVariantTable = "display: none";
            if (additionalParameters.exposeVariantTableOfDynamicUi === "1"){
                suppressionOfVariantTable = "";
            }
            var suppressionOfAllDynamicUiTabs = "";
            if ((additionalParameters.exposeGeneTableOnDynamicUi === "0") && (additionalParameters.exposeVariantTableOfDynamicUi === "0")){
                suppressionOfAllDynamicUiTabs = "display: none";
            }

            exposeDynamicUiIndicator.push(
                {
                    suppressionOfRange:suppressionOfRange,
                    suppressionOfGeneTable:suppressionOfGeneTable,
                    suppressionOfVariantTable:suppressionOfVariantTable,
                    suppressionOfAllDynamicUiTabs:suppressionOfAllDynamicUiTabs,
                    generalizedInputId:additionalParameters.generalizedInputId,
                    generalizedGoButtonId:additionalParameters.generalizedGoButtonId,
                    geneExtentBegin:additionalParameters.geneExtentBegin,
                    geneExtentEnd:additionalParameters.geneExtentEnd,
                    chromosome:chromosome,
                    pname: phenotype
                }
            );
        }
        if (additionalParameters.exposeGeneComparisonTable === "1"){
            exposeGeneComparisonIndicator.push(1);
        }
        if (true){// we want to insert a variable here
            exposeVariantComparisonIndicator.push(1);
        }
        if ((true) &&(additionalParameters.exposeGeneComparisonTable === "1")) { // we only need tabs if we have both jeans and variant tables
             weNeedToPutTablesInTabs.push(1);
        }
        if (additionalParameters.exposeGenesInRegionTab === "1"){
            exposeGenesInRegionTab.push(1);
        }


    return {commonTab: displayCommonTab,
        highImpactTab: displayHighImpactTab,
        pName: pName,
        credibleSetTab:credibleSetTab,
        incredibleSetTab:incredibleSetTab,
        genePrioritizationTab:genePrioritizationIndicator,
        chromatinConformationTab:chromatinConformationIndicator,
        exposeGeneComparisonSubTab:exposeGeneComparisonIndicator,
        exposeVariantComparisonSubTab:exposeVariantComparisonIndicator,
        dynamicUiTab:exposeDynamicUiIndicator,
        weNeedToPutTablesInTabs:weNeedToPutTablesInTabs,
        exposeGenesInRegionTab:exposeGenesInRegionTab};

    }



    var updateSignificantVariantDisplay = function (data, additionalParameters) {
        var phenotypeName = additionalParameters.phenotype;
        var datasetName = additionalParameters.ds;
        var datasetReadableName = additionalParameters.dsr;
        var pName = additionalParameters.pname;

        // Adding initial phenotype name to page header
        $("#gene-info-summary-content").find(".gene-phenotype").find(".pname").text(pName);


        if ((typeof datasetName === 'undefined') ||
            (datasetName === null))   {
            var suboptimalDefaultDataSets = _.map(_.filter(data.datasetToChoose,function(o){return o.suitableForDefaultDisplay==="false"}),function(oo){return oo.dataset});
            // can we find a variant of from our preferred phenotype, which is still an acceptable default?
            var variant;
            if ((typeof suboptimalDefaultDataSets !== 'undefined')&&
                (suboptimalDefaultDataSets.length>0)){
                variant = _.find(data.variants.variants,function(o){return (    (suboptimalDefaultDataSets.indexOf(o.dataset)<0)&&
                                                                                (o.phenotype==phenotypeName)    )});

            }
            if (typeof variant === 'undefined'){ // nothing? Okay will take anything from the chosen phenotype
                variant = _.find(data.variants.variants,function(o){return (o.phenotype==phenotypeName) });
            }
            if (typeof variant === 'undefined') { // still nothing? That's unexpected, but let's take any old variant we can get
                variant = data.variants.variants[0]
            }
            if (typeof variant === 'undefined') { // we have no variants.  Give up and go home
                return;
            } else {
                phenotypeName = variant.phenotype;
                datasetName = variant.dataset;
                datasetReadableName = variant.dsr;
                pName = variant.pname;
            }
        }

        var useIgvNotLz = false; // remove option for now
        var renderData = mpgSoftware.geneSignalSummaryMethods.buildRenderData(data, 0.05, additionalParameters);
        var signalLevel = mpgSoftware.geneSignalSummaryMethods.assessSignalSignificance(renderData);
        var commonSectionShouldComeFirst = mpgSoftware.geneSignalSummaryMethods.commonSectionComesFirst(renderData);
        renderData = mpgSoftware.geneSignalSummaryMethods.refineRenderData(renderData, 1);
        if (useIgvNotLz) {
            renderData["igvChecked"] = 'checked';
        }
        if (mpgSoftware.locusZoom.plotAlreadyExists()) {
            mpgSoftware.locusZoom.removeAllPanels();
        }
        var selectorInfo = [];
        var displayInfo = [];
        var epigeneticAssaysString = additionalParameters.epigeneticAssays;
        if (epigeneticAssaysString.length > 0){
            var epigeneticAssays = _.map(epigeneticAssaysString.replace(new RegExp(/[\[\]']+/g),"").split (','),function (str){return parseInt(str)});
            var weHaveMoreThanOneAssay = (epigeneticAssays.length>1);
                _.forEach(epigeneticAssays, function (singleAssay){
                var assayRecord = mpgSoftware.regionInfo.retrieveDesiredAssay (singleAssay);
                _.forEach(assayRecord.selectionOptions, function (selectionOption){
                    selectorInfo.push ({value:selectionOption.value,name:selectionOption.name});
                    if (weHaveMoreThanOneAssay){
                        displayInfo.push ({value:selectionOption.value,name:selectionOption.name});
                    }
                });
            });
            _.forEach(selectorInfo,function(o){
                o["selected"] = (mpgSoftware.regionInfo.getDefaultTissueRegionOverlapMatcher(additionalParameters,0).
                findIndex(function(w){return w===o.value})>-1)?"selected":"";
            });
            _.forEach(displayInfo,function(o){
                o["selected"] = (mpgSoftware.regionInfo.getDefaultTissueRegionOverlapMatcher(additionalParameters,1).
                findIndex(function(w){return w===o.value})>-1)?"selected":"";
            });
        }

        var credibleSetTab = [];
        var incredibleSetTab = [];
        var dropDownRenderInfo = {};
        if (selectorInfo.length==0){
            dropDownRenderInfo['selectorInfoExists'] = [];
        } else {
            dropDownRenderInfo['selectorInfoExists'] = [{selectorInfo:selectorInfo}];
        }
        if (displayInfo.length==0){
            dropDownRenderInfo['displayInfoExists'] = [];
        } else {
            dropDownRenderInfo['displayInfoExists'] = [{displayInfo:displayInfo}];
        }
        if ((data.sampleGroupsWithCredibleSetNames)&&(data.sampleGroupsWithCredibleSetNames.length>0)){
            credibleSetTab.push(dropDownRenderInfo);
        } else {
            incredibleSetTab.push(dropDownRenderInfo);
        }

       // $('#collapseExample div.wellPlace').empty();

        var regionSpecificVersion = additionalParameters.regionSpecificVersion;
        var displayCommonTab = [{chromosome:additionalParameters.geneChromosomeMinusChr,
            geneExtentBegin:additionalParameters.geneExtentBegin,
            geneExtentEnd:additionalParameters.geneExtentEnd,
            pname:additionalParameters.pname
        }];
        var displayHighImpactTab = [{chromosome:additionalParameters.geneChromosomeMinusChr,
            geneExtentBegin:additionalParameters.geneExtentBegin,
            geneExtentEnd:additionalParameters.geneExtentEnd,
            pname:additionalParameters.pname
        }];
        if (additionalParameters.exposeCommonVariantTab==="0"){
            displayCommonTab = []; //don't display the common variant tab unless we want it
        }
        if (!additionalParameters.exposeRareVariantTab==="0"){
            displayHighImpactTab = [];//don't display the high-impact variant tab unless want it
        }
        if (regionSpecificVersion === 1){
            displayHighImpactTab = []; //don't display the high-impact variant tab in the case of a region search
        } else {
            if ((typeof data.userQueryContext !== 'undefined')&&
                (!data.userQueryContext.gene)){
                displayHighImpactTab = []; // don't display the high-impact tab unless this is actually a gene we're looking at
            }

        }

        var genePageConfigurationParameters = buildPageConfigurationVariable(additionalParameters,displayCommonTab,displayHighImpactTab,pName,credibleSetTab,incredibleSetTab);

        /* hiding High-impact variants on V2fKP */
        /*
         $("#organizeSignalSummaryHeaderGoesHere").empty().append(Mustache.render($('#organizeSignalSummaryHeader')[0].innerHTML,
             genePageConfigurationParameters
                ));
                */

        $("#commonVariantTabHolder").empty().append(Mustache.render($('#organizeSignalSummaryCommon')[0].innerHTML,
            genePageConfigurationParameters
                ));
        /* hiding High-impact variants on V2fKP */
        /*
        $("#highImpactVariantTabHolder").empty().append(Mustache.render($('#organizeSignalSummaryHighImpact')[0].innerHTML,
            genePageConfigurationParameters
                ));*/

        if (credibleSetTab.length>0){
            $("#credibleSetTabHolder").empty().append(Mustache.render($('#organizeSignalSummaryCredibleSet')[0].innerHTML,
                genePageConfigurationParameters
                    ));
        }
        if (incredibleSetTab.length>0){
            $("#credibleSetTabHolder").empty().append(Mustache.render($('#organizeSignalSummaryIncredibleSet')[0].innerHTML,
                genePageConfigurationParameters
                    ));
        }
        $("ul.nav a.top-level").click(function (e) {
            //$(this).tab('show');
            if ($(this).attr('href') === "#generalRangeHolder"){
                _.forEach($('div.generalRangeHolder ul li a'), function (element){
                    var domElement = $(element);
                    if (!domElement.hasClass('active')){
                        domElement.click();
                    }
                });
                $($('div.generalRangeHolder ul li.active a')).click();
            } else if ($(this).attr('href') === "#geneSpecificHolder"){
                $($('div.geneSpecificHolder ul li a')).click();
                $($('div.geneSpecificHolder ul li.active a')).click();
            }
        });

        mpgSoftware.dynamicUi.installDirectorButtonsOnTabs(additionalParameters);

        //testing for v2f
        //mpgSoftware.dynamicUi.modifyScreenFields({},additionalParameters);
        // mpgSoftware.dynamicUi.modifyScreenFields({phenotype:additionalParameters.phenotype, chromosome:additionalParameters.geneChromosomeMinusChr, startPosition:additionalParameters.geneExtentBegin, endPosition:additionalParameters.geneExtentEnd},
        //     additionalParameters);
        mpgSoftware.geneFocusTable.initialPageSetUp({phenotype:additionalParameters.phenotype, chromosome:additionalParameters.geneChromosomeMinusChr, startPosition:additionalParameters.geneExtentBegin, endPosition:additionalParameters.geneExtentEnd},
            additionalParameters);

        $('div.credibleSetHeader input.credSetStartPos').val(""+additionalParameters.geneExtentBegin);
        $('div.credibleSetHeader input.credSetEndPos').val(""+additionalParameters.geneExtentEnd);

        if (useIgvNotLz) {
            $('.locusZoomLocation').css('display', 'none');
            $('.browserChooserGoesHere').empty().append(Mustache.render($('#genomeBrowserTemplate')[0].innerHTML, renderData));
            // renderData["lzDomSpec"] = "lz-"+additionalParameters.lzCredSet;
            // renderData.staticDataExists = false;
            // renderData.dynamicDataExists = [];
            // renderData.dynamic = [];
            // renderData.static = [];
            // $("#locusZoomLocationCredSet").empty().append(Mustache.render($('#locusZoomTemplate')[0].innerHTML, renderData));
        } else {
            $('.igvGoesHere').css('display', 'none');
            $('.browserChooserGoesHere').empty().append(Mustache.render($('#genomeBrowserTemplate')[0].innerHTML, renderData));
            renderData["lzDomSpec"] = "lz-"+additionalParameters.lzCommon;
            if (displayCommonTab.length>0){
                $("#locusZoomLocation").empty().append(Mustache.render($('#locusZoomTemplate')[0].innerHTML, renderData));
            }
            renderData["lzDomSpec"] = "lz-"+additionalParameters.lzCredSet;
            renderData.staticDataExists = false;
            renderData.dynamicDataExists = [];
            renderData.dynamic = [];
            renderData.static = [];
            $("#locusZoomLocationCredSet").empty().append(Mustache.render($('#locusZoomTemplate')[0].innerHTML, renderData));
        }

        if (displayHighImpactTab.length>0){
            mpgSoftware.geneSignalSummaryMethods.updateHighImpactTable(data, additionalParameters);
        }

        //  set up the gait interface
        if ((!additionalParameters.suppressBurdenTest)&&
            (displayHighImpactTab.length>0)){
            mpgSoftware.burdenTestShared.buildGaitInterface('#burdenGoesHere', {
                    accordionHeaderClass: 'toned-down-accordion-heading',
                    modifiedTitle: 'Custom aggregation tests',
                    modifiedTitleStyling: 'font-size: 18px;text-decoration: underline;padding-left: 20px; float: right; margin-right: 20px;',
                    allowExperimentChoice: false,
                    allowAggregationMethodChoice: true,
                    allowPhenotypeChoice: true,
                    allowStratificationChoice: true,
                    defaultPhenotype: phenotypeName
                },
                additionalParameters.geneName,
                true,
                '#datasetFilter',additionalParameters);
        }


        if (displayHighImpactTab.length>0){
            $("#aggregateVariantsLocation").empty().append(Mustache.render($('#aggregateVariantsTemplate')[0].innerHTML, renderData));
        }


        var alwaysShowTheCredibleSetTab = true;

        // if ((data.sampleGroupsWithCredibleSetNames)&&(data.sampleGroupsWithCredibleSetNames.length>0)) {


        var weHaveAnIncredibleSet = true;
        var propertyToRequest = 'POSTERIOR_PROBABILITY';
        if (incredibleSetTab.length>0){
            weHaveAnIncredibleSet = false;
            propertyToRequest = 'P_VALUE';
        }
        //buildOutSetPresentation (data, additionalParameters, false, propertyToRequest);
        additionalParameters['rememberOriginalData'] = data;
        if (additionalParameters.exposeGeneComparisonTable === "1") {
            buildOutSetPresentation(data, additionalParameters, true, propertyToRequest);
        }


        //    buildOutCredibleSetPresentation(data, additionalParameters);
        // } else if (alwaysShowTheCredibleSetTab){
        //    buildOutIncredibleSetPresentation(data, additionalParameters);
        // }

        if (displayCommonTab.length>0){
            mpgSoftware.geneSignalSummaryMethods.updateCommonTable(data, additionalParameters);
        }

        //var phenotypeName = $('#signalPhenotypeTableChooser option:selected').val();
        var sampleBasedPhenotypeName = mpgSoftware.geneSignalSummaryMethods.phenotypeNameForSampleData(phenotypeName,additionalParameters.portalTypeString);
        var hailPhenotypeInfo = mpgSoftware.geneSignalSummaryMethods.phenotypeNameForHailData(phenotypeName);

        var positioningInformation = {
            chromosome: (additionalParameters.geneChromosome).replace(/chr/g, ""),
            startPosition: additionalParameters.geneExtentBegin,
            endPosition: additionalParameters.geneExtentEnd
        };
        if (useIgvNotLz) {
            igvLauncher.setUpIgv(additionalParameters.geneName,
                '.igvGoesHere',
                additionalParameters.recomb_rateMsg,
                additionalParameters.genesMsg,
                additionalParameters.retrievePotentialIgvTracksUrl,
                additionalParameters.getDataUrl,
                additionalParameters.variantInfoUrl,
                additionalParameters.traitInfoUrl,
                additionalParameters.igvIntro,
                phenotypeName);
        } else {
            var defaultTissues = additionalParameters.defaultTissues;
            var defaultTissuesDescriptions = additionalParameters.defaultTissuesDescriptions;
            var lzParm = {
                assayIdList:additionalParameters.assayIdList,
                portalTypeString:additionalParameters.portalTypeString,
                page:'geneInfo',
                variantId:null,
                positionInfo:positioningInformation,
                domId1:'#lz-'+additionalParameters.lzCommon,
                collapsingDom:"#collapseExample",
                phenoTypeName:phenotypeName,
                phenoTypeDescription:pName,
                phenoPropertyName:additionalParameters.firstPropertyName,
                locusZoomDataset:datasetName,
                pageInitialization:!mpgSoftware.locusZoom.plotAlreadyExists(),
                functionalTrack:{},
                defaultTissues:defaultTissues,
                defaultTissuesDescriptions:defaultTissuesDescriptions,
                datasetReadableName:datasetReadableName,
                experimentAssays:additionalParameters.experimentAssays,
                colorBy:1,
                positionBy:1,
                excludeLdIndexVariantReset: false,
                suppressAlternatePhenotypeChooser: false,
                getLocusZoomFilledPlotUrl:additionalParameters.getLocusZoomFilledPlotUrl,
                geneGetLZ:additionalParameters.getLocusZoomUrl,
                variantInfoUrl:additionalParameters.variantInfoUrl,
                makeDynamic:additionalParameters.firstStaticPropertyName,
                retrieveFunctionalDataAjaxUrl:additionalParameters.retrieveFunctionalDataAjaxUrl
            };
            if (displayCommonTab.length>0){
                mpgSoftware.locusZoom.initializeLZPage(lzParm);
            }




            $('a[href="#commonVariantTabHolder"]').on('shown.bs.tab', function (e) {
                mpgSoftware.locusZoom.setNewDefaultLzPlot('#lz-'+additionalParameters.lzCommon);
                mpgSoftware.locusZoom.rescaleSVG(mpgSoftware.locusZoom.getNewDefaultLzPlot());
            });
            // $('a[href="#credibleSetTabHolder"]').on('shown.bs.tab', function (e) {
            //     mpgSoftware.locusZoom.setNewDefaultLzPlot('#lz-'+additionalParameters.lzCredSet);
            //     mpgSoftware.locusZoom.rescaleSVG(mpgSoftware.locusZoom.getNewDefaultLzPlot());
            // });
        }
        if (( typeof sampleBasedPhenotypeName !== 'undefined') &&
            ( sampleBasedPhenotypeName.length > 0)&&
            (!additionalParameters.suppressBurdenTest)&&
            ((displayHighImpactTab.length>0))) {
                $('#aggregateVariantsLocation').css('display', 'block');
                $('#noAggregatedVariantsLocation').css('display', 'none');
                var arrayOfPromises = [];
                arrayOfPromises.push(mpgSoftware.geneSignalSummaryMethods.refreshVariantAggregates(sampleBasedPhenotypeName, "8", additionalParameters.sampleDataSet, additionalParameters.burdenDataSet,
                        "2", "NaN", additionalParameters.geneName, mpgSoftware.geneSignalSummaryMethods.updateAggregateVariantsDisplay, "#allMissense"))
                arrayOfPromises.push(mpgSoftware.geneSignalSummaryMethods.refreshVariantAggregates(sampleBasedPhenotypeName, "7", additionalParameters.sampleDataSet, additionalParameters.burdenDataSet,
                        "2", "NaN", additionalParameters.geneName, mpgSoftware.geneSignalSummaryMethods.updateAggregateVariantsDisplay, "#possiblyDamaging"));
                arrayOfPromises.push(mpgSoftware.geneSignalSummaryMethods.refreshVariantAggregates(sampleBasedPhenotypeName, "6", additionalParameters.sampleDataSet, additionalParameters.burdenDataSet,
                        "2", "NaN", additionalParameters.geneName, mpgSoftware.geneSignalSummaryMethods.updateAggregateVariantsDisplay, "#probablyDamaging"));
                arrayOfPromises.push(mpgSoftware.geneSignalSummaryMethods.refreshVariantAggregates(sampleBasedPhenotypeName, "5", additionalParameters.sampleDataSet, additionalParameters.burdenDataSet,
                        "2", "NaN", additionalParameters.geneName, mpgSoftware.geneSignalSummaryMethods.updateAggregateVariantsDisplay, "#proteinTruncating"));
                $.when.apply($, arrayOfPromises).then(function() {
                    $('#rSpinner').hide();
                });
        } else {
            $('#aggregateVariantsLocation').css('display', 'none');
            $('#noAggregatedVariantsLocation').css('display', 'block');
        }

        $('#collapseExample').on('shown.bs.collapse', function (e) {
            if (mpgSoftware.locusZoom.plotAlreadyExists()) {
                mpgSoftware.locusZoom.rescaleSVG();
            }
        });
        $('#rSpinner').hide();
        mpgSoftware.geneSignalSummary.displayVariantResultsTable(phenotypeName);
        $("#xpropertiesModal").on("shown.bs.modal", function () {
            $("#xpropertiesModal li a").click();
        });
        $('a[href="#highImpactVariantTabHolder"]').on('shown.bs.tab', function (e) {
            $('#highImpactTemplateHolder').dataTable().fnAdjustColumnSizing();
            mpgSoftware.regionInfo.removeAllCredSetHeaderPopUps();
        });
        $('a[href="#commonVariantTabHolder"]').on('shown.bs.tab', function (e) {
            $('#commonVariantsLocationHolder').dataTable().fnAdjustColumnSizing();
            mpgSoftware.regionInfo.removeAllCredSetHeaderPopUps();
        });
        // $('a[href="#credibleSetTabHolder"]').on('shown.bs.tab', function (e) {
        //     mpgSoftware.regionInfo.removeAllCredSetHeaderPopUps();
        //  });
        // $('a[href="#credibleSetTabHolder"]').on('shown.bs.tab', function (e) {
        //     mpgSoftware.locusZoom.setNewDefaultLzPlot('#lz-'+additionalParameters.lzCredSet);
        //     mpgSoftware.locusZoom.rescaleSVG(mpgSoftware.locusZoom.getNewDefaultLzPlot());
        // });

        /* muting for V2F KP */
        /*
        $('a[href="#credibleSetTabHolder"]').on('shown.bs.tab', function (e) {
            var signalSummarySectionVariables = getSignalSummarySectionVariables();
            buildOutSetPresentation(signalSummarySectionVariables['rememberOriginalData'],
                signalSummarySectionVariables,
                false,'P_VALUE');
            mpgSoftware.locusZoom.setNewDefaultLzPlot('#lz-'+additionalParameters.lzCredSet);
           // mpgSoftware.locusZoom.rescaleSVG(mpgSoftware.locusZoom.getNewDefaultLzPlot());
            mpgSoftware.regionInfo.removeAllCredSetHeaderPopUps();
        });
        */

        var signalSummarySectionVariables = getSignalSummarySectionVariables();
        buildOutSetPresentation(signalSummarySectionVariables['rememberOriginalData'],
            signalSummarySectionVariables,
            false,'P_VALUE');
        mpgSoftware.locusZoom.setNewDefaultLzPlot('#lz-'+additionalParameters.lzCredSet);
        // mpgSoftware.locusZoom.rescaleSVG(mpgSoftware.locusZoom.getNewDefaultLzPlot());
        mpgSoftware.regionInfo.removeAllCredSetHeaderPopUps();


        if (!commonSectionShouldComeFirst) {
            $('.commonVariantChooser').removeClass('active');
            $('.highImpacVariantChooser').addClass('active');
            if (displayHighImpactTab.length>0) {
                $('#highImpactTemplateHolder').dataTable().fnAdjustColumnSizing();
            }

        }

        if (((displayHighImpactTab.length===0) && (displayCommonTab.length===0)) ||
            (data.userQueryContext.regionSpecificVersion)){
            $('.commonVariantChooser').removeClass('active');
            $('.highImpacVariantChooser').removeClass('active');
            $('.credibleSetChooser').addClass('active');
        }
       // gnomadDisplay(additionalParameters.geneName);

    };



// public routines are declared below
    return {
        setSignalSummarySectionVariables:setSignalSummarySectionVariables,
        refreshTopVariants:refreshTopVariants,
        buildCommonTable:buildCommonTable,
        buildHighImpactTable:buildHighImpactTable,
        buildAllVariantsTable:buildAllVariantsTable,
        processAggregatedData:processAggregatedData,
        phenotypeNameForSampleData:phenotypeNameForSampleData,
        phenotypeNameForHailData:phenotypeNameForHailData,
        refineRenderData:refineRenderData,
        buildRenderData:buildRenderData,
        updateAggregateVariantsDisplay:updateAggregateVariantsDisplay,
        commonSectionComesFirst:commonSectionComesFirst,
        toggleOtherPhenoBtns:toggleOtherPhenoBtns,
        refreshSignalSummaryBasedOnPhenotype:refreshSignalSummaryBasedOnPhenotype,
        displayInterestingPhenotypes:displayInterestingPhenotypes,
        assessSignalSignificance:assessSignalSignificance,
        updateDisplayBasedOnSignificanceLevel:updateDisplayBasedOnSignificanceLevel,
        tableInitialization:tableInitialization,
        commonTableRedraw:commonTableRedraw,
        commonTableDsFilter:commonTableDsFilter,
        highImpactTableDsFilter:highImpactTableDsFilter,
        allVariantsTableDsFilter:allVariantsTableDsFilter,
        disableClickPropagation:disableClickPropagation,
        startVRT:startVRT,
        updateCommonTable:updateCommonTable,
        updateHighImpactTable:updateHighImpactTable,
        updateAllVariantsTable:updateAllVariantsTable,
        updateGenePageTables:updateGenePageTables,
        adjustProperties:adjustProperties,
        refreshTopVariantsByPhenotype:refreshTopVariantsByPhenotype,
        refreshVariantAggregates:refreshVariantAggregates,
        updateSignificantVariantDisplay:updateSignificantVariantDisplay,
        buildRenderDataFromNonAggregatedData:buildRenderDataFromNonAggregatedData,
        updateCredibleSetTable:updateCredibleSetTable,
        initialPageSetUp:initialPageSetUp,
        buildNewCredibleSetPresentation:buildNewCredibleSetPresentation,
        lzOnCredSetTab:lzOnCredSetTab,
        getSingleBestPhenotypeAndLaunchInterface:getSingleBestPhenotypeAndLaunchInterface,
        getSingleBestNonFavoredPhenotypeAndLaunchInterface:getSingleBestNonFavoredPhenotypeAndLaunchInterface,
        refreshTopVariantsDirectlyByPhenotype:refreshTopVariantsDirectlyByPhenotype,
        getSignalSummarySectionVariables:getSignalSummarySectionVariables,
        processGeneRankingInfo: processGeneRankingInfo,
        processGeneRankingData:processGeneRankingData,
        selfContainedGeneRanking: selfContainedGeneRanking,
        resetPhenotypeCoefficientsBySignificance: resetPhenotypeCoefficientsBySignificance,
        resetPhenotypeCoefficientsByOne:resetPhenotypeCoefficientsByOne,
        resetPhenotypeCoefficientsByZero:resetPhenotypeCoefficientsByZero,
        setAllTissueChoicesUnchecked:setAllTissueChoicesUnchecked,
        setAllTissueChoicesChecked:setAllTissueChoicesChecked,
        processGeneRankingDataAndResetPhenoCoefficients:processGeneRankingDataAndResetPhenoCoefficients,
        hiGlassExperiment:hiGlassExperiment
    }

}());
