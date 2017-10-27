package org.broadinstitute.mpg.diabetes.bean

/**
 * Created by ben on 10/23/2017.
 */
class PortalVersionBean {

    // instance variables
    private String portalType
    private String portalDescription
    private String mdvName

    public PortalVersionBean(String portalType, String portalDescription, String mdvName) {
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

    public String toJsonString(){
        return """{"portalType":"${portalType}","portalDescription":"${portalDescription}","mdvName":"${mdvName}"}"""
    }
}
