package org.broadinstitute.mpg

import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.Experiment
import org.codehaus.groovy.grails.web.json.JSONObject
import org.springframework.web.servlet.support.RequestContextUtils

class InformationalController {
    RestServerService restServerService
    MetaDataService metaDataService

    def index() {}

    def about() {
        render(view: 'about')
    }

    def data() {
        Set<Experiment> allExperimentsForGivenVersion = []

        String currentVersion = metaDataService.getDataVersion()
        List<String> technologies = metaDataService.getTechnologyListByVersion(currentVersion)

        technologies.each {
            allExperimentsForGivenVersion.add(metaDataService.getExperimentByVersionAndTechnology(currentVersion, it, 1))
        }

        String locale = RequestContextUtils.getLocale(request)
        render(view: 'data', model: [locale: locale, experiments: allExperimentsForGivenVersion])
    }

    def aboutBeacon() {
        render(view: 'aboutBeacon')
    }

    def contactBeacon() {
        render(view: 'contactBeacon')
    }

    /***
     * Get the contents for the filter drop-down box on the burden test section of the gene info page
     * @return
     */
    def aboutTheDataAjax() {
        String metadataVersion = params.metadataVersion
        String technology = params.technology
        JSONObject jsonObject = restServerService.extractDataSetHierarchy(metadataVersion, technology)

        // send json response back
        render(status: 200, contentType: "application/json") { jsonObject }
    }

    def contact() {
        render(view: 'contact')
    }

    def hgat() {
        render(view: 'hgat')
    }

    def ashg() {
        forward(action: 'blog')
    }

    def ASHG() {
        forward(action: 'blog')
    }

    def forum() {
        render(view: "forum")
    }

    def blog() {
        render(view: "blog")
    }

    // the root page for policies.  This page recruits underlying pages via Ajax calls
    def policies() {
        String defaultDisplay = 'dataUse'
        render(view: 'policies', model: [specifics: defaultDisplay])
    }
    // subsidiary pages for  contact
    def policiessection() {
        render(template: "policies/${params.id}")
    }

}
