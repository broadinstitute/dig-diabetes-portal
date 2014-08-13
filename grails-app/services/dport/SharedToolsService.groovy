package dport

import grails.transaction.Transactional

@Transactional
class SharedToolsService {

    public String urlEncodedListOfPhenotypes() {
        List<Phenotype> phenotypeList=Phenotype.list()
        StringBuilder sb   = new StringBuilder ("")
        int numberOfPhenotypes  =  phenotypeList.size()
        int iterationCount  = 0
        for (Phenotype phenotype in phenotypeList){
            sb<< (phenotype.databaseKey + ":" + phenotype.name )
            iterationCount++
            if (iterationCount  < numberOfPhenotypes){
                sb<< ","
            }
        }
        return java.net.URLEncoder.encode( sb.toString())
    }



    public String urlEncodedListOfProteinEffect() {
        List<ProteinEffect> proteinEffectList=ProteinEffect.list()
        StringBuilder sb   = new StringBuilder ("")
        int numberOfProteinEffects  =  proteinEffectList.size()
        int iterationCount  = 0
        for (ProteinEffect proteinEffect in proteinEffectList){
            sb<< (proteinEffect.key + ":" + proteinEffect.name )
            iterationCount++
            if (iterationCount  < numberOfProteinEffects){
                sb<< "~"
            }
        }
        return java.net.URLEncoder.encode( sb.toString())
    }



}
