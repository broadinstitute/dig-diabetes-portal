package org.broadinstitute.mpg

import groovy.json.JsonSlurper
import org.apache.juli.logging.LogFactory
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject
import org.springframework.web.servlet.support.RequestContextUtils

class TraitController {
    RestServerService restServerService
    SharedToolsService sharedToolsService
    private static final log = LogFactory.getLog(this)
    MetaDataService metaDataService
    MetadataUtilityService metadataUtilityService
    WidgetService widgetService

    /***
     * create page frame for association statistics across 25 traits for a single variant. The resulting Ajax call is  ajaxTraitsPerVariant
     * @return
     */
    def traitInfo() {
        String variantIdentifier = params.getIdentifier()
        // get locale to provide to table-building plugin
        String locale = RequestContextUtils.getLocale(request)

        render(view: 'traitsPerVariant',
                model: [dnSnpId          : variantIdentifier,
                        variantIdentifier: variantIdentifier,
                        locale           : locale])
    }


    def retrieveIgvDropDownInfo (){

    }






    /**
     * serves the associatedStatisticsTraitsPerVariant.gsp fragment; should be independent widget
     *
     * @return
     */
    def ajaxAssociatedStatisticsTraitPerVariant() {
        // parse
        String variant = params["variantIdentifier"]
        String technology = ""
        if (params["technology"]) {
            technology = params["technology"]
        }
        JSONObject jsonObject = restServerService.getTraitPerVariant(variant, technology)

        def showExomeChip = sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp);
        def showExomeSequence = sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq);
        def showGene = sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gene);

        render(status: 200, contentType: "application/json") {
            [show_gene: showGene, show_exseq: showExomeSequence, show_exchp: showExomeChip, traitInfo: jsonObject]
        }
    }

    /**
     * serves the associatedStatisticsTraitsPerVariant.gsp fragment; should be independent widget
     *
     * @return
     */
    def ajaxSpecifiedAssociationStatisticsTraitsPerVariant() {
        // parse

        JSONObject jsonObjectFromBrowser
        JsonSlurper slurper = new JsonSlurper()
        if (params["chosendataData"]) {
            jsonObjectFromBrowser = slurper.parseText(params["chosendataData"])
        }
        String variant = params["variantIdentifier"]
        String technology = ""
        if (params["technology"]) {
            technology = params["technology"]
        }
        // JSONObject jsonObject = restServerService.getTraitPerVariant( variant,technology)
        JSONObject jsonObject = restServerService.getSpecifiedTraitPerVariant(variant,
                jsonObjectFromBrowser.vals.collect {
                    return new LinkedHashMap(ds: it.ds, phenotype: it.phenotype, prop: it.prop, otherFields: it.otherFields)
                },
                jsonObjectFromBrowser.phenos)

        def showExomeChip = sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp);
        def showExomeSequence = sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq);
        def showGene = sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gene);

        render(status: 200, contentType: "application/json") {
            [show_gene: showGene, show_exseq: showExomeSequence, show_exchp: showExomeChip, traitInfo: jsonObject]
        }
    }

    /***
     * Returns association statistics across 25 traits for a single variant.  The launching page is traitInfo
     * @return
     */
    def ajaxSampleGroupsPerTrait() {
        String phenotype = params["phenotype"]
        List<SampleGroup> sampleGroupList = metaDataService.getSampleGroupListForPhenotypeAndVersion(phenotype, "", MetaDataService.METADATA_VARIANT)
        List<String> sampleGroupStrings = []
        List<String> sortedSampleGroupStrings = sampleGroupList.sort { a, b -> return b.subjectsNumber <=> a.subjectsNumber }
        String largestSampleGroup = sortedSampleGroupStrings?.first()?.getSystemId()
        for (SampleGroup sampleGroup in sampleGroupList) {
            String sampleGroupId = sampleGroup.getSystemId()
            String sampleGroupTranslation = g.message(code: "metadata." + sampleGroupId, default: sampleGroupId)
            sampleGroupStrings << """{"sg":"${sampleGroupId}","sgn":"${sampleGroupTranslation}","default":${
                (sampleGroupId == largestSampleGroup) ? 1 : 0
            }}\n"""
        }
        String rawJson = "[" + sampleGroupStrings.join(",") + "]"
        JsonSlurper slurper = new JsonSlurper()
        JSONArray jsonArray = new JSONArray()
        // Very strange.  the parseText call gives me a different datatype if I have an array with one object.  It shouldn't.  The following workaround
        // seems to always function correctly: create JSONArray with a constructor, and add your collection to it, rather than directly assigning the
        // results from parseText
        def tempArray = slurper.parseText(rawJson)
        jsonArray.addAll(tempArray)

        //JSONArray jsonArray = slurper.parseText(rawJson)
        render(status: 200, contentType: "application/json") {
            [sampleGroups: jsonArray]
        }

    }

    /***
     *  search for a single trait from the main page and this will be the page frame.  The resulting Ajax call is  phenotypeAjax
     * @return
     */
    def traitSearch() {
        String phenotypeKey = sharedToolsService.convertOldPhenotypeStringsToNewOnes(params.trait)
        String requestedSignificance = params.significance
        String sampleGroupOwner = this.metaDataService.getGwasSampleGroupNameForPhenotype(phenotypeKey)
        String phenotypeDataSet = ''
        String phenotypeTranslation = g.message(code: "metadata." + phenotypeKey, default: phenotypeKey)
        List<SampleGroup> sampleGroupList = metaDataService.getSampleGroupListForPhenotypeAndVersion(phenotypeKey, "", MetaDataService.METADATA_VARIANT)
        List<SampleGroup> sortedSampleGroups = sampleGroupList.sort { a, b -> b.subjectsNumber <=> a.subjectsNumber }
        SampleGroup chosenSampleGroup = sortedSampleGroups?.first()
        String chosenSampleGroupId = chosenSampleGroup?.getSystemId()
        String locale = RequestContextUtils.getLocale(request)

        render(view: 'phenotype',
                model: [show_gwas            : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                        show_exchp           : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                        show_exseq           : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
                        show_gene            : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gene),
                        phenotypeKey         : phenotypeKey,
                        phenotypeName        : phenotypeTranslation,
                        phenotypeDataSet     : phenotypeDataSet,
                        sampleGroupOwner     : sampleGroupOwner,
                        requestedSignificance: requestedSignificance,
                        chosenSampleGroupId  : chosenSampleGroupId,
                        locale               : locale])

    }

    /***
     * This Ajax call is launched from the traitSearch page frame
     * @return
     */
    def phenotypeAjax() {
        String significance = params["significance"]
        String phenotypicTrait = params["trait"]
        String dataSetName = params["sampleGroup"]
        BigDecimal significanceValue
        try {
            significanceValue = new BigDecimal(significance)
        } catch (NumberFormatException nfe) {
            log.info("USER ERROR: User supplied a nonnumeric significance value = '${significance}")
            // TODO: error condition.  Go with GWAS significance
            significanceValue = 0.00000005
        }
        
        LinkedHashMap properties = [:]
        if (phenotypicTrait) {
            if (!dataSetName) {
                List<SampleGroup> sampleGroupList = metaDataService.getSampleGroupListForPhenotypeAndVersion(phenotypicTrait, "", MetaDataService.METADATA_VARIANT)
                List<String> sortedSampleGroupStrings = sampleGroupList.sort { a, b -> return b.subjectsNumber <=> a.subjectsNumber }
                dataSetName = sortedSampleGroupStrings?.first()?.getSystemId()

            }
            List<PhenotypeBean> phenotypeList = metaDataService.getAllPhenotypesWithName(phenotypicTrait)
            List<Property> propertyList = metadataUtilityService.retrievePhenotypeProperties(phenotypeList)
            for (Property property in propertyList) {
                properties[property.getName()] = property.getPropertyType()
            }
        }

//          List<PhenotypeBean> phenotypeList = metaDataService.getAllPhenotypesWithName(phenotypicTrait)
//         if ((phenotypeList?.size()>0) && (!dataSetName)){
//             List<Property> propertyList =  metadataUtilityService.retrievePhenotypeProperties(phenotypeList)
//             dataSetName = metadataUtilityService.retrievePhenotypeSampleGroupId(phenotypeList)
//             for (Property property in propertyList){
//                 properties[property.getName()] = property.getPropertyType()
//             }
//         }
        JSONObject jsonObject = restServerService.getTraitSpecificInformation(phenotypicTrait, dataSetName, properties, significanceValue, 0.0)
        render(status: 200, contentType: "application/json") {
            [variant: jsonObject]
        }

    }

    /***
     * Returns association statistics across 25 traits for a single variant.  The launching page is traitInfo
     * @return
     */
    def ajaxTraitsPerVariant() {
        String variant = params["variantIdentifier"]
        String technology = "GWAS"
        if (params["technology"]) {
            technology = params["technology"]
        }
        JSONObject jsonObject = restServerService.getTraitPerVariant(variant, technology)
        render(status: 200, contentType: "application/json") {
            [traitInfo: jsonObject]
        }

    }

    /***
     * Get here from the "Click here to see a GWAS summary of this region" link. Associated Ajax call is traitVariantCrossAjax
     * @return
     */
    def regionInfo() {
        String regionSpecification = params.id

        // log params
        log.info("regionInfo got params: " + params);

        String encodedString = this.metaDataService.urlEncodedListOfPhenotypes();
        render(view: 'traitVariantCross',
                model: [regionSpecification: regionSpecification,
                        phenotypeList      : encodedString,
                        show_gene          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gene),
                        show_gwas          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                        show_exchp         : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                        show_exseq         : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq)])
    }

    /***
     * Get here from the "Click here to see a GWAS summary of this region" link. Associated Ajax call is traitVariantCrossAjax
     * @return
     */
    def regionInfoGetData() {
        String regionSpecification = params.id

        // test of whether to use the new getData emulated call instead
        String getData = "getData"

        // log params
        log.info("regionInfoGetData got params: " + params);

        String encodedString = this.metaDataService.urlEncodedListOfPhenotypes();
        render(view: 'traitVariantCross',
                model: [regionSpecification: regionSpecification,
                        phenotypeList      : encodedString,
                        getData            : getData,
                        show_gene          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gene),
                        show_gwas          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                        show_exchp         : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                        show_exseq         : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq)])
    }

    /**
     * new method to use the getData call to get the data in trait-search REST call result format
     *
     * @return
     */
    def traitVariantCrossGetDataAjaxTest() {
        String regionsSpecification = params.id
        List<Phenotype> phenotypeList = new ArrayList<Phenotype>();
        Map<String, Phenotype> phenotypeMap;

        // log
        log.info("for traitVariantCrossGetDataAjaxTest call, got params: " + params)

        // get the phenotype list
        // DIGP-291: centralize metadata version
        phenotypeMap = this.metaDataService.getPhenotypeMapByTechnologyAndVersion("GWAS", this.metaDataService?.getDataVersion());

        // select the phenotypes to search for
        phenotypeList.add(phenotypeMap.get("T2D"));
        phenotypeList.add(phenotypeMap.get("WHR"));
        phenotypeList.add(phenotypeMap.get("BMI"));

        // submit query
        JSONObject jsonObject = this.metaDataService.searchTraitByUnparsedRegion(regionsSpecification, phenotypeList);

        // log
        log.info("for traitVariantCrossAjaxTest, got json results object: " + jsonObject);

        if (jsonObject) {
            render(status: 200, contentType: "application/json") {
                [variants: jsonObject['variants']]
            }
        } else {
            render(status: 300, contentType: "application/json")
        }

    }

    /**
     * new method to use the getData call to get the data in trait-search REST call result format
     *
     * @return
     */
    def traitVariantCrossGetDataAjax() {
        String regionsSpecification = params.id
        List<org.broadinstitute.mpg.diabetes.metadata.Phenotype> phenotypeList = null;

        // log
        log.info("for traitVariantCrossGetDataAjax call, got params: " + params)

        // get the phenotype list
        // DIGP-291: centralize metadata version
        phenotypeList = this.metaDataService.getPhenotypeListByTechnologyAndVersion("GWAS", this.metaDataService?.getDataVersion());

        // submit query
        JSONObject jsonObject = this.metaDataService.searchTraitByUnparsedRegion(regionsSpecification, phenotypeList);

        // log
        log.info("for traitVariantCrossAjax, got json results object: " + jsonObject);

        if (jsonObject) {
            render(status: 200, contentType: "application/json") {
                [variants: jsonObject['variants']]
            }
        } else {
            render(status: 300, contentType: "application/json")
        }

    }

    /***
     * called by regionInfo, this provides information across 25 phenotypes. Use it to populate our big region graphic (the one that
     * may one day be supplanted by LocusZoom?)
     * @return
     */
    def getData() {
        String requestPayload = request.JSON

        // log
        println "payload=${requestPayload}"
        log.info("for getData call, got params: " + params)

        header 'Allow', "HEAD,GET,PUT,DELETE,OPTIONS"

        JSONObject jsonObject = restServerService.postGetDataCall(requestPayload)

        render(status: 200, contentType: "application/json") {
            jsonObject
        }

    }

    /***
     * called by regionInfo, this provides information across 25 phenotypes. Use it to populate our big region graphic (the one that
     * may one day be supplanted by LocusZoom?)
     * @return
     */
    def traitVariantCrossByGeneAjax() {
        String geneName = params.geneName
        LinkedHashMap<String, Integer> geneExtents = sharedToolsService.getGeneExpandedExtent(geneName)
        JSONObject jsonObject = restServerService.searchForTraitBySpecifiedRegion(geneExtents.chrom as String,
                geneExtents.startExtent as String,
                geneExtents.endExtent as String)
        if (jsonObject) {
            render(status: 200, contentType: "application/json") {
                [variants: jsonObject['variants']]
            }
        } else {
            render(status: 300, contentType: "application/json")
        }

    }


    def retrievePotentialIgvTracks(){
        // defined this tiny little closure that we use locally
        Closure convertStaticStructToJson = { incoming ->
            List<String> allOptions = []
            incoming.each { Map map ->
                List<String> perOptionFields = []
                map.each { k, v -> perOptionFields << " \"$k\":\"$v\" " }
                allOptions << "{${perOptionFields.join(",")}}"
            }
            return "[${allOptions.join(",")}]"
        }
        Closure convertDynamicStructToJson = { incoming ->
            List<String> allOptions = []
            incoming.each { org.broadinstitute.mpg.locuszoom.PhenotypeBean phenotypeBean ->
                List<String> perOptionFields = []

                perOptionFields << " \"type\":\"gwas\" "
                perOptionFields << " \"trait\":\"${phenotypeBean.name}\" "
                perOptionFields << " \"dataset\":\"${phenotypeBean.dataSet}\" "
                perOptionFields << " \"pvalue\":\"${phenotypeBean.propertyName}\" "
                perOptionFields << " \"name\":\"${phenotypeBean.description}\" "
                allOptions << "{${perOptionFields.join(",")}}"
            }
            return "[${allOptions.join(",")}]"
        }

        JsonSlurper slurper = new JsonSlurper()
        List strokeDefaultDataSources = []

        List t2dDefaultDataSources = []

        List miDefaultDataSources = []

        List<org.broadinstitute.mpg.locuszoom.PhenotypeBean> phenotypeMap = widgetService.getHailPhenotypeMap()
        List<org.broadinstitute.mpg.locuszoom.PhenotypeBean> staticPhenotypeMap = phenotypeMap.findAll{org.broadinstitute.mpg.locuszoom.PhenotypeBean phenotypeBean->phenotypeBean.dataType=='static'}
        t2dDefaultDataSources.addAll(staticPhenotypeMap.findAll{org.broadinstitute.mpg.locuszoom.PhenotypeBean phenotypeBean->( phenotypeBean.key=='T2D'||
                                                                                                                                phenotypeBean.key=='FG'||
                                                                                                                                phenotypeBean.key=='FI')} )
        strokeDefaultDataSources.addAll(staticPhenotypeMap.findAll{org.broadinstitute.mpg.locuszoom.PhenotypeBean phenotypeBean->(  phenotypeBean.key=='Stroke_all'||
                                                                                                                                    phenotypeBean.key=='Stroke_deep'||
                                                                                                                                    phenotypeBean.key=='Stroke_lobar')} )
        miDefaultDataSources.addAll(staticPhenotypeMap.findAll{org.broadinstitute.mpg.locuszoom.PhenotypeBean phenotypeBean->( phenotypeBean.key=='CAD'||
                                                                                                                                phenotypeBean.key=='CE')} )

        String portalType = g.portalTypeString() as String
        String distributedKb = g.distributedKBString() as String
        List dataSources = []
        List defaultDataSources = []

        // kludge alert
        switch (portalType){
            case 't2d':
                defaultDataSources = t2dDefaultDataSources
                break
            case 'stroke':
                defaultDataSources = strokeDefaultDataSources
                break
            case 'mi':
                defaultDataSources = miDefaultDataSources
                break
            default:
                defaultDataSources = t2dDefaultDataSources
                break
        }



        render(status: 200, contentType: "application/json") {
            [allSources:slurper.parseText(convertDynamicStructToJson(staticPhenotypeMap)),
            defaultTracks:slurper.parseText(convertDynamicStructToJson(defaultDataSources))]
        }

    }







}
