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
