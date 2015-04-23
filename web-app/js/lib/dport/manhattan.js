/***
 *               --------------manhattan--------------
 *
 * This JavaScript file should be sufficient for creating a manhattan plot.
 *
 * @type {baget|*|{}}
 */



var baget = baget || {};  // encapsulating variable

(function () {

    /***
     * The
     * @returns {{}}
     */

    baget.manhattan = function () {

        // the variables we intend to surface
        var
            width = 1,
            height = 1,
            dotRadius = 3.5,
            significanceThreshold = 7.5,
            blockColoringThreshold,
            xAxisAccessor = {},
            yAxisAccessor = {},
            color = d3.scale.category10(),
            overrideXMinimum,overrideXMaximum,overrideYMinimum,overrideYMaximum,
            selection,
            dataExtent,

            /***
             * Encapsulate functionality directly surrounding chromosomes
             */
            chromosomes = (function (color)  {

                // private variables
                var  chromosomeInfo = [{c:'0',l:0,p:0},
                    {c:'1',l:247249719,p:8.01}, //chromosome name, length, cumulative percentage of total
                    {c:'2',l:242951149,p:15.88},
                    {c:'3',l:199501827,p:24.309},
                    {c:'4',l:191273063,p:30.509},
                    {c:'5',l:180857866,p:36.366},
                    {c:'6',l:170899992,p:41.90},
                    {c:'7',l:158821424,p:47.042},
                    {c:'8',l:146274826,p:51.782},
                    {c:'9',l:140273252,p:56.327},
                    {c:'10',l:135374737,p:60.715},
                    {c:'11',l:134452384,p:65.073},
                    {c:'12',l:132349534,p:69.363},
                    {c:'13',l:114142980,p:73.065},
                    {c:'14',l:106368585,p:76.513},
                    {c:'15',l:100338915,p:79.764},
                    {c:'16',l:88827254,p:82.644},
                    {c:'17',l:78774742,p:85.20},
                    {c:'18',l:76117153,p:87.669},
                    {c:'19',l:63811651,p:89.736},
                    {c:'20',l:62435964,p:91.763},
                    {c:'21',l:46944323,p:93.281},
                    {c:'22',l:49691432,p:94.88},
                    {c:'X',l:154913754,p:99.8},
                    {c:'Y',l:57772954,p:99.9}],
                    chromosomeToIndex = {},
                    genomeLength = 3080419480,
                /***
                 * Convert a chromosome name and position within that chromosome  to and ordered location
                 * within the complete genome.
                 * @param chromosomeNumber
                 * @param position
                 * @param chromosomeInfo
                 */
                 convertALocation  = function(chromosomeName, position) {
                    var chromosomeIndex = chromosomeToIndex[chromosomeName];
                    var returnValue;
                    if (typeof chromosomeIndex !== 'undefined') {
                        var startingPosition = chromosomeInfo[chromosomeIndex-1].p;
                        returnValue =  (startingPosition*genomeLength/100.0)+position; // start of chromosome
                    }
                    return  Number(returnValue);
                },
                colorByChromosomeNumber = function (chromosomeName)  {
                    var chromosomeIndex = chromosomeToIndex[chromosomeName];
                    var returnValue = color(1);
                    if (typeof chromosomeIndex !== 'undefined') {
                        if ((chromosomeIndex % 2)  === 0){
                            returnValue = color(2);
                        }   else {
                            returnValue = color(4);
                        }
                    }
                    return  returnValue;
                }


                // initialization
                for( var i = 1 ; i < chromosomeInfo.length ; i++ ){
                    chromosomeToIndex[chromosomeInfo[i].c] = i;
                }

                return {
                    // public variables
                    chromosomeInfo:chromosomeInfo,
                    chromosomeToIndex:chromosomeToIndex,
                    genomeLength:genomeLength,
                    convertALocation:convertALocation,
                    colorByChromosomeNumber:colorByChromosomeNumber
                }
            }(color)),

            crossChromosomePlot = true,
            tooltipAccessor = function (d) {
                return d.p;      //    default key name for the JSON field holding tooltip values
            },


        // private variables
            instance = {};

        /***
         * use the data to determine the extents. However we can override with the parameters below
         *
         * @param allData
         * @param crossChromosomePlot -- plot the whole human chromosome. 23 autosomes plus X and Y
         * @param minimumXValueOverride -- forget the data, forget crossChromosomePlot --> use this X value minimum
         * @param maximumXValueOverride -- forget the data, forget crossChromosomePlot --> use this X value maximum
         * @param minimumYValueOverride -- forget the data --> use this Y value minimum
         * @param maximumYValueOverride -- forget the data --> use this Y value maximum
         */
        var determineDataExtents = function (allData, crossChromosomePlot,    // Boolean-- X extent equals entire human chromosome
                                             minimumXValueOverride,
                                             maximumXValueOverride,
                                             minimumYValueOverride,
                                             maximumYValueOverride) {
            // first do the X extents, which are much more complicated
            var minimumExtent, maximumExtent;
            if (crossChromosomePlot) {  // plot the whole genome, so we know the extents
                maximumExtent = chromosomes.genomeLength;
                minimumExtent = 0;
            } else {
                (function () {
                    // we need to know the max and min values. Do this work in an orderly way
                    //  inside and immediately executed function so that we can cleanup temporary
                    // variables when the work is done
                    var rememberExtents = [];
                    var numberOfExtents = allData.length;
                    for (var i = 0; i < numberOfExtents; i++) {
                        rememberExtents.push(chromosomes.convertALocation("" + allData[i].c, allData[i].x))
                    }
                    maximumExtent = d3.max(rememberExtents);
                    minimumExtent = d3.min(rememberExtents);
                })();
            }
            if (typeof minimumXValueOverride !== 'undefined') {
                minimumExtent =   minimumXValueOverride;
            }
            if (typeof maximumXValueOverride !== 'undefined') {
                maximumExtent =   maximumXValueOverride;
            }
            return { minimumXExtent: minimumExtent,
                maximumXExtent: maximumExtent,
                minimumYExtent: (typeof minimumYValueOverride !== 'undefined') ? minimumYValueOverride:d3.min(allData, function (d) {return d.y;}),
                maximumYExtent: (typeof maximumYValueOverride !== 'undefined') ? maximumYValueOverride:d3.max(allData, function (d) {return d.y;})  }
        };


        var createAxes = function (axisGroup,chromosomes,xScale,yScale, width, height, margin){
            // draw the x axis
            var v = [];
            for ( var i = 1 ; i < chromosomes.chromosomeInfo.length ; i++ )  {
                v.push(((chromosomes.chromosomeInfo[i-1].p+chromosomes.chromosomeInfo[i].p)*chromosomes.genomeLength)/200);
            }

            // draw the y axis first, so that the
            //  X axis will overdraw it IF the two happen to coincide
            //  (if for example, y minimum  === 0) go to sleep
            var yAxis = d3.svg.axis()
                .scale(yScale)
                .tickSize(-((xScale(chromosomes.genomeLength)-xScale(0))+margin.right))
                .orient('left');

            axisGroup.append('g')
                .attr('transform', 'translate(' + margin.left + ',0)')
                .attr('class', 'main axis pValue')
                .call(yAxis);

            var xAxis = d3.svg.axis()
                .scale(xScale)
                .orient('bottom')
                .tickValues(v)
                .tickFormat(function(d, i){
                    return ""+chromosomes.chromosomeInfo[i+1].c ;
                }) ;

            axisGroup.append("text")
                .attr("class", "y label")
                .attr("text-anchor", "middle")
                .attr("y", 6)
                .attr("x", -height/2)
                .attr("dy", ".75em")
                .attr("transform", "rotate(-90)")
                .text("-log 10 p");

            axisGroup.append("text")
                .attr("class", "x label")
                .attr("text-anchor", "middle")
                .attr("y", height+margin.bottom)
                .attr("x", width)
                .attr("dy", ".75em")
                .text("chromosome number");

            axisGroup.append('g')
                .attr('transform', 'translate(0,' + height +')')
                .attr('class', 'main axis chromosome')
                .call(xAxis);

          };

        var createDots = function (dotHolder,data,chromosomes, radius, xScale,yScale,dataExtent,c,tip) {
            var dots=dotHolder.selectAll('.dot')
                .data(data,function(d){        // merge data sets so that we hold only unique points
                    return(""+ d.c+"_"+ d.x+"_"+ d.y);
                });
            dots
                .enter()
                .append('circle')
                .attr('class', 'dot')
                .attr("r", radius)
                .attr("cx", function(d){
                    return xScale(chromosomes.convertALocation (""+d.c, d.x));
                })
                .attr("cy", function(d){
                    return yScale(dataExtent.minimumYExtent);
                })
                .style("fill", function(d,i) {
                    if (d.y > significanceThreshold)  {
                        return color(9);
                    } else {
                        return chromosomes.colorByChromosomeNumber(d.c);
                    }
                })
                .on('mouseover', tip.show)
                .on('mouseout', tip.hide);
            dots.transition()
                .delay(100).duration(1400)
                .attr("cy", function(d){
                    return yScale(d.y);
                });

        };


        var createSolidBlock = function (blockGroup, yValueThreshold, chromosomes, xScale, yScale, dataExtent) {
            // draw the x axis
            if (typeof yValueThreshold !== 'undefined')  {
                for (var i = 1; i < chromosomes.chromosomeInfo.length; i++) {
                    blockGroup.append("rect")
                        .attr("x", xScale(((chromosomes.chromosomeInfo[i - 1].p) * chromosomes.genomeLength) / 100) )
                        .attr("y",  yScale(yValueThreshold))
                        .attr("width", xScale(((chromosomes.chromosomeInfo[i].p) * chromosomes.genomeLength) / 100) -
                                        xScale(((chromosomes.chromosomeInfo[i - 1].p) * chromosomes.genomeLength) / 100) )
                        .attr("height",    yScale(dataExtent.minimumYExtent)-yScale(yValueThreshold))
                        .style("fill", function(d) {
                            return chromosomes.colorByChromosomeNumber(chromosomes.chromosomeInfo[i].c);
                        });
                }

            }

        };



        var addSignificanceIndicator = function (significanceHolder, significanceThreshold, chromosomes,  xScale, yScale ) {
            if (typeof significanceThreshold === 'undefined')   {
                return ;
            }
            var significanceIndicator=significanceHolder.selectAll('line.significanceIndicator')
            .data([significanceThreshold],function(d){        // merge data sets so that we hold only unique points
                return(""+ d);
            });
            significanceIndicator
                .enter()
                .append('line')
                .attr('class', 'significanceIndicator')
                .attr("x1", function (d) {
                    return xScale(0)
                })
                .attr("y1",function (d) {
                    return yScale(significanceThreshold)
                })
                .attr("x2",  function (d) {
                    return xScale(chromosomes.genomeLength)-margin.right;
                })
                .attr("y2",  function (d) {
                    return yScale(significanceThreshold)
                })
                .attr("stroke-width", 0);
            significanceIndicator.transition()
                .delay(100).duration(1400)
                .attr("stroke-width", 1);
            significanceIndicator.exit()
                .transition()
                .attr("stroke-width", 0)
                .remove();
        };





        //  private variable
        var tip = d3.tip()
            .attr('class', 'd3-tip scatter-tip')
            .style('z-index', 51)
            .offset([-10, 0])
            .html(function (d) {
                var textToPresent = "";
                if (d) {
                    if ((typeof(tooltipAccessor) !== "undefined")&&
                        (typeof(tooltipAccessor(d)) !== "undefined")){
                        textToPresent = tooltipAccessor(d);
                    }  else {
                        textToPresent = d.n+'<br/>Chr='+d.c+', loc='+d.x+'<br/>('+chromosomes.convertALocation (""+d.c, d.x)+')' ;
                    }
                }
                return "<strong><span>" + textToPresent + "</span></strong> ";
            });


        instance.initialize  = function()  {
            // calculate data extents, allowing for manual overrides
            dataExtent =  determineDataExtents(selection.data()[0],crossChromosomePlot,
                overrideXMinimum,overrideXMaximum,overrideYMinimum,overrideYMaximum);
            return instance;
        } ;



        // Now walk through the DOM and create the enrichment plot
        instance.render = function (currentSelection) {


            var margin = {top: 20, right: 15, bottom: 60, left: 60}
                , width = 960 - margin.left - margin.right
                , height = 500 - margin.top - margin.bottom;

            // work in the SVG we created to hold the data
            var chart = currentSelection.select('svg');

            chart
                .selectAll('g.extentHolder')
                .data([1])
                .enter()
                .append('g')
                .attr('class', 'extentHolder')
                .style('display','none')
                .call(instance.initialize);



            // create the scales
            var x = d3.scale.linear()
                .domain([dataExtent.minimumXExtent-((dataExtent.maximumXExtent-dataExtent.minimumXExtent)/50), dataExtent.maximumXExtent])
                .range([ margin.left, width ]);
            var y = d3.scale.linear()
                .domain([dataExtent.minimumYExtent,dataExtent.maximumYExtent])
                .range([ height, 0 ]);

            // create the axes inside the one and only axis holder
            chart
                .selectAll('g.axesHolder')
                .data([1])
                .enter()
                .append('g')
                .attr('class', 'axesHolder')
            .call(createAxes ,chromosomes,x,y,width, height, margin);

            chart
                .selectAll('g.significanceHolder')
                .data([significanceThreshold],function(d){return (""+d)})
                .enter()
                .append('g')
                .attr('class', 'significanceHolder')
                .call(addSignificanceIndicator ,significanceThreshold,chromosomes,x,y);


            // create a solid block to cover the area where we know dots should be.
            if (typeof blockColoringThreshold !== 'undefined') {
                chart
                    .selectAll('g.blockHolder')
                    .data([1])
                    .enter()
                    .append('g')
                    .attr('class', 'blockHolder')
                    .call(createSolidBlock,blockColoringThreshold,chromosomes,x,y,dataExtent);
            }

            // create the dots inside the one and only dot holder
            var dotHolder=chart
                .selectAll('g.dotHolder')
                .data([1])
                .enter()
                .append('g')
                .attr('class', 'dotHolder')
                .call(createDots,chart.data()[0],chromosomes,dotRadius,x,y,dataExtent,significanceThreshold,tip);

            // special workaround-- there is only one dot holder, but we may want to merge in some new data.  In this case force
            //    createDots to be called again, but depend on the existing holder
            if(!dotHolder[0][0]){
                createDots(chart.select('g.dotHolder'),chart.data()[0],chromosomes,dotRadius,x,y,dataExtent,significanceThreshold,tip);
            }


        } ;


        instance.dataHanger = function (selectionIdentifier, data) {

            selection = d3.select(selectionIdentifier)
                .selectAll('svg.mychart')
                .data([data],function(){return ""+data.toString()})
                .enter()
                .append('svg')
                .attr('class', 'mychart')
                .attr('width', width*1.5)
                .attr('height', height*1.4)
                .call(tip);
            return instance;
        };


        instance.dataAppender = function (selectionIdentifier, data) {

            selection = d3.select(selectionIdentifier)
                .selectAll('svg.mychart')
                .data([data],function(){return ""+data.toString()})
                .enter()
                .append('svg')
                .attr('class', 'mychart')
              ;
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

        /***
         * you can explicitly restrict the extent of the data to be handled. The default is to expand the x-axis to handle all available
         * data (exception: if  crossChromosomePlot is specified than the x-axis expands to entire human genome)
         * @param x
         * @returns {*}
         */
        instance.overrideXMinimum = function (x) {
            if (!arguments.length) return overrideXMinimum;
            overrideXMinimum = x;
            return instance;
        };

        /***
         * you can explicitly restrict the extent of the data to be handled. The default is to expand the x-axis to handle all available
         * data (exception: if  crossChromosomePlot is specified than the x-axis expands to entire human genome)
         * @param x
         * @returns {*}
         */
        instance.overrideXMaximum = function (x) {
            if (!arguments.length) return overrideXMaximum
            overrideXMaximum = x;
            return instance;
        };


        /***
         *  explicitly set the minimum value along the vertical axis (the P value in a Manhattan plot).  If no minimum is set, then
         * the minimum will be derived from the data.  NOTE; If you plan to add data to the plotafter it is initially created
         * using the dataAppender followed by render then you must explicitly specify the y minimum (at least if
         * the max/min data extents are going to change -- the issue is that the axes are only drawn once.)
         * @param x
         * @returns {*}
         */
        instance.overrideYMinimum = function (x) {
            if (!arguments.length) return overrideYMinimum;
            overrideYMinimum = x;
            return instance;
        };

        /***
         * explicitly set the maximum value along the vertical axis (the P value in a Manhattan plot).  If no maximum is set, then
         * the maximum will be derived from the data.  NOTE; If you plan to add data to the plotafter it is initially created
         * using the dataAppender followed by render then you must explicitly specify the y maximum (at least if
         * the max/min data extents are going to change -- the issue is that the axes are only drawn once. )
         * @param x
         * @returns {*}
         */
        instance.overrideYMaximum = function (x) {
            if (!arguments.length) return overrideYMaximum;
            overrideYMaximum = x;
            return instance;
        };

        /***
         * size of the dots on the plot. There is a default.
         * @param x
         * @returns {*}
         */
        instance.dotRadius = function (x) {
            if (!arguments.length) return dotRadius;
            dotRadius = x;
            return instance;
        };

        /***
         * Rather than marking millions of high value points we will instead summarize them with a block of color.  If undefined than no drama blocks.
         * @param x
         * @returns {*}
         */
        instance.blockColoringThreshold = function (x) {
            if (!arguments.length) return blockColoringThreshold;
            blockColoringThreshold = x;
            return instance;
        };

        /***
         * This number determines where a line will be drawn to indicate significance. If the value is undefined then draw no line
         * @param x
         * @returns {*}
         */
        instance.significanceThreshold = function (x) {
            if (!arguments.length) return significanceThreshold;
            significanceThreshold = x;
            return instance;
        };

        /***
         * Boolean: plot the whole human chromosome, or conform the x-axis to the available data
         * @param x
         * @returns {*}
         */
        instance.crossChromosomePlot = function (x) {
            if (!arguments.length) return crossChromosomePlot;
            crossChromosomePlot = x;
            return instance;
        };




        return instance;
    };

})();