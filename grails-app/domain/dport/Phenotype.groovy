package dport

class Phenotype {
    String key = ''
    String name = ''
    String databaseKey = ''
    String dataSet = ''
    String category = ''

    static constraints = {
           key blank: false, unique:true
//         name blank: true
//         databaseKey blank: true
//         dataSet blank: true
//         category blank: true
    }

    static mapping = {
        key column: '`key`'
        name column: '`name`'
    }

}
