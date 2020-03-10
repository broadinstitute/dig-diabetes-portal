var baget = baget || {};  // encapsulating variable

baget.dynamicLine = (function () {
    //const d3 = require("d3@5");
    //import * as d3 from "d3";
    // const data = [{
    //     orient: "left",
    //     name: "1956",
    //     x: 0.1,
    //     y: 0.1
    // },
    //     {
    //         orient: "bottom",
    //         name: "",
    //         x: 0.3,
    //         y: 0.4
    //     },
    //     {
    //         orient: "bottom",
    //         name: "",
    //         x: 0.5,
    //         y: 0.7
    //     },
    //     {
    //         orient: "bottom",
    //         name: "",
    //         x: 0.7,
    //         y: 0.8
    //     },
    //     {
    //         orient: "right",
    //         name: "1958",
    //         x: 0.9,
    //         y: 0.9
    //     }
    // ];
    // const height = 720;
    // const width = 1000;
    // const margin = ({top: 20, right: 30, bottom: 30, left: 40});
    // const x = d3.scaleLinear()
    // .domain(d3.extent(data, d => d.x)).nice()
    // .range([margin.left, width - margin.right]);
    // const y = d3.scaleLinear()
    //     .domain(d3.extent(data, d => d.y)).nice()
    //     .range([height - margin.bottom, margin.top])
    // const xAxis = g => g
    // .attr("transform", `translate(0,${height - margin.bottom})`)
    // .call(d3.axisBottom(x).ticks(width / 80))
    // .call(g => g.select(".domain").remove())
    // .call(g => g.selectAll(".tick line").clone()
    //     .attr("y2", -height)
    //     .attr("stroke-opacity", 0.1))
    // .call(g => g.append("text")
    //     .attr("x", width - 4)
    //     .attr("y", -4)
    //     .attr("font-weight", "bold")
    //     .attr("text-anchor", "end")
    //     .attr("fill", "black")
    //     .text(data.x)
    //     .call(halo));
    // const yAxis = g => g
    //     .attr("transform", `translate(${margin.left},0)`)
    //     .call(d3.axisLeft(y).ticks(null, ".2f"))
    //     .call(g => g.select(".domain").remove())
    //     .call(g => g.selectAll(".tick line").clone()
    //         .attr("x2", width)
    //         .attr("stroke-opacity", 0.1))
    //     .call(g => g.select(".tick:last-of-type text").clone()
    //         .attr("x", 4)
    //         .attr("text-anchor", "start")
    //         .attr("font-weight", "bold")
    //         .attr("fill", "black")
    //         .text(data.y)
    //         .call(halo));
    // function halo(text) {
    //     text.select(function() { return this.parentNode.insertBefore(this.cloneNode(true), this); })
    //         .attr("fill", "none")
    //         .attr("stroke", "white")
    //         .attr("stroke-width", 4)
    //         .attr("stroke-linejoin", "round");
    // };
    // const line = d3.line()
    //     .curve(d3.curveCatmullRom)
    //     .x(d => x(d.x))
    //     .y(d => y(d.y));
    // function length(path) {
    //     return d3.create("svg:path").attr("d", path).node().getTotalLength();
    // };

    let x;
    let y;
    let xAxis;
    let yAxis;
    let height;
    let width;
    let margin;

    function halo(text) {
        text.select(function() { return this.parentNode.insertBefore(this.cloneNode(true), this); })
            .attr("fill", "none")
            .attr("stroke", "white")
            .attr("stroke-width", 4)
            .attr("stroke-linejoin", "round");
    };
    function length(path) {
        return d3.create("svg:path").attr("d", path).node().getTotalLength();
    };
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

        if ("ontouchstart" in document) svg
            .style("-webkit-tap-highlight-color", "transparent")
            .on("touchmove", moved)
            .on("touchstart", entered)
            .on("touchend", left)
        else svg
            .on("mousemove", moved)
            .on("mouseenter", entered)
            .on("mouseleave", left);

        const dot = svg.append("g")
            .attr("display", "none");

        dot.append("circle")
            .attr("r", 2.5);

        dot.append("text")
            .style("font", "10px sans-serif")
            .attr("text-anchor", "middle")
            .attr("y", -8);

        function moved() {
            d3.event.preventDefault();
            const ym = y.invert(d3.event.layerY);
            const xm = x.invert(d3.event.layerX);
            const path = d3.select(this).select('path');
            _.forEach(path.datum(),function(d){
                console.log(' garbage truck');
            });

            // const i1 = d3.bisectLeft(data.dates, xm, 1);
            // const i0 = i1 - 1;
            // const i = xm - data.dates[i0] > data.dates[i1] - xm ? i1 : i0;
            // const s = data.series.reduce((a, b) => Math.abs(a.values[i] - ym) < Math.abs(b.values[i] - ym) ? a : b);
            // path.attr("stroke", d => d === s ? null : "#ddd").filter(d => d === s).raise();
            // dot.attr("transform", `translate(${x(data.dates[i])},${y(s.values[i])})`);
            // dot.select("text").text(s.name);
        }

        function entered() {
            const path = $(this).find('path');
            //path.style("mix-blend-mode", null).attr("stroke", "#ddd");
            dot.attr("display", null);
        }

        function left() {
            const path = $(this).find('path');
            //path.style("mix-blend-mode", "multiply").attr("stroke", null);
            dot.attr("display", "none");
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



    const buildDynamicLinePlot = function (data,geneName) {

        height = 720;
        width = 1000;
        margin = ({top: 20, right: 30, bottom: 30, left: 40});
        x = d3.scaleLinear()
            .domain(d3.extent(data, d => d.x)).nice()
            .range([margin.left, width - margin.right]);
        y = d3.scaleLinear()
            .domain(d3.extent(data, d => d.y)).nice()
            .range([height - margin.bottom, margin.top])
        xAxis = g => g
            .attr("transform", `translate(0,${height - margin.bottom})`)
            .call(d3.axisBottom(x).ticks(width / 80))
            .call(g => g.select(".domain").remove())
            .call(g => g.selectAll(".tick line").clone()
                .attr("y2", -height)
                .attr("stroke-opacity", 0.1))
            .call(g => g.append("text")
                .attr("x", width - 4)
                .attr("y", -4)
                .attr("font-weight", "bold")
                .attr("text-anchor", "end")
                .attr("fill", "black")
                .text(data.x)
                .call(halo));
        yAxis = g => g
            .attr("transform", `translate(${margin.left},0)`)
            .call(d3.axisLeft(y).ticks(null, ".2f"))
            .call(g => g.select(".domain").remove())
            .call(g => g.selectAll(".tick line").clone()
                .attr("x2", width)
                .attr("stroke-opacity", 0.1))
            .call(g => g.select(".tick:last-of-type text").clone()
                .attr("x", 4)
                .attr("text-anchor", "start")
                .attr("font-weight", "bold")
                .attr("fill", "black")
                .text(data.y)
                .call(halo));
        line = d3.line()
            .curve(d3.curveCatmullRom)
            .x(d => x(d.x))
            .y(d => y(d.y));

        var dynamicLineSelection = d3.select("#dynamicLine");
        const svg = dynamicLineSelection.append("svg")
            .attr("viewBox", [0, 0, width, height]);

        const l = length(line(data));

        svg.append("g")
            .call(xAxis);

        svg.append("g")
            .call(yAxis);

        path = svg.append("path")
            .datum(data)
            .attr("fill", "none")
            .attr("stroke", "black")
            .attr("stroke-width", 2.5)
            .attr("stroke-linejoin", "round")
            .attr("stroke-linecap", "round")
            .attr("stroke-dasharray", `0,${l}`)
            .attr("d", line)
            .transition()
            .duration(500)
            .ease(d3.easeLinear)
            .attr("stroke-dasharray", `${l},${l}`);

        svg.append("g")
            .attr("fill", "white")
            .attr("stroke", "black")
            .attr("stroke-width", 2)
            .selectAll("circle")
            .data(data)
            .join("circle")
            .attr("cx", d => x(d.x))
            .attr("cy", d => y(d.y))
            .attr("r", 1);

        const label = svg.append("g")
            .attr("font-family", "sans-serif")
            .attr("font-size", 10)
            .selectAll("g")
            .data(data)
            .join("g")
            .attr("transform", d => `translate(${x(d.x)},${y(d.y)})`)
            .attr("opacity", 0);

        label.append("text")
            .text(d => d.name)
            .each(function(d) {
                const t = d3.select(this);
                switch (d.orient) {
                    case "top": t.attr("text-anchor", "middle").attr("dy", "-0.7em"); break;
                    case "right": t.attr("dx", "0.5em").attr("dy", "0.32em").attr("text-anchor", "start"); break;
                    case "bottom": t.attr("text-anchor", "middle").attr("dy", "1.4em"); break;
                    case "left": t.attr("dx", "-0.5em").attr("dy", "0.32em").attr("text-anchor", "end"); break;
                }
            })
            .call(halo);

        label.transition()
            .delay((d, i) => length(line(data.slice(0, i + 1))) / l * (5000 - 125))
            .attr("opacity", 1);

        svg.call(hover, path);



        return svg.node();



    }

    return {
        resize:resize,
        buildDynamicLinePlot: buildDynamicLinePlot
    }
})();
