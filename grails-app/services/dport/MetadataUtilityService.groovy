package dport

import grails.transaction.Transactional
import org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean
import org.broadinstitute.mpg.diabetes.metadata.Property
import org.broadinstitute.mpg.diabetes.metadata.PropertyBean
import org.broadinstitute.mpg.diabetes.metadata.SampleGroupBean

@Transactional
class MetadataUtilityService {

    public String createPhenotypePropertyFieldRequester(List<Property>  propertyList) {
        String returnValue = ""
        if (propertyList){
            // we will mostly iterate over this parent list
            List<PropertyBean> propertyBeanList = propertyList.collect{PropertyBean pb->return pb.parent}
            // create a list of sample groups associated with our property
            List <String> sampleGroupNames =  propertyBeanList.collect{PhenotypeBean pheno->return pheno.parent}.systemId?.sort()?.unique()
            List<String> eachSampleGroupsString = []
            for (String sampleGroupName in sampleGroupNames){
                List <String> phenotypeNames = propertyBeanList.findAll{org.broadinstitute.mpg.diabetes.metadata.PhenotypeBean phenotype->return phenotype.parent.systemId==sampleGroupName}.name
                //eachSampleGroupsString [sampleGroupName] = "[${phenotypeNames.collect{return "\"$it\""}.join(",")}]"
                eachSampleGroupsString << "\"$sampleGroupName\": [${phenotypeNames.collect {return "\"$it\""}.join(",")}]"
            }
            returnValue = eachSampleGroupsString.join(",")
        }
        return returnValue
    }

    public String createSampleGroupPropertyFieldRequester(List<Property>  propertyList) {
        String returnValue = ""
        if (propertyList){
            // we will mostly iterate over this parent list
            List<PropertyBean> propertyBeanList = propertyList.collect{PropertyBean pb->return pb.parent}
            // create a list of sample groups associated with our property
            List <String> sampleGroupNames =  propertyBeanList?.systemId?.sort()?.unique()

            returnValue = sampleGroupNames.collect {return "\"$it\""}.join(",")
        }
        return returnValue
    }
}
