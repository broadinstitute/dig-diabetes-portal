modules = {
    jquery {
        resource url: 'https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js'
        resource url: 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js'
        resource url: 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css'
        resource url: 'https://cdn.datatables.net/v/dt/dt-1.10.18/datatables.min.css'
        resource url: 'https://cdn.datatables.net/v/dt/dt-1.10.18/datatables.min.js'
    }
    variantInfoPage{
        dependsOn 'jquery'
        resource url: 'https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css'
        resource url: 'https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js'
        resource url: 'js/lib/dport/multiTrack.js'
        resource url: 'css/dport/multiTrack.css'
    }
    datatables {
        dependsOn 'jquery'
         resource url: 'js/lib/dport/datatablesSorting.js'
    }
    scroller {
        resource url: 'css/lib/li-scroller.css'
    }
    portalHome {
        dependsOn 'core'
        resource url: 'js/lib/dport/portalHome.js'
    }
    grsInfo {
        dependsOn "core", "mbar", "bootstrapMultiselect", "burdenTest","boxwhisker"


        resource url: 'js/lib/dport/grsInfo.js'
        resource url: 'css/dport/grsInfo.css'
    }

    gaitInfo {
        dependsOn "core", "mbar", "bootstrapMultiselect", "burdenTest","boxwhisker"

        resource url: 'js/lib/dport/gaitInfo.js'
        resource url: 'css/dport/grsInfo.css'
    }

    regionInfo {
        resource url: 'js/lib/dport/regionInfo.js'
        resource url: 'css/dport/regionInfo.css'
    }
    informational {
        resource url: 'js/lib/dport/informational.js'
    }
    traitInfo {
        resource url: 'css/dport/trait.css'
        resource url: 'js/lib/dport/trait.js'
        resource url: 'js/lib/dport/associationStatistics.js'
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
        resource url: 'js/lib/dport/manhattanplotTableHeader.js'
        resource url: 'js/lib/dport/genePrioritization.js'
    }
    mode3 {
        dependsOn "d3tooltip"
        dependsOn "manhattan"
        dependsOn "traitsFilter"

        resource url: 'js/lib/dport/moduleLaunch.js'
        resource url: 'js/lib/dport/manhattanplotTableHeader.js'
        resource url: 'js/lib/dport/traitsFilter.js'
    }
    matrix {
        dependsOn "d3tooltip"

        resource url: 'js/lib/dport/matrix.js'
        resource url: 'css/dport/matrix.css'
    }
    varsImpacter {
        dependsOn "core"

        resource url: 'js/lib/dport/varsImpacter.js'
        resource url: 'css/dport/varsImpacter.css'
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
        dependsOn "core", "portalHome","dynamicUi"

        resource url: 'css/dport/geneInfo.css'
        resource url: 'css/dport/barchart.css'

        resource url: 'js/lib/dport/geneInfo.js'
        resource url: 'js/lib/dport/barchart.js'

        resource url: 'js/lib/dport/boxWhiskerPlot.js'
        resource url: 'css/dport/boxWhiskerPlot.css'

        resource url: 'css/dport/mbarchart.css'
        resource url: 'js/lib/dport/mbarchart.js'

        resource url: 'js/lib/dport/varsImpacter.js'
        resource url: 'css/dport/varsImpacter.css'

        resource url: 'js/lib/bootstrap-multiselect.js'
        resource url: 'css/lib/bootstrap-multiselect.css'

        resource url: 'css/lib/bootstrap-select.css'
        resource url: 'js/lib/bootstrap-select.js'
        resource url: 'js/lib/dport/traitsFilter.js'

        resource url: 'css/dport/burdenTest.css'
        resource url: 'js/lib/dport/burdenTest.js'
        resource url: 'js/lib/dport/burdenTestShared.js'

        resource url: 'js/lib/dport/datatablesSorting.js'
        resource url: 'js/lib/dport/tableViewer.js'
        resource url: 'css/dport/tableViewer.css'

        resource url: 'js/lib/dport/regionInfo.js'
        resource url: 'css/dport/regionInfo.css'

        resource url: 'css/dport/variantSearchResults.css'
        resource url: 'js/lib/dport/variantSearchResults.js'

        resource url: 'js/lib/dport/geneSignalSummary.js'
        resource url: 'css/dport/geneSignalSummary.css'

        resource url: 'js/lib/dport/matrixMath.js'
    }
    variantInfo {

        dependsOn "core", "mbar", "bootstrapMultiselect","burdenTest", "matrix", "portalHome"

        resource url: 'css/images/controls.png'

        resource url: 'css/dport/geneInfo.css'
        resource url: 'css/dport/barchart.css'
        resource url: 'css/dport/variant.css'
        resource url: 'css/dport/variantInfo.css'
        resource url: 'css/dport/jqDataTables.css'

        resource url: 'js/lib/dport/geneInfo.js'
        resource url: 'js/lib/dport/variantInfo.js'
        resource url: 'js/lib/dport/barchart.js'
        resource url: 'js/lib/dport/associationStatistics.js'

        resource url: 'js/lib/dport/traitsFilter.js'
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
        dependsOn 'variantSearchResults','dynamicUi'
        resource url: 'js/lib/dport/geneSignalSummary.js'
        resource url: 'css/dport/geneSignalSummary.css'

    }
    dynamicUi {
        resource url: 'js/lib/dport/dynamicUi.js'
        resource url: 'css/dport/dynamicUi.css'

        resource url: 'js/lib/dport/dynamicUi/geneBurdenFirth.js'
        resource url: 'js/lib/dport/dynamicUi/geneBurdenSkat.js'
        resource url: 'js/lib/dport/dynamicUi/metaXcan.js'
        resource url: 'js/lib/dport/dynamicUi/depictGeneSets.js'
        resource url: 'js/lib/dport/dynamicUi/depictGenePriority.js'
        resource url: 'js/lib/dport/dynamicUi/eCaviar.js'
        resource url: 'js/lib/dport/dynamicUi/coloc.js'
        resource url: 'js/lib/dport/dynamicUi/mouseKnockout.js'
    }
    mustache {
        resource url: 'js/lib/mustache.js'
    }
    core {
        dependsOn "jquery"

        resource url: 'images/ajax-loader.gif'

        resource url: 'css/lib/bootstrap.min.css'
        resource url: 'js/lib/bootstrap.min.js'

        resource url: 'https://cdnjs.cloudflare.com/ajax/libs/mustache.js/3.0.1/mustache.min.js'

        resource url: 'css/lib/style.css'
        resource url: 'css/lib/dkstyle.css'

        resource url: 'js/lib/d3.min.js'
        resource url: 'js/lib/utils.js'

        resource url: 'js/lib/bootstrap3-typeahead.min.js'

        resource url: 'js/lib/lodash.min.js'

        resource url: 'js/lib/dport/portalHome.js'
    }
    igvNarrow {  // IGV on a page with core
        resource url: 'https://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css'

        resource url: 'css/igv/igv-1.0.5.css'
        resource url: 'js/igv/igv-1.0.5.js'
    }
    sigma {  // sigma site
        resource url: 'css/dport/sigma.css'
    }
    locusZoom {
        resource url: 'https://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css'
        resource url: 'js/lib/locuszoom.vendor.min.js'
        resource url: 'js/lib/locuszoom.app.js'
        resource url: 'js/lib/gwas-credible-sets.js'

        resource url: 'js/lib/dport/locusZoomPlot.js'
    }
    media {
        resource url: 'https://malsup.github.com/jquery.media.js'
    }
    traitSample {
        resource url: 'js/lib/dport/traitSample.js'
    }
    traitsFilter {

        resource url: 'css/lib/bootstrap-select.css'
        resource url: 'js/lib/bootstrap-select.js'
        resource url: 'js/lib/dport/traitsFilter.js'
    }
    higlass {
        resource url:"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
        resource url:"https://unpkg.com/higlass@1.0.1/dist/styles/hglib.css"

        resource url:"https://cdnjs.cloudflare.com/ajax/libs/react/15.6.2/react.min.js"
        resource url:"https://cdnjs.cloudflare.com/ajax/libs/react-dom/15.6.2/react-dom.min.js"
        resource url:"https://cdnjs.cloudflare.com/ajax/libs/pixi.js/4.6.2/pixi.min.js"
        resource url:"https://cdnjs.cloudflare.com/ajax/libs/react-bootstrap/0.31.0/react-bootstrap.min.js"
        resource url:"https://unpkg.com/higlass@1.0.1/dist/scripts/hglib.js"

//        resource url: 'js/lib/HiGlassComponent.js'
    }

}

