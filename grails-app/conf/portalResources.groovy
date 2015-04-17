modules = {

    jquery {
        resource url: 'js/lib/jquery-1.11.0.min.js'
        resource url: "js/lib/jquery.dataTables.min.js"
        resource url: "css/lib/jquery.dataTables.css"
    }
    portalHome {
        resource url: 'js/lib/dport/portalHome.js'
    }
    informational {
        resource url: 'js/lib/dport/informational.js'
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
    }

    core {
        dependsOn "jquery"

        resource url: 'images/ajaxLoadingAnimation.gif'
        resource url: 'images/icons/dna-strands.ico'

        resource url: 'css/lib/bootstrap.min.css'

        resource url: 'css/lib/style.css'

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

}

