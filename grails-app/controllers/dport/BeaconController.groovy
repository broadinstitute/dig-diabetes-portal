package dport

class BeaconController {
    RestServerService restServerService

    def index() {}

    def BeaconDisplay (){
        render (view: "beaconDisplay", model:[caller:0])
    }

    def beaconVariantQueryAjax() {
        def reqJSON = request.JSON
        String dataset   = reqJSON.getString("dataset")
        String chromosome = reqJSON.getString("chromosome")
        String position  = reqJSON.getString("position")
        String allele    = reqJSON.getString("allele")

        String currentRestServer = "http://broad-beacon.broadinstitute.org:8090/dev/beacon/"
        //TODO Remove hardcoding on ref=hg19 after updating the REST service
        String targetUrl         = "query?chrom=" + chromosome + "&pos=" + position + "&allele=" + allele + "&ref=hg19"

        String resp = restServerService.getRestCallBase(targetUrl, currentRestServer)
        render resp
    }
}
