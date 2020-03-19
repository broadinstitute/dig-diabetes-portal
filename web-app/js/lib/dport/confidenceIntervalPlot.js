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

        height = 200;
        width = 500;
        const yData = [0,1];
        const xDataRawRange = [beta-(1.96*standardError),beta+(1.96*standardError)];
        const xDataRawinterval = (xDataRawRange[1]===xDataRawRange[0])?1:(xDataRawRange[1]-xDataRawRange[0]); // this is the range of our actual data. don't arrow a range of 0
        const xDataRawintervalExpander = xDataRawinterval/5.0; //let's go 20% beyond that
        const displayableXRange = [(xDataRawRange[0]<(0-xDataRawintervalExpander))?(xDataRawRange[0]-xDataRawintervalExpander):(0-xDataRawintervalExpander),
                                (xDataRawRange[1]>(0+xDataRawintervalExpander))?(xDataRawRange[1]+xDataRawintervalExpander):(0+xDataRawintervalExpander)];
        margin = ({top: 50, right: 50, bottom: 35, left: 60});
        x = d3.scaleLinear()
            .domain(d3.extent(displayableXRange, d => d)).nice()
            .range([margin.left, width - margin.right]);
        y = d3.scaleLinear()
            .domain(d3.extent(yData, d => d)).nice()
            .range([margin.top,height - margin.bottom]);


        var confidenceIntervalSelection = d3.select("#confidenceInterval");

        const svg = confidenceIntervalSelection.append("svg")
            .attr("viewBox", [0, 0, width, height]);

        // build the 95% confidence line
        const confidenceIndicator = svg.append("g");
        confidenceIndicator
            .selectAll("line")
            .data([xDataRawRange])
            .enter()
            .append("line")
            .attr("class", "confidenceLine")
            .style("stroke", "black")
            .attr("stroke-opacity", 1)
            .style("stroke-width", 0.5)
            .attr("x1", d => x(beta))
            .attr("y1", d => y(0.5))
            .attr("x2", d => x(beta))
            .attr("y2", d => y(0.5))
            .transition()
            .duration(1000)
            .attr("x1", d => x(d[0]))
            .attr("x2", d => x(d[1]));

        // mark each end of the confidence line
        confidenceIndicator
            .append("g")
            .selectAll("line")
            .data(xDataRawRange)
            .enter()
            .append("line")
            .attr("class", "eachEndOfTheConfidenceLine")
            .style("stroke", "black")
            .attr("stroke-opacity", 1)
            .style("stroke-width", 0.5)
            .attr("x1", d => x(beta))
            .attr("y1", d => y(0.5)-5)
            .attr("x2", d => x(beta))
            .attr("y2", d => y(0.5)+5)
            .transition()
            .duration(1000)
            .attr("x1", d => x(d))
            .attr("y1", d => y(0.5)-5)
            .attr("x2", d => x(d))
            .attr("y2", d => y(0.5)+5);

        // enumerate the number at each end of the confidence interval
        confidenceIndicator
            .append("g")
            .selectAll("text")
            .data(xDataRawRange)
            .enter()
            .append("text")
            .attr("class", "describeEachEndOfTheConfidenceInterval")
            .attr("text-anchor", "middle")
            .attr("alignment-baseline", "ideographic")
            .text( d => d3.format(".2f")(d))
            .attr("x", d => x(beta))
            .attr("y", d => y(0.5)-5)
            .transition()
            .duration(1000)
            .attr("x", d => x(d));



        // build the 95% confidence line
        //const betaRectangle = svg.append("g");
        confidenceIndicator
            .selectAll("rect")
            .data([beta])
            .enter()
            .append("rect")
            .attr("class", "betaPoint")
            .attr("x", d => x(d))
            .attr("y", d => y(0.5)-5)
            .attr("width", 0)
            .attr("height", 10)
            .transition()
            .duration(1000)
            .attr("x", d => x(d)-5)
            .attr("width", 10);
        confidenceIndicator
            .append("text")
            .attr("class", "lofteeOr")
            .attr("text-anchor", "middle")
            .attr("alignment-baseline", "hanging")
            .attr("x", d => x(beta))
            .attr("y", d => y(0.5)+7)
            .text(d3.format(".2f")(beta));

        // Title the display
        svg.append("text")
            .attr("class", "displayTitle")
            .attr("text-anchor", "left")
            .attr("alignment-baseline", "ideographic")
            .attr("x", d => x(displayableXRange[0])+2)
            .attr("y", d => y(0)-2)
            .text("LOFTEE beta ("+d3.format(".3f")(beta)+") with 95% confidence interval");

        // build the beta==0 line
        svg.append("line")
            .attr("class", "oddsRatioZero")
            .style("stroke", "blue")
            .attr("stroke-opacity", 0.5)
            .style("stroke-width", 0.5)
            .style("stroke-dasharray", ("3, 3"))
            .attr("x1", d => x(0))
            .attr("y1", d => y(0))
            .attr("x2", d => x(0))
            .attr("y2", d => y(1));
        svg.append("text")
            .attr("class", "oddsRatioZero")
            .attr("text-anchor", "left")
            .attr("alignment-baseline", "ideographic")
            .attr("x", d => x(0)+2)
            .attr("y", d => y(1)-2)
            .text("beta = 0");
        return svg.node();



    }

    return {
        resize:resize,
        buildConfidenceIntervalPlot: buildConfidenceIntervalPlot
    }
})();

