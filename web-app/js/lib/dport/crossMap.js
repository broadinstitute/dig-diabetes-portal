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
            yAxis;


        // indicate significance level with size
        var circle_size = function (assoc) {
            if (assoc > .05) return 3;
            else if (assoc > .0001) return 5;
            else if (assoc > 5e-8) return 8;
            else return 16;
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
            var inverseVariantMap = {};  // given a number, give me a trait
            var extractUniqueLists = function (dd) {
                var uniqueVariants=d3.nest()
                    .key(function(d) {return d.ID;})
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
                variantMap: variantMap
            }

        };




        var createAxes = function (axisGroup,orgData,gridSize,xScale,yScale, width, height, margin){
            // draw the x axis

            var traitLocal = orgData.traitIDArray.map(function(d,i){
                return i * gridSize + 5;
            }) ;


            yAxis = d3.svg.axis()
                .scale(yScale)
                .orient('left')

          //  .ticks(0)
                .tickFormat   (d3.requote(""))
//                .tickFormat(function(d,i) {
//                    return orgData.traitIDArray[i];
//                }) ;

             //   .tickValues([10,100,500]);

            axisGroup.append('g')
                .attr('id','yaxis')
                .attr('transform', 'translate(' + margin.left + ',0)')
                .attr('class', 'main axis pValue')
                .call(yAxis);

            xAxis = d3.svg.axis()
                .scale(xScale)
                .orient('top')
                .ticks(orgData.variantNameArray.length)
                .tickFormat(function(d,i) {
                    return "";//orgData.variantNameArray[i];
                });

            axisGroup.append('g')
                .attr('id','xaxis x axis')
                .attr('transform', 'translate(0,0)')
                .attr('class', 'main axis chromosome')
                .call(xAxis)
                .selectAll("text")
                    .attr("dx", "0.5em")
                    .attr("dy", "0em")
                    .style("text-anchor", "start")
                    .attr("transform", function(d) {
                        return "rotate(-65)"
                    })
                   .append('a')
                .attr('class', 'boldlink')
                .attr('xlink:href', function (d,i) {
                    return variantLinkUrl + '/' + orgData.variantNameArray[i] ;
                })
                .attr("class", function (d, i) {
                    return "variantlabel r" + i;
                })
                .text(function (d, i) {
                    return '';//orgData.variantNameArray[i];
                });

        };






        instance.render = function () {
            var data = svg.data()[0].variants;


            var grid_size = Math.floor(width / 25);

            var orgData = buildInternalRepresentation(data);
            var traitName = orgData.getTraitNameByTraitNumber;
            var expandedWidth = orgData.variantNameArray.length * grid_size;
            var expandedHeight = orgData.traitIDArray.length * grid_size;

            // create the scales
            xScale = d3.scale.linear()
                .domain([0,expandedWidth])
                .range([ margin.left, width ]);

            yScale = d3.scale.ordinal()
                .domain([0,orgData.traitIDArray])
                .range([ 0,height ]);

            var group = svg
                .selectAll('g.axesHolder')
                .data([1])
                .enter()
                .append('g')
                .attr('class', 'axesHolder')
                .attr('transform', 'translate('+margin.left+','+margin.top+')')
                .call(createAxes ,orgData,grid_size,xScale,yScale,width, height, margin);


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

            // All the traits for a single variant
            var rows = group.selectAll('g.cellr')
                .data(orgData.variantArrayOfArrayVariantPointers)
                .enter()
                .append('g')
                .attr('class', 'cellr')



            var onMouseOver = function(d){
                    var buildToolTip =   function (d)   {
                        var text = '<div class="header">' + traitName(d.t) + '</div>';
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
                parent.append('line')
                    .attr('class', 'cellg')
                    .attr("x1", function (d, i) {
                        return xScale(d.v * grid_size + spaceForVariantLabel);
                    })
                    .attr("y1", function (d, i) {
                        return d.t * grid_size ;
                    })
                    .attr("x2", function (d, i) {
                        return xScale(d.v * grid_size + spaceForVariantLabel);
                    })
                    .attr("y2", function (d, i) {
                        return (d.t * grid_size)+circle_size(d) ;
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
//                parent.append('circle')
//                    .attr('class', 'cellg')
//                    .attr("cx", function (d, i) {
//                        return xScale(d.v * grid_size + spaceForVariantLabel);
//                    })
//                    .attr("cy", function (d, i) {
//                        return d.t * grid_size ;
//
//                        //  return d.v * grid_size
//                    })
//                    .attr('r', function (d, i) {
//                        return circle_size(d.p);
//                    })
//                    .attr('class', function (d, i) {
//                        return circle_class(d);
//                    })
//                    .on("mouseover", function (d) {
//                        onMouseOver(d);
//                    })
//                    .on("mouseout", function (d) {
//                        d3.select("#tooltip").classed("hidden", true);
//                        d3.selectAll(".traitlabel").classed("text-highlight", false);
//                        d3.selectAll(".variantlabel").classed("text-highlight", false).text('');
//                    });
//
            };




            // Now draw something for each trait
            rows.selectAll('circle.cellg')
                .data(function (d, i) {
                    return d
                })
                .enter()
                .call(drawIcon);
//                .append('circle')
//                .attr('class', 'cellg')
//                .attr("cx", function (d, i) {
//                    return xScale(d.v * grid_size + spaceForVariantLabel);
//                })
//                .attr("cy", function (d, i) {
//                    return d.t * grid_size ;
//
//                  //  return d.v * grid_size
//                })
//                .attr('r', function (d, i) {
//                    return circle_size(d.p);
//                })
//                .attr('class', function (d, i) {
//                    return circle_class(d);
//                })
//                .on("mouseover", function (d) {
//                    onMouseOver(d);
//                })
//                .on("mouseout", function (d) {
//                    d3.select("#tooltip").classed("hidden", true);
//                    d3.selectAll(".traitlabel").classed("text-highlight", false);
//                    d3.selectAll(".variantlabel").classed("text-highlight", false).text('');
//                });

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