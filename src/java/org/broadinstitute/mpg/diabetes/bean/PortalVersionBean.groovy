package org.broadinstitute.mpg.diabetes.bean

import grails.util.Holders
import groovy.json.JsonBuilder
import org.broadinstitute.mpg.RestServerService
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.springframework.beans.factory.annotation.Autowired

/**
 * Created by ben on 10/23/2017.
 */
class PortalVersionBean {

    RestServerService restServerService

    // instance variables
    private String portalType
    private String portalDescription
    private String mdvName
    private String phenotype=""
    private String dataSet=""
    List<String> tissueRegionOverlapMatcher=[]
    List<String> tissueRegionOverlapDisplayMatcher=[]
    private List<String> tissues=[]
    private List<String> orderedPhenotypeGroupNames=[]
    private List<String> excludeFromLZ=[]
    private String epigeneticAssays=""
    private String lzDataset=""
    private String frontLogo=""
    private String tagline=""
    private String tabLabel=""
    private List<String> alternateLanguages=[]
    private List<String> geneExamples=[]
    private List<String> variantExamples=[]
    private List<String> rangeExamples=[]
    private String backgroundGraphic=""
    private String phenotypeLookupMessage=""
    private String logoCode=""
    private String menuHeader=""
    private String sampleLevelSequencingDataExists=""
    private String genePageWarning=""
    private String credibleSetInfoCode=""
    private String blogId=""
    private Integer exposeCommonVariantTab=0
    private Integer exposeRareVariantTab=0
    private Integer variantAssociationsExists=0
    private Integer  geneLevelDataExists=0
    private Integer exposeGrsModule=0
    private Integer highSpeedGetAggregatedDataCall=0
    private Integer regionSpecificVersion=0
    private Integer exposePhewasModule=0
    private Integer exposeForestPlot=0
    private Integer exposeTraitDataSetAssociationView=0
    private Integer exposeGreenBoxes=0
    private Integer exposeGeneComparisonTable=0
    private Integer variantTakesYouToGenePage=0
    private Integer utilizeBiallelicGait=0
    private Integer utilizeUcsdData=0
    private Integer exposePredictedGeneAssociations=0
    private Integer exposeHiCData=0
    private Integer exposeDynamicUi=0
    private Integer exposeDatasetHierarchy=0
    private Integer exposeVariantAndAssociationTable=0
    private Integer exposeIgvDisplay=0
    private Integer exposeIndependentBurdenTest=0
    private Integer exposeGenesInRegionTab=0



    public PortalVersionBean(String portalType,
                             String portalDescription,
                             String mdvName,
                             String phenotype,
                             String dataSet,
                             List<String> tissueRegionOverlapMatcher,
                             List<String> tissueRegionOverlapDisplayMatcher,
                             List<String> tissues,
                             List<String> orderedPhenotypeGroupNames,
                             List<String> excludeFromLZ,
                             String epigeneticAssays,
                             String lzDataset,
                             String frontLogo,
                             String tagline,
                             String tabLabel,
                             List<String> alternateLanguages,
                             List<String> geneExamples,
                             List<String> variantExamples,
                             List<String> rangeExamples,
                             String backgroundGraphic,
                             String phenotypeLookupMessage,
                             String logoCode,
                             String menuHeader,
                             String sampleLevelSequencingDataExists,
                             String genePageWarning,
                             String credibleSetInfoCode,
                             String blogId,
                             Integer exposeCommonVariantTab,
                             Integer exposeRareVariantTab,
                             Integer variantAssociationsExists,
                             Integer geneLevelDataExists,
                             Integer exposeGrsModule,
                             Integer highSpeedGetAggregatedDataCall,
                             Integer regionSpecificVersion,
                             Integer exposePhewasModule,
                             Integer exposeForestPlot,
                             Integer exposeTraitDataSetAssociationView,
                             Integer exposeGreenBoxes,
                             Integer exposeGeneComparisonTable,
                             Integer variantTakesYouToGenePage,
                             Integer utilizeBiallelicGait,
                             Integer utilizeUcsdData,
                             Integer exposePredictedGeneAssociations,
                             Integer exposeHiCData,
                             Integer exposeDynamicUi,
                             Integer exposeDatasetHierarchy,
                             Integer exposeVariantAndAssociationTable,
                             Integer exposeIgvDisplay,
                             Integer exposeIndependentBurdenTest,
                             Integer exposeGenesInRegionTab
    ){
        this.portalType = portalType;
        this.portalDescription = portalDescription;
        this.mdvName = mdvName;
        this.phenotype = phenotype;
        this.dataSet = dataSet
        this.tissueRegionOverlapMatcher = tissueRegionOverlapMatcher
        this.tissueRegionOverlapDisplayMatcher = tissueRegionOverlapDisplayMatcher
        this.tissues = tissues
        this.epigeneticAssays = epigeneticAssays
        this.orderedPhenotypeGroupNames = orderedPhenotypeGroupNames
        this.excludeFromLZ = excludeFromLZ
        this.lzDataset = lzDataset
        this.frontLogo = frontLogo
        this.tagline = tagline
        this.tabLabel = tabLabel
        this.alternateLanguages = alternateLanguages
        this.geneExamples = geneExamples
        this.variantExamples = variantExamples
        this.rangeExamples = rangeExamples
        this.backgroundGraphic = backgroundGraphic
        this.phenotypeLookupMessage = phenotypeLookupMessage
        this.logoCode = logoCode
        this.menuHeader = menuHeader
        this.sampleLevelSequencingDataExists = sampleLevelSequencingDataExists
        this.genePageWarning = genePageWarning
        this.credibleSetInfoCode = credibleSetInfoCode
        this.blogId = blogId
        this.exposeCommonVariantTab = exposeCommonVariantTab
        this.exposeRareVariantTab = exposeRareVariantTab
        this.variantAssociationsExists =  variantAssociationsExists
        this.geneLevelDataExists = geneLevelDataExists
        this.exposeGrsModule = exposeGrsModule
        this.highSpeedGetAggregatedDataCall = highSpeedGetAggregatedDataCall
        this.regionSpecificVersion = regionSpecificVersion
        this.exposePhewasModule = exposePhewasModule
        this.exposeForestPlot = exposeForestPlot
        this.exposeTraitDataSetAssociationView = exposeTraitDataSetAssociationView
        this.exposeGreenBoxes = exposeGreenBoxes
        this.exposeGeneComparisonTable = exposeGeneComparisonTable
        this.variantTakesYouToGenePage = variantTakesYouToGenePage
        this.utilizeBiallelicGait = utilizeBiallelicGait
        this.utilizeUcsdData = utilizeUcsdData
        this.exposePredictedGeneAssociations = exposePredictedGeneAssociations
        this.exposeHiCData = exposeHiCData
        this.exposeDynamicUi = exposeDynamicUi
        this.exposeDatasetHierarchy = exposeDatasetHierarchy
        this.exposeVariantAndAssociationTable = exposeVariantAndAssociationTable
        this.exposeIgvDisplay = exposeIgvDisplay
        this.exposeIndependentBurdenTest = exposeIndependentBurdenTest
        this.exposeGenesInRegionTab = exposeGenesInRegionTab
    }



    public PortalVersionBean(String portalType,
                             String portalDescription,
                             String mdvName
    ){
        this.portalType = portalType;
        this.portalDescription = portalDescription;
        this.mdvName = mdvName;
    }




    public String getPortalType() {
        return portalType
    }

    public String getPortalDescription() {
        return portalDescription
    }

    public String getMdvName() {
        return mdvName
    }

    public String getPhenotype() {
        return phenotype
    }

    public String getDataSet() {
        return dataSet
    }

    public List<String> getTissueRegionOverlapMatcher() {
        return tissueRegionOverlapMatcher
    }

    public List<String> getTissueRegionOverlapDisplayMatcher() {
        return tissueRegionOverlapDisplayMatcher
    }

    public List<String> getTissues() {
        return tissues
    }

    public List<String> getOrderedPhenotypeGroupNames() {
        return orderedPhenotypeGroupNames
    }

    public List<String> getExcludeFromLZ() {
        return excludeFromLZ
    }

    public String getEpigeneticAssays() {
        return epigeneticAssays
    }

    public String getLzDataset() {
        return lzDataset
    }

    public String getFrontLogo() {
        //g.message(code: frontLogo, default: frontLogo)
        return frontLogo
    }

    public String getTagline() {
        return tagline
    }

    public String getTabLabel() {
        return tabLabel
    }

    public List<String> getAlternateLanguages() {
        return alternateLanguages
    }

    public List<String> getGeneExamples() {
        return geneExamples
    }

    public List<String> getVariantExamples() {
        return variantExamples
    }

    public List<String> getRangeExamples() {
        return rangeExamples
    }

    public String getBackgroundGraphic() {
        return backgroundGraphic
    }

    public String getPhenotypeLookupMessage() {
        return phenotypeLookupMessage
    }

    public String getLogoCode() {
        return logoCode
    }

    public String getMenuHeader() {
        return menuHeader
    }


    public String getSampleLevelSequencingDataExists() {
        return sampleLevelSequencingDataExists
    }

    public String getGenePageWarning() {
        return genePageWarning
    }

    public String getCredibleSetInfoCode() {
        return credibleSetInfoCode
    }

    public String getBlogId() {
        return blogId
    }

    public Integer getExposeCommonVariantTab() {
        return exposeCommonVariantTab
    }

    public Integer getExposeRareVariantTab() {
        return exposeRareVariantTab
    }

    public Integer getVariantAssociationsExists() {
        return variantAssociationsExists
    }

    public Integer getGeneLevelDataExists() {
        return geneLevelDataExists
    }

    public Integer getExposeGrsModule() {
        return exposeGrsModule
    }

    public Integer getHighSpeedGetAggregatedDataCall() {
        return highSpeedGetAggregatedDataCall
    }

    public Integer getRegionSpecificVersion(){
        return regionSpecificVersion
    }

    public Integer getExposePhewasModule(){
        return exposePhewasModule
    }

    public Integer getExposeForestPlot(){
        return exposeForestPlot
    }

    public Integer getExposeTraitDataSetAssociationView(){
        return exposeTraitDataSetAssociationView
    }

    public Integer getExposeGreenBoxes(){
        return exposeGreenBoxes
    }

    public Integer getExposeGeneComparisonTable(){
        return exposeGeneComparisonTable
    }

    public Integer getVariantTakesYouToGenePage(){
        return variantTakesYouToGenePage
    }

    public Integer getUtilizeBiallelicGait(){
        return utilizeBiallelicGait
    }

    public Integer getUtilizeUcsdData(){
        return utilizeUcsdData
    }

    public Integer getExposePredictedGeneAssociations(){
        return exposePredictedGeneAssociations
    }
    public Integer getExposeHiCData(){
        return exposeHiCData
    }
    public Integer getExposeDynamicUi(){
        return exposeDynamicUi
    }
    public Integer getExposeDatasetHierarchy(){
        return exposeDatasetHierarchy
    }
    public Integer getExposeVariantAndAssociationTable(){
        return exposeVariantAndAssociationTable
    }
    public Integer getExposeIgvDisplay(){
        return exposeIgvDisplay
    }
    public Integer getExposeIndependentBurdenTest(){
        return exposeIndependentBurdenTest
    }
    public Integer getExposeGenesInRegionTab(){
        return exposeGenesInRegionTab
    }






    private List<String> findDataAccessorsForPortalVersionBean(String getOrSet, PortalVersionBean portalVersionBean){
        List<String> returnValue = []
        for (String portalBeanMethodName in this.metaClass.methods*.name.sort().unique() ){
            if (portalBeanMethodName.startsWith(getOrSet)){
                String fieldName = portalBeanMethodName.substring(3)
                if ((fieldName!="MetaClass")&&
                        (fieldName!="Class")&&
                        (fieldName!="Property")){
                    returnValue << fieldName
                }
            }
        }
        return returnValue
    }






    public String toJsonString(PortalVersionBean portalVersionBean) {
        List<String> dataAccessorsForPortalVersionBean = findDataAccessorsForPortalVersionBean("get", portalVersionBean)
        LinkedHashMap objectWeAreBuilding = [:]
        for (String fieldName in dataAccessorsForPortalVersionBean) {
            String portalBeanMethodName = "get${fieldName}"
            try {
                Object methodReturnValue = this.invokeMethod(portalBeanMethodName, null as Object)
                if (methodReturnValue instanceof ArrayList) {
                    List listHolder = []
                    for (String str in (methodReturnValue as ArrayList)) {
                        listHolder << str
                    }
                    objectWeAreBuilding[fieldName] = listHolder
                } else {
                    objectWeAreBuilding[fieldName] = methodReturnValue
                }
            } catch (Exception e) {
                print("prob with ${fieldName}, ${e.toString()}.")
            }
        }
        return new JsonBuilder(objectWeAreBuilding).toPrettyString()
    }


}
