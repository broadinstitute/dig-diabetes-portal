package org.broadinstitute.mpg

import groovy.json.JsonSlurper
import org.apache.juli.logging.LogFactory
import org.broadinstitute.mpg.diabetes.BurdenService
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.broadinstitute.mpg.locuszoom.PhenotypeBean
import org.broadinstitute.mpg.meta.UserQueryContext
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.core.io.ResourceLocator
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject
import org.springframework.web.servlet.support.RequestContextUtils

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class GeneController {
    RestServerService restServerService
    GeneManagementService geneManagementService
    SharedToolsService sharedToolsService
    MetaDataService metaDataService
    private static final log = LogFactory.getLog(this)
    SqlService sqlService
    BurdenService burdenService
    WidgetService widgetService
    EpigenomeService epigenomeService
    GrailsApplication grailsApplication


    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    /***
     * return partial matches as Json for the purposes of the twitter typeahead handler
     * @return
     */
    def index() {
        String partialMatches = geneManagementService.partialGeneMatchesUsingStringLists(params.query,27)
        response.setContentType("application/json")
        render ("${partialMatches}")
    }

    /***
     * We want to be able to do a type ahead in a gene name only field
     * @return
     */
    def geneOnlyTypeAhead() {
        String partialMatches = geneManagementService.partialGeneOnlyMatches(params.query,27)
        response.setContentType("application/json")
        render ("${partialMatches}")
    }


    /***
     * We want to be able to do a type ahead in a gene name only field
     * @return
     */
    def variantOnlyTypeAhead() {
        String partialMatches = geneManagementService.partialVariantOnlyMatches(params.query,27)
        response.setContentType("application/json")
        render ("${partialMatches}")
    }





    /***
     * display all information about a gene. This call displays only the core of the page -- the data all come back
     * with the Json
     * @return
     */
    def geneInfo() {
        String locale = RequestContextUtils.getLocale(request)
        String geneToStartWith = params.id
        Long startExtent=0L
        Long endExtent=0L
        String chromosomeNumber=params.chromosomeNumber
        LinkedHashMap savedCols = params.findAll{ it.key =~ /^savedCol/ }
        LinkedHashMap savedRows = params.findAll{ it.key =~ /^savedRow/ }
        String newVandAColumnName = "custom significance"
        String newVandAColumnPValue
        String newDatasetName
        String phenotype = metaDataService.getDefaultPhenotype()
        String portalType = g.portalTypeString() as String
        String igvIntro = ""
        List <String> defaultTissues = []
        switch (portalType){
            case 't2d':
                igvIntro = g.message(code: "gene.igv.intro1", default: "Use the IGV browser")
                break
            case 'mi':
                igvIntro = g.message(code: "gene.mi.igv.intro1", default: "Use the IGV browser")
                break
            case 'stroke':
                igvIntro = g.message(code: "gene.stroke.igv.intro1", default: "Use the IGV browser")
                break
            case 'ibd':
                igvIntro = g.message(code: "gene.ibd.igv.intro1", default: "Use the IGV browser")
                break
            default:
                break
        }
        try {
            startExtent = Long.parseLong(params.startExtent)
            endExtent = Long.parseLong(params.endExtent)
        } catch(e){
          //  e.printStackTrace()
        }
        defaultTissues = restServerService.retrieveBeanForPortalType(portalType)?.getTissues()

        if (params.phenotypeChooser){
            phenotype = params.phenotypeChooser
        }

        // capture requests related to a new column
        if (params.pValue) {
            newVandAColumnPValue =  params.pValue
        }
        if (params.columnName) {
            newVandAColumnName =  params.columnName
        }
        if (params.dataSetChooser) {
            newDatasetName =  params.dataSetChooser // data set^ P value property name
        }
        String phenotypeList = this.metaDataService?.urlEncodedListOfPhenotypes();

        String regionSpecification = sharedToolsService.generateRegionString(chromosomeNumber,  startExtent,  endExtent,  geneToStartWith,  restServerService.EXPAND_ON_EITHER_SIDE_OF_GENE )

        List <LinkedHashMap<String,String>> columnInformation = []
        // if we have saved values then use them, otherwise add the defaults
        if (savedCols.size()>0){
            savedCols.each{String key, String value->
                List <String> listOfProperties = value.tokenize("^")
                if (listOfProperties.size()>2) {
                    columnInformation << [name:listOfProperties[0], value:listOfProperties[1], count:listOfProperties[2]]
                }
            }
        } else { // no saved columns -- provide some defaults
            columnInformation << [name:'total variants', value:'1', count:'0']
            columnInformation << [name:'nominal', value:'0.05', count:'0']
            columnInformation << [name:'locus-wide', value:'0.00005', count:'0']
            columnInformation << [name:'genome-wide', value:'0.00000005', count:'0']
        }
        if (newVandAColumnPValue){
            String filteredNumericPValue = newVandAColumnPValue.replaceAll(/\s*x\s*10/,"e") // take out any references to 10x, which would match the representation and the table, so I guess it's
            // a fair mistake for a novice.   replace with a legal numerical format
            try {
                new BigDecimal(filteredNumericPValue)
                columnInformation << [name:"${newVandAColumnName}", value:"${filteredNumericPValue}", count:'0']
            } catch (e){
                columnInformation << [name:"${newVandAColumnName}", value:"1", count:'0'] // wrong value, but at least we don't crash
            }
        }
        List <LinkedHashMap<String,String>> sortedColumnInformation = columnInformation.sort{a,b-> (b.value as Float)<=>(a.value as Float)}

        List<PhenotypeBean> lzOptions = this.widgetService?.getHailPhenotypeMap()

        StringBuilder sb = new StringBuilder("[")
        if (portalType=='ibd'){
            LinkedHashMap<String,List<String>> possibleExperiments =  epigenomeService.getThePossibleReadData("{\"version\":\"${ sharedToolsService.getCurrentDataVersion ()}\"}")
            List <String> allElements = []
            for (String key in possibleExperiments.keySet()){
                StringBuilder isb = new StringBuilder()
                isb << "{\"expt\":\"${key}\",\"assays\":[\""
                isb << possibleExperiments[key].join("\",\"")
                isb << "\"]}"
                allElements << isb.toString()
            }
            sb << allElements.join(",")
        }
        sb << "]"
        JsonSlurper slurper = new JsonSlurper()
        JSONArray experimentAssays = slurper.parseText(sb.toString())

        String assayId = restServerService.retrieveBeanForPortalType(portalType)?.getEpigeneticAssays()

        // DIGKB-217: get the default samples data set from the metadata
        SampleGroup defaultGeneBurdenSampleGroup = this.metaDataService.getDefaultBurdenGeneDataset();
        String defaultGeneBurdenSamplesDataSetName = defaultGeneBurdenSampleGroup?.getSystemId();
        String defaultGeneBurdenDataSetName

        Iterator<String> meaningIterator = defaultGeneBurdenSampleGroup?.getMeaningSet().iterator();
        while (meaningIterator.hasNext()) {
            String variantDataSet = meaningIterator.next();
            if (variantDataSet.contains("DATASET_")) {
                defaultGeneBurdenDataSetName = variantDataSet.substring(variantDataSet.indexOf("DATASET_") + 8);
                break;
            }
        }

        if ((geneToStartWith)||
                ((endExtent>0) && (chromosomeNumber)  ))  {
            String locusZoomDataset = metaDataService.getDefaultDataset()
            JSONArray passDefaultTissues = []
            JSONArray passDefaultTissuesDescriptions = []
            for (String tissue in defaultTissues){
                passDefaultTissues.put("'${tissue}'")
                passDefaultTissuesDescriptions.put("'${g.message(code: "metadata." + tissue, default: tissue)}'")
            }
            LinkedHashMap geneExtent =[:]
            if ((chromosomeNumber)&&(endExtent>0)) {
                geneExtent["startExtent"] = startExtent
                geneExtent["endExtent"] = endExtent
                geneExtent["chrom"] = chromosomeNumber
            } else {
                geneExtent = sharedToolsService.getGeneExpandedExtent(geneToStartWith,restServerService.EXPAND_ON_EITHER_SIDE_OF_GENE)
            }


            List<String> identifiedGenes = restServerService.retrieveGenesInExtents(
                    [chromosomeSpecified:geneExtent.chrom,
                     beginningExtentSpecified:geneExtent.startExtent,
                     endingExtentSpecified:geneExtent.endExtent])
            String defaultPhenotype = metaDataService.getDefaultPhenotype()
            String  geneUpperCase
            if (geneToStartWith){
                geneUpperCase =   geneToStartWith.toUpperCase()
            } else {
                geneUpperCase = regionSpecification.toUpperCase()
            }


            List<SampleGroup> sampleGroupsWithCredibleSets  = metaDataService.getSampleGroupListForPhenotypeWithMeaning(phenotype,"CREDIBLE_SET_ID")
            render (view: 'geneInfo', model:[show_gwas:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_gwas),
                                             show_exchp:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exchp),
                                             show_exseq:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exseq),
                                             phenotypeList: phenotypeList,
                                             regionSpecification: regionSpecification,
                                             geneName:geneUpperCase,
                                             geneExtentBegin:geneExtent.startExtent,
                                             geneExtentEnd:geneExtent.endExtent,
                                             geneChromosome:geneExtent.chrom,
                                             columnInformation:sortedColumnInformation,
                                             phenotype:phenotype,
                                             locale:locale,
                                             lzOptions:lzOptions,
                                             sampleDataSet: defaultGeneBurdenSamplesDataSetName,
                                             burdenDataSet:defaultGeneBurdenDataSetName,
                                             dataVersion: metaDataService.getDataVersion(),
                                             locusZoomDataset:locusZoomDataset,
                                             igvIntro: igvIntro,
                                             defaultTissues:passDefaultTissues,
                                             defaultTissuesDescriptions:passDefaultTissuesDescriptions,
                                             defaultPhenotype: defaultPhenotype,
                                             identifiedGenes:identifiedGenes,
                                             assayId: assayId,
                                             sampleLevelSequencingDataExists: restServerService.retrieveBeanForCurrentPortal().getSampleLevelSequencingDataExists(),
                                             genePageWarning:g.message(code: restServerService.retrieveBeanForCurrentPortal().getGenePageWarning(), default:restServerService.retrieveBeanForCurrentPortal().getGenePageWarning()),
                                             regionSpecificVersion:restServerService.retrieveBeanForCurrentPortal().getRegionSpecificVersion()
            ] )
        }
    }

    /***
     * we've been asked to search, but we don't know what kind of string. Figure it out, and then
     * go to the right page.  gene info? Variant info? or punt, and re-display the main home page
     */
    def findTheRightDataPage () {
        String uncharacterizedString = params.id

        UserQueryContext userQueryContext = widgetService.generateUserQueryContext(uncharacterizedString)

        if (userQueryContext.range){
            redirect(controller:'gene',action:'geneInfo', params: [id: userQueryContext.originalRequest,
                                                                   startExtent:userQueryContext.startOriginalExtent,
                                                                   endExtent:userQueryContext.endOriginalExtent,
                                                                   chromosomeNumber:userQueryContext.chromosome])
            return
        }

        if (userQueryContext.gene){
            redirect(controller:'gene',action:'geneInfo', params: [id: userQueryContext.originalRequest])
            return
        }

        if (userQueryContext.variant) {
            if (restServerService.retrieveBeanForCurrentPortal().getRegionSpecificVersion()) {
                redirect(controller: 'gene', action: 'geneInfo', params: [id              : userQueryContext.originalRequest,
                                                                          startExtent     : userQueryContext.startExpandedExtent,
                                                                          endExtent       : userQueryContext.endExpandedExtent,
                                                                          chromosomeNumber: userQueryContext.chromosome])
            } else {
                redirect(controller: 'variantInfo', action: 'variantInfo', params: [id: params.id])
                return
            }
        }


        if (userQueryContext.genomicPosition) {
            redirect(controller: 'gene', action: 'geneInfo', params: [id              : userQueryContext.originalRequest,
                                                                      startExtent     : userQueryContext.startExpandedExtent,
                                                                      endExtent       : userQueryContext.endExpandedExtent,
                                                                      chromosomeNumber: userQueryContext.chromosome])
            return
         }

        // give up and go home
        redirect(controller: 'home', action: 'portalHome', params: [id: params.id])
        return
     }

    /***
     * Get the information for the variants and association tables on the gene info page
     * @return
     */
    def genepValueCounts() {
        String geneToStartWith = params.geneName
        String phenotype = params.phenotype
        String dataset = params.dataset
        List<String> colSignificances = sharedToolsService.convertAnHttpList(params."colNames[]")

        List<Float> significanceValues = []
        for(String significance in colSignificances){
            try {
                significanceValues << Float.parseFloat(significance)
            } catch (ex) {
                log.error("nonnumeric significance value (${significance}) in genepValueCounts action in GeneController")
            }
        }

        JSONObject jsonObject =  restServerService.combinedVariantCountByGeneNameAndPValue ( geneToStartWith.trim().toUpperCase(), dataset, significanceValues, phenotype )

        // attach the translated name so that the client has access to it for sorting in the table
        jsonObject.translatedName = g.message(code: "metadata." + jsonObject.dataset, default: jsonObject.dataset)

        render(status:200, contentType:"application/json") {
            jsonObject
        }
    }


    /***
     * get the information needed for the Variants across Continental Ancestry table on the gene info page
     * @return
     */
    def geneEthnicityCounts (){
        String geneToStartWith = params.geneName
        List<String> rowNames = sharedToolsService.convertAnHttpList(params."rowNames[]")
        List<String> colSignificances = sharedToolsService.convertAnHttpList(params."colNames[]")
        List <LinkedHashMap<String,String>> rowMaps = []
        if (!rowNames)  {

            rowMaps  = []
            List<SampleGroup> fullListOfSampleGroups = sharedToolsService.listOfTopLevelSampleGroups( "", "MAF", ["ExSeq","ExChip","GWAS", "WGS"])
            for (SampleGroup sampleGroup in fullListOfSampleGroups){
                rowMaps << ["dataset":"${sampleGroup.systemId}","technology":"${metaDataService.getTechnologyPerSampleGroup(sampleGroup.systemId)}"]
            }

        } else {
            for (String oneName in rowNames){
                rowMaps << ["dataset":oneName,"technology":"${metaDataService.getTechnologyPerSampleGroup(oneName)}"]
            }
        }
        List <LinkedHashMap<String,String>> uniqueRowMaps = rowMaps.unique{ LinkedHashMap a,LinkedHashMap b -> a.dataset <=> b.dataset }

        List<Float> significanceValues = []
        for(String significance in colSignificances){
            try {
                significanceValues << Float.parseFloat(significance)
            } catch (ex) {
                log.error("nonnumeric significance value (${significance}) in genepValueCounts action in GeneController")
            }
        }
        significanceValues = significanceValues.sort()

        List <LinkedHashMap<String,String>> numericBounds = []
        numericBounds << ["lowerValue":0.0f,"higherValue":1.0f]
        numericBounds << ["lowerValue":0.0f,"higherValue":1.0f]
        numericBounds << ["lowerValue":0.05f,"higherValue":1.0f]
        numericBounds << ["lowerValue":0.0005f,"higherValue":0.05f]
        numericBounds << ["lowerValue":0.0f,"higherValue":0.0005f]


        JSONObject jsonObject =  restServerService.combinedEthnicityTable ( geneToStartWith.trim().toUpperCase(), uniqueRowMaps, numericBounds)
        render(status:200, contentType:"application/json") {
            [ethnicityInfo:jsonObject]
        }
    }


    /***
     * Returns the information necessary to fill the Biological Hypothesis Testing section of the
     * gene info page. NOTE: this is the only place in the entire application where we need to call
     * gene-info, which is otherwise a vestigial call from the old API.  We should probably find a way
     * to merge this call into the new API, or else embrace gene-info altogether, and be willing to use it
     * in other places as well.
     *
     * @return
     */
    def geneInfoAjax() {
        String geneToStartWith = params.geneName
        UserQueryContext userQueryContext = widgetService.generateUserQueryContext(geneToStartWith)

        if (geneToStartWith)      {
            JSONObject jsonObject =  restServerService.retrieveGeneInfoByName (geneToStartWith.trim().toUpperCase())
            if (jsonObject["is_error"]){
                JSONObject userQueryContextAsJsonObject = userQueryContext.toJSONObject()
                Map variantPieces = sharedToolsService.getVariantExtent(geneToStartWith)
                jsonObject = new JSONObject()
                jsonObject["id"] = geneToStartWith
                jsonObject["CHROM"] = variantPieces.chrom
                jsonObject["BEG"] = variantPieces.startExtent
                jsonObject["END"] = variantPieces.endExtent
                render(status:200, contentType:"application/json") {
                    [geneInfo:jsonObject,
                     userQueryContext:userQueryContextAsJsonObject]
                }
                return
            } else {
                JSONObject userQueryContextAsJsonObject = userQueryContext.toJSONObject()
                render(status:200, contentType:"application/json") {
                    [geneInfo:jsonObject['gene-info'],
                     userQueryContext:userQueryContextAsJsonObject]
                }
                return
            }


        }
    }


    def vectorDataAjax() {
        String geneToStartWith = params.geneName
        if (geneToStartWith)      {
            JSONObject jsonObject =  restServerService.retrieveGeneInfoByName (geneToStartWith.trim().toUpperCase())
            render(status:200, contentType:"application/json") {
                [geneInfo:jsonObject['gene-info']]
            }

        }
    }

    /***
     * This call supports the burden test on the gene info page
     * @return
     */
    def burdenTestAjax() {
        // log parameters received
        // Here are some example parameters, as they show up in the params variable
        // params.filterNum=="2" // value=id from burdenTestVariantSelectionOptionsAjax, or 0 if no selection was made (which is a legal choice)
        // params.mafOption=="1" // where 1->apply maf across all samples, 2->apply maf to each ancestry"
        // params.mafValue=="0.47" // where value= real number x (where 0 <= x <= 1), and x is the MAF you'll pass into the REST call"
        // params.geneName=="SLC30A8" // string representing gene name
        log.info("got parameters: " + params);
        String portalType = g.portalTypeString() as String

        // cast the parameters
        Boolean explicitlySelectSamples = false
        String geneName = params.geneName
        String dataSet = params.dataSet
        String sampleDataSet = params.sampleDataSet
        int variantFilterOptionId = (params.filterNum ? Integer.valueOf(params.filterNum) : 0);     // default to all variants if none given
        String burdenTraitFilterSelectedOption = (params.burdenTraitFilterSelectedOption ? params.burdenTraitFilterSelectedOption : PortalConstants.BURDEN_DEFAULT_PHENOTYPE_KEY);               // default ot t2d if none given
        int mafOption = (params.mafOption ? Integer.valueOf(params.mafOption) : 1);                 // 1 is default, 2 is different ancestries if specified
        Float mafValue = ((params.mafValue && !params.mafValue?.equals("NaN")) ? new Float(params.mafValue) : null);                      // null float if none specified

        // TODO - eventually create new bean to hold all the options and have smarts for double checking validity
        JSONObject result = this.burdenService.callBurdenTest(burdenTraitFilterSelectedOption, geneName, variantFilterOptionId, mafOption, mafValue,
                dataSet, sampleDataSet, explicitlySelectSamples,portalType);

        // send json response back
        render(status: 200, contentType: "application/json") {result}
    }



    def generateListOfVariantsFromFiltersAjax() {
        // log parameters received
        // Here are some example parameters, as they show up in the params variable
        // params.filterNum=="2" // value=id from burdenTestVariantSelectionOptionsAjax, or 0 if no selection was made (which is a legal choice)
        // params.mafOption=="1" // where 1->apply maf across all samples, 2->apply maf to each ancestry"
        // params.mafValue=="0.47" // where value= real number x (where 0 <= x <= 1), and x is the MAF you'll pass into the REST call"
        // params.geneName=="SLC30A8" // string representing gene name

        Boolean explicitlySelectSamples = false
        String geneName = params.geneName
        String dataSet = params.dataSet
        int variantFilterOptionId = (params.filterNum ? Integer.valueOf(params.filterNum) : 0);     // default to all variants if none given
        String burdenTraitFilterSelectedOption = (params.burdenTraitFilterSelectedOption ? params.burdenTraitFilterSelectedOption : PortalConstants.BURDEN_DEFAULT_PHENOTYPE_KEY);               // default ot t2d if none given
        int mafOption = (params.mafOption ? Integer.valueOf(params.mafOption) : 1);                 // 1 is default, 2 is different ancestries if specified
        Float mafValue = ((params.mafValue && !params.mafValue?.equals("NaN")) ? new Float(params.mafValue) : null);                      // null float if none specified

        // TODO - eventually create new bean to hold all the options and have smarts for double checking validity
        String codedVariantList = this.burdenService.generateListOfVariantsFromFilters(burdenTraitFilterSelectedOption, geneName, variantFilterOptionId, mafOption, mafValue, dataSet, explicitlySelectSamples);

        if (codedVariantList == null) {
            render(status: 200, contentType: "application/json"){variantInfo:{results:[]}}
            return
        }

        JsonSlurper slurper = new JsonSlurper()
        JSONObject sampleCallSpecifics = slurper.parseText(codedVariantList)

        if (sampleCallSpecifics.results) {
            for (Map result in sampleCallSpecifics.results){
                for (Map pval in result.pVals){
                    if ((pval.level == "Consequence")||
                            (pval.level == "SIFT_PRED")||
                            (pval.level == "PolyPhen_PRED")){
                        List<String> consequenceList = pval.count.tokenize(",")
                        List<String> translatedConsequenceList = []
                        for (String consequence in consequenceList){
                            translatedConsequenceList << g.message(code: "metadata." + consequence, default: consequence)
                        }
                        pval.count = translatedConsequenceList.join(", ")
                    }
                }
            }
        }

        // send json response back
        render(status: 200, contentType: "application/json") {variantInfo:sampleCallSpecifics}
    }







    /***
     * Get the contents for the filter drop-down box on the burden test section of the gene info page
     * @return
     */
    def burdenTestVariantSelectionOptionsAjax() {
        JSONObject jsonObject = this.burdenService.getBurdenVariantSelectionOptions()

        // send json response back
        render(status: 200, contentType: "application/json") {jsonObject}
    }

    /**
     * method to serve LZ requests in the format needed
     *
     * @return
     */
    def getLocusZoom() {
        String jsonReturn;
        String chromosome = params.chromosome; // ex "22"
        String startString = params.start; // ex "29737203"
        String endString = params.end; // ex "29937203"
        String phenotype = params.phenotype;
        String dataSet = params.dataset
        String dataType = params.datatype
        String propertyName = params.propertyName
        String maximumNumberOfResults = params.maximumNumberOfResults

        int requestedResults = -1
        int startInteger;
        int endInteger;
        String errorJson = "{\"data\": {}, \"error\": true}";

        // get the covariate variants
        List<String> conditionVariants
        if (params.conditionVariantId) {
            conditionVariants = params.list("conditionVariantId")
            log.info("got covariates: " + conditionVariants)
        }

        // log
        log.info("got LZ request with params: " + params);

        // log start
        Date startTime = new Date();

        if (maximumNumberOfResults){
            try {
                requestedResults =  Integer.parseInt(maximumNumberOfResults);
            } catch (e){
                // an error here is no crisis – we can go with our internally specified default number
            }
        }

        // if have all the information, call the widget service
        try {
            startInteger = Integer.parseInt(startString);
            endInteger = Integer.parseInt(endString);

            if (chromosome != null) {

                if (dataType=='static'){ // dynamically get the property name for static datasets
                    Property property = metaDataService.getPropertyForPhenotypeAndSampleGroupAndMeaning(phenotype,dataSet,
                                        propertyName,MetaDataService.METADATA_VARIANT )
                    propertyName = property.name
                }
                println("making LZ on dataset = ${dataSet} and pheno=${phenotype}")
                jsonReturn = widgetService.getVariantJsonForLocusZoomString(chromosome, startInteger, endInteger, dataSet, phenotype,propertyName, dataType, conditionVariants, requestedResults);
            } else {
                jsonReturn = errorJson;
            }

            // log
            log.info("got LZ result: " + jsonReturn);

            // log end
            Date endTime = new Date();
            log.info("LZ call returned in: " + (endTime?.getTime() - startTime?.getTime()) + " milliseconds");

        } catch (NumberFormatException exception) {
            log.error("got incorrect parameters for LZ call: " + params);
            jsonReturn = errorJson;
        }

        // return
        println("HHHHHHHHHHHHHHHHHHHHHHH: ${jsonReturn.toString()}")
        render(jsonReturn)
    }

    /**
     * method to serve LZ requests of filled line plot in the format needed
     *
     * @return
     */
    def getLocusZoomFilledPlot() {
        String jsonReturn;
        String chromosome = params.chromosome; // ex "22"
        String startString = params.start; // ex "29737203"
        String endString = params.end; // ex "29937203"
        String assay_id = params.assay_id
        String tissue_id = params.source
        String permissions = params.permissions;

        int startInteger;
        int endInteger;
        String errorJson = "{\"data\": {}, \"error\": true}";
        JsonSlurper slurper = new JsonSlurper()
        JSONObject errorJsonObject = slurper.parseText(errorJson)
        List<LinkedHashMap<String,String>> bigwigResources = epigenomeService.getTheRemoteBigwigInformation("{\"version\":\"${ sharedToolsService.getCurrentDataVersion ()}\"}")
        //List<String> possibleBigwigAddresses =  epigenomeService.getThePossibleBigwigAddresses("{\"version\":\"${ sharedToolsService.getCurrentDataVersion ()}\"}")
        if (tissue_id.split(" ").size()>1){
            tissue_id = tissue_id.split(" ")[0]
        }
       // List<String> filteredBigWigUrl = possibleBigwigAddresses.findAll{String t->t.contains(tissue_id)}
        Map oneResource = bigwigResources.find{LinkedHashMap t->t.assayid==assay_id&&t.eid==tissue_id}
        String chosenBigWigUrl
        if (oneResource){
            chosenBigWigUrl = oneResource.bigwigpath
        }
        if (chosenBigWigUrl.startsWith('s3')){  // hack to circumvent bad values in getEpigenomicData.  Fix the darn values, so that everything starts with HTTP and then remove the kludge
            chosenBigWigUrl = "https://"+chosenBigWigUrl
            permissions = "private"
        }
        List<String> filteredBigWigUrl = null //youpossibleBigwigAddresses.findAll{String t->t.toUpperCase().contains(tissue_id.toString().toUpperCase())}

        // log
        log.info("got LZ request with params: for filled line plot " + params);

        // log start
        Date startTime = new Date();

        // if have all the information, call the widget service
        JSONObject resultLZJson
        try {
            startInteger = Integer.parseInt(startString);
            endInteger = Integer.parseInt(endString);
            String callingJson = """{"chr":"chr${chromosome}",
                                     "start":${startString},
                                     "end":${endString},
                                     "bigwigUrl":"${chosenBigWigUrl}",
                                      "permissions":"${permissions}"}""".toString()

            if (chromosome != null) {
                resultLZJson= epigenomeService.getBigWigDataRestCall(callingJson)

            } else {
                resultLZJson = errorJsonObject;
            }

            // log
            log.info("got LZ result: " + jsonReturn);

            // log endin
            Date endTime = new Date();
            log.info("LZ call returned in: " + (endTime?.getTime() - startTime?.getTime()) + " milliseconds");

        } catch (NumberFormatException exception) {
            log.error("got incorrect parameters for LZ call: " + params);
            resultLZJson = errorJsonObject;
        }


        // In V0.7.0 we have to remove the pastback field, which was never used anyway
        resultLZJson.remove("passback")
        render(status: 200, contentType: "application/json") {resultLZJson}
        return;
    }


    def list(Integer max) {
        params.max = Math.min(max ?: 50, 1000)
        List geneResults = []
        def taskList = Gene.createCriteria().list (params) {
            if ( params.query ) {
                ilike("name1", "%${params.query}%")
                geneResults = Gene.findAllByName1Ilike("%${params.query}%").sort{it.name1}
            } else {
                geneResults = Gene.list(params+[sort:'name1'])
            }
        }
        respond geneResults, model:[geneInstanceCount: Gene.count()]
        // respond Gene.list(params+[sort:'name1']), model:[geneInstanceCount: Gene.count()]
    }

    def show(Gene geneInstance) {
        respond geneInstance
    }

    def create() {
        respond new Gene(params)
    }

    def search() {
        params.max = (params.max && params.max.toInteger() > 0) ? Math.min(params.max.toInteger(), 50) : 20
        params.order = params.order ? params.order : (params.sort ? 'desc' : 'asc')
        params.sort = params.sort ?: "name1"
        render (view: 'list', model:Gene.list(params) )
    }

    @Transactional
    def save(Gene geneInstance) {
        if (geneInstance == null) {
            notFound()
            return
        }

        if (geneInstance.hasErrors()) {
            respond geneInstance.errors, view:'create'
            return
        }

        geneInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'gene.label', default: 'Gene'), geneInstance.id])
                redirect geneInstance
            }
            '*' { respond geneInstance, [status: CREATED] }
        }
    }

    def edit(Gene geneInstance) {
        respond geneInstance
    }

    @Transactional
    def update(Gene geneInstance) {
        if (geneInstance == null) {
            notFound()
            return
        }

        if (geneInstance.hasErrors()) {
            respond geneInstance.errors, view:'edit'
            return
        }

        geneInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Gene.label', default: 'Gene'), geneInstance.id])
                redirect geneInstance
            }
            '*'{ respond geneInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(Gene geneInstance) {

        if (geneInstance == null) {
            notFound()
            return
        }

        geneInstance.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Gene.label', default: 'Gene'), geneInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'gene.label', default: 'Gene'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
