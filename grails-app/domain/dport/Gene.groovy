package dport

class Gene {

    String name1 = ''
    String name2 = ''
    String chromosome = ''
    Long addrStart = 0l
    Long addrEnd = 0l

    static constraints = {
        name1 nullable: false
        name2 nullable: false
        chromosome nullable: false
        addrStart nullable: false
        addrEnd nullable: false
    }
}
