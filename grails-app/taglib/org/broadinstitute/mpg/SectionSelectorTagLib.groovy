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



    def renderIfWeHaveSampleDatathereValue = { attrs,body ->
        if (metaDataService.getDistributedKBFromSession ()!='EBI'){
            out << body()
        }

    }


    def renderNotIfWeHaveSampleDatathereValue = { attrs,body ->
        if (metaDataService.getDistributedKBFromSession ()=='EBI'){
            out << body()
        }

    }



    def renderIfWeHaveDynamicDataValue = { attrs,body ->
        if (metaDataService.getDistributedKBFromSession ()!='EBI'){
            out << body()
        }

    }


    def renderNotIfWeHaveDynamicDataValue = { attrs,body ->
        if (metaDataService.getDistributedKBFromSession ()=='EBI'){
            out << body()
        }

    }


    def renderExomeChipSection = { attrs,body ->
        if (sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exchp)){
            out << body()
        }

    }

    def renderExomeChipIndicator = { attrs,body ->
        out << sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exchp)
    }

    def renderExomeSequenceIndicator = { attrs,body ->
        out << sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exseq)
    }

    def renderGwasIndicator = { attrs,body ->
        out << sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_gwas)
    }



}
