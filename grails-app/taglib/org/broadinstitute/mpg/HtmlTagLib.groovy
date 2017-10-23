package org.broadinstitute.mpg

import org.apache.commons.lang.StringEscapeUtils
import org.broadinstitute.mpg.diabetes.MetaDataService;

class HtmlTagLib {
    MetaDataService metaDataService
//    static defaultEncodeAs = [taglib: 'html']

//    def renderHtml = {attrs ->
//
//        def filePath = attrs.file
//
//        if (!filePath) {
//            throwTagError("'file' attribute must be provided")
//        }
//        IOUtils.copy((String)request.servletContext.getResourceAsStream(filePath), out);
//    }

    /**
     * returns the metadata version to use for all metadata tree searches
     *
     */
    def metadataVersion = {attrs, body ->
        String metadataVersion = this.metaDataService?.getDataVersion();
        out << metadataVersion;
    }

    /**
     * returns the default phenotype to use
     *
     */
    def defaultPhenotype = {attrs, body ->
        String phenotype = this.metaDataService?.getDefaultPhenotype();
        out << phenotype;
    }

    /**
     * returns the portal type string from the user session
     *
     */
    def portalTypeString = {attrs, body ->
        String portalType = this.metaDataService?.getPortalTypeFromSession()
        out << portalType;
    }

    def portalVersionString = {attrs, body ->
        String portalType = this.metaDataService?.getPortalVersionFromSession()
        out << portalType;
    }

    def distributedKBString = {attrs, body ->
        String distributedKB = this.metaDataService?.getDistributedKBFromSession()
        out << distributedKB;
    }


    def renderGeneSummary = { attrs ->

        String geneName = attrs.geneFile
        String locale = attrs.locale

        if (!geneName) {
            return;  // better to fail silently
            //throwTagError("'file' attribute must be provided")
        }

        String fileName = "/WEB-INF/resources/geneSummaries/${geneName}.html" // default value
        if (locale) {
            if (locale.startsWith("en")) {
                fileName = "/WEB-INF/resources/geneSummaries/${geneName}.html"
            } else if (locale.startsWith("es")) {
                fileName = "/WEB-INF/resources/geneSummaries/spanish/${geneName}.html"
            }
        }

        String fileDesignationOnDisk = grailsApplication.mainContext.getResource(fileName)?.file?.toString()


        if (!fileDesignationOnDisk) {
            return;  // better to fail silently
        }
        File file = new File(fileDesignationOnDisk)
        String fileContents = ""

        if (file.exists()){
            file?.eachLine {
                String rawCharacters = it
                fileContents += StringEscapeUtils.escapeJavaScript(rawCharacters)
            }
        }
        out << fileContents
    }
}





