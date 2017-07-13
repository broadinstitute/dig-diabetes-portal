package org.broadinstitute.mpg

class RegionInfoController {
    RestServerService restServerService

    def regionInfo() {
        LinkedHashMap extractedNumbers =  restServerService.extractNumbersWeNeed(params.id)
        if ((extractedNumbers)   &&
                (extractedNumbers["startExtent"])   &&
                (extractedNumbers["endExtent"])&&
                (extractedNumbers["chromosomeNumber"]) ){
            List<String> identifiedGenes = restServerService.retrieveGenesInExtents(
                    [chromosomeSpecified:extractedNumbers.chromosomeNumber,
                    beginningExtentSpecified:extractedNumbers.startExtent,
                    endingExtentSpecified:extractedNumbers.endExtent])
            render (view: 'regionInfo', model:[regionDescription:extractedNumbers,
                                               identifiedGenes:identifiedGenes])
            return
        }
        render (view: 'regionInfo', model:[])
    }

}
