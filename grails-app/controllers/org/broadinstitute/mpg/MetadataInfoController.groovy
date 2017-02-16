package org.broadinstitute.mpg

import org.broadinstitute.mpg.diabetes.MetaDataService
import org.codehaus.groovy.grails.commons.GrailsApplication

class MetadataInfoController {
    RestServerService restServerService
    GrailsApplication grailsApplication
    MetaDataService metaDataService
    SharedToolsService sharedToolsService

    def index() {}

    // iterates over the input array to build the HTML that gets displayed
    private String buildDisplay(String[] names) {
        StringBuilder sb = new StringBuilder()
        names.each { name ->
            sb.append(getMetadataLine(name))
            sb.append("<br>")
        }

        return sb.toString()
    }

    // makes the g.message call
    private String getMetadataLine(String key) {
        return "metadata.${key}=${g.message(code: "metadata." + key, default: "<b>No translation for</b> " + key)}"
    }


}
