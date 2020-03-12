var mpgSoftware = mpgSoftware || {};




mpgSoftware.dynaLineLauncher = (function () {

    const priorAllelicVariance =  0.042;

    var widthAdjuster = function ()  {
        var returnValue;
        var browserWidth =   $(window).width();
        returnValue = (browserWidth > 200) ?  browserWidth : 200;
        returnValue = (returnValue < 1000) ?  returnValue : 1000;
        return   returnValue;
    }
    var heightAdjuster = function ()  {
        var returnValue;
        var browserHeight =   $(window).height()-3200;
        returnValue = (browserHeight > 300) ?  browserHeight : 350;
        returnValue = (returnValue < 1000) ?  returnValue : 1000;
        return   returnValue;
    }


    var margin = {top: 30, right: 20, bottom: 50, left: 70},
        width = 800 - margin.left - margin.right,
        height = 600 - margin.top - margin.bottom,
        sliderOnScreenTop = 10,
        sliderOnScreenBottom = 200;


    var qqPlot;

    var width = 960,
        height = 500;

    var chart = d3.select("#manhattanPlot1")
        .attr("width", width)
        .attr("height", height);


    var addMoreData = function (d3Object) {

        d3.json("${createLink(controller: 'man', action:'manData3')}", function (error, data) {

            d3Object.dataAppender("#manhattanPlot1",data)
                .overrideYMinimum (0)
                .overrideYMaximum (10) ;

            d3.select("#manhattanPlot1").call(d3Object.render);

        });
    };

    const priorPosteriorArray = function(beta,se, priorAllelicVariance){
        const variance = se*se;
        const multiplier =  Math.sqrt(variance / (variance+priorAllelicVariance));
        const numerator = priorAllelicVariance*beta*beta;
        const denominator = (2*variance)*(variance+priorAllelicVariance);
        const bayesFactor = multiplier * Math.exp(numerator/denominator);
        const rangeOfPossiblePriors = _.map(_.range(101),function(rangeElement){return rangeElement/100.0});
        return _.map(rangeOfPossiblePriors,function(prior){
            let posterior;
            if (prior<1) {
                const po = (prior/(1-prior))*bayesFactor;
                posterior = po/(1+po);
            } else {
                posterior = 1;
            }
            po = (prior/(1-prior))*bayesFactor;
            return {x:prior,
                y:posterior,
                name:'',
                orient:'bottom'};
        });
    }



    const prepareDisplay = function(dataUrl, geneName,priorAllelicVarianceVar, window){
        try{
            const geneNameUpperCase = geneName.toUpperCase();
            var promise =  $.ajax({
                cache: false,
                type: "post",
                url: dataUrl,
                data: { gene: geneNameUpperCase },
                async: true
            });
            const priorAllelicVariance = priorAllelicVarianceVar || 0.0462;
            promise.done(
                function (dataForGene) {
                    const numericSE = parseFloat(dataForGene.se);
                    const numericBeta = parseFloat(dataForGene.beta);
                    const numericpValue = parseFloat(dataForGene.pValue);
                    const arrayOfPlotElements = priorPosteriorArray(numericBeta,numericSE,priorAllelicVariance)
                    var dynaline = baget.dynamicLine.buildDynamicLinePlot(arrayOfPlotElements,geneNameUpperCase,priorAllelicVariance,dataForGene);
                    d3.select(window).on('resize', baget.dynamicLine.resize);
                }

            );

        } catch(e){
            console.log('f');
        }
    }


// public routines are declared below
    return {
        prepareDisplay:prepareDisplay
    }

}());

