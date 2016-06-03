
<script type="text/javascript">
    var locusZoomPlot;
    var dataSources;
    // objects needed for both initialization and for adding more phenotypes
    var broadAssociationSource = LocusZoom.Data.Source.extend(function(init, phenotype) {
        this.parseInit(init);
        this.getURL = function(state, chain, fields) {
            //var analysis = state.analysis || chain.header.analysis || this.params.analysis || 3;
            return this.url + "?" +
             "chromosome=" + state.chr + "&" +
             "start=" + state.start + "&"+
             "end=" + state.end + "&" +
             "phenotype=" + phenotype;
        }
    }, "BroadT2D");


    function addLZPhenotype(lzParameters) {
        var phenotype = lzParameters.phenotype;

        var ld_source = [ "LDLZ",
            { url: mpgSoftware.locusZoom.apiBase + "pair/LD/",
                params: {
                    pvalue_field: phenotype + ":pvalue|neglog10",
                    position_field: phenotype + ":position",
                    id_field: phenotype + ":id"
                }
            }
        ];
        dataSources.add(phenotype, new broadAssociationSource("${createLink(controller:"gene", action:"getLocusZoom")}", phenotype))
                    .add(phenotype + "_ld", ld_source);

        var layout = {
            title: lzParameters.description,
            description: phenotype,
            y_index: -1,
            min_width:  400,
            min_height: 112.5,
            margin: { top: 35, right: 50, bottom: 40, left: 50 },
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
                }
            },
            data_layers: {
                significance: {
                    type: "line",
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
                positions: {
                    type: "scatter",
                    point_shape: "circle",
                    point_size: 40,
                    fields: [phenotype+":id",
                        phenotype+":position",
                        phenotype+":pvalue|scinotation",
                        phenotype+":pvalue|neglog10",
                        phenotype+":refAllele",
                        phenotype+"_ld:state"],
                    id_field: phenotype+":id",
                    x_axis: {
                        field: phenotype+":position"
                    },
                    y_axis: {
                        axis: 1,
                        field: phenotype+":pvalue|neglog10",
                        floor: 0,
                        upper_buffer: 0.05,
                        min_extent: [ 0, 10 ]
                    },
                    color: {
                        field: phenotype+"_ld:state",
                        scale_function: "numerical_bin",
                        parameters: {
                            breaks: [0, 0.2, 0.4, 0.6, 0.8],
                            values: ["#357ebd","#46b8da","#5cb85c","#eea236","#d43f3a"],
                            null_value: "#B8B8B8"
                        }
                    },
                    tooltip: {
                        divs: [
                            { html: "<strong>{{"+phenotype+":id}}</strong>" },
                            { html: "P Value: <strong>{{"+phenotype+":pvalue|scinotation}}</strong>" },
                            { html: "Ref. Allele: <strong>{{"+phenotype+":refAllele}}</strong>" }
                        ]
                    }
                }
            }
        };

        locusZoomPlot.addPanel(phenotype, layout);
    }




    $( document ).ready( function (){
        var variant;
        var loading = $('#spinner').show();
        var position = null;
        var chromosome = null;
        var varId = null;
        var locusZoomInput = null;
        var rangeInteger = 80000;
        $.ajax({
            cache: false,
            type: "get",
            url:('<g:createLink controller="variantInfo" action="variantAjax"/>'+'/${variantToSearch}'),
            async: true,
            success: function (data) {
                if ( typeof data !== 'undefined')  {
                    if ( typeof data.variant !== 'undefined')  {
                        if ( typeof data.variant.variants[0] !== 'undefined')  {
                            data.variant.variants[0].forEach(function (v) {
                                if ( typeof v.CHROM !== 'undefined')  {
                                    chromosome = v.CHROM;
                                }
                                if ( typeof v.POS !== 'undefined')  {
                                    position = v.POS;
                                }
                                if ( typeof v.VAR_ID !== 'undefined')  {
                                    varId = v.VAR_ID;
                                }
                            });
                        }
                    }
                }

                // get the locuszoom range and set it on the LZ div
                var startPosition = parseInt(position) - rangeInteger;
                if (startPosition < 0) {
                    startPosition = 0;
                }
                var endPosition = parseInt(position) + rangeInteger;
                locusZoomInput = chromosome + ":" + startPosition + "-" + endPosition;
                console.log(locusZoomInput);
                $("#lz-1").attr("data-region", locusZoomInput);
                $("#lzRegion").text(locusZoomInput);
                loading.hide();

                var returned = mpgSoftware.locusZoom.initLocusZoom('#lz-1');
                locusZoomPlot = returned.locusZoomPlot;
                dataSources = returned.dataSources;

                // default panel
                addLZPhenotype({
                    phenotype: 'T2D',
                    description: 'Type 2 Diabetes'
                });

                $("#collapseLZ").on("shown.bs.collapse", function() {
                    locusZoomPlot.rescaleSVG();
                })

            },
            error: function (jqXHR, exception) {
                loading.hide();
                core.errorReporter(jqXHR, exception);
            }
        });

    } );


</script>

<div class="accordion-group">
    <div class="accordion-heading">
        <a class="accordion-toggle  collapsed" data-toggle="collapse" data-parent="#accordion3"
           href="#collapseLZ">
            <h2><strong><g:message code="gene.locusZoom.title" default="Locus Zoom"/></strong></h2>
        </a>
    </div>

    <div id="collapseLZ" class="accordion-body collapse">
        <ul class="nav navbar-nav navbar-left">
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
        </ul>
        <div class="accordion-inner">
                        <div>
                                <b>Region: <span id="lzRegion"></span></b>
                        </div>
                        <!-- TODO: get LZ canvas to dynamically resize to width of enclosing div and height to minimum possible for display -->
                        <div id="lz-1" class="lz-container-responsive" data-region="${regionSpecification}"></div>

        </div>
    </div>
</div>
