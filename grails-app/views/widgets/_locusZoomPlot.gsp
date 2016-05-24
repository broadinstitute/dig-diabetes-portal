
    <!--
    <script src="https://code.jquery.com/jquery-2.1.4.min.js" type="text/javascript"></script>
    -->

    <script src="https://portaldev.sph.umich.edu/lz-amp/locuszoom.vendor.min.js" type="application/javascript"></script>
    <script src="https://portaldev.sph.umich.edu/lz-amp/locuszoom.app.js" type="application/javascript"></script>
    <link rel="stylesheet" type="text/css" href="https://portaldev.sph.umich.edu/lz-amp/locuszoom.css" />

    %{--<script src="https://portaldev.sph.umich.edu/lz-amp/locuszoom.vendor.min.js" type="text/javascript"></script>--}%
    %{--<script src="https://portaldev.sph.umich.edu/lz-amp/locuszoom.next.js" type="text/javascript"></script>--}%

    %{--<link rel="stylesheet" type="text/css" href="https://portaldev.sph.umich.edu/lz-amp/locuszoom.next.css"/>--}%

    <script type="text/javascript">
        // objects needed for both initialization and for adding more phenotypes
        var apiBase = "https://portaldev.sph.umich.edu/api/v1/";
        var ds = new LocusZoom.DataSources();
        var broadAssociationSource;

        function addLZPhenotype(lzParameters) {
            var phenotype = lzParameters.phenotype;

            var ld_source = [ "LDLZ",
                { url: apiBase + "pair/LD/",
                    params: {
                        pvalue_field: phenotype + ":pvalue|neglog10",
                        position_field: phenotype + ":position",
                        id_field: phenotype + ":id"
                    }
                }
            ];
            ds.add(phenotype, new broadAssociationSource("${createLink(controller:"gene", action:"getLocusZoom")}", phenotype))
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

            locuszoom_plot.addPanel(phenotype, layout);
        }


        var mpgSoftware = mpgSoftware || {};

        mpgSoftware.locusZoom = (function () {

            broadAssociationSource = LocusZoom.Data.Source.extend(function(init, phenotype) {
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

			ds.add("base", new broadAssociationSource("${createLink(controller:"gene", action:"getLocusZoom")}", "T2D"))
			  .add("ld", ["LDLZ" ,apiBase + "pair/LD/"])
			  .add("gene", ["GeneLZ", apiBase + "annotation/genes/"])
              .add("recomb", ["RecombLZ", { url: apiBase + "annotation/recomb/results/", params: {source: 15} }])
              .add("sig", ["StaticJSON", [{ "x": 0, "y": 4.522 }, { "x": 2881033286, "y": 4.522 }] ]);

            function initLocusZoom(stateInput) {
                // TODO - will need to test that incorrect input format doesn't throw JS exception which stops all JS activity
                // TODO - need to catch all exceptions to make sure rest of non LZ JS modules on page load properly (scope errors to this module)
//                return LocusZoom.populate("#lz-1", ds);
                var layout = LocusZoom.mergeLayouts({state: stateInput, panels: {positions: { title: "Type 2 diabetes"}}}, LocusZoom.StandardLayout);
                return LocusZoom.populate("#lz-1", ds, layout);
            };

            // public routines are declared below
            return {
                initLocusZoom:initLocusZoom
            }

        }());

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
                        data.variant.variants[0]
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
                    chromosome = 22;
                    position = 29837203;
                    rangeInteger = 100000;

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

                    // build state for the lz object
                    var stateVar;
                    if (typeof varId !== 'undefined')  {
                        var varIdArray = varId.split("_");
                        stateVar = {
                            chr: chromosome,
                            start: startPosition,
                            end: endPosition,
                            ldrefvar: varIdArray[0] + ":" + varIdArray[1] + "_" + varIdArray[2] + "/" + varIdArray[3]
                        };
                    }

//                    alert(stateVar);
//                    debugger
                    locuszoom_plot = mpgSoftware.locusZoom.initLocusZoom(stateVar);

                    $("#collapseLZ").on("shown.bs.collapse", function() {
                        locuszoom_plot.rescaleSVG();
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
