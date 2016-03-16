var baget = baget || {};  // encapsulating variable

(function () {


    baget.ColorManagementRoutines = function (colorScale) {

        var color = d3.scale.category20c();
        var colorCnt = 6;

        // Safety trick for constructors
        if (!(this instanceof baget.ColorManagementRoutines)) {
            return new baget.ColorManagementRoutines(colorScale);
        }

        // public methods
        this.colorArcFill = function (d) {
            var returnValue = new String();
            colorCnt++;

            if (( typeof d.ancestry !== 'undefined')&&
                ( typeof colorScale !== 'undefined'))
            {
                if (d.name === "/") { // root is special cased
                    return "#ffffff";
                } else if ((d.name.length > 4) && (d.name.substring(0, 4) === 'zzul')) {
                    return "#ffffff";
                }
                returnValue = colorScale(d.ancestry);
            } else {
                if ((d.name === "/") ||
                    ((d.name.length > 4) && (d.name.substring(0, 4) === 'zzul'))) { // root is special cased
                    return "#ffffff";
                } else {

                }
                returnValue = color(colorCnt % 20);//"#a8fafb";
            }
            return returnValue;
        };

        this.colorText = function (d) {
            if (((d.name.length > 4) && (d.name.substring(0, 4) === 'zzul'))) {
                return '#ffffff'
            } else {
                return '#000';
            }

        };
    };


    baget.TooltipHandler = function () {
        // Safety trick for constructors
        if (!(this instanceof baget.TooltipHandler)) {
            return new baget.TooltipHandler();
        }

        var tooltip = d3.select("body")
            .append("div")
            .style("opacity", "0")
            .style("position", "absolute")
            .style("z-index", "10")
            .attr("class", "toolTextAppearance");

        this.mouseOver = function (d) {
            if ((d.name != '/') &&
                (!(((d.name.length > 4) && (d.name.substring(0, 4) === 'zzul'))))) {
                tooltip.html(d.descr)
                    .transition()
                    .duration(200)
                    .style("opacity", "1");
                return;// tooltip.html(d.name + '<br/>' + 'active in ' + d.ac + '<br/>' + 'inactive in ' + d.inac);
            }
            else {
                return tooltip.html(null).style("opacity", "0");
            }

        };
        this.mouseMove = function (d) {
            if ((d.name === '/') || ((d.name.length > 4) && (d.name.substring(0, 4) === 'zzul'))) {
                return tooltip.html(null).style("opacity", "0");
            } else {
                return tooltip.style("top", (d3.event.pageY - 10) + "px")
                    .style("left", (d3.event.pageX + 10) + "px");
            }

        };
        this.mouseOut = function () {
            return tooltip.style("opacity", "0");
        };
    };


    baget.createASunburst = function (width, height, padding, duration, colorScale, domSelector, data) {


        var tooltipHandler = new baget.TooltipHandler();
        var colorManagementRoutines = new baget.ColorManagementRoutines(colorScale);
        var radius = Math.min(width, height) / 2;
        var hideOrDisplayColors = 1;


        var toggleColorDisplay = function () {
            if (hideOrDisplayColors === 1) {
                hideOrDisplayColors = 0;
            } else {
                hideOrDisplayColors = 1;
            }
        }

        var SunburstAnimation = function () {
                // Safety trick for constructors
                if (!(this instanceof SunburstAnimation)) {
                    return new SunburstAnimation();
                }

                // Need to keep track of how Zoomed we are
                var currentZoomLevel = 0;
                this.zoomLevel = function (newZoomLevel) {
                    if (newZoomLevel === undefined) {
                        return  currentZoomLevel;
                    } else {
                        currentZoomLevel = newZoomLevel;
                    }
                }


                this.arcTween = function (d) {
                    var my = maxY(d),
                        xd = d3.interpolate(x.domain(), [d.x, d.x + d.dx]),
                        yd = d3.interpolate(y.domain(), [d.y, my]),
                        yr = d3.interpolate(y.range(), [d.y ? 100 : 0, radius]);
                    return function (d) {
                        return function (t) {
                            x.domain(xd(t));
                            y.domain(yd(t)).range(yr(t));
                            return arc(d);
                        };
                    };
                };

                var maxY = function (d) {
                    return d.children ? Math.max.apply(Math, d.children.map(maxY)) : d.y + d.dy;
                }

                var isParentOf = function (p, c) {
                    if (p === c) return true;
                    if (p.children) {
                        return p.children.some(function (d) {
                            return isParentOf(d, c);
                        });
                    }
                    return false;
                };

                this.isParentOf = isParentOf;

            },
            sunburstAnimation = SunburstAnimation();


        var svg = d3.select(domSelector).append("svg")
            .attr("width", width)
            .attr("height", height)
            .append("g")
            .attr("transform", "translate(" + width / 2 + "," + (height / 2 ) + ")");


        var x = d3.scale.linear()
            .range([0, 2 * Math.PI]);

        var shift = function(x){
            return x;
        }

        var y = d3.scale.linear()
            .range([0, radius]);


        var partition = d3.layout.partition()
            .value(function (d) {
                return d.size;
            }).sort(function (a, b) {
                return d3.descending(a.name, b.name);
            });

        var arc = d3.svg.arc()
            .startAngle(function (d) {
                return Math.max(0, Math.min(2 * Math.PI, x(shift(d.x))));
            })
            .endAngle(function (d) {
                return Math.max(0, Math.min(2 * Math.PI, x(shift(d.x + d.dx))));
            })
            .innerRadius(function (d) {
                return Math.max(0, y(d.y));
            })
            .outerRadius(function (d) {
                return Math.max(0, y(d.y + d.dy));
            });

        // Method local to createASunburst to keep track of our depth
        var createIdForNode = function (incomingName) {
            var returnValue = 'null';
            var preliminaryGeneratedId = String(incomingName).replace(/\s/g, '_');
            if (preliminaryGeneratedId === '/') {
                returnValue = 'root';
            } else {
                returnValue = preliminaryGeneratedId;
            }
            return returnValue;
        }

        //
        // Change the cursor to zoom-in or zoom-out or nothing, all depending on the current expansion
        //  level of the sunburst.
        //
        var adjustSunburstCursor = function (d) {
            //
            // first deal with all non-root arcs
            //
            if (!(d.parent === undefined) && !(d.parent.name === undefined)) {
                sunburstAnimation.zoomLevel(d.depth);
                var parentName = d.parent.name;
                var nodeName = d.name;
                // reset the cursor for the last center of the sunburst, since it is no longer
                // ready to support a zoom out.  Note that this select statement will also grab
                // nny other stray classes indicating zoom out.
                var previousCenterpiece = d3.select('.indicateZoomOut');
                if (!(previousCenterpiece === undefined)) {
                    previousCenterpiece.classed('indicateZoomIn', true)
                        .classed('indicateZoomOut', false)
                        .classed('indicateNoZoomingPossible', false);
                }
                var arcThatWasLastZoomed = d3.selectAll('.indicateNoZoomingPossible');
                if (!(arcThatWasLastZoomed === undefined)) {
                    arcThatWasLastZoomed.classed('indicateNoZoomingPossible', function (d) {
                        return ((d.name === "/") && ((d.name.length > 4) && (d.name.substring(0, 4) === 'zzul')));
                    });
                    arcThatWasLastZoomed.classed('indicateZoomIn', function (d) {
                        return ((!(d.name === "/")) &&
                            (!((d.name.length > 4) && (d.name.substring(0, 4) === 'zzul'))));
                    });
                }
                // Now deal with the parent node, which DOES need to adopt
                // a cursor indicating that a zoom out is possible.
                var parentNode = d3.select('#' + createIdForNode(parentName));
                if (sunburstAnimation.zoomLevel() > 0) {
                    parentNode.classed('indicateZoomOut', true)
                        .classed('indicateZoomIn', false)
                        .classed('indicateNoZoomingPossible', false);
                }
                // Take the current arc ( the one that was clicked ) and
                // turn off any mouse handling at all, since After clicking an arc
                // it becomes fully expanded, and there is no purpose to clicking it again.
                var currentNode = d3.select('#' + createIdForNode(nodeName));
                currentNode.classed('indicateZoomOut', false)
                    .classed('indicateZoomIn', false)
                    .classed('indicateNoZoomingPossible', true);

            }  // next deal with the root arc, in case the user clicked it.
            else if (!(d === undefined) && !(d.name === undefined)) {  // Root node clicked -- reset mouse ptr
                sunburstAnimation.zoomLevel(d.depth);
                var nodeName = d.name;
                // whatever had no cursor needs to be turned on
                var arcThatWasLastZoomed = d3.selectAll('.indicateNoZoomingPossible');
                if (!(arcThatWasLastZoomed === undefined)) {
                    arcThatWasLastZoomed.classed('indicateNoZoomingPossible', function (d) {
                        return ((d.name === "/") && ((d.name.length > 4) && (d.name.substring(0, 4) === 'zzul')));
                    });
                    arcThatWasLastZoomed.classed('indicateZoomIn', function (d) {
                        return ((!(d.name === "/")) &&
                            (!((d.name.length > 4) && (d.name.substring(0, 4) === 'zzul'))));
                    });
                }
                // take the current arc and turn the cursor off
                var currentNode = d3.select('#' + createIdForNode(nodeName));
                currentNode.classed('indicateZoomOut', false)
                    .classed('indicateZoomIn', false)
                    .classed('indicateNoZoomingPossible', true);
            }
        }


        var path = svg.datum(data).selectAll("path")
            .data(partition.nodes)
            .enter().append("path")
            .attr("d", arc)
            .attr("id", function (d) {
                return createIdForNode(d.name);
            })
            .classed('indicateZoomIn', function (d) {
                return (d.depth || d.name != '/');
            })
            .classed('indicateNoZoomingPossible', function (d) {
                return (!(d.depth || d.name != '/'));
            })
            .style("stroke", function (d) {
                if ((d.name.length > 4) && (d.name.substring(0, 4) === 'zzul')) {
                    return '#ffffff';
                } else {
                    return '#000';
                }
            })
            .style("stroke-width", function (d) {
                if ((d.name.length > 4) && (d.name.substring(0, 4) === 'zzul')) {
                    return '0px';
                } else {
                    return '1px';
                }
            })
            .style("fill", function (d) {
                return colorManagementRoutines.colorArcFill(d);
            })
            .style("fill-opacity", function (d) {
                return hideOrDisplayColors;
            })
            .on("click", click)
            .on("mouseover", tooltipHandler.mouseOver)
            .on("mousemove", tooltipHandler.mouseMove)
            .on("mouseout", tooltipHandler.mouseOut);


        // d3.selectAll("[id^='zzul']").style('stroke','#ffffff') ;

        var text = svg.datum(data).selectAll("text").data(partition.nodes);


        // Interpolate the scales!
        function click(d) {
            adjustSunburstCursor(d);
            path.transition()
                .duration(duration)
                .attrTween("d", sunburstAnimation.arcTween(d));

            // Somewhat of a hack as we rely on arcTween updating the scales.
            text.style("visibility", function (e) {
                return sunburstAnimation.isParentOf(d, e) ? null : d3.select(this).style("visibility");
            })
                .transition()
                .duration(duration)
                .attrTween("text-anchor", function (d) {
                    return function () {
                        return x(shift(d.x + d.dx / 2)) > Math.PI ? "end" : "start";
                    };
                })
                .attrTween("transform", function (d) {
                    var multiline = (d.name || "").split(" ").length > 1;
                    return function () {
                        var angle = x(shift(d.x + d.dx / 2)) * 180 / Math.PI - 90,
                            rotate = angle + (multiline ? -.5 : 0);
                        return "rotate(" + rotate + ")translate(" + (y(d.y) + padding) + ")rotate(" + (angle > 90 ? -180 : 0) + ")";
                    };
                })
                .style("fill-opacity", function (e) {
                    return sunburstAnimation.isParentOf(d, e) ? 1 : 1e-6;
                })
                .each("end", function (e) {
                    d3.select(this).style("visibility", sunburstAnimation.isParentOf(d, e) ? null : "hidden");
                });
        }


        var textEnter = text.enter().append("svg:text")
            .style("fill-opacity", 1)
            .style("pointer-events", "none")
            .style("fill", function (d) {
                return  colorManagementRoutines.colorText(d);
            })
            .attr("text-anchor", function (d) {
                return x(shift(d.x + d.dx / 2)) > Math.PI ? "end" : "start";
            })
            .attr("dy", ".2em")
            .attr("transform", function (d) {
                var multiline = (d.name || "").split(" ").length > 1,
                    angle = x(shift(d.x + d.dx / 2)) * 180 / Math.PI - 90,
                    rotate = angle + (multiline ? -.5 : 0);
                return "rotate(" + rotate + ")translate(" + (y(d.y) + padding) + ")rotate(" + (angle > 90 ? -180 : 0) + ")";
            })
            .on("click", click);
//                    .on("mouseover", tooltipHandler.mouseOver)
//                    .on("mousemove", tooltipHandler.mouseMove)
//                    .on("mouseout",tooltipHandler.mouseOut );

        textEnter.append("tspan")
            .attr("x", 0)
            .text(function (d) {
                if ((d.depth) && (d.name.indexOf("zzul") === -1)) {
                    var displayName = ((typeof d.label !== 'undefined')  &&
                        (d.label.length > 0))?d.label: d.name;
                    return displayName.split(":")[0];
                } else {
                    return "";
                }
            });
        textEnter.append("tspan")
            .attr("x", 0)
            .attr("dy", "1em")
            .text(function (d) {
                if ((d.depth) && (d.name.indexOf("zzul") === -1)) {
                    var displayName = ((typeof d.label !== 'undefined')  &&
                        (d.label.length > 0))?d.label: d.name;
                    return displayName.split(":")[1] || "";
                } else {
                    return "";
                }
            });
//        textEnter.append("tspan")
//            .attr("x", 0)
//            .attr("dy", "1em")
//            .text(function (d) {
//                if ((d.depth) && (d.name.indexOf("zzul") === -1)) {
//                    var displayName = ((typeof d.label !== 'undefined')  &&
//                        (d.label.length > 0))?d.label: d.name;
//                    return displayName.split(" ")[2] || "";
//                } else {
//                    return "";
//                }
//            });
//        textEnter.append("tspan")
//            .attr("x", 0)
//            .attr("dy", "1em")
//            .text(function (d) {
//                if ((d.depth) && (d.name.indexOf("zzul") === -1)) {
//                    var displayName = ((typeof d.label !== 'undefined')  &&
//                        (d.label.length > 0))?d.label: d.name;
//                    return displayName.split(" ")[3] || "";
//                } else {
//                    return "";
//                }
//            });


//            d3.select(self.frameElement).style("height", height + "px");

    }


})();