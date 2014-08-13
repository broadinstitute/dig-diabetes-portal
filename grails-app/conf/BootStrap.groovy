import dport.Gene
import dport.Phenotype
import dport.ProteinEffect
import dport.RestServerService

class BootStrap {
    def grailsApplication
    RestServerService restServerService

    def init = { servletContext ->
        // for the time being fill up our gene table locally. In the long run
        // we need to be pulling this information from the backend, of course
        if (Gene.count()) {
            println "Genes already loaded. Total operational number = ${Gene.count()}"
        } else {
            String fileLocation = grailsApplication.mainContext.getResource("/WEB-INF/resources/genes.tsv").file.toString()
            println "Actively loading genes from file = ${fileLocation}"
            File file = new File(fileLocation)
            int counter = 1
            boolean headerLine = true
            file.eachLine {
                if (headerLine){
                    headerLine = false
                }  else {
                    String rawLine = it
                    String[] columnData =  rawLine.split(",")
                    Long addrStart = Long.parseLong(columnData[3],10)
                    Long addrEnd = Long.parseLong(columnData[4],10)
                    new Gene (
                            name1:columnData[0],
                            name2:columnData[1],
                            chromosome:columnData[2],
                            addrStart :addrStart,
                            addrEnd:addrEnd ).save(failOnError: true)
                }
                counter++
            }
            println "Genes successfully loaded: ${counter}"
        }

        if (Phenotype.count()) {
            println "Phenotypes already loaded. Total operational number = ${Phenotype.count()}"
        } else {
            String fileLocation = grailsApplication.mainContext.getResource("/WEB-INF/resources/gwas_phenotypes.yaml").file.toString()
            println "Actively loading phenotypes from file = ${fileLocation}"
            File file = new File(fileLocation)
            int counter = 1
            int fieldCount = 0
            boolean headerLine = true
            String key = ''
            String name = ''
            String databaseKey = ''
            String dataSet = ''
            String category = ''
            file.eachLine {
                if (headerLine){
                    headerLine = false
                }  else {
                    String rawLine = it
                    if (rawLine.startsWith("-")) {
                        fieldCount = 0
                    }  else {
                        fieldCount++
                        String[] columnData =  rawLine.split(":")
                        if (columnData.length > 1)
                        {
                            String rawKey = columnData[0].trim()
                            String rawValue = columnData[1].trim()
                            switch (rawKey) {
                                case  "key" : key = rawValue;
                                    break;
                                case  "name" : name = rawValue;
                                    break;
                                case  "db_key" : databaseKey = rawValue;
                                    break;
                                case  "dataset" : dataSet = rawValue;
                                    break;
                                case  "category" : category = rawValue;
                                    new Phenotype (
                                            key:key,
                                            name:name,
                                            databaseKey:databaseKey,
                                            dataSet :dataSet,
                                            category:category ).save(failOnError: true)
                                    break;
                            }

                        }
                    }
                }
                counter++
            }
            println "Phenotypes successfully loaded: ${counter}"
        }


        if (ProteinEffect.count()) {
            println "ProteinEffect already loaded. Total operational number = ${ProteinEffect.count()}"
        } else {
            String fileLocation = grailsApplication.mainContext.getResource("/WEB-INF/resources/so_consequences.yaml").file.toString()
            println "Actively loading ProteinEffect from file = ${fileLocation}"
            File file = new File(fileLocation)
            int counter = 1
            int fieldCount = 0
            boolean headerLine = true
            String key = ''
            String name = ''
            String description = ''
            file.eachLine {
                if (headerLine){
                    headerLine = false
                }  else {
                    String rawLine = it
                    if (rawLine.startsWith("-")) {
                        fieldCount = 0
                    }  else {
                        fieldCount++
                        String[] columnData =  rawLine.split(":")
                        if (columnData.length > 1)
                        {
                            String rawKey = columnData[0].trim()
                            String rawValue = columnData[1].trim()
                            switch (rawKey) {
                                case  "key" : key = rawValue;
                                    break;
                                case  "name" : name = rawValue;
                                    break;
                                case  "description" : description = rawValue;
                                    new ProteinEffect (
                                            key:key,
                                            name:name,
                                            description:description ).save(failOnError: true)
                                    break;
                            }

                        }
                    }
                }
                counter++
            }
            println "ProteinEffect successfully loaded: ${counter}"
        }


        // any services that need to be initialized should be referenced here
        restServerService.initialize()

    }
    def destroy = {
    }
}
