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
        resource url: 'js/lib/dport/datatablesSorting.js'

        resource url: 'css/lib/datatables/buttons.dataTables.css'
        resource url: 'css/lib/datatables/jquery.dataTables.css'
        resource url: 'css/lib/datatables/select.dataTables.css'

        resource url: 'css/dport/jqDataTables.css'
    }
    scroller {
        resource url: 'js/lib/dport/jquery.li-scroller.1.0.js'
        resource url: 'css/lib/li-scroller.css'
    }
    portalHome {
        resource url: 'js/lib/dport/portalHome.js'
    }
    regionInfo {
        resource url: 'js/lib/dport/regionInfo.js'
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
    burdenTest {
        resource url: 'css/dport/burdenTest.css'
        resource url: 'js/lib/dport/burdenTest.js'
        resource url: 'js/lib/dport/burdenTestShared.js'
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
    matrix {
        dependsOn "d3tooltip"

        resource url: 'js/lib/dport/matrix.js'
        resource url: 'css/dport/matrix.css'
    }
    multiTrack {
        dependsOn "core"

        resource url: 'js/lib/dport/multiTrack.js'
        resource url: 'css/dport/multiTrack.css'
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
        dependsOn "core", "mbar", "multiTrack","bootstrapMultiselect", "igv","burdenTest", "geneSignalSummary", "tableViewer"

        resource url: 'css/dport/geneInfo.css'
        resource url: 'css/dport/barchart.css'

        resource url: 'js/lib/dport/geneInfo.js'
        resource url: 'js/lib/dport/barchart.js'

    }
    variantInfo {

        dependsOn "core", "mbar", "bootstrapMultiselect", "igv","burdenTest", "matrix"

        resource url: 'css/images/controls.png'

        resource url: 'css/dport/geneInfo.css'
        resource url: 'css/dport/barchart.css'
        resource url: 'css/dport/variant.css'
        resource url: 'css/dport/variantInfo.css'
        resource url: 'css/dport/jqDataTables.css'

        resource url: 'js/lib/dport/geneInfo.js'
        resource url: 'js/lib/dport/variantInfo.js'
        resource url: 'js/lib/dport/barchart.js'
        resource url: 'js/lib/dport/igvLaunch.js'
    }
    variantWF {
        resource url: 'css/dport/variantWorkflow.css'
        resource url: 'js/lib/dport/variantWorkflow.js'
    }

    datasetsPage {
        resource url: 'css/dport/datasets.css'
        resource url: 'js/lib/dport/datasetsPage.js'
    }
    variantSearchResults {
        dependsOn "tableViewer"

        resource url: 'css/dport/variantSearchResults.css'
        resource url: 'js/lib/dport/variantSearchResults.js'
    }
    igv {
        dependsOn "jquery"

        resource url: 'js/lib/dport/igvLaunch.js'

        resource url: 'images/ajaxLoadingAnimation.gif'
        resource url: 'https://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css'

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
    geneSignalSummary {
        dependsOn 'variantSearchResults'
        resource url: 'js/lib/dport/geneSignalSummary.js'
        resource url: 'css/dport/geneSignalSummary.css'
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

        resource url: 'https://igv.org/web/release/1.0.5/igv-1.0.7.css'
        resource url: 'https://igv.org/web/release/1.0.5/igv-1.0.7.js'
    }
    sigma {  // sigma site
        resource url: 'css/dport/sigma.css'
        resource url: 'js/lib/jquery-1.11.0.min.js'
    }
    locusZoom {
        resource url: 'https://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css'
        resource url: 'js/lib/locuszoom.vendor.min.js'
//        resource url: 'https://statgen.github.io/locuszoom/versions/0.5.6/locuszoom.app.js'
//        resource url: 'https://statgen.github.io/locuszoom/versions/0.5.6/locuszoom.css'
        resource url: 'js/lib/locuszoom.app.js'
        resource url: 'css/lib/locuszoom.css'

        resource url: 'js/lib/dport/locusZoomPlot.js'
    }
    media {
        resource url: 'https://malsup.github.com/jquery.media.js'
    }

}

