package dport

class ProteinEffect {
    String key
    String name
    String description

    static constraints = {
        key nullable: false
        name nullable: false
        description nullable: false
    }
}
