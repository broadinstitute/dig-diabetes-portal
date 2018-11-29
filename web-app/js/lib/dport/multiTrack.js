/***
 *               --------------multiTrack--------------
 *
 * This JavaScript file should be sufficient for plotting multitrack genomic data.
 *
 * @type {baget|*|{}}
 */



var baget = baget || {};  // encapsulating variable

(function () {

    /***
     * The
     * @returns {{}}
     */

    baget.multiTrack = function (options) {

        // the variables we intend to surface
        var
            margin = {top: 50, right: 50, bottom: 100, left: 100},
            width = 350,
            height = 350,
            data,// array of arrays of objects
            container, // text for a CSS selector
            xlabelsData,// dataform = ['xlab1','xlab2'],
            ylabelsData,// dataform = ['ylab1','ylab2'],
            xAxisLabel,// no x label by default
            yAxisLabel,// no y label by default
            mappingInfo,// figure out how to label rows so that we can color them
            startColor = '#ffffff',
            endColor = '#3498db',
            startRegion,
            endRegion,
            colorByValue=0,
            renderCellText = 1;

        // private variables
        var instance = {};


        // Now walk through the DOM and create the enrichment plot
        instance.render = function (currentSelection) {

            /// check the data
            if(!data){
                throw new Error('multiTrack expects data');
            }

            if( !Array.isArray(data) ){
                throw new Error('multiTrack expects array data, even if length 0');
            }

            var numrows = data.length;

            var minValue = d3.min(data, function(layer) { return d3.min(layer, function(f) { return f.START; }); });
            var maxValue = d3.max(data, function(layer) { return d3.max(layer, function(f) { return f.STOP; }); });
            var minAssayValue = d3.min(data, function(layer) { return d3.min(layer, function(f) { return f.VALUE; }); });
            var maxAssayValue = d3.max(data, function(layer) { return d3.max(layer, function(f) { return f.VALUE; }); });
            var color_scale = d3.scale.linear().domain([minAssayValue, maxAssayValue]).range(['blue', 'red']);

            var svg = d3.select(container).append("svg")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
                .attr('class','trackHolder')
                .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");


            var xDomain = [minValue,maxValue];
            var xScale = d3.scale.linear()
                .domain(xDomain)
                .range([0, width]);

            var yDomain = d3.range(numrows);
            var yScale = d3.scale.ordinal()
                .domain(yDomain)
                .rangeBands([0, height]);

            var row = svg.selectAll(".row")
                .data(data)
                .enter().append("g")
                .attr("class", "row")
                .attr("class",  function(d, i) {
                    var markRow = "";
                    if (typeof xlabelsData !== 'undefined'){
                        var indexOfNonZeroElement =_.findIndex(mappingInfo[i] ,function(o){
                            return (o!==0);
                        });
                        if (indexOfNonZeroElement > -1){
                            markRow = xlabelsData[indexOfNonZeroElement].replace(/[ \/]/g,"_");
                        }
                    }
                    return "row "+markRow;
                })
                .attr("transform", function(d, i) {
                    return "translate(0," + yScale(i) + ")";
                });

            var element = row.selectAll(".element")
                .data(function(d) { return d; })
                .enter().append("g")
                .attr("class", "element")
                .attr("transform", function(d, i) { return "translate(" + xScale(d.START) + ", 0)"; });

            if (colorByValue){  // color by scale
                element.append('rect')
                    .attr("width", function(v){
                        return xScale(v.STOP)-xScale(v.START);})
                    .attr("height", yScale.rangeBand()/2)
                    .style("stroke-width", 1)
                    .style("stroke",  function(v) {
                        return color_scale(v.VALUE);
                    })
                    .style('fill', function(v) {
                        return color_scale(v.VALUE);
                    });
            } else { // no color for rectangles at all -- we will instead color on the basis of CSS class assignments
                element.append('rect')
                    .attr("width", function(v){
                        return xScale(v.STOP)-xScale(v.START);})
                    .attr("height", yScale.rangeBand()/2)
                    .style("stroke-width", 1)
                    .style("stroke", "black");
            }


            var labels = svg.append('g')
                .attr('class', "labels");

            // x-axis
            var xAxis = d3.svg.axis().scale(xScale).orient("bottom");
            var axG = svg.append("g")
                .attr("class", "x axis")
                .attr("transform", "translate(0," + height + ")")
                .style('stroke-width',1)
                .call(xAxis);

            //axG.selectAll("line").attr("fill", "none");
            axG.selectAll("path").attr("fill", "none");
            axG.selectAll("text")
                .attr("y", 0)
                .attr("x", -38)
                .attr("text-anchor", "end")
                .attr("transform", "rotate(-60)");

            if (typeof xAxisLabel !== 'undefined'){
                axG.append("text")
                    .attr("class", "label")
                    .attr("x", width / 2)
                    .attr("y", 90)
                    .style("text-anchor", "middle")
                    .style("font-weight", "bold")
                    .text(xAxisLabel);
            }


            // label those tissues on the y-axis
            if (typeof ylabelsData !== 'undefined'){
                var rowLabels = labels.selectAll(".row-label")
                    .data(ylabelsData)
                    .enter().append("g")
                    .attr("class", "row-label")
                    .attr("transform", function(d, i) { return "translate(" + 0 + "," + yScale(i) + ")"; });

                rowLabels.append("line")
                    .style("stroke-width", "1px")
                    .attr("x1", 0)
                    .attr("x2", -5)
                    .attr("y1", (1*yScale.rangeBand() / 4))
                    .attr("y2", (1*yScale.rangeBand() / 4));

                rowLabels.append("text")
                    .attr("x", -8)
                    .attr("y", (1*yScale.rangeBand() / 4))
                    .attr("dy", ".32em")
                    .attr("text-anchor", "end")
                    .text(function(d, i) { return d; });
            }

            if (startRegion!==endRegion){
                var indexPosition = svg.append("g")
                    .attr("class", "rect");
                indexPosition.append("rect")
                    .attr("id", "indexPosition")
                    .attr("class", "regionRect");
                indexPosition.select("#indexPosition")
                    .attr("x", xScale(startRegion))
                    .attr("y", 0)
                    .attr("width", xScale(endRegion)-xScale(startRegion))
                    .attr("height", height);

            } else if (typeof startRegion !== 'undefined') {
                var indexPosition = svg.append("g")
                    .attr("class", "line");
                indexPosition.append("line")
                    .attr("id", "indexPosition")
                    .attr("class", "indexPosition");
                indexPosition.select("#indexPosition")
                    .attr("x1", xScale(startRegion))
                    .attr("y1", 0-2)
                    .attr("x2", xScale(startRegion))
                    .attr("y2", height+2);
                var indexPosLabel = labels.append("text")
                    .attr("x", xScale(startRegion))
                    .attr("y", 0 - 5)
                    .attr("class", "mouseReporter")
                    .style("text-anchor", "middle");
                indexPosLabel.text("variant location "+startRegion)
            }

            // build a crosshair attached to the pointer
            var label = labels.append("text")
                .attr("x", width - 5)
                .attr("y", height - 5)
                .attr("class", "mouseReporter")
                .style("text-anchor", "end");
            var crosshair = svg.append("g")
                .attr("class", "line");
            crosshair.append("line")
                .attr("id", "crosshairX")
                .attr("class", "crosshair");
            svg.append("rect")
                .attr("class", "overlay")
                .attr("width", width)
                .attr("height", height)
                .on("mouseover", function() {
                    crosshair.style("display", null);
                })
                .on("mouseout", function() {
                    crosshair.style("display", "none");
                    label.text("");
                })
                .on("mousemove", function() {
                    var mouse = d3.mouse(this);
                    crosshair.select("#crosshairX")
                        .attr("x1", mouse[0])
                        .attr("y1", 0)
                        .attr("x2", mouse[0])
                        .attr("y2", height);
                    label.text(function() {
                        return "position = "+Math.round(xScale.invert(mouse[0]));
                    });
                });






        };

        instance.xAxisAccessor = function (x) {
            if (!arguments.length) return xAxisAccessor;
            xAxisAccessor = x;
            return instance;
        };

        instance.yAxisAccessor = function (x) {
            if (!arguments.length) return yAxisAccessor;
            yAxisAccessor = x;
            return instance;
        };

        instance.tooltipAccessor = function (x) {
            if (!arguments.length) return tooltipAccessor;
            tooltipAccessor = x;
            return instance;
        };

        instance.externalLinkAccessor = function (x) {
            if (!arguments.length) return externalLinkAccessor;
            externalLinkAccessor = x;
            return instance;
        };

        instance.xlabelsData = function (x) {
            if (!arguments.length) return xlabelsData;
            xlabelsData = x;
            return instance;
        };
        instance.ylabelsData = function (x) {
            if (!arguments.length) return ylabelsData;
            ylabelsData = x;
            return instance;
        };
        instance.startColor = function (x) {
            if (!arguments.length) return startColor;
            startColor = x;
            return instance;
        };
        instance.endColor = function (x) {
            if (!arguments.length) return endColor;
            endColor = x;
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

        instance.margin = function (x) {
            if (!arguments.length) return margin;
            margin = x;
            return instance;
        };

        instance.xAxisLabel = function (x) {
            if (!arguments.length) return xAxisLabel;
            xAxisLabel = x;
            return instance;
        };

        instance.yAxisLabel = function (x) {
            if (!arguments.length) return yAxisLabel;
            yAxisLabel = x;
            return instance;
        };

        instance.margin = function (x) {
            if (!arguments.length) return margin;
            margin = x;
            return instance;
        };

        instance.mappingInfo = function (x) {
            if (!arguments.length) return mappingInfo;
            mappingInfo = x;
            return instance;
        };

        instance.renderCellText = function (x) {
            if (!arguments.length) return renderCellText;
            renderCellText = x;
            return instance;
        };

        instance.clickCallback = function (x) {
            if (!arguments.length) return clickCallback;
            clickCallback = x;
            return instance;
        };
        instance.endRegion = function (x) {
            if (!arguments.length) return endRegion;
            endRegion = x;
            return instance;
        };
        instance.startRegion = function (x) {
            if (!arguments.length) return startRegion;
            startRegion = x;
            return instance;
        };
        instance.colorByValue = function (x) {
            if (!arguments.length) return colorByValue;
            colorByValue = x;
            return instance;
        };



        /***
         * This is not a standard accessor.  The purpose of this method is to take a DOM element and to
         *  attach the data to it.  All further references to the data should come through that DOM element.
         * @param x
         * @returns {*}
         */
        instance.dataHanger = function (selectionIdentifier, dataPasser) {

            container = selectionIdentifier;
            data = dataPasser;
            return instance;
        };




        return instance;
    };

})();