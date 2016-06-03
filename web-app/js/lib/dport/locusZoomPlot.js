
var mpgSoftware = mpgSoftware || {};

mpgSoftware.locusZoom = {
    apiBase: 'https://portaldev.sph.umich.edu/api/v1/',

    // standard layout
    StandardLayout: {
        resizable: "responsive",
        aspect_ratio: 2.5,
        panels: {
            genes: {
                margin: { top: 20, right: 50, bottom: 20, left: 50 },
                axes: {},
                data_layers: {
                    genes: {
                        type: "genes",
                        fields: ["gene:gene", "constraint:constraint"],
                        id_field: "gene_id",
                        selectable: "one",
                        tooltip: {
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
                }
            }
        }
    },
    
    initLocusZoom: function(selector) {
        // TODO - will need to test that incorrect input format doesn't throw JS exception which stops all JS activity
        // TODO - need to catch all exceptions to make sure rest of non LZ JS modules on page load properly (scope errors to this module)
        var ds = new LocusZoom.DataSources();
        ds.add("constraint", ["GeneConstraintLZ", { url: "http://exac.broadinstitute.org/api/constraint" }])
            .add("ld", ["LDLZ" , mpgSoftware.locusZoom.apiBase + "pair/LD/"])
            .add("gene", ["GeneLZ", mpgSoftware.locusZoom.apiBase + "annotation/genes/"])
            .add("recomb", ["RecombLZ", { url: mpgSoftware.locusZoom.apiBase + "annotation/recomb/results/", params: {source: 15} }])
            .add("sig", ["StaticJSON", [{ "x": 0, "y": 4.522 }, { "x": 2881033286, "y": 4.522 }] ]);
        var lzp = LocusZoom.populate(selector, ds, mpgSoftware.locusZoom.StandardLayout);
        return {
            locusZoomPlot: lzp,
            dataSources: ds
        };
    }
};