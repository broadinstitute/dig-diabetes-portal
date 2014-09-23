/***
 *               --------------Bar chart--------------
 *
 * This JavaScript file should be sufficient for creating a bar chart.
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
            selection;   // no default because we can't make a plot without a place to put it

        // private variables
        var  instance = {};

        var margin = {top: 30, right: 20, bottom: 50, left: 70},
            width = 800 - margin.left - margin.right,
            height = 250 - margin.top - margin.bottom;

        instance.render = function() {
            var x, y;
            var chart =  selection
                .append('svg')
                .attr('class', 'chart')
                .attr('width', width*1.5)
                .attr('height', height*1.4);

            x = d3.scale.linear()
                .domain([0,maximumPossibleValue ])
                .range([margin.left+roomForLabels, width+roomForLabels]);

            var names=[];
            data.map(function(d){names.push(d.barname)});
            y = d3.scale.ordinal()
                .domain(names)
                .rangeBands([margin.top, height]);

            var	xAxis = d3.svg.axis();

            xAxis
                .orient('bottom')
                .scale(x)
                .tickSize(2);

            var x_xis = chart.append('g')
                .attr("transform", "translate(0,"+(height+40)+")")
                .attr('class','xaxis')
                .call(xAxis);



            // the bars in the bar chart
            var bars = chart.selectAll("rect")
                .data(data,function(d,i){return d.barname;});

            bars.enter().append("rect")
                .attr('class','h-bar')
                .attr("x", x(0))
                .attr("y", function(d, i){
                    return y(d.barname) + y.rangeBand()/2;
                } )
                .attr("width", function(d,i){
                    return (0)
                })
                .attr("height", y.rangeBand()/4);

            // perform the animation
            bars.transition()
                .delay(100).duration(1400)
                .attr("width", function(d,i){
                    return (x( d.value)-x(0))
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
                .attr("x",  margin.left+roomForLabels-labelSpacer)
                .attr("y", function(d, i){
                    return y(d.barname) + y.rangeBand()/2;
                } )
                .attr("dy", ""+textLeading+"em")
                .attr("text-anchor", "end")
                .attr('class', 'barChartLabel')
                .text(function(d,i){return d.barname;});

            // sub labels, just below the main labels above
            chart.selectAll("text.barChartSubLabel")
                .data(data)
                .enter().append("text")
                .attr("x",  margin.left+roomForLabels-labelSpacer)
                .attr("y", function(d, i){
                    return y(d.barname) + y.rangeBand()/2;
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
                    return y(d.barname) + y.rangeBand()/2;
                } )
                .attr("dx", 12)
                .attr("dy", ""+textLeading+"em")
                .attr("text-anchor", "start")
                .attr('class', 'valueLabels')
                .text(function(d,i){return ""+(d.value).toPrecision(3)+ "%";});

            // labels to the right of the right hand labels
            chart.selectAll("text.valueQualifiers")
                .data(data)
                .enter().append("text")
                .attr("x", function(d){
                    return (x(d.value));
                })
                .attr("y", function(d){
                    return y(d.barname) + y.rangeBand()/2;
                } )
                .attr("dx", 108)
                .attr("dy", ""+textLeading+"em")
                .attr("text-anchor", "start")
                .attr('class', 'valueQualifiers')
                .text(function(d,i){return ""+d.descriptor+ "%";})


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

        instance.selectionIdentifier = function (x) {
            if (!arguments.length) return selectionIdentifier;
            selectionIdentifier = x;
            selection = d3.select(selectionIdentifier);
            return instance;
        };

        return instance;
    };

})();