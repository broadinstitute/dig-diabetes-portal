<div class="row">

    <div class="col-md-2"></div>

    <div class="col-md-8"><div id="manhattanPlot1"></div>
        <div id="chart"></div>

        <div class="col-md-2"></div>

    </div>

</div>



<script>


    var margin = {top: 30, right: 20, bottom: 50, left: 70},
            width = 800 - margin.left - margin.right,
            height = 600 - margin.top - margin.bottom,
            sliderOnScreenTop = 10,
            sliderOnScreenBottom = 200;


    var qqPlot;

    var width = 960,
            height = 500;

    var chart = d3.select("#manhattanPlot1")
            .attr("width", width)
            .attr("height", height);


    var addMoreData = function (d3Object) {

        d3.json("${createLink(controller: 'man', action:'manData1')}", function (error, data) {

            d3Object.dataAppender("#manhattanPlot1",data)
                    .overrideYMinimum (0)
                    .overrideYMaximum (10) ;

            d3.select("#manhattanPlot1").call(d3Object.render);

        });
    };





    %{--d3.json("${createLink(controller: 'man', action:'manData')}", function (error, data) {--}%

        %{--var manhattan = baget.manhattan()--}%
                %{--.width(width)--}%
                %{--.height(height)--}%
                %{--.dataHanger("#manhattanPlot1",data)--}%
                %{--.crossChromosomePlot(true)--}%
                %{--.overrideYMinimum (0)--}%
                %{--.overrideYMaximum (10)--}%
%{--//                .overrideXMinimum (0)--}%
%{--//                .overrideXMaximum (1000000000)--}%
                %{--.dotRadius(3)--}%
                %{--.blockColoringThreshold(0.5)--}%
                %{--.significanceThreshold(6.5) ;--}%


        %{--d3.select("#manhattanPlot1").call(manhattan.render);--}%

        %{--addMoreData (manhattan) ;--}%


    %{--});--}%

    function type(d) {
        d.value = +d.value; // coerce to number
        return d;
    }










</script>