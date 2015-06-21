package dport.mgr

import dport.RestServerService
import  dport.SharedToolsService
import dport.people.User;
import temporary.BuildInfo;
import org.codehaus.groovy.grails.commons.GrailsApplication

class SystemController {

    GrailsApplication grailsApplication
    SharedToolsService sharedToolsService
    RestServerService restServerService


    def index = {
        render "<h1>hi</h1>"
    }

    def systemManager = {
        render(view: 'systemMgr', model: [warningText:sharedToolsService.getWarningText(),
                                          currentRestServer:restServerService.currentRestServer(),
        currentApplicationIsSigma:sharedToolsService.applicationName(),
        helpTextLevel:sharedToolsService.getHelpTextSetting(),
        newApi:sharedToolsService.getNewApi(),
        forceMetadataCacheOverride:sharedToolsService.getMetadataOverrideStatus(),
        dataVersion:sharedToolsService.getDataVersion (),
        currentGeneChromosome:sharedToolsService.retrieveCurrentGeneChromosome(),
        currentVariantChromosome:sharedToolsService.retrieveCurrentVariantChromosome()])
    }

    def determineVersion = {
        String jsonVersion  =  """
{"buildHost": "${BuildInfo?.buildHost}",
"buildTime":"${BuildInfo?.buildTime}",
"appVersion":"${BuildInfo?.appVersion}",
"buildNumber":"${BuildInfo?.buildNumber}"
}""".toString()
        render(status:200, contentType:"application/json") {
            [info:jsonVersion]
        }
      }




    def updateWarningText() {
        String warningText = params.warningText
        sharedToolsService.setWarningText(warningText)
        render(view: 'systemMgr', model: [warningText:sharedToolsService.getWarningText(),
                currentRestServer:restServerService.currentRestServer(),
                                          currentApplicationIsSigma:sharedToolsService.applicationName(),
                                          helpTextLevel:sharedToolsService.getHelpTextSetting(),
                                          newApi:sharedToolsService.getNewApi(),
                                          forceMetadataCacheOverride:sharedToolsService.getMetadataOverrideStatus(),
                                          dataVersion:sharedToolsService.getDataVersion (),
                                          currentGeneChromosome:sharedToolsService.retrieveCurrentGeneChromosome(),
                                          currentVariantChromosome:sharedToolsService.retrieveCurrentVariantChromosome()])

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
        render(view: 'systemMgr', model: [warningText:sharedToolsService.getWarningText(),
                                          currentRestServer:restServerService.currentRestServer(),
                                          currentApplicationIsSigma:sharedToolsService.applicationName(),
                                          helpTextLevel:sharedToolsService.getHelpTextSetting(),
                                          newApi:sharedToolsService.getNewApi(),
                                          forceMetadataCacheOverride:sharedToolsService.getMetadataOverrideStatus(),
                                          dataVersion:sharedToolsService.getDataVersion (),
                                          currentGeneChromosome:sharedToolsService.retrieveCurrentGeneChromosome(),
                                          currentVariantChromosome:sharedToolsService.retrieveCurrentVariantChromosome()])
    }



    def updateApiLevel() {
        String apiSetting = params.datatype
        Boolean currentApiSetting = sharedToolsService.getNewApi ()
        if (apiSetting == 'newApi') {
            if (!(currentApiSetting == 0)) {
                sharedToolsService.setNewApi(1)
                flash.message = "You have turned on the new API"
            } else {
                flash.message = "But the new API was already turned on!"
            }
        } else if (apiSetting == 'oldApi') {
            if (!(currentApiSetting == 1)) {
                sharedToolsService.setNewApi(0)
                flash.message = "you have turned to the old API"
            } else {
                flash.message = "But you were already using the old API!"
            }
        }
        render(view: 'systemMgr', model: [warningText:sharedToolsService.getWarningText(),
                                          currentRestServer:restServerService.currentRestServer(),
                                          currentApplicationIsSigma:sharedToolsService.applicationName(),
                                          helpTextLevel:sharedToolsService.getHelpTextSetting(),
                                          newApi:sharedToolsService.getNewApi(),
                                          forceMetadataCacheOverride:sharedToolsService.getMetadataOverrideStatus(),
                                          dataVersion:sharedToolsService.getDataVersion (),
                                          currentGeneChromosome:sharedToolsService.retrieveCurrentGeneChromosome(),
                                          currentVariantChromosome:sharedToolsService.retrieveCurrentVariantChromosome()])
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
        render(status: 200)

    }
    def refreshVariantsForChromosome()  {
        String chromosomeName = params.chromosome
        String endChromosomeName = params.endChromosome
        if ((!chromosomeName)||(chromosomeName?.length()==0)) {
            render(status:200)
        } else {
            Boolean allDone=false
            String  nextChromosomeToProcess   =   chromosomeName
            while (!allDone) {
                restServerService.refreshVariantsForChromosome(nextChromosomeToProcess)
                sharedToolsService.incrementCurrentVariantChromosome()
                nextChromosomeToProcess = sharedToolsService.retrieveCurrentVariantChromosome()
                if ((nextChromosomeToProcess?.length() == 0)  ||
                        (endChromosomeName == nextChromosomeToProcess)){
                    allDone = true
                    render(status: 200)
                }
            }
        }
        render(status: 200)
    }



    def forceMetadataCacheUpdate ()  {
        String metadataOverrideStatus = params.datatype
        Boolean metadataOverrideHasBeenRequested = sharedToolsService.getMetadataOverrideStatus ()
        if (metadataOverrideStatus == "forceIt") {
            if (metadataOverrideHasBeenRequested == false) {
                sharedToolsService.setMetadataOverrideStatus(1)
                flash.message = "You have scheduled an override to the metadata cache. The next time the metadata is requested the cache will be reloaded"
            } else {
                flash.message = "But the metadata cache was already scheduled!"
            }
        } else {
            if (!(metadataOverrideHasBeenRequested == true)) {
                sharedToolsService.setForceMetadataOverride(0)
                flash.message = "you have rejected the request to update the metadata. "
            } else {
                flash.message = "But there was no override in place to cancel!"
            }
        }
        render(view: 'systemMgr', model: [warningText:sharedToolsService.getWarningText(),
                                          currentRestServer:restServerService.currentRestServer(),
                                          currentApplicationIsSigma:sharedToolsService.applicationName(),
                                          helpTextLevel:sharedToolsService.getHelpTextSetting(),
                                          newApi:sharedToolsService.getNewApi(),
                                          forceMetadataCacheOverride:sharedToolsService.getMetadataOverrideStatus(),
                                          dataVersion:sharedToolsService.getDataVersion (),
                                          currentGeneChromosome:sharedToolsService.retrieveCurrentGeneChromosome(),
                                          currentVariantChromosome:sharedToolsService.retrieveCurrentVariantChromosome()])

    }


    def changeDataVersion()  {
        String requestedDataVersion = params.datatype
        int currentDataVersion = sharedToolsService.getDataVersion ()
        if (requestedDataVersion!=null) {
            if (requestedDataVersion != currentDataVersion) {
                sharedToolsService.setDataVersion(requestedDataVersion)
                flash.message = "You have changed the data version to ${sharedToolsService.getDataVersion ()}"
            } else {
                flash.message = "But the data version was already ${currentDataVersion}"
            }
        }
        render(view: 'systemMgr', model: [warningText:sharedToolsService.getWarningText(),
                                          currentRestServer:restServerService.currentRestServer(),
                                          currentApplicationIsSigma:sharedToolsService.applicationName(),
                                          helpTextLevel:sharedToolsService.getHelpTextSetting(),
                                          newApi:sharedToolsService.getNewApi(),
                                          forceMetadataCacheOverride:sharedToolsService.getMetadataOverrideStatus(),
                                          dataVersion:sharedToolsService.getDataVersion (),
                                          currentGeneChromosome:sharedToolsService.retrieveCurrentGeneChromosome(),
                                          currentVariantChromosome:sharedToolsService.retrieveCurrentVariantChromosome()])

    }




    def updateRestServer() {
        String restServer = params.datatype
        String currentServer =  restServerService.whatIsMyCurrentServer()
        if  (restServer == 'prodloadbalancedserver')  {
            if (!(currentServer == 'prodloadbalancedserver')) {
                restServerService.goWithTheProdLoadBalancedServer()
                flash.message = "You are now using the ${restServer} server!"
            }  else {
                flash.message = "But you were already using the ${currentServer} server!"
            }
        } else  if (restServer == 'qaloadbalancedserver')  {
            if (!(currentServer == 'qaloadbalancedserver')) {
                restServerService.goWithTheQaLoadBalancedServer()
                flash.message = "You are now using the ${restServer} server!"
            }  else {
                flash.message = "But you were already using the ${currentServer} server!"
            }
        } else  if (restServer == 'qa01behindloadbalancer')  {
            if (!(currentServer == 'qa01behindloadbalancer')) {
                restServerService.goWithTheQa01BehindLoadBalancer()
                flash.message = "You are now using the ${restServer} server!"
            }  else {
                flash.message = "But you were already using the ${currentServer} server!"
            }
        } else  if (restServer == 'qa02behindloadbalancer')  {
            if (!(currentServer == 'qa02behindloadbalancer')) {
                restServerService.goWithTheQa02BehindLoadBalancer()
                flash.message = "You are now using the ${restServer} server!"
            }  else {
                flash.message = "But you were already using the ${currentServer} server!"
            }
        } else  if (restServer == 'devloadbalancedserver')  {
            if (!(currentServer == 'devloadbalancedserver')) {
                restServerService.goWithTheDevLoadBalancedServer()
                flash.message = "You are now using the ${restServer} server!"
            }  else {
                flash.message = "But you were already using the ${currentServer} server!"
            }
        } else  if (restServer == 'dev01behindloadbalancer')  {
            if (!(currentServer == 'dev01behindloadbalancer')) {
                restServerService.goWithTheDev01BehindLoadBalancer()
                flash.message = "You are now using the ${restServer} server!"
            }  else {
                flash.message = "But you were already using the ${currentServer} server!"
            }
        } else  if (restServer == 'dev02behindloadbalancer')  {
            if (!(currentServer == 'dev02behindloadbalancer')) {
                restServerService.goWithTheDev02BehindLoadBalancer()
                flash.message = "You are now using the ${restServer} server!"
            }  else {
                flash.message = "But you were already using the ${currentServer} server!"
            }
        } else  if (restServer == 'newdevserver')  {
            if (!(currentServer == 'newdevserver')) {
                restServerService.goWithTheNewDevServer()
                flash.message = "You are now using the ${restServer} server!"
            }  else {
                flash.message = "But you were already using the ${currentServer} server!"
            }
        } else  if (restServer == 'aws01restserver')  {
            if (!(currentServer == 'aws01restserver')) {
                restServerService.goWithTheAws01RestServer()
                flash.message = "You are now using the ${restServer} server!"
            }  else {
                flash.message = "But you were already using the ${currentServer} server!"
            }
        } else  if (restServer == 'prodserver')  {
            if (!(currentServer == 'prodserver')) {
                restServerService.goWithTheProdServer()
                flash.message = "You are now using the ${restServer} server!"
            }  else {
                flash.message = "But you were already using the ${currentServer} server!"
            }
        }


        render(view: 'systemMgr', model: [warningText:sharedToolsService.getWarningText(),
                                          currentRestServer:restServerService.currentRestServer(),
                                          currentApplicationIsSigma:sharedToolsService.applicationName(),
                                          helpTextLevel:sharedToolsService.getHelpTextSetting(),
                                          newApi:sharedToolsService.getNewApi(),
                                          forceMetadataCacheOverride:sharedToolsService.getMetadataOverrideStatus(),
                                          dataVersion:sharedToolsService.getDataVersion (),
                                          currentGeneChromosome:sharedToolsService.retrieveCurrentGeneChromosome(),
                                          currentVariantChromosome:sharedToolsService.retrieveCurrentVariantChromosome()])
    }

    def switchSigmaT2d(){
       // String restServer = params
        String requestedApplication = params.datatype
        if ( requestedApplication == 'sigma')  {
            sharedToolsService.setApplicationToSigma  ()
            redirect(controller:'home', action:'index')
            return
        }  else if  ( requestedApplication == 't2dgenes')  {
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

        render(view: 'systemMgr', model: [warningText:sharedToolsService.getWarningText(),
                                          currentRestServer:restServerService.currentRestServer(),
                                          currentApplicationIsSigma:sharedToolsService.applicationName(),
                                          helpTextLevel:sharedToolsService.getHelpTextSetting(),
                                          newApi:sharedToolsService.getNewApi(),
                                          forceMetadataCacheOverride:sharedToolsService.getMetadataOverrideStatus(),
                                          dataVersion:sharedToolsService.getDataVersion (),
                                          currentGeneChromosome:sharedToolsService.retrieveCurrentGeneChromosome(),
                                          currentVariantChromosome:sharedToolsService.retrieveCurrentVariantChromosome()])
    }


    def switchApplicationToT2dgenes(){
        sharedToolsService.setApplicationToT2dgenes()
        render(view: 'systemMgr', model: [warningText:sharedToolsService.getWarningText(),
                                          currentRestServer:restServerService.currentRestServer(),
                                          currentApplicationIsSigma:sharedToolsService.applicationName(),
                                          helpTextLevel:sharedToolsService.getHelpTextSetting(),
                                          newApi:sharedToolsService.getNewApi(),
                                          forceMetadataCacheOverride:sharedToolsService.getMetadataOverrideStatus(),
                                          dataVersion:sharedToolsService.getDataVersion (),
                                          currentGeneChromosome:sharedToolsService.retrieveCurrentGeneChromosome(),
                                          currentVariantChromosome:sharedToolsService.retrieveCurrentVariantChromosome()])
    }

}
