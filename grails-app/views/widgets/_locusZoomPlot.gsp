
    <!--
    <script src="https://code.jquery.com/jquery-2.1.4.min.js" type="text/javascript"></script>
    -->

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
			//global object for debugging
            locuszoom_plot = mpgSoftware.locusZoom.initLocusZoom();
			$("#collapseLZ").on("shown.bs.collapse", function() {
				locuszoom_plot.setDimensions();
			})
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
                                <b>Region: ${regionSpecification}</b>
                        </div>
                        <!-- TODO: get LZ canvas to dynamically resize to width of enclosing div and height to minimum possible for display -->
                        <div id="lz-1" class="lz-container-responsive" data-region="${regionSpecification}"></div>

        </div>
    </div>
</div>
