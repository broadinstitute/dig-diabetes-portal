/**
 * Created by ben on 8/16/2014.
 */
package org.broadinstitute.mpg

import grails.test.spock.IntegrationSpec
import org.broadinstitute.mpg.RegionController
import org.broadinstitute.mpg.diabetes.MetaDataService

/**
 *
 */
class RegionControllerIntegrationSpec extends IntegrationSpec {

    RegionController controller
    MetaDataService metaDataService = new MetaDataService()


    def setup() {
        controller = new  RegionController()
        metaDataService.getCommonPropertiesAsJson(false)
    }

    def cleanup() {
    }



    void "test the search a region by ajax page"() {
        when:
        controller.params.id="chr9:21,940,000-22,190,000"
        controller.regionInfo()
        then: 'verify that we get valid responses back'
        controller.response.status==302
        controller.response.redirectedUrl.contains("launchAVariantSearch")

    }



}

