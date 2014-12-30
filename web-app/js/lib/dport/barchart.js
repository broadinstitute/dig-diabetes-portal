/***
 *               --------------Bar chart--------------
 *
 * This JavaScript file should be sufficient for creating a bar chart.
 *
 * In an effort to provide more flexibility this routine can support either an ordinal vertical
 * axis (which will space the bars out for you) or else a linear vertical axis (in which case
 * you need to provide the coordinates on the y-axis to describe where every bar goes).  I incorporated
 * this switch in order to allow for grouped bar charts.  Include a "position" field in your data
 * if you want to use the linear scaling.
 *
 */



var baget = baget || {};  // encapsulating variable

(function () {

    baget.barChart = function (barChartName) {// name is optional, but allows you to clear specifically

//
//   Here's an example of the sort of data that this routine expect
//
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
            customLegend = 0,// by default skip the legend.  Note that this legend (and legends in general) are tough to implement in a general form
            selection;   // no default because we can't make a plot without a place to put it

        // private variables
        var  instance = {},
            internalMin;

        var margin = {top: 30, right: 20, bottom: 50, left: 70},
            width = 800 - margin.left - margin.right,
            height = 250 - margin.top - margin.bottom;

        instance.render = function(currentSelection) {

            var subGroupHolder  = currentSelection.selectAll('svg.chart');
            subGroupHolder
                .each(function (data, eachGroupI) {      // d3 each: d=datum, i=index

                    var x, y,
                        minimumValue,
                        maximumValue,
                        range = 0,
                        vPosition;

                    var chart = d3.select(subGroupHolder[0][eachGroupI]);

                    if (typeof barChartName !== 'undefined') {
                        chart.attr('class', barChartName);
                    }

                    if (logXScale) {
                        internalMin = 1;
                        x = d3.scale.log()
                            .base(10)
                            .domain([internalMin, maximumPossibleValue ])
                            .range([margin.left + roomForLabels, width + roomForLabels]);
                    } else {
                        internalMin = 0;
                        x = d3.scale.linear()
                            .domain([0, maximumPossibleValue ])
                            .range([margin.left + roomForLabels, width + roomForLabels]);
                    }

                    var names = [],
                        verticalPositioning = []

                    data.map(function (d) {
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
                    if ((verticalPositioning.length > 0) &&
                        ((typeof (verticalPositioning [0]) !== 'undefined') )) {
                        var minimumValue = Math.min.apply(null, verticalPositioning),
                            maximumValue = Math.max.apply(null, verticalPositioning),
                            range = maximumValue - minimumValue;
                        if (range > 0) {
                            y = d3.scale.linear()
                                .domain([0, range])
                                .range([margin.top, height]);
                            vPosition = {nameMap: {}, pos: {}, barHeight: {}}
                            var minspacing = 0;
                            var smallestPosition = -1;
                            // before we start assigning bars we need to know the smallest one so that everything can be offset
                            // from zero (otherwise we start with the smallest, which means we never get to the top of the graph)
                            for (var i = 0; i < data.length; i++) {
                                if (smallestPosition === -1) {
                                    smallestPosition = data[i].position;
                                } else {
                                    if (smallestPosition > data[i].position) {
                                        smallestPosition = data[i].position
                                    }
                                }
                            }
                            for (var i = 0; i < data.length; i++) {
                                vPosition.nameMap[data[i].barname] = y(data[i].position - smallestPosition) + 5;
                                // look at the distance between each bar position in order to calculate bar height
                                if (i > 0) {
                                    if (minspacing == 0) {
                                        minspacing = data[i].position - data[i - 1].position;
                                    } else {
                                        if ((data[i].position - data[i - 1].position) < minspacing) {
                                            minspacing = data[i].position - data[i - 1].position;
                                        }
                                    }
                                }
                            }
                            vPosition.pos = function (name) {
                                return vPosition.nameMap[name];
                            }
                            vPosition.barHeight = (y(minspacing) - y(0)) / 2;
                        }
                    }
                    if (range == 0) {
                        y = d3.scale.ordinal()
                            .domain(names)
                            .rangeBands([margin.top, height]);
                        vPosition = {pos: function (name) {
                            //return vPosition.pos(name);
                            return y(name) + y.rangeBand() / 2;
                        },
                            barHeight: y.rangeBand() / 4}
                    }

                    var xAxis = d3.svg.axis();

                    xAxis
                        .orient('bottom')
                        .scale(x)
                        .tickSize(2);

                    if (logXScale) {
                        xAxis
                            .tickValues([1, 10, 100, 1000, 10000])
                            .tickFormat(d3.format("d"));
                    }

                    var x_xis = chart.append('g')
                        .attr("transform", "translate(0," + (height + 40) + ")")
                        .attr('class', 'xaxis')
                        .call(xAxis);


                    // the bars in the bar chart
                    // special handling in case the bars have groups
                    var bars = chart.selectAll("rect")
                        .data(data, function (d, i) {
                            return d.barname;
                        });

                    bars.enter().append("rect")
                        .attr('class', function (d, i) {
                            if (customBarColoring === 1) {
                                return 'barstyling' + i;
                            } else {
                                return 'h-bar';
                            }
                        })
                        .attr("x", x(internalMin))
                        .attr("y", function (d, i) {
                            return vPosition.pos(d.barname);
                        })
                        .attr("width", function (d, i) {
                            return (0)
                        })
                        .attr("height", vPosition.barHeight);

                    // perform the animation
                    bars.transition()
                        .delay(100).duration(1400)
                        .attr("width", function (d, i) {
                            if (typeof d.value === 'undefined') {
                                return 0;
                            } else {
                                return (x(d.value) - x(internalMin));
                            }

                        });

                    // get rid of any extra data in case we've done this before
                    bars.exit().transition().selectAll("rect").remove();


                    // these are tics, without labels
                    var bar_height = 25;
                    var gap = 5;

                    // labels to the left
                    var textLeading = (90 - (data.length * 5)) / 100;
                    chart.selectAll("text.barChartLabel")
                        .data(data)
                        .enter().append("text")
                        .attr("x", function (d, i) {
                            return margin.left + roomForLabels - labelSpacer;
                        })
                        .attr("y", function (d, i) {
                            return vPosition.pos(d.barname);
                        })
                        .attr("dy", "" + textLeading + "em")
                        .attr("text-anchor", "end")
                        .attr('class', function (d, i) {
                            if (typeof d.inset === 'undefined') {
                                return 'barChartLabel';
                            } else {
                                return 'rightBarChartLabel';
                            }
                        })
                        .text(function (d, i) {
                            return d.barname;
                        });

                    // sub labels, just below the main labels above
                    chart.selectAll("text.barChartSubLabel")
                        .data(data)
                        .enter().append("text")
                        .attr("x", margin.left + roomForLabels - labelSpacer)
                        .attr("y", function (d, i) {
                            return vPosition.pos(d.barname);
                        })
                        .attr("dy", "" + (1.5 + textLeading) + "em")
                        .attr("dx", "-1em")
                        .attr("text-anchor", "end")
                        .attr('class', 'barSubChartLabel')
                        .text(function (d, i) {
                            return d.barsubname;
                        });

                    // labels to the right -- expected to be numeric
                    chart.selectAll("text.valueLabels")
                        .data(data)
                        .enter().append("text")
                        .attr("x", function (d) {
                            if (typeof d.value !== 'undefined') {
                                return (x(d.value));
                            } else {
                                return 0;
                            }

                        })
                        .attr("y", function (d) {
                            return vPosition.pos(d.barname);
                        })
                        .attr("dx", 12)
                        .attr("dy", "" + textLeading + "em")
                        .attr("text-anchor", "start")
                        .attr('class', 'valueLabels')
                        .text(function (d, i) {
                            // do we format the value to the right of the bar as a percentage or an integer
                            //  one other special case: if the label is inset then don't label anything
                            if (typeof d.inset === 'undefined') {
                                if (typeof d.value !== 'undefined') {
                                    if (integerValues === 1) {
                                        return "" + (d.value);
                                    } else {
                                        return "" + (d.value).toPrecision(3) + "%";
                                    }
                                }
                            }

                        });

                    // labels to the right of the right hand labels
                    chart.selectAll("text.valueQualifiers")
                        .data(data)
                        .enter().append("text")
                        .attr("x", function (d) {
                            if (typeof d.value !== 'undefined') {
                                return (x(d.value));
                            } else {
                                return 0;
                            }
                        })
                        .attr("y", function (d) {
                            return vPosition.pos(d.barname);
                        })
                        .attr("dx", 108)
                        .attr("dy", "" + textLeading + "em")
                        .attr("text-anchor", "start")
                        .attr('class', 'valueQualifiers')
                        .text(function (d, i) {
                            return "" + d.descriptor;
                        })

                    if (customLegend == 1) {
                        // add legend
                        var legendPos = 565,
                            legendTextYPosition = 15,
                            spaceBetweenLegendEntries = 15,
                            spaceBetweenLegendColorAndLegendText = 30,
                            legendHolderBoxWidth = 150,
                            legendHolderBoxHeight = 80,
                            legendTitleYPositioning = 18;


                        var legend = chart.append("g")
                            .attr("class", "legendHolder")
                            .attr("x", margin.left + legendPos)
                            .attr("y", 0)
                            .attr("height", 100)
                            .attr("width", 100)
                            .attr('transform', 'translate(-20,50)');


                        legend.selectAll('rect')
                            .data([0])
                            .enter()
                            .append("rect")
                            .attr("x", margin.left + legendPos)
                            .attr("y", 0)
                            .attr("width", legendHolderBoxWidth)
                            .attr("height", legendHolderBoxHeight)
                            .attr("class", "legendHolder");

                        legend.selectAll('text')
                            .data([0])
                            .enter()
                            .append("text")
                            .attr("class", "legendTitle")
                            .attr("x", margin.left + legendPos + (legendHolderBoxWidth / 2))
                            .attr("y", legendTitleYPositioning)
                            .attr("class", "legendTitle")
                            .text('Legend');


                        legend.selectAll('rect')
                            .data(data)
                            .enter()
                            .append("rect")
                            .attr("x", margin.left + legendPos + 10)
                            .attr("y", function (d, i) {
                                return i * spaceBetweenLegendEntries + legendTextYPosition;
                            })
                            .attr("width", 10)
                            .attr("height", 10)
                            .attr("class", function (d, i) {
                                return 'legendStyling' + i;
                            })

                        legend.selectAll('text')
                            .data(data)
                            .enter()
                            .append("text")
                            .attr("x", margin.left + legendPos + spaceBetweenLegendColorAndLegendText)
                            .attr("y", function (d, i) {
                                return i * spaceBetweenLegendEntries + legendTextYPosition + 9;
                            })
                            .attr("class", "legendStyling")
                            .text(function (d) {
                                if (typeof d.legendText !== 'undefined') {
                                    return d.legendText;
                                } else {
                                    return '';
                                }
                            });
                    }

                    // This next section is necessary only if you want to include question marks
                    // that provide external HTML links.
                    var elem = chart.selectAll("text.clickableQuestionMark")
                        .data(data);

                    var elemEnter = elem
                        .enter()
                        .append("svg:a")
                        .attr("xlink:href", function (d) {
                            return d.barsubnamelink;
                        })
                        .append("g");
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
                .attr('height', height*1.4);

            return instance;
        };


        // assign data to the DOM
        instance.assignData = function (x) {
            if (!arguments.length) return data;
            // data = x;
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

        instance.customLegend = function (x) {
            if (!arguments.length) return customLegend;
            customLegend = x;
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