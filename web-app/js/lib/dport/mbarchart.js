/***
 *               --------------Bar chart--------------
 *
 * This JavaScript file should be sufficient for creating a bar chart.
 *
 *
 */



var baget = baget || {};  // encapsulating variable

(function () {

    baget.mBar = function (barChartName) {// name is optional, but allows you to clear specifically


        // public variables
        var data, // no defaults because we can't make a plot without some data to plot
            showGridLines = true,
            blackTextAfterBar = false,
            labelSpacer = 10,
            spaceForYAxisLabels = 50,
            valueAccessor = function (x){return x.value},
            colorAccessor = function (x){return x.color},
            categoryAccessor = function (x){return x.category},
            staticBarSize = false,// if true then obey the default for barHeight.  Otherwise calculate this value dynamically.
            integerValues = 0,// by default we show percentages, set value to one to show integers
            logXScale = 0,// by default go with a linear x axis.  Set value to 1 for log
            customBarColoring = 0,// by default don't color the bars differently.  Otherwise each one gets its own class
            customLegend = 0,// by default skip the legend.  Note that this legend (and legends in general) are tough to implement in a general form
            minimumXValue = 0,// by default treat access if it must be nonnegative
            selection;   // no default because we can't make a plot without a place to put it

        // private variables (which serve as constants
        var  instance = {},
            internalMin,
            barHeight = 60,
            expansionPercentage = 20,
            numberOfGridlines = 10,
            textLabelLengthFromEnd =10,
            verticalSpaceForXAxis =20,
            disambiguator='';

        var margin = {top: 30, right: 20, bottom: 50, left: 70},
            width = 800 - margin.left - margin.right,
            height = 500 - margin.top - margin.bottom;

        instance.render = function(currentSelection) {

            var subGroupHolder  = currentSelection.selectAll('svg.chart');
            subGroupHolder
                .each(function (data, eachGroupI) {      // d3 each: d=datum, i=index

                    var categories= [];
                    var values = [];
                    var colors = [];
                    var minimum;
                    var maximum;

                    data.map(function(d,i){
                        categories.push(categoryAccessor(d));
                        values.push(valueAccessor(d));
                        colors.push(colorAccessor(d));
                    });

                    // we will need these for scaling
                    minimum = d3.min(values) ;
                    maximum = d3.max(values) ;


                    // let's calculate the domain and range. The only thing tricky is that we want to go a little below the minimum
                    //  and above the maximum, sso we will need to calculate a range, then increase it by a percentage.  Use an
                    //  immediately executed function to avoid leaving some local variables hanging around. Also, create some allowance
                    //  for values with zero variance.
                    var xscale;
                    var expandedRange;
                    (function(){
                        expandedRange = [];
                        if (minimum === maximum) {
                            if (minimum === 0){  // can't really do much in a case like this, since every value is zero.
                                expandedRange.push (0);
                                expandedRange.push (1);
                            }  else {   // no variance, but create a chart anyway. No expansion of range necessary
                                expandedRange.push (0);
                                var rangeExpansion = ((minimum)*expansionPercentage)/(100) ;
                                expandedRange.push (minimum+rangeExpansion);
                            }
                        }  else {
                            var rangeExpansion = ((maximum-minimum)*expansionPercentage)/(100) ;
//                            expandedRange.push (d3.max ([0,minimum-rangeExpansion]));
//                            expandedRange.push (maximum + rangeExpansion);
                  //          expandedRange.push (d3.max ([0,minimum-(((minimum)*expansionPercentage)/(100))]));
                            expandedRange.push (0);
                            expandedRange.push (maximum + (((maximum)*expansionPercentage)/(100)));
                        }
                        xscale = d3.scale.linear()
                            .domain(expandedRange)
                            .range([margin.left+spaceForYAxisLabels,width-(margin.right+margin.left+spaceForYAxisLabels)]);
                    }());

                    var grid = d3.range(numberOfGridlines).map(function(i){
                        return {'x1':margin.left+spaceForYAxisLabels,'y1':margin.top,'x2':margin.left,'y2':height-margin.bottom};
                    });

                    var tickVals = grid.map(function(d,i){
                             return xscale(expandedRange[0]+(i*((expandedRange[1]-expandedRange[0])/numberOfGridlines)));
                    });


                    var yscale = d3.scale.linear()
                        .domain([0,categories.length])
                        .range([margin.top,height-margin.bottom]);

                    var colorScale = d3.scale.quantize()
                        .domain([0,categories.length])
                        .range(colors);

                    var canvas = selection
                        .append('svg')
                        .attr({'width':width,'height':height+margin.top+margin.bottom+verticalSpaceForXAxis});

                    if (showGridLines=== true)  {
                        canvas.append('g')
                            .attr('id','grid'+disambiguator)
                            .attr('transform','translate('+margin.left+spaceForYAxisLabels+',0)')
                            .selectAll('line')
                            .data(grid)
                            .enter()
                            .append('line')
                            .attr({'x1':function(d,i){ return tickVals[i]; },
                                'y1':function(d){ return d.y1+margin.top; },
                                'x2':function(d,i){ return tickVals[i]; },
                                'y2':function(d){ return d.y2+margin.top; }
                            })
                            .style({'stroke':'#adadad','stroke-width':'1px'});
                    }

                    // horizontal axis
                    var	xAxis = d3.svg.axis();
                    xAxis
                        .orient('bottom')
                        .scale(xscale)
//                        .tickValues([0,100,200,260]);
//                        .tickFormat(function(d,i){
//                            return d;
//                        });


                    // unless we have been requested to hold the bar size constant, pick a nice value based on the amount
                    // of vertical space we have to work with
                    if (!staticBarSize){
                        barHeight = (height-margin.top-margin.bottom)/(categories.length+1);
                    }


                    // vertical axis
                    var	yAxis = d3.svg.axis();
                    yAxis
                        .orient('left')
                        .scale(yscale)
                        .tickSize(2)
                        .tickFormat(function(d,i){ return categories[i]; })
                        .tickValues(d3.range(categories.length));

                    canvas.append('g')
                        .attr("transform", "translate("+((margin.left+spaceForYAxisLabels)*2)+","+(margin.top+(barHeight/2))+")")
                        .attr('id','yaxis_'+disambiguator)
                        .call(yAxis)
                        .call(function(me){
                            me.selectAll('.domain').style('display','none');
                        });


                    canvas.append('g')
                        .attr("transform", "translate("+(margin.left+spaceForYAxisLabels)+","+(margin.top+height)+")")
                        .attr('id','xaxis_'+disambiguator)
                        .call(xAxis)
                        .call(function(me){
                            me.selectAll('.domain').style('display','none');
                        });


                    // create each bar
                    canvas.append('g')
                        .attr("transform", "translate("+(margin.left+spaceForYAxisLabels)+","+margin.top+")")
                        .attr('id','bars'+disambiguator)
                        .selectAll('rect')
                        .data(values)
                        .enter()
                        .append('rect')
                        .attr('height',barHeight)
                        .attr({'x':xscale(minimumXValue),'y':function(d,i){ return (yscale(i)); }})
                        .style('fill',function(d,i){ return colorScale(i); })
                        .attr('width',function(d){
                            return xscale(minimumXValue)-xscale(minimumXValue);
                        });

                    // give the bar length
                    d3.select("#bars"+disambiguator).selectAll('rect')
                        .data(values)
                        .transition()
                        .duration(1000)
                        .attr("width", function(d) {
                            return xscale(d)-xscale(minimumXValue);
                        });

                    // label on bar
                  //  d3.select('#bars')
                    d3.select("#bars"+disambiguator)
                        .selectAll('text')
                        .data(values)
                        .enter()
                        .append('text')
                        .text(function(d){ return d; })
                        .style('fill',function(d){
                            if (blackTextAfterBar){
                                return '#000';
                            } else {
                                return '#fff';
                            }
                        })
                        .style('font-size','14px')
                        .attr('class',function(d,i){
                            return 'barlabel'+i;
                        })
                        .attr({'x':
                            function(d,i) {
                                var textElement = d3.select('.barlabel'+i);
                                var textLength = textElement.node().getComputedTextLength()+textLabelLengthFromEnd;
                                if (blackTextAfterBar){
                                    return xscale(d)+textLabelLengthFromEnd;
                                } else {
                                    return xscale(d)-textLength;
                                }
                            },
                            'y':
                                function(d,i){
                                    return yscale(i)+(barHeight/2)+4;
                                }}) ;



                });

        }



        instance.dataHanger = function (selectionIdentifier, data) {

            selection = d3.select(selectionIdentifier)
                .selectAll('svg.chart')
                .data([data])
                .enter()
                .append('svg')
                .attr('class', 'chart')
                .attr('width', width*1.5)
                .attr('height', height+margin.top+margin.bottom);
            disambiguator = selectionIdentifier.substring(1); // make unique IDs
            return instance;
        };


        // assign data to the DOM
        instance.assignData = function (x) {
            if (!arguments.length) return data;
           // data = x;
            return instance;
        };

        instance.showGridLines = function (x) {
            if (!arguments.length) return showGridLines;
            showGridLines = x;
            return instance;
        };

        instance.blackTextAfterBar = function (x) {
            if (!arguments.length) return blackTextAfterBar;
            blackTextAfterBar = x;
            return instance;
        };

        instance.spaceForYAxisLabels = function (x) {
            if (!arguments.length) return spaceForYAxisLabels;
            spaceForYAxisLabels = x;
            return instance;
        };

        instance.labelSpacer = function (x) {
            if (!arguments.length) return labelSpacer;
            labelSpacer = x;
            return instance;
        };

        instance.margin = function (x) {
            if (!arguments.length) return margin;
            margin = x;
            return instance;
        };

        instance.width = function (x) {
            if (!arguments.length) return width;
            width = x;
            return instance;
        };

        instance.height = function (x) {
            if (!arguments.length) return height;
            height = x;
            return instance;
        };

        instance.integerValues = function (x) {
            if (!arguments.length) return integerValues;
            integerValues = x;
            return instance;
        };

        instance.logXScale = function (x) {
            if (!arguments.length) return logXScale;
            logXScale = x;
            return instance;
        };

        instance.customBarColoring = function (x) {
            if (!arguments.length) return customBarColoring;
            customBarColoring = x;
            return instance;
        };

        instance.customLegend = function (x) {
            if (!arguments.length) return customLegend;
            customLegend = x;
            return instance;
        };

        instance.valueAccessor = function (x) {
            if (!arguments.length) return valueAccessor;
            valueAccessor = x;
            return instance;
        };

        instance.colorAccessor = function (x) {
            if (!arguments.length) return colorAccessor;
            colorAccessor = x;
            return instance;
        };

        instance.categoryAccessor = function (x) {
            if (!arguments.length) return categoryAccessor;
            categoryAccessor = x;
            return instance;
        };

        instance.selectionIdentifier = function (x) {
            if (!arguments.length) return selectionIdentifier;
            selectionIdentifier = x;
            selection = d3.select(selectionIdentifier);
            return instance;
        };

        instance.clear = function(barChartName){ // if there is a name then only clear the svg with that class
            if (typeof barChartName === 'undefined') {
                d3.select('svg').remove();
            } else {
                d3.select('svg.'+barChartName).remove();
            }

            return instance;
        };

        return instance;
    };

})();