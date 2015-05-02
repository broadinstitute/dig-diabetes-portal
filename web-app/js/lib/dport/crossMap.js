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
               width = 1080 - margin.left - margin.right;

        var instance = {};

        instance.render = function (data, allTraits) {
            var that = data,
                traits = allTraits;


            var buildInternalRepresentation = function (inArray) {
                var traitMap;  // given a trait, give me a number
                var inverseTraitMap = {};  // given a number, give me a trait
                var variantArrayOfArrays; // arrays of each trait, all pointed to by the elements of an array
                var variantArrayOfArrayVariantPointers; // arrays of each trait, all pointed to by the elements of an array
                var variantMap;
                var inverseVariantMap = {};  // given a number, give me a trait
                var getUniqueTraits = function (dd) {
                    var u = {}, a = [], ddLength = dd.length;
                    var v = {}, b = [];
                    for (var i = 0, l = ddLength; i < l; ++i) {
                        if (!u.hasOwnProperty(dd[i].TRAIT)) {
                            a.push(dd[i].TRAIT);
                            u[dd[i].TRAIT] = 1;
                        }
                        if (!v.hasOwnProperty(dd[i].ID)) {
                            b.push(dd[i].ID);
                            v[dd[i].ID] = 1;
                        }
                    }
                    return {traits: a,
                        variants: b};
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
                    // create my array of arrays with all the variant
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
                var uniqueArrays = getUniqueTraits(inArray);
                traitMap = createAMap(uniqueArrays.traits);
                variantMap = createAMap(uniqueArrays.variants);
                for (var key in traitMap) {
                    if (traitMap.hasOwnProperty(key)) {
                        inverseTraitMap[traitMap[key]] = key;
                    }
                }
                variantArrayOfArrays = createArrayOfArrays(inArray, traitMap);

                return {
                    getVariantsByTraitNumber: getVariantsByTraitNumber,
                    getTraitNameByTraitNumber: getTraitNameByTraitNumber,
                    variantArrayOfArrayVariantPointers: variantArrayOfArrayVariantPointers,
                    variantMap: variantMap
                }

            };




            var grid_size = Math.floor(width / 25);

            var orgData = buildInternalRepresentation(data.variants);
            var traitName = orgData.getTraitNameByTraitNumber;

            var uniqueVariantLabels = [];
            for (var i = 0; i < that.variants.length; i++) {
                if (uniqueVariantLabels.indexOf(that.variants[i]['DBSNP_ID']) == -1) {
                    uniqueVariantLabels.push(that.variants[i]['DBSNP_ID']);
                }
            }

            var height = uniqueVariantLabels.length * grid_size;

            //var svg = d3.select(that.$("#vis")[0]).append("svg")
            var svg = d3.select("#vis").append("svg")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
                .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
            window.vis = svg;

            var xaxis = svg.append('line')
                .attr('x1', '15')
                .attr('y1', '-15')
                .attr('x2', width)
                .attr('y2', '-15')
                .attr('stroke', '#bbb')
                .attr('stroke-width', '1');

            var yaxis = svg.append('line')
                .attr('x1', '15')
                .attr('y1', '-15')
                .attr('x2', '15')
                .attr('y2', height)
                .attr('stroke', '#bbb')
                .attr('stroke-width', '1');
            var variant_labels = svg.append('g')
                .selectAll(".row-g")
                .data(uniqueVariantLabels)
                .enter()
                .append('a')
                .attr('class', 'boldlink')
                .attr('xlink:href', function (d) {
                    var rootUrl = '<g:createLink controller="variant" action="variantInfo" />';
                    return rootUrl + '/' + d
                })
                .append('text')
                .attr("class", function (d, i) {
                    return "variantlabel r" + i;
                })
                .text(function (d) {
                    return d;
                })
                .attr("x", 0)
                .attr("y", function (d, i) {
                    return i * grid_size + 5;
                })
                .style("text-anchor", "end");

            var trait_labels = svg.append('g')
                .selectAll(".col-g")
                .data(traits)
                .enter()
                .append('text')
                .attr("class", function (d, i) {
                    return "traitlabel r" + i;
                })
                .text(function (d, i) {
                    return traitName(i)
                })
                .attr('y', 30)
                .attr('x', 30)
                .attr("transform", function (d, i) {
                    return 'translate(' + i * grid_size + ',-20) rotate(-60)';
                });

            var circle_size = function (assoc) {
                if (assoc > .05) return 3;
                else if (assoc > .0001) return 5;
                else if (assoc > 5e-8) return 8;
                else return 16;
            };


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
            }


            var rows = svg.selectAll('g.cellr')
                .data(orgData.variantArrayOfArrayVariantPointers)
                .enter()
                .append('g')
                .attr('class', 'cellr')


            var cells = rows.selectAll('circle.cellg')
                .data(function (d, i) {
                    return d
                })
                .enter()
                .append('circle')
                .attr('class', 'cellg')
                .attr("cx", function (d, i) {
                    return d.t * grid_size + 40;
                })
                .attr("cy", function (d, i) {
                    return d.v * grid_size
                })
                .attr('r', function (d, i) {
                    return circle_size(d.p);
                })
                .attr('class', function (d, i) {
                    return circle_class(d);
                })
                .on("mouseover", function (d) {

                    d3.selectAll(".traitlabel").classed("text-highlight", function (r, ri) {
                        return ri == (d.t);
                    });
                    d3.selectAll(".variantlabel").classed("text-highlight", function (r, ri) {
                        return ri == (d.v);
                    });
                    var text = '<div class="header">' + traitName(d.t) + '</div>';
                    text += d.dbsnp + '<br/>';
                    text += 'chr' + d.chr + ':' + d.pos + '<br/>';
                    text += 'p-value: <strong>' + d.p.toPrecision(3) + '</strong><br/>';
                    if (d.o) text += 'odds ratio: <strong>' + d.o.toPrecision(3) + '</strong><br/>';
                    if (d.b) text += 'beta: <strong>' + d.b.toPrecision(3) + '</strong><br/>';
                    if (d.z) text += 'z-score: <strong>' + d.z.toPrecision(3) + '</strong><br/>';
                    d3.select("#tooltip")
                        .style("left", (d3.event.pageX + 10) + "px")
                        .style("top", (d3.event.pageY - 10) + "px")
                        .select("#value")
                        .html(text);
                    d3.select("#tooltip").classed("hidden", false);
                })
                .on("mouseout", function (d) {
                    d3.select("#tooltip").classed("hidden", true);
                    d3.selectAll(".traitlabel").classed("text-highlight", false);
                    d3.selectAll(".variantlabel").classed("text-highlight", false);
                });

        };


        // Now walk through the DOM and create the enrichment plot
        instance.dataHanger = function (selectionIdentifier, data) {

//            selection = d3.select(selectionIdentifier)
//                .selectAll('svg.mychart')
//                .data([data],function(){return ""+data.toString()})
//                .enter()
//                .append('svg')
//                .attr('class', 'mychart')
//                .attr('width', width*1.5)
//                .attr('height', height*1.4)
//                .call(tip);
//
//            return instance;
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