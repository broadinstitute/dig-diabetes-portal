modules = {

    jquery {
        resource url: 'js/lib/jquery-1.11.0.min.js'
        resource url: 'js/lib/jquery.dataTables.min.js'
        resource url: 'css/lib/jquery.dataTables.css'
        resource url: 'js/DataTables-1.10.7/media/css/jquery.dataTables.min.css'
        resource url: 'js/lib/dataTables.tableTools.min.js'
        resource url: 'css/lib/dataTables.tableTools.min.css'
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
    d3tooltip {
        resource url: 'js/lib/dport/d3tooltip.js'
        resource url: 'css/dport/d3tooltip.css'
    }
    manhattan {
        dependsOn "d3tooltip"

        resource url: 'js/lib/dport/manhattan.js'
        resource url: 'css/dport/manhattan.css'
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
        resource url: 'css/dport/geneInfo.css'
        resource url: 'css/dport/barchart.css'

        resource url: 'js/lib/dport/geneInfo.js'
        resource url: 'js/lib/dport/barchart.js'

        resource url: 'js/lib/dport/igvLaunch.js'
    }
    variantInfo {
        resource url: 'css/dport/barchart.css'
        resource url: 'css/dport/variant.css'

        resource url: 'js/lib/dport/variantInfo.js'
        resource url: 'js/lib/dport/barchart.js'

        resource url: 'js/lib/dport/igvLaunch.js'
    }
    variantWF {
        resource url: 'css/dport/variantWorkflow.css'
        resource url: 'js/lib/dport/variantWorkflow.js'
    }
    // igv and core independently call jquery
    igv {
        resource url: 'js/lib/jquery-1.11.0.min.js'

        resource url: 'images/ajaxLoadingAnimation.gif'

        resource url: 'http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css'
        resource url: 'http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css'

        resource url: 'http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js'

        resource url: 'http://www.broadinstitute.org/igvdata/t2d/igv-all.min.css'
        resource url: 'http://www.broadinstitute.org/igvdata/t2d/igv-all.min.js'


        resource url: 'css/lib/bootstrap.min.css'

    }
    tableViewer {
        resource url: 'js/lib/dport/tableViewer.js'
        resource url: 'css/dport/tableViewer.css'
    }

    core {
        dependsOn "jquery"

        resource url: 'images/ajaxLoadingAnimation.gif'
        resource url: 'images/icons/dna-strands.ico'

        resource url: 'css/lib/bootstrap.min.css'

        resource url: 'css/lib/style.css'
        resource url: 'css/lib/dkstyle.css'

        resource url: 'js/lib/d3.min.js'
        resource url: 'js/lib/utils.js'

        resource url: 'js/lib/bootstrap3-typeahead.min.js'
        resource url: 'js/lib/shared.js'
        resource url: 'js/lib/tooltip.js'
        resource url: 'js/lib/popover.js'

    }
    igvNarrow {  // IGV on a page with core
        resource url: 'http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css'
        resource url: 'http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css'

        resource url: 'http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js'

        resource url: 'http://www.broadinstitute.org/igvdata/t2d/igv-all.min.css'
        resource url: 'http://www.broadinstitute.org/igvdata/t2d/igv-all.min.js'
    }
    sigma {  // sigma site
        resource url: 'css/dport/sigma.css'
        resource url: 'js/lib/jquery-1.11.0.min.js'
        resource url: 'http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js'
    }
}

