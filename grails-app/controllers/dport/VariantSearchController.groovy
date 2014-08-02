package dport

import groovy.json.JsonSlurper
import org.codehaus.groovy.grails.web.json.JSONObject

class VariantSearchController {

        RestServerService   restServerService

        def index() { }


        def variantSearch() {
                render (view: 'variantSearch',
                        model:[show_gwas:1,
                               show_exchp: 1,
                               show_exseq: 1,
                               show_sigma: 0] )

        }
    }
