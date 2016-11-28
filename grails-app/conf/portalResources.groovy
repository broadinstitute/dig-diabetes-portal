modules = {
    jquery {
        resource url: 'js/lib/jquery-1.11.0.min.js'
        resource url: 'js/lib/jstree.min.js'
        resource url: 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/jquery-ui.min.js'
    }
    datatables {
        dependsOn 'jquery'
        resource url: 'js/lib/datatables/jquery.dataTables.js'
        resource url: 'js/lib/dport/datatablesSorting.js'

        resource url: 'js/lib/datatables/pdfmake.js'
        resource url: 'js/lib/datatables/vfs_fonts.js'
        resource url: 'js/lib/datatables/buttons.html5.js'
        resource url: 'js/lib/datatables/buttons.print.js'
        resource url: 'js/lib/datatables/dataTables.buttons.js'
        resource url: 'js/lib/datatables/dataTables.select.js'

        resource url: 'css/lib/datatables/buttons.dataTables.css'
        resource url: 'css/lib/datatables/jquery.dataTables.css'
        resource url: 'css/lib/datatables/select.dataTables.css'

    }
    scroller {
        resource url: 'js/lib/dport/jquery.li-scroller.1.0.js'
        resource url: 'css/lib/li-scroller.css'
    }
    portalHome {
        resource url: 'js/lib/dport/portalHome.js'
    }
    informational {
        resource url: 'js/lib/dport/informational.js'
    }
    traitInfo {
        resource url: 'css/dport/trait.css'
        resource url: 'js/lib/dport/trait.js'
    }
    sunburst {
        resource url: 'css/dport/sunburst.css'
        resource url: 'js/lib/dport/sunburst.js'
    }
    mbar {
        resource url: 'css/dport/mbarchart.css'
        resource url: 'js/lib/dport/mbarchart.js'
    }

    d3tooltip {
        resource url: 'js/lib/dport/d3tooltip.js'
        resource url: 'css/dport/d3tooltip.css'
    }
    manhattan {
        dependsOn "d3tooltip"

        resource url: 'js/lib/dport/manhattan.js'
        resource url: 'css/dport/manhattan.css'
    }
    boxwhisker {
        dependsOn "d3tooltip"

        resource url: 'js/lib/dport/boxWhiskerPlot.js'
        resource url: 'css/dport/boxWhiskerPlot.css'
    }
    crossMap {
        dependsOn "d3tooltip"

        resource url: 'js/lib/dport/crossMap.js'
    }
    phenotype {
        dependsOn "manhattan"

        resource url: 'js/lib/dport/phenotype.js'
    }
    geneInfo {
        dependsOn "core", "mbar", "bootstrapMultiselect"

        resource url: 'css/dport/geneInfo.css'
        resource url: 'css/dport/barchart.css'

        resource url: 'js/lib/dport/geneInfo.js'
        resource url: 'js/lib/dport/barchart.js'

        resource url: 'js/lib/dport/igvLaunch.js'
    }
    variantInfo {
        dependsOn "core", "mbar", "bootstrapMultiselect"

        resource url: 'css/images/controls.png'

        resource url: 'css/dport/geneInfo.css'
        resource url: 'css/dport/barchart.css'
        resource url: 'css/dport/variant.css'

        resource url: 'js/lib/dport/geneInfo.js'
        resource url: 'js/lib/dport/variantInfo.js'
        resource url: 'js/lib/dport/barchart.js'

        resource url: 'js/lib/dport/igvLaunch.js'
    }
    variantWF {
        resource url: 'css/dport/variantWorkflow.css'
        resource url: 'js/lib/dport/variantWorkflow.js'
    }
    variantSearchResults {
        dependsOn "tableViewer"

        resource url: 'js/lib/dport/variantSearchResults.js'
    }
    igv {
        dependsOn "jquery"

        resource url: 'images/ajaxLoadingAnimation.gif'
        resource url: 'https://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css'

//        resource url: 'https://igv.org/web/release/1.0.1/igv-1.0.1.css'
//        resource url: 'https://igv.org/web/release/1.0.1/igv-1.0.1.min.js'
        resource url: 'https://igv.org/web/release/1.0.5/igv-1.0.5.css'
        resource url: 'https://igv.org/web/release/1.0.5/igv-1.0.5.js'

    }
    bootstrapMultiselect {
        resource url: 'js/lib/bootstrap-multiselect.js'
        resource url: 'css/lib/bootstrap-multiselect.css'
    }
    tableViewer {
        dependsOn 'datatables'
        resource url: 'js/lib/dport/tableViewer.js'
        resource url: 'css/dport/tableViewer.css'
    }
    mustache {
        resource url: 'js/lib/mustache.js'
    }
    core {
        dependsOn "jquery"

        resource url: 'images/ajax-loader.gif'
        resource url: 'images/icons/dna-strands.ico'

        resource url: 'css/lib/bootstrap.min.css'
        resource url: 'js/lib/bootstrap.min.js'

        resource url: 'css/lib/style.css'
        resource url: 'css/lib/dkstyle.css'

        resource url: 'js/lib/d3.min.js'
        resource url: 'js/lib/utils.js'

        resource url: 'js/lib/bootstrap3-typeahead.min.js'

        resource url: 'js/lib/lodash.min.js'

    }
    igvNarrow {  // IGV on a page with core
        resource url: 'https://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css'
//        resource url: 'https://igv.org/web/release/1.0.1/igv-1.0.1.css'
//        resource url: 'https://igv.org/web/release/1.0.1/igv-1.0.1.min.js'
        resource url: 'https://igv.org/web/release/1.0.5/igv-1.0.5.css'
        resource url: 'https://igv.org/web/release/1.0.5/igv-1.0.5.js'
    }
    sigma {  // sigma site
        resource url: 'css/dport/sigma.css'
        resource url: 'js/lib/jquery-1.11.0.min.js'
    }
    locusZoom {
        resource url: 'https://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css'
        resource url: 'js/lib/locuszoom.vendor.min.js'
        resource url: 'https://statgen.github.io/locuszoom/versions/0.5.0/locuszoom.app.js'
        resource url: 'https://statgen.github.io/locuszoom/versions/0.5.0/locuszoom.css'
//        resource url: 'js/lib/locuszoom.app.js'
//        resource url: 'css/lib/locuszoom.css'

        resource url: 'js/lib/dport/locusZoomPlot.js'
    }
    media {
        resource url: 'https://malsup.github.com/jquery.media.js'
    }

}

