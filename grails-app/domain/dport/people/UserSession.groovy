package dport.people

class UserSession implements Serializable {


    User user
    Date startSession = new Date()
    Date endSession
    String remoteAddress
    String dataField

    static constraints = {
        user blank: false
        startSession blank: false
        endSession nullable: true
        remoteAddress nullable: true
        dataField nullable: true
    }


 }
