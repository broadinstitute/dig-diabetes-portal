/***
 *               --------------simpleHeatMap--------------
 *
 * This JavaScript file should be sufficient for creating a simple heat map. Combine this single module with other
 * modules to create a more fully featured interactive visualization.
 *
 * See also Arpit Narechania's blog: https://bl.ocks.org/arpitnarechania/caeba2e6579900ea12cb2a4eb157ce74
 *
 * @type {baget|*|{}}
 */



var baget = baget || {};  // encapsulating variable

(function () {

    /***
     * The
     * @returns {{}}
     */

    baget.matrix = function (options) {

        // the variables we intend to surface
        var
            margin = {top: 50, right: 50, bottom: 100, left: 100},
            width = 350,
            height = 350,
            data,// array of arrays of real values
            container, // text for a CSS selector
            xlabelsData,// dataform = ['xlab1','xlab2'],
            ylabelsData,// dataform = ['ylab1','ylab2'],
            xAxisLabel,// no x label by default
            yAxisLabel,// no y label by default
            startColor = '#ffffff',
            endColor = '#3498db',
            widthLegend = 100,
            renderLegend = 1,
            renderCellText = 1;

            // private variables
            var instance = {};

        // build a legend
       var renderLegendNow = function ( legendSelector,
                                        widthLegend,
                                        height,
                                        margin,
                                        startColor,
                                        endColor,
                                        minValue,
                                        maxValue )  {
           var key = d3.select("#legend")
               .append("svg")
               .attr("width", widthLegend)
               .attr("height", height + margin.top + margin.bottom);

           var legend = key
               .append("defs")
               .append("svg:linearGradient")
               .attr("id", "gradient")
               .attr("x1", "100%")
               .attr("y1", "0%")
               .attr("x2", "100%")
               .attr("y2", "100%")
               .attr("spreadMethod", "pad");

           legend
               .append("stop")
               .attr("offset", "0%")
               .attr("stop-color", endColor)
               .attr("stop-opacity", 1);

           legend
               .append("stop")
               .attr("offset", "100%")
               .attr("stop-color", startColor)
               .attr("stop-opacity", 1);

           key.append("rect")
               .attr("width", widthLegend/2-10)
               .attr("height", height)
               .style("fill", "url(#gradient)")
               .attr("transform", "translate(0," + margin.top + ")");

           var y = d3.scale.linear()
               .range([height, 0])
               .domain([minValue, maxValue]);

           var yAxis = d3.svg.axis()
               .scale(y)
               .orient("right");

           key.append("g")
               .attr("class", "y axis")
               .attr("transform", "translate(41," + margin.top + ")")
               .call(yAxis)

       };



        // Now walk through the DOM and create the enrichment plot
        instance.render = function (currentSelection) {

            /// check the data
            if(!data){
                throw new Error('Please pass data');
            }

            if(!Array.isArray(data) || !data.length || !Array.isArray(data[0])){
                throw new Error('It should be a 2-D array');
            }

            var numrows = data.length;
            var numcols = data[0].length;

            if (typeof xlabelsData !== 'undefined')  {
                if (!Array.isArray(xlabelsData)) {
                    throw new Error('Problem: xlabelsData must be an array');
                }
                else if(numcols != xlabelsData.length){
                    throw new Error('Problem: length of X axis labels = '+xlabelsData.length+','+
                    ' but the number of columns in the data matrix is '+numcols+'.');
                }
            }

            if (typeof ylabelsData !== 'undefined')  {
                if (!Array.isArray(ylabelsData)) {
                    throw new Error('Problem: ylabelsData must be an array');
                }
                else if(numrows != ylabelsData.length){
                    throw new Error('Problem: length of Y axis labels = '+ylabelsData.length+','+
                        ' but the number of rows in the data matrix is '+numrows+'.');
                }
            }



            var maxValue = d3.max(data, function(layer) { return d3.max(layer, function(d) { return d; }); });
            var minValue = d3.min(data, function(layer) { return d3.min(layer, function(d) { return d; }); });

            var svg = d3.select(container).append("svg")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
                .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
                //.call(tip)

            var background = svg.append("rect")
                .style("stroke", "black")
                .style("stroke-width", "2px")
                .attr("width", width)
                .attr("height", height);

            var xScale = d3.scale.ordinal()
                .domain(d3.range(numcols))
                .rangeBands([0, width]);
            var axG = svg.append("g")
                .attr("class", "x axis")
                .attr("transform", "translate(0," + height + ")")
                .style('stroke-width',1)
                .call(xScale);
            if (typeof xAxisLabel !== 'undefined'){
                axG.append("text")
                    .attr("class", "label")
                    .attr("x", width / 2)
                    .attr("y", 170)
                    .style("text-anchor", "middle")
                    .style("font-weight", "bold")
                    .text(xAxisLabel);
            }


            var y = d3.scale.ordinal()
                .domain(d3.range(numrows))
                .rangeBands([0, height]);

            var colorMap = d3.scale.linear()
                .domain([minValue,maxValue])
                .range([startColor, endColor]);

            var row = svg.selectAll(".row")
                .data(data)
                .enter().append("g")
                .attr("class",  function(d, i) {
                    var markRow = "";
                    if (typeof xlabelsData !== 'undefined'){
                        var indexOfNonZeroElement =_.findIndex(d,function(o){
                            return (o!==0);
                        });
                        markRow = xlabelsData[indexOfNonZeroElement].replace(/[ \/]/g,"_");
                    }
                    return "row "+markRow;
                })
                .attr("transform", function(d, i) {
                    return "translate(0," + y(i) + ")";
                });

            var cell = row.selectAll(".cell")
                .data(function(d) { return d; })
                .enter().append("g")
                .attr("class", "cell")
                .attr("transform", function(d, i) {
                    return "translate(" + xScale(i) + ", 0)";
                });

            cell.append('rect')
                .attr("width", xScale.rangeBand())
                .attr("height", y.rangeBand())
                .style("stroke-width", 0);

            if (renderCellText){
                cell.append("text")
                    .attr("dy", ".32em")
                    .attr("x", xScale.rangeBand() / 2)
                    .attr("y", y.rangeBand() / 2)
                    .attr("text-anchor", "middle")
                    .style("fill", function(d, i) { return d >= maxValue/2 ? 'white' : 'black'; })
                    .text(function(d, i) { return d; });
            }

            row.selectAll(".cell")
                .data(function(d, i) { return data[i]; })
                .attr('class',function(d, i) {
                    if (d===1){
                       return 'cell chosen'
                    } else {
                        return 'cell notChosen'
                    }

                });

            var labels = svg.append('g')
                .attr('class', "labels");

            if (typeof xlabelsData !== 'undefined'){
                var columnLabels = labels.selectAll(".column-label")
                    .data(xlabelsData)
                    .enter().append("g")
                    .attr("class", "column-label")
                    .attr("transform", function(d, i) { return "translate(" + xScale(i) + "," + height + ")"; });

                columnLabels.append("line")
                    .style("stroke", "black")
                    .style("stroke-width", "1px")
                    .attr("x1", xScale.rangeBand() / 2)
                    .attr("x2", xScale.rangeBand() / 2)
                    .attr("y1", 0)
                    .attr("y2", 5);

                columnLabels.append("text")
                    .attr("x", 0)
                    .attr("y", y.rangeBand() / 2)
                    .attr("dy", ".82em")
                    .attr("text-anchor", "end")
                    .attr("transform", "rotate(-60)")
                    .text(function(d, i) { return d; });
            }

            if (typeof ylabelsData !== 'undefined'){
                var rowLabels = labels.selectAll(".row-label")
                    .data(ylabelsData)
                    .enter().append("g")
                    .attr("class", "row-label")
                    .attr("transform", function(d, i) { return "translate(" + 0 + "," + y(i) + ")"; });

                rowLabels.append("line")
                    .style("stroke", "black")
                    .style("stroke-width", "1px")
                    .attr("x1", 0)
                    .attr("x2", -5)
                    .attr("y1", y.rangeBand() / 2)
                    .attr("y2", y.rangeBand() / 2);

                rowLabels.append("text")
                    .attr("x", -8)
                    .attr("y", y.rangeBand() / 2)
                    .attr("dy", ".32em")
                    .attr("text-anchor", "end")
                    .text(function(d, i) { return d; });
            }


            if (renderLegend){
                renderLegendNow('#legend',
                                widthLegend,
                                height,
                                margin,
                                startColor,
                                endColor,
                                minValue,
                                maxValue);
            }

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

        instance.renderLegend = function (x) {
            if (!arguments.length) return renderLegend;
            renderLegend = x;
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