import dport.Gene

class BootStrap {
    def grailsApplication

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

    }
    def destroy = {
    }
}
