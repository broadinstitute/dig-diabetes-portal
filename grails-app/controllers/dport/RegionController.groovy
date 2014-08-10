package dport

import org.codehaus.groovy.grails.web.json.JSONObject

class RegionController {
    RestServerService   restServerService

    def index() { }

    def regionInfo() {
        String regionSpecification = params.id

        render (view: 'regionInfo',
                model:[regionSpecification: regionSpecification,
                       show_gene:1,
                       show_gwas:1,
                       show_exchp: 1,
                       show_exseq: 1,
                       show_sigma: 0] )
    }

    def regionAjax() {
        String regionsSpecification = params.id

        JSONObject jsonObject =  restServerService.searchGenomicRegionAsSpecifiedByUsers (regionsSpecification)
        render(status:200, contentType:"application/json") {
            [variants:jsonObject['variants']]
        }
    }

}
