
var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";



    mpgSoftware.locusZoom = (function (){
        var apiBase = 'https://portaldev.sph.umich.edu/api/v1/';
        var currentLzPlotKey = 'lz-47';
        var pageVars = {};

        var convertVarIdToUmichFavoredForm =  function (varId){
            // broad form example: 8_118183491_C_T
            // UM form example: 8:118183491_C/T
            var returnValue = varId;
            if (( typeof varId !== 'undefined')&&(varId.length>0)){
                var varIdSplit = varId.split("_");
                if (varIdSplit.length==4){
                    returnValue = varIdSplit[0]+":"+varIdSplit[1]+"_"+varIdSplit[2]+"/"+varIdSplit[3];
                }
            }
            return returnValue;
        };
        var convertVarIdToBroadFavoredForm =  function (varId){
            // broad form example: 8_118183491_C_T
            // UM form example: 8:118183491_C/T
            var extractedParts = extractParts(varId);

            var returnValue = extractedParts.chromosome+"_"+extractedParts.position+"_"+extractedParts.reference+"_"+extractedParts.alternate;

            return returnValue;
        };

        var extractParts =  function (varId){
            // broad form example: 8_118183491_C_T
            // UM form example: 8:118183491_C/T
            var returnValue = {};
            if (( typeof varId !== 'undefined')&&(varId.length>0)){
                var broadIdSplit = varId.split("_");
                if (broadIdSplit.length==4){
                    returnValue = {"chromosome":broadIdSplit[0],
                                    "position":broadIdSplit[1],
                                    "reference":broadIdSplit[2],
                                    "alternate":broadIdSplit[3]};
                } else {
                    var umIdSplit1 = varId.split("_");
                    if (umIdSplit1.length!=2){console.log("Unexpected var ID format: "+varId+".")}
                    var umIdSplit2 = umIdSplit1[0].split(":");
                    if (umIdSplit2.length!=2){console.log("Unexpected var ID format: "+varId+".")}
                    var umIdSplit3 = umIdSplit1[1].split("/");
                    if (umIdSplit3.length!=2){console.log("Unexpected var ID format: "+varId+".")}
                    returnValue = {"chromosome":umIdSplit2[0],
                        "position":umIdSplit2[1],
                        "reference":umIdSplit3[0],
                        "alternate":umIdSplit3[1]};
                }
            }
            return returnValue;
        };

        var weHaveAssociatedAtacSeqInfo = function (label){
            var retval;
            if (label.indexOf('Adipose')>-1){
                return 'Adipose';
            } else if (label.indexOf('Islet')>-1){
                return 'Islet1';
            } else if (label.indexOf('SkeletalMuscle')>-1){
                return 'Skeleta';
            } else if (label.indexOf('GM12878')>-1){
                return 'gm12878';
            } else if (label.indexOf('Adipose')>-1){
                return 'Adipose';
            }
            return retval;
        }

        var setPageVars = function (thisPageVars,pageVarOption){
            if (typeof pageVarOption !== 'undefined') {
                pageVars[pageVarOption] = thisPageVars;
            } else {
                pageVars = thisPageVars;
            }
        };
        var getPageVars = function (pageVarOption){
            var returnVar={};
            if (typeof pageVars[pageVarOption] !== 'undefined'){
                returnVar = pageVars[pageVarOption];
            } else {
                returnVar = pageVars;
            }

            return returnVar;
        };


        var customIntervalsToolTip = function (namespace){
            var htmlRef = "{{"+namespace+":state_name}}<br>"+"{{"+namespace+":start}}-"+"{{"+namespace+":end}}";
            var developingStructure =  {
                namespace: { "intervals": namespace },
                closable: false,
                show: { or: ["highlighted", "selected"] },
                hide: { and: ["unhighlighted", "unselected"] }
            };
            developingStructure['html'] = htmlRef;
            return developingStructure;
        }


        var standardDashBoadWithoutMove = function(){
            return  {
                components: [
                    {
                        type: "remove_panel",
                        position: "right",
                        color: "red",
                        group_position: "end"
                    },
                    {
                        type: "toggle_split_tracks",
                        data_layer_id: layerName,
                        position: "right"
                    }
                ]
            }
        }

        LocusZoom.Layouts.add("data_layer", "recomb_rate_filled", {
            namespace: { "recomb": "recomb" },
            id: "recombratenew",
            type: "filledCurve",
            fields: ["{{namespace[recomb]}}position", "{{namespace[recomb]}}recomb_rate"],
            z_index: 1,
            style: {
                "stroke": "#0000FF",
                "stroke-width": "1.5px"
            },
            x_axis: {
                field: "{{namespace[recomb]}}position"
            },
            y_axis: {
                axis: 2,
                field: "{{namespace[recomb]}}recomb_rate",
                floor: 0,
                ceiling: 100
            }
        });


        LocusZoom.DataLayers.add("filledCurve", function(layout){

            // Define a default layout for this DataLayer type and merge it with the passed argument
            this.DefaultLayout = {
                style: {
                    fill: "#0000ff",
                    "stroke-width": "2px"
                },
                interpolate: "linear",
                x_axis: { field: "x" },
                y_axis: { field: "y", axis: 1 },
                hitarea_width: 5
            };
            layout = LocusZoom.Layouts.merge(layout, this.DefaultLayout);

            // Var for storing mouse events for use in tool tip positioning
            this.mouse_event = null;

            // Var for storing the generated line function itself
            this.line = null;

            this.tooltip_timeout = null;

            // Apply the arguments to set LocusZoom.DataLayer as the prototype
            LocusZoom.DataLayer.apply(this, arguments);

            // Helper function to get display and data objects representing
            // the x/y coordinates of the current mouse event with respect to the line in terms of the display
            // and the interpolated values of the x/y fields with respect to the line
            this.getMouseDisplayAndData = function(){
                var ret = {
                    display: {
                        x: d3.mouse(this.mouse_event)[0],
                        y: null
                    },
                    data: {},
                    slope: null
                };
                var x_field = this.layout.x_axis.field;
                var y_field = this.layout.y_axis.field;
                var x_scale = "x_scale";
                var y_scale = "y" + this.layout.y_axis.axis + "_scale";
                ret.data[x_field] = this.parent[x_scale].invert(ret.display.x);
                var bisect = d3.bisector(function(datum) { return +datum[x_field]; }).left;
                var index = bisect(this.data, ret.data[x_field]) - 1;
                var startDatum = this.data[index];
                var endDatum = this.data[index + 1];
                var interpolate = d3.interpolateNumber(+startDatum[y_field], +endDatum[y_field]);
                var range = +endDatum[x_field] - +startDatum[x_field];
                ret.data[y_field] = interpolate((ret.data[x_field] % range) / range);
                ret.display.y = this.parent[y_scale](ret.data[y_field]);
                if (this.layout.tooltip.x_precision){
                    ret.data[x_field] = ret.data[x_field].toPrecision(this.layout.tooltip.x_precision);
                }
                if (this.layout.tooltip.y_precision){
                    ret.data[y_field] = ret.data[y_field].toPrecision(this.layout.tooltip.y_precision);
                }
                ret.slope = (this.parent[y_scale](endDatum[y_field]) - this.parent[y_scale](startDatum[y_field]))
                    / (this.parent[x_scale](endDatum[x_field]) - this.parent[x_scale](startDatum[x_field]));
                return ret;
            };

            // Reimplement the positionTooltip() method to be line-specific
            this.positionTooltip = function(id){
                if (typeof id != "string"){
                    throw ("Unable to position tooltip: id is not a string");
                }
                if (!this.tooltips[id]){
                    throw ("Unable to position tooltip: id does not point to a valid tooltip");
                }
                var tooltip = this.tooltips[id];
                var tooltip_box = tooltip.selector.node().getBoundingClientRect();
                var arrow_width = 7; // as defined in the default stylesheet
                var border_radius = 6; // as defined in the default stylesheet
                var stroke_width = parseFloat(this.layout.style["stroke-width"]) || 1;
                var page_origin = this.getPageOrigin();
                var data_layer_height = this.parent.layout.height - (this.parent.layout.margin.top + this.parent.layout.margin.bottom);
                var data_layer_width = this.parent.layout.width - (this.parent.layout.margin.left + this.parent.layout.margin.right);
                var top, left, arrow_top, arrow_left, arrow_type;

                // Determine x/y coordinates for display and data
                var dd = this.getMouseDisplayAndData();

                // If the absolute value of the slope of the line at this point is above 1 (including Infinity)
                // then position the tool tip left/right. Otherwise position top/bottom.
                if (Math.abs(dd.slope) > 1){

                    // Position horizontally on the left or the right depending on which side of the plot the point is on
                    if (dd.display.x <= this.parent.layout.width / 2){
                        left = page_origin.x + dd.display.x + stroke_width + arrow_width + stroke_width;
                        arrow_type = "left";
                        arrow_left = -1 * (arrow_width + stroke_width);
                    } else {
                        left = page_origin.x + dd.display.x - tooltip_box.width - stroke_width - arrow_width - stroke_width;
                        arrow_type = "right";
                        arrow_left = tooltip_box.width - stroke_width;
                    }
                    // Position vertically centered unless we're at the top or bottom of the plot
                    if (dd.display.y - (tooltip_box.height / 2) <= 0){ // Too close to the top, push it down
                        top = page_origin.y + dd.display.y - (1.5 * arrow_width) - border_radius;
                        arrow_top = border_radius;
                    } else if (dd.display.y + (tooltip_box.height / 2) >= data_layer_height){ // Too close to the bottom, pull it up
                        top = page_origin.y + dd.display.y + arrow_width + border_radius - tooltip_box.height;
                        arrow_top = tooltip_box.height - (2 * arrow_width) - border_radius;
                    } else { // vertically centered
                        top = page_origin.y + dd.display.y - (tooltip_box.height / 2);
                        arrow_top = (tooltip_box.height / 2) - arrow_width;
                    }

                } else {

                    // Position horizontally: attempt to center on the mouse's x coordinate
                    // pad to either side if bumping up against the edge of the data layer
                    var offset_right = Math.max((tooltip_box.width / 2) - dd.display.x, 0);
                    var offset_left = Math.max((tooltip_box.width / 2) + dd.display.x - data_layer_width, 0);
                    left = page_origin.x + dd.display.x - (tooltip_box.width / 2) - offset_left + offset_right;
                    var min_arrow_left = arrow_width / 2;
                    var max_arrow_left = tooltip_box.width - (2.5 * arrow_width);
                    arrow_left = (tooltip_box.width / 2) - arrow_width + offset_left - offset_right;
                    arrow_left = Math.min(Math.max(arrow_left, min_arrow_left), max_arrow_left);

                    // Position vertically above the line unless there's insufficient space
                    if (tooltip_box.height + stroke_width + arrow_width > dd.display.y){
                        top = page_origin.y + dd.display.y + stroke_width + arrow_width;
                        arrow_type = "up";
                        arrow_top = 0 - stroke_width - arrow_width;
                    } else {
                        top = page_origin.y + dd.display.y - (tooltip_box.height + stroke_width + arrow_width);
                        arrow_type = "down";
                        arrow_top = tooltip_box.height - stroke_width;
                    }
                }

                // Apply positions to the main div
                tooltip.selector.style({ left: left + "px", top: top + "px" });
                // Create / update position on arrow connecting tooltip to data
                if (!tooltip.arrow){
                    tooltip.arrow = tooltip.selector.append("div").style("position", "absolute");
                }
                tooltip.arrow
                    .attr("class", "lz-data_layer-tooltip-arrow_" + arrow_type)
                    .style({ "left": arrow_left + "px", top: arrow_top + "px" });

            };


            // Implement the main render function
            this.render = function(){

                // Several vars needed to be in scope
                var data_layer = this;
                var panel = this.parent;
                var x_field = this.layout.x_axis.field;
                var y_field = this.layout.y_axis.field;
                var x_scale = "x_scale";
                var y_scale = "y" + this.layout.y_axis.axis + "_scale";


                // Join data to the line selection
                var selection = this.svg.group
                    .selectAll("path.lz-data_layer-line")
                    .data([this.data]);

                // Create path element, apply class
                this.path = selection.enter()
                    .append("path")
                    .attr("class", "lz-data_layer-line");

                //define the area under the line
                this.line = d3.svg.area()
                    .x(function(d) { return parseFloat(panel[x_scale](d[x_field])); })
                    .y0(function(d) {return parseFloat(panel[y_scale](0));})
                    .y1(function(d) { return parseFloat(panel[y_scale](d[y_field])); })
                    .interpolate(this.layout.interpolate);


                // Apply line and style
                if (this.canTransition()){
                    selection
                        .transition()
                        .duration(this.layout.transition.duration || 0)
                        .ease(this.layout.transition.ease || "cubic-in-out")
                        .attr("d", this.line)
                        .style(this.layout.style);
                } else {
                    selection
                        .attr("d", this.line)
                        .style(this.layout.style);

                }


                // Apply tooltip, etc
                if (this.layout.tooltip){
                    // Generate an overlaying transparent "hit area" line for more intuitive mouse events
                    var hitarea_width = parseFloat(this.layout.hitarea_width).toString() + "px";
                    var hitarea = this.svg.group
                        .selectAll("path.lz-data_layer-line-hitarea")
                        .data([this.data]);
                    hitarea.enter()
                        .append("path")
                        .attr("class", "lz-data_layer-line-hitarea")
                        .style("stroke-width", hitarea_width);
                    var hitarea_line = d3.svg.line()
                        .x(function(d) { return parseFloat(panel[x_scale](d[x_field])); })
                        .y(function(d) { return parseFloat(panel[y_scale](d[y_field])); })
                        .interpolate(this.layout.interpolate);
                    hitarea
                        .attr("d", hitarea_line)
                        .on("mouseover", function(){
                            clearTimeout(data_layer.tooltip_timeout);
                            data_layer.mouse_event = this;
                            var dd = data_layer.getMouseDisplayAndData();
                            data_layer.createTooltip(dd.data);
                        })
                        .on("mousemove", function(){
                            clearTimeout(data_layer.tooltip_timeout);
                            data_layer.mouse_event = this;
                            var dd = data_layer.getMouseDisplayAndData();
                            data_layer.updateTooltip(dd.data);
                            data_layer.positionTooltip(data_layer.getElementId());
                        })
                        .on("mouseout", function(){
                            data_layer.tooltip_timeout = setTimeout(function(){
                                data_layer.mouse_event = null;
                                data_layer.destroyTooltip(data_layer.getElementId());
                            }, 300);
                        });
                    hitarea.exit().remove();
                }

                // Remove old elements as needed
                selection.exit().remove();
            };

            // Redefine setElementStatus family of methods as line data layers will only ever have a single path element
            this.setElementStatus = function(status, element, toggle){
                return this.setAllElementStatus(status, toggle);
            };
            this.setElementStatusByFilters = function(status, toggle){
                return this.setAllElementStatus(status, toggle);
            };
            this.setAllElementStatus = function(status, toggle){
                // Sanity check
                if (typeof status == "undefined" || LocusZoom.DataLayer.Statuses.adjectives.indexOf(status) == -1){
                    throw("Invalid status passed to DataLayer.setAllElementStatus()");
                }
                if (typeof this.state[this.state_id][status] == "undefined"){ return this; }
                if (typeof toggle == "undefined"){ toggle = true; }

                // Update global status flag
                this.global_statuses[status] = toggle;

                // Apply class to path based on global status flags
                var path_class = "lz-data_layer-line";
                Object.keys(this.global_statuses).forEach(function(global_status){
                    if (this.global_statuses[global_status]){ path_class += " lz-data_layer-line-" + global_status; }
                }.bind(this));
                this.path.attr("class", path_class);

                // Trigger layout changed event hook
                this.parent.emit("layout_changed");
                this.parent_plot.emit("layout_changed");

                return this;
            };

            return this;

        });





// Toggle Split Tracks
        LocusZoom.Dashboard.Components.add("toggle_detail_tracks", function(layout){
            LocusZoom.Dashboard.Component.apply(this, arguments);
            if (!layout.data_layer_id){ layout.data_layer_id = "intervals"; }
            if (!this.parent_panel.data_layers[layout.data_layer_id]){
                throw ("Dashboard toggle split tracks component missing valid data layer ID");
            }
            this.update = function(){
                var data_layer = this.parent_panel.data_layers[layout.data_layer_id];
                var text = data_layer.layout.split_tracks ? "Hide DNase reads" : "Show DNase reads";
                if (this.button){
                    this.button.setHtml(text);
                    this.button.show();
                    this.parent.position();
                    return this;
                } else {
                    this.button = new LocusZoom.Dashboard.Component.Button(this)
                        .setColor(layout.color).setHtml(text)
                        .setTitle("Toggle whether or not tracks are split apart or merged together")
                        .setOnclick(function(){
                            //alert('display detailed tracks');
                            var pageVars = getPageVars('#'+this.parent_plot.id);
                            if ((typeof pageVars.getLocusZoomFilledPlotUrl !== 'undefined') &&
                                (pageVars.getLocusZoomFilledPlotUrl !== 'junk')){
                                var tissueId = this.parent_panel.id.substr("intervals-".length).split('-')[0];
                                addLZTissueChromatinAccessibility({
                                    tissueCode: tissueId,
                                    tissueDescriptiveName: 'Reads in '+this.parent_panel.title.text(),
                                    getLocusZoomFilledPlotUrl:pageVars.getLocusZoomFilledPlotUrl,
                                    phenoTypeName:pageVars.phenoTypeName,
                                    domId1:pageVars.domId1,
                                    assayId:'DNase'
                                },pageVars.domId1,pageVars);
                            }
                            this.update();
                        }.bind(this));
                    return this.update();
                }
            };
        });




        LocusZoom.Dashboard.Components.add("toggle_h3kdetail_tracks", function(layout){
            LocusZoom.Dashboard.Component.apply(this, arguments);
            if (!layout.data_layer_id){ layout.data_layer_id = "intervals"; }
            if (!this.parent_panel.data_layers[layout.data_layer_id]){
                throw ("Dashboard toggle split tracks component missing valid data layer ID");
            }
            this.update = function(){
                var data_layer = this.parent_panel.data_layers[layout.data_layer_id];
                var text = data_layer.layout.split_tracks ? "Hide H3K27ac reads" : "Show H3K27ac reads";
                if (this.button){
                    this.button.setHtml(text);
                    this.button.show();
                    this.parent.position();
                    return this;
                } else {
                    this.button = new LocusZoom.Dashboard.Component.Button(this)
                        .setColor(layout.color).setHtml(text)
                        .setTitle("Toggle whether or not tracks are split apart or merged together")
                        .setOnclick(function(){
                            //alert('display detailed tracks');
                            var pageVars = getPageVars('#'+this.parent_plot.id);
                            if ((typeof pageVars.getLocusZoomFilledPlotUrl !== 'undefined') &&
                                (pageVars.getLocusZoomFilledPlotUrl !== 'junk')){
                                var tissueId = this.parent_panel.id.substr("intervals-".length).split('-')[0];
                                addLZTissueChromatinAccessibility({
                                    tissueCode: tissueId,
                                    tissueDescriptiveName: 'Reads in '+this.parent_panel.title.text(),
                                    getLocusZoomFilledPlotUrl:pageVars.getLocusZoomFilledPlotUrl,
                                    phenoTypeName:pageVars.phenoTypeName,
                                    domId1:pageVars.domId1,
                                    assayId:'H3K27ac'
                                },pageVars.domId1,pageVars);
                            }

                            data_layer.toggleSplitTracks();
                            if (this.scale_timeout){ clearTimeout(this.scale_timeout); }
                            var timeout = data_layer.layout.transition ? +data_layer.layout.transition.duration || 0 : 0;
                            this.scale_timeout = setTimeout(function(){
                                this.parent_panel.scaleHeightToData();
                                this.parent_plot.positionPanels();
                            }.bind(this), timeout);
                            this.update();
                        }.bind(this));
                    return this.update();
                }
            };
        });

        LocusZoom.Dashboard.Components.add("toggle_atacData_tracks", function(layout){
            LocusZoom.Dashboard.Component.apply(this, arguments);
            if (!layout.data_layer_id){ layout.data_layer_id = "intervals"; }
            if (!this.parent_panel.data_layers[layout.data_layer_id]){
                throw ("Dashboard toggle split tracks component missing valid data layer ID");
            }
            this.update = function(){
                var data_layer = this.parent_panel.data_layers[layout.data_layer_id];
                var text = data_layer.layout.split_tracks ? "Hide ATAC-seq reads" : "Show ATAC-seq reads";
                if (this.button){
                    this.button.setHtml(text);
                    this.button.show();
                    this.parent.position();
                    return this;
                } else {
                    this.button = new LocusZoom.Dashboard.Component.Button(this)
                        .setColor(layout.color).setHtml(text)
                        .setTitle("Toggle whether or not tracks are split apart or merged together")
                        .setOnclick(function(){
                            //alert('display detailed tracks');
                            var pageVars = getPageVars('#'+this.parent_plot.id);
                            if ((typeof pageVars.getLocusZoomFilledPlotUrl !== 'undefined') &&
                                (pageVars.getLocusZoomFilledPlotUrl !== 'junk')){
                                var tissueId = this.parent_panel.id.substr("intervals-".length).split('-')[0];
                                addLZTissueChromatinAccessibility({
                                    tissueCode: 'E00'+weHaveAssociatedAtacSeqInfo(tissueId),
                                    tissueDescriptiveName: 'Reads in '+this.parent_panel.title.text(),
                                    getLocusZoomFilledPlotUrl:pageVars.getLocusZoomFilledPlotUrl,
                                    phenoTypeName:pageVars.phenoTypeName,
                                    domId1:pageVars.domId1,
                                    assayId:'Varshney17'
                                },pageVars.domId1,pageVars);
                            }

                            data_layer.toggleSplitTracks();
                            if (this.scale_timeout){ clearTimeout(this.scale_timeout); }
                            var timeout = data_layer.layout.transition ? +data_layer.layout.transition.duration || 0 : 0;
                            this.scale_timeout = setTimeout(function(){
                                this.parent_panel.scaleHeightToData();
                                this.parent_plot.positionPanels();
                            }.bind(this), timeout);
                            this.update();
                        }.bind(this));
                    return this.update();
                }
            };
        });





        // epigenetic tracks built from bed data, Intended for the Parker HMM tracks
        var customIntervalsDataLayer = function (layerName){
            var stateIdSpec = layerName+":state_id";
            var developingStructure =  {
                namespace: { "intervals": layerName },
                id: layerName,
                type: "intervals",
                fields: [layerName+":start",layerName+":end",layerName+":state_id",layerName+":state_name"],
                id_field: layerName+":start",
                start_field: layerName+":start",
                end_field: layerName+":end",
                track_split_field: layerName+":state_id",
                split_tracks: false,
                always_hide_legend: true,
                color: {
                    field: layerName+":state_id",
                    scale_function: "categorical_bin",
                    parameters: {
                        categories: [1,2,3,4,5,6,7,8,9,10,11,12,13],
                        values: ["rgb(255,0,0)",
                            "rgb(255,140,26)",
                            "rgb(255,140,26)",
                            "rgb(0,230,0)",
                            "rgb(0,100,0)",
                            "rgb(194,225,5)",
                            "rgb(255,195,77)",
                            "rgb(255,195,77)",
                            "rgb(255,255,0)",
                            "rgb(255,255,0)",
                            "rgb(128,128,128)",
                            "rgb(192,192,192)",
                            "rgb(221,221,221)"],
                        null_value: "#B8B8B8"
                    }
                },
                legend: [
                    { shape: "rect", color: "rgb(255,0,0)", width: 9, label: "Active transcription start site" },
                    { shape: "rect", color: "rgb(255,140,26)", width: 9, label: "Weak transcription start site" },
                    { shape: "rect", color: "rgb(255,140,26)", width: 9, label: "Flanking transcription start site" },
                    { shape: "rect", color: "rgb(0,230,0)", width: 9, label: "Strong transcription" },
                    { shape: "rect", color: "rgb0,100,0)", width: 9, label: "Weak transcription" },
                    { shape: "rect", color: "rgb(194,225,5)", width: 9, label: "Genic enhancer" },
                    { shape: "rect", color: "rgb(255,195,77)", width: 9, label: "Active enhancer 1" },
                    { shape: "rect", color: "rgb(255,195,77)", width: 9, label: "Active enhancer 2" },
                    { shape: "rect", color: "rgb(255,255,0)", width: 9, label: "Weak enhancer" },
                    { shape: "rect", color: "rgb(255,255,0)", width: 9, label: "Bivalent poised TSS" },
                    { shape: "rect", color: "rgb(128,128,128)", width: 9, label: "Repressed polycomb" },
                    { shape: "rect", color: "rgb(192,192,192)", width: 9, label: "Weak repressed polycomb" },
                    { shape: "rect", color: "rgb(221,221,221)", width: 9, label: "Quiescent low signal" }
                ],
                behaviors: {
                    onmouseover: [
                        { action: "set", status: "highlighted" }
                    ],
                    onmouseout: [
                        { action: "unset", status: "highlighted" }
                    ],
                    onclick: [
                        { action: "toggle", status: "selected", exclusive: true }
                    ],
                    onshiftclick: [
                        { action: "toggle", status: "selected" }
                    ]
                }
                 // ,
                 // tooltip: customIntervalsToolTip(layerName)
            };
            _.forEach(developingStructure.legend,function(o,i){
                o[stateIdSpec] = (i+1);
            });
            return developingStructure;
        };


        var customIBDIntervalsDataLayer = function (layerName){
            var stateIdSpec = layerName+":state_id";
            var developingStructure =  {
                namespace: { "intervals": layerName },
                id: layerName,
                type: "intervals",
                fields: [layerName+":start",layerName+":end",layerName+":state_id",layerName+":state_name"],
                id_field: layerName+":start",
                start_field: layerName+":start",
                end_field: layerName+":end",
                track_split_field: layerName+":state_id",
                split_tracks: false,
                always_hide_legend: true,
                color: {
                    field: layerName+":state_id",
                    scale_function: "categorical_bin",
                    parameters: {
                        categories: [1,2,3],
                        values: ["rgb(255,0,0)",// 1=H3k27AC
                            "rgb(0,0,255)",//2=DNase
                            "rgb(0,255,0)"],//3=For the Parker data -- we shouldn't see this result here

                        null_value: "#B8B8B8"
                    }
                },
                legend: [
                    { shape: "rect", color: "rgb(255,0,0)", width: 9, label: "Active transcription start site" },
                    { shape: "rect", color: "rgb(255,140,26)", width: 9, label: "Weak transcription start site" },
                    { shape: "rect", color: "rgb(255,140,26)", width: 9, label: "Flanking transcription start site" },
                    { shape: "rect", color: "rgb(0,230,0)", width: 9, label: "Strong transcription" },
                    { shape: "rect", color: "rgb0,100,0)", width: 9, label: "Weak transcription" },
                    { shape: "rect", color: "rgb(194,225,5)", width: 9, label: "Genic enhancer" },
                    { shape: "rect", color: "rgb(255,195,77)", width: 9, label: "Active enhancer 1" },
                    { shape: "rect", color: "rgb(255,195,77)", width: 9, label: "Active enhancer 2" },
                    { shape: "rect", color: "rgb(255,255,0)", width: 9, label: "Weak enhancer" },
                    { shape: "rect", color: "rgb(255,255,0)", width: 9, label: "Bivalent poised TSS" },
                    { shape: "rect", color: "rgb(128,128,128)", width: 9, label: "Repressed polycomb" },
                    { shape: "rect", color: "rgb(192,192,192)", width: 9, label: "Weak repressed polycomb" },
                    { shape: "rect", color: "rgb(221,221,221)", width: 9, label: "Quiescent low signal" }
                ],
                behaviors: {
                    onmouseover: [
                        { action: "set", status: "highlighted" }
                    ],
                    onmouseout: [
                        { action: "unset", status: "highlighted" }
                    ],
                    onclick: [
                        { action: "toggle", status: "selected", exclusive: true }
                    ],
                    onshiftclick: [
                        { action: "toggle", status: "selected" }
                    ]
                }
            };
            _.forEach(developingStructure.legend,function(o,i){
                o[stateIdSpec] = (i+1);
            });
            return developingStructure;
        };



        // Chromatin state data, currently Parker 2013
        var customIntervalsPanel = function (layerName){
            return {   id: layerName,
                    width: 1000,
                    height: 50,
                    min_width: 500,
                    min_height: 50,
                    margin: { top: 25, right: 150, bottom: 5, left: 20 },
                dashboard: (function(){
                    //var l = standardDashBoadWithoutMove();
                    var l = LocusZoom.Layouts.get("dashboard", "standard_panel", { unnamespaced: true });
                    l.components.push({
                        type: "toggle_split_tracks",
                        data_layer_id: layerName,
                        position: "right"
                    });
                    if ((typeof weHaveAssociatedAtacSeqInfo(layerName) !== 'undefined')){
                        l.components.push({
                            type: "toggle_atacData_tracks",
                            data_layer_id: layerName,
                            position: "right"
                        });
                    }


                    return l;
                })(),
                    axes: {},
                interaction: {
                    drag_background_to_pan: true,
                        scroll_to_zoom: true,
                        x_linked: true
                },
                legend: {
                    hidden: true,
                        orientation: "horizontal",
                        origin: { x: 50, y: 0 },
                    pad_from_bottom: 5
                },
                data_layers: [
                    customIntervalsDataLayer(layerName)
                ]
            }
        };


        var customIbdIntervalsPanel = function (layerName,assayName){
            return {   id: layerName,
                width: 1000,
                height: 50,
                min_width: 500,
                min_height: 50,
                margin: { top: 25, right: 150, bottom: 5, left: 20 },
                dashboard: (function(){
                    //var l = standardDashBoadWithoutMove();
                    var l = LocusZoom.Layouts.get("dashboard", "standard_panel", { unnamespaced: true });
                    if (assayName === "DNase") {
                        l.components.push({
                            type: "toggle_detail_tracks",
                            data_layer_id: layerName,
                            position: "right"
                        });
                    }
                    if (assayName === "H3K27ac") {
                        l.components.push({
                            type: "toggle_h3kdetail_tracks",
                            data_layer_id: layerName,
                            position: "right"
                        });
                    }
                    return l;
                })(),
                axes: {},
                interaction: {
                    drag_background_to_pan: true,
                    scroll_to_zoom: true,
                    x_linked: true
                },
                legend: {
                    hidden: true,
                    orientation: "horizontal",
                    origin: { x: 50, y: 0 },
                    pad_from_bottom: 5
                },
                data_layers: [
                    customIBDIntervalsDataLayer(layerName)
                ]
            }
        };




        var customCurveDataLayer = function (layerName,assayId){
            var stateIdSpec = layerName+":state_id";
            var color = "#FF0000";
            if (assayId==="DNase" || assayId==="Varshney17"){
                color = "#0000FF";
            }
            var developingStructure = {
                namespace: {layerName: layerName},
                id: "recombratenew",
                type: "filledCurve",
                fields: [layerName+":position", layerName+":pvalue"],
                z_index: 1,
                style: {
                    "stroke": color,
                    "stroke-width": "1.5px"
                },
                x_axis: {
                    field: layerName+":position"
                },
                y_axis: {
                    axis: 1,
                    field: layerName+":pvalue"
                }
            };
            return developingStructure;
        };


        var customCurvePanel = function (layerName,assayId){
            var accessorName = layerName.split(":")[0];
           return { id: layerName,
            width: 800,
            height: 225,
            min_width:  400,
            min_height: 200,
            proportional_width: 1,
            margin: { top: 35, right: 50, bottom: 40, left: 20 },
            inner_border: "rgb(210, 210, 210)",
            dashboard: (function(){
                var l = LocusZoom.Layouts.get("dashboard", "standard_panel", { unnamespaced: true });
                l.components.push({
                    type: "toggle_legend",
                    position: "right"
                });
                return l;
            })(),
            axes: {
                x: {
                    label: "Chromosome {{chr}} (Mb)",
                    label_offset: 32,
                    tick_format: "region",
                    extent: "state"
                },
                y1: {
                    label: "Density",
                    label_offset: 28
                }
            },
            legend: {
                orientation: "vertical",
                origin: { x: 55, y: 40 },
                hidden: true
            },
            interaction: {
                drag_background_to_pan: true,
                drag_x_ticks_to_scale: true,
                drag_y1_ticks_to_scale: true,
                drag_y2_ticks_to_scale: true,
                scroll_to_zoom: true,
                x_linked: true
            },
            data_layers: [
                customCurveDataLayer(accessorName,assayId)
            ]
        }
        };




        var initLocusZoomLayout = function(){
            var mods = {
                namespace: {
                    default: "assoc"
                }
                ,
                panel_ids_by_y_index: ['genes']
            };
            var newLayout = LocusZoom.Layouts.get("plot", "interval_association", mods);

            // Add covariates model button/menu to the plot-level dashboard
            newLayout.dashboard.components.push({
                type: "covariates_model",
                button_html: "Model",
                button_title: "Use this feature to interactively build a model using variants from the data set",
                position: "left"
            });
            newLayout.panels = [newLayout.panels[2]];
            newLayout.panels[0].y_index = 1000;
            return newLayout;
        };








        var buildAccessibilityLayout = function ( accessibilityPanelName,phenotypeName,assayId){
            var addendumToName = '';
            var mods = {
                id: accessibilityPanelName,
                title: { text: "chromatin accessibility in Aorta"},
                namespace: { assoc: phenotypeName }
            };
            var panel_layout = customCurvePanel(accessibilityPanelName + ":id",assayId);
            //panel_layout.y_index = -1;
            panel_layout.height = 210;
            panel_layout.data_layers[0].id = accessibilityPanelName;
            panel_layout.data_layers[0].id_field = accessibilityPanelName+":start"

            return panel_layout;
        };





        var arbitraryCredibleSetColors = function (index){
            var returnValue = "#111111";
            switch (index){
                case 0:
                    returnValue = "#FF0000";
                    break;
                case 1:
                    returnValue = "#00FF00";
                    break;
                case 2:
                    returnValue = "#0000FF";
                    break;
                case 3:
                    returnValue = "#00FFFF";
                    break;
                case 4:
                    returnValue = "#FF00FF";
                    break;
                case 5:
                    returnValue = "#FFFF00";
                    break;
                case 6:
                    returnValue = "#000000";
                    break;
            }
            return returnValue
        };






        var buildPanelLayout = function (colorBy,positionBy, phenotype,makeDynamic,dataSetName,variantInfoLink,lzParameters){
            var pageVars = getPageVars(currentLzPlotKey);
            var toolTipText = "<strong><a href="+variantInfoLink+"/?lzId={{" + phenotype + ":id}} target=_blank>{{" + phenotype + ":id}}</a></strong><br>";
            if (positionBy==1) {
                toolTipText += "P Value: <strong>{{" + phenotype + ":pvalue|scinotation}}</strong><br>";
            } else if (positionBy==2) {
                toolTipText += "Post. prob: <strong>{{" + phenotype + ":pvalue|scinotation}}</strong><br>";
            }
            toolTipText +=  "Ref. Allele: <strong>{{" + phenotype + ":refAllele}}</strong><br>";
            if ((typeof makeDynamic !== 'undefined') &&
                (makeDynamic==='dynamic')){
                toolTipText += "<a onClick=\"mpgSoftware.locusZoom.conditioning(this);\" style=\"cursor: pointer;\">Condition on this variant</a><br>";
            }
            toolTipText += "<a onClick=\"mpgSoftware.locusZoom.expandedView(this,'"+lzParameters.domId1+"','"+lzParameters.assayIdList+"');\" style=\"cursor: pointer;\">Expanded view</a><br>";

            if (typeof pageVars.excludeLdIndexVariantReset !== 'undefined'){
                if (pageVars.excludeLdIndexVariantReset === false){
                    toolTipText += "<a onClick=\"mpgSoftware.locusZoom.replaceTissues(this,'"+lzParameters.domId1+"','"+lzParameters.assayIdList+"');\" style=\"cursor: pointer;\">Tissues with overlapping enhancer regions</a><br>";
                    toolTipText += "<a onClick=\"mpgSoftware.locusZoom.changeLDReference('{{" + phenotype + ":id}}', '" + phenotype + "', '" + dataSetName + "');\" style=\"cursor: pointer;\">Make LD Reference</a>";
                } else {
                    toolTipText += "<a onClick=\"mpgSoftware.locusZoom.replaceTissues(this,'"+lzParameters.domId1+"','"+lzParameters.assayIdList+"');\" style=\"cursor: pointer;\">Display tissues with overlapping regions</a><br>";
                }
            } else {
                toolTipText += "<a onClick=\"mpgSoftware.locusZoom.changeLDReference('{{" + phenotype + ":id}}', '" + phenotype + "', '" + dataSetName + "');\" style=\"cursor: pointer;\">Make LD Reference</a>";
            }



            //colorBy=1;

            var yAxisScale1;
            var yAxisScale2;
            var yAxisLabel = "";
            if (positionBy ===1){
                yAxisScale1 = phenotype + ":pvalue|scinotation";
                yAxisScale2 = phenotype + ":pvalue|neglog10";
                yAxisLabel = "p-value";
            }
            if (positionBy === 2){
                yAxisScale1 = phenotype + ":pvalue|scinotation";
                yAxisScale2 = phenotype + ":pvalue";
                yAxisLabel = 'posterior probability';
            }

            var addendumToName = '';
            if ( typeof lzParameters.datasetReadableName !== 'undefined'){
                addendumToName = (" ("+lzParameters.datasetReadableName+")");
            }
            var mods = {
                id: phenotype+dataSetName,
                title: { text: lzParameters.description+addendumToName},
                namespace: { assoc: phenotype }
            };
            var panel_layout = LocusZoom.Layouts.get("panel","association", mods);



            if ((typeof pageVars.credSetToVariants !== 'undefined') &&
                (pageVars.credSetToVariants.length>0)&&
                (pageVars.credSetToVariants[0].credSetName!=='none')){
                panel_layout.dashboard.components.push(
                    {
                        type: "display_options",
                        position: "right",
                        color: "blue",
                        // Below: special config specific to this widget
                        button_html: "Display options...",
                        button_title: "Control how plot items are displayed",

                        layer_name: "associationpvalues",
                        default_config_display_name: "annotation (default)", // display name for the default plot color option (allow user to revert to plot defaults)

                        options: [
                            {
                                // Second option. The same plot- or even the same field- can be colored in more than one way.
                                display_name: "credible set",
                                display: {
                                    point_shape: "circle",
                                    point_size: 40,
                                    color: {
                                        field: "assoc:credSetId",
                                        scale_function: "categorical_bin",
                                        parameters: {
                                            categories: [0, 1,2,3,4,5,6],
                                            values: [arbitraryCredibleSetColors (0),
                                                arbitraryCredibleSetColors (1),
                                                arbitraryCredibleSetColors (2),
                                                arbitraryCredibleSetColors (3),
                                                arbitraryCredibleSetColors (4),
                                                arbitraryCredibleSetColors (5),
                                                "#000000"],
                                            null_value: "#B8B8B8"
                                        }
                                    },
                                    legend: [
                                    ]
                                }
                            }
                        ]
                    }
                );
                var emptyLegendArray = _.last(panel_layout.dashboard.components).options[0].display.legend;
                _.forEach(pageVars.credSetToVariants, function (credSetObject, count){
                    var oneLegend = { shape: "circle",
                        color: arbitraryCredibleSetColors (count),
                        size: 40,
                        label: credSetObject.credSetName,
                        class: "lz-data_layer-scatter" };
                    emptyLegendArray.push(oneLegend);
                });
            }

            // add legend elements to refer to individual credible sets



            panel_layout.axes.y1.label = yAxisLabel;
            panel_layout.y_index = -1;
            panel_layout.height = 270;
            panel_layout.data_layers[2].fields = [phenotype + ":id",
                phenotype + ":position",
                yAxisScale1,
                yAxisScale2,
                phenotype + ":refAllele",
                phenotype + ":analysis",
                phenotype + ":scoreTestStat",
                "ld:state",
                "ld:isrefvar"
            ];
            panel_layout.data_layers[2].id_field = phenotype + ":id";
            switch (positionBy){
                case 1:
                    panel_layout.data_layers[2].y_axis.field = yAxisScale2;
                    break;
                case 2:
                    panel_layout.data_layers[2].y_axis.field = yAxisScale2;
                    panel_layout.data_layers[2].y_axis.min_extent= [0, 0.001];
                    break;
                default: break;
            }
            switch (colorBy){
                case 1:
                    panel_layout.data_layers[2].color = [
                                {
                                    scale_function: "if",
                                    field: "ld:isrefvar",
                                    parameters: {
                                    field_value: 1,
                                        then: "#9632b8"
                                }
                                },
                                {
                                    scale_function: "numerical_bin",
                                    field: "ld:state",
                                    parameters: {
                                        breaks: [0, 0.2, 0.4, 0.6, 0.8],
                                        values: ["#357ebd","#46b8da","#5cb85c","#eea236","#d43f3a"]
                                    }
                                }
                                ,
                                // {
                                //     scale_function: "categorical_bin",
                                //     field: phenotype + ":scoreTestStat",
                                //     parameters: {
                                //         categories: ["1","2","3","4","5"],
                                //         values: ["#ff0000", "#00ff00", "#0000ff", "#ffcc00", "#111111"]
                                //     }
                                // },
                    "#c8c8c8"];
                    if (lzParameters.domId1!=='#lz-47') { // KLUDGE ALERT!   we have to give a different legend in the case of the variant info page.
                        panel_layout.data_layers[2].legend = [  { shape: "circle", color: "#ff0000", size: 40, label: "PTV", class: "lz-data_layer-scatter" },
                            { shape: "circle", color: "#00ff00", size: 40, label: "missense", class: "lz-data_layer-scatter" },
                            { shape: "circle", color: "#0000ff", size: 40, label: "coding", class: "lz-data_layer-scatter" },
                            { shape: "circle", color: "#ffcc00", size: 40, label: "non-coding", class: "lz-data_layer-scatter" } ];
                    }
                    break;
                case 2:
                    panel_layout.data_layers[2].color = [
                        {
                            scale_function: "categorical_bin",
                            field: phenotype + ":scoreTestStat",
                            parameters: {
                                categories: ["1","2","3","4","5"],
                                values: ["#ff0000", "#00ff00", "#0000ff", "#ffcc00", "#111111"]
                            }
                        },
                        {
                            scale_function: "if",
                            field: "ld:isrefvar",
                            parameters: {
                                field_value: 1,
                                then: "#9632b8"
                            }
                        },
                        "#B8B8B8"
                    ];
                    panel_layout.data_layers[2].legend = [  { shape: "circle", color: "#ff0000", size: 40, label: "PTV", class: "lz-data_layer-scatter" },
                        { shape: "circle", color: "#00ff00", size: 40, label: "missense", class: "lz-data_layer-scatter" },
                        { shape: "circle", color: "#0000ff", size: 40, label: "coding", class: "lz-data_layer-scatter" },
                        { shape: "circle", color: "#ffcc00", size: 40, label: "non-coding", class: "lz-data_layer-scatter" } ];
                    break;
                default:
                    panel_layout.data_layers[2].point_shape = [
                        {
                            scale_function: "categorical_bin",
                            field: phenotype + ":scoreTestStat",
                            parameters: {
                                categories: ["1","2","3","4","5"],
                                values: ["triangle", "square", "diamond", "circle", "square"]
                            }
                        },
                        "circle"
                    ];
                    break;
            }
            panel_layout.data_layers[2].tooltip.html = toolTipText;
            return panel_layout;
        };


        var setNewDefaultLzPlot = function (key){
        currentLzPlotKey  = key;
    };
        var getNewDefaultLzPlot = function (){
            return currentLzPlotKey;
        };


        // these get defined when the LZ plot is initialized
        var locusZoomPlot = {};
        var standardLayout = {};
        var dataSources = {};

        function conditioning(myThis) {
            locusZoomPlot[currentLzPlotKey].CovariatesModel.add(LocusZoom.getToolTipData(myThis));
            LocusZoom.getToolTipData(myThis).deselect();
        }

        var retrieveFunctionalData = function(callingData,callback,additionalData){
            var pageVars = getPageVars(currentLzPlotKey);
            // var includeRecord = callingData.includeRecord;
            $.ajax({
                cache: false,
                type: "post",
                url: pageVars.retrieveFunctionalDataAjaxUrl,
                data: {
                    chromosome: callingData.CHROM,
                    startPos: ""+callingData.POS,
                    endPos: ""+callingData.POS,
                    lzFormat:0,
                    assayIdList:callingData.ASSAY_ID_LIST
                },
                async: true
            }).done(function (data, textStatus, jqXHR) {

                callback(data,additionalData);


            }).fail(function (jqXHR, textStatus, errorThrown) {
                core.errorReporter(jqXHR, errorThrown)
            });
        };

        var processIbdEpigeneticData = function (data,additionalData){
            var matchedTissue = _.filter(data.variants.variants,additionalData.includeRecord);
            var plotId = getNewDefaultLzPlot();
            if (typeof additionalData.plotDomId !== 'undefined') {
                plotId = additionalData.plotDomId;
            }
            _.forEach(matchedTissue,function(o,i){
                var derivedAssayName = "unspecified";
                if (o.ASSAY_ID === 1){
                    derivedAssayName = "H3K27ac";
                } else if (o.ASSAY_ID === 2){
                    derivedAssayName = "DNase";
                }
                addLZTissueAnnotations({
                    tissueCode: o.source,
                    tissueDescriptiveName: o.source_trans,
                    retrieveFunctionalDataAjaxUrl:getPageVars([currentLzPlotKey]).retrieveFunctionalDataAjaxUrl,
                    assayName: derivedAssayName,
                    assayIdList:"["+ o.ASSAY_ID+"]"
                },plotId,additionalData);
            });
        };
        var buildMultiTrackDisplay  = function(     allUniqueElementNames,
                                                    allUniqueTissueNames,
                                                    dataMatrix,
                                                    selector,
                                                    additionalParams ){
            var correlationMatrix = dataMatrix;
            var xlabels = additionalParams.xLabels;
            var ylabels = allUniqueTissueNames;
            var margin = {top: 50, right: 50, bottom: 100, left: 250},
                width = 750 - margin.left - margin.right,
                height = 800 - margin.top - margin.bottom;
            var multiTrack = baget.multiTrack()
                .height(height)
                .width(width)
                .margin(margin)
                .renderCellText(0)
                .xlabelsData(xlabels)
                .ylabelsData(ylabels)
                .startColor('#ffffff')
                .endColor('#3498db')
                .endRegion(additionalParams.regionEnd)
                .startRegion(additionalParams.regionStart)
                .xAxisLabel('genomic position')
                .mappingInfo(additionalParams.mappingInformation)
                .dataHanger(selector, correlationMatrix);
            d3.select(selector).call(multiTrack.render);
        };
        var buildExpandedDisplay  = function(data,additionalData){
            var renderData = UTILS.processChromatinStateData(data);
            if (renderData.recordsExist) {
                buildMultiTrackDisplay(renderData.uniqueElements,
                    renderData.uniqueTissues,
                    renderData.arrayOfArraysGroupedByTissue,
                    '#chromatinStateDisplay',
                    {   regionStart:renderData.regionStart,
                        regionEnd:renderData.regionEnd,
                        xLabels:renderData.uniqueElements,
                        mappingInformation:renderData.dataMatrix});
            }
        }
        function expandedView(myThis) {
            var lzMyThis = LocusZoom.getToolTipData(myThis);
            // remove the old tissue tracks
            var tooltipContents = lzMyThis.getDataLayer().parent_plot.container.lastChild.innerHTML;
            var callingData = {};
            callingData.POS = _.find(lzMyThis,function(v,k){return (k.indexOf('position')!==-1)});
            callingData.CHROM = extractParts(_.find(lzMyThis,function(v,k){return (k.indexOf('id')!==-1)})).chromosome;
             lzMyThis.getDataLayer().parent_plot.container.lastChild.innerHTML  =  tooltipContents +
                '<div id="chromatinStateDisplay"></div>';
            retrieveFunctionalData(callingData,buildExpandedDisplay,callingData);
            //LocusZoom.getToolTipData(myThis).deselect();
            // figure out the tissues we need
        }
        function replaceTissues(myThis,domId,assayIdList) {
            var lzMyThis = LocusZoom.getToolTipData(myThis);
            // remove the old tissue tracks
            var tissueTracks = _.filter(lzMyThis.getDataLayer().parent_plot.panels,function(v,k){return (k.indexOf('intervals')===0)});
            _.forEach(tissueTracks, function (panel){
                panel.dashboard.hide(true);
                d3.select(panel.parent.svg.node().parentNode).on("mouseover." + panel.getBaseId() + ".dashboard", null);
                d3.select(panel.parent.svg.node().parentNode).on("mouseout." + panel.getBaseId() + ".dashboard", null);
                return panel.parent.removePanel(panel.id);
            });
            LocusZoom.getToolTipData(myThis).deselect();
            var chromosome;
            var varId = _.find(lzMyThis,function(v,k){return (k.indexOf('id')!==-1)});
            chromosome = extractParts(varId).chromosome;
            replaceTissuesWithOverlappingIbdRegions( _.find(lzMyThis,function(v,k){return (k.indexOf('position')!==-1)}),
                                                   chromosome,domId,assayIdList, varId );
        }
        var replaceTissuesWithOverlappingIbdRegions = function(position, chromosome,plotDomId,assayIdList,varId){
            var callingData = {};
            callingData.POS = position;
            callingData.CHROM = chromosome;
            callingData.plotDomId = plotDomId;
            callingData.ASSAY_ID_LIST = "["+mpgSoftware.regionInfo.getSelectorAssayIds().join(",")+"]";
            var lzVar = mpgSoftware.locusZoom.locusZoomPlot[plotDomId];
            // var includeRecord  = function() {return true;};
            // if (assayIdList=='[3]') {
            //     //includeRecord = function(o) {return ((o.element.indexOf('nhancer')>-1))};
            //     includeRecord = mpgSoftware.regionInfo.includeRecordBasedOnUserChoice;
            // }
            callingData.includeRecord = mpgSoftware.regionInfo.includeRecordBasedOnUserChoice;
            // erase any old tissue tracks
            var tissueTracks = _.filter(lzVar.panels,function(v,k){return (k.indexOf('intervals')===0)});
            _.forEach(tissueTracks, function (panel){
                panel.dashboard.hide(true);
                d3.select(panel.parent.svg.node().parentNode).on("mouseover." + panel.getBaseId() + ".dashboard", null);
                d3.select(panel.parent.svg.node().parentNode).on("mouseout." + panel.getBaseId() + ".dashboard", null);
                panel.parent.removePanel(panel.id);
            });
            $('#spinner').show();
            setTimeout(
                function() {
                    $('#spinner').hide();
                }, 2000);

            retrieveFunctionalData(callingData,processIbdEpigeneticData,callingData);
            if (( typeof varId !== 'undefined')&&
                (varId.length>0)){
                mpgSoftware.regionInfo.markHeaderAsCurrentlyDisplayed(varId);
                mpgSoftware.locusZoom.changeCurrentReference(varId);
            }
        };

        var replaceTissuesWithOverlappingEnhancersFromVarId = function(varId,plotDomId,assayIdList){
            var convertedVarId=convertVarIdToUmichFavoredForm(varId); // convert if necessary
            mpgSoftware.regionInfo.specificHeaderToBeActiveByVarId(convertedVarId);
            var variantParts = extractParts(varId);
            mpgSoftware.regionInfo.setIncludeRecordBasedOnUserChoice(assayIdList);
            replaceTissuesWithOverlappingIbdRegions(variantParts.position, variantParts.chromosome,plotDomId,assayIdList,convertedVarId);
            mpgSoftware.regionInfo.removeAllCredSetHeaderPopUps();

        };
        var replaceTissuesWithOverlappingIbdRegionsVarId = function(varId,plotDomId,assayIdList){
            var convertedVarId=convertVarIdToUmichFavoredForm(varId); // convert if necessary
            var variantParts = extractParts(varId);
            replaceTissuesWithOverlappingIbdRegions(variantParts.position, variantParts.chromosome,plotDomId,assayIdList,varId);

        };


        function conditionOnVariant(variantId, phenotype,datasetName) {
            locusZoomPlot[currentLzPlotKey].curtain.show('Loading...', {'text-align': 'center'});
            // locusZoomPlot[currentLzPlotKey].panels[phenotype+datasetName].data_layers.positions.destroyAllTooltips();
            locusZoomPlot[currentLzPlotKey].state[phenotype+datasetName+".positions"].selected = [];
            var newStateObject = {
                condition_on_variant: variantId
            };
            locusZoomPlot[currentLzPlotKey].applyState(newStateObject);
        }


        function changeCurrentReference(variantId) {
            var newStateObject = {
                ldrefvar: variantId
            };
            locusZoomPlot[currentLzPlotKey].applyState(newStateObject);
        }



        function changeLDReference(variantId, phenotype,datasetName) {
            locusZoomPlot[currentLzPlotKey].curtain.show('Loading...', {'text-align': 'center'});
            changeCurrentReference(variantId);
        }

        var buildAssociationSource = function(dataSources,geneGetLZ,phenotype, rawPhenotype,dataSetName,propertyName,makeDynamic){
            var broadAssociationSource = LocusZoom.Data.Source.extend(function (init, rawPhenotype,dataSetName,propertyName,makeDynamic) {
                var pageVars = getPageVars(mpgSoftware.locusZoom.getNewDefaultLzPlot());
                this.parseInit(init);
                this.getURL = function (state, chain, fields) {
                    var url = this.url + "?" +
                        "chromosome=" + state.chr + "&" +
                        "start=" + state.start + "&" +
                        "end=" + state.end + "&" +
                        "phenotype=" + rawPhenotype + "&" +
                        "dataset=" + dataSetName + "&" +
                        "propertyName=" + propertyName + "&" +
                        "datatype="+ makeDynamic;

                    //console.log("position marker?  start=" + state.start  +"end=" + state.end + "&")

                    if ((typeof state.model !== 'undefined')&&(state.model.covariates.length)){
                        var covariant_ids = "";
                        state.model.covariates.forEach(function(covariant){
                            _.forEach(covariant,function(v,k){
                                if ((k.substr(k.length-3))===':id'){
                                    covariant_ids += (covariant_ids.length ? "," : "") + v.replace(/[^0-9ATCG]/g,"_");
                                }
                            });
                        });
                        url += "&conditionVariantId=" + covariant_ids;
                    }
                    if ((typeof pageVars.maximumNumberOfResults !== 'undefined') &&(pageVars.maximumNumberOfResults>0)){
                        url += "&maximumNumberOfResults=" + pageVars.maximumNumberOfResults;
                    }
                    return url;
                };
                this.prepareData = function(records){
                //
                //     // Below is an example of how we might use UM's latest in order to assign credible set definitions.  For now
                //     //  I will leave it commented out.
                //
                //     // The first step is to find the key that points to the values
                //     var pValueKeyName;
                //     if ((records) &&
                //         (records.length>0)){
                //         _.forEach(records[0], function (value,key){
                //             if (key.indexOf('pvalue|neglog10')>-1){
                //                 pValueKeyName = key;
                //             }
                //
                //         })
                //     }
                //     // everything else comes right out of the UM example, which I found by going to this URL (http://statgen.github.io/locuszoom/examples/credible_sets.html)
                //     // and then looking at the browser console to see what they were actually doing
                //     //
                //     // Calculate raw bayes factors and posterior probabilities based on information returned from the API
                //     if (typeof pValueKeyName !== 'undefined') {
                //         var nlogpvals = records.map(function (item) {
                //             return item[pValueKeyName];
                //         });
                //         var scores = gwasCredibleSets.scoring.bayesFactors(nlogpvals);
                //         var posteriorProbabilities = gwasCredibleSets.scoring.normalizeProbabilities(scores);
                //
                //         // Use scores to mark the credible set in various ways (depending on your visualization preferences,
                //         //    some of these may be unneeded)
                //         var credibleSet = gwasCredibleSets.marking.findCredibleSet(scores);
                //         var credSetScaled= gwasCredibleSets.marking.rescaleCredibleSet(credibleSet);
                //         var credSetBool = gwasCredibleSets.marking.markBoolean(credibleSet);
                //
                //         // Annotate each response record based on credible set membership
                //         records.forEach(function (item, index) {
                //             item["assoc:credibleSetPosteriorProb"] = posteriorProbabilities[index];
                //             item["assoc:credibleSetContribution"] = credSetScaled[index]; // Visualization helper: normalized to contribution within the set
                //             item["assoc:isCredible"] = credSetBool[index];
                //         });
                //         return records;
                //
                //     }
                //
                    var pageVars = getPageVars(mpgSoftware.locusZoom.getNewDefaultLzPlot());
                    var pValueKeyName;
                     if ((records) &&
                         (records.length>0)&&
                         ( typeof pageVars.credSetToVariants !== 'undefined')){
                         _.forEach(records[0], function (value,key){
                             if (key.indexOf(':id')>-1){
                                 pValueKeyName = key;
                             }

                         });

                         _.forEach(records, function (oneRecord){
                             var varId = convertVarIdToBroadFavoredForm(oneRecord[pValueKeyName]) ;
                             var substitutedVarId = varId;
                             _.forEach(pageVars.credSetToVariants,function(credSetObj,count){
                                 _.forEach(credSetObj.varIds,function(oneVariant){
                                    if (substitutedVarId===oneVariant){
                                        oneRecord["credSetName"] = credSetObj.credSetName;
                                        oneRecord["credSetId"] = count;
                                    }
                                 });
                             });


                         });
                     }

                    return records;
                 };
            }, "BroadT2Da");
            dataSources.add(phenotype, new broadAssociationSource(geneGetLZ, rawPhenotype,dataSetName,propertyName,makeDynamic));
        };

        var buildIntervalSource = function(dataSources,retrieveFunctionalDataAjaxUrl,rawTissue,intervalPanelName,assayName,assayIdList){
             var broadIntervalsSource = LocusZoom.Data.Source.extend(function (init, tissue,assayName) {
                this.parseInit(init);
                var assayId = 3;
                if (assayName == "DNase" ) {
                    assayId = 2;
                } else if (assayName == "H3K27ac" ) {
                    assayId = 1;
                }
                // if(typeof assayIdList !== 'undefined') {
                //     assayId = assayIdList;
                // }
                this.getURL = function (state, chain, fields) {
                    var url = this.url + "?" +
                        "chromosome=" + state.chr + "&" +
                        "startPos=" + state.start + "&" +
                        "endPos=" + state.end + "&" +
                        "source=" + tissue + "&" +
                        "assayId=" + assayId + "&" +
                        "assayIdList=" + assayIdList + "&" +
                        "lzFormat=1";
                    return url;
                };
            }, "BroadT2Db");
            //var tissueAsId = 'intervals-'+rawTissue;
            dataSources.add(intervalPanelName, new broadIntervalsSource(retrieveFunctionalDataAjaxUrl, rawTissue,assayName));
        };

        var buildChromatinAccessibilitySource = function(dataSources,getLocusZoomFilledPlotUrl,rawTissue,phenotype,dom1,assayId){
            var broadAccessibilitySource = LocusZoom.Data.Source.extend(function (init, tissue,dom1,assayId) {
                this.parseInit(init);
                this.getURL = function (state, chain, fields) {
                    var url = this.url + "?" +
                        "chromosome=" + state.chr + "&" +
                        "start=" + state.start + "&" +
                        "end=" + state.end + "&" +
                        "source=" + tissue + "&" +
                        "assay_id=" + assayId + "&" +
                        "lzFormat=1";
                    return url;
                };
            }, "BroadT2Dc");
            var tissueAsId = 'intervals-'+rawTissue+"-reads-"+dom1+"-"+assayId;
            dataSources.add(tissueAsId, new broadAccessibilitySource(getLocusZoomFilledPlotUrl, rawTissue,dom1,assayId));
        };




        var initLocusZoom = function(selector, variantIdString,retrieveFunctionalDataAjaxUrl) {
        // TODO - will need to test that incorrect input format doesn't throw JS exception which stops all JS activity
        // TODO - need to catch all exceptions to make sure rest of non LZ JS modules on page load properly (scope errors to this module)
        var newLayout = initLocusZoomLayout();
        standardLayout[currentLzPlotKey] = newLayout;
        if(variantIdString != '') {
            setNewDefaultLzPlot(selector);
            standardLayout[currentLzPlotKey].state = {
                ldrefvar: variantIdString
            };
        }
        var ds = new LocusZoom.DataSources();
        ds.add("constraint", ["GeneConstraintLZ", { url: "http://exac.broadinstitute.org/api/constraint" }])
            .add("assoc", ["AssociationLZ", {url: apiBase + "statistic/single/", params: {analysis: 3, id_field: "variant"}}])
            .add("ld", ["LDLZ" , apiBase + "pair/LD/"])
            .add("gene", ["GeneLZ", apiBase + "annotation/genes/"])
            .add("recomb", ["RecombLZ", { url: apiBase + "annotation/recomb/results/", params: {source: 15} }])
            .add("sig", ["StaticJSON", [{ "x": 0, "y": 4.522 }, { "x": 2881033286, "y": 4.522 }] ]);

        var lzp = LocusZoom.populate(selector, ds, standardLayout[currentLzPlotKey]);

        return {
            layoutPanels:lzp.layout.panels,
            locusZoomPlot: lzp,
            dataSources: ds
        };
    };


    var reorderPanels = function(plot){
        var currentPanelOrdering = plot.panel_ids_by_y_index;
        var newPanelOrdering = [];
        var intervalPanels = [];
        var genePanel = [];
        _.forEach(currentPanelOrdering, function (o){
            if (o==='genes'){
                genePanel.push(o);
            } else if (o.substr(0,"intervals-".length)==='intervals-'){
                intervalPanels.push(o);
            } else {
                newPanelOrdering.push(o);
            }
        });
        _.forEach(intervalPanels.sort(),function(o){newPanelOrdering.push(o)});
        _.forEach(genePanel,function(o){newPanelOrdering.push(o)});
        plot.panel_ids_by_y_index = newPanelOrdering;
    }

        var addAssociationTrack = function (locusZoomVar,colorBy,positionBy, phenotype,makeDynamic,dataSetName,variantInfoUrl,lzParameters){
            var panelLayout = buildPanelLayout(colorBy,positionBy, phenotype,makeDynamic,dataSetName,variantInfoUrl,lzParameters);
            panelLayout.y_index = 0;
            if ((positionBy==2)&&(panelLayout.data_layers[2].y_axis.field.indexOf('|')>-1)){
//                panelLayout.data_layers[2].y_axis.field=(panelLayout.data_layers[2].y_axis.field.substr(0,panelLayout.data_layers[2].y_axis.field.indexOf('|'))+'|unchanged');
            }
            locusZoomVar.addPanel(panelLayout).addBasicLoader();
            reorderPanels(locusZoomVar);
        };



        var addIntervalTrack = function(locusZoomVar,tissueName,tissueId,intervalPanelName,assayName){
           // var intervalPanelName = "intervals-"+tissueId+"-"+locusZoomVar.id;
            // we can't use the standard interval panel, but we can derive our own
            var pageVars = getPageVars(currentLzPlotKey);
            var intervalPanel;
            if (pageVars.portalTypeString=== 'ibd'){
                intervalPanel =  customIbdIntervalsPanel(intervalPanelName,assayName);
                intervalPanel.title = { text: tissueName+" "+assayName, style: {}, x: 0, y: 22 };
            } else {
                intervalPanel = customIntervalsPanel(intervalPanelName);
                intervalPanel.dashboard.components.push({
                    type: "menu",
                    color: "yellow",
                    position: "right",
                    button_html: "Track Info",
                    menu_html: "<strong>"+tissueName+" ChromHMM calls from Parker 2013</strong><br>Build: 37<br>Assay: ChIP-seq<br>Tissue: "+tissueName+"</div>"
                });
                intervalPanel.title = { text: tissueName, style: {}, x: 10, y: 22 };
            }



            if (typeof locusZoomPlot[currentLzPlotKey].panels[intervalPanelName] === 'undefined'){

                locusZoomVar.addPanel(intervalPanel).addBasicLoader();
            } else {
                console.log(' we already had a panel for tissue='+tissueId+'.')
            }
            reorderPanels(locusZoomVar);
        };


        var addChromatinAccessibilityTrack = function(locusZoomVar,tissueName,tissueId,phenotypeName,dom1,assayId){
            var accessibilityPanelName = "intervals-"+tissueId+"-reads-"+dom1+"-"+assayId;
            // we can't use the standard interval panel, but we can derive our own
            var accessibilityPanel = buildAccessibilityLayout(accessibilityPanelName,phenotypeName,assayId)
            accessibilityPanel.title = { text: tissueName, style: {}, x: 10, y: 22 };
            if (typeof locusZoomPlot[currentLzPlotKey].panels[accessibilityPanel] === 'undefined'){
                locusZoomVar.addPanel(accessibilityPanel).addBasicLoader();
            } else {
                console.log(' we already had a panel for tissue='+tissueId+'.')
            }
            reorderPanels(locusZoomVar);
        };




        function addLZPhenotype(lzParameters,  dataSetName, geneGetLZ,variantInfoUrl,makeDynamic,lzGraphicDomId,graphicalOptions) {
            var colorBy = 1;  //colorBy:1=LD,2=MDS
            var positionBy = 1;  //positionBy:1=pValue,2=posteriorPValue
            if (typeof graphicalOptions !== 'undefined') {
                colorBy = graphicalOptions.colorBy;
                positionBy = graphicalOptions.positionBy;
            }
            var rawPhenotype = lzParameters.phenotype;
            var phenotype = lzParameters.phenotype+"_"+makeDynamic+"_"+dataSetName;
            var propertyName = lzParameters.propertyName;
            var retrieveFunctionalDataAjaxUrl = lzParameters.retrieveFunctionalDataAjaxUrl;
            setNewDefaultLzPlot(lzGraphicDomId);

            buildAssociationSource(dataSources[currentLzPlotKey],geneGetLZ,phenotype, rawPhenotype,dataSetName,propertyName,makeDynamic);
            addAssociationTrack(locusZoomPlot[currentLzPlotKey],colorBy,positionBy, phenotype,makeDynamic,dataSetName,variantInfoUrl,lzParameters)


        };




        function addLZTissueAnnotations(lzParameters,  lzGraphicDomId, graphicalOptions) {
            var retrieveFunctionalDataAjaxUrl = lzParameters.retrieveFunctionalDataAjaxUrl;
            var tissueCode = lzParameters.tissueCode;
            var tissueDescriptiveName = lzParameters.tissueDescriptiveName;
            var assayName = lzParameters.assayName;
            var assayIdList = lzParameters.assayIdList;
            setNewDefaultLzPlot(lzGraphicDomId);
            var intervalPanelName = "intervals-"+tissueCode+"-"+lzGraphicDomId.substr(1);
            if (typeof assayName !== 'undefined') {
                intervalPanelName += ("-"+assayName);
            }


            buildIntervalSource(dataSources[currentLzPlotKey],retrieveFunctionalDataAjaxUrl,tissueCode,intervalPanelName,assayName,assayIdList);
            addIntervalTrack(locusZoomPlot[currentLzPlotKey],tissueDescriptiveName,tissueCode,intervalPanelName, assayName);

            rescaleSVG();
        };
        function addLZTissueChromatinAccessibility(lzParameters,  lzGraphicDomId, graphicalOptions) {
            var getLocusZoomFilledPlotUrl = lzParameters.getLocusZoomFilledPlotUrl;
            var tissueCode = lzParameters.tissueCode;
            var tissueDescriptiveName = lzParameters.tissueDescriptiveName;
            var phenotypeName = lzParameters.phenotypeName;
            var domId1 = lzParameters.domId1;
            var assayId = lzParameters.assayId;
            setNewDefaultLzPlot(lzGraphicDomId);

            if (domId1.substr(0,1)==='#') { domId1=domId1.substr(1)}
            buildChromatinAccessibilitySource(dataSources[currentLzPlotKey],getLocusZoomFilledPlotUrl,tissueCode,phenotypeName,domId1,assayId);
            addChromatinAccessibilityTrack(locusZoomPlot[currentLzPlotKey],tissueDescriptiveName,tissueCode,phenotypeName,domId1,assayId);

           rescaleSVG();

        };

        var initializeLZPage = function (inParm) {
            setPageVars(inParm,inParm.domId1);
            var loading = $('#spinner').show();
            var lzGraphicDomId = "#lz-1";
            var defaultPhenotypeName = "T2D";
            var dataSetName = inParm.locusZoomDataset;
            if (typeof inParm.domId1 !== 'undefined') {
                lzGraphicDomId = inParm.domId1;
            }
            setNewDefaultLzPlot(lzGraphicDomId);
            if (typeof inParm.phenoTypeName !== 'undefined') {
                defaultPhenotypeName = inParm.phenoTypeName;
            }
            $(inParm.domId1).empty();
            var chromosome = inParm.positionInfo.chromosome;
            // make sure we don't get a negative start point
            var startPosition = Math.max(0, inParm.positionInfo.startPosition);
            var endPosition = inParm.positionInfo.endPosition;

            var locusZoomInput = chromosome + ":" + startPosition + "-" + endPosition;
            $(lzGraphicDomId).attr("data-region", locusZoomInput);
            $("#lzRegion").text(locusZoomInput);
            loading.hide();

            var lzVarId = '';
            if ((inParm.page == 'variantInfo')&& (typeof inParm.variantId !== 'undefined') ) {
                lzVarId = inParm.variantId;
                // we have format: 8_118184783_C_T
                // need to get format like: 8:118184783_C/T
                lzVarId = convertVarIdToUmichFavoredForm(inParm.variantId);
            }

            if ((lzVarId.length > 0)||(typeof chromosome !== 'undefined') ) {

                var returned = mpgSoftware.locusZoom.initLocusZoom( lzGraphicDomId,
                                                                    lzVarId,
                                                                    inParm.retrieveFunctionalDataAjaxUrl);
                locusZoomPlot[currentLzPlotKey] = returned.locusZoomPlot;
                dataSources[currentLzPlotKey] = returned.dataSources;

                if (inParm.positionBy == 2){ // credset only
                    inParm.locusZoomDataset = inParm.sampleGroupsWithCredibleSetNames[0];
                    inParm.datasetReadableName = 'fine mapping';
                }


                // default panel
                addLZPhenotype({
                        assayIdList: inParm.assayIdList,
                        domId1: inParm.domId1,
                        phenotype: defaultPhenotypeName,
                        description: inParm.phenoTypeDescription,
                        propertyName:inParm.phenoPropertyName,
                        dataSet:inParm.locusZoomDataset,
                        datasetReadableName:inParm.datasetReadableName,
                        retrieveFunctionalDataAjaxUrl:inParm.retrieveFunctionalDataAjaxUrl
                },inParm.locusZoomDataset,inParm.geneGetLZ,inParm.variantInfoUrl,
                    inParm.makeDynamic,lzGraphicDomId,inParm);

                if (typeof inParm.functionalTrack !== 'undefined'){
                    if ( typeof inParm.defaultTissues !== 'undefined'){
                        _.forEach(inParm.defaultTissues,function(o,i){
                            if ((typeof inParm.experimentAssays === 'undefined')||
                                (inParm.experimentAssays.length === 0)){
                                addLZTissueAnnotations({
                                    tissueCode: o,
                                    tissueDescriptiveName: inParm.defaultTissuesDescriptions[i],
                                    retrieveFunctionalDataAjaxUrl:inParm.retrieveFunctionalDataAjaxUrl,
                                    assayIdList:"[3]"
                                },lzGraphicDomId,inParm);
                            } else {
                                var experimentOfInterests = _.find(inParm.experimentAssays, function (t){return (t.expt==o)});
                                if(typeof experimentOfInterests !== 'undefined'){
                                    _.forEach(experimentOfInterests.assays, function (assay){
                                        var assayId = 3;
                                        if (assay==='H3K27ac'){
                                            assayId = 1;
                                        } else if (assay==='DNase'){
                                            assayId = 2;
                                        }
                                        addLZTissueAnnotations({
                                            tissueCode: o,
                                            tissueDescriptiveName: inParm.defaultTissuesDescriptions[i],
                                            retrieveFunctionalDataAjaxUrl:inParm.retrieveFunctionalDataAjaxUrl,
                                            assayName: assay,
                                            assayIdList:"["+assayId+"]"
                                        },lzGraphicDomId,inParm);
                                    });
                                }
                             }

                        });
                    }

                }


                if ((typeof inParm.pageInitialization !== 'undefined')&&
                    (inParm.pageInitialization)){

                    $(inParm.collapsingDom).on("shown.bs.collapse", function () {
                        locusZoomPlot[currentLzPlotKey].rescaleSVG();
                    });

                    // var clearCurtain = function() {
                    //     locusZoomPlot[currentLzPlotKey].curtain.hide();
                    // };
                    // locusZoomPlot[currentLzPlotKey].on('data_rendered', clearCurtain);
                    "data_requested"
                }
                var clearCurtain = function() {
                    locusZoomPlot[inParm.domId1].curtain.hide();
                };
                locusZoomPlot[inParm.domId1].on('data_rendered', clearCurtain);
                var resetGenomicCoordinates = function() {
                    if ("#lz-lzCredSet"===inParm.domId1) { // in the credible set tab we allow people to drag around their data region window
                        var credSetStartPos = $('input.credSetStartPos').val();
                        var credSetEndPos = $('input.credSetEndPos').val();
                        var lzStart = ''+locusZoomPlot[inParm.domId1].state.start;
                        var lzEnd = ''+locusZoomPlot[inParm.domId1].state.end;
                        var somethingHasChanged = false;
                        if (credSetStartPos!==lzStart){
                            $('input.credSetStartPos').val(lzStart);
                            somethingHasChanged = true;
                        }
                        if (credSetEndPos!==lzEnd){
                            $('input.credSetEndPos').val(lzEnd);
                            somethingHasChanged = true;
                        }
                        if (somethingHasChanged){
                            mpgSoftware.regionInfo.redisplayTheCredibleSetHeatMap();
                        }
                    }
                };
                locusZoomPlot[inParm.domId1].on('data_requested', resetGenomicCoordinates);
            }
        };

    var rescaleSVG = function (plotChooser){
        var plotToReset = currentLzPlotKey;
        if (typeof plotChooser !== 'undefined'){
            plotToReset = plotChooser;
        }
        locusZoomPlot[plotToReset].rescaleSVG();
    };

    var removePanel = function (panelId){
        locusZoomPlot[currentLzPlotKey].removePanel(panelId);
    }
    var removeAllPanels = function (){
        _.forEach(locusZoomPlot[currentLzPlotKey].panel_ids_by_y_index,function(o){
            if ((typeof o !== 'undefined') && (o !== 'genes')){
                locusZoomPlot[currentLzPlotKey].removePanel(o);
            }
        });

    }

    var plotAlreadyExists = function (){
        return (typeof locusZoomPlot[currentLzPlotKey] !== 'undefined');
    }




    return {
        getNewDefaultLzPlot: getNewDefaultLzPlot,
        setNewDefaultLzPlot: setNewDefaultLzPlot,
        conditioning:conditioning,
        replaceTissues:replaceTissues,
        expandedView:expandedView,
        initLocusZoom : initLocusZoom,
        initializeLZPage:initializeLZPage,
        addLZPhenotype:addLZPhenotype,
        addLZTissueAnnotations:addLZTissueAnnotations,
        changeLDReference:changeLDReference,
        conditionOnVariant:conditionOnVariant,
        rescaleSVG:rescaleSVG,
        removePanel:removePanel,
        removeAllPanels:removeAllPanels,
        plotAlreadyExists: plotAlreadyExists,
        locusZoomPlot:locusZoomPlot,
        replaceTissuesWithOverlappingEnhancersFromVarId:replaceTissuesWithOverlappingEnhancersFromVarId,
        replaceTissuesWithOverlappingIbdRegionsVarId:replaceTissuesWithOverlappingIbdRegionsVarId,
        changeCurrentReference:changeCurrentReference,
        convertVarIdToBroadFavoredForm:convertVarIdToBroadFavoredForm
    }

}());
})();
