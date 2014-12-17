package dport.people

import org.apache.commons.lang.builder.HashCodeBuilder

class LoginTracking {

        User user
        Long timeOfLogin
        int accountNonExpired
        int accountNonLocked
        int credentialsNonExpired
        String remoteAddress
        String additionalNotes

        static constraints = {
            user blank: false
            timeOfLogin blank: false
            accountNonExpired blank: false
            accountNonLocked blank: false
            credentialsNonExpired blank: false
            remoteAddress blank: false
            additionalNotes blank: true
        }

        static mapping = {
            user column: '`user`'
        }
    }
