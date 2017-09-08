var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.regionInfo = (function () {

        var developingTissueGrid = {};
        var getDevelopingTissueGrid = function (){
            return developingTissueGrid;
        };
        var setDevelopingTissueGrid = function (myDevelopingTissueGrid){
            developingTissueGrid = myDevelopingTissueGrid;
        };

        var buildRenderData = function (data){
            var renderData = {  variants: [],
                                const:{
                                    coding:[],
                                    spliceSite:[],
                                    utr:[],
                                    promoter:[],
                                    CTCFmotif:[]
                                },
                                cellTypeSpecs: [
                                    // {name:'Aorta',
                                    // DHS:[],
                                    // K27:[]}
                                ]};
            if (typeof data !== 'undefined'){
                var allVariants = _.flatten([{}, data.variants]);
                var flattendVariants = _.map(allVariants,function(o){return  _.merge.apply(_,o)});
                _.forEach(flattendVariants.sort(function (a, b) {return a.POS - b.POS;}), function (v){
                    var posteriorProbability = "";
                    _.forEach(v.POSTERIOR_PROBABILITY, function (ppvalue){
                        _.forEach(ppvalue,function (phenotype){
                            posteriorProbability=phenotype;
                        })
                    });
                    v['extractedPOSTERIOR_PROBABILITY'] = posteriorProbability;
                    if (typeof v.VAR_ID !== 'undefined') {
                        renderData.variants.push({name:v.VAR_ID, details:v});
                    }
                    if (typeof v.MOST_DEL_SCORE !== 'undefined') {
                        if ((v.MOST_DEL_SCORE > 0)&&(v.MOST_DEL_SCORE < 4)){
                            renderData.const.coding.push({val:'',descr:'present'});
                        } else {
                            renderData.const.coding.push({val:'',descr:'absent'});
                        }
                    }
                    if (typeof v.Consequence !== 'undefined'){
                        if (v.Consequence.indexOf('splice')>-1){
                            renderData.const.spliceSite.push({val:'',descr:'present'});
                        } else {
                            renderData.const.spliceSite.push({val:'',descr:'absent'});
                        }
                        if (v.Consequence.indexOf('UTR')>-1){
                            renderData.const.utr.push({val:'',descr:'present'});
                        } else {
                            renderData.const.utr.push({val:'',descr:'absent'});
                        }
                        if (v.Consequence.indexOf('promoter')>-1){
                            renderData.const.promoter.push({val:'',descr:'present'});
                        } else {
                            renderData.const.promoter.push({val:'',descr:'absent'});
                        }
                        renderData.const.CTCFmotif.push({val:'',descr:'absent'});
                    }
                });
            }

            return renderData;
        };

        var oneCallbackForEachVariant = function(variants,additionalData){
            var promiseArray = [];
            _.forEach(variants,function (variant){
                var args = _.flatten([{}, variant]);
                var variantObject = _.merge.apply(_, args);
                promiseArray.push(
                    $.ajax({
                    cache: false,
                    type: "post",
                    url: additionalData.retrieveFunctionalDataAjaxUrl,
                    data: {
                        chromosome: variantObject.CHROM,
                        startPos: ""+variantObject.POS,
                        endPos: ""+variantObject.POS,
                        lzFormat:0,
                        assayIdList:""+additionalData.assayIdList
                    },
                    async: true
                    }).done(function (data, textStatus, jqXHR) {
                        var tissueGrid = getDevelopingTissueGrid();
                        if ((typeof data !== 'undefined') &&
                            (typeof data.variants !== 'undefined') &&
                            (typeof data.variants.region_start !== 'undefined')&&
                            (typeof data.variants.variants !== 'undefined')) {
                            _.forEach(data.variants.variants, function (record){
                                if(typeof tissueGrid[record.source_trans] === 'undefined') {
                                    tissueGrid[record.source_trans] = {};
                                }
                                var tissueRow = tissueGrid[record.source_trans];
                                if(typeof tissueRow[''+data.variants.region_start] === 'undefined') {
                                    tissueRow[''+data.variants.region_start] = record;
                                }
                            });
                        }

                    }).fail(function (jqXHR, textStatus, errorThrown) {
                        loading.hide();
                        core.errorReporter(jqXHR, errorThrown)
                    })
                );


            });
            return promiseArray;
        }

        var fillRegionInfoTable = function(vars,additionalParameters) {

            var promise = $.ajax({
                cache: false,
                type: "post",
                url: vars.fillCredibleSetTableUrl,
                data: vars,
                async: true
            });
            promise.done(
                function (data) {
                    // var allVariants = _.flatten([{}, data.variants]);
                    // var flattendVariants = _.map(allVariants,function(o){return  _.merge.apply(_,o)});
                    // var sortedVariants = flattendVariants.sort(function (a, b) {return a.POS - b.POS;});
                    var drivingVariables = buildRenderData(data);
                    $(".credibleSetTableGoesHere").empty().append(
                        Mustache.render( $('#credibleSetTableTemplate')[0].innerHTML,drivingVariables)
                    );
                    mpgSoftware.geneSignalSummaryMethods.updateCredibleSetTable(data, additionalParameters);
                    additionalParameters.assayIdList = "[1,2]";
                    var promises = oneCallbackForEachVariant(data.variants,additionalParameters);

                    $.when.apply($, promises).then(function(schemas) {
                        console.log("DONE with "+getDevelopingTissueGrid(), this, schemas);
                        var tissueGrid = getDevelopingTissueGrid();
                        // convert to an array for sorting
                        var sortableTissueArray = [];
                        _.forEach(Object.keys(tissueGrid),function(tissueKey){
                            sortableTissueArray.push(tissueGrid[tissueKey]);
                        });
                        var everySingleValue = [];
                        var sortedArrayOfArrays = _.sortBy(sortableTissueArray, function(objArray){
                            var bestVariantPerTissue = _.sortBy(objArray, function(singleVariant){
                                var oneValue = singleVariant.VALUE;
                                everySingleValue.push(oneValue);
                                return oneValue;
                            }).reverse()[0];
                            return bestVariantPerTissue.VALUE
                        });
                        var sortedTissues = _.map(sortedArrayOfArrays, function(oneRec){return oneRec[Object.keys(oneRec)[0]].source_trans});
                        var everySingleValueSorted = everySingleValue.sort(function(a,b){return a-b});
                        var maximumValue = everySingleValueSorted[everySingleValueSorted.length-1];
                        var minimumValue = everySingleValueSorted[0];
                        var quantileArray = [];
                        var numberOfQuantiles =5;
                        var widthOfOneQuintile = (maximumValue-minimumValue)/numberOfQuantiles;
                        for ( var i = 0 ; i < numberOfQuantiles ; i++ ){
                            quantileArray.push({min:minimumValue+(widthOfOneQuintile*i),max:minimumValue+(widthOfOneQuintile*(i+1))});
                        }
                        var determineColorIndex = function (val,quantileArray){
                            var index = 0;
                            while (index<quantileArray.length&& val>quantileArray[index].min){index++};
                            return index;
                        };

                        var allVariants = _.flatten([{}, data.variants]);
                        var flattendVariants = _.map(allVariants,function(o){return  _.merge.apply(_,o)});
                        var sortedVariants = flattendVariants.sort(function (a, b) {return a.POS - b.POS;});

                        _.forEach(sortedTissues,function(tissueKey){
                            var lineToAdd = "<tr><td></td><td>"+tissueKey+"</td>";
                            _.forEach(sortedVariants,function(variantRec){
                                if (typeof variantRec.POS !== 'undefined'){
                                    var positionString = ""+variantRec.POS;
                                    var record = tissueGrid[tissueKey][positionString];
                                    var worthIncluding = false;
                                    if ((typeof record !== 'undefined') && (typeof record.source_trans !== 'undefined') && (record.source_trans !== null)){
                                        var elementName = record.source_trans;
                                        lineToAdd += ("<td class='tissueTable matchingRegion"+record.ASSAY_ID + "_" +determineColorIndex(record.VALUE,quantileArray)+" "+elementName+"' data-toggle='tooltip' title='chromosome:"+ record.CHROM +
                                            ", position:"+ positionString +", tissue:"+ record.source_trans +"'></td>");

                                    } else {
                                        lineToAdd += ("<td class='tissueTable "+elementName+"'></td>");

                                    }
                                }

                            });
                            lineToAdd += '</tr>';

                            $('.credibleSetTableGoesHere tr:last').parent().append(lineToAdd);



                        });

                        setDevelopingTissueGrid({});
                    }, function(e) {
                        console.log("My ajax failed");
                    });
                    $('#toggleVarianceTableLink').click();
                    $('.credibleSetTableGoesHere td.tissueTable').popover({
                        html : true,
                        title: function() {
                            //return $(this).parent().find('.head').html();
                            console.log('title');
                            return "foo";
                        },
                        content: function() {
                            //return $(this).parent().find('.content').html();
                            return "fii";
                        },
                        container: 'body',
                        placement: 'bottom',
                        trigger: 'hover'
                    });
                    $('.credibleSetTableGoesHere th.niceHeaders').popover({
                        html : true,
                        title: function() {
                            var var_id = $(this).attr('chrom')+":"+$(this).attr('position')+"_"+$(this).attr('defrefa')+"/"+$(this).attr('defeffa');
                            return var_id;
                        },
                        content: function() {
                            var retString = "<div class='credSetLine'><scan class='credSetPopUpTitle'>Posterior probability:&nbsp;</scan><scan class='credSetPopUpValue'>"+$(this).attr('postprob')+"</scan></div>"+
                                "<div class='credSetLine'><scan class='credSetPopUpTitle'>Reference Allele:&nbsp;</scan><scan class='credSetPopUpValue'>"+$(this).attr('defrefa')+"</scan></div>"+
                                "<div class='credSetLine'><a onclick='mpgSoftware.locusZoom.replaceTissuesWithOverlappingEnhancersFromVarId(\""+
                                $(this).attr('chrom')+"_"+$(this).attr('position')+"_"+$(this).attr('defrefa')+"_"+$(this).attr('defeffa')+"\")' href='#'>"+
                                "Tissues with overlapping enhancer regions</a></div>";
                            if (additionalParameters.portalTypeString==='ibd'){
                                "<div class='credSetLine'><scan class='credSetPopUpTitle'>Posterior probability:&nbsp;</scan><scan class='credSetPopUpValue'>"+$(this).attr('postprob')+"</scan></div>"+
                                "<div class='credSetLine'><scan class='credSetPopUpTitle'>Reference Allele:&nbsp;</scan><scan class='credSetPopUpValue'>"+$(this).attr('defrefa')+"</scan></div>"+
                                "<div class='credSetLine'><a onclick='mpgSoftware.locusZoom.:replaceTissuesWithOverlappingIbdRegionsVarId(\""+
                                $(this).attr('chrom')+"_"+$(this).attr('position')+"_"+$(this).attr('defrefa')+"_"+$(this).attr('defeffa')+"\",\"#lz-lzCredSet\")' href='#'>"+
                                "Tissues with overlapping enhancer regions</a></div>";
                            }
                            return retString;
                        },
                        container: 'body',
                        placement: 'left',
                        trigger: 'click focus'
                    });
                }
            );
            promise.fail(function( jqXHR, textStatus, errorThrown ) {
                console.log('error');
            });

        }

        return { fillRegionInfoTable: fillRegionInfoTable}

    })();



})();
