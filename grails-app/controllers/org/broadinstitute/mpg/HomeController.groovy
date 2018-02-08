package org.broadinstitute.mpg

import dig.diabetes.portal.NewsFeedService
import groovy.json.JsonSlurper
import org.apache.juli.logging.LogFactory
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.bean.PortalVersionBean
import org.broadinstitute.mpg.diabetes.metadata.Experiment
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.core.io.ResourceLocator
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject
import org.springframework.web.servlet.support.RequestContextUtils
import grails.converters.JSON

class HomeController {
    private static final log = LogFactory.getLog(this)
    GrailsApplication grailsApplication
    SharedToolsService sharedToolsService
    ResourceLocator grailsResourceLocator
    RestServerService restServerService
    NewsFeedService newsFeedService
    MetaDataService metaDataService
    def mailService

    /***
     * top-level index routine. This is where we go if somebody types in type2diabetesgenetics.org and nothing else
     */
    def index = {
        if  ((sharedToolsService.getApplicationIsT2dgenes())) {
            render(view:'portalHome', model: [newsItems: (newsFeedService.getCurrentPosts(g.portalTypeString() as String) as JSON),
                                              show_gwas:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_gwas),
                                              show_exchp:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exchp),
                                              show_exseq:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exseq),
                                              listPortalVersionBean: restServerService.retrieveBeanForAllPortals(),
                                              portalVersionBean: restServerService.retrieveBeanForCurrentPortal()])
        }  else if (sharedToolsService.getApplicationIsBeacon()) {
            redirect(controller:'beacon', action:'beaconDisplay')
        } else {
            log.error ">>>>> Critical internal error!  The application was set to something other than T2dgenes, Sigma, or Beacon.  No home page possible.  <<<<<"
        }

    }

    /**
     * action to pick portal type
     *
     */
    def pickPortal = {
        String portalType = params.portal

        // log
        log.info("setting portal type: " + portalType + " for session: " + request.getSession());

        if (portalType != null) {
            request?.getSession()?.setAttribute("portalType", portalType)
            request?.getSession()?.setAttribute("portalVersion", portalType)
        }

        // forward to index page
        redirect(action: 'index')

     }





    /***
     * This is our standard home page. We get directed here from a few places in the portal
     */
    def portalHome = {
        render(controller: 'home', view: 'portalHome', model: [newsItems: (newsFeedService.getCurrentPosts(g.portalTypeString() as String) as JSON),
                                                               show_gwas:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_gwas),
                                                               show_exchp:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exchp),
                                                               show_exseq:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exseq),
                                                               warningText:sharedToolsService.getWarningText(),
                                                               listPortalVersionBean: restServerService.retrieveBeanForAllPortals(),
                                                               portalVersionBean: restServerService.retrieveBeanForCurrentPortal()])
    }



    def getGeneLevelResults() {
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
        JSONObject returnResult = new JSONObject()
        returnResult["is_error"] = false;
        List<Phenotype> phenotypeList = metaDataService.getPhenotypeListByTechnologyAndVersion("", metaDataService.getDataVersion(),metaDataService.METADATA_GENE)
        PortalVersionBean portalVersionBean = restServerService.retrieveBeanForPortalType(metaDataService.portalTypeFromSession)
        returnResult["preferredGroups"] = portalVersionBean.getOrderedPhenotypeGroupNames() as JSONArray
        JSONArray phenotypeArray = new JSONArray()
        for (org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean phenotype in phenotypeList.sort{it.sortOrder}) {
            JSONObject phenoRecord = new JSONObject()
            phenoRecord['systemId'] = phenotype.parent.systemId
            phenoRecord['translatedSystemId'] = g.message(code: "metadata." + phenotype.parent.systemId, default: phenotype.parent.systemId)
            phenoRecord['name'] = phenotype.name
            phenoRecord['translatedPhenotype'] = g.message(code: "metadata." + phenotype.name, default: phenotype.name)
            phenoRecord['group'] = phenotype.group
            JSONArray propertyArray = new JSONArray()
            for (org.broadinstitute.mpg.diabetes.metadata.PropertyBean property in phenotype.propertyList) {
                if ( property.hasMeaning("P_VALUE") ){
                    JSONObject propertyRecord = new JSONObject()
                    propertyRecord['name'] = property.name
                    propertyRecord['translatedProperty'] = g.message(code: "metadata." + property.name, default: property.name)
                    propertyRecord['meaning'] = "P_VALUE"
                    propertyArray.add(propertyRecord)
                }
//                if ( property.hasMeaning("ODDS_RATIO") ){
//                    JSONObject propertyRecord = new JSONObject()
//                    propertyRecord["name"] = property.name
//                    propertyRecord["meaning"] = "ODDS_RATIO"
//                    propertyArray.add(propertyRecord)}
            }
            phenoRecord['properties'] = propertyArray
            phenotypeArray.add(phenoRecord)
        }
        returnResult["pheotypeRecords"] = phenotypeArray
        render(status: 200, contentType: "application/json") {returnResult}
    }


    /***
     * The very first time you use the portal you have to sign something.  This should happen to everyone EXCEPT those
     * with built-in login accounts (i.e. system users) who will never see this message.
     */
    def signAContract = {
        render(controller: 'home', view: 'signAContract')
    }


    def retrieveOnePortalAjax = {
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
        String portalJsonDescr = restServerService.retrieveBeanForCurrentPortal().toJsonString()
        JsonSlurper slurper = new JsonSlurper()
        JSONObject jsonObject= slurper.parseText(portalJsonDescr)
//
//            jsonObject["menuHeader"] = grailsApplication.getMainContext().getResource(jsonObject["menuHeader"]).servletContext.context.context.path+
//                    grailsApplication.getMainContext().getResource(jsonObject["menuHeader"]).getPath()
////            String logoCode = grailsApplication.getMainContext().getResource(g.message(code:jsonObject["logoCode"]))
////            jsonObject.remove("logoCode")
//            jsonObject["logoCode"] = grailsApplication.getMainContext().getResource(jsonObject["menuHeader"]).servletContext.context.context.path+
//                    grailsApplication.getMainContext().getResource(jsonObject["logoCode"]).getPath()
        render(status:200, contentType:"application/json") {
            jsonObject
        }
    }


    def retrieveAllPortalsAjax = {
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
        String portalJsonDescr = restServerService.getPortalVersionBeanListAsJson()
        JsonSlurper slurper = new JsonSlurper()
        JSONArray jsonArray = slurper.parseText(portalJsonDescr)
        JSONArray modifiedJsonArray = new JSONArray()
        for(JSONObject jsonObject in jsonArray){
//            String menuHeader = grailsApplication.getMainContext().getResource(jsonObject["menuHeader"]).servletContext.context.context.path+
//                    grailsApplication.getMainContext().getResource(jsonObject["menuHeader"]).getPath()
//            jsonObject.remove("menuHeader")
//            jsonObject["menuHeader"] = menuHeader
//            String logoCode = grailsApplication.getMainContext().getResource(jsonObject["menuHeader"]).servletContext.context.context.path+
//                    grailsApplication.getMainContext().getResource(jsonObject["logoCode"]).getPath()
//            jsonObject.remove("logoCode")
//            jsonObject["logoCode"] = logoCode
            modifiedJsonArray.add(jsonObject)
        }
        render(status:200, contentType:"application/json") {
            modifiedJsonArray
        }
    }

    /***
     * Show tutorial documents. Some tutorials have Spanish versions, so generate links appropriately
     */
    def tutorials = {
        String locale = RequestContextUtils.getLocale(request)
        JSONObject links = [
            introTutorial: locale.startsWith('es') ? "https://s3.amazonaws.com/broad-portal-resources/tutorials/tutorial_ES.pdf" : "https://s3.amazonaws.com/broad-portal-resources/tutorials/tutorial_EN.pdf",
            variantFinderTutorial: "https://s3.amazonaws.com/broad-portal-resources/tutorials/VariantFinderTutorial.pdf",
            strokeIntroTutorial: "https://s3.amazonaws.com/broad-portal-resources/stroke/tutorials/Cerebrovascular_disease_KP_tutorial.pdf",
            strokeVariantFinderTutorial: "https://s3.amazonaws.com/broad-portal-resources/stroke/tutorials/Cerebrovascular_VF_Tutorial.pdf",
            miIntroTutorial: "https://s3.amazonaws.com/broad-portal-resources/tutorials/CVDKP_tutorial.pdf",
            miVariantFinderTutorial: "https://s3.amazonaws.com/broad-portal-resources/stroke/tutorials/Cerebrovascular_VF_Tutorial.pdf",
                GAITguide: "https://s3.amazonaws.com/broad-portal-resources/tutorials/KP_GAIT_guide.pdf",
                VariantResultsTableGuide: "https://s3.amazonaws.com/broad-portal-resources/tutorials/KP_variant_results_guide.pdf",
                GeneticsGuide: "https://s3.amazonaws.com/broad-portal-resources/tutorials/Genetic_association_primer.pdf",
                PhenotypeGuide: "https://s3.amazonaws.com/broad-portal-resources/tutorials/Phenotype_reference_guide.pdf",
                GenePageGuide: "https://s3.amazonaws.com/broad-portal-resources/tutorials/gene_page_guide.pdf",
                StrokePhenotypeGuide: "https://s3.amazonaws.com/broad-portal-resources/stroke/CDKP_phenotype_reference_guide.pdf",
            test: "https://s3.amazonaws.com/broad-portal-resources/tutorials/CVDKP_gene_page_guide.pdf",
            CDKPGenePageGuide: "https://s3.amazonaws.com/broad-portal-resources/stroke/tutorials/CDKP_gene_page_guide.pdf",




        ]
        render(controller: 'home', view: 'tutorials', model: [links: links])
    }

    /***
     * I think we still support the Beacon application.  Someone should really split this out into its own app.
     */
    def beaconHome = {
        render(view: 'beaconDisplay')
    }

    /***
     * If something has gone on the browser, then the browser calls this action in order to make sure
     * that the failure gets around.  Unfortunately these are not necessarily real errors -- if for example
     * you are waiting for an Ajax response and you get impatient and leave the page then you're going to
     * generate this error response.  I don't know a good way to differentiate between real and non-real errors
     * on the browser yet.
     */
    def errorReporter = {
        String errorText = params['errorText']
        log.error "*** Received error from client reporter. text=${errorText}"
        if ((errorText !=  null ) &&
            (errorText != "null")) {  // There is no point in sending a completely empty message.
                                      // Note that the 'null' message will go into the logs, so it isn't
                                      // completely lost, however, even if it doesn't fill up my email box
            mailService.sendMail {
                from "t2dPortal@gmail.com"
                to "${grailsApplication.config.site.operator}"
                subject "Error report"
                body "${errorText}"
            }
        }
        render(status: 200)
    }

}
