package dport

class Phenotype {
    String key = ''
    String name = ''
    String databaseKey = ''
    String dataSet = ''
    String category = ''

    static constraints = {
         key nullable: false
         name nullable: false
         databaseKey nullable: false
         dataSet nullable: false
         category nullable: false
    }
}
