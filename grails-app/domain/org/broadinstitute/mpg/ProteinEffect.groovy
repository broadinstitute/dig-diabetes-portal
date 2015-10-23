package org.broadinstitute.mpg

class ProteinEffect {
    String key =''
    String name =''
    String description =''

    static constraints = {
          key blank: false, unique: true
//        name blank: true
//        description blank: true
    }

    static mapping = {
        key column: '`key`'
        name column: '`name`'
    }

}
