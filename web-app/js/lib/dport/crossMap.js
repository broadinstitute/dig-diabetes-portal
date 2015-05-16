/***
 *               --------------manhattan--------------
 *
 * This JavaScript file should be sufficient for creating a manhattan plot.
 *
 * @type {baget|*|{}}
 */



var baget = baget || {};  // encapsulating variable

(function () {
    "use strict";

    /***
     * The
     * @returns {{}}
     */

    baget.crossMap = function () {

        // the variables we intend to surface
        var
            width = 1,
            height = 1,
            margin = { top: 250, right: 100, bottom: 100, left: 100 },
               width = 1080 - margin.left - margin.right,
            spaceForVariantLabel = 60,
            variantLinkUrl = '',
            phenotypeArray = [];



        /***
         * private functions
         * @param assoc
         * @returns {number}
         */
        var instance = {},
            svg,
            xScale,
            yScale,
            xAxis,
            yAxis,
            orgData,
            maximumArrowSize=16,
            legendHolderBoxWidth = 150;


        // indicate significance level with size
        var arrowSize = function (node) {
            if (node.p > .05) return maximumArrowSize/4;
            else if (node.p > .0001) return maximumArrowSize/2;
            else if (node.p > 5e-8) return (maximumArrowSize*3)/4;
            else return maximumArrowSize;
        };

        // indicate direction of effect with color
        var circle_class = function (assoc) {
            var c = '';
            if (assoc.d == 'down') c += 'assoc-down';
            else if (assoc.d == 'up') c += 'assoc-up';
            else c += 'assoc-none';

            if (assoc.p > .05) c += ' assoc-none';
            else if (assoc.p > .0001) c += ' assoc-sm';
            else if (assoc.p > 5e-8) c += ' assoc-med';
            else c += ' assoc-lg';


            return c;
        } ;



        var buildInternalRepresentation = function (inArray) {
            var traitMap;  // given a trait, give me a number
            var inverseTraitMap = {};  // given a number, give me a trait
            var variantArrayOfArrays; // arrays of each trait, all pointed to by the elements of an array
            var variantArrayOfArrayVariantPointers; // arrays of each trait, all pointed to by the elements of an array
            var variantMap;
            var positionExtent = {max: undefined, min: undefined} ;
            var inverseVariantMap = {};  // given a number, give me a trait
            var extractUniqueLists = function (dd) {
                var uniqueVariants=d3.nest()
                    .key(function(d) {
                        positionExtent.max = d3.max([positionExtent.max,d.POS]);
                        positionExtent.min = d3.min([positionExtent.min,d.POS]);
                        return d.ID;
                    })
                    .sortKeys(function(a,b) { return a.POS - b.POS; })
                    .rollup(function(d) {return d[0].DBSNP_ID;})
                    .entries(dd)
                    .map(function(d){
                       return {'id':d.key,
                            'rsname':d.values}
                    });
                var uniqueTraits=d3.nest()
                    .key(function(d) {return d.TRAIT;})
                    .rollup(function(d) {return phenotypeMap.phenotypeMap[d[0].TRAIT];})
                    .entries(dd)
                    .map(function(d){
                        return {'id':d.key,
                            'name':d.values}
                    });

                return {traits: uniqueTraits,
                    variants: uniqueVariants};
            };
            var createAMap = function (allTraitsArray) {
                var retval = {};
                for (var i = 0; i < allTraitsArray.length; i++) {
                    retval[allTraitsArray[i]] = i;
                }
                return retval;
            };
            var createArrayOfArrays = function (incoming, traitMap) {
                var variantArrayOfArrays = [];
                variantArrayOfArrayVariantPointers = [];
                var ddLength = incoming.length;
                for (var key in traitMap) {
                    if (traitMap.hasOwnProperty(key)) {
                        variantArrayOfArrays.push([]);
                        variantArrayOfArrayVariantPointers.push([]);
                    }
                }
                // create my array of arrays with all the variants
                for (var i = 0; i < ddLength; i++) {
                    var variant = incoming [i];
                    var variantIdPointer = variantMap[variant.ID];
                    variantArrayOfArrays [traitMap [variant.TRAIT]].push(variant);
                    variantArrayOfArrayVariantPointers[traitMap [variant.TRAIT]].push({v: variantIdPointer,
                        t: traitMap [variant.TRAIT],
                        p: variant.PVALUE,
                        d: variant.DIR,
                        o: variant.ODDS_RATIO,
                        dbsnp: variant.DBSNP_ID,
                        chr: variant.CHROM,
                        pos: variant.POS,
                        b: variant.BETA,
                        z: variant.ZSCORE
                    });
                }
                // and now for each of those arrays of arrays, create an array of pointers so that I can step through the variants in order
                return  variantArrayOfArrays;
            };
            var getVariantsByTraitNumber = function (traitNumber) {
                return  variantArrayOfArrays[traitNumber];
            };
            var getTraitNameByTraitNumber = function (traitNumber) {
                return phenotypeMap.phenotypeMap[inverseTraitMap[traitNumber]];
            };


            //ctor
            var uniqueArrays = extractUniqueLists(inArray);
            var  variantIdArray =  uniqueArrays.variants.map(function (d){return d.id});
            var  variantNameArray = uniqueArrays.variants.map(function (d){return d.rsname});
            var  traitIdArray =  uniqueArrays.traits.map(function (d){return d.id});
            var  traitNameArray = uniqueArrays.traits.map(function (d){return d.rsname});
            traitMap = createAMap(traitIdArray);
            variantMap = createAMap(variantIdArray);
            for (var key in traitMap) {
                if (traitMap.hasOwnProperty(key)) {
                    inverseTraitMap[traitMap[key]] = key;
                }
            }
            variantArrayOfArrays = createArrayOfArrays(inArray, traitMap);

            return {
                variantNameArray:  variantNameArray,
                variantIDArray:  variantIdArray,
                traitNameArray:  traitNameArray,
                traitIDArray:  traitIdArray,
                getVariantsByTraitNumber: getVariantsByTraitNumber,
                getTraitNameByTraitNumber: getTraitNameByTraitNumber,
                variantArrayOfArrayVariantPointers: variantArrayOfArrayVariantPointers,
                variantMap: variantMap,
                positionExtent:positionExtent
            }

        };



        var defineBodyClip = function (bodyClip,id,xStart,yStart,xEnd,yEnd) {

            var defHolder = bodyClip.append("defs");

            defHolder.append("clipPath")
                .attr("id", id)
                .append("rect")
                .attr("x", xStart)
                .attr("y", yStart)
                .attr("width", xEnd)
                .attr("height", yEnd);

        };


        var drawLegend  = function(parent,data,legendPosX,legendPosY,spaceBetweenLegendEntries,set2) {
            // add legend
            var legendTextYPosition = 15,
                spaceBetweenLegendColorAndLegendText = 30,
                legendHolderBoxHeight = 120,
                legendTitleYPositioning = 18,
                legMapShift =  60;


            var legend = parent.append("g")
                .attr("class", "legendHolder")
                .attr("x", legendPosX)
                .attr("y", legendPosY)
                .attr("height", 100)
                .attr("width", 100) ;


            legend.selectAll('rect')
                .data([0])
                .enter()
                .append("rect")
                .attr("x", legendPosX)
                .attr("y", legendPosY)
                .attr("width", legendHolderBoxWidth)
                .attr("height", legendHolderBoxHeight)
                .attr("class", "legendHolder");

            legend.selectAll('text.legendTitle')
                .data([0])
                .enter()
                .append("text")
                .attr("class", "legendTitle")
                .attr("x", legendPosX + (legendHolderBoxWidth / 2))
                .attr("y", legendPosY+legendTitleYPositioning)
                .attr("class", "legendTitle")
                .text('Legend');

            legend.selectAll('text.legendStylingCat')
                .data([0])
                .enter()
                .append("text")
                .attr("class", "legendStylingCat")
                .attr("x", legendPosX+5)
                .attr("y", (legendPosY+(3*(spaceBetweenLegendEntries + legendTextYPosition))/2)-7)
                .text('Direction');
            legend.selectAll('text.legendStylingCat2')
                .data([0])
                .enter()
                .append("text")
                .attr("class", "legendStylingCat2")
                .attr("x", legendPosX+5)
                .attr("y", (legendPosY+(3*(spaceBetweenLegendEntries + legendTextYPosition))/2)+7)
                .text('(color)');


            legend.selectAll('rect')
                .data(data)
                .enter()
                .append("rect")
                .attr("x", legMapShift+legendPosX + 10)
                .attr("y", function (d, i) {
                    return legendPosY+(i * spaceBetweenLegendEntries + legendTextYPosition);
                })
                .attr("width", 10)
                .attr("height", 10)
                .attr("class", function (d, i) {
                    return 'legendStyling' + i;
                })

            legend.selectAll('text.elements1')
                .data(data)
                .enter()
                .append("text")
                .attr("class", "elements1")
                .attr("x", legMapShift+legendPosX + spaceBetweenLegendColorAndLegendText)
                .attr("y", function (d, i) {
                    return legendPosY+(i * spaceBetweenLegendEntries + legendTextYPosition + 9);
                })
                .attr("class", "legendStyling")
                .text(function (d) {
                    if (typeof d.legendText !== 'undefined') {
                        return d.legendText;
                    } else {
                        return '';
                    }
                });

            legend.selectAll('text.legendStylingSig')
                .data([0])
                .enter()
                .append("text")
                .attr("class", "legendStylingSig")
                .attr("x", legendPosX+5)
                .attr("y", (legendPosY+(6*(spaceBetweenLegendEntries + legendTextYPosition))/2)-15)
                .text('Significance');
            legend.selectAll('text.legendStylingSig2')
                .data([0])
                .enter()
                .append("text")
                .attr("class", "legendStylingSig2")
                .attr("x", legendPosX+5)
                .attr("y", legendPosY+(6*(spaceBetweenLegendEntries + legendTextYPosition))/2)
                .text('(size)');

            legend.selectAll('text.elements2')
                .data(set2)
                .enter()
                .append("text")
                .attr("class", "elements2")
                .attr("x", legMapShift/2+legendPosX + spaceBetweenLegendColorAndLegendText+10)
                .attr("y", function (d, i) {
                    return legendPosY+((i+5) * spaceBetweenLegendEntries/2 + legendTextYPosition + 9);
                })
                .attr("class", "legendStyling")
                .text(function (d) {
                    if (typeof d.legendText !== 'undefined') {
                        return d.legendText;
                    } else {
                        return '';
                    }
                });


        } ;



        var createAxes = function (axisGroup,orgData,gridSize,xScale,yScale, width, height, margin) {
            // draw the x axis
//
//            var traitLocal = orgData.traitIDArray.map(function (d, i) {
//                return i * gridSize + 5;
//            });


            yAxis = d3.svg.axis()
                .scale(yScale)
                .orient('left')
                .tickFormat(d3.requote(""));

            axisGroup.append('g')
                .attr('id', 'yaxis')
                .attr('transform', 'translate(' + margin.left + ',0)')
                .attr('class', 'main axis pValue')
                .call(yAxis);

            xAxis = d3.svg.axis()
                .scale(xScale)
                .orient('top')
                .ticks(4);


            axisGroup.append('g')
                .attr('id', 'xaxis')
                .attr('transform', 'translate(0,0)')
                .attr('class', 'main axis chromosome')
                .call(xAxis);
        };
//
//                .selectAll("text")
//                    .attr("dx", "0.5em")
//                    .attr("dy", "0em")
//                    .style("text-anchor", "start")
//                    .attr("transform", function(d) {
//                        return "rotate(-65)"
//                    });
//        };


        var onMouseOver = function(d){
            var buildToolTip =   function (d)   {
                var text = '<div class="header">' +orgData.getTraitNameByTraitNumber(d.t) + '</div>';
                text += d.dbsnp + '<br/>';
                text += 'chr' + d.chr + ':' + d.pos + '<br/>';
                text += 'p-value: <strong>' + d.p.toPrecision(3) + '</strong><br/>';
                if (d.o) text += 'odds ratio: <strong>' + d.o.toPrecision(3) + '</strong><br/>';
                if (d.b) text += 'beta: <strong>' + d.b.toPrecision(3) + '</strong><br/>';
                if (d.z) text += 'z-score: <strong>' + d.z.toPrecision(3) + '</strong><br/>';
                return text;
            };
            d3.selectAll(".traitlabel").classed("text-highlight", function (r, ri) {
                var oneWeWant = (ri == (d.t));
                return  oneWeWant;
            });
            d3.selectAll(".variantlabel").classed("text-highlight", function (r, ri) {
                var oneWeWant = (ri == (d.v));
                if (oneWeWant){
                    $('.variantlabel.r'+ d.v).text(d.dbsnp);
                }
                return  oneWeWant;
            });
            d3.select("#tooltip")
                .style("left", xScale((d3.event.pageX + 10)))
                .style("top", (d3.event.pageY - 10) + "px")
                .select("#value")
                .html(buildToolTip(d));
            d3.select("#tooltip").classed("hidden", false);

        };




        var drawIcon  = function(parent){
            var grid_size = Math.floor((height-margin.top-margin.bottom) / 25);
            parent
                .attr("x1", function (d, i) {
                    return xScale(d.pos);
                })
                .attr("y1", function (d, i) {
                    return (maximumArrowSize/2)+(d.t * grid_size)-(arrowSize(d)/2) ;
                })
                .attr("x2", function (d, i) {
                    return xScale(d.pos);
                    // return xScale(d.v * grid_size + spaceForVariantLabel);
                })
                .attr("y2", function (d, i) {
                    return (maximumArrowSize/2)+(d.t * grid_size)+arrowSize(d) ;
                })
                .attr('stroke-width', 1)
                .attr('class', function (d, i) {
                    return circle_class(d);
                })
                .on("mouseover", function (d) {
                    onMouseOver(d);
                })
                .on("mouseout", function (d) {
                    d3.select("#tooltip").classed("hidden", true);
                    d3.selectAll(".traitlabel").classed("text-highlight", false);
                    d3.selectAll(".variantlabel").classed("text-highlight", false).text('');
                });
        };



        var zoomed = function (local) {

            d3.select("#xaxis").call(xAxis);
            d3.selectAll('.cellr').selectAll('line')
                .call(drawIcon);
        };







        instance.render = function () {
            var data = svg.data()[0].variants;


            var grid_size = Math.floor((height-margin.top-margin.bottom) / 25);

            orgData = buildInternalRepresentation(data);
            var traitName = orgData.getTraitNameByTraitNumber;

            var expandedWidth = orgData.variantNameArray.length * grid_size;
            var expandedHeight = orgData.traitIDArray.length * grid_size;


            // create the scales
            xScale = d3.scale.linear()
                .domain([orgData.positionExtent.min,orgData.positionExtent.max])
                .range([ margin.left, width ]);

            yScale = d3.scale.ordinal()
                .domain([0,orgData.traitIDArray])
                .range([ 0,(height-margin.top-margin.bottom)]);

            var zoom = d3.behavior.zoom()
                .x(xScale)
                .scaleExtent([1, 100])
                .on("zoom", zoomed);

            svg.call(zoom, drawIcon);

            svg
                .selectAll('g.bodyClip')
                .data([1])
                .enter()
                .append('g')
                .attr('class', 'bodyClip')
                .call(defineBodyClip ,"bodyClip",margin.left,0,width-margin.left,height+margin.top);


            var group = svg
                .selectAll('g.axesHolder')
                .data([1])
                .enter()
                .append('g')
                .attr('class', 'axesHolder')
                .attr('transform', 'translate('+margin.left+','+margin.top+')')
                .call(createAxes ,orgData,grid_size,xScale,yScale,width, height, margin);

            var legCol1 = [{legendText:''},
                {legendText:'positive'},
                {legendText:'negative'}] ;
            var legCol2 = [{legendText:''},
                {legendText:'p>.05=none'},
                {legendText:'p<.05=small'},
                {legendText:'p<.0001=med'},
                {legendText:'p<10E-8=big'}
            ] ;


            svg
                .selectAll('g.legend')
                .data([1])
                .enter()
                .append('g')
                .attr('class', 'legend')
                .call(drawLegend,legCol1,  width-legendHolderBoxWidth,3,20, legCol2);



//            var group = svg.attr("width", expandedWidth + margin.top + margin.bottom)
//                           .append("g")
//                           .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
//
//
//            // draw a line along the top
//            group.append('line')
//                .attr('x1', xScale(spaceForVariantLabel-25))
//                .attr('y1', '-15')
//                .attr('x2', xScale(expandedWidth+(spaceForVariantLabel-25)))
//                .attr('y2', '-15')
//                .attr('stroke', '#bbb')
//                .attr('stroke-width', '1');
//
//            // draw a line down the left side
//            group.append('line')
//                .attr('x1', xScale(spaceForVariantLabel-25))
//                .attr('y1', '-15')
//                .attr('x2', xScale(spaceForVariantLabel-25))
//                .attr('y2', height)
//                .attr('stroke', '#bbb')
//                .attr('stroke-width', '1');

            //label variant down the left side
            group.append('g')
                .selectAll(".row-g")
                .data(orgData.traitIDArray)
                .enter()
                .append('text')
                .attr("class", function (d, i) {
                    return "traitlabel  r" + i;
                })
                .text(function (d) {
                    return d;
                })
                .attr("x", 0 )
                .attr("y", function (d, i) {
                    return i * grid_size + 15;
                })
                .style("text-anchor", "start");


            var dataHolder = group
                .selectAll('g.dataHolder')
                .data([1])
                .enter()
                .append('g')
                .attr('class', 'dataHolder');


            // All the traits for a single variant
            var rows = dataHolder.selectAll('g.cellr')
                .data(orgData.variantArrayOfArrayVariantPointers)
                .enter()
                .append('g')
                .attr('class', 'cellr') ;

            // Now draw something for each trait
            rows.selectAll('line.cg')
                .data(function (d, i) {
                    return d
                })
                .enter()
                .append('line')
                .attr('class','cg')
                .attr("clip-path", "url(#bodyClip)")
                .call(drawIcon);

        };


        // Now walk through the DOM and create the enrichment plot
        instance.dataHanger = function (selectionIdentifier, data) {

            var buildSvgContainer = function(parent, width, margin){
                if (typeof parent !== 'undefined'){
                    parent.attr("height", height + margin.top + margin.bottom)
                        .attr("width",width + margin.left + margin.right);
                 }
            };


            svg = d3.select(selectionIdentifier)
                .selectAll('svg.cross')
                .data ([data])
                .enter()
                .append("svg")
                .attr('class', 'cross')
                .call(buildSvgContainer,width,margin);

            return instance;
        };


        instance.phenotypeArray = function (x) {
            if (!arguments.length) return phenotypeArray;
            phenotypeArray = x;
            return instance;
        };

        instance.variantLinkUrl = function (x) {
            if (!arguments.length) return variantLinkUrl;
            variantLinkUrl = x;
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


        return instance;
    };

})();