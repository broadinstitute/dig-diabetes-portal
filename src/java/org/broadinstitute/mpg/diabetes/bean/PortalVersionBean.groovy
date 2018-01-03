package org.broadinstitute.mpg.diabetes.bean

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
    private List<String> tissues
    private List<String> orderedPhenotypeGroupNames
    private List<String> excludeFromLZ
    private String epigeneticAssays
    private String lzDataset

    public PortalVersionBean(String portalType,
                             String portalDescription,
                             String mdvName,
                             String phenotype,
                             String dataSet,
                             List<String> tissues,
                             List<String> orderedPhenotypeGroupNames,
                             List<String> excludeFromLZ,
                             String epigeneticAssays,
                             String lzDataset ) {
        this.portalType = portalType;
        this.portalDescription = portalDescription;
        this.mdvName = mdvName;
        this.phenotype = phenotype;
        this.dataSet = dataSet
        this.tissues = tissues
        this.epigeneticAssays = epigeneticAssays
        this.orderedPhenotypeGroupNames = orderedPhenotypeGroupNames
        this.excludeFromLZ = excludeFromLZ
        this.lzDataset = lzDataset
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




    public String toJsonString(){
        return """{"portalType":"${getPortalType()}",
"portalDescription":"${getPortalDescription()}",
"mdvName":"${getMdvName()}",
"phenotype":"${getPhenotype()}",
"dataSet":"${getDataSet()}",
"tissues":"${getTissues().toString()}",
"orderedPhenotypeGroupNames":"${getOrderedPhenotypeGroupNames().toString()}",
"excludeFromLZ":"${getExcludeFromLZ().toString()}",
"epigeneticAssays":"${getEpigeneticAssays()}",
"lzDataset":"${getLzDataset()}"}""".toString()
    }
}
