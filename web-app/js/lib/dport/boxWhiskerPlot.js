
// d3.tip
// Copyright (c) 2013 Justin Palmer
//
// Tooltips for d3.js SVG visualizations

// this library is initialized elsewhere properly through grails resources.  Yet I find that I am forced to initialize it again
//  if LZ is running on the same page.  I'm not sure why, but we have some sort of conflict.
immedTip = function(){
    (function (root, factory) {
        if (typeof define === 'function' && define.amd) {
            // AMD. Register as an anonymous module with d3 as a dependency.
            define(['d3'], factory)
        } else {
            // Browser global.
            root.d3.tip = factory(root.d3)
        }
    }(this, function (d3) {

        // Public - contructs a new tooltip
        //
        // Returns a tip
        return function() {
            var direction = d3_tip_direction,
                offset    = d3_tip_offset,
                html      = d3_tip_html,
                node      = initNode(),
                svg       = null,
                point     = null,
                target    = null

            function tip(vis) {
                svg = getSVGNode(vis)
                point = svg.createSVGPoint()
                document.body.appendChild(node)
            }

            // Public - show the tooltip on the screen
            //
            // Returns a tip
            tip.show = function() {
                var args = Array.prototype.slice.call(arguments)
                if(args[args.length - 1] instanceof SVGElement) target = args.pop()

                var content = html.apply(this, args),
                    poffset = offset.apply(this, args),
                    dir     = direction.apply(this, args),
                    nodel   = d3.select(node),
                    i       = directions.length,
                    coords,
                    scrollTop  = document.documentElement.scrollTop || document.body.scrollTop,
                    scrollLeft = document.documentElement.scrollLeft || document.body.scrollLeft

                nodel.html(content)
                    .style({ opacity: 1, 'pointer-events': 'all' })

                while(i--) nodel.classed(directions[i], false)
                coords = direction_callbacks.get(dir).apply(this)
                nodel.classed(dir, true).style({
                    top: (coords.top +  poffset[0]) + scrollTop + 'px',
                    left: (coords.left + poffset[1]) + scrollLeft + 'px'
                })

                return tip
            }

            // Public - hide the tooltip
            //
            // Returns a tip
            tip.hide = function() {
                nodel = d3.select(node)
                nodel.style({ opacity: 0, 'pointer-events': 'none' })
                return tip
            }

            // Public: Proxy attr calls to the d3 tip container.  Sets or gets attribute value.
            //
            // n - name of the attribute
            // v - value of the attribute
            //
            // Returns tip or attribute value
            tip.attr = function(n, v) {
                if (arguments.length < 2 && typeof n === 'string') {
                    return d3.select(node).attr(n)
                } else {
                    var args =  Array.prototype.slice.call(arguments)
                    d3.selection.prototype.attr.apply(d3.select(node), args)
                }

                return tip
            }

            // Public: Proxy style calls to the d3 tip container.  Sets or gets a style value.
            //
            // n - name of the property
            // v - value of the property
            //
            // Returns tip or style property value
            tip.style = function(n, v) {
                if (arguments.length < 2 && typeof n === 'string') {
                    return d3.select(node).style(n)
                } else {
                    var args =  Array.prototype.slice.call(arguments)
                    d3.selection.prototype.style.apply(d3.select(node), args)
                }

                return tip
            }

            // Public: Set or get the direction of the tooltip
            //
            // v - One of n(north), s(south), e(east), or w(west), nw(northwest),
            //     sw(southwest), ne(northeast) or se(southeast)
            //
            // Returns tip or direction
            tip.direction = function(v) {
                if (!arguments.length) return direction
                direction = v == null ? v : d3.functor(v)

                return tip
            }

            // Public: Sets or gets the offset of the tip
            //
            // v - Array of [x, y] offset
            //
            // Returns offset or
            tip.offset = function(v) {
                if (!arguments.length) return offset
                offset = v == null ? v : d3.functor(v)

                return tip
            }

            // Public: sets or gets the html value of the tooltip
            //
            // v - String value of the tip
            //
            // Returns html value or tip
            tip.html = function(v) {
                if (!arguments.length) return html
                html = v == null ? v : d3.functor(v)

                return tip
            }

            function d3_tip_direction() { return 'n' }
            function d3_tip_offset() { return [0, 0] }
            function d3_tip_html() { return ' ' }

            var direction_callbacks = d3.map({
                    n:  direction_n,
                    s:  direction_s,
                    e:  direction_e,
                    w:  direction_w,
                    nw: direction_nw,
                    ne: direction_ne,
                    sw: direction_sw,
                    se: direction_se
                }),

                directions = direction_callbacks.keys()

            function direction_n() {
                var bbox = getScreenBBox()
                return {
                    top:  bbox.n.y - node.offsetHeight,
                    left: bbox.n.x - node.offsetWidth / 2
                }
            }

            function direction_s() {
                var bbox = getScreenBBox()
                return {
                    top:  bbox.s.y,
                    left: bbox.s.x - node.offsetWidth / 2
                }
            }

            function direction_e() {
                var bbox = getScreenBBox()
                return {
                    top:  bbox.e.y - node.offsetHeight / 2,
                    left: bbox.e.x
                }
            }

            function direction_w() {
                var bbox = getScreenBBox()
                return {
                    top:  bbox.w.y - node.offsetHeight / 2,
                    left: bbox.w.x - node.offsetWidth
                }
            }

            function direction_nw() {
                var bbox = getScreenBBox()
                return {
                    top:  bbox.nw.y - node.offsetHeight,
                    left: bbox.nw.x - node.offsetWidth
                }
            }

            function direction_ne() {
                var bbox = getScreenBBox()
                return {
                    top:  bbox.ne.y - node.offsetHeight,
                    left: bbox.ne.x
                }
            }

            function direction_sw() {
                var bbox = getScreenBBox()
                return {
                    top:  bbox.sw.y,
                    left: bbox.sw.x - node.offsetWidth
                }
            }

            function direction_se() {
                var bbox = getScreenBBox()
                return {
                    top:  bbox.se.y,
                    left: bbox.e.x
                }
            }

            function initNode() {
                var node = d3.select(document.createElement('div'))
                node.style({
                    position: 'absolute',
                    top: 0,
                    opacity: 0,
                    'pointer-events': 'none',
                    'box-sizing': 'border-box'
                })

                return node.node()
            }

            function getSVGNode(el) {
                el = el.node()
                if(el.tagName.toLowerCase() == 'svg')
                    return el

                return el.ownerSVGElement
            }

            // Private - gets the screen coordinates of a shape
            //
            // Given a shape on the screen, will return an SVGPoint for the directions
            // n(north), s(south), e(east), w(west), ne(northeast), se(southeast), nw(northwest),
            // sw(southwest).
            //
            //    +-+-+
            //    |   |
            //    +   +
            //    |   |
            //    +-+-+
            //
            // Returns an Object {n, s, e, w, nw, sw, ne, se}
            function getScreenBBox() {
                var targetel   = target || d3.event.target,
                    bbox       = {},
                    matrix     = targetel.getScreenCTM(),
                    tbbox      = targetel.getBBox(),
                    width      = tbbox.width,
                    height     = tbbox.height,
                    x          = tbbox.x,
                    y          = tbbox.y

                point.x = x
                point.y = y
                bbox.nw = point.matrixTransform(matrix)
                point.x += width
                bbox.ne = point.matrixTransform(matrix)
                point.y += height
                bbox.se = point.matrixTransform(matrix)
                point.x -= width
                bbox.sw = point.matrixTransform(matrix)
                point.y -= height / 2
                bbox.w  = point.matrixTransform(matrix)
                point.x += width
                bbox.e = point.matrixTransform(matrix)
                point.x -= width / 2
                point.y -= height / 2
                bbox.n = point.matrixTransform(matrix)
                point.y += height
                bbox.s = point.matrixTransform(matrix)

                return bbox
            }

            return tip
        };

    }));

};


var baget = baget || {};

(function () {
    "use strict";

    baget.boxWhiskerPlot = function () {

        /***
         * Publicly accessible data goes here
         */
        var  instance = {},  // null object around which we will build the boxWhiskerPlot iinstance
            boxWhiskerData,  // All the points the box whisker plot represents ( outliers or boxed )
            selectionIdentifier = '', // String defining Dom element where the plot will hang
            selection = {}, // DOM element inside D3 wrapper
            min = Infinity,  // min y value.  Autoscale if not set
            max = -Infinity,  // max y value.  Autoscale if not set
            whiskers = function (d) { return [0, d.length - 1]; }, // function to set the whiskers
            outlierRadius = 2,  // size of outlier dots on screen
            histogramBarMultiplier = 0.9,  // how big should we make the bars on the histogram? 0 implies no display
            boxAndWhiskerWidthMultiplier = 1,  // how big should we make the bars on the histogram? 0 implies no display
            explicitlySpecifiedHistogram, // if anything other than undefined then try to set the horizontal bars explicitly, rather than calculating a histogram of the data
            leftShiftPlotWithinAxes = 0,
            tooltipTextFunction = function(nodeData){
                var valueToDisplay = nodeData.v;
                if ($.isNumeric(valueToDisplay)){
                    return "<span> value: " + valueToDisplay.toPrecision(3) + "</span>";
                } else {
                    return "<span>" + valueToDisplay + "</span>";
                }

            },

        // Private variables, which can be surfaced as necessary
            duration = 500,  // How many milliseconds to animations require
            quartiles = UTILS.boxQuartiles, // function describing how quartiles are calculated
            value = Number,
            tickFormat = null,

        // these sizes referred to each individual bar in the bar whisker plot
            margin = {top: 50, right: 70, bottom: 20, left: 80},
            width = 350 - margin.left - margin.right,
            height = 500 - margin.top - margin.bottom;


        /***
         *  jitter module provides an offset so that points that would be near
         *  to one another along the y-axis are offset in the x-axis to keep
         *  points from overlaying one another
         *
         *  Assumption: this method requires the data to be monotonic in descending order
         */
        var jitter = (function () {
            var lastX = null,
                lastY = null,
                centralXPosition = null,
                lastAxialPoint = null,
                shiftLeftNext = true,
                currentX = 0,

                determinePositioning = function (xValue, yValue) {
                    if ((lastX === null) && (lastY === null)) {  // this is our first time through
                        lastX = 0;
                        centralXPosition = xValue;
                        lastAxialPoint = yValue;
                        lastY = yValue;
                        shiftLeftNext = true;
                    }
                    else {  // this is not our first time
                        if (yValue > (lastAxialPoint - (2 * outlierRadius))) { // potential overlap. Shift it.
                            if (shiftLeftNext) {    // let's shift to the left.  expand on left shifts only
                                if (lastX < 0) {
                                    lastX = (0 - lastX);
                                }
                                lastX += (2 * outlierRadius);
                                shiftLeftNext = false;
                            } else {  // we are shifting to the right. Change sign.
                                lastX = (0 - lastX);
                                shiftLeftNext = true;
                            }
                        } else { // no overlap possible. Return to center
                            lastX = 0;
                            lastAxialPoint = yValue;
                            shiftLeftNext = true;
                        }
                        lastY = yValue;
                    }
                    currentX = (centralXPosition + lastX);
                },
                shiftedX = function (xValue, yValue) {
                    if (yValue > lastY) {
                        initialize();
                    }
                    determinePositioning(xValue, yValue);
                    return currentX;
                },
                shiftedY = function (xValue, yValue) {
                    if (yValue > lastY) {
                        initialize();
                    }
                    determinePositioning(xValue, yValue);
                    return lastY;
                },
                initialize = function () {
                    lastX = null;
                    lastY = null;
                };

            return {
                // public variables

                // public methods
                currentX: shiftedX,
                currentY: shiftedY,
                initialize: initialize
            };

        }());


        //  Handle the tooltip pop-ups.
        var tip = (function () {
            if (typeof d3.tip === 'undefined') {
                immedTip();// kludge.  Why am I forced to re-initialize this library in the presence of LZ?  I don't want to
                // stop to figure out the problem right now, but something is going on
                // that I don't understand.
            }
            return d3.tip()
                .attr('class', 'd3-tip')
                .offset([-10, 0])
                .html(function (d) {
                    var nodeData = d3.select(this.parentNode).data()[0].data[d];
                    var valueToDisplay = new Number(nodeData.v);
                    return tooltipTextFunction(nodeData);
                });
        })();


        var histogram = (function () {
            var summaryData,
                arrayOfBars = [],
                longestBar = 0,

                summarizeData = function (incoming,numberOfBins,accessor) {
                    if ( typeof numberOfBins === 'undefined')  {
                        numberOfBins = 15;
                    }
                    summaryData = UTILS.distributionMapper(incoming,numberOfBins,accessor);
                    return summaryData;
                },

                convertToArrayOfBarValues = function(summaryForProcessing){
                    if ( typeof summaryForProcessing === 'undefined')  {
                        summaryForProcessing = summaryData;
                    }
                    if (!(( typeof summaryForProcessing === 'undefined')  ||
                        ( typeof summaryForProcessing.binSize === 'undefined')  ||
                        ( summaryForProcessing.binSize <= 0 )))   {
                        var numericKeys  = summaryForProcessing.binMap.keys().map(function(x){return parseInt(x)}) ;
                        var sortedKeys =   numericKeys.sort(function(a,b){return a-b;});
                        sortedKeys.forEach(function(key){     // while we build the array we can also identify the longest bar for scaling purposes
                            var tempHolder =  summaryForProcessing.binMap.get(key);
                            if (tempHolder>longestBar) {longestBar = tempHolder;}
                            arrayOfBars.push(tempHolder);
                        });
                    }
                    return  arrayOfBars;
                },

                explicitBarValues = function(explicitBinCounts){
                    if (( typeof explicitBinCounts !== 'undefined')   &&
                        ( explicitBinCounts.length  >  0)  )   {
                        var minVal = d3.min(explicitBinCounts, function(d){return d.start_value});
                        var maxVal = d3.max(explicitBinCounts, function(d){return d.end_value});
                        summaryData = {min: minVal,
                            max: maxVal,
                            binSize:(maxVal-minVal)/explicitBinCounts.length };
                        arrayOfBars = explicitBinCounts.map(function (d){return d.count});
                        longestBar = d3.max(arrayOfBars);
                    }
                    return  arrayOfBars;//min,max,binSize
                },


                reinitialize  = function (){
                    arrayOfBars = [];
                },
                getLongestBar =   function(){
                    return longestBar;
                } ,
                getSummaryData =   function(){
                    return summaryData;
                } ,
                getArrayOfBars =   function(){
                    return arrayOfBars;
                }

            return {
                // public methods
                reinitialize: reinitialize,
                summarizeData: summarizeData,
                getLongestBar:getLongestBar,
                getSummaryData: getSummaryData,
                getArrayOfBars: getArrayOfBars,
                explicitBarValues: explicitBarValues,
                convertToArrayOfBarValues:convertToArrayOfBarValues
            };

        }());




        // Now we get to work  and actually build the box whisker plot.
        instance.boxWhisker = function (currentSelection) {
            var xAxis,
                yAxis,
                boxWhiskerObjects,
                numberOfBoxes,
                boxWidth,
                centerForBox,
                leftEdgeOfBox,
                rightEdgeOfBox;

            boxWhiskerObjects  = currentSelection.selectAll('g.boxHolder');
            numberOfBoxes  = boxWhiskerObjects[0].length;
            boxWidth = width/(1.5*(numberOfBoxes +0.5));
            boxWhiskerObjects
                .each(function (d, i) {

                    /***
                     * Everything inside this block we will loop over once for each  data set
                     * ( that is, once for each box whisker grouping).  May be breakout the code
                     * tthat should be executed exactly once ( such as axis definitions)    and put it
                     * in a separate place from the code  that needs to be reexecuted for each box whisker?
                     */
                    centerForBox =  (boxWidth/2)*((3*i)+2.5) - leftShiftPlotWithinAxes ;
                    leftEdgeOfBox =  centerForBox-(boxAndWhiskerWidthMultiplier*(boxWidth/2)) ;
                    rightEdgeOfBox = centerForBox+(boxAndWhiskerWidthMultiplier*(boxWidth/2));

                    histogram.reinitialize();
                    if (typeof explicitlySpecifiedHistogram !== 'undefined') {
                        histogram.explicitBarValues(explicitlySpecifiedHistogram);
                        min = histogram.getSummaryData().min; // if you are explicitly setting your bar chart then you cannot override min for your plot
                        max = histogram.getSummaryData().max; // if you are explicitly setting your bar chart then you cannot override max for your plot
                    }


                    var g = d3.select(boxWhiskerObjects[0][i]);

                    g.call(tip);//.class('boxHolder',true);
                    var d2 = d.data.sort(function (a, b) {
                        return a.v - b.v;
                    });
                    var n = d2.length;

                    // Compute quartiles. Must return exactly 3 elements.
                    var quartileData = d2.quartiles = quartiles(d2);

                    // Compute whiskers. Must return exactly 2 elements, or null.
                    var whiskerIndices = whiskers && whiskers.call(this, d2, i),
                        whiskerData = whiskerIndices && whiskerIndices.map(function (i) {
                            return d2[i].v;
                        });

                    // Compute outliers. If no whiskers are specified, all data are "outliers".
                    // We compute the outliers as indices, so that we can join across transitions!
                    var outlierIndices = whiskerIndices
                        ? d3.range(0, whiskerIndices[0]).concat(d3.range(whiskerIndices[1] + 1, n))
                        : d3.range(n);

                    // Compute the new x-scale.
                    var xScale = d3.scale.linear()
                        .domain([0, 1])
                        .range([boxWidth + margin.right + margin.left, 0]);


                    // Compute the new y-scale.
                    var yScale = d3.scale.linear()
                        .domain([min - ((max - min) * 0.05), max + ((max - min) * 0.05)])
                        .range([height , 0]);

                    // Retrieve the old x-scale, if this is an update.
                    var yScaleOld = this.__chart__ || d3.scale.linear()
                        .domain([min - ((max - min) * 0.05), max + ((max - min) * 0.05)])
                        .range([height/* + margin.bottom + margin.top*/, 0]);


                    // Stash the new scale.
                    this.__chart__ = yScale;


                    xAxis = d3.svg.axis()
                        .scale(xScale)
                        .orient("bottom");

                    yAxis = d3.svg.axis()
                        .scale(yScale)
                        .orient("left");


                    // Note: the box, median, and box tick elements are fixed in number,
                    // so we only have to handle enter and update. In contrast, the outliers
                    // and other elements are variable, so we need to exit them! Variable
                    // elements also fade in and out.

                    // Update center line: the vertical line spanning the whiskers.
                    var center = g.selectAll("line.center")
                        .data(whiskerData ? [whiskerData] : []);

                    center.enter().append("line", "rect")
                        .attr("class", "center")
                        .attr("x1", centerForBox)
                        .attr("y1", function (d) {
                            return yScaleOld(d[0]);
                        })
                        .attr("x2", centerForBox)
                        .attr("y2", function (d) {
                            return yScaleOld(d[1]);
                        })
                        .style("opacity", 1e-6)
                        .transition()
                        .duration(duration)
                        .style("opacity", 1)
                        .attr("y1", function (d) {
                            return yScale(d[0]);
                        })
                        .attr("y2", function (d) {
                            return yScale(d[1]);
                        });

                    center.transition()
                        .duration(duration)
                        .style("opacity", 1)
                        .attr("y1", function (d) {
                            return yScale(d[0]);
                        })
                        .attr("y2", function (d) {
                            return yScale(d[1]);
                        });

                    center.exit().transition()
                        .duration(duration)
                        .style("opacity", 1e-6)
                        .attr("y1", function (d) {
                            return yScale(d[0]);
                        })
                        .attr("y2", function (d) {
                            return yScale(d[1]);
                        })
                        .remove();

                    // Update innerquartile box.
                    var box = g.selectAll("rect.box")
                        .data([quartileData]);

                    box.enter().append("rect")
                        .attr("class", "box")
                        .attr("x", leftEdgeOfBox)
                        .attr("y", function (d) {
                            return yScaleOld(d[2]);
                        })
                        .attr("width", rightEdgeOfBox-leftEdgeOfBox)
                        .attr("height", function (d) {
                            return yScaleOld(d[0]) - yScaleOld(d[2]);
                        })
                        .transition()
                        .duration(duration)
                        .attr("y", function (d) {
                            return yScale(d[2]);
                        })
                        .attr("height", function (d) {
                            return yScale(d[0]) - yScale(d[2]);
                        });

                    box.transition()
                        .duration(duration)
                        .attr("y", function (d) {
                            return yScale(d[2]);
                        })
                        .attr("height", function (d) {
                            return yScale(d[0]) - yScale(d[2]);
                        });

                    box.exit().remove();

                    // Update median line.
                    var medianLine = g.selectAll("line.median")
                        .data([quartileData[1]]);

                    medianLine.enter().append("line")
                        .attr("class", "median")
                        .attr("x1", leftEdgeOfBox)
                        .attr("y1", yScaleOld)
                        .attr("x2", rightEdgeOfBox)
                        .attr("y2", yScaleOld)
                        .transition()
                        .duration(duration)
                        .attr("y1", yScale)
                        .attr("y2", yScale);

                    medianLine.transition()
                        .duration(duration)
                        .attr("y1", yScale)
                        .attr("y2", yScale);

                    medianLine.exit().remove();

                    // Update whiskers. These are the lines outside
                    //  of the boxes, but not including text or outliers.
                    var whisker = g.selectAll("line.whisker")
                        .data(whiskerData || []);

                    whisker.enter().append("line", "circle, text")
                        .attr("class", "whisker")
                        .attr("x1", leftEdgeOfBox)
                        .attr("y1", yScaleOld)
                        .attr("x2", rightEdgeOfBox)
                        .attr("y2", yScaleOld)
                        .style("opacity", 1e-6)
                        .transition()
                        .duration(duration)
                        .attr("y1", yScale)
                        .attr("y2", yScale)
                        .style("opacity", 1);

                    whisker.transition()
                        .duration(duration)
                        .attr("y1", yScale)
                        .attr("y2", yScale)
                        .style("opacity", 1);

                    whisker.exit().transition()
                        .duration(duration)
                        .attr("y1", yScale)
                        .attr("y2", yScale)
                        .style("opacity", 1e-6)
                        .remove();

                    // Update outliers.  These are the circles that Mark data outside of the whiskers.
                    var outlier = g.selectAll("circle.outlier")
                        .data(outlierIndices || [], Number);


                    outlier.enter()
                        .append("a")
                        .attr("class", "clickable")
                        .attr("gpn", function (i) {
                            return d2[i].description;
                        })
                        .on('mouseover', tip.show)
                        .on('mouseout', tip.hide)
                        .append("circle", "text")
                        .attr("class", "outlier")
                        .attr("r", function (d) {
                            return outlierRadius;
                        })
                        .attr("cx", function (i) {
                            return jitter.currentX(centerForBox, yScaleOld(d2[i].v));
                        })
                        .attr("cy", function (i) {
                            return jitter.currentY(centerForBox, yScaleOld(d2[i].v));
                        })
                        .style("opacity", 1e-6)

                        .transition()
                        .duration(duration)
                        .attr("r", function (d) {
                            return outlierRadius;
                        })
                        .attr("cx", function (i) {
                            return jitter.currentX(centerForBox, yScaleOld(d2[i].v));
                        })
                        .attr("cy", function (i) {
                            return jitter.currentY(centerForBox, yScaleOld(d2[i].v));
                        })
                        .style("opacity", 1)
                    ;

                    outlier.transition()
                        .duration(duration)
                        .attr("r", function (d) {
                            return outlierRadius;
                        })
                        .attr("cx", function (i) {
                            return jitter.currentX(centerForBox, yScaleOld(d2[i].v));
                        })
                        .attr("cy", function (i) {
                            return jitter.currentY(centerForBox, yScaleOld(d2[i].v));
                        })
                        .style("opacity", 1);

                    outlier.exit()
                        .transition()
                        .duration(duration)
                        .attr("r", function (d) {
                            return 0;
                        })
                        .remove();

                    // Compute the tick format.
                    var format = tickFormat || yScale.tickFormat(8);

                    // Update box ticks. These are the numbers on the
                    //     sides of the box
                    var boxTick = g.selectAll("text.box")
                        .data(quartileData);

                    boxTick.enter().append("text")
                        .attr("class", "box")
                        .attr("dy", ".3em")
                        .attr("dx", function (d, i) {
                            return i & 1 ? 6 : -6;
                        })
                        .attr("x", function (d, i) {
                            return i & 1 ? rightEdgeOfBox : leftEdgeOfBox ;
                        })
                        .attr("y", yScaleOld)
                        .attr("text-anchor", function (d, i) {
                            return i & 1 ? "start" : "end";
                        })
                        .text(format)
                        .transition()
                        .duration(duration)
                        .attr("y", yScale);

                    boxTick.transition()
                        .duration(duration)
                        .text(format)
                        .attr("y", yScale);


                    // No explicit the specification of the bar chart. Therefore derive a histogram from the data in d2
                    if (typeof explicitlySpecifiedHistogram === 'undefined') {
                        histogram.summarizeData(d2,15,function(x){return x.v});
                        histogram.convertToArrayOfBarValues();
                    }


                    var histogramScale = d3.scale.linear()
                        .domain([0,histogram.getLongestBar ()])
                        .range([0,(boxWidth/2)*0.9]);     // cover up to 90% of the box whisker box

                    //   first we unconditionally create a group to hold the bars
                    var histogramHolder = g.selectAll("g.histogramHolder")
                        .data([histogram.getSummaryData()]);

                    histogramHolder.enter().append("g")
                        .attr("class", "histogramHolder");

                    histogramHolder.exit()
                        .remove();

                    // now make the bars
                    var histogramBars = histogramHolder.selectAll("rect.histogramHolder")
                        .data(histogram.getArrayOfBars());

                    var barHeight =  ( yScale(histogram.getSummaryData().min)  - yScale(histogram.getSummaryData().max) ) / histogram.getArrayOfBars().length;

                    histogramBars.enter().append("rect")
                        .attr("class", "histogramHolder")
                        .attr("x", centerForBox)
                        .attr("y", function (d,i) {
                            return yScale(histogram.getSummaryData().min)-(barHeight*(i+1));
                        })
                        .attr("width", 0)
                        .attr("height", function (d) {
                            return barHeight;
                        });

                    histogramBars.transition()
                        .duration(duration)
                        .attr("width", function(d){
                            return histogramScale(d)*histogramBarMultiplier;
                        });

                    histogramBars.exit().remove();





                    // Update whisker ticks. These are the numbers on the side of the whiskers.
                    //
                    // These are handled separately from the box
                    // ticks because they may or may not exist, and we want don't want
                    // to join box ticks pre-transition with whisker ticks post-.
                    var whiskerTick = g.selectAll("text.whisker")
                        .data(whiskerData || []);

                    whiskerTick.enter().append("text")
                        .attr("class", "whisker")
                        .attr("dy", ".3em")
                        .attr("dx", 6)
                        .attr("x", rightEdgeOfBox)
                        .attr("y", yScaleOld)
                        .text(format)
                        .style("opacity", 1e-6)
                        .transition()
                        .duration(duration)
                        .attr("y", yScale)
                        .style("opacity", 1);

                    whiskerTick.transition()
                        .duration(duration)
                        .text(format)
                        .attr("y", yScale)
                        .style("opacity", 1);

                    whiskerTick.exit().transition()
                        .duration(duration)
                        .attr("y", yScale)
                        .style("opacity", 1e-6)
                        .remove();


                    //
                    // provide a single label underneath each box whisker
                    //
                    var boxWhiskerLabel = g.selectAll("text.boxWhiskerLabel")
                        .data(['X'] || []);

                    boxWhiskerLabel.enter().append("text")
                        .attr("class", "boxWhiskerLabel")
                        .attr("x", centerForBox)
                        .attr("y", height )
                        .style("text-anchor", "middle")
                        .style("font-weight", "bold")
                        .text(d.name)
                        .style("opacity", 1e-6)
                        .transition()
                        .duration(duration)
                        .style("opacity", 1);

                    boxWhiskerLabel.transition()
                        .duration(duration)
                        .style("opacity", 1);

                    boxWhiskerLabel.exit().transition()
                        .duration(duration)
                        .style("opacity", 1)
                        .remove();





                    // y axis
                    selection
                        .select("svg").selectAll("g.y").data([1]).enter()
                        .append("g")
                        .attr("class", "y axis")
                        .attr("transform", "translate(32,0)")
                        .call(yAxis)
                        .append("text")
                        .attr("class", "label")
                        .attr("x", 0)
                        .attr("y", height / 2 + margin.top + margin.bottom)
                        .style("text-anchor", "middle")
                        .style("font-weight", "bold")
                        .text('');


                });
            d3.timer.flush();
        };


        /***
         *****************************************************************************
         * This next section of the code describes publicly available methods
         *****************************************************************************
         ***/


            // Note:  this method will assign data to the DOM
        instance.initData = function (x,width,height) {
            if (!arguments.length) return boxWhiskerData;
            boxWhiskerData = x;
            var bwHolderLength,
                valueToConsider;
            var bwPlot = selection
                .append("svg")
                .attr("class", "box")
                .attr("width", width+"px")
                .attr("height", height+"px")
                .selectAll("g")
                .data(boxWhiskerData)
                .enter()
                .append('g')
                .attr("class", "boxHolder")
                .attr("transform", "translate(-130,0)");
             //   .attr("transform", "translate(" + margin.left + ",0)");

            // calculate the maximum and min.  The user can override these
            // if they like.
            min = Infinity;
            max = -Infinity;
            for ( var i = 0 ; i < boxWhiskerData.length ; i++ ) {
                bwHolderLength =  boxWhiskerData[i].data.length;
                for ( var j = 0 ; j < bwHolderLength ; j++)   {
                    valueToConsider=boxWhiskerData[i].data[j].v;
                    if (valueToConsider > max) { max = valueToConsider; }
                    if (valueToConsider < min) { min = valueToConsider; }
                }
            }

            return instance;
        };

        // identify the dominant element upon which we will hang this graphic
        instance.selectionIdentifier = function (x) {
            if (!arguments.length) return selectionIdentifier;
            selectionIdentifier = x;
            selection = d3.select(selectionIdentifier);
            return instance;
        };



        // Returns a function to compute the interquartile range, which is represented
        // through the whiskers attached to the quartile boxes.  Without this function the
        // whiskers will expand to cover the entire data range. With it they will
        // shrink to cover a multiple of the interquartile range.  Set the parameter
        // two zero and you'll get a box with no whiskers
        instance.iqr = function (k) {
            return function(d, i) {
                var q1 = d.quartiles[0],
                    q3 = d.quartiles[2],
                    iqr = (q3 - q1) * k,
                    i = -1,
                    j = d.length;
                while ((d[++i].v) < q1 - iqr);
                while ((d[--j].v) > q3 + iqr);
                return [i, j];
            };
        };




        /***
         *****************************************************************************
         * From here to the end of boxWhiskerPlot the methods are only data accessors
         *****************************************************************************
         ***/

        instance.width = function (x) {
            if (!arguments.length) return width;
            width = x;
            return instance;
        };


        instance.min = function (x) {
            if (!arguments.length) return min;
            min = x;
            return instance;
        };

        instance.max = function (x) {
            if (!arguments.length) return max;
            max = x;
            return instance;
        };

        instance.height = function (x) {
            if (!arguments.length) return height;
            height = x;
            return instance;
        };

        instance.tickFormat = function (x) {
            if (!arguments.length) return tickFormat;
            tickFormat = x;
            return instance;
        };

        instance.value = function (x) {
            if (!arguments.length) return value;
            value = x;
            return instance;
        };


        instance.whiskers = function (x) {
            if (!arguments.length) return whiskers;
            whiskers = x;
            return instance;
        };

        instance.outlierRadius = function (x) {
            if (!arguments.length) return outlierRadius;
            outlierRadius = x;
            return instance;
        };

        instance.histogramBarMultiplier = function (x) {
            if (!arguments.length) return histogramBarMultiplier;
            histogramBarMultiplier = x;
            return instance;
        };

        instance.boxAndWhiskerWidthMultiplier = function (x) {
            if (!arguments.length) return boxAndWhiskerWidthMultiplier;
            boxAndWhiskerWidthMultiplier = x;
            return instance;
        };

        instance.explicitlySpecifiedHistogram = function (x) { // expecting data of the form  [{"start": 15.1,"end": 17.8, "count": 3 },{"start": 17.8,"end": 20.5,"count": 13 },...]
            if (!arguments.length) return explicitlySpecifiedHistogram;
            explicitlySpecifiedHistogram = x;
            return instance;
        };

        instance.leftShiftPlotWithinAxes = function (x) { // with a single box whisker plot the default vertical location may be too far to the right
            if (!arguments.length) return leftShiftPlotWithinAxes;
            leftShiftPlotWithinAxes = x;
            return instance;
        };



        instance.tooltipTextFunction = function (x) {
            if (!arguments.length) return tooltipTextFunction;
            tooltipTextFunction = x;
            return instance;
        };


        return instance;
    };

})();