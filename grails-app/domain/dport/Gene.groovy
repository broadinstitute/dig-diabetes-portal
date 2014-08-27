package dport

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
}
