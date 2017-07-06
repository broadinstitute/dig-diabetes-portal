
var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";



    mpgSoftware.locusZoom = (function (){
        var apiBase = 'https://portaldev.sph.umich.edu/api/v1/';
        var currentLzPlotKey = 'lz-47';

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

        var customIntervalsPanel = function (layerName){
            return {   id: layerName,
                    width: 1000,
                    height: 50,
                    min_width: 500,
                    min_height: 50,
                    margin: { top: 25, right: 150, bottom: 5, left: 50 },
                dashboard: (function(){
                    //var l = standardDashBoadWithoutMove();
                    var l = LocusZoom.Layouts.get("dashboard", "standard_panel", { unnamespaced: true });
                    l.components.push({
                        type: "toggle_split_tracks",
                        data_layer_id: layerName,
                        position: "right"
                    });
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

        var customCurveDataLayer = function (layerName){
            var stateIdSpec = layerName+":state_id";
            var developingStructure = {
                namespace: {layerName: layerName},
                id: "recombratenew",
                type: "filledLine",
                fields: [layerName+":position", layerName+":pvalue"],
                z_index: 1,
                style: {
                    "stroke": "#0000FF",
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


        var customCurvePanel = function (layerName){
           return { id: layerName,
            width: 800,
            height: 225,
            min_width:  400,
            min_height: 200,
            proportional_width: 1,
            margin: { top: 35, right: 50, bottom: 40, left: 50 },
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
                customCurveDataLayer('accessibility-tissue')
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








        var buildAccessibilityLayout = function ( accessibilityPanelName,phenotypeName){
            var addendumToName = '';
            var mods = {
                id: accessibilityPanelName,
                title: { text: "chromatin accessibility in Aorta"},
                namespace: { assoc: phenotypeName }
            };
            var panel_layout = customCurvePanel(accessibilityPanelName + ":id");
            //panel_layout.y_index = -1;
            panel_layout.height = 210;
            panel_layout.data_layers[0].id = accessibilityPanelName;
            panel_layout.data_layers[0].id_field = accessibilityPanelName+":start"

            return panel_layout;
        };












        var buildPanelLayout = function (colorBy,positionBy, phenotype,makeDynamic,dataSetName,variantInfoLink,lzParameters){
            var toolTipText = "<strong><a href="+variantInfoLink+"/?lzId={{" + phenotype + ":id}} target=_blank>{{" + phenotype + ":id}}</a></strong><br>"
                + "P Value: <strong>{{" + phenotype + ":pvalue|scinotation}}</strong><br>"
                + "Ref. Allele: <strong>{{" + phenotype + ":refAllele}}</strong><br>";
            if ((typeof makeDynamic !== 'undefined') &&
                (makeDynamic==='dynamic')){
                toolTipText += "<a onClick=\"mpgSoftware.locusZoom.conditioning(this);\" style=\"cursor: pointer;\">Condition on this variant</a><br>";
            }
            toolTipText += "<a onClick=\"mpgSoftware.locusZoom.changeLDReference('{{" + phenotype + ":id}}', '" + phenotype + "', '" + dataSetName + "');\" style=\"cursor: pointer;\">Make LD Reference</a>";



            colorBy=1;




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
            panel_layout.y_index = -1;
            panel_layout.height = 270;
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
                                },
                    "#c8c8c8"]
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
                        "#B8B8B8"
                    ];
                    panel_layout.data_layers[2].legend = [  { shape: "circle", color: "#ff0000", size: 40, label: "PTS", class: "lz-data_layer-scatter" },
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

        var buildAssociationSource = function(dataSources,geneGetLZ,phenotype, rawPhenotype,dataSetName,propertyName,makeDynamic){
            var broadAssociationSource = LocusZoom.Data.Source.extend(function (init, rawPhenotype,dataSetName,propertyName,makeDynamic) {
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
                        });
                        url += "&conditionVariantId=" + covariant_ids;
                    }
                    return url;
                }
            }, "BroadT2D");
            dataSources.add(phenotype, new broadAssociationSource(geneGetLZ, rawPhenotype,dataSetName,propertyName,makeDynamic));
        };

        var buildIntervalSource = function(dataSources,retrieveFunctionalDataAjaxUrl,rawTissue){
             var broadIntervalsSource = LocusZoom.Data.Source.extend(function (init, tissue) {
                this.parseInit(init);
                this.getURL = function (state, chain, fields) {
                    var url = this.url + "?" +
                        "chromosome=" + state.chr + "&" +
                        "startPos=" + state.start + "&" +
                        "endPos=" + state.end + "&" +
                        "source=" + tissue + "&" +
                        "lzFormat=1";
                    return url;
                }
            }, "BroadT2D");
            var tissueAsId = 'intervals-'+rawTissue;
            dataSources.add(tissueAsId, new broadIntervalsSource(retrieveFunctionalDataAjaxUrl, rawTissue));
        };

        var buildChromatinAccessibilitySource = function(dataSources,getLocusZoomFilledPlotUrl,rawTissue){
            var broadAccessibilitySource = LocusZoom.Data.Source.extend(function (init, tissue) {
                this.parseInit(init);
                this.getURL = function (state, chain, fields) {
                    var url = this.url + "?" +
                        "chromosome=" + state.chr + "&" +
                        "start=" + state.start + "&" +
                        "end=" + state.end + "&" +
                        "source=" + tissue + "&" +
                        "lzFormat=1";
                    return url;
                }
            }, "BroadT2D");
            var tissueAsId = 'accessibility-'+rawTissue;
            dataSources.add(tissueAsId, new broadAccessibilitySource(getLocusZoomFilledPlotUrl, rawTissue));
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
        _.forEach(intervalPanels,function(o){newPanelOrdering.push(o)});
        _.forEach(genePanel,function(o){newPanelOrdering.push(o)});
        plot.panel_ids_by_y_index = newPanelOrdering;
    }

        var addAssociationTrack = function (locusZoomVar,colorBy,positionBy, phenotype,makeDynamic,dataSetName,variantInfoUrl,lzParameters){
            var panelLayout = buildPanelLayout(colorBy,positionBy, phenotype,makeDynamic,dataSetName,variantInfoUrl,lzParameters);
            panelLayout.y_index = 0;
            locusZoomVar.addPanel(panelLayout).addBasicLoader();
            reorderPanels(locusZoomVar);
        };



        var addIntervalTrack = function(locusZoomVar,tissueName,tissueId){
            var intervalPanelName = "intervals-"+tissueId;
            // we can't use the standard interval panel, but we can derive our own
            var intervalPanel = customIntervalsPanel(intervalPanelName);
            intervalPanel.dashboard.components.push({
                type: "menu",
                color: "yellow",
                position: "right",
                button_html: "Track Info",
                menu_html: "<strong>"+tissueName+" ChromHMM calls from Parker 2013</strong><br>Build: 37<br>Assay: ChIP-seq<br>Tissue: "+tissueName+"</div>"
            });
            intervalPanel.title = { text: tissueName, style: {}, x: 10, y: 22 };
            if (typeof locusZoomPlot[currentLzPlotKey].panels[intervalPanelName] === 'undefined'){

                locusZoomVar.addPanel(intervalPanel).addBasicLoader();
            } else {
                console.log(' we already had a panel for tissue='+tissueId+'.')
            }
            reorderPanels(locusZoomVar);
        };


        var addChromatinAccessibilityTrack = function(locusZoomVar,tissueName,tissueId,phenotypeName){
            var accessibilityPanelName = "accessibility-"+tissueId;
            // we can't use the standard interval panel, but we can derive our own
            var accessibilityPanel = buildAccessibilityLayout(accessibilityPanelName,phenotypeName)
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

            buildAssociationSource(dataSources,geneGetLZ,phenotype, rawPhenotype,dataSetName,propertyName,makeDynamic);
            addAssociationTrack(locusZoomPlot[currentLzPlotKey],colorBy,positionBy, phenotype,makeDynamic,dataSetName,variantInfoUrl,lzParameters)


        };




        function addLZTissueAnnotations(lzParameters,  lzGraphicDomId, graphicalOptions) {
            var colorBy = 1;  //colorBy:1=LD,2=MDS
            var positionBy = 1;  //positionBy:1=pValue,2=posteriorPValue
            if (typeof graphicalOptions !== 'undefined') {
                colorBy = graphicalOptions.colorBy;
                positionBy = graphicalOptions.positionBy;
            }
            var retrieveFunctionalDataAjaxUrl = lzParameters.retrieveFunctionalDataAjaxUrl;
            var tissueCode = lzParameters.tissueCode;
            var tissueDescriptiveName = lzParameters.tissueDescriptiveName;
            setNewDefaultLzPlot(lzGraphicDomId);

            buildIntervalSource(dataSources,retrieveFunctionalDataAjaxUrl,tissueCode);
            addIntervalTrack(locusZoomPlot[currentLzPlotKey],tissueDescriptiveName,tissueCode);

            rescaleSVG();
        };
        function addLZTissueChromatinAccessibility(lzParameters,  lzGraphicDomId, graphicalOptions) {
            var getLocusZoomFilledPlotUrl = lzParameters.getLocusZoomFilledPlotUrl;
            var tissueCode = lzParameters.tissueCode;
            var tissueDescriptiveName = lzParameters.tissueDescriptiveName;
            var phenotypeName = lzParameters.phenotypeName;
            setNewDefaultLzPlot(lzGraphicDomId);

            buildChromatinAccessibilitySource(dataSources,getLocusZoomFilledPlotUrl,tissueCode,phenotypeName);
            addChromatinAccessibilityTrack(locusZoomPlot[currentLzPlotKey],tissueDescriptiveName,tissueCode,phenotypeName);

            rescaleSVG();

        };

        var initializeLZPage = function (page, variantId, positionInfo,domId1,collapsingDom,
                                         phenoTypeName,phenoTypeDescription,
                                         phenoPropertyName,locusZoomDataset,getLocusZoomFilledPlotUrl,
                                         geneGetLZ,variantInfoUrl,makeDynamic,
                                         retrieveFunctionalDataAjaxUrl,
                                         pageInitialization,functionalTrack, defaultTissues,defaultTissuesDescriptions,datasetReadableName) {
            var graphicalOptions = {colorBy:1,
                                    positionBy:1};
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

                var returned = mpgSoftware.locusZoom.initLocusZoom(lzGraphicDomId, lzVarId,retrieveFunctionalDataAjaxUrl);
                locusZoomPlot[currentLzPlotKey] = returned.locusZoomPlot;
                dataSources = returned.dataSources;

                // default panel
                addLZPhenotype({
                        phenotype: defaultPhenotypeName,
                        description: phenoTypeDescription,
                        propertyName:phenoPropertyName,
                        dataSet:locusZoomDataset,
                        datasetReadableName:datasetReadableName,
                        retrieveFunctionalDataAjaxUrl:retrieveFunctionalDataAjaxUrl
                },dataSetName,geneGetLZ,variantInfoUrl,
                    makeDynamic,lzGraphicDomId,graphicalOptions);

                if (typeof functionalTrack !== 'undefined'){
                    if ( typeof defaultTissues !== 'undefined'){
                        _.forEach(defaultTissues,function(o,i){
                            addLZTissueAnnotations({
                                tissueCode: o,
                                tissueDescriptiveName: defaultTissuesDescriptions[i],
                                retrieveFunctionalDataAjaxUrl:retrieveFunctionalDataAjaxUrl
                            },lzGraphicDomId,graphicalOptions);
                        });
                    }

                }

 is
                if ((typeof pageInitialization !== 'undefined')&&
                    (pageInitialization)){

                    $(collapsingDom).on("shown.bs.collapse", function () {
                        locusZoomPlot[currentLzPlotKey].rescaleSVG();
                    });

                    var clearCurtain = function() {
                        locusZoomPlot[currentLzPlotKey].curtain.hide();
                    };
                    locusZoomPlot[currentLzPlotKey].on('data_rendered', clearCurtain);

                }
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
        addLZPhenotype:addLZPhenotype,
        addLZTissueAnnotations:addLZTissueAnnotations,
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