package org.broadinstitute.mpg

import grails.plugin.mail.MailService
import grails.transaction.Transactional
import groovy.json.StringEscapeUtils
import org.apache.juli.logging.LogFactory
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.SampleGroup
import org.broadinstitute.mpg.diabetes.metadata.SampleGroupBean
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQuery
import org.broadinstitute.mpg.diabetes.metadata.query.JsNamingQueryTranslator
import org.broadinstitute.mpg.diabetes.metadata.query.QueryFilter
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.broadinstitute.mpg.people.Role
import org.broadinstitute.mpg.people.User
import org.broadinstitute.mpg.people.UserRole
import org.broadinstitute.mpg.people.UserSession
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.web.json.JSONObject
import org.codehaus.groovy.grails.web.mapping.LinkGenerator

@Transactional
class SharedToolsService {

    MailService mailService
    GrailsApplication grailsApplication
    LinkGenerator grailsLinkGenerator
    RestServerService restServerService
    MetaDataService metaDataService
    FilterManagementService filterManagementService
    private static final log = LogFactory.getLog(this)
    JSONObject sharedMetadata = null
    LinkedHashMap sharedProcessedMetadata = null
    Integer forceProcessedMetadataOverride = -1
    Integer forceMetadataOverride = -1
    Integer showGwas = -1
    Integer showExomeChip = -1
    Integer showExomeSequence = -1
    Integer showGene = -1
    Integer showBeacon = -1
    Integer showNewApi = 1
    Integer dataVersion = 2
    String warningText = ""
    String dataSetPrefix = "mdv"
    LinkedHashMap trans = [:]
    String currentGeneChromosome = "1"
    String currentVariantChromosome = "1"
    Integer recognizedStringsOnly = 0
    Integer cachedVariantNumber;
    Integer cachedGeneNumber;
    // TODO remove hack: currently we get phenotypes from the old geneinfo call, but
    // we need to interpret them with the new API, which uses different strings in some cases.
    //  Eventually we will pull the strings from the new API and then throw away this conversion utility
    LinkedHashMap convertPhenotypes = ["T2D"          : "T2D",
                                       "FastGlu"      : "FG",
                                       "FastIns"      : "FI",
                                       "ProIns"       : "PI",
                                       "2hrGLU_BMIAdj": "2hrG",
                                       "2hrIns_BMIAdj": "2hrI",
                                       "HOMAIR"       : "HOMAIR",
                                       "HOMAB"        : "HOMAB",
                                       "HbA1c"        : "HBA1C",
                                       "BMI"          : "BMI",
                                       "WHR"          : "WHR",
                                       "Height"       : "HEIGHT",
                                       "TC"           : "CHOL",
                                       "HDL"          : "HDL",
                                       "LDL"          : "LDL",
                                       "TG"           : "TG",
                                       "CAD"          : "CAD",
                                       "CKD"          : "CKD",
                                       "eGFRcrea"     : "eGFRcrea",
                                       "eGFRcys"      : "eGFRcys",
                                       "UACR"         : "UACR",
                                       "MA"           : "MA",
                                       "BIP"          : "BIP",
                                       "SCZ"          : "SCZ",
                                       "STRK"         : "STRK",
                                       "MDD"          : "MDD"]

    LinkedHashMap convertPhenotypesFlipped = null;

    Integer helpTextSetting = 1 // 0== never display, 1== display conditionally, 2== always display

    public String retrieveCurrentGeneChromosome() {
        return currentGeneChromosome
    }

    public String retrieveCurrentVariantChromosome() {
        return currentVariantChromosome
    }

    public String getCurrentDataVersion() {
        // DIGP-291: switch to metedataservice metadata call
        String centralMetadataVersion = this.metaDataService.getDataVersion();
        String compareDataVersion = "${dataSetPrefix}${getDataVersion()}";
        log.info("using metadata: " + centralMetadataVersion + " as opposed to previous: " + compareDataVersion);

        return centralMetadataVersion;
    }

    public Integer getRecognizedStringsOnly() {
        return recognizedStringsOnly
    }

    public void setRecognizedStringsOnly(Integer recognizedStringsOnly) {
        this.recognizedStringsOnly = recognizedStringsOnly
    }

    /**
     * retrieve cached number of variants in the portal DB; pass in true for the cached number to be refreshed
     *
     * @param forceReload whether to refresh the number
     * @return the total number of cached variants in the portal DB
     */
    public Integer getCachedVariantNumber(Boolean forceReload) {
        if ((this.cachedVariantNumber == null) || forceReload) {
            this.cachedVariantNumber = Variant.totalNumberOfVariants();
        }
        return this.cachedVariantNumber;
    }

    /**
     * retrieve cached number of genes in the portal DB; pass in true for the cached number to be refreshed
     *
     * @param forceReload whether to refresh the number
     * @return the total number of cached genes in the portal DB
     */
    public Integer getCachedGeneNumber(Boolean forceReload) {
        if ((this.cachedGeneNumber == null) || forceReload) {
            this.cachedGeneNumber = Gene.totalNumberOfGenes();
        }
        return this.cachedGeneNumber;
    }

    private String determineNextChromosome(String currentChromosome) {
        String returnValue
        if (currentChromosome == 'X') {
            returnValue = 'Y'
        } else if (currentChromosome == 'Y') {
            returnValue = ''
        } else {
            int chromosomeNumber = currentChromosome as int
            if (chromosomeNumber == 23) {
                returnValue = 'X'
            } else {
                returnValue = (++chromosomeNumber)
            }
        }
        return returnValue
    }

    public void incrementCurrentGeneChromosome() {
        currentGeneChromosome = determineNextChromosome(retrieveCurrentGeneChromosome())
    }

    public void incrementCurrentVariantChromosome() {
        currentVariantChromosome = determineNextChromosome(retrieveCurrentVariantChromosome())
    }


    public void setHelpTextSetting(int newHelpTextSetting) {
        if ((newHelpTextSetting > -1) && (newHelpTextSetting < 3)) {
            helpTextSetting = newHelpTextSetting
        } else {
            log.error("Attempt to set help text to ${newHelpTextSetting}.  Should be 0, 1, or 2.")
        }
    }


    public Integer getDataVersion() {
        return dataVersion
    }

    public void setDataVersion(String dataVersionString) {
        int dataVersion = dataVersionString as int
        this.dataVersion = dataVersion
    }


    public int getHelpTextSetting() {
        return helpTextSetting
    }

    public String getWarningText() {
        return warningText
    }

    public void setWarningText(String warningText) {
        this.warningText = warningText
    }


    public void initialize() {
        showGwas = (grailsApplication.config.portal.sections.show_gwas) ? 1 : 0
        showExomeChip = (grailsApplication.config.portal.sections.show_exchp) ? 1 : 0
        showExomeSequence = (grailsApplication.config.portal.sections.show_exseq) ? 1 : 0
        showGene = (grailsApplication.config.portal.sections.show_gene) ? 1 : 0
        showBeacon = (grailsApplication.config.portal.sections.show_beacon) ? 1 : 0
        showNewApi = 1
    }

    public enum TypeOfSection {
        show_gwas, show_exchp, show_exseq, show_gene, show_beacon
    }


    public Boolean getSectionToDisplay(typeOfSection) {
        showGwas = (showGwas == -1) ? grailsApplication.config.portal.sections.show_gwas : showGwas
        showExomeChip = (showExomeChip == -1) ? grailsApplication.config.portal.sections.show_exchp : showExomeChip
        showExomeSequence = (showExomeSequence == -1) ? grailsApplication.config.portal.sections.show_exseq : showExomeSequence
        showGene = (showGene == -1) ? grailsApplication.config.portal.sections.show_gene : showGene
        showBeacon = (showBeacon == -1) ? grailsApplication.config.portal.sections.show_beacon : showBeacon
        Boolean returnValue = false
        switch (typeOfSection) {
            case TypeOfSection.show_gwas:
                returnValue = showGwas
                break;
            case TypeOfSection.show_exchp:
                returnValue = showExomeChip
                break;
            case TypeOfSection.show_exseq:
                returnValue = showExomeSequence
                break;
            case TypeOfSection.show_gene:
                returnValue = showGene
                break;
            case TypeOfSection.show_beacon:
                returnValue = showBeacon
                break;
            default: break;
        }
        return returnValue
    }


    public Boolean setApplicationToT2dgenes() {
        showGwas = 1
        showExomeChip = 1
        showExomeSequence = 1
        showBeacon = 0
    }


    public Boolean getApplicationIsT2dgenes() {
        return ((!showBeacon) &&
                (showGwas || showExomeChip || showExomeSequence))
    }


    public Boolean setApplicationToBeacon() {
        showGwas = 0
        showExomeChip = 0
        showExomeSequence = 0
        showBeacon = 1
    }

    public Boolean getApplicationIsBeacon() {
        return showBeacon
    }


    public String applicationName() {
        String returnValue = ""
        if (getApplicationIsT2dgenes()) {
            returnValue = "t2dGenes"
        } else if (getApplicationIsBeacon()) {
            returnValue = "Beacon"
        } else {
            returnValue = "Undetermined application: internal error"
        }
        return returnValue
    }

    /***
     * This is a hack that we have to use because we still do a few things with the old API calls.
     * @param oldKey
     * @return
     */
    public String convertOldPhenotypeStringsToNewOnes(String oldKey) {
        String returnValue = ""
        if ((oldKey) && (oldKey.length() > 0)) {
            if (convertPhenotypes.containsKey(oldKey)) {
                returnValue = convertPhenotypes[oldKey]
            } else {
                // this should presumably never happen, but in case it does will guess that the string hasn't changed
                returnValue = oldKey
            }
        }
        return returnValue
    }

    /**
     * hack to fix trait id mismatch between old trait-search call and new getData and getMetadata trait ids
     *
     * @param newKey
     * @return
     */
    public String convertNewPhenotypeStringsToOldOnes(String newKey) {
        if (this.convertPhenotypesFlipped == null) {
            this.convertPhenotypesFlipped = [];
            for (String key in this.convertPhenotypes.keySet()) {
                if (!this.convertPhenotypes.get(key).equals(key)) {
                    this.convertPhenotypesFlipped.put(this.convertPhenotypes.get(key), key);
                }
            }
        }

        if (this.convertPhenotypesFlipped.get(newKey)) {
            return this.convertPhenotypesFlipped.get(newKey)
        } else {
            return newKey
        }
    }

    /***
     * take whatever weird string the user comes up with and try to turn it into a variant name that we recognize
     * @param rawString
     * @return
     */
    public String createCanonicalVariantName(String rawString) {
        String canonicalForm = rawString
        if (rawString) {
            String chromosome
            String position
            String reference
            String alternate
            if (rawString.indexOf(':')) {
                List<String> dividedByColons = rawString.tokenize(":")
                if (dividedByColons.size() > 1) {
                    chromosome = dividedByColons[0]
                    position = dividedByColons[1]
                    canonicalForm = "${chromosome}_${position}"
                }
                if (dividedByColons.size() > 2) {
                    reference = dividedByColons[2]
                    canonicalForm += "_${reference}"
                }
                if (dividedByColons.size() > 3) {
                    alternate = dividedByColons[3]
                    canonicalForm += "_${alternate}"
                }
            }
            canonicalForm = rawString.replaceAll('-', '_')
        }
        return canonicalForm
    }

    /***
     * One peculiarity of values returned from an HTML page is as follows: multiple values can be retrieved
     * by appending a "[]" string after your parameter name, and in this case the value is immediately convertible
     * to a list.  That's nice.  But what if the user chooses only a single value?  In that case the value comes back
     * not as a List but as a String, which is liable to lead to conversion errors if the code is expecting a list.
     * So here is a little convenience routine which can always return a list (a single value returns a list of length = 1).
     *
     * Note the undefined type of the incoming parameter == "rawValue"
     *
     * @param rawValue
     * @return
     */
    public List<String> convertAnHttpList(def rawValue) {
        List<String> collatedValues = []
        if ((rawValue) &&
                (rawValue.size() > 0)) {
            if (rawValue.getClass().simpleName == "String") { // single value
                String rowName = rawValue
                collatedValues << rowName
            } else { // we must have a list of values
                List<String> rowNameList = rawValue as List
                for (String oneRowName in rowNameList) {
                    collatedValues << oneRowName as String
                }
            }
        }
        return collatedValues
    }

    /***
     * Control the order in which the columns appear on the screen after a sort.  Here we take the tree
     * containing the meta information describing the columns and sort it using the data structures
     * we have already extracted from the metadata.
     *
     * @param processedMetadata
     * @param unsortedTree
     * @return
     */
    private LinkedHashMap sortEverything(LinkedHashMap unsortedTree) {

        // sort common
        if ((unsortedTree?.cproperty) && (unsortedTree?.cproperty?.size() > 0)) {
            LinkedHashMap temporaryHolder = [:]
            List<Property> commonProperties = metaDataService.getCommonProperties()
            for (String property in unsortedTree.cproperty) {
                if (commonProperties.collect { return it.name }?.contains(property)) {
                    temporaryHolder[property] = commonProperties.find { it.name == property }.sortOrder
                }
            }
            unsortedTree.cproperty = ["VAR_ID"] + temporaryHolder.sort { it.value }.keySet()
        }

        // sort dproperty
        if ((unsortedTree?.dproperty) && (unsortedTree?.dproperty?.size() > 0)) {
            for (String phenotype in unsortedTree.dproperty.keySet()) {
                for (String sampleGroup in unsortedTree.dproperty[phenotype].keySet()) {
                    List<String> properties = unsortedTree.dproperty[phenotype][sampleGroup]
                    List<String> props = metaDataService.getPhenotypeSpecificSampleGroupPropertyList(sampleGroup, phenotype)
                    List<String> props2 = props.findAll { properties.contains(it) }
                    if ((props2) && (props2.size() > 0)) {
                        unsortedTree.dproperty[phenotype][sampleGroup] = props2
                    }
                }

            }

        }

        // sort pproperty
        if ((unsortedTree?.pproperty) && (unsortedTree?.pproperty?.size() > 0)) {
            for (String phenotype in unsortedTree.pproperty.keySet()) {
                for (String sampleGroup in unsortedTree.pproperty[phenotype].keySet()) {
                    List<String> properties = unsortedTree.pproperty[phenotype][sampleGroup]
                    List<String> props = metaDataService.getSpecificPhenotypePropertyList(sampleGroup, phenotype)
                    List<String> props2 = props.findAll { properties.contains(it) }
                    if ((props2) && (props2.size() > 0)) {
                        unsortedTree.pproperty[phenotype][sampleGroup] = props2
                    }
                }

            }

        }
        return unsortedTree
    }

    /***
     * Subset the metadata to only columns we want to display
     * @param phenotypesToKeep The phenotypes to keep
     * @param sampleGroupsToKeep The sample groups to keep 
     * @param propertiesToKeep The properties to keep 
     * @return
     */
    public LinkedHashMap getColumnsToDisplayStructure(List<String> phenotypesToKeep = null,
                                                      List<String> sampleGroupsToKeep = null, List<String> propertiesToKeep = null,
                                                      List<String> commonProperties = null) {

        // DIGP-170: modified method signature for final push to move to dynamic metadata structure
        if (phenotypesToKeep) {
            phenotypesToKeep = phenotypesToKeep.unique()
        }
        if (sampleGroupsToKeep) {
            sampleGroupsToKeep = sampleGroupsToKeep.unique()
        }
        if (propertiesToKeep) {
            propertiesToKeep = propertiesToKeep.unique()
        }

        LinkedHashMap returnValue = [:]

        returnValue["cproperty"] = commonProperties


        returnValue["dproperty"] = [:]
        returnValue["pproperty"] = [:]


        if (phenotypesToKeep == null) {

            phenotypesToKeep = metaDataService.getEveryPhenotype()
        } else {
            phenotypesToKeep = phenotypesToKeep.findAll({ metaDataService.getEveryPhenotype().contains(it) })
        }

        for (String phenotype in phenotypesToKeep) {
            returnValue.pproperty[phenotype] = [:]
            returnValue.dproperty[phenotype] = [:]
            List<String> curSampleGroups = []
            if (sampleGroupsToKeep == null) {
                curSampleGroups.addAll(metaDataService.getSampleGroupPerPhenotype(phenotype))
            } else {
                curSampleGroups.addAll(sampleGroupsToKeep)
                //curSampleGroups.addAll(sampleGroupsToKeep.findAll({metaDataService.getSampleGroupPerPhenotype(phenotype)?.contains(it)}))
            }
            for (String sampleGroup in curSampleGroups) {
                returnValue.dproperty[phenotype][sampleGroup] = []
                returnValue.pproperty[phenotype][sampleGroup] = []
                if (propertiesToKeep == null) {
                    // I'm not sure that this branch is ever called
                    returnValue.dproperty[phenotype][sampleGroup].addAll(metaDataService.getSampleGroupPropertyList(sampleGroup).contains(it))
                    List<String> propertiesToAdd = metaDataService.getSpecificPhenotypePropertyList(sampleGroup, phenotype)
                    if ((propertiesToAdd) && (propertiesToAdd.size() > 0)) {
                        returnValue.pproperty[phenotype][sampleGroup].addAll(propertiesToAdd)
                    }
                } else {
                    returnValue.dproperty[phenotype][sampleGroup].addAll(propertiesToKeep.findAll({
                        metaDataService.getSampleGroupPropertyList(sampleGroup).contains(it)
                    }))
                    List<String> phenotypeProperties = metaDataService.getSpecificPhenotypePropertyList(sampleGroup, phenotype)
                    List<String> propertiesToAdd = propertiesToKeep.findAll { phenotypeProperties }
                    if ((propertiesToAdd) && (propertiesToAdd.size() > 0)) {
                        returnValue.pproperty[phenotype][sampleGroup].addAll(propertiesToAdd)
                    }
                }
            }

        }

        return sortEverything(returnValue)
    }


    public JSONObject packageUpAListAsJson(List<String> listOfStrings) {
        // now that we have a list, build it into a string suitable for JSON
        int numrec = 0
        StringBuilder sb = new StringBuilder()
        if ((listOfStrings) && (listOfStrings?.size() > 0)) {
            numrec = listOfStrings.size()
            for (int i = 0; i < numrec; i++) {
                sb << "\"${listOfStrings[i]}\"".toString()
                if (i < listOfStrings.size() - 1) {
                    sb << ","
                }
            }
        }

        return [
                is_error  : false,
                numRecords: numrec,
                dataset   : listOfStrings
        ]

    }


    public JSONObject packageUpATreeAsJson(LinkedHashMap<String, LinkedHashMap<String, List<String>>> bigTree) {
        // now that we have a multilevel tree, build it into a string suitable for JSON
        JSONObject toReturn = []
        if ((bigTree) && (bigTree?.size() > 0)) {
            bigTree.each { String phenotype, LinkedHashMap phenotypeSpecificSampleGroups ->
                toReturn[phenotype] = phenotypeSpecificSampleGroups
            }
        }
        return toReturn
    }

    /***
     * get top level sample groups for display
     *
     **/
    public List<SampleGroup> listOfTopLevelSampleGroups(String phenotypeName, String datasetName, List<String> technologies) {
        List<SampleGroup> fullListOfSampleGroups = []
        for (String technologyName in technologies) {
            List<SampleGroup> technologySpecificSampleGroups = metaDataService.getSampleGroupForPhenotypeDatasetTechnologyAncestry(phenotypeName, datasetName,
                    technologyName,
                    getCurrentDataVersion(), "")
            // pick a favorite -- use sample size eventually.  For now we use a shortcut...
            if (technologySpecificSampleGroups) {
                List<SampleGroup> sortedTechnologySpecificSampleGroups = technologySpecificSampleGroups.sort { SampleGroup a, SampleGroup b ->
                    (b.subjectsNumber as Integer) <=> (a.subjectsNumber as Integer)
                }
                if ("ExSeq" == technologyName) {
                    fullListOfSampleGroups.add(sortedTechnologySpecificSampleGroups[0])
                } else {
                    fullListOfSampleGroups.addAll(sortedTechnologySpecificSampleGroups)
                }
            }
        }
        return fullListOfSampleGroups
    }


    public String packageUpASingleLevelTreeAsJson(LinkedHashMap<String, LinkedHashMap<String, List<String>>> bigTree) {
        // now that we have a multilevel tree, build it into a string suitable for JSON
        //LinkedHashMap<String, LinkedHashMap <String,List <String>>> sortedBigTree = bigTree.sort{it.value.technology}
        StringBuilder returnValue = new StringBuilder()
        if ((bigTree) && (bigTree?.size() > 0)) {
            List<String> phenotypeHolder = []
            bigTree.each { String phenotype, LinkedHashMap phenotypeSpecificSampleGroups ->
                StringBuilder sb = new StringBuilder()
                sb << """  \"${phenotype}\":
    {""".toString()
                List<String> sampleGroupList = []
                if (phenotypeSpecificSampleGroups?.size() > 0) {
                    phenotypeSpecificSampleGroups.each { String sampleGroupName, String propertyName ->
                        sampleGroupList << """        \"${sampleGroupName}\":\"$propertyName\" """.toString()
                    }
                }
                sb << """
          ${sampleGroupList.join(",")}
  }""".toString()
                phenotypeHolder << sb.toString()
            }
            returnValue << """{
            ${phenotypeHolder.join(",")}
            }"""
        }
        return returnValue.toString()
    }


    public JSONObject packageUpSortedHierarchicalListAsJson(LinkedHashMap mapOfSampleGroups) {
        int numberOfGroups = 0
        StringBuilder sb = new StringBuilder()

        JSONObject toReturn = [
                dataset: new JSONObject()
        ]

        List<String> sampleGroupList = []
        if (mapOfSampleGroups?.size() > 0) {
            mapOfSampleGroups.each { String sampleGroupName, List<String> propertyNames ->
                toReturn.dataset[sampleGroupName] = propertyNames
            }
        }
        toReturn.is_error = false
        toReturn.numRecords = numberOfGroups

        return toReturn
    }


    public JSONObject packageUpAHierarchicalListAsJson(LinkedHashMap mapOfStrings) {
        int numberOfGroups = 0

        JSONObject toReturn = [
                dataset: new JSONObject()
        ]

        if ((mapOfStrings) && (mapOfStrings?.size() > 0)) {
            LinkedHashMap sortedMapOfStrings = mapOfStrings
            numberOfGroups = sortedMapOfStrings.size()
            int groupCounter = 0
            sortedMapOfStrings.each { k, List v ->
                ArrayList<String> listOfPhenotypes = new ArrayList<String>()
                int individualGroupLength = v.size()
                for (int i = 0; i < individualGroupLength; i++) {
                    listOfPhenotypes << v[i]
                }
                groupCounter++
                toReturn.dataset[k] = listOfPhenotypes
            }
        }

        toReturn.is_error = false
        toReturn.numRecords = numberOfGroups

        return toReturn
    }


    public JSONObject packageUpASimpleMapAsJson(LinkedHashMap<String, String> mapOfStrings) {
        // now that we have a list, build it into a string suitable for JSON
        int numberOfGroups = 0
        StringBuilder sb = new StringBuilder()

        JSONObject toReturn = [
                dataset: new JSONObject()
        ]

        if ((mapOfStrings) && (mapOfStrings?.size() > 0)) {
            LinkedHashMap sortedMapOfStrings = mapOfStrings
            numberOfGroups = sortedMapOfStrings.size()
            int groupCounter = 0
            sortedMapOfStrings.each { String k, String v ->
                toReturn.dataset[k] = v
            }
        }

        toReturn.is_error = false
        toReturn.numRecords = numberOfGroups

        return toReturn
    }


    public String packageSampleGroupsHierarchicallyForJsTree(SampleGroupBean sampleGroupBean, String phenotypeName) {
        StringBuilder sb = new StringBuilder()
        if (sampleGroupBean) {
            sb = recursivelyDescendSampleGroupsHierarchically(sampleGroupBean, phenotypeName, sb)
        }
        return sb.toString()
    }


    public StringBuilder recursivelyDescendSampleGroupsHierarchically(SampleGroupBean sampleGroupBean, String phenotypeName, StringBuilder sb) {
        String checkedByDef = (sb.toString().length() == 0) ? "true" : "false"
        if (sampleGroupBean) {
            def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
            List<org.broadinstitute.mpg.diabetes.metadata.Phenotype> phenotypeList = sampleGroupBean.getPhenotypes()
            for (org.broadinstitute.mpg.diabetes.metadata.Phenotype phenotype in phenotypeList) {
                if (("" == phenotypeName) || (phenotype.name == phenotypeName)) {// we care about this sample group
                    String pValue = filterManagementService.findFavoredMeaningValue(sampleGroupBean.getSystemId(), phenotypeName, "P_VALUE");
                    sb << """{
  "text"        : "${
                        g.message(code: "metadata." + sampleGroupBean.getSystemId(), default: sampleGroupBean.getSystemId())
                    }",
  "id"          : "${sampleGroupBean.getSystemId()}-${pValue}-${sampleGroupBean.subjectsNumber}-${phenotypeName}",
  "state"       : {
    "opened"    : false,
    "disabled"  : false,
    "selected"  : ${checkedByDef}
  },
  "children"    : [""".toString()
                    List<SampleGroup> sampleGroupList = sampleGroupBean.getSampleGroups()
                    int sampleGroupCount = 0
                    for (SampleGroup sampleGroup in sampleGroupList) {
                        recursivelyDescendSampleGroupsHierarchically(sampleGroup, phenotypeName, sb)
                        sampleGroupCount++
                        if (sampleGroupCount < sampleGroupList.size()) {
                            sb << ","
                        }
                    }
                    sb << """]
}""".toString()
                }
            }
        }
        return sb
    }


    LinkedHashMap<String, LinkedHashMap<String, List<String>>> putPropertiesIntoHierarchy(String rawProperties) {
        LinkedHashMap phenotypeHolder = [:]
        if ((rawProperties) &&
                (rawProperties.length())) {
            List<String> listOfProperties = rawProperties.tokenize("^")
            for (String property in listOfProperties) {
                List<String> propertyPieces = property.tokenize(":") // 0=Phenotype,1= data set,2= property
                LinkedHashMap datasetHolder
                if (phenotypeHolder.containsKey(propertyPieces[0])) {
                    datasetHolder = phenotypeHolder[propertyPieces[0]]
                } else {
                    datasetHolder = [:]
                    phenotypeHolder[propertyPieces[0]] = datasetHolder
                }
                List propertyHolder
                if (datasetHolder.containsKey(propertyPieces[1])) {
                    propertyHolder = datasetHolder[propertyPieces[1]]
                } else {
                    propertyHolder = []
                    datasetHolder[propertyPieces[1]] = propertyHolder
                }
                if (!propertyHolder.contains(propertyPieces[2])) {
                    propertyHolder << propertyPieces[2]
                }

            }
        }
        return phenotypeHolder
    }


    public String parseChromosome(String rawChromosomeString) {
        String returnValue = ""
        java.util.regex.Matcher chromosome = rawChromosomeString =~ /chr[\dXY]*/
        if (chromosome.size() == 0) {  // let's try to help if the user forgot to specify the chr
            chromosome = rawChromosomeString =~ /[\dXY]*/
        }
        if (chromosome.size() > 0) {
            java.util.regex.Matcher chromosomeString = chromosome[0] =~ /[\dXY]+/
            if (chromosomeString.size() > 0) {
                returnValue = chromosomeString[0]
            }
        }
        return returnValue;
    }


    public String parseExtent(String rawExtentString) {
        String returnValue = ""
        java.util.regex.Matcher startExtentString = rawExtentString =~ /\d+/
        if (startExtentString.size() > 0) {
            returnValue = startExtentString[0]
        }
        return returnValue;
    }


    public String convertMultipartFileToString(org.springframework.web.multipart.commons.CommonsMultipartFile incomingFile) {
        StringBuilder sb = []
        if (!incomingFile.empty) {
            java.io.InputStream inputStream = incomingFile.getInputStream()
            try {
                int temp
                while ((temp = inputStream.read()) != -1) {
                    sb << ((char) temp).toString()
                }
            } catch (Exception ex) {
                log.error('Problem reading input file=' + ex.toString() + '.')
            }
        } else {
            log.info('User passed us an empty file.')
        }
        return sb.toString()
    }

    /***
     * split up a compound string on the basis of commas.  Turn it into a nice clean list
     *
     * @param initialString
     * @return
     */
    List<String> convertStringToArray(String initialString) {
        List<String> returnValue = []
        List<String> rawList = []
        if (initialString) {
            rawList = initialString.split(',')
        }
        for (String oneString in rawList) {
            returnValue << oneString.replaceAll("[^a-zA-Z_\\d\\s:]", "")
        }
        return returnValue
    }

    /***
     * Convert a simple list into a collection of strings enclosed in quotation marks and separated
     * by commas
     * @param list
     * @return
     */
    String convertListToString(List<String> list) {
        String returnValue = ""
        if (list) {
            List filteredList = list.findAll { it.toString().size() > 0 }
            // make sure everything is a string with at least size > 0
            if (filteredList.size() > 0) {
                returnValue = "\"" + filteredList.join("\",\"") + "\""
                // put them together in a way that Json can consume
            }
        }
        return returnValue
    }

    /***
     * take the data from a multiple line representation (as one might find in a datafile) and
     * put every line into its own element in a list. While were at it remove quotation marks
     * as well as everything else that is in a digit, character, or underscore.
     *
     * @param multiline
     * @return
     */
    List<String> convertMultilineToList(String multiline) {
        List<String> returnValue = []
        multiline.eachLine {
            if (it) {
                String filteredVersion = it.toString().replaceAll("[^a-zA-Z_\\d\\s:]", "")
                if (filteredVersion) {
                    returnValue << filteredVersion
                }
            }
        }
        return returnValue
    }


    String createDistributedBurdenTestInput(List<String> variantList) {
        String returnValue = """{
            "variants":[
               ${convertListToString(variantList)}
        ],
            "covariates": [],
            "samples": []
        }"""
        return returnValue
    }

    /***
     * urlEncodedListOfProteinEffect delivers the information in of the ProteinEffect domain object
     * For convenient delivery to the browser
     * @return
     */
    public String urlEncodedListOfProteinEffect() {
        List<ProteinEffect> proteinEffectList = ProteinEffect.list()
        StringBuilder sb = new StringBuilder("")
        int numberOfProteinEffects = proteinEffectList.size()
        int iterationCount = 0
        for (ProteinEffect proteinEffect in proteinEffectList) {
            sb << (proteinEffect.key + ":" + proteinEffect.name)
            iterationCount++
            if (iterationCount < numberOfProteinEffects) {
                sb << "~"
            }
        }
        return java.net.URLEncoder.encode(sb.toString())
    }

    /***
     * urlEncodedListOfProteinEffect delivers the information in of the ProteinEffect domain object
     * For convenient delivery to the browser
     * @return
     */
    public String urlEncodedListOfUsers() {
        List<User> userList = User.list()
        StringBuilder sb = new StringBuilder("")
        int numberOfUsers = userList.size()
        int iterationCount = 0
        for (User user in userList) {
            sb << (user.username + ":" + (user.getPasswordExpired() ? 'T' : 'F') + ":" + (user.getAccountExpired() ? 'T' : 'F') + ":" + user.getId())
            iterationCount++
            if (iterationCount < numberOfUsers) {
                sb << "~"
            }
        }
        return java.net.URLEncoder.encode(sb.toString())
    }


    public String urlEncodedListOfUserSessions(List<UserSession> userSessionList) {
        StringBuilder sb = new StringBuilder("")
        int numberOfUsers = userSessionList.size()
        int iterationCount = 0
        for (UserSession userSession in userSessionList) {
            sb << (userSession.user.username + "#" + (userSession.getStartSession().toString()) + "#" + (userSession.getEndSession() ?: 'none') + "#" +
                    (userSession.getRemoteAddress() ?: 'none') + "#" + (userSession.getDataField() ?: 'none'))
            iterationCount++
            if (iterationCount < numberOfUsers) {
                sb << "~"
            }
        }
        return java.net.URLEncoder.encode(sb.toString())
    }

    /***
     * Given a user, translate their privileges into a flag integer
     *
     * @param userInstance
     * @return
     */
    public int extractPrivilegeFlags(User userInstance) {
        int flag = 0
        List<UserRole> userRoleList = UserRole.findAllByUser(userInstance)
        for (UserRole oneUserRole in userRoleList) {
            if (oneUserRole.role == Role.findByAuthority("ROLE_USER")) {
                flag += 1
            } else if (oneUserRole.role == Role.findByAuthority("ROLE_ADMIN")) {
                flag += 2
            } else if (oneUserRole.role == Role.findByAuthority("ROLE_SYSTEM")) {
                flag += 4
            }
        }
        return flag
    }


    private void adjustPrivileges(User userInstance, int targetFlag, int currentFlag, int bitToConsider, String targetRole) {
        if ((targetFlag & bitToConsider) > 0) {
            // we want them to have it

            if ((currentFlag & bitToConsider) == 0) {
                // we want them to have it and they don't. Give it to them
                Role role = Role.findByAuthority(targetRole)
                UserRole.create userInstance, role
            }  // else we want them to have it and they do already == no-op

        } else {
            // we don't want them to have it

            if ((currentFlag & bitToConsider) > 0) {
                // we don't want them to have it but they do. Take it away
                Role role = Role.findByAuthority(targetRole)
                UserRole userRole = UserRole.findByUserAndRole(userInstance, role)
                //               UserRole userRole =  UserRole.get(userInstance.id,role.id)
                userRole.delete()
            }  // else we don't want them to have it and they don't already == no-op

        }

    }

    /***
     * Give the user the privileges we want them to have – no more, no less
     * @param userInstance
     * @param flag
     * @return
     */
    public int storePrivilegesFromFlags(User userInstance, int targetFlag) {
        // what privileges do they have already
        int currentFlag = extractPrivilegeFlags(userInstance)

        // Now go through the flags we want them to have one by one and adjust accordingly
        adjustPrivileges(userInstance, targetFlag, currentFlag, 0x1, "ROLE_USER")
        adjustPrivileges(userInstance, targetFlag, currentFlag, 0x2, "ROLE_ADMIN")
        adjustPrivileges(userInstance, targetFlag, currentFlag, 0x4, "ROLE_SYSTEM")

        return targetFlag
    }

    public int convertCheckboxesToPrivFlag(params) {
        int flag = 0
        if (params["userPrivs"] == "on") {
            flag += 1
        }
        if (params["mgrPrivs"] == "on") {
            flag += 2
        }
        if (params["systemPrivs"] == "on") {
            flag += 4
        }
        return flag
    }

    /***
     * did we get enough information to find a spot on the genome? We need at least a chromosome specifier and
     * a position greater than and a position less than OR a gene (allowing us to infer the position).
     *
     * @param getDataQuery
     * @return
     */
    public LinkedHashMap validGenomicExtents(GetDataQuery getDataQuery) {
        LinkedHashMap returnValue = [:]
        List<Integer> geneIndex = getDataQuery.getPropertyIndexList(PortalConstants.PROPERTY_KEY_COMMON_GENE)
        List<Integer> chromosomeIndex = getDataQuery.getPropertyIndexList(PortalConstants.PROPERTY_KEY_COMMON_CHROMOSOME)
        List<Integer> positionIndex = getDataQuery.getPropertyIndexList(PortalConstants.PROPERTY_KEY_COMMON_POSITION)
        if (geneIndex?.size() == 1) {
            Property property = getDataQuery.getFilterList()[geneIndex[0]]?.property
            Gene geneList = Gene.retrieveGene(property?.getName())
            if (geneList) {
                returnValue["addrStart"] = geneList.addrStart
                returnValue["addrEnd"] = geneList.addrEnd
                returnValue["chromosome"] = geneList.chromosome
                returnValue["geneName"] = geneList.name2
            }
        } else if ((chromosomeIndex?.size() == 1) &&
                (positionIndex.size() == 2)) {
            QueryFilter queryFilter0 = getDataQuery.getFilterList()[positionIndex[0]]
            QueryFilter queryFilter1 = getDataQuery.getFilterList()[positionIndex[1]]
            returnValue["addrStart"] = 0L
            returnValue["addrEnd"] = 3200000000L
            if ((queryFilter0.operator == PortalConstants.OPERATOR_LESS_THAN_EQUALS) ||
                    (queryFilter0.operator == PortalConstants.OPERATOR_LESS_THAN_NOT_EQUALS)) {
                returnValue["addrEnd"] = queryFilter0.value as Long
            }
            if ((queryFilter1.operator == PortalConstants.OPERATOR_MORE_THAN_EQUALS) ||
                    (queryFilter1.operator == PortalConstants.OPERATOR_MORE_THAN_NOT_EQUALS)) {
                returnValue["addrStart"] = queryFilter1.value as Long
            }
            returnValue["chromosome"] = getDataQuery.getFilterList()[chromosomeIndex[0]]?.property
        }
        return returnValue
    }


    List<String> allEncompassedGenes(LinkedHashMap genomicExtents) {
        List<String> returnValue = []
        if (genomicExtents.size() > 0) {
            List<Gene> geneList = Gene.findAllByChromosome("chr" + genomicExtents["chromosome"])
            for (Gene gene in geneList) {
                int startExtent = genomicExtents["addrStart"] as Long
                int endExtent = genomicExtents["addrEnd"] as Long
                if (((gene.addrStart > startExtent) && (gene.addrStart < endExtent)) ||
                        ((gene.addrEnd > startExtent) && (gene.addrEnd < endExtent))) {
                    returnValue << gene.name1 as String
                }
            }
        }
        return returnValue
    }


    List<String> allEncompassedGenes(GetDataQuery getDataQuery) {
        LinkedHashMap genomicExtents = validGenomicExtents(getDataQuery)
        return allEncompassedGenes(genomicExtents)
    }

    /***
     * packageUpFiltersForRoundTrip get back a list of filters that we need to pass to the backend. We package them up for a round trip to the client
     * and back via the Ajax call
     *
     * @param listOfAllFilters
     * @return
     */
    public String packageUpFiltersForRoundTrip(List<String> listOfAllFilters) {

        StringBuilder sb = new StringBuilder()
        if (listOfAllFilters) {
            for (int i = 0; i < listOfAllFilters.size(); i++) {
                sb << listOfAllFilters[i]
                if ((i + 1) < listOfAllFilters.size()) {
                    sb << ","
                }
            }
        }
        return java.net.URLEncoder.encode(sb.toString())

    }


    public LinkedHashMap<String, List<LinkedHashMap>> composePhenotypeOptions() {
        LinkedHashMap<String, List<LinkedHashMap>> returnValue = [:]
        LinkedHashMap<String, List<String>> propertyTree = metaDataService.getHierarchicalPhenotypeTree()
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
        propertyTree.each { String categoryName, List<String> phenotypeList ->
            List<LinkedHashMap> phenotypesAndTranslations = []
            for (String phenotype in phenotypeList) {
                phenotypesAndTranslations << ['mkey': phenotype, 'name': g.message(code: "metadata." + phenotype, default: phenotype)]
            }
            returnValue[categoryName] = phenotypesAndTranslations
        }
        return returnValue
    }

    /***
     * build up a phenotype list
     * @return
     */
    public LinkedHashMap<String, List<LinkedHashMap>> composeDatasetOptions() {
        LinkedHashMap returnValue = [:]
        List ancestry = []
        ancestry << ['mkey': 'AA', 'name': 'African-American']
        ancestry << ['mkey': 'EA', 'name': 'East Asian']
        ancestry << ['mkey': 'SA', 'name': 'South Asian']
        ancestry << ['mkey': 'EU', 'name': 'European']
        ancestry << ['mkey': 'HS', 'name': 'Hispanic']
        returnValue["ancestry"] = ancestry
        return returnValue
    }

    /***
     *  we need to  encode the list of parameters so that we can reset them when we reenter  the filter setting form.  It
     *  is certainly true that this is a different form of the same information that is held in BOTH the filter list and the
     *  filterDescription  list.  This one could be passed from a different page, however, so we really want a simple, unambiguous
     *  way to store it and pass it around
     *
     *  Note that these values will be interpreted by the client (browser) and they are guaranteed to have no funny characters.  Therefore
     *  we don't need to URL encode them
     *
     * @param listOfAllEncodedParameters
     * @return
     */
    public String packageUpEncodedParameters(List<String> listOfAllEncodedParameters) {
        StringBuilder sbEncoded = new StringBuilder()
        for (int i = 0; i < listOfAllEncodedParameters.size(); i++) {
            sbEncoded << listOfAllEncodedParameters[i]
            if ((i + 1) < listOfAllEncodedParameters.size()) {
                sbEncoded << ","
            }
        }

        return sbEncoded.toString()
    }


    public String encodeUser(String putativeUsername) {
        int key = 47
        String coded = ""
        for (int i = 0; i < putativeUsername.length(); ++i) {

            char c = putativeUsername.charAt(i);
            int j = (int) c + key;
            coded += (j + "-")


        }
        return coded
    }


    public String unencodeUser(String encodedUsername) {
        String returnValue = ""
        String[] elements = encodedUsername.split("-")
        for (int i = 0; i < elements.size(); ++i) {
            String encChar = elements[i]
            if (encChar.length() > 0) {
                int codedVal = encChar.toInteger()
                int decoded = codedVal - 47
                String aChar = new Character((char) decoded).toString();
                returnValue += aChar
            }
        }
        return returnValue

    }


    public String sendForgottenPasswordEmail(String userEmailAddress) {
        String serverUrl = "http://localhost:8080/dport"
        String passwordResetUrl = grailsLinkGenerator.link(controller: 'admin', action: 'resetPasswordInteractive', absolute: true)
        String bodyOfMessage = "Dear diabetes portal user;\n\n In order to access the updated version of the diabetes portal it will be necessary for you to reset your password." +
                "Please copy the following string into the URL of your browser:\n\n" +
                passwordResetUrl + "/" + encodeUser(userEmailAddress) + "\n" +
                "\n" +
                "If you did not request a password reset then you can safely ignore this e-mail"
        mailService.sendMail {
            from "t2dPortal@gmail.com"
            to userEmailAddress
            subject "Password reset necessary"
            body bodyOfMessage
        }

    }


    public String encodeAFilterList(LinkedHashMap<String, String> parametersToEncode, LinkedHashMap<String, String> customFiltersToEncode) {
        StringBuilder sb = new StringBuilder("")
        if (((parametersToEncode.containsKey("phenotype")) && (parametersToEncode["phenotype"]))) {
            sb << ("1=" + StringEscapeUtils.escapeJavaScript(parametersToEncode["phenotype"].toString()) + "^")
        }
        if (((parametersToEncode.containsKey("dataSet")) && (parametersToEncode["dataSet"]))) {
            sb << ("2=" + StringEscapeUtils.escapeJavaScript(parametersToEncode["dataSet"].toString()) + "^")
        }
        if (((parametersToEncode.containsKey("orValue")) && (parametersToEncode["orValue"]))) {
            sb << ("3=" + StringEscapeUtils.escapeJavaScript(parametersToEncode["orValue"].toString()) + "^")
        }
        if (((parametersToEncode.containsKey("orValueInequality")) && (parametersToEncode["orValueInequality"]))) {
            sb << ("4=" + StringEscapeUtils.escapeJavaScript(parametersToEncode["orValueInequality"]) + "^")
        }
        if (((parametersToEncode.containsKey("pValue")) && (parametersToEncode["pValue"]))) {
            sb << ("5=" + StringEscapeUtils.escapeJavaScript(parametersToEncode["pValue"].toString()) + "^")
        }
        if (((parametersToEncode.containsKey("pValueInequality")) && (parametersToEncode["pValueInequality"]))) {
            sb << ("6=" + StringEscapeUtils.escapeJavaScript(parametersToEncode["pValueInequality"].toString()) + "^")
        }
        if (((parametersToEncode.containsKey("gene")) && (parametersToEncode["gene"]))) {
            sb << ("7=" + StringEscapeUtils.escapeJavaScript(parametersToEncode["gene"].toString()) + "^")
        }
        if (((parametersToEncode.containsKey("regionChromosomeInput")) && (parametersToEncode["regionChromosomeInput"]))) {
            sb << ("8=" + StringEscapeUtils.escapeJavaScript(parametersToEncode["regionChromosomeInput"].toString()) + "^")
        }
        if (((parametersToEncode.containsKey("regionStartInput")) && (parametersToEncode["regionStartInput"]))) {
            sb << ("9=" + StringEscapeUtils.escapeJavaScript(parametersToEncode["regionStartInput"].toString()) + "^")
        }
        if (((parametersToEncode.containsKey("regionStopInput")) && (parametersToEncode["regionStopInput"]))) {
            sb << ("10=" + StringEscapeUtils.escapeJavaScript(parametersToEncode["regionStopInput"].toString()) + "^")
        }
        if (((parametersToEncode.containsKey("predictedEffects")) && (parametersToEncode["predictedEffects"])) &&
                (parametersToEncode["predictedEffects"] != "0")) {
            sb << ("11=" +
                    StringEscapeUtils.escapeJavaScript("${PortalConstants.JSON_VARIANT_MOST_DEL_SCORE_KEY}|${parametersToEncode["predictedEffects"]}") + "^")
        }
        if (((parametersToEncode.containsKey("esValue")) && (parametersToEncode["esValue"]))) {
            sb << ("12=" + StringEscapeUtils.escapeJavaScript(parametersToEncode["esValue"].toString()) + "^")
        }
        if (((parametersToEncode.containsKey("esValueInequality")) && (parametersToEncode["esValueInequality"]))) {
            sb << ("13=" + StringEscapeUtils.escapeJavaScript(parametersToEncode["esValueInequality"].toString()) + "^")
        }
        if (((parametersToEncode.containsKey("condelSelect")) && (parametersToEncode["condelSelect"]))) {
            sb << ("11=" +
                    StringEscapeUtils.escapeJavaScript("${PortalConstants.JSON_VARIANT_CONDEL_PRED_KEY}|${parametersToEncode["condelSelect"]}") + "^")
        }
        if (((parametersToEncode.containsKey("polyphenSelect")) && (parametersToEncode["polyphenSelect"]))) {
            sb << ("11=" +
                    StringEscapeUtils.escapeJavaScript("${PortalConstants.JSON_VARIANT_POLYPHEN_PRED_KEY}|${parametersToEncode["polyphenSelect"]}") + "^")
        }
        if (((parametersToEncode.containsKey("siftSelect")) && (parametersToEncode["siftSelect"]))) {
            sb << ("11=" +
                    StringEscapeUtils.escapeJavaScript("${PortalConstants.JSON_VARIANT_SIFT_PRED_KEY}|${parametersToEncode["siftSelect"]}") + "^")
        }
        customFiltersToEncode?.each { String key, String value ->
            sb << ("17=" + StringEscapeUtils.escapeJavaScript(value.toString()) + "^")
        }


        return sb.toString()
    }


    public LinkedHashMap getGeneExtent(String geneName) {
        LinkedHashMap<String, Integer> returnValue = [startExtent: 0, endExtent: 3000000000, chrom: "1"]
        if (geneName) {
            String geneUpperCase = geneName.toUpperCase()
            Gene gene = Gene.retrieveGene(geneUpperCase)
            returnValue.startExtent = gene?.addrStart ?: 0
            returnValue.endExtent = gene?.addrEnd ?: 0
            returnValue.chrom = gene?.chromosome
        }
        return returnValue
    }


    public LinkedHashMap getGeneExpandedExtent(String geneName) {
        LinkedHashMap<String, Integer> returnValue = [startExtent: 0, endExtent: 3000000000]
        if (geneName) {
            LinkedHashMap<String, Integer> geneExtent = getGeneExtent(geneName)
            Integer addrStart = geneExtent.startExtent
            if (addrStart) {
                returnValue.startExtent = ((addrStart > 100000) ? (addrStart - 100000) : 0)
            }
            returnValue.endExtent = geneExtent.endExtent + 100000
            returnValue.chrom = geneExtent.chrom
        }
        return returnValue
    }


    public Long convertRegionString(String incomingExtent) {
        Long returnValue = -1
        try {
            returnValue = Long.parseLong(incomingExtent)
        } catch (NumberFormatException nfe) {
            log.info("convertRegionString failed to convert= ${incomingExtent}")
            returnValue = -1
        }
        return returnValue
    }


    public String getGeneExpandedRegionSpec(String geneName) {
        String returnValue = ""
        if (geneName) {
            String geneUpperCase = geneName.toUpperCase()
            Gene gene = Gene.retrieveGene(geneUpperCase)
            LinkedHashMap<String, Integer> geneExtent = getGeneExpandedExtent(geneName)
            returnValue = "${gene.chromosome}:${geneExtent.startExtent}-${geneExtent.endExtent}"
        }
        return returnValue
    }


    public void decodeAFilterList(List<String> encodedOldParameterList, LinkedHashMap<String, String> returnValue) {
        int filterCount = 0
        for (String encodedFilterString in encodedOldParameterList) {
            if (encodedFilterString) {
                List<String> parametersList = encodedFilterString.split("\\^")
                for (int i = 0; i < parametersList.size(); i++ > 0) {
                    List<String> divKeys = parametersList[i].split("=")
                    if (divKeys.size() != 2) {
                        log.info("Problem interpreting filter list = ${parametersList}")
                    } else {
                        int parameterKey
                        try {
                            parameterKey = Integer.parseInt(divKeys[0])
                        } catch (e) {
                            log.info("Unexpected key when interpreting filter list = ${parametersList}")
                        }
                        returnValue["ofilter${filterCount++}"] = StringEscapeUtils.unescapeJavaScript(parametersList[i]);
//                        switch (parameterKey){
//                            case 1:returnValue ["phenotype"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 2:returnValue ["dataSet"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 3:returnValue ["orValue"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 4:returnValue ["orValueInequality"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 5:returnValue ["pValue"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 6:returnValue ["pValueInequality"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 7:returnValue ["gene"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 8:returnValue ["regionChromosomeInput"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 9:returnValue ["regionStartInput"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 10:returnValue ["regionStopInput"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 11:returnValue ["predictedEffects"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 12:returnValue ["esValue"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 13:returnValue ["esValueInequality"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 14:returnValue ["condelSelect"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 15:returnValue ["polyphenSelect"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 16:returnValue ["siftSelect"] = StringEscapeUtils.unescapeJavaScript(divKeys [1]);
//                                break
//                            case 17:returnValue ["ofilter${filterCount++}"] = StringEscapeUtils.unescapeJavaScript(parametersList[i]);
//                                break
//                            default:
//                                log.info("Unexpected parameter key  = ${parameterKey}")
//                        }
                    }
                }
            }
        }
        return
    }


    public String translatorFilter(String filterToTranslate) {
        //break apart the filter, substitute human readable strings
        String returnValue
        List<String> breakoutProperty = filterToTranslate.tokenize(JsNamingQueryTranslator.QUERY_SAMPLE_GROUP_AND_STRING)
        if (breakoutProperty.size() == 2) {
            List<String> breakoutPhenotype = breakoutProperty[0].tokenize(JsNamingQueryTranslator.QUERY_SAMPLE_GROUP_BEGIN_STRING)
            if (breakoutPhenotype.size() == 2) {
                String comparator = ""
                String displayableComparator = ""
                if (breakoutProperty[1].contains(JsNamingQueryTranslator.QUERY_OPERATOR_EQUALS_STRING)) {
                    comparator = JsNamingQueryTranslator.QUERY_OPERATOR_EQUALS_STRING
                    displayableComparator = "="
                } else if (breakoutProperty[1].contains(JsNamingQueryTranslator.QUERY_OPERATOR_MORE_THAN_STRING)) {
                    comparator = JsNamingQueryTranslator.QUERY_OPERATOR_MORE_THAN_STRING
                    displayableComparator = "&gt;"
                } else if (breakoutProperty[1].contains(JsNamingQueryTranslator.QUERY_OPERATOR_LESS_THAN_STRING)) {
                    comparator = JsNamingQueryTranslator.QUERY_OPERATOR_LESS_THAN_STRING
                    displayableComparator = "&lt;"
                } else {
                    returnValue = filterToTranslate
                }
                if (comparator.length() > 0) {
                    def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
                    // try for the fully expanded description
                    List<String> valueComparisonBreakout = breakoutProperty[1].tokenize(comparator)
                    if (valueComparisonBreakout.size() == 2) {
                        returnValue = "${g.message(code: "metadata." + breakoutPhenotype[0], default: breakoutPhenotype[0])}[${g.message(code: "metadata." + breakoutPhenotype[1], default: breakoutPhenotype[1])}" +
                                "]${g.message(code: "metadata." + valueComparisonBreakout[0], default: valueComparisonBreakout[0])}${displayableComparator}${valueComparisonBreakout[1]}"
                    }
                }
            } else {
                // something surprising happened. Let's take our best shot at a filter
                returnValue = filterToTranslate
            }
        } else {
            // something surprising happened. Let's take our best shot at a filter
            returnValue = filterToTranslate
        }
        return returnValue
    }
}