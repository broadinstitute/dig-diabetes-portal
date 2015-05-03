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
            svg;


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
                    .rollup(function(d) {
                        return d.DBSNP_ID;//+"%"+ d.DBSNP_ID;
                    })
                    .entries(dd)
                    .map(function(d){
//                        var combo =  d.key;
//                        var both = combo.split('%');
//                        return {'id':both[0],
//                            'name':both[1]}
                        return d.key;
                    });
                var uniqueTraits=d3.nest()
                    .key(function(d) {return d.TRAIT;})
                    .rollup(function(d) {return d.TRAIT;})
                    .entries(dd)
                    .map(function(d){ return d.key; });

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
            var  variantNameArray = uniqueArrays.variants.map(function (d){return d}); //uniqueArrays.variants.map(function (d){return d.name});
            traitMap = createAMap(uniqueArrays.traits);
            variantMap = createAMap(variantNameArray);
           // variantMap = createAMap(variantIdArray);
            for (var key in traitMap) {
                if (traitMap.hasOwnProperty(key)) {
                    inverseTraitMap[traitMap[key]] = key;
                }
            }
            variantArrayOfArrays = createArrayOfArrays(inArray, traitMap);

            return {
                variantNameArray:  variantNameArray,
                traitNameArray:  uniqueArrays.traits,
                getVariantsByTraitNumber: getVariantsByTraitNumber,
                getTraitNameByTraitNumber: getTraitNameByTraitNumber,
                variantArrayOfArrayVariantPointers: variantArrayOfArrayVariantPointers,
                variantMap: variantMap
            }

        };





        instance.render = function () {
            var data = svg.data()[0].variants;


            var grid_size = Math.floor(width / 25);

            var orgData = buildInternalRepresentation(data);
            var traitName = orgData.getTraitNameByTraitNumber;
            var height = orgData.variantNameArray.length * grid_size;


            var group = svg.attr("height", height + margin.top + margin.bottom)
                           .append("g")
                           .attr("transform", "translate(" + margin.left + "," + margin.top + ")");


            // draw a line along the top
            group.append('line')
                .attr('x1', spaceForVariantLabel-25)
                .attr('y1', '-15')
                .attr('x2', width+(spaceForVariantLabel-25))
                .attr('y2', '-15')
                .attr('stroke', '#bbb')
                .attr('stroke-width', '1');

            // draw a line down the left side
            group.append('line')
                .attr('x1', spaceForVariantLabel-25)
                .attr('y1', '-15')
                .attr('x2', spaceForVariantLabel-25)
                .attr('y2', height)
                .attr('stroke', '#bbb')
                .attr('stroke-width', '1');

            // label variant down the left side
            group.append('g')
                .selectAll(".row-g")
                .data(orgData.variantNameArray)
                .enter()
                .append('a')
                .attr('class', 'boldlink')
                .attr('xlink:href', function (d) {
                     return variantLinkUrl + '/' + d
                })
                .append('text')
                .attr("class", function (d, i) {
                    return "variantlabel r" + i;
                })
                .text(function (d) {
                    return d;
                })
                .attr("x", spaceForVariantLabel-35)
                .attr("y", function (d, i) {
                    return i * grid_size + 5;
                })
                .style("text-anchor", "end");

            // label traits along the top
            group.append('g')
                .selectAll(".col-g")
                .data(phenotypeArray)
                .enter()
                .append('text')
                .attr("class", function (d, i) {
                    return "traitlabel r" + i;
                })
                .text(function (d, i) {
                    return traitName(i)
                })
                .attr('y', 30)
                .attr('x', spaceForVariantLabel-10)
                .attr("transform", function (d, i) {
                    return 'translate(' + i * grid_size + ',-20) rotate(-60)';
                });


            var rows = group.selectAll('g.cellr')
                .data(orgData.variantArrayOfArrayVariantPointers)
                .enter()
                .append('g')
                .attr('class', 'cellr')


            rows.selectAll('circle.cellg')
                .data(function (d, i) {
                    return d
                })
                .enter()
                .append('circle')
                .attr('class', 'cellg')
                .attr("cx", function (d, i) {
                    return d.t * grid_size + spaceForVariantLabel;
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

            var buildSvgContainer = function(parent, width, margin){
                if (typeof parent !== 'undefined'){
                    parent.attr("width", width + margin.left + margin.right);
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