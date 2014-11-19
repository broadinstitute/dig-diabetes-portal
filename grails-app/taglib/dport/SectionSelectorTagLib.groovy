package dport

import dport.SharedToolsService

class SectionSelectorTagLib {

    SharedToolsService sharedToolsService

    def renderSigmaSection = { attrs,body ->
        if (sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_sigma)){
            out << body()
        }

    }
    def renderNotSigmaSection = { attrs,body ->
        if (!sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_sigma)){
            out << body()
        }

    }



    def rendersSigmaMessage = { attrs,body ->
        if (sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_sigma)){
            String messageText = ""
            if (attrs.messageSpec){
                messageText = g.message(code:attrs.messageSpec)
                out << messageText
            }
        }
    }


    def rendersNotSigmaMessage = { attrs,body ->
        if (!sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_sigma)){
            String messageText = ""
            if (attrs.messageSpec){
                messageText = g.message(code:attrs.messageSpec)
                out << messageText
            }
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

    def renderSigmaIndicator = { attrs,body ->
        out << sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_sigma)
    }

    def renderGwasIndicator = { attrs,body ->
        out << sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_gwas)
    }



}
