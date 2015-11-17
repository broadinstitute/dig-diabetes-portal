package org.broadinstitute.mpg

import org.apache.juli.logging.LogFactory
import org.broadinstitute.mpg.diabetes.BurdenService
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
import org.codehaus.groovy.grails.web.json.JSONObject

class GeneController {

    RestServerService restServerService
    GeneManagementService geneManagementService
    SharedToolsService sharedToolsService
    MetaDataService metaDataService
    private static final log = LogFactory.getLog(this)
    SqlService sqlService
    BurdenService burdenService

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
     * display all information about a gene. This call displays only the core of the page -- the data all come back
     * with the Jace on
     * @return
     */
    def geneInfo() {
        String geneToStartWith = params.id
        LinkedHashMap savedCols = params.findAll{ it.key =~ /^savedCol/ }
        LinkedHashMap savedRows = params.findAll{ it.key =~ /^savedRow/ }
        String newVandAColumnName = "custom significance"
        String newVandAColumnPValue
        String newDatasetName
        String newDatasetRowName = ""
        String phenotype = "T2D"

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
        if (params.newRowName) {
            newDatasetRowName =  params.newRowName
        }
        String phenotypeList = this.metaDataService?.urlEncodedListOfPhenotypes();
        String regionSpecification = null

        // added test for unit test error
        if (geneToStartWith != null) {
            regionSpecification = this.geneManagementService?.getRegionSpecificationForGene(geneToStartWith, 100000)
        }
        List<SampleGroup> sampleGroupList = metaDataService?.getSampleGroupList()
        List <LinkedHashMap<String,String>> allAvailableRows = []
        for(SampleGroup sampleGroup in sampleGroupList){
            allAvailableRows << [name:sampleGroup.name, value:sampleGroup.systemId, count:'4747']
        }
        List <LinkedHashMap<String,String>> rowInformation = []
        if ((savedRows.size()>0)||
                (newDatasetName)){ // no saved rows -- provide some defaults
            savedRows.each{String key, String value->
                List <String> listOfProperties = value.tokenize("^")
                if (listOfProperties.size()>2) {
                    rowInformation << [name:listOfProperties[0], value:listOfProperties[1], count:listOfProperties[2], pvalue:listOfProperties[3]]
                }
            }
            if (newDatasetName){
                // break apart data set name and P value name
                List <String> nameAndAssociatedPValue = newDatasetName.tokenize("^")
                if (nameAndAssociatedPValue.size()==2) {
                    if (!(newDatasetRowName)) {
                        newDatasetRowName =  nameAndAssociatedPValue[0]
                    }
                    rowInformation << [name:newDatasetRowName, value:nameAndAssociatedPValue[0],count:'5656', pvalue: nameAndAssociatedPValue[1] ]
                }


            }
        } else {
            rowInformation << [name:'GWAS', value:RestServerService.TECHNOLOGY_GWAS,  pvalue: RestServerService.GWASDATAPVALUE, count:'69,033']
            rowInformation << [name:'exome chip', value:RestServerService.TECHNOLOGY_EXOME_CHIP,  pvalue: RestServerService.EXOMECHIPPVALUE, count:'79,854']
            rowInformation << [name:'exome sequence', value:RestServerService.TECHNOLOGY_EXOME_SEQ,  pvalue: RestServerService.EXOMESEQUENCEPVALUE, count:'16,760']
// example of additional row
//        rowInformation << [name:'AA exome seq', value:"ExSeq_17k_aa_mdv2", count:'4777']
        }

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
            columnInformation << [name:'genome-wide', value:'0.00000005', count:'0']
//        columnInformation << [name:'exome wide <br>significance', value:'0.000009', count:'0']  // example of additional column
            columnInformation << [name:'locus-wide', value:'0.00005', count:'0']
            columnInformation << [name:'nominal', value:'0.05', count:'0']
        }
        if (newVandAColumnPValue){
            columnInformation << [name:"${newVandAColumnName}", value:"${newVandAColumnPValue}", count:'0']
        }

        if (geneToStartWith)  {
            String  geneUpperCase =   geneToStartWith.toUpperCase()
            LinkedHashMap geneExtent = sharedToolsService.getGeneExpandedExtent(geneToStartWith)
            render (view: 'geneInfo', model:[show_gwas:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_gwas),
                                             show_exchp:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exchp),
                                             show_exseq:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exseq),
                                             phenotypeList: phenotypeList,
                                             regionSpecification: regionSpecification,
                                             geneName:geneUpperCase,
                                             geneExtentBegin:geneExtent.startExtent,
                                             geneExtentEnd:geneExtent.endExtent,
                                             geneChromosome:geneExtent.chrom,
                                             rowInformation:rowInformation,
                                             columnInformation:columnInformation,
                                             allAvailableRows:allAvailableRows,
                                             phenotype:phenotype
            ] )
        }
     }

    /***
     * we've been asked to search, but we don't know what kind of string. Figure it out, and then
     * go to the right page.  gene info? Variant info? or punt, and re-display the main home page
     */
    def findTheRightDataPage () {
        String uncharacterizedString = params.id
        // Is our string a region?
        LinkedHashMap extractedNumbers =  restServerService.extractNumbersWeNeed(uncharacterizedString)
        if ((extractedNumbers)   &&
                (extractedNumbers["startExtent"])   &&
                (extractedNumbers["endExtent"])&&
                (extractedNumbers["chromosomeNumber"]) ){
            redirect(controller:'region',action:'regionInfo', params: [id: params.id])
            return
        }
        // It's not a region.  Is our string a gene?
        String possibleGene = params.id
        if (possibleGene){
            possibleGene = possibleGene.trim().toUpperCase()
        }
        Gene gene = Gene.retrieveGene(possibleGene)
        if (gene){
            redirect(controller:'gene',action:'geneInfo', params: [id: params.id])
            return
        }

        // KDUXTD-99: check to see if dbSnpId provided so that it gets past search box filter
        if (sharedToolsService.getRecognizedStringsOnly()!=0) {
            // once we have the variant database complete we can use this
            String inputString = params.id
            if (sqlService?.isDbSnpIdString(inputString)) {
                // search for the variant by dbSnpId and if found, return; if not found, drop down to below test (just in case for now)
                Variant variant = Variant.findByDbSnpId(inputString)
                if (variant) {
                    redirect(controller: 'variantInfo', action: 'variantInfo', params: [id: params.id])
                    return
                }
            }
        }

        // Is our string a variant?  Build an identifying string and test
        String canonicalVariant = sharedToolsService.createCanonicalVariantName(params.id)
        if (sharedToolsService.getRecognizedStringsOnly()!=0){ // once we have the variant database complete we can use this
            Variant variant = Variant.retrieveVariant(canonicalVariant)
            if (variant) {
                redirect(controller: 'variantInfo', action: 'variantInfo', params: [id: params.id])
                return
            } else {
                redirect(controller: 'home', action: 'portalHome', params: [id: params.id])
                return
            }
        } else {// for now we don't have to verify of variant's existence
            redirect(controller: 'variantInfo', action: 'variantInfo', params: [id: canonicalVariant])
            return
        }
        // this is an error condition -- we should never get here in the code
        log.error("why did we never finish parsing '${uncharacterizedString}'?")
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
        def rawRowNames = params."rowNames[]"
        def colSignificances = params."colNames[]"


        List<String> rowNames = []
        if ((rawRowNames)&&
                (rawRowNames.size()>0)){
            if (rawRowNames.getClass().simpleName=="String"){ // single value
                String rowName = rawRowNames
                rowNames << rowName
             } else { // we must have a list of values
                List<String> rowNameList = rawRowNames as List
                for (String oneRowName in rowNameList) {
                    rowNames << oneRowName as String
                }
            }
        }

        List<Float> significanceValues = []
        if ((colSignificances)&&
                (colSignificances.size()>0)){
            if (colSignificances.getClass().simpleName=="String"){ // single value
                String colSignificance = colSignificances
                try {
                    significanceValues << Float.parseFloat(colSignificance)
                } catch (ex) {
                    log.error("nonnumeric significance value (${colSignificance}) in genepValueCounts action in GeneController")
                }
            } else { // we must have a list of values
                List<String> colSignificanceList = colSignificances as List
                for (String oneSignificance in colSignificanceList) {
                    try {
                        significanceValues << Float.parseFloat(oneSignificance)
                    } catch (ex) {
                        log.error("nonnumeric significance value (${oneSignificance}) in genepValueCounts action in GeneController")
                    }
                }
            }
         }
         JSONObject jsonObject =  restServerService.combinedVariantCountByGeneNameAndPValue ( geneToStartWith.trim().toUpperCase(),
                                                                                             rowNames, significanceValues, phenotype )
        render(status:200, contentType:"application/json") {
            [geneInfo:jsonObject]
        }
    }


    /***
     * get the information needed for the Variants across Continental Ancestry table on the gene info page
     * @return
     */
    def geneEthnicityCounts (){
        String geneToStartWith = params.geneName
        JSONObject jsonObject =  restServerService.combinedEthnicityTable ( geneToStartWith.trim().toUpperCase())
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
        // params.dataSet=="1" // where 1->13k, 2->26k"
        // params.mafOption=="1" // where 1->apply maf across all samples, 2->apply maf to each ancestry"
        // params.mafValue=="0.47" // where value= real number x (where 0 <= x <= 1), and x is the MAF you'll pass into the REST call"
        // params.geneName=="SLC30A8" // string representing gene name
        log.info("got parameters: " + params);

        // cast the parameters
        String geneName = params.geneName;
        int variantFilterOptionId = (params.filterNum ? Integer.valueOf(params.filterNum) : 0);     // default to all variants if none given
        int datasetOptionId = (params.dataSet ? Integer.valueOf(params.dataSet) : 1);               // default ot 1 if none given
        int mafOption = (params.mafOption ? Integer.valueOf(params.mafOption) : 1);                 // 1 is default, 2 is different ancestries if specified
        Float mafValue = ((params.mafValue && !params.mafValue?.equals("NaN")) ? new Float(params.mafValue) : null);                      // null float if none specified

        // TODO - eventually create new bean to hold all the options and have smarts for double checking validity
        JSONObject result = this.burdenService.callBurdenTest(datasetOptionId, geneName, variantFilterOptionId, mafOption, mafValue);

        // send json response back
        render(status: 200, contentType: "application/json") {result}
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

}
