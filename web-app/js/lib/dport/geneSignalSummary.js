var mpgSoftware = mpgSoftware || {};




mpgSoftware.geneSignalSummaryMethods = (function () {
    var loading = $('#rSpinner');


    var buildCommonTable = function(selectionToFill,
                                    variantInfoUrl,
                                      cvar){

        var commonTable  = $(selectionToFill).dataTable({
                "bDestroy": true,
                "className": "compact",
                "bAutoWidth" : false,
                "order": [[ 1, "asc" ]],
                "columnDefs": [
                     { "name": "VAR_ID",   "targets": [0], "type":"allAnchor", "title":"Variant ID",
                        "sWidth": "20%" },
                    { "name": "DBSNP_ID",   "targets": [1], "title":"dbSNP ID",
                        "sWidth": "15%"  },
                    { "name": "PVALUE",   "targets": [2], "title":"p-Value",
                        "sWidth": "15%"  },
                    { "name": "EFFECT",   "targets": [3], "title":"Effect",
                        "sWidth": "15%" },
                    { "name": "DS",   "targets": [4], "title":"Data set",
                        "sWidth": "35%" }
                ],
                "order": [[ 2, "asc" ]],
                "scrollY":        "300px",
                "scrollCollapse": true,
                "paging":         false,
                "bFilter": true,
                "bLengthChange" : true,
                "bInfo":false,
                "bProcessing": true,
                "fnRowCallback": function( nRow, aData, iDisplayIndex ) {
                   nRow.className = $(aData[0]).attr('custag');
                   return nRow;
                 }
            }
        );
        _.forEach(cvar,function(variantRec){
            var arrayOfRows = [];
            var variantID = variantRec.id;
            arrayOfRows.push('<a href="'+variantInfoUrl+'/'+variantID+'" class="boldItlink" custag="'+variantRec.CAT+'">'+variantID+'</a>');
            var DBSNP_ID = (variantRec.rsId)?variantRec.rsId:'';
            arrayOfRows.push(DBSNP_ID);
            arrayOfRows.push(variantRec.P_VALUE);
            arrayOfRows.push(variantRec.BETA);
            arrayOfRows.push(variantRec.dsr);
            commonTable.dataTable().fnAddData( arrayOfRows );
        });
        $('div.dataTables_scrollHeadInner table.dataTable thead tr').addClass('niceHeaders');
    };



    var buildHighImpactTable = function(selectionToFill,
                                    variantInfoUrl,
                                    rvar){

        var highImpactTable  = $(selectionToFill).dataTable({
                "bDestroy": true,
                "className": "compact",
                "bAutoWidth" : false,
                "order": [[ 1, "asc" ]],
                "columnDefs": [
                    { "name": "VAR_ID",   "targets": [0], "type":"allAnchor", "title":"Variant ID",
                        "sWidth": "16%" },
                    { "name": "DBSNP_ID",   "targets": [1], "title":"dbSNP ID",
                        "sWidth": "13%"  },
                    { "name": "PREDICTED",   "targets": [2], "title":"Predicted<br/>impact",
                        "sWidth": "13%"  },
                    { "name": "PVALUE",   "targets": [3], "title":"p-Value",
                        "sWidth": "13%"  },
                    { "name": "EFFECT",   "targets": [4], "title":"Effect",
                        "sWidth": "15%" },
                    { "name": "DS",   "targets": [5], "title":"Data set",
                        "sWidth": "30%" }
                ],
                "order": [[ 3, "asc" ]],
                "scrollY":        "300px",
                "scrollCollapse": true,
                "paging":         false,
                "bFilter": true,
                "bLengthChange" : true,
                "bInfo":false,
                "bProcessing": true,
                "fnRowCallback": function( nRow, aData, iDisplayIndex ) {
                    nRow.className = $(aData[0]).attr('custag');
                    return nRow;
                }
            }
        );
        _.forEach(rvar,function(variantRec){
            var arrayOfRows = [];
            var variantID = variantRec.id;
            arrayOfRows.push('<a href="'+variantInfoUrl+'/'+variantID+'" class="boldItlink" custag="'+variantRec.CAT+'">'+variantID+'</a>');
            var DBSNP_ID = (variantRec.rsId)?variantRec.rsId:'';
            arrayOfRows.push(DBSNP_ID);
            arrayOfRows.push(variantRec.deleteriousness);
            arrayOfRows.push(variantRec.P_VALUE);
            arrayOfRows.push(variantRec.BETA);
            arrayOfRows.push(variantRec.dsr);
            highImpactTable.dataTable().fnAddData( arrayOfRows );
        });
        $('div.dataTables_scrollHeadInner table.dataTable thead tr').addClass('niceHeaders');
    };

    var phenotypeNameForSampleData  = function (untranslatedPhenotype) {
        var convertedName = '';
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
            var mafValue;
            var mdsValue;
            var pValue;
            if (key === 'VAR_ID') {
                obj['id'] = (val) ? val : '';
            } else if (key === 'DBSNP_ID') {
                obj['rsId'] = (val) ? val : '';
            } else if (key === 'Protein_change') {
                obj['impact'] = (val) ? val : '';
            } else if (key === 'Consequence') {
                obj['deleteriousness'] = (val) ? val : '';
            } else if (key === 'Reference_Allele') {
                obj['referenceAllele'] = (val) ? val : '';
            } else if (key === 'Effect_Allele') {
                obj['effectAllele'] = (val) ? val : '';
            } else if (key === 'MOST_DEL_SCORE') {
                obj['MOST_DEL_SCORE'] = (val) ? val : '';
            } else if (key === 'dataset') {
                obj['ds'] = (val) ? val : '';
            } else if (key === 'dsr') {
                obj['dsr'] = (val) ? val : '';
            } else if (key === 'pname') {
                obj['pname'] = (val) ? val : '';
            } else if (key === 'phenotype') {
                obj['pheno'] = (val) ? val : '';
            } else if (key === 'datasetname') {
                obj['datasetname'] = (val) ? val : '';
            } else if (key === 'meaning') {
                obj['meaning'] = (val) ? val : '';
            } else if (key === 'AF') {
                obj['MAF'] = UTILS.realNumberFormatter((val) ? val : 1);
            } else if ((key === 'P_FIRTH_FE_IV') ||
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
            return obj;
        }
        _.forEach(v, procAggregatedData);
        return obj;
    };
    var refineRenderData = function (renderData, significanceLevel) {
        renderData.rvar = [];
        renderData.cvar = [];
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
        _.forEach(renderData.variants, function (v) {
            var mafValue = v['MAF']
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
        });
        // sort by P value for the high-impact variants
        var tempRVar = _.sortBy(rvart, function (o) {
            return o.P_VALUEV
        });
        // Only the first P value with each name gets in.  Since these are sorted we get all the variants with the lowest P values
        _.forEach(tempRVar,function(o){
            if (_.findIndex(renderData.rvar,function (p){return (p['id']==o['id'])})<0){
                renderData.rvar.push(o);
            }
        });
        // repeat the sorting and filtering for the common variants
        var tempCVar = _.sortBy(cvart, function (o) {
            return o.P_VALUEV
        });
        _.forEach(tempCVar,function(o){
            if (_.findIndex(renderData.cvar,function (p){return (p['id']==o['id'])})<0){
                renderData.cvar.push(o);
            }
        });
        return renderData;
    };


// public routines are declared below
    return {
        buildCommonTable:buildCommonTable,
        buildHighImpactTable:buildHighImpactTable,
        processAggregatedData:processAggregatedData,
        phenotypeNameForSampleData:phenotypeNameForSampleData,
        phenotypeNameForHailData:phenotypeNameForHailData,
        refineRenderData:refineRenderData
    }

}());

