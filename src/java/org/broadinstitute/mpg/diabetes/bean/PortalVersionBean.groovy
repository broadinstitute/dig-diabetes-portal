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
    private String epigeneticAssays
    private String lzDataset
    private String credibleSet

    public PortalVersionBean(String portalType,
                             String portalDescription,
                             String mdvName,
                             String phenotype,
                             String dataSet,
                             List<String> tissues,
                             String epigeneticAssays,
                             String lzDataset,
                             String credibleSet ) {
        this.portalType = portalType;
        this.portalDescription = portalDescription;
        this.mdvName = mdvName;
        this.phenotype = phenotype;
        this.dataSet = dataSet
        this.tissues = tissues
        this.epigeneticAssays = epigeneticAssays
        this.lzDataset = lzDataset
        this.credibleSet = credibleSet
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

    public String getEpigeneticAssays() {
        return epigeneticAssays
    }

    public String getLzDataset() {
        return lzDataset
    }

    public String getCredibleSet() {
        return credibleSet
    }



    public String toJsonString(){
        return """{"portalType":"${getPortalType()}",
"portalDescription":"${getPortalDescription()}",
"mdvName":"${getMdvName()}",
"phenotype":"${getPhenotype()}",
"dataSet":"${getDataSet()}",
"tissues":"${getTissues().toString()}",
"epigeneticAssays":"${getEpigeneticAssays()}",
"lzDataset":"${getLzDataset()}",
"credibleSet":"${getCredibleSet()}"}""".toString()
    }
}
