package dport


class GeneController {
    def grailsApplication
    def index() {
        def fileLocation2 = grailsApplication.mainContext.getResource("/WEB-INF/resources/genes.tsv").file.toString()
        File file = new File(fileLocation2)
        int counter = 1
        String tester = "start here"
        boolean headerLine = true
        file.eachLine {
            if (counter < 5) {
                if (headerLine){
                    headerLine = false
                }  else {
                    String rawLine = it
                    String[] columnData =  rawLine.split(",")
                    Long addrStart = Long.parseLong(columnData[3],10)
                    Long addrEnd = Long.parseLong(columnData[4],10)
                    Gene gene = new Gene (
                            name1:columnData[0],
                            name2:columnData[1],
                            chromosome:columnData[2],
                            addrStart :addrStart,
                            addrEnd:addrEnd )
                    tester += (gene.toString()+">>")

                }
            }
            counter++
        }
        render ("<html><body><h1>${tester}<h1><body></html>")
    }
}
