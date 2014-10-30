package dport

import dport.SharedToolsService

class SectionSelectorTagLib {

    SharedToolsService sharedToolsService

    def renderSigmaSection = { attrs,body ->
        if (sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_sigma)){
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




}
