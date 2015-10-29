package org.broadinstitute.mpg

import dport.RestServerService
import grails.test.spock.IntegrationSpec
import org.broadinstitute.mpg.MetadataUtilityService
import org.broadinstitute.mpg.SearchBuilderService
import org.broadinstitute.mpg.SharedToolsService
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.junit.After
import org.junit.Before
import spock.lang.Unroll

/**
 * Created by balexand on 10/22/2015.
 */
@Unroll
class SearchBuilderServiceIntegrationSpec  extends IntegrationSpec  {

    RestServerService restServerService
    SharedToolsService sharedToolsService
    SearchBuilderService searchBuilderService
    MetaDataService metaDataService // Initialize metadata if necessary
    MetadataUtilityService metadataUtilityService

    @Before
    void setup() {
        metaDataService.getCommonPropertiesAsJson(false)
    }

    @After
    void tearDown() {

    }




    @Unroll("testing  pretty printing with #label")
    void "test pretty printing"() {

        setup:
        restServerService.searchBuilderService = searchBuilderService
        restServerService.metaDataService = metaDataService

        when:
        String result = searchBuilderService.prettyPrintPredictedEffect (PortalConstants.PROTEIN_PREDICTION_TYPE_PROTEINEFFECT, "${code}","|")

        then:
        result.contains(res)

        where:
        label                       | code              |   res
        "protein prediction ptv"    |   1               |   "protein-truncating"
        "protein pred missense"     |   2               |   "missense"
        "protein pred synonymous"   |   3               |   "synonymous coding"
        "protein pred non-coding"   |   4               |   "non-coding"
        "protein pred coding"       |   5               |   "coding variant"



    }



}
