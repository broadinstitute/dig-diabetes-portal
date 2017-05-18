
var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";



    mpgSoftware.locusZoom = (function (){
        var apiBase = 'https://portaldev.sph.umich.edu/api/v1/';
        var currentLzPlotKey = 'lz-47';




        var customIntervalsDataLayer = function (layerName){
            return {
                namespace: { "intervals": layerName },
                id: layerName,
                type: "intervals",
                fields: ["{{namespace[intervals]}}start","{{namespace[intervals]}}end","{{namespace[intervals]}}state_id","{{namespace[intervals]}}state_name"],
                id_field: "{{namespace[intervals]}}start",
                start_field: "{{namespace[intervals]}}start",
                end_field: "{{namespace[intervals]}}end",
                track_split_field: "{{namespace[intervals]}}state_id",
                split_tracks: true,
                always_hide_legend: false,
                color: {
                    field: "{{namespace[intervals]}}state_id",
                    scale_function: "categorical_bin",
                    parameters: {
                        categories: [1,2,3,4,5,6,7,8,9,10,11,12,13],
                        values: ["rgb(212,63,58)", "rgb(250,120,105)", "rgb(252,168,139)", "rgb(240,189,66)", "rgb(250,224,105)", "rgb(240,238,84)", "rgb(244,252,23)", "rgb(23,232,252)", "rgb(32,191,17)", "rgb(23,166,77)", "rgb(32,191,17)", "rgb(162,133,166)", "rgb(212,212,212)"],
                        null_value: "#B8B8B8"
                    }
                },
                legend: [
                    { shape: "rect", color: "rgb(212,63,58)", width: 9, label: "Active Promoter", "{{namespace[intervals]}}state_id": 1 },
                    { shape: "rect", color: "rgb(250,120,105)", width: 9, label: "Weak Promoter", "{{namespace[intervals]}}state_id": 2 },
                    { shape: "rect", color: "rgb(252,168,139)", width: 9, label: "Poised Promoter", "{{namespace[intervals]}}state_id": 3 },
                    { shape: "rect", color: "rgb(240,189,66)", width: 9, label: "Strong enhancer", "{{namespace[intervals]}}state_id": 4 },
                    { shape: "rect", color: "rgb(250,224,105)", width: 9, label: "Strong enhancer", "{{namespace[intervals]}}state_id": 5 },
                    { shape: "rect", color: "rgb(240,238,84)", width: 9, label: "Weak enhancer", "{{namespace[intervals]}}state_id": 6 },
                    { shape: "rect", color: "rgb(244,252,23)", width: 9, label: "Weak enhancer", "{{namespace[intervals]}}state_id": 7 },
                    { shape: "rect", color: "rgb(23,232,252)", width: 9, label: "Insulator", "{{namespace[intervals]}}state_id": 8 },
                    { shape: "rect", color: "rgb(32,191,17)", width: 9, label: "Transcriptional transition", "{{namespace[intervals]}}state_id": 9 },
                    { shape: "rect", color: "rgb(23,166,77)", width: 9, label: "Transcriptional elongation", "{{namespace[intervals]}}state_id": 10 },
                    { shape: "rect", color: "rgb(136,240,129)", width: 9, label: "Weak transcribed", "{{namespace[intervals]}}state_id": 11 },
                    { shape: "rect", color: "rgb(162,133,166)", width: 9, label: "Polycomb-repressed", "{{namespace[intervals]}}state_id": 12 },
                    { shape: "rect", color: "rgb(212,212,212)", width: 9, label: "Heterochromatin / low signal", "{{namespace[intervals]}}state_id": 13 }
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
                },
                tooltip: LocusZoom.Layouts.get("tooltip", "standard_intervals", { unnamespaced: true })
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
            // Add a track information button to the intervals panel
            newLayout.panels[1].dashboard.components.push({
                type: "menu",
                color: "yellow",
                position: "right",
                button_html: "Track Info",
                menu_html: "<strong>Pancreatic islet chromHMM calls from Parker 2013</strong><br>Build: 37<br>Assay: ChIP-seq<br>Tissue: pancreatic islet</div>"
            });
            //newLayout.panels = _.tail(newLayout.panels);
            newLayout.panels = [newLayout.panels[2]];
            newLayout.panels[0].y_index = -1;
            return newLayout;
        };

    var setNewDefaultLzPlot = function (key){
        currentLzPlotKey  = key;
    }
    
    var initLocusZoom = function(selector, variantIdString,retrieveFunctionalDataAjaxUrl) {
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
            .add("sig", ["StaticJSON", [{ "x": 0, "y": 4.522 }, { "x": 2881033286, "y": 4.522 }] ]);
            //.add("intervals", ["IntervalLZ", { url: apiBase + "annotation/intervals/results/", params: {source: 16} }]);
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
        ds.add('intervals', new broadIntervalsSource(retrieveFunctionalDataAjaxUrl, 'Islets'));
        ds.add('intervals-Islets', new broadIntervalsSource(retrieveFunctionalDataAjaxUrl, 'Islets'));
        var lzp = LocusZoom.populate(selector, ds, standardLayout[currentLzPlotKey]);


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
                panel_layout.y_index = -1;
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
          //colorBy:1=LD,2=MDS
            //positionBy:1=pValue,2=posteriorPValue
            var intervalPanel = LocusZoom.Layouts.get("panel", "intervals");
            // intervalPanel.dashboard.components[3].data_layer_id = 'intervals-Islets';
            // intervalPanel.data_layers = [customIntervalsDataLayer('intervals-Islets')];
            if (typeof locusZoomPlot[currentLzPlotKey].panels['intervals'] === 'undefined'){
                locusZoomPlot[currentLzPlotKey].addPanel(intervalPanel).addBasicLoader();
            } else {
                intervalPanel.id = 'intervals-Islets';
              //  intervalPanel.dashboard.components[3].data_layer_id = 'intervals-Islets';
              //  intervalPanel.data_layers = [customIntervalsDataLayer('intervals-Islets')];
              //  locusZoomPlot[currentLzPlotKey].addPanel(intervalPanel).addBasicLoader();
            }


            var panelLayout = buildPanelLayout(colorBy,positionBy, phenotype,makeDynamic,dataSetName,variantInfoUrl);
            locusZoomPlot[currentLzPlotKey].addPanel(panelLayout).addBasicLoader();

        };





        var resetLZPage = function (page, variantId, positionInfo,domId1,collapsingDom,
                                         phenoTypeName,phenoTypeDescr,dataSetName,propName,phenotype,
                                         geneGetLZ,variantInfoUrl,makeDynamic,retrieveFunctionalDataAjaxUrl) {
            var graphicalOptions = {colorBy:2,
                positionBy:1};
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

                var returned = mpgSoftware.locusZoom.initLocusZoom(lzGraphicDomId, lzVarId,retrieveFunctionalDataAjaxUrl);
                locusZoomPlot[currentLzPlotKey] = returned.locusZoomPlot;
                dataSources = returned.dataSources;

                // default panel
                addLZPhenotype({
                    phenotype: defaultPhenotypeName,
                    dataSet: dataSetName,
                    propertyName: propName,
                    description: phenoTypeDescr
                },dataSetName,geneGetLZ,variantInfoUrl,
                    makeDynamic,lzGraphicDomId,graphicalOptions);

            }
        };


        var initializeLZPage = function (page, variantId, positionInfo,domId1,collapsingDom,
                                         phenoTypeName,phenoTypeDescription,
                                         phenoPropertyName,locusZoomDataset,junk,
                                         geneGetLZ,variantInfoUrl,makeDynamic,retrieveFunctionalDataAjaxUrl) {
            var graphicalOptions = {colorBy:2,
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
                    dataSet:locusZoomDataset
                },dataSetName,geneGetLZ,variantInfoUrl,
                    makeDynamic,lzGraphicDomId,graphicalOptions);

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