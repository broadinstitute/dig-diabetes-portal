var baget = baget || {};  // encapsulating variable

baget.confidenceIntervalPlot = (function () {
    let x;
    let y;
    let xAxis;
    let yAxis;
    let height;
    let width;
    let margin;


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
    let line;
    let path;


    function hover(svg, path) {
        const straightLine = d3.line()
            .x(d => x(d.x))
            .y(d => y(d.y));

        if ("ontouchstart" in document) svg
            .style("-webkit-tap-highlight-color", "transparent")
            .on("touchmove", moved)
            .on("touchstart", entered)
            .on("touchend", left)
        else svg
            .on("mousemove", moved)
            .on("mouseenter", entered)
            .on("mouseleave", left);

        const dotHolder = svg.append("g")
            .attr("display", "none");

        const dot = dotHolder.append("circle")
            .attr("r", 3)
            .attr("fill", "red")
            .attr("class", "movingDot");

        const crosshairsVertical = dotHolder.append("line")
            .attr("class", "crosshairs")
            .style("stroke", "red")
            .attr("stroke-opacity", 0.5)
            .style("stroke-width", 0.5);
        const crosshairsHorizontal = dotHolder.append("line")
            .attr("class", "crosshairs")
            .style("stroke", "red")
            .attr("stroke-opacity", 0.5)
            .style("stroke-width", 0.5);

        const priorDescription = dotHolder.append("text")
            .attr("class", "movingTextDescription")
            .attr("x", 4)
            .attr("y", -2)
            .attr("text-anchor", "left");
        const posteriorDescription = dotHolder.append("text")
            .attr("class", "movingTextDescription")
            .attr("x", 4)
            .attr("y", -3)
            .attr("text-anchor", "left");

        function moved() {
            d3.event.preventDefault();
            const ym = y.invert(d3.event.layerY);
            const xm = x.invert(d3.event.layerX);
            const path = d3.select(this).select('path');
            let closestIndex;
            _.forEach(path.datum(),function(d,i){
                if (d.x > xm){
                    closestIndex = i;
                    return false;
                }
            });
            const closestDataPoint = path.datum()[closestIndex];
            if ( typeof closestDataPoint !== 'undefined'){
                dotHolder.attr("display", null);
                dot
                    .attr("cx", d => x(closestDataPoint.x))
                    .attr("cy", d => y(closestDataPoint.y));
                priorDescription
                    .attr("dx", d => x(closestDataPoint.x))
                    .attr("dy", d => y(0))
                    .text('prior:'+closestDataPoint.x);
                posteriorDescription
                    .attr("dx", d => x(0))
                    .attr("dy", d => y(closestDataPoint.y))
                    .text('posterior probability:'+d3.format(".2f")(closestDataPoint.y));
                crosshairsVertical
                    .attr("x1", d => x(closestDataPoint.x))
                    .attr("y1", d => y(0))
                    .attr("x2", d => x(closestDataPoint.x))
                    .attr("y2", d => y(1));
                crosshairsHorizontal
                    .attr("x1", d => x(0))
                    .attr("y1", d => y(closestDataPoint.y))
                    .attr("x2", d => x(1))
                    .attr("y2", d => y(closestDataPoint.y));
            }

        }

        function entered() {
            dotHolder.attr("display", null);
        }

        function left() {
            dotHolder.attr("display", "none");
        }
    };

    const resize = function () {
        width = widthAdjuster()- margin.left - margin.right;
        height = heightAdjuster() - margin.top - margin.bottom;
        var extractedData  = d3.selectAll('#groupHolder').selectAll('g.allGroups').data();
        var dataRange = UTILS.extractDataRange(extractedData);
        d3.select("#scatterPlot1").selectAll('svg').remove();
        qqPlot.width(width)
            .height(height)
            .dataHanger ("#scatterPlot1", extractedData);
        d3.select("#scatterPlot1").call(qqPlot.render);
    };



    const buildConfidenceIntervalPlot = function (beta,standardError) {

        height = 300;
        width = 500;
        const yData = [0,1];
        const xDataRawRange = [beta-(1.96*standardError),beta+(1.96*standardError)];
        const xDataRawinterval = (xDataRawRange[1]===xDataRawRange[0])?1:(xDataRawRange[1]-xDataRawRange[0]); // this is the range of our actual data. don't arrow a range of 0
        const xDataRawintervalExpander = xDataRawinterval/5.0; //let's go 20% beyond that
        const displayableXRange = [(xDataRawRange[0]<(1-xDataRawintervalExpander))?(xDataRawRange[0]-xDataRawintervalExpander):(1-xDataRawintervalExpander),
                                (xDataRawRange[1]>(1+xDataRawintervalExpander))?(xDataRawRange[1]+xDataRawintervalExpander):(1+xDataRawintervalExpander)];
        margin = ({top: 100, right: 50, bottom: 35, left: 60});
        x = d3.scaleLinear()
            .domain(d3.extent(displayableXRange, d => d)).nice()
            .range([margin.left, width - margin.right]);
        y = d3.scaleLinear()
            .domain(d3.extent(yData, d => d)).nice()
            .range([height - margin.bottom, margin.top])
        xAxis = g => g
            .attr("transform", `translate(0,${height - margin.bottom})`)
            .call(d3.axisBottom(x).ticks(width / 80))
            .call(g => g.select(".domain").remove())
            .call(g => g.selectAll(".tick line").clone()
                .attr("y2", -height+margin.top)
                .attr("stroke-opacity", 0.05));
            // .call(g => g.append("text")
            //     .attr("x", width - 4)
            //     .attr("y", -4)
            //     .attr("font-weight", "bold")
            //     .attr("text-anchor", "end")
            //     .attr("fill", "black")
            //     .text('x foo'));

        yAxis = g => g
            .attr("transform", `translate(${margin.left},0)`);
            // .call(d3.axisLeft(y).ticks(null, ".2f"))
            // .call(g => g.select(".domain").remove())
            // .call(g => g.selectAll(".tick line").clone()
            //     .attr("x2", width)
            //     .attr("stroke-opacity", 0.1));


        var confidenceIntervalSelection = d3.select("#confidenceInterval");

        const svg = confidenceIntervalSelection.append("svg")
            .attr("viewBox", [0, 0, width, height]);

        // build the axes
        svg.append("g")
            .call(xAxis);
        svg.append("g")
            .call(yAxis);

        // build the 95% confidence line
        const confidenceIndicator = svg.append("g");
        confidenceIndicator.append("line")
            .attr("class", "confidenceLine")
            .style("stroke", "black")
            .attr("stroke-opacity", 1)
            .style("stroke-width", 0.5)
            .attr("x1", d => x(xDataRawRange[0]))
            .attr("y1", d => y(0.5))
            .attr("x2", d => x(xDataRawRange[1]))
            .attr("y2", d => y(0.5));


        // build the 95% confidence line
        //const betaRectangle = svg.append("g");
        confidenceIndicator.append("rect")
            .attr("class", "betaPoint")
            .attr("x", d => x(beta))
            .attr("y", d => y(0.5)-5)
            .attr("width", 10)
            .attr("height", 10);


        // build the identity line
        //const identityLine = svg.append("g");
        confidenceIndicator.append("line")
            .attr("class", "identity")
            .style("stroke", "blue")
            .attr("stroke-opacity", 0.5)
            .style("stroke-width", 0.5)
            .attr("x1", d => x(1))
            .attr("y1", d => y(0))
            .attr("x2", d => x(1))
            .attr("y2", d => y(1));

        return svg.node();



    }

    return {
        resize:resize,
        buildConfidenceIntervalPlot: buildConfidenceIntervalPlot
    }
})();

