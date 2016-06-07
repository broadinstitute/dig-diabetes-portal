<script type="text/javascript">
    var mpgSoftware = mpgSoftware || {};

    // these get defined when the LZ plot is initialized
    var locusZoomPlot;
    var dataSources;
    // objects needed for both initialization and for adding more phenotypes
    var broadAssociationSource = LocusZoom.Data.Source.extend(function (init, phenotype) {
        this.parseInit(init);
        this.getURL = function (state, chain, fields) {
            var url = this.url + "?" +
                    "chromosome=" + state.chr + "&" +
                    "start=" + state.start + "&" +
                    "end=" + state.end + "&" +
                    "phenotype=" + phenotype;
            if (state.condition_on_variant){
                url += "&variantId=" + state.condition_on_variant.replace(/[^0-9ATCG]/g,"_")
            }
            return url;
        }
    }, "BroadT2D");


    function addLZPhenotype(lzParameters) {
        var phenotype = lzParameters.phenotype;

        dataSources.add(phenotype, new broadAssociationSource("${createLink(controller:"gene", action:"getLocusZoom")}", phenotype))

        var layout = {
            title: lzParameters.description,
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
            data_layers: {
                significance: {
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
                recomb: {
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
                positions: {
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
                    tooltip: {
                        html: "<strong><a href=${g.createLink(controller: "variantInfo", action: "variantInfo")}/?lzId={{" + phenotype + ":id}} target=_blank>{{" + phenotype + ":id}}</a></strong><br>"
                        + "P Value: <strong>{{" + phenotype + ":pvalue|scinotation}}</strong><br>"
                        + "Ref. Allele: <strong>{{" + phenotype + ":refAllele}}</strong><br>"
                        + "<a href=\"#\" onClick=\"locusZoomPlot.applyState({condition_on_variant:'{{" + phenotype + ":id}}'});\">Condition on this variant</a>"
                    }
                }
            }
        };

        locusZoomPlot.addPanel(phenotype, layout);
    }


    var initializeLZPage = function (page, variantId, positionInfo) {
        var loading = $('#spinner').show();
        var chromosome = positionInfo.chromosome;
        // make sure we don't get a negative start point
        var startPosition = Math.max(0, positionInfo.startPosition);
        var endPosition = positionInfo.endPosition;

        var locusZoomInput = chromosome + ":" + startPosition + "-" + endPosition;
        $("#lz-1").attr("data-region", locusZoomInput);
        $("#lzRegion").text(locusZoomInput);
        loading.hide();

        var lzVarId = '';
        // need to process the varId to match the IDs that LZ is getting, so that
        // the correct reference variant is displayed
        if (page == 'variantInfo') {
            lzVarId = variantId;
            // we have format: 8_118184783_C_T
            // need to get format like: 8:118184783_C/T
            var splitVarId = variantId.split('_');
            lzVarId = splitVarId[0] + ':' + splitVarId[1] + '_' + splitVarId[2] + '/' + splitVarId[3];
        }

        var returned = mpgSoftware.locusZoom.initLocusZoom('#lz-1', lzVarId);
        locusZoomPlot = returned.locusZoomPlot;
        dataSources = returned.dataSources;

        // default panel
        addLZPhenotype({
            phenotype: 'T2D',
            description: 'Type 2 Diabetes'
        });

        $("#collapseLZ").on("shown.bs.collapse", function () {
            locusZoomPlot.rescaleSVG();
        });
    };

    mpgSoftware.locusZoom.initializeLZPage = initializeLZPage;

</script>

<div class="accordion-group">
    <div class="accordion-heading">
        <a class="accordion-toggle  collapsed" data-toggle="collapse" data-parent="#accordion3"
           href="#collapseLZ">
            <h2><strong><g:message code="variant.locusZoom.title" default="Locus Zoom"/></strong></h2>
        </a>
    </div>

    <div id="collapseLZ" class="accordion-body collapse">
        <p><g:message code="variant.locusZoom.text"/></p>

        <div style="display: flex; justify-content: space-around;">
            <p>Linkage disequilibrium (r<sup>2</sup>) with the reference variant:</p>

            <p><i class="fa fa-circle" style="color: #d43f3a"></i> 1 - 0.8</p>

            <p><i class="fa fa-circle" style="color: #eea236"></i> 0.8 - 0.6</p>

            <p><i class="fa fa-circle" style="color: #5cb85c"></i> 0.6 - 0.4</p>

            <p><i class="fa fa-circle" style="color: #46b8da"></i> 0.4 - 0.2</p>

            <p><i class="fa fa-circle" style="color: #357ebd"></i> 0.2 - 0</p>

            <p><i class="fa fa-circle" style="color: #B8B8B8"></i> no information</p>

            <p><i class="fa fa-circle" style="color: #9632b8"></i> reference variant</p>
        </div>
        <ul class="nav navbar-nav navbar-left" style="display: flex;">
            <li class="dropdown" id="tracks-menu-dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Phenotypes<b class="caret"></b></a>
                <ul id="trackList" class="dropdown-menu">
                    <g:each in="${lzOptions}">
                        <li><a onclick="addLZPhenotype({
                            phenotype: '${it.key}',
                            description: '${it.description}'
                        })">
                            ${g.message(code: "metadata." + it.name)}
                        </a></li>
                    </g:each>
                </ul>
            </li>
            <li style="margin: auto;">
                <b>Region: <span id="lzRegion"></span></b>
            </li>
        </ul>

        <div class="accordion-inner">
            <div id="lz-1" class="lz-container-responsive"></div>
        </div>

    </div>
</div>
