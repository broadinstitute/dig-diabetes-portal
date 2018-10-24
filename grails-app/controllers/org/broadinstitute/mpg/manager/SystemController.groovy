package org.broadinstitute.mpg.manager

import groovy.json.JsonBuilder
import groovy.json.JsonSlurper
import org.broadinstitute.mpg.RestServerService
import org.broadinstitute.mpg.SharedToolsService
import org.broadinstitute.mpg.WidgetService
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.bean.PortalVersionBean
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject
import temporary.BuildInfo

class SystemController {

    GrailsApplication grailsApplication
    SharedToolsService sharedToolsService
    RestServerService restServerService
    MetaDataService metaDataService
    WidgetService widgetService

    def index = {
        render "<h1>hi</h1>"
    }

    def systemManager = {

        String test = this.widgetService.getLocusZoomEndpointSelection()
        log.info("LZ endpoint is: " + test)
        log.info("LZ map is: " + this.widgetService?.getLocusZoomEndpointList())
        render(view: 'systemMgr', model: [warningText:sharedToolsService.getWarningText(),
                                          currentRestServer:restServerService?.getCurrentRestServer(),
                                          burdenCurrentRestServer: restServerService?.getCurrentBurdenServer(),
                                          restServerList: grailsApplication.config.getRestServerList,
        currentApplicationIsSigma:sharedToolsService.applicationName(),
        helpTextLevel:sharedToolsService.getHelpTextSetting(),
        forceMetadataCacheOverride: this.metaDataService?.getMetadataOverrideStatus(),
        dataVersion:sharedToolsService.getDataVersion (),
        currentGeneChromosome:sharedToolsService.retrieveCurrentGeneChromosome(),
        currentVariantChromosome:sharedToolsService.retrieveCurrentVariantChromosome(),
        totalNumberOfGenes: sharedToolsService.getCachedGeneNumber(false),
        totalNumberOfVariants: sharedToolsService.getCachedVariantNumber(false),
        locusZoomEndpointSelectionList: this.widgetService?.getLocusZoomEndpointList(),
        currentLocusZoomEndpoint: this.widgetService.getLocusZoomEndpointSelection(),
        recognizedStringsOnly:sharedToolsService.getRecognizedStringsOnly(),
        betaFeaturesDisplayed:sharedToolsService.getBetaFeaturesDisplayed()])
    }


    def retrievePortalVersionBean = {

    }


    def getPortalVersionList = {
        JsonSlurper slurper = new JsonSlurper()
        JSONArray portalVersionListJsonArray = slurper.parseText(restServerService?.getPortalVersionBeanListAsJson())
        render(status:200, contentType:"application/json") {
            [portalVersionList:portalVersionListJsonArray]
        }
    }



    def getPortalVersionBeanDetails = {
        def slurper = new JsonSlurper()
//
//        PortalVersionBean portalVersionBean = restServerService.retrieveBeanForCurrentPortal()
//        List<String> dataAccessorsForPortalVersionBean = findDataAccessorsForPortalVersionBean("get",portalVersionBean)
//        LinkedHashMap objectWeAreBuilding = [:]
//        for (String fieldName in dataAccessorsForPortalVersionBean ){
//            String portalBeanMethodName = "get${fieldName}"
//            try{
//                Object methodReturnValue =  portalVersionBean.invokeMethod(portalBeanMethodName,null as Object)
//                if (methodReturnValue instanceof ArrayList){
//                    List listHolder = []
//                    for (String str in (methodReturnValue as ArrayList)){
//                        listHolder << str
//                    }
//                    objectWeAreBuilding[fieldName] = listHolder
//                } else {
//                    objectWeAreBuilding[fieldName] = methodReturnValue
//                }
//            } catch(Exception e){
//                print ("prob with ${fieldName}, ${e.toString()}.")
//            }
//        }
        String proposedJsonString = restServerService.retrieveBeanForCurrentPortal().toJsonString()
        JSONObject jsonReturn =  slurper.parseText(proposedJsonString);

        render(status: 200, contentType: "application/json") {["jsonObject":jsonReturn,"jsonString":proposedJsonString]}
        return

    }



//
//    List<String> findDataAccessorsForPortalVersionBean(String getOrSet, PortalVersionBean portalVersionBean){
//        List<String> returnValue = []
//        for (String portalBeanMethodName in portalVersionBean.metaClass.methods*.name.sort().unique() ){
//            if (portalBeanMethodName.startsWith(getOrSet)){
//                String fieldName = portalBeanMethodName.substring(3)
//                if ((fieldName!="MetaClass")&&
//                        (fieldName!="Class")&&
//                        (fieldName!="Property")){
//                    returnValue << fieldName
//                }
//            }
//        }
//        return returnValue
//    }


    String firstCharToLowerCase(String str) {

        if(str == null || str.length() == 0)
            return "";

        if(str.length() == 1)
            return str.toLowerCase();

        char[] chArr = str.toCharArray();
        chArr[0] = Character.toLowerCase(chArr[0]);

        return new String(chArr);
    }


    def setPortalVersionBeanDetails = {
        String portaVersionFieldsDef = params.portalBeanInformation
        def slurper = new JsonSlurper()
        JSONObject jsonObject =  slurper.parseText(portaVersionFieldsDef);
        PortalVersionBean portalVersionBean = restServerService.retrieveBeanForCurrentPortal()
        LinkedHashMap propertiesForPortalVersionBean = portalVersionBean.getProperties()
        Iterator<String> keys = jsonObject.keys()
        while(keys.hasNext()){
            String key = keys.next()
            Object value = jsonObject[key]
            String property = firstCharToLowerCase(key)
            if (propertiesForPortalVersionBean.containsKey(property)){
                if (value instanceof ArrayList){
                    List<String> listOfElements = []
                    for (String element in (value as ArrayList)){
                        listOfElements << element
                    }
                    portalVersionBean.@"$property" = listOfElements
                } else if (value instanceof String){
                    portalVersionBean.@"$property" = value as String
                } else if (value instanceof Integer){
                    portalVersionBean.@"$property" = value as Integer
                }
            }
         }




        render(status: 200, contentType: "application/json") {["jsonObject":jsonObject]}
        return
    }







    def determineVersion = {
        JSONObject jsonVersion = [
            buildHost: "${BuildInfo?.buildHost}",
            buildTime:"${BuildInfo?.buildTime}",
            appVersion:"${BuildInfo?.appVersion}",
            buildNumber:"${BuildInfo?.buildNumber}"
        ]

        render(status:200, contentType:"application/json") {
            [info:jsonVersion]
        }
      }

    /**
     * updates the warning text of the application; text display in running banner ont he home page
     *
     * @return
     */
    def updateWarningText() {
        String warningText = params.warningText
        sharedToolsService.setWarningText(warningText)
        forward(action: "systemManager")
    }




    def updateHelpTextLevel() {
        String helpTextSetting = params.datatype
        int currentHelpTextSetting = sharedToolsService.getHelpTextSetting ()
        if (helpTextSetting == 'none') {
            if (!(currentHelpTextSetting == 0)) {
                sharedToolsService.setHelpTextSetting(0)
                flash.message = "You have now turned off all help text"
            } else {
                flash.message = "But you had already turned off all help text!"
            }
        } else if (helpTextSetting == 'conditional') {
            if (!(currentHelpTextSetting == 1)) {
                sharedToolsService.setHelpTextSetting(1)
                flash.message = "Help text will now appear only if messages exist to be displayed"
            } else {
                flash.message = "But you had already set the help text to conditional display!"
            }
        } else if (helpTextSetting == 'always') {
            if (!(currentHelpTextSetting == 2)) {
                sharedToolsService.setHelpTextSetting(2)
                flash.message = "Help text question marks will now always appear, even if we don't have text to back them up"
            } else {
                flash.message = "But you had already set the help text to always display!"
            }
        }
        forward(action: "systemManager")
    }

    def refreshGeneCache()  {
        redirect(controller:'system',action:'refreshGenesForChromosome', params: [chromosome: "1"])
    }
    def refreshVariantCache()  {
        redirect(controller:'system',action:'refreshVariantsForChromosome', params: [chromosome: "1"])
    }
    def refreshGenesForChromosome()  {
        String chromosomeName = params.chromosome
        String endChromosomeName = params.endChromosome
        if ((!chromosomeName)||(chromosomeName?.length()==0)) {
            render(status:200)
        } else {
            Boolean allDone=false
            String  nextChromosomeToProcess   =   chromosomeName
            while (!allDone) {
                restServerService.refreshGenesForChromosome(nextChromosomeToProcess)
                sharedToolsService.incrementCurrentGeneChromosome()
                nextChromosomeToProcess = sharedToolsService.retrieveCurrentGeneChromosome()
                if ((nextChromosomeToProcess?.length() == 0)  ||
                     (endChromosomeName == nextChromosomeToProcess)){
                    allDone = true
                    render(status: 200)
                }
            }
         }
        // refresh gene cache number
        sharedToolsService.getCachedGeneNumber(true);

        render(status: 200)

    }

    /**
     * refresh the variant count number that is displayed on the systems web page
     *
     * @return
     */
    def refreshVariantsForChromosome()  {
        int variantCount = 0
        int variantForChromosomeCount = 0

        String chromosomeName = params.chromosome
        String endChromosomeName = params.endChromosome
        if ((!chromosomeName)||(chromosomeName?.length()==0)) {
            render(status:200)
        } else {
            Boolean allDone=false
            String  nextChromosomeToProcess   =   chromosomeName
            while (!allDone) {
                Boolean chromosomeFinished=false
                int nextPosition = 0
                int chunkSize = 1000
                while (!chromosomeFinished)  {
                    LinkedHashMap variantsRetrieved = restServerService.refreshVariantsForChromosomeByChunkNew( nextChromosomeToProcess, chunkSize, nextPosition)
                    variantForChromosomeCount = variantForChromosomeCount + variantsRetrieved.numberOfVariants;

                    if (variantsRetrieved.numberOfVariants<1)  {
                        chromosomeFinished = true
                    }  else {
                        nextPosition =  variantsRetrieved.lastPosition + 1
                    }
                }
                log.info("got: " + variantForChromosomeCount + " variant count for chromosome: " + nextChromosomeToProcess)
                variantCount = variantCount + variantForChromosomeCount
                log.info("got: " + variantCount + " total variants so far")

                sharedToolsService.incrementCurrentVariantChromosome()
                nextChromosomeToProcess = sharedToolsService.retrieveCurrentVariantChromosome()
                if ((nextChromosomeToProcess?.length() == 0)  ||
                        (endChromosomeName == nextChromosomeToProcess)){
                    allDone = true
                    render(status: 200)
                }
            }
        }

        // force reload of the cached variant number
        sharedToolsService.getCachedVariantNumber(true);

        render(status: 200)
    }

    /**
     * forces a getMetadata() call to the API and caches the results; metadata will be refreshed next time home page is hit(?)
     *
     * @return
     */
    def forceMetadataCacheUpdate ()  {
        String metadataOverrideStatus = params.datatype

        // DIGP_170: commenting out for final push to move to new metadata data structure (10/18/2015)
        Boolean metadataOverrideHasBeenRequested = this.metaDataService?.getMetadataOverrideStatus ()

        if (metadataOverrideStatus == "forceIt") {
            if (metadataOverrideHasBeenRequested == false) {
                // DIGP_47: adding in new medatata data structure service
                this.metaDataService.setForceProcessedMetadataOverride(1)
                flash.message = "You have scheduled an override to the metadata cache. The next time the metadata is requested the cache will be reloaded"
            } else {
                flash.message = "But the metadata cache was already scheduled!"
            }
        } else {
            // DIGP-170: switching test below to (metadataOverrideHasBeenRequested == true)
            if (metadataOverrideHasBeenRequested == true) {
                // DIGP_47: adding in new medatata data structure service
                this.metaDataService.setForceProcessedMetadataOverride(0)
                flash.message = "you have rejected the request to update the metadata. "
            } else {
                flash.message = "But there was no override in place to cancel!"
            }
        }

        forward(action: "systemManager")
    }


    def changeDataVersion()  {
        List<String> allDataTypes = params.dataType as List
        LinkedHashMap<String,String> typeToVersionMap = [:]
        for (String dataType in allDataTypes){
            String mdvParm="mdvName_${dataType}"
            restServerService.modifyPortalVersion(dataType, params[mdvParm])
        }
        forward(action: "systemManager")

    }


    def updateBackEndRestServer() {
        String restServer = params.datatype
        String currentServer =  restServerService.getCurrentRestServer()?.getName()

        if  (!(restServer == currentServer)) {
            restServerService.changeRestServer(restServer)
            flash.message = "You are now using the ${restServer} server!"
        } else {
            flash.message = "But you were already using the ${currentServer} server!"
        }
        params.datatype = "forceIt"
        forward(action: "forceMetadataCacheUpdate")
    }

    /**
     * method to update the LocusZoom rest server
     *
     * @return
     */

    def updateLocusZoomRestServer() {
        String restServer = params.locusZoomRestServer
        String currentServer =  this.widgetService?.getLocusZoomEndpointSelection()

        if  (!(restServer == currentServer)) {
            this.widgetService?.setLocusZoomEndpointSelection(restServer)
            flash.message = "You are now using the ${restServer} LocusZoom server!"
        } else {
            flash.message = "But you were already using the ${currentServer} LocusZoom server!"
        }

        forward(action: "systemManager")
    }

    /**
     * update whether beta features are displayed
     *
     * @return
     */
    def updateBetaFeaturesDisplayed() {
        Integer requestedBetaFeaturesDisplayed = 0
        try {
            requestedBetaFeaturesDisplayed = Integer.parseInt(params.betaFeaturesDisplayed)
        } catch (e){
            e.printStackTrace()
        }
        int  currentBetaFeaturesDisplayed =  sharedToolsService?.getBetaFeaturesDisplayed()


        String areWeDisplaying = " not "
        if  (!(requestedBetaFeaturesDisplayed == currentBetaFeaturesDisplayed)) {
            sharedToolsService?.setBetaFeaturesDisplayed(requestedBetaFeaturesDisplayed)
            if (sharedToolsService?.getBetaFeaturesDisplayed()){
                areWeDisplaying = " "
            }
            flash.message = "The portal is now${areWeDisplaying}displaying beta features!"
        } else {
            flash.message = "But you were already${areWeDisplaying}displaying beta features!"
        }

        forward(action: "systemManager")
    }



    def switchSigmaT2d(){
       // String restServer = params
        String requestedApplication = params.datatype
        if  ( requestedApplication == 't2dgenes')  {
            sharedToolsService.setApplicationToT2dgenes  ()
            redirect(controller:'home', action:'index')
            return
        }  else if  ( requestedApplication == 'beacon')  {
            sharedToolsService.setApplicationToBeacon  ()
            redirect(controller:'beacon', action:'beaconDisplay')
            return
        }   else {
            flash.message = "Internal error: you requested server = ${requestedApplication} which I do not recognize!"
        }

        forward(action: "systemManager")
    }


    def switchApplicationToT2dgenes(){
        sharedToolsService.setApplicationToT2dgenes()
        forward(action: "systemManager")
    }



    def changeRecognizedStringsOnly()  {
        String recognizeStringsOnly = params.datatype
        int currentRecognizedStringsOnly = sharedToolsService.getRecognizedStringsOnly ()
        if (recognizeStringsOnly!=null) {
            int  recognizeStringsOnlyInteger = recognizeStringsOnly as Integer
            if (recognizeStringsOnlyInteger != currentRecognizedStringsOnly) {
                sharedToolsService.setRecognizedStringsOnly(recognizeStringsOnlyInteger)
                flash.message = "You have changed the recognizeStringsOnly to ${sharedToolsService.getRecognizedStringsOnly ()}"
            } else {
                flash.message = "But recognizeStringsOnly was already ${currentRecognizedStringsOnly}"
            }
        }
        forward(action: "systemManager")
    }


}
