
var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";



    mpgSoftware.locusZoom = (function (){
        var apiBase = 'https://portaldev.sph.umich.edu/api/v1/';
        var currentLzPlotKey = 'lz-47';


    // var createStandardLayout = function(){
    //   this.layout = {
    //       responsive_resize: true,
    //       min_width: 600,
    //       min_height: 150,
    //       width: 600,
    //       height: 150,
    //     aspect_ratio: 5,
    //     dashboard: {
    //         components: [
    //             { type: "title", title: "LocusZoom", position: "left" },
    //             { type: "covariates_model", button_html: "Model", button_title: "Click to view/remove covariates from this plot's model", position: "left" },
    //             { type: "dimensions", position: "right" },
    //             { type: "region_scale", position: "right" },
    //             { type: "download", position: "right" }
    //         ]
    //     },
    //     panels: [
    //         {
    //             id: 'genes',
    //             margin: { top: 20, right: 50, bottom: 20, left: 50 },
    //             axes: {},
    //             dashboard: {
    //                 components: [
    //                     { type: "move_panel_up", position: "right" },
    //                     { type: "move_panel_down", position: "right" }
    //                 ]
    //             },
    //             interaction: {
    //                 drag_background_to_pan: true,
    //                 drag_x_ticks_to_scale: true,
    //                 drag_y1_ticks_to_scale: true,
    //                 drag_y2_ticks_to_scale: true,
    //                 scroll_to_zoom: true,
    //                 x_linked: true
    //             },
    //             data_layers: [
    //                 {
    //                     id: 'genes',
    //                     type: "genes",
    //                     fields: ["gene:gene", "constraint:constraint"],
    //                     id_field: "gene_id",
    //                     selectable: "one",
    //                     highlighted: {
    //                         onmouseover: "on",
    //                         onmouseout: "off"
    //                     },
    //                     selected: {
    //                         onclick: "toggle_exclusive",
    //                         onshiftclick: "toggle"
    //                     },
    //                     tooltip: {
    //                         closable: true,
    //                         show: { or: ["highlighted", "selected"] },
    //                         hide: { and: ["unhighlighted", "unselected"] },
    //                         html: "<h4><strong><i>{{gene_name}}</i></strong></h4>"
    //                             + "<div style=\"float: left;\">Gene ID: <strong>{{gene_id}}</strong></div>"
    //                             + "<div style=\"float: right;\">Transcript ID: <strong>{{transcript_id}}</strong></div>"
    //                             + "<div style=\"clear: both;\"></div>"
    //                             + "<table>"
    //                             + "<tr><th>Constraint</th><th>Expected variants</th><th>Observed variants</th><th>Const. Metric</th></tr>"
    //                             + "<tr><td>Synonymous</td><td>{{exp_syn}}</td><td>{{n_syn}}</td><td>z = {{syn_z}}</td></tr>"
    //                             + "<tr><td>Missense</td><td>{{exp_mis}}</td><td>{{n_mis}}</td><td>z = {{mis_z}}</td></tr>"
    //                             + "<tr><td>LoF</td><td>{{exp_lof}}</td><td>{{n_lof}}</td><td>pLI = {{pLI}}</td></tr>"
    //                             + "</table>"
    //                             + "<div style=\"width: 100%; text-align: right;\"><a href=\"http://gnomad.broadinstitute.org/gene/{{gene_id}}\" target=\"_new\">More data on gnomAD</a></div>"
    //                     }
    //                 }
    //             ]
    //         }
    //     ]
    // }
    // };

        var initLocusZoomLayout = function(){
            var mods = {
                namespace: {
                    default: "assoc",
                    // ld: "ld",
                    // gene: "gene",
                    // recomb: "recomb",
//                    intervals: "intervals"
                }
            };
            var newLayout = LocusZoom.Layouts.get("plot", "interval_association", mods);
            // Update HTML for variant tooltip to include "Add to Model" link
            //newLayout.panels[0].data_layers[2].tooltip.html = "<strong>{{assoc:variant}}</strong><br>"
            //    + "P Value: <strong>{{assoc:log_pvalue|logtoscinotation}}</strong><br>"
            //    + "Ref. Allele: <strong>{{assoc:ref_allele}}</strong><br>"
            //    + "<a href=\"javascript:void(0);\" onclick=\"LocusZoom.getToolTipPlot(this).CovariatesModel.add(LocusZoom.getToolTipData(this));\">Add to Model</a><br>";

            // Add covariates model button/menu to the plot-level dashboard
            newLayout.dashboard.components.push({
                type: "covariates_model",
                button_html: "Model",
                button_title: "Use this feature to interactively build a model using variants from the data set",
                position: "left"
            });
            // Add a track information button to the intervals panel
            newLayout.panels[1].dashboard.components.push({
                type: "menu",
                color: "yellow",
                position: "right",
                button_html: "Track Info",
                menu_html: "<strong>Pancreatic islet chromHMM calls from Parker 2013</strong><br>Build: 37<br>Assay: ChIP-seq<br>Tissue: pancreatic islet</div>"
            });

            return newLayout;
        };

    var setNewDefaultLzPlot = function (key){
        currentLzPlotKey  = key;
    }
    
    var initLocusZoom = function(selector, variantIdString) {
        // TODO - will need to test that incorrect input format doesn't throw JS exception which stops all JS activity
        // TODO - need to catch all exceptions to make sure rest of non LZ JS modules on page load properly (scope errors to this module)
        //standardLayout[currentLzPlotKey] =  (new createStandardLayout()).layout;
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
            .add("sig", ["StaticJSON", [{ "x": 0, "y": 4.522 }, { "x": 2881033286, "y": 4.522 }] ])
            .add("intervals", ["IntervalLZ", { url: apiBase + "annotation/intervals/results/", params: {source: 16} }]);
        var lzp = LocusZoom.populate(selector, ds, standardLayout[currentLzPlotKey]);

        // Create event hooks to clear the loader whenever a panel renders new data
        lzp.layout.panels.forEach(function(panel){
        //    lzp.panels[panel.id].addBasicLoader();
        });

        return {
            layoutPanels:lzp.layout.panels,
            locusZoomPlot: lzp,
            dataSources: ds
        };
    };


        // these get defined when the LZ plot is initialized
        var locusZoomPlot = {};
        var standardLayout = {};
        var dataSources;

        function conditioning(myThis) {
            locusZoomPlot[currentLzPlotKey].CovariatesModel.add(LocusZoom.getToolTipData(myThis));
            LocusZoom.getToolTipData(myThis).deselect();
        }



        function conditionOnVariant(variantId, phenotype,datasetName) {
            locusZoomPlot[currentLzPlotKey].curtain.show('Loading...', {'text-align': 'center'});
           // locusZoomPlot[currentLzPlotKey].panels[phenotype+datasetName].data_layers.positions.destroyAllTooltips();
            locusZoomPlot[currentLzPlotKey].state[phenotype+datasetName+".positions"].selected = [];
            var newStateObject = {
                condition_on_variant: variantId
            };
            locusZoomPlot[currentLzPlotKey].applyState(newStateObject);
        }

        function changeLDReference(variantId, phenotype,datasetName) {
            locusZoomPlot[currentLzPlotKey].curtain.show('Loading...', {'text-align': 'center'});
           // locusZoomPlot[currentLzPlotKey].panels[phenotype+datasetName].data_layers.positions.destroyAllTooltips();
            var newStateObject = {
                ldrefvar: variantId
            };
            locusZoomPlot[currentLzPlotKey].applyState(newStateObject);
        }


        function addLZPhenotype(lzParameters,  dataSetName, geneGetLZ,variantInfoUrl,makeDynamic,lzGraphicDomId,graphicalOptions) {
            var colorBy = 1;
            var positionBy = 1;
            if (typeof graphicalOptions !== 'undefined') {
                colorBy = graphicalOptions.colorBy;
                positionBy = graphicalOptions.positionBy;
            }
            var rawPhenotype = lzParameters.phenotype;
            var phenotype = lzParameters.phenotype+"_"+makeDynamic;
            var localDataSet = lzParameters.dataSet;
            var propertyName = lzParameters.propertyName;
            var dataSet = dataSetName;
            var domId = lzGraphicDomId;
            setNewDefaultLzPlot(lzGraphicDomId);
            var broadAssociationSource = LocusZoom.Data.Source.extend(function (init, rawPhenotype,dataSetName) {
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

                    if ((typeof state.model !== 'undefined')&&(state.model.covariates.length)){
                        var covariant_ids = "";
                        state.model.covariates.forEach(function(covariant){
                            _.forEach(covariant,function(v,k){
                                if ((k.substr(k.length-3))===':id'){
                                    covariant_ids += (covariant_ids.length ? "," : "") + v.replace(/[^0-9ATCG]/g,"_");
                                }
                            });
                            //covariant_ids += (covariant_ids.length ? "," : "") + covariant.id.replace(/[^0-9ATCG]/g,"_");
                        });
                        url += "&conditionVariantId=" + covariant_ids;
                    }
                    return url;
                }
            }, "BroadT2D");
            dataSources.add(phenotype, new broadAssociationSource(geneGetLZ, rawPhenotype,dataSetName));
            //colorBy:1=LD,2=MDS
            //positionBy:1=pValue,2=posteriorPValue
            var buildPanelLayout = function (colorBy,positionBy, phenotype,makeDynamic,dataSetName,variantInfoLink){
                var toolTipText = "<strong><a href="+variantInfoLink+"/?lzId={{" + phenotype + ":id}} target=_blank>{{" + phenotype + ":id}}</a></strong><br>"
                    + "P Value: <strong>{{" + phenotype + ":pvalue|scinotation}}</strong><br>"
                    + "Ref. Allele: <strong>{{" + phenotype + ":refAllele}}</strong><br>";
                if ((typeof makeDynamic !== 'undefined') &&
                    (makeDynamic==='dynamic')){
                    toolTipText += "<a onClick=\"mpgSoftware.locusZoom.conditioning(this);\" style=\"cursor: pointer;\">Condition on this variant</a><br>";
                }
                toolTipText += "<a onClick=\"mpgSoftware.locusZoom.changeLDReference('{{" + phenotype + ":id}}', '" + phenotype + "', '" + dataSetName + "');\" style=\"cursor: pointer;\">Make LD Reference</a>";

                var mods = {
                    id: phenotype+dataSetName,
                    title: { text: lzParameters.description+" ("+makeDynamic+")" },
                    namespace: { assoc: phenotype }
                };
                var panel_layout = LocusZoom.Layouts.get("panel","association", mods);
                panel_layout.data_layers[2].fields = [phenotype + ":id",
                    phenotype + ":position",
                    phenotype + ":pvalue|scinotation",
                    phenotype + ":pvalue|neglog10",
                    phenotype + ":refAllele",
                    phenotype + ":analysis",
                    phenotype + ":scoreTestStat",
                    "ld:state",
                    "ld:isrefvar"
                ];
                panel_layout.data_layers[2].id_field = phenotype + ":id";
                switch (positionBy){
                    case 1:
                        panel_layout.data_layers[2].y_axis.field = phenotype + ":pvalue|neglog10";
                        break;
                    case 2:
                        panel_layout.data_layers[2].y_axis.field = phenotype + ":analysis";
                        panel_layout.data_layers[2].y_axis.min_extent= [0, 1];
                        break;
                    default: break;
                }
                switch (colorBy){
                    case 1: break;
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
                            "#B8B8B8"
                        ];
                        panel_layout.data_layers[2].legend = [  { shape: "circle", color: "#ff0000", size: 40, label: "PTS", class: "lz-data_layer-scatter" },
                            { shape: "circle", color: "#00ff00", size: 40, label: "missense", class: "lz-data_layer-scatter" },
                            { shape: "circle", color: "#0000ff", size: 40, label: "coding", class: "lz-data_layer-scatter" },
                            { shape: "circle", color: "#ffcc00", size: 40, label: "non-coding", class: "lz-data_layer-scatter" } ];
                        break;
                    default: break;
                }
                panel_layout.data_layers[2].tooltip.html = toolTipText;
                return panel_layout;
            }
            // var layout = (function (variantInfoLink) {
            //     var toolTipText = "<strong><a href="+variantInfoLink+"/?lzId={{" + phenotype + ":id}} target=_blank>{{" + phenotype + ":id}}</a></strong><br>"
            //         + "P Value: <strong>{{" + phenotype + ":pvalue|scinotation}}</strong><br>"
            //         + "Ref. Allele: <strong>{{" + phenotype + ":refAllele}}</strong><br>";
            //     if ((typeof makeDynamic !== 'undefined') &&
            //         (makeDynamic==='dynamic')){
            //         toolTipText += "<a onClick=\"mpgSoftware.locusZoom.conditioning(this);\" style=\"cursor: pointer;\">Condition on this variant</a><br>";
            //     }
            //     toolTipText += "<a onClick=\"mpgSoftware.locusZoom.changeLDReference('{{" + phenotype + ":id}}', '" + phenotype + "', '" + dataSetName + "');\" style=\"cursor: pointer;\">Make LD Reference</a>";
            //     var panelLayoutDescr = {
            //         id: phenotype+dataSetName,
            //         title: {text:lzParameters.description+" ("+makeDynamic+")"},
            //         description: phenotype,
            //         y_index: -1,
            //         min_width: 400,
            //         min_height: 240,
            //         margin: {top: 55, right: 50, bottom: 40, left: 50},
            //         inner_border: "rgba(210, 210, 210, 0.85)",
            //         axes: {
            //             x: {
            //                 label_function: "chromosome",
            //                 label_offset: 32,
            //                 tick_format: "region",
            //                 extent: "state"
            //             },
            //             y1: {
            //                 label: "-log10 p-value",
            //                 label_offset: 28
            //             },
            //             y2: {
            //                 label: "Recombination Rate (cM/Mb)",
            //                 label_offset: 40
            //             }
            //         },
            //         dashboard: {
            //             components: [
            //                 { type: "remove_panel", position: "right", color: "red" },
            //                 { type: "move_panel_up", position: "right" },
            //                 { type: "move_panel_down", position: "right" }
            //             ]
            //         },
            //         interaction: {
            //             drag_background_to_pan: true,
            //             drag_x_ticks_to_scale: true,
            //             drag_y1_ticks_to_scale: true,
            //             drag_y2_ticks_to_scale: true,
            //             scroll_to_zoom: true,
            //             x_linked: true
            //         },
            //         data_layers: [
            //             {
            //                 id: 'significance',
            //                 type: "line",
            //                 z_index: 0,
            //                 fields: ["sig:x", "sig:y"],
            //                 style: {
            //                     "stroke": "#D3D3D3",
            //                     "stroke-width": "3px",
            //                     "stroke-dasharray": "10px 10px"
            //                 },
            //                 x_axis: {
            //                     field: "sig:x",
            //                     decoupled: true
            //                 },
            //                 y_axis: {
            //                     axis: 1,
            //                     field: "sig:y"
            //                 },
            //                 tooltip: {
            //                     html: "Significance Threshold: 3 × 10^-5"
            //                 }
            //             },
            //             {
            //                 id: 'recomb',
            //                 type: "line",
            //                 z_index: 1,
            //                 fields: ["recomb:position", "recomb:recomb_rate"],
            //                 style: {
            //                     "stroke": "#0000FF",
            //                     "stroke-width": "1.5px"
            //                 },
            //                 x_axis: {
            //                     field: "recomb:position"
            //                 },
            //                 y_axis: {
            //                     axis: 2,
            //                     field: "recomb:recomb_rate",
            //                     floor: 0,
            //                     ceiling: 100
            //                 }
            //             },
            //             {
            //                 id: 'positions',
            //                 type: "scatter",
            //                 z_index: 2,
            //                 fields: [phenotype + ":id",
            //                         phenotype + ":position",
            //                         phenotype + ":pvalue|scinotation",
            //                         phenotype + ":pvalue|neglog10",
            //                         phenotype + ":refAllele",
            //                         phenotype + ":scoreTestStat",
            //                     "ld:state",
            //                     "ld:isrefvar"
            //                 ],
            //                 id_field: phenotype + ":id",
            //                 x_axis: {
            //                     field: phenotype + ":position"
            //                 },
            //                 y_axis: {
            //                     axis: 1,
            //                     field: phenotype + ":pvalue|neglog10",
            //                     floor: 0,
            //                     upper_buffer: 0.05,
            //                     min_extent: [0, 10]
            //                 },
            //                 point_shape: "circle",
            //                 point_size: {
            //                     scale_function: "if",
            //                     field: "ld:isrefvar",
            //                     parameters: {
            //                         field_value: 1,
            //                         then: 80,
            //                         else: 40
            //                     }
            //                 },
            //                 color: [
            //                     // {
            //                     //     scale_function: "if",
            //                     //     field: "ld:isrefvar",
            //                     //     parameters: {
            //                     //         field_value: 1,
            //                     //         then: "#9632b8"
            //                     //     }
            //                     // },
            //                     // {
            //                     //     scale_function: "numerical_bin",
            //                     //     field: "ld:state",phenotype + ":position"
            //                     //     parameters: {
            //                     //         breaks: [0, 0.2, 0.4, 0.6, 0.8],
            //                     //         values: ["#357ebd", "#46b8da", "#5cb85c", "#eea236", "#d43f3a"]
            //                     //     }
            //                     // },
            //                     {
            //                         scale_function: "categorical_bin",
            //                         field: phenotype + ":scoreTestStat",
            //                         parameters: {
            //                             categories: ["1","2","3","4","5"],
            //                             values: ["#ff0000", "#00ff00", "#0000ff", "#ffcc00", "#111111"]
            //                         }
            //                     },
            //                     "#B8B8B8"
            //                 ],
            //                 legend: [
            //                     { shape: "circle", color: "#ff0000", size: 40, label: "MDS=1", class: "lz-data_layer-scatter" }
            //                 ],
            //                 transition: {
            //                     duration: 500
            //                 },
            //                 behaviors: {
            //                     onmouseover: [
            //                         { action: "set", status: "highlighted" }
            //                     ],
            //                     onmouseout: [
            //                         { action: "unset", status: "highlighted" }
            //                     ],
            //                     onclick: [
            //                         { action: "toggle", status: "selected", exclusive: true }
            //                     ],
            //                     onshiftclick: [
            //                         { action: "toggle", status: "selected" }
            //                     ]
            //                 },
            //                 tooltip: {
            //                     closable: true,
            //                     show: { or: ["highlighted", "selected"] },
            //                     hide: { and: ["unhighlighted", "unselected"] },
            //                     html: toolTipText
            //                 }
            //             }
            //         ]
            //     };
            // }(variantInfoUrl));
            //colorBy:1=LD,2=MDS
            //positionBy:1=pValue,2=posteriorPValue
            var panelLayout = buildPanelLayout(colorBy,positionBy, phenotype,makeDynamic,dataSetName,variantInfoUrl);
            locusZoomPlot[currentLzPlotKey].addPanel(panelLayout).addBasicLoader();
        };





        var resetLZPage = function (page, variantId, positionInfo,domId1,collapsingDom,
                                         phenoTypeName,phenoTypeDescr,dataSetName,propName,phenotype,
                                         geneGetLZ,variantInfoUrl,makeDynamic) {
            var loading = $('#spinner').show();
            var lzGraphicDomId = "#lz-1";
            var defaultPhenotypeName = "T2D";
            if (typeof domId1 !== 'undefined') {
                lzGraphicDomId = domId1;
            }
            setNewDefaultLzPlot(lzGraphicDomId);
            if (typeof phenoTypeName !== 'undefined') {
                defaultPhenotypeName = phenoTypeName;
            }

            var chromosome = positionInfo.chromosome;
            // make sure we don't get a negative start point
            var startPosition = Math.max(0, positionInfo.startPosition);
            var endPosition = positionInfo.endPosition;

            var locusZoomInput = chromosome + ":" + startPosition + "-" + endPosition;
            $(lzGraphicDomId).attr("data-region", locusZoomInput);
            $("#lzRegion").text(locusZoomInput);
            loading.hide();

            var lzVarId = '';
            // need to process the varId to match the IDs that LZ is getting, so that
            // the correct reference variant is displayed
            if ((page == 'variantInfo')&& (typeof variantId !== 'undefined') ) {
                lzVarId = variantId;
                // we have format: 8_118184783_C_T
                // need to get format like: 8:118184783_C/T
                var splitVarId = variantId.split('_');
                lzVarId = splitVarId[0] + ':' + splitVarId[1] + '_' + splitVarId[2] + '/' + splitVarId[3];
            }

            if ((lzVarId.length > 0)||(typeof chromosome !== 'undefined') ) {

                var returned = mpgSoftware.locusZoom.initLocusZoom(lzGraphicDomId, lzVarId);
                locusZoomPlot[currentLzPlotKey] = returned.locusZoomPlot;
                dataSources = returned.dataSources;

                // default panel
                addLZPhenotype({
                    phenotype: defaultPhenotypeName,
                    dataSet: dataSetName,
                    propertyName: propName,
                    description: phenoTypeDescr
                },dataSetName,geneGetLZ,variantInfoUrl,makeDynamic,lzGraphicDomId);

            }
        };


        var initializeLZPage = function (page, variantId, positionInfo,domId1,collapsingDom,
                                         phenoTypeName,phenoTypeDescription,
                                         phenoPropertyName,locusZoomDataset,junk,
                                         geneGetLZ,variantInfoUrl,makeDynamic) {
            var loading = $('#spinner').show();
            var lzGraphicDomId = "#lz-1";
            var defaultPhenotypeName = "T2D";
            var dataSetName = locusZoomDataset;
            if (typeof domId1 !== 'undefined') {
                lzGraphicDomId = domId1;
            }
            setNewDefaultLzPlot(lzGraphicDomId);
            if (typeof phenoTypeName !== 'undefined') {
                defaultPhenotypeName = phenoTypeName;
            }
            $(domId1).empty();
            var chromosome = positionInfo.chromosome;
            // make sure we don't get a negative start point
            var startPosition = Math.max(0, positionInfo.startPosition);
            var endPosition = positionInfo.endPosition;

            var locusZoomInput = chromosome + ":" + startPosition + "-" + endPosition;
            $(lzGraphicDomId).attr("data-region", locusZoomInput);
            $("#lzRegion").text(locusZoomInput);
            loading.hide();

            var lzVarId = '';
            // need to process the varId to match the IDs that LZ is getting, so that
            // the correct reference variant is displayed
            if ((page == 'variantInfo')&& (typeof variantId !== 'undefined') ) {
                lzVarId = variantId;
                // we have format: 8_118184783_C_T
                // need to get format like: 8:118184783_C/T
                var splitVarId = variantId.split('_');
                lzVarId = splitVarId[0] + ':' + splitVarId[1] + '_' + splitVarId[2] + '/' + splitVarId[3];
            }

            if ((lzVarId.length > 0)||(typeof chromosome !== 'undefined') ) {

                var returned = mpgSoftware.locusZoom.initLocusZoom(lzGraphicDomId, lzVarId);
                locusZoomPlot[currentLzPlotKey] = returned.locusZoomPlot;
                dataSources = returned.dataSources;

                // default panel
                addLZPhenotype({
                    phenotype: defaultPhenotypeName,
                    description: phenoTypeDescription,
                    propertyName:phenoPropertyName,
                    dataSet:locusZoomDataset
                },dataSetName,geneGetLZ,variantInfoUrl,makeDynamic,lzGraphicDomId);

                $(collapsingDom).on("shown.bs.collapse", function () {
                    locusZoomPlot[currentLzPlotKey].rescaleSVG();
                });

                var clearCurtain = function() {
                    locusZoomPlot[currentLzPlotKey].curtain.hide();
                };
                locusZoomPlot[currentLzPlotKey].on('data_rendered', clearCurtain);
            }
        };

    var rescaleSVG = function (){
        locusZoomPlot[currentLzPlotKey].rescaleSVG();
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
        setNewDefaultLzPlot: setNewDefaultLzPlot,
        conditioning:conditioning,
        initLocusZoom : initLocusZoom,
        initializeLZPage:initializeLZPage,
        resetLZPage:resetLZPage,
        addLZPhenotype:addLZPhenotype,
        changeLDReference:changeLDReference,
        conditionOnVariant:conditionOnVariant,
        rescaleSVG:rescaleSVG,
        removePanel:removePanel,
        removeAllPanels:removeAllPanels,
        plotAlreadyExists: plotAlreadyExists,
        locusZoomPlot:locusZoomPlot
       // broadAssociationSource:broadAssociationSource
    }

}());
})();