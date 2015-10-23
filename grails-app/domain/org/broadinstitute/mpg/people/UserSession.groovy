package org.broadinstitute.mpg.people

import org.broadinstitute.mpg.people.User

class UserSession implements Serializable {


    User user
    Date startSession = new Date()
    Date endSession
    String remoteAddress
    String dataField

    static constraints = {
        endSession nullable: true
        remoteAddress nullable: true
        dataField nullable: true
    }

}
