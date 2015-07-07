package dport

import dport.SharedToolsService

class SectionSelectorTagLib {

    SharedToolsService sharedToolsService

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
