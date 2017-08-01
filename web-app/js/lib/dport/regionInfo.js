var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.regionInfo = (function () {

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
                var allVariants = _.flatten([{}, data.variants])
                _.forEach(allVariants, function (oneVariant){
                    var v = _.merge.apply(_,oneVariant);
                    if (typeof v.VAR_ID !== 'undefined') {
                        renderData.variants.push({name:v.VAR_ID});
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
                    var drivingVariables = buildRenderData(data);
                    $(".credibleSetTableGoesHere").empty().append(
                        Mustache.render( $('#credibleSetTableTemplate')[0].innerHTML,drivingVariables)
                    );
                    mpgSoftware.geneSignalSummaryMethods.updateCredibleSetTable(data, additionalParameters);
                }
            );
            promise.fail(function( jqXHR, textStatus, errorThrown ) {
                console.log('error');
            });

        }

        return { fillRegionInfoTable: fillRegionInfoTable}

    })();



})();
