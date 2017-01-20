
var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";



    mpgSoftware.locusZoom = (function (){
        var apiBase = 'https://portaldev.sph.umich.edu/api/v1/';
        var currentLzPlotKey = 'lz-47';


    var createStandardLayout = function(){
      this.layout = {
          responsive_resize: true,
          min_width: 600,
          min_height: 300,
          width: 600,
          height: 300,
        aspect_ratio: 2,
        dashboard: {
            components: [
                { type: "title", title: "LocusZoom", position: "left" },
                { type: "covariates_model", button_html: "Model", button_title: "Click to view/remove covariates from this plot's model", position: "left" },
                { type: "dimensions", position: "right" },
                { type: "region_scale", position: "right" },
                { type: "download", position: "right" }
            ]
        },
        panels: [
            {
                id: 'genes',
                margin: { top: 20, right: 50, bottom: 20, left: 50 },
                axes: {},
                dashboard: {
                    components: [
                        { type: "move_panel_up", position: "right" },
                        { type: "move_panel_down", position: "right" }
                    ]
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
                    {
                        id: 'genes',
                        type: "genes",
                        fields: ["gene:gene", "constraint:constraint"],
                        id_field: "gene_id",
                        selectable: "one",
                        highlighted: {
                            onmouseover: "on",
                            onmouseout: "off"
                        },
                        selected: {
                            onclick: "toggle_exclusive",
                            onshiftclick: "toggle"
                        },
                        tooltip: {
                            closable: true,
                            show: { or: ["highlighted", "selected"] },
                            hide: { and: ["unhighlighted", "unselected"] },
                            html: "<h4><strong><i>{{gene_name}}</i></strong></h4>"
                                + "<div style=\"float: left;\">Gene ID: <strong>{{gene_id}}</strong></div>"
                                + "<div style=\"float: right;\">Transcript ID: <strong>{{transcript_id}}</strong></div>"
                                + "<div style=\"clear: both;\"></div>"
                                + "<table>"
                                + "<tr><th>Constraint</th><th>Expected variants</th><th>Observed variants</th><th>Const. Metric</th></tr>"
                                + "<tr><td>Synonymous</td><td>{{exp_syn}}</td><td>{{n_syn}}</td><td>z = {{syn_z}}</td></tr>"
                                + "<tr><td>Missense</td><td>{{exp_mis}}</td><td>{{n_mis}}</td><td>z = {{mis_z}}</td></tr>"
                                + "<tr><td>LoF</td><td>{{exp_lof}}</td><td>{{n_lof}}</td><td>pLI = {{pLI}}</td></tr>"
                                + "</table>"
                                + "<div style=\"width: 100%; text-align: right;\"><a href=\"http://exac.broadinstitute.org/gene/{{gene_id}}\" target=\"_new\">More data on ExAC</a></div>"
                        }
                    }
                ]
            }
        ]
    }
    };




    var setNewDefaultLzPlot = function (key){
        currentLzPlotKey  = key;
    }
    
    var initLocusZoom = function(selector, variantIdString) {
        // TODO - will need to test that incorrect input format doesn't throw JS exception which stops all JS activity
        // TODO - need to catch all exceptions to make sure rest of non LZ JS modules on page load properly (scope errors to this module)
        standardLayout[currentLzPlotKey] =  (new createStandardLayout()).layout;
        if(variantIdString != '') {
            setNewDefaultLzPlot(selector);
            standardLayout[currentLzPlotKey].state = {
                ldrefvar: variantIdString
            };
        }
        var ds = new LocusZoom.DataSources();
        ds.add("constraint", ["GeneConstraintLZ", { url: "http://exac.broadinstitute.org/api/constraint" }])
            .add("ld", ["LDLZ" , apiBase + "pair/LD/"])
            .add("gene", ["GeneLZ", apiBase + "annotation/genes/"])
            .add("recomb", ["RecombLZ", { url: apiBase + "annotation/recomb/results/", params: {source: 15} }])
            .add("sig", ["StaticJSON", [{ "x": 0, "y": 4.522 }, { "x": 2881033286, "y": 4.522 }] ]);
        var lzp = LocusZoom.populate(selector, ds, standardLayout[currentLzPlotKey]);

        // Create event hooks to clear the loader whenever a panel renders new data
        lzp.layout.panels.forEach(function(panel){
            lzp.panels[panel.id].addBasicLoader();
        });

        return {
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
            locusZoomPlot[currentLzPlotKey].panels[phenotype+datasetName].data_layers.positions.destroyAllTooltips();
            locusZoomPlot[currentLzPlotKey].state[phenotype+datasetName+".positions"].selected = [];
            var newStateObject = {
                condition_on_variant: variantId
            };
            locusZoomPlot[currentLzPlotKey].applyState(newStateObject);
        }

        function changeLDReference(variantId, phenotype,datasetName) {
            locusZoomPlot[currentLzPlotKey].curtain.show('Loading...', {'text-align': 'center'});
            locusZoomPlot[currentLzPlotKey].panels[phenotype+datasetName].data_layers.positions.destroyAllTooltips();
            var newStateObject = {
                ldrefvar: variantId
            };
            locusZoomPlot[currentLzPlotKey].applyState(newStateObject);
        }


        function addLZPhenotype(lzParameters,  dataSetName, geneGetLZ,variantInfoUrl,makeDynamic,lzGraphicDomId) {
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
                    if (state.model.covariates.length){
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

            var layout = (function (variantInfoLink) {
                var toolTipText = "<strong><a href="+variantInfoLink+"/?lzId={{" + phenotype + ":id}} target=_blank>{{" + phenotype + ":id}}</a></strong><br>"
                    + "P Value: <strong>{{" + phenotype + ":pvalue|scinotation}}</strong><br>"
                    + "Ref. Allele: <strong>{{" + phenotype + ":refAllele}}</strong><br>";
                if ((typeof makeDynamic !== 'undefined') &&
                    (makeDynamic==='dynamic')){
                    toolTipText += "<a onClick=\"mpgSoftware.locusZoom.conditioning(this);\" style=\"cursor: pointer;\">Condition on this variant</a><br>";
                }
                toolTipText += "<a onClick=\"mpgSoftware.locusZoom.changeLDReference('{{" + phenotype + ":id}}', '" + phenotype + "', '" + dataSetName + "');\" style=\"cursor: pointer;\">Make LD Reference</a>";
                return {
                    id: phenotype+dataSetName,
                    title: {text:lzParameters.description+" ("+makeDynamic+")"},
                    description: phenotype,
                    y_index: -1,
                    min_width: 400,
                    min_height: 100,
                    margin: {top: 35, right: 50, bottom: 40, left: 50},
                    inner_border: "rgba(210, 210, 210, 0.85)",
                    axes: {
                        x: {
                            label_function: "chromosome",
                            label_offset: 32,
                            tick_format: "region",
                            extent: "state"
                        },
                        y1: {
                            label: "-log10 p-value",
                            label_offset: 28
                        },
                        y2: {
                            label: "Recombination Rate (cM/Mb)",
                            label_offset: 40
                        }
                    },
                    dashboard: {
                        components: [
                            { type: "remove_panel", position: "right", color: "red" },
                            { type: "move_panel_up", position: "right" },
                            { type: "move_panel_down", position: "right" }
                        ]
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
                        {
                            id: 'significance',
                            type: "line",
                            z_index: 0,
                            fields: ["sig:x", "sig:y"],
                            style: {
                                "stroke": "#D3D3D3",
                                "stroke-width": "3px",
                                "stroke-dasharray": "10px 10px"
                            },
                            x_axis: {
                                field: "sig:x",
                                decoupled: true
                            },
                            y_axis: {
                                axis: 1,
                                field: "sig:y"
                            },
                            tooltip: {
                                html: "Significance Threshold: 3 × 10^-5"
                            }
                        },
                        {
                            id: 'recomb',
                            type: "line",
                            z_index: 1,
                            fields: ["recomb:position", "recomb:recomb_rate"],
                            style: {
                                "stroke": "#0000FF",
                                "stroke-width": "1.5px"
                            },
                            x_axis: {
                                field: "recomb:position"
                            },
                            y_axis: {
                                axis: 2,
                                field: "recomb:recomb_rate",
                                floor: 0,
                                ceiling: 100
                            }
                        },
                        {
                            id: 'positions',
                            type: "scatter",
                            z_index: 2,
                            fields: [phenotype + ":id",
                                    phenotype + ":position",
                                    phenotype + ":pvalue|scinotation",
                                    phenotype + ":pvalue|neglog10",
                                    phenotype + ":refAllele",
                                "ld:state",
                                "ld:isrefvar"
                            ],
                            id_field: phenotype + ":id",
                            x_axis: {
                                field: phenotype + ":position"
                            },
                            y_axis: {
                                axis: 1,
                                field: phenotype + ":pvalue|neglog10",
                                floor: 0,
                                upper_buffer: 0.05,
                                min_extent: [0, 10]
                            },
                            point_shape: "circle",
                            point_size: {
                                scale_function: "if",
                                field: "ld:isrefvar",
                                parameters: {
                                    field_value: 1,
                                    then: 80,
                                    else: 40
                                }
                            },
                            color: [
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
                                        values: ["#357ebd", "#46b8da", "#5cb85c", "#eea236", "#d43f3a"]
                                    }
                                },
                                "#B8B8B8"
                            ],
                            transition: {
                                duration: 500
                            },
                            selectable: "one",
                            highlighted: {
                                onmouseover: "on",
                                onmouseout: "off"
                            },
                            selected: {
                                onclick: "toggle_exclusive",
                                onshiftclick: "toggle"
                            },
                            tooltip: {
                                closable: true,
                                show: { or: ["highlighted", "selected"] },
                                hide: { and: ["unhighlighted", "unselected"] },
                                html: toolTipText
                            }
                        }
                    ]
                };
            }(variantInfoUrl));
            locusZoomPlot[currentLzPlotKey].addPanel(layout).addBasicLoader();
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
                                         phenoTypeName,phenoTypeDescription,locusZoomDataset,
                                         phenoPropertyName,junk,
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