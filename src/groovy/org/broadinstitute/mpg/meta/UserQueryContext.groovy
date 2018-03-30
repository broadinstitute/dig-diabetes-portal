package org.broadinstitute.mpg.meta

import org.apache.juli.logging.LogFactory
import org.broadinstitute.mpg.RestServerService
import org.broadinstitute.mpg.SharedToolsService
import org.broadinstitute.mpg.Variant
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.springframework.beans.factory.annotation.Autowired

/**
 * Created by balexand on 8/6/2015.
 *
 * This class is intended to serve two purposes:
 * short-term: let's pull out all of the static Definition/dependencies
 *       that are necessary to construct filters into one place
 * longer-term: will require some metadata changes, but this is the place to
 *       derive specifics such as sample group IDs based on the information in the metadata
 */
class UserQueryContext {
    private static final log = LogFactory.getLog(this)

    private Long startOriginalExtent
    private Long endOriginalExtent
    private Long startExpandedExtent
    private Long endExpandedExtent
    private String chromosome
    private String originalRequest = ""
    private String interpretedRequest = null
    private Boolean error = false
    public Boolean range = false
    public Boolean gene = false
    public Boolean variant = false
    public Boolean genomicPosition = false


    public UserQueryContext(  ){}

    public UserQueryContext( String userInput,
                             RestServerService restServerService,
                             SharedToolsService sharedToolsService ){
        originalRequest = userInput
        Integer expandBy = restServerService.EXPAND_ON_EITHER_SIDE_OF_GENE

        if ((originalRequest==null)||
                (originalRequest.size()==0)){return}

        // First let's see if the string might be a gene
        LinkedHashMap geneExtent = sharedToolsService.getGeneExpandedExtent(originalRequest.trim().toUpperCase(),0)
        if ( geneExtent.is_error == false ) { gene = true }
        if (gene){
            chromosome = geneExtent.chrom
            startOriginalExtent = geneExtent.startExtent
            endOriginalExtent = geneExtent.endExtent
            startExpandedExtent = ((startOriginalExtent > expandBy) ?
                    (startOriginalExtent - expandBy) : 0)
            endExpandedExtent = endOriginalExtent + expandBy
        }

        // maybe it's a variant?
        if (!gene){
            List<String> variantFields = originalRequest.split(":")
            if (variantFields.size()>1){
                chromosome = sharedToolsService.parseChromosome(variantFields[0])
                String canonicalVariant = sharedToolsService.createCanonicalVariantName(originalRequest)
                Variant variant = Variant.retrieveVariant(canonicalVariant)
                if (variant) {
                    interpretedRequest = variant.varId
                    startOriginalExtent = variant.position
                    endOriginalExtent = variant.position
                    startExpandedExtent = ((variant.position > expandBy) ?
                            (variant.position - expandBy) : 0)
                    endExpandedExtent = variant.position + expandBy
                    variant = true
                } else if (!variantFields[1].contains("-")){ // as long as we're sure it isn't a range
                    // treat like a position, since we don't know this variant
                    Long position
                    try {
                        position = Long.parseLong(sharedToolsService.parseExtent(variantFields[1].replace(/,/, "")))
                        startOriginalExtent = position
                        endOriginalExtent = position
                        startExpandedExtent = ((position > expandBy) ?
                                (position - expandBy) : 0)
                        endExpandedExtent = position + expandBy
                        genomicPosition = true
                    } catch(e){
                        error = true
                    }
                }
            }

        }


        // maybe a location that is specified like a variant?
        if ((!gene)&&(!variant)&&(!genomicPosition)){
            List<String> variantFields = originalRequest.split("_")
            if (variantFields.size()>1){
                chromosome = sharedToolsService.parseChromosome(variantFields[0])
                Long position = 0
                try {
                    position = Long.parseLong(variantFields[1].replace(/,/, ""))
                } catch(e){
                    error = true
                }
                if (!error){
                     startOriginalExtent = position
                    endOriginalExtent = position
                    startExpandedExtent = ((position > expandBy) ?
                            (position - expandBy) : 0)
                    endExpandedExtent = position + expandBy
                    genomicPosition = true
                }
            }

        }



        // maybe the string is a range?
        if ((!gene)&&(!variant)&&(!genomicPosition)){
            // Is our string a region?
            LinkedHashMap extractedNumbers =  restServerService.extractNumbersWeNeed(originalRequest)
            if ((extractedNumbers)   &&
                    (extractedNumbers["startExtent"])   &&
                    (extractedNumbers["endExtent"])&&
                    (extractedNumbers["chromosomeNumber"]) ){
                chromosome = sharedToolsService.parseChromosome(extractedNumbers["chromosomeNumber"])
                startOriginalExtent = Long.parseLong(extractedNumbers["startExtent"].replace(/,/, ""))
                endOriginalExtent = Long.parseLong(extractedNumbers["endExtent"].replace(/,/, ""))
                startExpandedExtent = ((startOriginalExtent > expandBy) ?
                        (startOriginalExtent - expandBy) : 0)
                endExpandedExtent = endOriginalExtent + expandBy
                range = true
            } else {
                error = true
            }
        }
    }

    public static UserQueryContext parseUserQueryContext( String userInput,
                                                          RestServerService restServerService,
                                                          SharedToolsService sharedToolsService ){
        return new UserQueryContext(userInput,
                 restServerService,
                 sharedToolsService)
    }

    public Long getStartOriginalExtent(){
        return startOriginalExtent
    }
    public Long getEndOriginalExtent(){
        return endOriginalExtent
    }
    public Long getStartExpandedExtent(){
        return startExpandedExtent
    }
    public Long getEndExpandedExtent(){
        return endExpandedExtent
    }
    public String getChromosome(){
        return chromosome
    }
    public String getOriginalRequest(){
        return originalRequest
    }
    public String getInterpretedRequest(){
        return interpretedRequest ?: originalRequest
    }
    public Boolean getError(){
        return error
    }

}
