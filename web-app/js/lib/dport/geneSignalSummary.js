var mpgSoftware = mpgSoftware || {};




mpgSoftware.geneSignalSummaryMethods = (function () {
    var loading = $('#rSpinner');
    var commonTable;
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
        pValueIndex = _.findIndex(requestedProperties,function (o){o=="PVALUE"});
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
            requestedProperties.push("dataset");
        }
        var counter = 0;
        var columnDefsForDatatable = _.map(requestedProperties, function(o){
                return buildAHeaderForTheDatatable(o,counter++,'highImpactDataSet');
            }
        );
        pValueIndex = _.findIndex(requestedProperties,function (o){o=="PVALUE"});
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
        pValueIndex = _.findIndex(requestedProperties,function (o){o=="PVALUE"});
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
                obj['P_VALUE'] = UTILS.realNumberFormatter((val) ? val : 1);
                obj['P_VALUEV'] = (val) ? val : 1;
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
            if ((typeof mafValue !== 'undefined') && (mafValue !== '') && (mafValue > 0.05) &&
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
        renderData['assayIdList'] = additionalData.assayIdList
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
        return _.sortBy(listOfInterestingPhenotypes,[function(o){return o.pValue}]);
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
    var refreshSignalSummaryBasedOnPhenotype = function () {
        var phenocode = $('.phenotypeStrength.chosenPhenotype').attr('id');
        var ds = $('.phenotypeStrength.chosenPhenotype').attr('ds');
        var phenoName = $('.phenotypeStrength.chosenPhenotype').text();
        launchUpdateSignalSummaryBasedOnPhenotype(phenocode,ds,phenoName);
    };
    var displayInterestingPhenotypes = function (data,params) {
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
            var phenotypeDescriptions = '<label>Phenotypes with signals</label><ul class="nav nav-pills">';
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
            phenotypeDescriptions += ('<li><a href="#" class="morePhenos"  onclick="mpgSoftware.geneSignalSummaryMethods.toggleOtherPhenoBtns()">Additional phenotypes...</a></li>');
            phenotypeDescriptions += ('<li><a href="#" class="noMorePhenos" style="display:none" onclick="mpgSoftware.geneSignalSummaryMethods.toggleOtherPhenoBtns()">Collapse phenotypes without signals</a></li>');
            phenotypeDescriptions += '</ul>';
            $('#interestingPhenotypes').append(phenotypeDescriptions);

        }

        $('.phenotypeStrength').on("click",updateSignalSummaryBasedOnPhenotype);
        if (overrideClickIndex !== -1){
            $($('.phenotypeStrength')[overrideClickIndex]).click();
        } else {
            $('.phenotypeStrength').first().click();
        }

    };

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


        $('#trafficLightHolder').empty();
        var significanceLevelDom = $('.trafficExplanation'+significanceLevel);
        significanceLevelDom.removeClass('unemphasize');
        significanceLevelDom.addClass('emphasize');
        if (significanceLevel == 1){
            $('#trafficLightHolder').append(params.redLightImage);
        } else if (significanceLevel == 2){
            $('#trafficLightHolder').append(params.yellowLightImage);
        } else if (significanceLevel == 3){
            $('#trafficLightHolder').append(params.greenLightImage);
        }
        $('#signalLevelHolder').text(significanceLevel);
    };

    var refreshTopVariants = function ( callBack, params ) {
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
        $.ajax({
            cache: false,
            type: "post",
            url: params.retrieveTopVariantsAcrossSgsUrl,
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
        var loading = $('#rSpinner');
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
                sampleGroupsWithCredibleSetNames:sampleGroupsWithCredibleSetNames
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




    var buildOutCredibleSetPresentation = function (data,additionalData){
        var loading = $('#rSpinner');
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
                sampleGroupsWithCredibleSetNames:data.sampleGroupsWithCredibleSetNames
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

    var refreshTopVariantsDirectlyByPhenotype = function (phenotypeName, callBack, parameter) {
        var rememberCallBack = callBack;
        var rememberParameter = parameter;
        var coreVariables = getSignalSummarySectionVariables();
        var propertiesToIncludeQuoted = [];
        var propertiesToRemoveQuoted = [];
        _.each(parameter.propertiesToInclude, function(o){propertiesToIncludeQuoted.push(o)});
        _.each(parameter.propertiesToRemove, function(o){propertiesToRemoveQuoted.push(o)});

        $.ajax({
            cache: false,
            type: "post",
            url: coreVariables.retrieveTopVariantsAcrossSgsUrl,
            data: {
                phenotype: phenotypeName,
                geneToSummarize:coreVariables.geneName,
                propertiesToInclude: propertiesToIncludeQuoted.join(","),
                propertiesToRemove: propertiesToRemoveQuoted.join(",")
            },
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

    };
    var initialPageSetUp = function (drivingVariables) {
        $("#tableHeaderHolder").empty().append(
            Mustache.render($('#genePageHeaderTemplate')[0].innerHTML, drivingVariables));
    }
    var refreshTopVariantsByPhenotype = function (sel, callBack) {
        var phenotypeName = sel.value;
        var dataSetName = sel.attr('dsr');
        refreshTopVariantsDirectlyByPhenotype(phenotypeName,callBack);
    };

    var updateSignificantVariantDisplay = function (data, additionalParameters) {
        var phenotypeName = additionalParameters.phenotype;
        var datasetName = additionalParameters.ds;
        var datasetReadableName = additionalParameters.dsr;
        var pName = additionalParameters.pname;
        // var useIgvNotLz = additionalParameters.preferIgv;
        var useIgvNotLz = ($('input[name=genomeBrowser]:checked').val() === '2');

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
        var credibleSetTab = [];
        if ((data.sampleGroupsWithCredibleSetNames)&&(data.sampleGroupsWithCredibleSetNames.length>0)){
            credibleSetTab.push(1);
        }
        $('#collapseExample div.wellPlace').empty();

        $("#collapseExample div.wellPlace").empty().append(Mustache.render($('#organizeSignalSummaryCommonFirstTemplate')[0].innerHTML,
            {pName: pName,credibleSetTab:credibleSetTab}));
        $('div.credibleSetHeader input.credSetStartPos').val(""+additionalParameters.geneExtentBegin);
        $('div.credibleSetHeader input.credSetEndPos').val(""+additionalParameters.geneExtentEnd);

        if (useIgvNotLz) {
            $('.locusZoomLocation').css('display', 'none');
            $('.browserChooserGoesHere').empty().append(Mustache.render($('#genomeBrowserTemplate')[0].innerHTML, renderData));
        } else {
            $('.igvGoesHere').css('display', 'none');
            $('.browserChooserGoesHere').empty().append(Mustache.render($('#genomeBrowserTemplate')[0].innerHTML, renderData));
            renderData["lzDomSpec"] = "lz-"+additionalParameters.lzCommon;
            $("#locusZoomLocation").empty().append(Mustache.render($('#locusZoomTemplate')[0].innerHTML, renderData));
            renderData["lzDomSpec"] = "lz-"+additionalParameters.lzCredSet;
            renderData.staticDataExists = false;
            renderData.static = [];
            $("#locusZoomLocationCredSet").empty().append(Mustache.render($('#locusZoomTemplate')[0].innerHTML, renderData));
        }

        mpgSoftware.geneSignalSummaryMethods.updateHighImpactTable(data, additionalParameters);

        //  set up the gait interface
        if (!additionalParameters.suppressBurdenTest){
            mpgSoftware.burdenTestShared.buildGaitInterface('#burdenGoesHere', {
                    accordionHeaderClass: 'toned-down-accordion-heading',
                    modifiedTitle: 'Run a custom burden test',
                    modifiedTitleStyling: 'font-size: 18px;text-decoration: underline;padding-left: 20px; float: right; margin-right: 20px;',
                    allowExperimentChoice: false,
                    allowPhenotypeChoice: true,
                    allowStratificationChoice: true,
                    defaultPhenotype: phenotypeName
                },
                additionalParameters.geneName,
                true,
                '#datasetFilter',
                additionalParameters.sampleMetadataExperimentAjaxUrl,
                additionalParameters.sampleMetadataAjaxWithAssumedExperimentUrl,
                additionalParameters.variantOnlyTypeAheadUrl,
                additionalParameters.sampleMetadataAjaxUrl,
                additionalParameters.generateListOfVariantsFromFiltersAjaxUrl,
                additionalParameters.retrieveSampleSummaryUrl,
                additionalParameters.variantInfoUrl,
                additionalParameters.variantAndDsAjaxUrl,
                additionalParameters.burdenTestVariantSelectionOptionsAjaxUrl);
        }


        $("#aggregateVariantsLocation").empty().append(Mustache.render($('#aggregateVariantsTemplate')[0].innerHTML, renderData));

        if ((data.sampleGroupsWithCredibleSetNames)&&(data.sampleGroupsWithCredibleSetNames.length>0)) {
            // buildOutCredibleSetPresentation(data, phenotypeName);
            // mpgSoftware.geneSignalSummaryMethods.updateAllVariantsTable(data, additionalParameters);
            buildOutCredibleSetPresentation(data, additionalParameters);
            // mpgSoftware.geneSignalSummaryMethods.updateAllVariantsTable(data, additionalParameters);
        }

        mpgSoftware.geneSignalSummaryMethods.updateCommonTable(data, additionalParameters);

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
            mpgSoftware.locusZoom.initializeLZPage(lzParm);

            var lzParmCred = {
                assayIdList:additionalParameters.assayIdList,
                portalTypeString:additionalParameters.portalTypeString,
                page:'geneInfo',
                variantId:null,
                positionInfo:positioningInformation,
                domId1:'#lz-'+additionalParameters.lzCredSet,
                collapsingDom:"#collapseExample",
                phenoTypeName:phenotypeName,
                phenoTypeDescription:pName,
                phenoPropertyName:'POSTERIOR_PROBABILITY',
                locusZoomDataset:datasetName,
                pageInitialization:!mpgSoftware.locusZoom.plotAlreadyExists(),
                functionalTrack:{},
                defaultTissues:undefined,
                defaultTissuesDescriptions:defaultTissuesDescriptions,
                datasetReadableName:datasetReadableName,
                experimentAssays:additionalParameters.experimentAssays,
                colorBy:2,
                positionBy:2,
                excludeLdIndexVariantReset: true,
                suppressAlternatePhenotypeChooser: true,
                getLocusZoomFilledPlotUrl:additionalParameters.getLocusZoomFilledPlotUrl,
                geneGetLZ:additionalParameters.getLocusZoomUrl,
                variantInfoUrl:additionalParameters.variantInfoUrl,
                makeDynamic:additionalParameters.firstStaticPropertyName,
                retrieveFunctionalDataAjaxUrl:additionalParameters.retrieveFunctionalDataAjaxUrl,
                sampleGroupsWithCredibleSetNames:data.sampleGroupsWithCredibleSetNames
            };



            // lzParm.domId1 = '#lz-'+additionalParameters.lzCredSet;
            // lzParm.colorBy = 2; // category
            // lzParm.positionBy = 2; // posterior p
            // lzParm.excludeLdIndexVariantReset = true;
            // lzParm.suppressAlternatePhenotypeChooser = true;
            // lzParm.defaultTissues = undefined;
            // lzParm.phenoPropertyName='POSTERIOR_PROBABILITY';
            //lzParm.sampleGroupsWithCredibleSetNames=data.sampleGroupsWithCredibleSetNames;
            if ((data.sampleGroupsWithCredibleSetNames)&&(data.sampleGroupsWithCredibleSetNames.length>0)) {
                mpgSoftware.locusZoom.initializeLZPage(lzParmCred);
            }


            $('a[href="#commonVariantTabHolder"]').on('shown.bs.tab', function (e) {
                mpgSoftware.locusZoom.rescaleSVG('#lz-'+additionalParameters.lzCommon);
            });
            $('a[href="#credibleSetTabHolder"]').on('shown.bs.tab', function (e) {
                mpgSoftware.locusZoom.rescaleSVG('#lz-'+additionalParameters.lzCredSet);
            });
        }
        if (( typeof sampleBasedPhenotypeName !== 'undefined') &&
            ( sampleBasedPhenotypeName.length > 0)&&
            (!additionalParameters.suppressBurdenTest)) {
                $('#aggregateVariantsLocation').css('display', 'block');
                $('#noAggregatedVariantsLocation').css('display', 'none');
                var arrayOfPromises = [];
                arrayOfPromises.push(mpgSoftware.geneSignalSummaryMethods.refreshVariantAggregates(sampleBasedPhenotypeName, "0", additionalParameters.sampleDataSet, additionalParameters.burdenDataSet,
                        "2", "NaN", additionalParameters.geneName, mpgSoftware.geneSignalSummaryMethods.updateAggregateVariantsDisplay, "#allVariants"));
                arrayOfPromises.push(mpgSoftware.geneSignalSummaryMethods.refreshVariantAggregates(sampleBasedPhenotypeName, "1", additionalParameters.sampleDataSet, additionalParameters.burdenDataSet,
                        "2", "NaN", additionalParameters.geneName, mpgSoftware.geneSignalSummaryMethods.updateAggregateVariantsDisplay, "#allCoding"));
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
        $('#rSpinner').hide()
        mpgSoftware.geneSignalSummary.displayVariantResultsTable(phenotypeName);
        $("#xpropertiesModal").on("shown.bs.modal", function () {
            $("#xpropertiesModal li a").click();
        });
        $('a[href="#highImpactVariantTabHolder"]').on('shown.bs.tab', function (e) {
            $('#highImpactTemplateHolder').dataTable().fnAdjustColumnSizing();
        });
        $('a[href="#commonVariantTabHolder"]').on('shown.bs.tab', function (e) {
            $('#commonVariantsLocationHolder').dataTable().fnAdjustColumnSizing();
        });
        $('a[href="#credibleSetTabHolder"]').on('shown.bs.tab', function (e) {
            //$('#allVariantsTemplateHolder').dataTable().fnAdjustColumnSizing();
        });

        if (!commonSectionShouldComeFirst) {
            $('.commonVariantChooser').removeClass('active');
            $('.highImpacVariantChooser').addClass('active');
            $('#highImpactTemplateHolder').dataTable().fnAdjustColumnSizing();
        }

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
        buildNewCredibleSetPresentation:buildNewCredibleSetPresentation
    }

}());

