modules = {

    dataTables {
        resource url: "js/lib/jquery.dataTables.min.js"
        resource url: "css/lib/jquery.dataTables.css"
    }
    core {
        dependsOn "dataTables"

        resource url: 'css/lib/bootstrap.min.css'
        resource url: 'css/lib/style.css'

        resource url: 'js/lib/utils.js'
        resource url: 'js/lib/jquery-1.11.0.min.js'
        resource url: 'js/lib/bootstrap.min.js'
        resource url: 'js/lib/bootstrap3-typeahead.min.js'
        resource url: 'js/lib/underscore-min.js'
        resource url: 'js/lib/backbone-min.js'
        resource url: 'js/lib/shared.js'
        resource url: 'js/lib/d3.min.js'
    }


}

