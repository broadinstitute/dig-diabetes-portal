package org.broadinstitute.mpg

class Gene {

    String name1 = ''
    String name2 = ''
    String chromosome = ''
    Long addrStart = 0l
    Long addrEnd = 0l

    static constraints = {
        name1 blank: false
        name2 blank: true
        chromosome blank: true
    }



    static Gene retrieveGene(String geneName){
        Gene gene = null
        if (geneName)   {
           List<Gene> geneList = Gene.findAllByName2Ilike(geneName)
           if (geneList?.size()>0){
               gene =  geneList.first()
           }
        }
        return gene
    }


    static Map retrieveListOfGenesInARange ( Long startPos, Long endPos,  String chrName ){
        Map returnValue = [is_error: true, error_message:"unknown error"]
        if ((chrName==null) || (!chrName.startsWith("chr"))){
            returnValue.error_message = "unexpected chromosome name = ${chrName}"
        } else if ((startPos==null)||(endPos==null)||(startPos>endPos)){
            returnValue.error_message = "start position = ${startPos} and end position =  ${startPos}"
        } else{
            returnValue.is_error = false
            List<Gene> geneList = Gene.findAll("from Gene as g where (chromosome=?) and ((g.addrStart>? and g.addrStart <?) or (g.addrEnd>? and g.addrEnd <?) or (g.addrStart<? and g.addrEnd >?))",[chrName,startPos,endPos,startPos,endPos,startPos,endPos])
            List<Map> listOfGenes = []
            for (Gene gene in geneList){
                Map oneGene = [name1:gene.name1,name2:gene.name2,chromosome:gene.chromosome,addrStart:gene.addrStart,addrEnd:gene.addrEnd,id:gene.id]
                listOfGenes << oneGene
            }
            returnValue["listOfGenes"] = listOfGenes
        }
        return returnValue
    }


    static void refresh(String geneName,String chromosome,Long  startPosition,Long  endPosition) {
        Gene gene = retrieveGene( geneName)
        if ((gene?.name2!= geneName) &&
                (gene?.chromosome != chromosome) &&
                (gene?.addrStart != startPosition) &&
                (gene?.addrEnd != endPosition) ){
            if (gene!=null)  {
                gene.delete(flush: true)
            }
            new Gene(name1:geneName,
                    name2:geneName,
                    chromosome: chromosome,
                    addrStart: startPosition,
                    addrEnd: endPosition).save()
        }
    }



    static void deleteGenesForChromosome(String chromosome) {
        List<Gene> geneList = Gene.findAllByChromosome('chr'+chromosome) //whole data set.  TODO we can remove this line once all the old data is gone
        if (geneList?. size()==0) {
            geneList = Gene.findAllByChromosome(chromosome)
        }
        for ( Gene  gene in geneList) {
            gene.delete(flush: true)
        }
     }



    static int totalNumberOfGenes() {
        return Gene.count()
    }




}
