
    <!--
    <script src="https://code.jquery.com/jquery-2.1.4.min.js" type="text/javascript"></script>
    -->

    <script>
    </script>

    <script src="http://portaldev.sph.umich.edu/lz-amp/locuszoom.vendor.min.js" type="text/javascript"></script>
    <script src="http://portaldev.sph.umich.edu/lz-amp/locuszoom.next.js" type="text/javascript"></script>

    <link rel="stylesheet" type="text/css" href="http://portaldev.sph.umich.edu/lz-amp/locuszoom.next.css"/>

    <script type="text/javascript">
        var mpgSoftware = mpgSoftware || {};

        mpgSoftware.locusZoom = (function () {

			var broadAssociationSource = function(init) {
				this.parseInit(init);	
				this.getURL = function(state, chain, fields) {
				    //var analysis = state.analysis || chain.header.analysis || this.params.analysis || 3;
					return this.url + "?" +
						"chromosome=" + state.chr + "&" +
						"start=" + state.start + "&"+
						"end=" + state.end;
				}
			};
			broadAssociationSource.SOURCE_NAME = "BroadT2D";
			broadAssociationSource.prototype = Object.create(LocusZoom.Data.AssociationSource.prototype);
			broadAssociationSource.prototype.constructor = broadAssociationSource;

			var apiBase = "http://portaldev.sph.umich.edu/api_internal_dev/v1/";
			var ds = new LocusZoom.DataSources();
			//ds.addSource("base", ["AssociationLZ", {url:apiBase + "single/", params: {analysis: 3}}]);
			ds.addSource("base", new broadAssociationSource("${createLink(controller:"gene", action:"getLocusZoom")}"));
			ds.addSource("ld", ["LDLZ" ,apiBase + "pair/LD/"]);
			ds.addSource("gene", ["GeneLZ", apiBase + "annotation/genes/"]);

            function initLocusZoom() {
                // TODO - will need to test that incorrect input format doesn't throw JS exception which stops all JS activity
                // TODO - need to catch all exceptions to make sure rest of non LZ JS modules on page load properly (scope errors to this module)
                return LocusZoom.populate("#lz-1", ds);
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

                    //global object for debugging
                    locuszoom_plot = mpgSoftware.locusZoom.initLocusZoom();
                    $("#collapseLZ").on("shown.bs.collapse", function() {
                        locuszoom_plot.setDimensions();
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
        <div class="accordion-inner">
                        <div>
                                <b>Region: <span id="lzRegion"></span></b>
                        </div>
                        <!-- TODO: get LZ canvas to dynamically resize to width of enclosing div and height to minimum possible for display -->
                        <div id="lz-1" class="lz-container-responsive" data-region="${regionSpecification}"></div>

        </div>
    </div>
</div>
