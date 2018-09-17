package org.broadinstitute.mpg.diabetes.bean

import grails.util.Holders
import org.broadinstitute.mpg.RestServerService
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.springframework.beans.factory.annotation.Autowired

/**
 * Created by ben on 10/23/2017.
 */
class PortalVersionBean {

    // instance variables
    private String portalType
    private String portalDescription
    private String mdvName
    private String phenotype
    private String dataSet
    List<String> tissueRegionOverlapMatcher
    List<String> tissueRegionOverlapDisplayMatcher
    private List<String> tissues
    private List<String> orderedPhenotypeGroupNames
    private List<String> excludeFromLZ
    private String epigeneticAssays
    private String lzDataset
    private String frontLogo
    private String tagline
    private String tabLabel
    private List<String> alternateLanguages
    private List<String> geneExamples
    private List<String> variantExamples
    private List<String> rangeExamples
    private String backgroundGraphic
    private String phenotypeLookupMessage
    private String logoCode
    private String menuHeader
    private String sampleLevelSequencingDataExists
    private String genePageWarning
    private String credibleSetInfoCode
    private String blogId
    private Integer variantAssociationsExists
    private Integer  geneLevelDataExists
    private Integer exposeGrsModule
    private Integer highSpeedGetAggregatedDataCall
    private Integer regionSpecificVersion
    private Integer exposePhewasModule
    private Integer exposeForestPlot
    private Integer exposeTraitDataSetAssociationView
    private Integer exposeGreenBoxes
    private Integer exposeGeneComparisonTable
    private Integer variantTakesYouToGenePage
    private Integer utilizeBiallelicGait
    private Integer utilizeUcsdData
    private Integer exposePredictedGeneAssociations
    private Integer exposeHiCData



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
                             Integer exposeHiCData){
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






    public String toJsonString(){
        return """{"portalType":"${getPortalType()}",
"portalDescription":"${getPortalDescription()}",
"mdvName":"${getMdvName()}",
"phenotype":"${getPhenotype()}",
"dataSet":"${getDataSet()}",
"tissueRegionOverlapMatcher":"${getTissueRegionOverlapMatcher().toString()}",
"tissueRegionOverlapDisplayMatcher":"${getTissueRegionOverlapDisplayMatcher().toString()}",
"tissues":"${getTissues().toString()}",
"orderedPhenotypeGroupNames":"${getOrderedPhenotypeGroupNames().toString()}",
"excludeFromLZ":"${getExcludeFromLZ().toString()}",
"epigeneticAssays":"${getEpigeneticAssays()}",
"lzDataset":"${getLzDataset()}",
"frontLogo":"${getFrontLogo()}",
"tagline":"${getTagline()}",
"tabLabel":"${getTabLabel()}",
"alternateLanguages":"${getAlternateLanguages().toString()}",
"geneExamples":"${getGeneExamples().toString()}",
"variantExamples":"${getVariantExamples().toString()}",
"rangeExamples":"${getRangeExamples().toString()}",
"backgroundGraphic":"${getBackgroundGraphic()}",
"phenotypeLookupMessage":"${getPhenotypeLookupMessage()}",
"logoCode":"${getLogoCode()}",
"menuHeader":"${getMenuHeader()}",
"sampleLevelSequencingDataExists":${getSampleLevelSequencingDataExists()},
"genePageWarning":"${getGenePageWarning()}",
"credibleSetInfoCode":"${getCredibleSetInfoCode()}",
"blogId":"${getBlogId()}",
"variantAssociationsExists":${getVariantAssociationsExists()},
"geneLevelDataExists":${getGeneLevelDataExists()},
"exposeGrsModule": ${getExposeGrsModule()},
"highSpeedGetAggregatedDataCall": ${getHighSpeedGetAggregatedDataCall()},
"regionSpecificVersion":${getRegionSpecificVersion()},
"exposePhewasModule":${getExposePhewasModule()},
"exposeForestPlot":${getExposeForestPlot()},
"exposeTraitDataSetAssociationView":${getExposeTraitDataSetAssociationView()},
"exposeGreenBoxes":${getExposeGreenBoxes()},
"exposeGeneComparisonTable": ${getExposeGeneComparisonTable()},
"variantTakesYouToGenePage": ${getVariantTakesYouToGenePage()},
"utilizeBiallelicGait":${getUtilizeBiallelicGait()},
"utilizeUcsdData":${getUtilizeUcsdData()},
"exposePredictedGeneAssociations":${getExposePredictedGeneAssociations()},
"exposeHiCData()": ${getExposeHiCData()}
}""".toString()
    }
}
