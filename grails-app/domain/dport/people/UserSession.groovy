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
        endSession blank: true
        remoteAddress blank: true
        dataField blank: true
    }


 }
