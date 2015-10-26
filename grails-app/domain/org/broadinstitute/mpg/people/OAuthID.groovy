package org.broadinstitute.mpg.people

class OAuthID implements Serializable {

    String provider
    String accessToken

    static belongsTo = [user: User]

    static constraints = {
        accessToken unique: true
    }

    static mapping = {
        provider    index: "identity_idx"
        accessToken index: "identity_idx"
    }

}
