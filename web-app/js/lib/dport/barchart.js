/***
 *               --------------Bar chart--------------
 *
 * This JavaScript file should be sufficient for creating a bar chart.
 *
 * We want to be able to handle not only individual bars but also grouped bars.  If you are
 * creating a bar group you'll need to put the grouped bars into an array inside the top level
 * objects. For each grouping provide a bar name.
 *
 * @type {baget|*|{}}
 */



var baget = baget || {};  // encapsulating variable

(function () {

    baget.barChart = function () {

//        var data = [
//                { value: 12,
//                    barname: 'Have T2D',
//                    barsubname: '(cases)',
//                    barsubnamelink:'http://www.google.com',
//                    inbar: '',
//                    descriptor: '(8 out of 6469)'},
//                {value: 33,
//                    barname: 'Do not have T2D',
//                    barsubname: '(controls)',
//                    barsubnamelink:'http://www.google.com',
//                    inbar: '',
//                    descriptor: '(21 out of 6364)'}
//            ],
//            roomForLabels = 120,
//            maximumPossibleValue = 100,
//            labelSpacer = 10;

        // public variables
        var data, // no defaults because we can't make a plot without some data to plot
            roomForLabels = 120,
            maximumPossibleValue = 100,
            labelSpacer = 10,
            integerValues = 0,// by default we show percentages, set value to one to show integers
            logXScale = 0,// by default go with a linear x axis.  Set value to 1 for log
            customBarColoring = 0,// by default don't color the bars differently.  Otherwise each one gets its own class
            selection;   // no default because we can't make a plot without a place to put it

        // private variables
        var  instance = {},
            internalMin;

        var margin = {top: 30, right: 20, bottom: 50, left: 70},
            width = 800 - margin.left - margin.right,
            height = 250 - margin.top - margin.bottom;

        instance.render = function() {
            var x, y,
                minimumValue,
                maximumValue,
                range = 0,
                vPosition;

            var chart =  selection
                .append('svg')
                .attr('class', 'chart')
                .attr('width', width*1.5)
                .attr('height', height*1.4);

            if (logXScale){
                internalMin = 1;
                x = d3.scale.log()
                    .base(10)
                    .domain([internalMin,maximumPossibleValue ])
                    .range([margin.left+roomForLabels, width+roomForLabels]);
            } else {
                internalMin = 0;
                x = d3.scale.linear()
                    .domain([0,maximumPossibleValue ])
                    .range([margin.left+roomForLabels, width+roomForLabels]);
            }

            var names=[],
                verticalPositioning = []

            data.map(function(d){
                names.push(d.barname);
                verticalPositioning.push(d.position);
            });


            /***
             * we want to be able to support either ordinal or else explicitly placed horizontal bars.  To achieve this
             * interpose an object that will either reference the ordinal scale or else the linear one with its
             * explicit positioning
             *
             * As far as bar height goes, for the explicit positioning go through and find the minimum distance between any two bars.
             * This will tell you how thin the bars have to be so that they can all fit.
             */
            if ((verticalPositioning.length >  0) &&
                ((typeof (verticalPositioning [0]) !== 'undefined') )){
                var minimumValue = Math.min.apply(null, verticalPositioning),
                    maximumValue = Math.max.apply(null, verticalPositioning),
                    range = maximumValue-minimumValue;
                if(range > 0){
                    y = d3.scale.linear()
                        .domain([0,range])
                        .range([margin.top, height]);
                    vPosition = {nameMap:{},pos:{},barHeight:{}}
                    var minspacing = 0;
                    var smallestPosition = -1;
                    // before we start assigning bars we need to know the smallest one so that everything can be offset
                    // from zero (otherwise we start with the smallest, which means we never get to the top of the graph)
                    for ( var i = 0 ; i < data.length ; i++ ) {
                        if (smallestPosition  === -1 ){
                            smallestPosition = data[i].position;
                        } else {
                            if (smallestPosition > data[i].position){
                                smallestPosition = data[i].position
                            }
                        }
                    }
                    for ( var i = 0 ; i < data.length ; i++ ){
                        vPosition.nameMap[data[i].barname] = y(data[i].position-smallestPosition)+5;
                        // look at the distance between each bar position in order to calculate bar height
                        if (i>0){
                            if (minspacing==0){
                                minspacing = data[i].position-data[i-1].position;
                            } else {
                                if ((data[i].position-data[i-1].position)< minspacing){
                                    minspacing = data[i].position-data[i-1].position;
                                }
                            }
                        }
                    }
                    vPosition.pos = function (name){
                        return vPosition.nameMap[name];
                    }
                    vPosition.barHeight = (y(minspacing)-y(0))/2;
                }
            }
            if(range == 0) {
                y = d3.scale.ordinal()
                    .domain(names)
                    .rangeBands([margin.top, height]);
                vPosition = {pos:function (name){
                    //return vPosition.pos(name);
                    return y(name) + y.rangeBand()/2;
                },
                    barHeight:y.rangeBand()/4}
            }

            var	xAxis = d3.svg.axis();

            xAxis
                .orient('bottom')
                .scale(x)
                .tickSize(2);

            if (logXScale){
                xAxis.tickValues([1,10,100,1000,10000])
            }

            var x_xis = chart.append('g')
                .attr("transform", "translate(0,"+(height+40)+")")
                .attr('class','xaxis')
                .call(xAxis);



            // the bars in the bar chart
            // special handling in case the bars have groups
            var bars = chart.selectAll("rect")
                .data(data,function(d,i){return d.barname;});

            bars.enter().append("rect")
                .attr('class',function(d,i){
                    if (customBarColoring === 1) {
                        return 'barstyling'+i;
                    }else {
                        return 'h-bar';
                    }
                })
                .attr("x", x(internalMin))
                .attr("y", function(d, i){
                    return vPosition.pos(d.barname);
                } )
                .attr("width", function(d,i){
                    return (0)
                })
                .attr("height", vPosition.barHeight);
            //           .attr("height", vPosition.barHeighty.rangeBand()/4);

            // perform the animation
            bars.transition()
                .delay(100).duration(1400)
                .attr("width", function(d,i){
                    return (x( d.value)-x(internalMin))
                });

            // get rid of any extra data in case we've done this before
            bars.exit().transition().selectAll("rect").remove();



            // these are tics, without labels
            var bar_height = 25;
            var  gap=5;

            // labels to the left
            var textLeading = (90 - (data.length*5))/100;
            chart.selectAll("text.barChartLabel")
                .data(data)
                .enter().append("text")
                .attr("x", function(d, i){
                    return margin.left+roomForLabels-labelSpacer;
                })
                .attr("y", function(d, i){
                    return vPosition.pos(d.barname);
                } )
                .attr("dy", ""+textLeading+"em")
                .attr("text-anchor", "end")
                .attr('class',function(d, i) {
                    if (typeof d.inset === 'undefined') {
                        return 'barChartLabel';
                    } else {
                        return 'rightBarChartLabel';
                    }
                })
                .text(function(d,i){return d.barname;});

            // sub labels, just below the main labels above
            chart.selectAll("text.barChartSubLabel")
                .data(data)
                .enter().append("text")
                .attr("x",  margin.left+roomForLabels-labelSpacer)
                .attr("y", function(d, i){
                    return vPosition.pos(d.barname);
                } )
                .attr("dy", ""+(1.5+textLeading)+"em")
                .attr("dx", "-1em")
                .attr("text-anchor", "end")
                .attr('class', 'barSubChartLabel')
                .text(function(d,i){return d.barsubname;});

            // labels to the right -- expected to be numeric
            chart.selectAll("text.valueLabels")
                .data(data)
                .enter().append("text")
                .attr("x", function(d){
                    return (x(d.value));
                })
                .attr("y", function(d){
                    return vPosition.pos(d.barname);
                } )
                .attr("dx", 12)
                .attr("dy", ""+textLeading+"em")
                .attr("text-anchor", "start")
                .attr('class', 'valueLabels')
                .text(function(d,i){
                    // do we format the value to the right of the bar as a percentage or an integer
                    //  one other special case: if the label is inset then don't label anything
                    if (typeof d.inset === 'undefined'){
                        if (integerValues ===  1){
                            return ""+(d.value);
                        }else {
                            return ""+(d.value).toPrecision(3)+ "%";
                        }
                    }

                });

            // labels to the right of the right hand labels
            chart.selectAll("text.valueQualifiers")
                .data(data)
                .enter().append("text")
                .attr("x", function(d){
                    return (x(d.value));
                })
                .attr("y", function(d){
                    return vPosition.pos(d.barname);
                } )
                .attr("dx", 108)
                .attr("dy", ""+textLeading+"em")
                .attr("text-anchor", "start")
                .attr('class', 'valueQualifiers')
                .text(function(d,i){return ""+d.descriptor;})


            var elem = chart.selectAll("text.clickableQuestionMark")
                .data(data);

            var elemEnter = elem
                .enter()
                .append("svg:a")
                .attr("xlink:href", function(d){return d.barsubnamelink;})
                .append("g");


//            elemEnter
//                .append("circle")
//                .attr("cx",  margin.left+roomForLabels-labelSpacer)
//                .attr("cy", function(d, i){
//                    return y(d.barname) + y.rangeBand()/2;
//                } )
//                .attr('r',8)
//                .attr("transform", function(d){return "translate(-5,29)"})
//                .attr('class', 'clickableQuestionMark')
//            ;
//            elemEnter
//                .append("text")
//                .attr("x",  margin.left+roomForLabels-labelSpacer)
//                .attr("y", function(d, i){
//                    return y(d.barname) + y.rangeBand()/2;
//                } )
//                .attr("dy", ""+(1.4+textLeading)+"em")
//                .attr("text-anchor", "end")
//                .attr('class', 'clickableQuestionMark')
//                .text("?");


        }



        // assign data to the DOM
        instance.assignData = function (x) {
            if (!arguments.length) return data;
            data = x;
            return instance;
        };

        instance.roomForLabels = function (x) {
            if (!arguments.length) return roomForLabels;
            roomForLabels = x;
            return instance;
        };

        instance.maximumPossibleValue = function (x) {
            if (!arguments.length) return maximumPossibleValue;
            maximumPossibleValue = x;
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



        instance.selectionIdentifier = function (x) {
            if (!arguments.length) return selectionIdentifier;
            selectionIdentifier = x;
            selection = d3.select(selectionIdentifier);
            return instance;
        };

        instance.clear = function(){
            selection.select('svg').remove();
            return instance;
        };

        return instance;
    };

})();