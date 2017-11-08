package org.broadinstitute.mpg

import org.broadinstitute.mpg.diabetes.MetaDataService

class SectionSelectorTagLib {

    SharedToolsService sharedToolsService
    MetaDataService metaDataService

    def renderSigmaSection = { attrs,body ->

    }

    def renderT2dGenesSection = { attrs,body ->
        if (sharedToolsService.getApplicationIsT2dgenes()){
            out << body()
        }

    }

    def renderBeaconSection = { attrs,body ->
        if (sharedToolsService.getApplicationIsBeacon()){
            out << body()
        }

    }


    def renderExomeSequenceSection = { attrs,body ->
        if (sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exseq)){
            out << body()
        }

    }

    def renderBetaFeaturesDisplayedValue = { attrs,body ->
        if (sharedToolsService.getBetaFeaturesDisplayedValue ()){
            out << body()
        }

    }


    def renderNotBetaFeaturesDisplayedValue = { attrs,body ->
        if (!sharedToolsService.getBetaFeaturesDisplayedValue ()){
            out << body()
        }

    }



}
