modules = {

    dataTables {
        resource url: "js/lib/jquery.dataTables.min.js"
        resource url: "css/lib/jquery.dataTables.css"
    }
    geneInfo {
        resource url: 'css/dport/barchart.css'

        resource url: 'js/lib/dport/geneInfo.js'
        resource url: 'js/lib/dport/barchart.js'
    }
    variantInfo {
        resource url: 'js/lib/dport/variantInfo.js'
    }
    brandingStyle {
        resource url: 'css/lib/t2dBranding.css',bundle:'brandingStyle'
    }
    igv {
        resource url: 'js/lib/jquery-1.11.0.min.js'

        resource url: 'images/ajaxLoadingAnimation.gif'

        resource url: 'http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css'
        resource url: 'http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css'

//        resource url: "http://www.broadinstitute.org/igvdata/t2d/igv.css"

        resource url: 'http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js'

        resource url: 'http://www.broadinstitute.org/igvdata/t2d/igv-all.min.css'
        resource url: 'http://www.broadinstitute.org/igvdata/t2d/igv-all.min.js'


        resource url: 'css/lib/bootstrap.min.css'

    }
    core {
        dependsOn "dataTables"

        resource url: 'images/ajaxLoadingAnimation.gif'

        resource url: 'css/lib/bootstrap.min.css'

        resource url: 'css/lib/jquery.dataTables.css'

        resource url: 'css/lib/style.css'

        resource url: 'js/lib/d3.min.js'
        resource url: 'js/lib/utils.js'
        resource url: 'js/lib/jquery-1.11.0.min.js'
        resource url: 'js/lib/jquery.dataTables.min.js'
        resource url: 'js/lib/bootstrap3-typeahead.min.js'
        resource url: 'js/lib/shared.js'
        resource url: 'js/lib/d3.min.js'
    }


}

