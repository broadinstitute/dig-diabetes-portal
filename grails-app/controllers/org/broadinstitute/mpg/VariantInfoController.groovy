package org.broadinstitute.mpg
import grails.converters.JSON
import groovy.json.JsonSlurper
import org.broadinstitute.mpg.diabetes.BurdenService
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject
import org.springframework.web.servlet.support.RequestContextUtils
/**
 * Controller class to control the /variantInfo section of the T2D site
 */
class VariantInfoController {
    RestServerService   restServerService
    SharedToolsService sharedToolsService
    BurdenService burdenService

    def index() { }

    /***
     *  Launch the page frame that will hold a friendly collection of information about a single variant. The associated Ajax call is  variantAjax
     * @return
     */
    def variantInfo() {
        String locale = RequestContextUtils.getLocale(request)
        String variantToStartWith = params.id
        if (variantToStartWith) {

/*
            // get the chrom/pos for the LZ widget
            JSONObject jsonObject =  restServerService.retrieveVariantInfoByName (variantToStartWith.trim())
            if (jsonObject != null) {
                log.info(jsonObject)
                JSONArray propertyArray = jsonObject?.getJSONArray("variants")?.get(0);
                String chromosome = null;
                Integer position = null;
                log.info(jsonObject?.toString())

                for (JSONObject property : propertyArray) {
                    if (property?.getString("CHROM")) {
                        chromosome = property?.getString("CHROM");
                    }
                    if (property?.getString("POS")) {
                        position = Integer.valueOf(property?.getString("POS"))
                    }
                }

                String regionSpecification = chromosome + ":" + ((position > 250) ? (position - 250) : 0) + "-" + (position + 250)

            }
*/
            render(view: 'variantInfo',
                    model: [variantToSearch: variantToStartWith.trim(),
                            regionSpecification: "5:57000000-58000000",
                            show_gwas      : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                            show_exchp     : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                            show_exseq     : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                            locale:locale ])

        }
    }

    /***
     * provide  a nice collection of information about a single variant. This is the Ajax call associated with variantInfo
     * @return
     */
    def variantAjax() {
        String variantToStartWith = params.id
        if (variantToStartWith)      {
            JSONObject jsonObject =  restServerService.retrieveVariantInfoByName (variantToStartWith.trim())
            render(status:200, contentType:"application/json") {
                [variant:jsonObject]
            }

        }
    }




    def retrieveBurdenMetadataAjax() {
        JSONObject jsonObject =  restServerService.retrieveBurdenMetadata ()
        render(status:200, contentType:"application/json") {
            [metaData:jsonObject]
        }
    }











    /**
     * method to service ajax call for the 'What effect on the encoded protein' section/accordion
     *
     * @return
     */
    def proteinEffect (){
        String variantId = params.variantId
        JSONObject jsonObject =  restServerService.gatherProteinEffect ( variantId.trim().toUpperCase())
        render(status:200, contentType:"application/json") {
            [variantInfo:jsonObject]
        }
    }

    /**
     * method to service ajax call for the 'Variant frequency difference for patients with disease' section/accordion
     *
     * @return
     */
    def variantDiseaseRisk (){
        String variantId = params.variantId
        JSONObject jsonObject =  restServerService.combinedVariantDiseaseRisk ( variantId.trim().toUpperCase(), "ExSeq_17k_mdv2")
        render(status:200, contentType:"application/json") {
            [variantInfo:jsonObject]
        }
    }

// strictly static, but we need a metadata enhancement to pull these data back dynamically
//on

    /**
     * method to service the ajax call for the 'variant association statistics (pvalue/OR)' section/accordion
     *
     * @return
     */
    def variantDescriptiveStatistics (){
        String variantId = params.variantId
        String datasetStructs = params.datasets
        String phenotype = params.phenotype
        JSONArray jsonArray = JSON.parse(datasetStructs)
        Iterator<JSONObject> iterator = jsonArray.iterator()
        List<LinkedHashMap> linkedHashMapList = []
        while (iterator.hasNext()) {
            JSONObject value = iterator.next();
            LinkedHashMap linkedHashMap = [:]
            linkedHashMap['technology']=value.technology
            linkedHashMap['name']=value.name
            linkedHashMap['pvalue']=value.pvalue
            linkedHashMap['orvalue']=value.orvalue
            linkedHashMap['betavalue']=value.betavalue
            linkedHashMapList << linkedHashMap
        }
        JSONObject jsonObject =  restServerService.combinedVariantAssociationStatistics ( variantId.trim().toUpperCase(),phenotype, linkedHashMapList)
        render(status:200, contentType:"application/json") {
            [variantInfo:jsonObject]
        }
    }

    /**
     * method to service the ajax call for the 'How common is' section/accordion
     *
     * @return
     */
    def howCommonIsVariant(){
        String variantId = params.variantId
        String showAll = params.showAll
        JSONObject jsonObject =  restServerService.howCommonIsVariantAcrossEthnicities ( variantId.trim().toUpperCase(),showAll)
        render(status:200, contentType:"application/json") {
            [variantInfo:jsonObject]
        }
    }

    /***
     * This call supports the burden test on the variant info page
     * @return
     */
    def burdenTestAjax() {
        // log parameters received
        // Here are some example parameters, as they show up in the params variable
        // params.filterNum=="2" // value=id from burdenTestVariantSelectionOptionsAjax, or 0 if no selection was made (which is a legal choice)
        // params.dataSet=="1" // where 1->13k, 2->26k"
        // params.variantName=="SLC30A8" // string representing gene name

        // Really?  Different names for phenotypes?  Well, okay, let's translate them
        String traitFilterOptionId = (params.traitFilterSelectedOption ? params.traitFilterSelectedOption : "t2d");     // default to t2d if none given
        switch (traitFilterOptionId) {
            case "BMI": traitFilterOptionId = "BMI"; break
            case "T2D": traitFilterOptionId = "t2d"; break
            case "FG": traitFilterOptionId = "FAST_GLU_ANAL"; break
            case "FI": traitFilterOptionId = "FAST_INS_ANAL"; break
            case "CHOL": traitFilterOptionId = "CHOL_ANAL"; break
            case "LDL": traitFilterOptionId = "LDL_ANAL"; break
            case "HDL": traitFilterOptionId = "HDL_ANAL"; break
            case "TG": traitFilterOptionId = "TG_ANAL"; break
            case "SBP": traitFilterOptionId = "SBP_ANAL"; break
            case "DBP": traitFilterOptionId = "DBP_ANAL"; break
            default:traitFilterOptionId = "t2d"; break
        }

        log.info("got parameters: " + params);
        JsonSlurper slurper = new JsonSlurper()
        JSONObject jsonObject = slurper.parseText(params.covariates)
        // cast the parameters
        String variantName = params.variantName;

        // TODO - eventually create new bean to hold all the options and have smarts for double checking validity
        JSONObject result = this.burdenService.callBurdenTestForTraitAndDbSnpId(traitFilterOptionId, variantName, jsonObject);

        // send json response back
        render(status: 200, contentType: "application/json") {result}
    }

    /***
     * Get the contents for the filter drop-down box on the burden test section of the gene info page
     * @return
     */
    def burdenTestTraitSelectionOptionsAjax() {
        JSONObject jsonObject = this.burdenService.getBurdenTraitSelectionOptions()

        // log
        log.info("got burden trait options: " + jsonObject);

        // send json response back
        render(status: 200, contentType: "application/json") {jsonObject}
    }

}
